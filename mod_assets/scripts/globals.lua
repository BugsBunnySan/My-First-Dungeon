
-- global animation
animations = {}

function add_animation(level, animation)
    --hudPrint("add animation to animations for level "..tostring(level))
    
    animation.elapsed = 0
    animation.last_called = -1
    if animations[level] == nil then
        animations[level] = {animation}
    else
        table.insert(animations[level], animation)
    end
end

function get_animations(level)
    return animations[level]
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

function handle_animation(animation, now, tick_delta)
    local done = false
    if animation.delay ~= nil then
        if animation.delay > tick_delta then
            animation.delay = animation.delay - tick_delta
            return false
        else
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
    for idx, animation in ipairs(animations) do         
        local done = handle_animation(animation, now, tick_delta)
        if done then
            table.remove(animations, idx)
        end
    end
end

function globaAnimationTick(timer)
    local now = Time.systemTime()
    if last_tick == -1 then
        last_tick = now
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
end

-- Beginning Dungeon
rubble_pedestals = {["rubble_pedestal_2"] = {["rubble"] = {"rubble_2"},
                                            ["kin"] = {"rubble_pedestal_1"},
                                            ["food"] = 250,
                                            ["xp"] = 100},
                    ["rubble_pedestal_1"] = {["rubble"] = {"rubble_1"},
                                            ["kin"] = {"rubble_pedestal_2"},
                                            ["food"] = 250,
                                            ["xp"] = 100}
                   }

function clearRubble(pedestal, item)
    if item ~= nil and item.go.name ~= "pickaxe" then
        return
    end
    pedestal = getGO(pedestal)
    for _, rubble_n in ipairs(rubble_pedestals[pedestal.id]["rubble"]) do
        local rubble = findEntity(rubble_n)
        playSound("mining")
        rubble:destroyDelayed()
    end
    if item ~= nil then
        spawn(item.go.name, item.go.level, item.go.x, item.go.y, item.go.facing, item.go.elevation)
        item.go:destroyDelayed()        
        for _, kin_n in ipairs(rubble_pedestals[pedestal.id]["kin"]) do            
            local kin = findEntity(kin_n)            
            clearRubble(kin, nil)
        end
    end
    party_consume_food({1, 2, 3, 4}, rubble_pedestals[pedestal.id]["food"])
    party_gain_xp({1, 2, 3, 4}, rubble_pedestals[pedestal.id]["xp"])    
    pedestal:destroyDelayed()
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
               onCastSpell = {}}

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
    --print(tostring(champion).." cast "..tostring(spell))
    for k,hook in pairs(party_hooks.onCastSpell) do
        if hook.data.spell_name == spell then
            script_entity = findEntity(hook.script_entity_id)
            script_entity.script[hook.func_name](party, champion, spell, hook.data)
        end
    end
    return true
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

function faceObject(object, facing)
    object:setPosition(object.x, object.y, facing, object.elevation, object.level)
end

function moveObjectToObject(object, target)
    local object = getGO(object)
    local target = getGO(target)
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

-- find a location amongst locations (must be an array), that are free of anything (occupiers == nil)
-- or free of any of the item classes listed in occupiers (which must be a table with the class names as keys)
function findEmptySpot(locations, occupiers)
    local empty_spot = {x = nil, y = nil, elevation = nil, level = nil, facing = nil, id = nil}
    for _, location in ipairs(locations) do
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
            break
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
            if empty and (occupiers ~= nil and occupiers[entity.name] ~= nil) then
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