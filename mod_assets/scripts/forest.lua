pushblock_triggers = {["floor_trigger_22"] = {"pushable_block_floor_11", "pushable_block_floor_12"},
                      ["floor_trigger_23"] = {"pushable_block_floor_11", "pushable_block_floor_12", "pushable_block_floor_13"},
                      ["floor_trigger_24"] = {"pushable_block_floor_12", "pushable_block_floor_13", "pushable_block_floor_14"},
                      ["floor_trigger_25"] = {"pushable_block_floor_13", "pushable_block_floor_14", "pushable_block_floor_15"},
                      ["floor_trigger_26"] = {"pushable_block_floor_14", "pushable_block_floor_15"},
                      ["floor_trigger_27"] = {"pushable_block_floor_11", "pushable_block_floor_12"},
                      ["pushable_block_floor_trigger_1"] = {"pushable_block_floor_13"},
                      ["pushable_block_floor_trigger_2"] = {"pushable_block_floor_14"},
                      ["pushable_block_floor_trigger_3"] = {"pushable_block_floor_15"},
                      ["pushable_block_floor_trigger_4"] = {"pushable_block_floor_16"}}

pushblock_floor_triggered = {}

function finish_lite_up_pushblock_floor(time_delta, animation)
    local push_block_floor = findEntity(animation.push_block_floor)
    push_block_floor.controller:activate()
end

function lite_up_pushblock_floor(time_delta, animation)
    local brightness = (animation.elapsed / animation.duration) * animation.light_level    
    local push_block_floor = findEntity(animation.push_block_floor)
    push_block_floor.light:setBrightness(brightness)    
    if brightness >= animation.light_level / 2 then
        push_block_floor.particle:enable()
    end
end

function liteUpPushblockFloorAnimation(trigger)
    for _,pushable_block_floor_id in ipairs(pushblock_triggers[trigger.go.id]) do
        if pushblock_floor_triggered[pushable_block_floor_id] == nil then
            pushblock_floor_triggered[pushable_block_floor_id] = true
            local push_block_floor = findEntity(pushable_block_floor_id)
            trigger:disable()
            push_block_floor.light:setBrightness(0)
            push_block_floor.light:enable()
            local animation = {func=lite_up_pushblock_floor, on_finish=finish_lite_up_pushblock_floor, step=0.05, duration=2, elapsed=0, last_called=-1, push_block_floor=pushable_block_floor_id, light_level=35}
            global_scripts.script.add_animation(trigger.go.level, animation)
            global_scripts.script.playSoundAtObject("charge_up", push_block_floor)
        end
    end
end

function spawnMinePit()
    forest_heightmap_5:destroy()
    spawn("mine_pit", invisible_wall_101.level, invisible_wall_101.x, invisible_wall_101.y, invisible_wall_101.facing, invisible_wall_101.elevation)
    spawn("forest_heightmap", invisible_wall_101.level, 0, 0, 0, 0)
end

shop = {pedestal_13 = {blue_gem = {output_id = "dungeon_alcove_3", item_class = "long_sword"}}}

function onInsertItem(surface, item)
    surface = global_scripts.script.getGO(surface)
    item = global_scripts.script.getGO(item)
    local item_list = shop[surface.id][item.name]
    if item_list ~= nil then               
        local output_shelf = findEntity(item_list.output_id)
        surface:spawn("blob_blast")
        item:destroyDelayed()
        output_shelf:spawn("blob_blast")
        output_shelf.surface:addItem(spawn(item_list.item_class).item)        
    end
end

function ladderFloorTrigger(trigger)
    print("triggered")
    party:setPosition(spawn_test.x, spawn_test.y, spawn_test.facing, spawn_test.elevation, spawn_test.level)
    party.party:move(party.facing)
    --local w_pos = spawn_test:getWorldPosition()
    --party:setWorldPosition(w_pos)
    --party:setWorldPositionY(w_pos.y)
end

function printObstacles()
	local map = Dungeon.getMap(party.level)
    local pathfinding_sprite = spawn("invisible_wall", party.level, party.x, party.y, party.facing, party.elevation)
    pathfinding_sprite.obstacle:disable()
    pathfinding_sprite.projectilecollider:disable()
    
	for facing=0,3 do
		local obstacle = map:checkObstacle(pathfinding_sprite, facing)
		print(tostring(facing).." = "..tostring(obstacle))
	end
end

distance_maps = {}

function make_pos_key(pos)
    return string.format("%02dx%02d", pos.x, pos.y)
end

function next_step(npc_id, destination)

end

function put_pos_into_map(pos, map, value)
    if map[pos.x] == nil then
        map[pos.x] = {}
    end
    map[pos.x][pos.y] = value
end

function get_map_value(pos, map, default)
    local value = default
    if map[pos.x] ~= nil then
        value = map[pos.x][pos.y] or default
    end
    return value
end

function get_neighbours(level_map, pathfinding_sprite, pos, elevation, level)
    local neighbours = {}
    local neighbour_pos
    pathfinding_sprite:setPosition(pos.x, pos.y, 0, elevation, level)
    for facing=0,3 do
        local obstacle_type = level_map:checkObstacle(pathfinding_sprite, facing)
               
        if facing == 0 then
            neighbour_pos = {x = pos.x, 
                             y = pos.y - 1}
        elseif facing == 1 then
            neighbour_pos = {x = pos.x + 1, 
                             y = pos.y}
        elseif facing == 2 then
            neighbour_pos = {x = pos.x, 
                             y = pos.y + 1}
        elseif facing == 3 then
            neighbour_pos = {x = pos.x - 1, 
                             y = pos.y}
        end
        if obstacle_type == nil or (obstacle_type == "dynamic_obstacle" and neighbour_pos.x == party.x and neighbour_pos.y == party.y) then    
            table.insert(neighbours, neighbour_pos)        
        end
    end

    return neighbours
end

function do_make_distance_map(level_map, pathfinding_sprite, destination_pos)    
    local visited = {}
    local open = {destination_pos}
    local in_open = {}
    local distance_map = {}
    
    put_pos_into_map(destination_pos, distance_map, 0)
    put_pos_into_map(destination_pos, visited, true)
    
    local safety = 2000
    while #open > 0 and safety > 0 do
        safety = safety - 1
        --print(tostring(safety))
        local current_pos = open[#open]
        local current_dist = get_map_value(current_pos, distance_map)
        --print(tostring(current_pos.x).." x "..tostring(current_pos.y).." <=> "..tostring(current_dist))
        local neighbour_dist = current_dist + 1
        local neighbours = get_neighbours(level_map, pathfinding_sprite, current_pos, destination_pos.elevation, destination_pos.level)        
        for _, neighbour_pos in ipairs(neighbours) do
            --print("    already seen? "..tostring(neighbour_pos.x).." x "..tostring(neighbour_pos.y))
            if get_map_value(neighbour_pos, visited) == true then
                --print("yes")
                if neighbour_dist < get_map_value(neighbour_pos, distance_map) then
                    --
                    put_pos_into_map(neighbour_pos, distance_map, neighbour_dist)                    
                    if get_map_value(neighbour_pos, in_open) ~= true then
                        print("    put into open again "..tostring(neighbour_pos.x).." x "..tostring(neighbour_pos.y)) 
                        put_pos_into_map(neighbour_pos, in_open, true)
                        table.insert(open, 1, neighbour_pos)
                    end
                end
            else
                --print("no")
                put_pos_into_map(neighbour_pos, distance_map, neighbour_dist)                
                if get_map_value(neighbour_pos, in_open) ~= true then
                    --print("    put into open "..tostring(neighbour_pos.x).." x "..tostring(neighbour_pos.y))   
                    put_pos_into_map(neighbour_pos, in_open, true)
                    table.insert(open, 1, neighbour_pos)
                end
            end
        end        
        put_pos_into_map(current_pos, visited, true)
        --print("    renove from open "..tostring(open[#open].x).." x "..tostring(open[#open].y))
        table.remove(open, #open)
        --spawn("beach_stone_ring", destination_pos.level, current_pos.x, current_pos.y, 0, 0)
        --print("put current pos into visited and removed from open "..tostring(#open))
    end
    
    return distance_map
end

function make_distance_map(destination)
    local destination_pos = global_scripts.script.copy_pos(destination)
    local destination_key = make_pos_key(destination)
    local level_map = Dungeon.getMap(destination.level)
    
    local pathfinding_sprite = spawn("invisible_wall")
    pathfinding_sprite.obstacle:disable()
    pathfinding_sprite.projectilecollider:disable()
    
    if distance_maps[destination.level] == nil then
        distance_maps[destination.level] = {}
    end
    distance_maps[destination.level][destination_key] = do_make_distance_map(level_map, pathfinding_sprite, destination_pos)    
end

function get_distance_map(destination)
    local destination_key = make_pos_key(destination)    
    return distance_maps[destination.level][destination_key]
end

function find_shortest_step(pos, distance_map)
    local check_pos = {x=pos.x, y=pos.y}
    local dist = get_map_value(pos, distance_map, math.huge)
    
    local step = {}
    
    check_pos = {x=pos.x, y=pos.y-1}
    local check_dist = get_map_value(check_pos, distance_map, math.huge)
    if check_dist < dist then
        dist = check_dist
        step = {x=check_pos.x, y=check_pos.y}
    end
    check_pos = {x=pos.x+1, y=pos.y}
    check_dist = get_map_value(check_pos, distance_map, math.huge)
    if check_dist < dist then
        dist = check_dist
        step = {x=check_pos.x, y=check_pos.y}
    end
    check_pos = {x=pos.x, y=pos.y+1}
    check_dist = get_map_value(check_pos, distance_map, math.huge)
    if check_dist < dist then
        dist = check_dist
        step = {x=check_pos.x, y=check_pos.y}
    end
    check_pos = {x=pos.x-1, y=pos.y}
    check_dist = get_map_value(check_pos, distance_map, math.huge)
    if check_dist < dist then
        dist = check_dist
        step = {x=check_pos.x, y=check_pos.y}
    end
    
    return step
end

function debug_get_map_value(pos, map)
    print(tostring(map[pos.x][pos.y]))   
    print(tostring(pos.x).." x "..tostring(pos.y))    
    local value = nil
    if map[pos.x] ~= nil then
        value = map[pos.x][pos.y]
    end
    return value
end

function doFindPath()    
    make_distance_map(pathfinding_target)
    
    local arrived = false
    local pos = {x=party.x, y=party.y}
    local distance_map = get_distance_map(pathfinding_target) 
    local safety = 2000
    
    while not arrived and safety > 0 do
        safety = safety - 1
        local current_dist = debug_get_map_value(pos, distance_map)
        print("current "..tostring(current_dist).." from target")
        
        pos = find_shortest_step(pos, distance_map)
        spawn("magic_bridge", pathfinding_target.level, pos.x, pos.y, 0, 0)
        arrived = (pos.x == pathfinding_target.x and pos.y == pathfinding_target.y)
    end
end

function init()
    --print(tostring(math.huge))
    --spawn_test:spawn("forest_ground_01"):destroyDelayed()
   --spawn("mine_pit", spawn_test.levet, spawn_test.x, spawn_test.y, spawn_test.facing, spawn_test.elevation)    
end

morning = 0
noon = 0.5
evening = 1
midnight = 1.5
maxtime = 1.99 -- this then becomes morning
onehour = 0.0833333

time_of_day = GameMode.getTimeOfDay()--1.5
keep_time_of_day = true

step = 0.05
tick = 0.1

time_control_levers = {"beach_lever_1", "beach_lever_2", "beach_lever_3", "beach_lever_4"}

function enable_buttons()
    for _, lever_id in ipairs(time_control_levers) do
        local lever = findEntity(lever_id)
        if lever.lever:isActivated() then
            lever.lever:setState("deactivated")
            global_scripts.script.playSoundAtObject("lever", lever)
        end
        lever.clickable:enable()
        lever.lever:enable()
    end
end

function disable_buttons()
    for _, lever_id in ipairs(time_control_levers) do
        local lever = findEntity(lever_id)
        lever.clickable:disable()
        lever.lever:disable()
    end
end

function keepTOD()
    if keep_time_of_day then
        GameMode.setTimeOfDay(time_of_day)
    end
end

function moveTOD(time_delta, animation)
    local now = GameMode.getTimeOfDay()
    local set_time = now + (tick * (time_delta))
    GameMode.setTimeOfDay(set_time)
end

function setTOD(time_delta, animation)
    GameMode.setTimeOfDay(animation.targetTime)
    time_of_day = GameMode.getTimeOfDay()
    keep_time_of_day = true
    enable_buttons()
end

function goTilMorning()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now ~= morning then
        duration = (maxtime - now) / tick-- rollover is at morning
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=maxtime, tick=tick}
    global_scripts.script.add_animation(forest_script_entity.level, animation)
end

function goTilNoon()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now >= noon then
        duration = ((maxtime - now) + noon) / tick
    elseif now <= noon then
        duration = (noon - now) / tick
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=noon, tick=tick}
    global_scripts.script.add_animation(forest_script_entity.level, animation)
end

function goTilEvening()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now >= evening then
        duration = ((maxtime - now) + evening) / tick
    elseif now <= evening then
        duration = (evening - now) / tick
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=evening, tick=tick}
    global_scripts.script.add_animation(forest_script_entity.level, animation)
end

function goTilMidnight()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now >= midnight then
        duration = ((maxtime - now) + midnight) / tick
    elseif now <= midnight then
        duration = (midnight - now) / tick
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=midnight, tick=tick}
    global_scripts.script.add_animation(forest_script_entity.level, animation)
end