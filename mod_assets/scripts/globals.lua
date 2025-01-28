
-- global animation
animations = {}

function add_animation(level, animation)
    --hudPrint("add animation to animations for level "..tostring(level))
    if animations[level] == nil then
        animations[level] = {animation}
    else
        animation.elapsed = 0
        animation.last_called = -1
        table.insert(animations[level], animation)
    end
end

function get_animations(level)
    return animations[level]
end

last_tick = -1

function animateTick(level)
    local animations = get_animations(level)
    if animations == nil then
        return
    end
    local now = Time.systemTime()
    if last_tick == -1 then
        last_tick = now
    end
    local tick_delta = now - last_tick
    for idx, animation in ipairs(animations) do        
        if animation.last_called == -1 or animation.last_called > now then
            animation.last_called = now
        end                
        animation.elapsed = animation.elapsed + tick_delta        
        local time_delta = now - animation.last_called    
        if animation.elapsed >= animation.duration then        
            if animation.on_finish ~= nil then
                animation.on_finish(time_delta, animation)
            end
            table.remove(animations, idx)                          
        elseif time_delta >= animation.step then
            if animation.func ~= nil then
                animation.func(time_delta, animation)
                animation.last_called = now
            end
        end                
    end
    last_tick = now
end

function globaAnimationTick(timer)
    animateTick(0)
    animateTick(timer.go.level)
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

function getGO(entity)
    if entity.go ~= nil then
        return entity.go
    else
        return entity
    end
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