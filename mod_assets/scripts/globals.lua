champions_last_item_used = {[1] = "", [2] = "", [3] = "", [4] = ""}

-- from https://stackoverflow.com/a/16077650
function deep_copy(object, seen)
    seen = seen or {}
    
    if object == nil then 
        return nil 
    end
    
    if seen[object] then 
        return seen[object] 
    end

    local new_object
    
    if type(object) == 'table' then
        new_object = {}
        seen[object] = new_object

        --for k, v in next, object, nil do -- this causes an error in grimrock lua
        for k, v in pairs(object) do
            new_object[deep_copy(k, seen)] = deep_copy(v, seen)
        end
        
        --setmetatable(new_object, deep_copy(getmetatable(object), seen))  -- this causes an error in grimrock lua     
    else -- number, string, boolean, etc
        new_object = object
    end
    
    return new_object
end


function aim_camera(camera, target)
    local camera_w_pos = camera:getWorldPosition()
    local target_w_pos = target:getWorldPosition()
    local delta_w_pos = target_w_pos - camera_w_pos
    local dist = math.sqrt((delta_w_pos.x * delta_w_pos.x) + (delta_w_pos.y * delta_w_pos.y) + (delta_w_pos.z * delta_w_pos.z))
    local rotations = vec()
    
    rotations.x = math.asin(delta_w_pos.x / dist)
    rotations.y = math.asin(delta_w_pos.y / dist)
    rotations.z = math.asin(delta_w_pos.z / dist)
    
    rotations = (rotations / math.pi) * 180
    
    camera:setWorldRotationAngles(rotations.y, -1 * rotations.x, 0) 
end

--global timed events and time keeping
morning = 0
noon = 0.5
evening = 1
midnight = 1.5
maxtime = 1.9999 -- this then becomes morning
onehour = 1/12

time_callbacks = {}

function add_time_callback(level, time_callback)
    if time_callbacks[level] == nil then
        time_callbacks[level] = {}
    end
    print("add "..time_callback.name.." for npcs on level "..tostring(time_callback.level).." to level "..tostring(level))
    time_callbacks[level][time_callback.name] = time_callback
end

function remove_time_callback(level, name)
    time_callbacks[level][name] = nil
end

function get_time_callbacks(level)
    return time_callbacks[level]
end

timed_event_conditions = {
    dawn = false,
    noon = false,
    dusk = false,
    midnight = false
}

last_time_of_day = -1

function set_timed_event_conditions()
    local time_of_day = GameMode.getTimeOfDay()
    
    if last_time_of_day == -1 then
        last_time_of_day = time_of_day
    end

    for key, value in pairs(timed_event_conditions) do
        timed_event_conditions[key] = false
    end
    
    if last_time_of_day > time_of_day then -- rollover at 1.99999
        print("it is dawn")
        timed_event_conditions["dawn"] = true
    elseif last_time_of_day < noon and time_of_day > noon then
        print("it is noon")
        timed_event_conditions["noon"] = true
    elseif last_time_of_day < evening and time_of_day > evening then
        print("it is dusk")
        timed_event_conditions["dusk"] = true
    elseif last_time_of_day < midnight and time_of_day > midnight then
        print("it is midnight")
        timed_event_conditions["midnight"] = true
    end
    
    last_time_of_day = time_of_day
end

function check_timed_events(level)
    local level_time_callbacks = get_time_callbacks(level)
    if level_time_callbacks == nil then
        return
    end   
    
    --print("time of day "..tostring(time_of_day))
    
    local remove_callback_keys = {}
    
    for key,callback in pairs(level_time_callbacks) do
        --print(tostring(callback.check_func))        
        if callback.condition ~= nil and timed_event_conditions[callback.condition] == true then
            print("check "..callback.condition)
            if callback.enabled == true then
                if callback.level == 0 or callback.level == party.level then
                    print("calling "..key.." "..tostring(callback.level))
                    callback.func(key, callback)
                
                    if callback.oneshot == true then
                        table.insert(remove_callback_keys, key)
                    end
                end
            end
        elseif callback.check_func ~= nil and callback.check_func(key, callback, time_of_day) == true then
            if callback.enabled == true then
                --print("calling "..key)
                callback.func(key, callback)
                if callback.oneshot == true then
                    table.insert(remove_callback_keys, key)
                end
            end
        end
    end
    
    for _,key in ipairs(remove_callback_keys) do
        level_time_callbacks[key] = nil
    end
end

function check_for_not_morning(key, callback, time_of_day)    
    local pass = not check_for_morning(key, callback, time_of_day)
    return pass
end

function check_for_morning(key, callback, time_of_day)    
    local pass = false
   
    if ((time_of_day >= morning) and (time_of_day < morning + (3 * onehour))) then
        pass = true
    end
    
    return pass
end

function check_for_not_noon(key, callback, time_of_day)    
    local pass = not check_for_noon(key, callback, time_of_day)
    return pass
end

function check_for_noon(key, callback, time_of_day)    
    local pass = false
   
    if ((time_of_day >= noon) and (time_of_day < noon + onehour)) then
        pass = true
    end
    
    return pass
end


function check_for_not_evening(key, callback, time_of_day)    
    local pass = not check_for_evening(key, callback, time_of_day)
    return pass
end

function check_for_evening(key, callback, time_of_day)    
    local pass = false
   
    if ((time_of_day >= evening - onehour) and (time_of_day < evening + onehour)) then
        pass = true
    end
    
    return pass
end

function check_for_not_midnight(key, callback, time_of_day)    
    local pass = not check_for_midnight(key, callback, time_of_day)
    return pass
end

function check_for_midnight(key, callback, time_of_day)    
    local pass = false
   
    if ((time_of_day >= midnight - onehour) and (time_of_day < midnight + onehour)) then
        pass = true
    end
    
    return pass
end

function check_for_day(key, callback, time_of_day)
    return ((time_of_day > morning) and (time_of_day < evening))
end

function check_for_night(key, callback, time_of_day)
    return ((time_of_day > (evening + onehour)) and (time_of_day < (maxtime - onehour)))
end

-- global animation
animations = {}

function add_animation(level, animation)
    --hudPrint("add animation to animations for level "..tostring(level))
    
    animation.elapsed = 0
    animation.last_called = -1
    
    if animations[level] == nil then
        animations[level] = {}
    end
    
    local animation_id = math.random(500000)
    while animations[level][animation_id] ~= nil do
        animation_id = math.random(500000)
    end

    animation.id = animation_id
   
    animations[level][animation_id] = animation
    
    return animation_id
end

function get_animations(level)    
    return animations[level]
end

function remove_animation(level, animation_id)
    animations[level][animation_id] = nil
end


-- https://javascript.info/bezier-curve 
-- P = ((1−t)^3 * P1) + (3 * (1−t)^2 * t * P2) + (3 * (1−t)t^2 * P3) + (t^3 * P4)

function bezier(curve, t)
    local t_ = 1 - t
    local t_2 = t_ * t_    
    local t2 = t * t      
    
    local y = t_2 * t_ * curve.p1.y
    y = y + 3 * t_2 * t * curve.p2.y
    y = y + 3 * t_ * t2 * curve.p3.y
    y = y + t2 * t * curve.p4.y
    
    return y
end

last_tick = -1
last_time_callback_tick = -1

function handle_animation(animation, now, tick_delta)
    local done = false
    if animation.delay ~= nil then
        if animation.delay > tick_delta then
            animation.delay = animation.delay - tick_delta
            return false
        elseif animation.on_start ~= nil then
            animation.on_start(animation)
            animation.delay = nil
        end
    end
    if animation.last_called == -1 or animation.last_called > now then
        animation.last_called = now
    end  
    animation.elapsed = animation.elapsed + tick_delta        
    local time_delta = now - animation.last_called    
    if animation.duration >= 0 and animation.elapsed >= animation.duration then        
        if animation.on_finish ~= nil then
            animation.on_finish(time_delta, animation)
        end
        done = true                    
    elseif time_delta >= animation.step then
        if animation.func ~= nil then
            animation.func(time_delta, animation)
            animation.last_called = now
        end
        done = false
    end
    return done
end

function animateTick(level, now, tick_delta)  
    local animations = get_animations(level)    
    if animations == nil then
        return
    end
    for animation_id, animation in pairs(animations) do         
        local done = handle_animation(animation, now, tick_delta)
        if done then
            animations[animation_id] = nil
        end
    end    
end

function globaAnimationTick(timer)
    local now = Time.systemTime()
    if last_tick == -1 then
        last_tick = now
    end
    if last_time_callback_tick == -1 then
        last_time_callback_tick = now
    end
    local tick_delta = now - last_tick
    animateTick(0, now, tick_delta)
    -- not refreshing now / time_delta here, keeps last_tick accurate for the first animations, it 
    -- does move the extra time each animation takes into the next frame, when the
    -- timer has had a chance to be called again, but also this makes sure
    -- every animated entity is in sync, with respect to time_delta and time elapsed
    -- which seems a good thing...
    animateTick(timer.go.level, now, tick_delta)
    last_tick = now
    
    local time_callback_time_delta = now - last_time_callback_tick
    if time_callback_time_delta >= 1 then -- don't do this too often, for something that depends on time of day, every second is good
        set_timed_event_conditions()
        check_timed_events(0)
        check_timed_events(timer.go.level)
        last_time_callback_tick = now
    end
end

-- Beginning Dungeon
rubble_pedestals = {["rubble_pedestal_2"] = {["rubble"] = {"rubble_2", "rubble_1"},
                                            ["kin"] = {"rubble_pedestal_1"},
                                            ["food"] = 250,
                                            ["xp"] = 100},
                    ["rubble_pedestal_1"] = {["rubble"] = {"rubble_1", "rubble_2"},
                                            ["kin"] = {"rubble_pedestal_2"},
                                            ["food"] = 250,
                                            ["xp"] = 100},                                            
                    ["merchants_hq_rubble_pedestal_1"] = {["rubble"] = {"merchants_hq_rubble_1"},
                                            ["kin"] = {},
                                            ["food"] = 250,
                                            ["xp"] = 100},                                            
                    ["merchants_hq_rubble_pedestal_2"] = {["rubble"] = {"merchants_hq_rubble_2", "merchants_hq_rubble_3"},
                                            ["kin"] = {},
                                            ["food"] = 250,
                                            ["xp"] = 100}
                   }

function resetRubblePedestal(pedestal_id)
    local pedestal = findEntity(pedestal_id)
    pedestal.clickable:enable()
    pedestal.surface:enable()
end

function rubbleCleared(time_delta, animation) 
    GameMode.fadeIn(1, 1)
    GameMode.setEnableControls(true)
    party_consume_food({1, 2, 3, 4}, animation.food_consumed)
    party_gain_xp({1, 2, 3, 4}, animation.xp_gained)    
    --pedestal:destroyDelayed()
end

function doClearRubble(time_delta, animation)
    local pedestal = findEntity(animation.pedestal_id)
    for _, rubble_n in ipairs(rubble_pedestals[pedestal.id]["rubble"]) do
        local rubble = findEntity(rubble_n)
        rubble:destroyDelayed()
    end
    
    local item = findEntity(animation.item_id)
    local food_consumed = rubble_pedestals[pedestal.id]["food"]
    local xp_gained = rubble_pedestals[pedestal.id]["xp"]
    spawn(item.name, item.level, item.x, item.y, party.facing, item.elevation)
    item:destroyDelayed()   
    pedestal.clickable:disable()
    pedestal.surface:disable() 
    pedestal.projectilecollider:disable()
    for _, kin_id in ipairs(rubble_pedestals[pedestal.id]["kin"]) do            
        local kin = findEntity(kin_id)   
        kin.clickable:disable()
        kin.surface:disable() 
        kin.projectilecollider:disable()
        food_consumed = food_consumed + rubble_pedestals[kin_id]["food"]
        xp_gained = xp_gained + rubble_pedestals[kin_id]["xp"]
    end       
    local animation = {on_finish=rubbleCleared, step=1.2, duration=1.1, food_consumed=food_consumed, xp_gained=xp_gained}
    add_animation(0, animation)

end

function clearRubble(pedestal, item)
    pedestal = getGO(pedestal)
    item = getGO(item)
    
    if item.name ~= "pickaxe" then
        return
    end
   
    playSound("mining")
    GameMode.fadeOut(0, 1)
    GameMode.setEnableControls(false)

    local animation = {on_finish=doClearRubble, step=1.2, duration=1.1, pedestal_id=pedestal.id, item_id=item.id}
    add_animation(0, animation)
end

-- Fields Of Herbs
herbs_to_raise = .33
herbs_raise_step = 0.02

function party_consume_food(champions, amount)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:consumeFood(amount)
        end
    end
end

function party_level_up_champions(champions)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:levelUp()
        end
    end
end

function party_gain_xp(champions, amount)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:gainExp(amount)
        end
    end
end

function party_gain_energy(champions, amount)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:regainEnergy(amount)
        end
    end
end

function party_gain_health(champions, amount)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:regainHealth(amount)
        end
    end
end


function fullHealParty()
    party_gain_health({1,2,3,4}, 500)
    party_gain_energy({1,2,3,4}, 500)
end

function party_take_damage(champions, amount, damage_type)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:damage(amount, damage_type)
        end
    end
end

function party_is_weilding(item_class)
    for i = 1,4 do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            local worn_item_weapon = champion:getItem(ItemSlot.Weapon)            
            local worn_item_offhand = champion:getItem(ItemSlot.OffHand)
            if (worn_item_weapon ~= nil and worn_item_weapon.go.name == item_class) or (worn_item_offhand ~= nil and worn_item_offhand.go.name == item_class) then
                return true
            end
        end
    end
    return false
end

function party_wears_item(champions, item_slot, item_class)    
    local wearing_champions = {count = 0}
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            local worn_item = champion:getItem(item_slot)
            if worn_item ~= nil and worn_item.go.name == item_class then
                wearing_champions[i] = item
                wearing_champions.count = wearing_champions.count + 1 
            end
        end
    end
    return wearing_champions
end

function party_conditions(champions, add_conditions, remove_conditions)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            for _, condition in ipairs(add_conditions) do
                champion:setCondition(condition)
            end
            for _, condition in ipairs(remove_conditions) do
                champion:removeCondition(condition)
            end
        end
    end
end

party_hooks = {onWakeUp = {},
               onCastSpell = {},
               onPickUpItem = {}}

function register_party_hook(hook_name, script_entity_id, func_name, data)
    local hook_id = math.random(500000)
    while party_hooks[hook_name][hook_id] ~= nil do
        hook_id = math.random(500000)
    end
    party_hooks[hook_name][hook_id] = {script_entity_id=script_entity_id, func_name=func_name, data=data}
    return hook_id
end
         
function deregister_party_hook(hook_name, hook_id)
    party_hooks[hook_name][hook_id] = nil
end

function partyOnCastSpell(party, champion, spell)
    local script_entity
    
    local item_name = champions_last_item_used[champion:getOrdinal()]
                
    --print(tostring(champion).." cast "..tostring(spell).." with "..item_name)
    for k,hook in pairs(party_hooks.onCastSpell) do
        if hook.data.spell_name == spell then
            script_entity = findEntity(hook.script_entity_id)
            script_entity.script[hook.func_name](party, champion, spell, hook.data)
        end
    end
    return true
end

function partyOnPickUpItem(party, item)
    local script_entity
    local allow_pickup = true   
    for k,hook in pairs(party_hooks.onPickUpItem) do
        script_entity = findEntity(hook.script_entity_id)
        allow_pickup = script_entity.script[hook.func_name](item, hook.data)
    end
    return allow_pickup
end

function partyOnWakeUp(party)
    local script_entity
    --print("The party wakes up")
    for k,hook in pairs(party_hooks.onWakeUp) do
        script_entity = findEntity(hook.script_entity_id)
        script_entity.script[hook.func_name](hook.data)
    end
    return true
end

function objectWorldPositionOffset(object, offset)
    object = getGO(object)
    local w_pos = object:getWorldPosition()
    w_pos = w_pos + offset
    object:setWorldPosition(w_pos)
end

function faceObject(object, facing)
    object:setPosition(object.x, object.y, facing, object.elevation, object.level)
end

function matchSubtileOffset(object, target)
    local x, y = target:getSubtileOffset()
    object:setSubtileOffset(x, y)
end

function moveObjectToObject(object, target)
    object = getGO(object)
    target = getGO(target)
    object:setPosition(target.x, target.y, target.facing, target.elevation, target.level)
end

function spawnAtObject(projectile, ref_object, facing, offset_x, offset_y, offset_elevation)
    ref_object = getGO(ref_object)
    if facing == nil then
        facing = ref_object.facing
    end
    local x = ref_object.x
    local y = ref_object.y
    local elevation = ref_object.elevation
    if offset_x ~= nil then
        x = x + offset_x
    end
    if offset_y ~= nil then
        y = y + offset_y
    end
    if offset_elevation ~= nil then
        elevation = elevation + offset_elevation
    end
    return spawn(projectile, ref_object.level, x, y, facing, elevation)
end

function playSoundAtObject(sound, ref_object)
    ref_object = getGO(ref_object)
    playSoundAt(sound, ref_object.level, ref_object.x, ref_object.y)
end

function findEntities(class, level)    
    local entities = {}
    for entity in Dungeon.getMap(level):allEntities() do        
        if entity.name == class then
            table.insert(entities, entity)
        end
    end
    return entities
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function getGO(entity)
    if entity.go ~= nil then
        return entity.go
    else
        return entity
    end
end

function copy_pos(pos)
    return {x=pos.x, y=pos.y, facing=pos.facing, elevation=pos.elevation, level=pos.level}    
end

function print_pos(pos)
    print("x: "..tostring(pos.x).." y: "..tostring(pos.y).." facing: "..tostring(pos.facing).." elevation: "..tostring(pos.elevation).." level: "..tostring(pos.level))
end

north = 0
east  = 1
south = 2
west  = 3

facing_names = {[0] = "north", [1] = "east", [2] = "south", [3] = "west"}

function object_in_area(object, from_x, to_x, from_y, to_y, elevation, level)
    local in_area = true
    in_area = in_area and (object.level == level)
    in_area = in_area and ((object.x >= from_x and object.x <= to_x))
    in_area = in_area and ((object.y >= from_y and object.y <= to_y))
    in_area = in_area and (object.elevation == elevation)
    
    return in_area
end

-- return the empty facing sports on location, free of occupation
function getEmptyFacings(location, occupiers)
    local facings = {[north] = true, [east] = true, [south] = true, [west] = true}
    local empty_facings = {}
    for entity in Dungeon.getMap(location.level):entitiesAt(location.x, location.y) do                    
        if occupiers == nil or occupiers[entity.name] ~= nil then
            facings[entity.facing] = false            
        end        
    end
    for _, facing in ipairs({north, east, south, west}) do        
        if facings[facing] then
            table.insert(empty_facings, facing)
        end
    end        
    return empty_facings
end

function checkLocation(location, empty_spot)
    if location.go ~= nil then
        location = location.go
    end
    local empty_facings = getEmptyFacings(location, occupiers)        
    if #empty_facings ~= 0 then
        empty_spot.x = location.x
        empty_spot.y = location.y
        empty_spot.elevation = location.elevation
        empty_spot.level = location.level
        empty_spot.id = location.id
        empty_spot.facing = empty_facings[math.random(#empty_facings)]        
        return true
    else
        return false
    end
end

-- find a location amongst locations (must be an array), that are free of anything (occupiers == nil)
-- or free of any of the item classes listed in occupiers (which must be a table with the class names as keys)
function findEmptySpot(locations, occupiers, random)
    local empty_spot = {x = nil, y = nil, elevation = nil, level = nil, facing = nil, id = nil}    
    if not random then
        for _, location in ipairs(locations) do
            if checkLocation(location, empty_spot) == true then
                break
            end
        end
    else
        local found = false
        while not found do            
            local location_idx = math.random(#locations)
            local location = locations[location_idx]
            found = checkLocation(location, empty_spot)
        end        
    end
    return empty_spot
end

function findSpawnSpot(from_x, to_x, from_y, to_y, elevation, level, occupiers)
    local empty_spot = {x = nil, y = nil, elevation = nil, level = nil, facing = nil, id = nil}
    
    local dx = to_x - from_x
    local dy = to_y - from_y
    local x = math.random(0, dx) + from_x
    local y = math.random(0, dy) + from_y
    
    local empty = false
    
    while not empty do
        empty = true
        for entity in Dungeon.getMap(level):entitiesAt(x, y) do
            if empty and ((occupiers == nil) or (occupiers ~= nil and occupiers[entity.name] ~= nil)) then
                empty = false
                x = math.fmod((math.fmod(x-from_x+1, dx) + dx), dx) + from_x -- assure result is positive
                y = math.fmod((math.fmod(y-from_y+1, dy) + dy), dy) + from_y -- assure result is positive                       
            end
        end        
    end
        
    empty_spot = {x=x, y=y, elevation=elevation, level=level, facing=math.random(0, 3)}
    
    return empty_spot
end

function activatePortal(portal)
    hudPrint(portal.id)
    local portal = getGO(portal)
    portal.light:enable()
    portal.particle:enable()
    portal.particle2:enable()
    portal.portalBeam:enable()
    portal.planeModel:enable()
end

function deactivatePortal(portal) 
    local portal = getGO(portal)   
    portal.light:disable()
    portal.particle:disable()
    portal.particle2:disable()
    portal.portalBeam:disable()
    portal.planeModel:disable()
end