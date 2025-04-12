npc_infos = {
}

npc_targets = {   
}

npc_belongings_ids = {
}

pickup_item_callback_id = -1

function npc_check_party_pickup_item(item, data)
    item = global_scripts.script.getGO(item)
    local npc_id = npc_belongings_ids[item.id]
    if npc_id ~= nil then
        local npc = findEntity(npc_id)
        if npc ~= nil then
            if npc.brain.seesParty and npc_infos[npc_id].party_takes_item_func ~= nil then
                npc_infos[npc_id].party_takes_item_func(npc, item)
            end
        end
    end
end

function remove_npc(npc_data)
    npc_infos[npc_data.id] = nil
end

function tos(t)
    if t ~= nil and #t > 0 then
        return t[#t]
    else
        return nil
    end
end

function setLastOperated(entity)
    local npc_id = npc_targets[entity.go.id]
    print(entity.go.id.." operated by ")
    if npc_id == nil then
        return
    end
    print("    "..npc_id)
    npc_infos[npc_id].last_operated_id = entity.go.id
    --dungeon_door_wooden_6.door:toggle()
end

function add_npc_belongig(item_id, npc_id)
    npc_belongings_ids[item_id] = npc_id
end

function add_npc(npc_data)    
    print("adding npc info for "..npc_data.id)
    npc_infos[npc_data.id] = npc_data
    npc_infos[npc_data.id].root_state = {name=npc_data.idle_default, parent_state=nil, state_stack={}}
    npc_infos[npc_data.id].state = npc_infos[npc_data.id].root_state
    for _, item_id in ipairs(npc_data.belongings_ids) do
        add_npc_belongig(item_id, npc_data.id)
    end    
    last_current_states[npc_data.id] = {name="*"}
    event_queue[npc_data.id] = {}
end

function add_state(npc_id, state)
    if state.state_stack == nil then
        state.state_stack = {}
    end
    table.insert(npc_infos[npc_id].state.state_stack, state)
end

function parent_state(state)    
    --print("parent state of "..state.name)
    if state.parent_state == nil then
        --print("is root state")
        return state
    else
        --print("is "..state.parent_state.name)
        return state.parent_state
    end
end

function pop_state(npc_id, state)
    local prev_state = nil
    if #state.state_stack  > 0 then
        prev_state = table.remove(state.state_stack)
        if prev_state.on_close ~= nil then           
            local npc_info = npc_infos[npc_id]
            prev_state.on_close(npc_id, npc_info, prev_state)
        end
    end
    return prev_state
end

function push_state(npc_id, state, idx, parent_state)
    parent_state = parent_state or npc_infos[npc_id].state
    idx = idx or (#parent_state.state_stack + 1)
    
    table.insert(parent_state.state_stack, idx, state)
    state.parent_state = parent_state
end

function find_tos(npc_id, state)   
    if #state.state_stack == 0 then        
        return state
    else
        return find_tos(npc_id, tos(state.state_stack))
    end
end

function print_state(npc_id, state, level) 
    level = level or 0
    local indent = string.rep("*  ", level+1)
    print(indent..state.name)
    if #state.state_stack == 0 then
        print(indent.."---")
    else
        print_state(npc_id, tos(state.state_stack), level+1)
    end
end

function goto_next_state(npc_id, state)
    local parent_state = parent_state(state)
    if #parent_state.state_stack > 0 then -- if there's sibling states, or we're the last child, this returns the next sibling or the parent
        pop_state(npc_id, parent_state)        
    else -- there's no more child states of the parent state, so we go up another level and remove the parent_state
        local grand_parent_state = parent_state(npc_id, parent_state)
        grand_parent_state.remove_state(npc_id, parent_state) 
    end
end    

function add_child_state(parent_state, child_state, idx)
    child_state.parent_state = parent_state
    if parent_state.state_stack == nil then
        parent_state.state_stack = {}
    end
    if child_state.state_stack == nil then
        child_state.state_stack = {}
    end
    idx = idx or (#parent_state.state_stack + 1)
    table.insert(parent_state.state_stack, idx, child_state)
end

function replace_state(npc_id, state, new_state)
    local parent_state = parent_state(state)
    
    for idx=1,#parent_state.state_stack do
        if parent_state.state_stack[idx] == state then
            print("replace "..state.name.." with "..new_state.name)
            parent_state.state_stack[idx] = new_state
            new_state.parent_state = parent_state
            
            if state.on_close ~= nil then                
                local npc_info = npc_infos[npc_id]
                state.on_close(npc_id, npc_info, state)
            end
            break
        end
    end
end

function remove_state(npc_id, to_remove_state)
    local parent_state = parent_state(to_remove_state)
    local remove_idx = nil
    for idx, state in ipairs(parent_state.state_stack) do
        if state == to_remove_state then
            remove_idx = idx
            break
        end
    end
    if remove_idx ~= nil then
        table.remove(parent_state.state_stack, remove_idx)
        if to_remove_state.on_close ~= nil then
            local npc_info = npc_infos[npc_id]
            to_remove_state.on_close(npc_id, npc_info, to_remove_state)
        end
    end
end

function do_find_state(start_state, state_name)    
    local found_state = nil
    if start_state.name == state_name then
        found_state = start_state
    else
        for _, state in ipairs(start_state.state_stack) do            
            if state.name == state_name then
                found_state = state
                break
            else
                found_state = do_find_state(state, state_name)
                if found_state ~= nil then
                    break
                end
            end
        end
    end
    return found_state
end

function find_state(npc_id, state_name, start_state)
    start_state = start_state or npc_infos[npc_id].root_state 
    return do_find_state(start_state, state_name)
end


-- recalculate what state we're in

function recalculate_state(npc_id)
    --print(npc_id.." was in "..npc_infos[npc_id].state.name)
    npc_infos[npc_id].state = find_tos(npc_id, npc_infos[npc_id].root_state)
    --print(npc_id.." is now in "..npc_infos[npc_id].state.name)
end


-- event handler infrastructure
function npc_get_state_event_func(npc_id, state_name, event_name)
    print(npc_id.." look for "..state_name.." "..event_name)
    local npc_info = npc_infos[npc_id]
    local event_funcs = npc_info.state_event_funcs[state_name]
    local event_func = nil
    if event_funcs ~= nil then
        event_func = event_funcs[event_name]
    end
    return event_func
end

function do_npc_handle_event(npc_id, parent_state, callback)
    local npc_info = npc_infos[npc_id]
    local event_func
    parent_state = parent_state or npc_info.root_state
    for i=#parent_state.state_stack,1,-1 do        
        local child_state = parent_state.state_stack[i]
        
        if #child_state.state_stack > 0 then
            do_npc_handle_event(npc_id, child_state, callback)
        end
        
        event_func = npc_get_state_event_func(npc_id, child_state.name, callback.condition)
        if event_func ~= nil then
            event_func(npc_id, npc_info, child_state, callback)
        end
                
    end
end

function npc_handle_event(npc_id, parent_state, callback)
    local npc_info = npc_infos[npc_id]
    local event_func
    parent_state = parent_state or npc_info.root_state

    do_npc_handle_event(npc_id, parent_state, callback)

    event_func = npc_get_state_event_func(npc_id, parent_state.name, callback.condition)
    if event_func ~= nil then
        event_func(npc_id, npc_info, parent_state, callback)
    end
end

function all_add_event(callback)
    for npc_id, npc_info in pairs(npc_infos) do
        --print("check if "..tostring(callback.level).." matches npc's level "..tostring(npc_info.level))
        if callback.level == 0 or callback.level == npc_info.level then
            add_event(npc_id, callback)
        end
    end
end

function handle_event_time_of_day(key, callback)
    all_add_event(callback)    
end

function onAnimationEvent(animation, event_name)
    local npc_id = animation.go.id
    --print(npc_id.." "..tostring(event))
    local event_handler = npc_infos[npc_id].animation_event_handlers[event_name]
    if event_handler ~= nil then
        event_handler(npc_id, event_name)
    end
end
    

function calculate_operate(npc_brain, npc_info, state)  
    local npc_id = npc_brain.go.id
    if npc_info.last_operated_id ~= state.target_id then
        npc_brain.go.move:enable()   
        npc_brain.go.turn:enable() 
        npc_targets[state.target_id] = npc_id
        -- get the npc to face the thing their supposed to operate
        return_value = npc_brain:operate(state.target_id)         
    else
        npc_info.last_operated_id = -1
        goto_next_state(npc_id, state)
        return_value = true
    end
    
    return return_value
end

function calculate_turn_to_target(npc_brain, npc_info, state) 
    local target = findEntity(state.target_id)
    local delta_x = npc_brain.go.x - target.x
    local delta_y = npc_brain.go.y - target.y
    local turns
    
    if state.turned == false then    
        if delta_y == 0 and delta_x == 0 then -- best guess as to what direction makes sense
            npc_brain:turnTowardsDirection(target.facing)
        elseif math.abs(delta_y) > math.abs(delta_x) then
            if delta_y < 0 then -- we need to face south
                return_value = npc_brain:turnTowardsDirection(2)
            else -- we need to face north
                return_value = npc_brain:turnTowardsDirection(0)
            end
        else -- also when both are equal, just arbitrarily use x axis first...
            if delta_x < 0 then -- we need to face east
                return_value = npc_brain:turnTowardsDirection(1)
            else -- we need to face west
                return_value = npc_brain:turnTowardsDirection(3)
            end
        end
    else
        goto_next_state(npc_id, state)
        return_value = true
    end
        
    
    return return_value
end

function get_facing_from_pos(object, target)
    if object.x == target.x then
        if object.y > target.y then
            return 0
        elseif object.y < target.y then
            return 2
        end
    elseif object.y == target.y then
        if object.x > target.x then
            return 3
        elseif object.x < target.x then
            return 1
        end
    end
    return nil
end

function calculate_goto_target(npc_brain, npc_info, state)   
    local npc_id = npc_brain.go.id
    if not npc_brain:here(state.target_id) then
        npc_brain.go.move:enable()   
        npc_brain.go.turn:enable() 

        local destination = findEntity(state.target_id)
        local distance_map = get_distance_map(destination)
        local step = find_shortest_step(npc_brain.go, distance_map)
        
        local facing = get_facing_from_pos(npc_brain.go, step)
        if facing ~= nil and npc_brain.go.map:checkObstacle(npc_brain.go, facing) ~= nil then
            step = find_shortest_step(step, distance_map)
        end
        
        return_value = npc_brain:seek(step.x, step.y)         
    else        
        --print(npc_brain.go.id.." has reached their destination "..state.target_id)
        goto_next_state(npc_id, state)
        return_value = true  
    end  

    return return_value
end

function calculate_goto_xy(npc_brain, npc_info, state)   
    local npc_id = npc_brain.go.id
    --print(npc_id.." off to "..tostring(state.goto_pos.x).." "..tostring(state.goto_pos.y))
        
    if npc_brain.go.x ~= state.goto_pos.x or npc_brain.go.y ~= state.goto_pos.y then
        npc_brain.go.move:enable()   
        npc_brain.go.turn:enable() 
        
        local distance_map = get_distance_map(state.goto_pos)
        local step = find_shortest_step(npc_brain.go, distance_map)
        
        local facing = get_facing_from_pos(npc_brain.go, step)
        if facing ~= nil and npc_brain.go.map:checkObstacle(npc_brain.go, facing) ~= nil then
            step = find_shortest_step(step, distance_map)
        end
        
        return_value = npc_brain:seek(step.x, step.y)         
    else
        goto_next_state(npc_id, state)
        return_value = true
    end  
    
    return return_value
end

function calculate_put_item_in_container(npc_brain, npc_info, state)   
    local npc_id = npc_brain.go.id
    local item
    for _, inventory_item in npc_brain.go.monster:contents() do
        --print(state.item_id.." =? "..inventory_item.go.id)
        if inventory_item.go.id == state.item_id then
            item = inventory_item.go
            break
        end
    end
    
    local container = findEntity(state.container_id)
    --print("take item "..item.id)
    npc_brain.go.monster:removeItem(item.item)
    container.surface:addItem(item.item)
    goto_next_state(npc_id, state)
    return true
end

function calculate_idle_wait(npc_brain, npc_info, state)  
    npc_brain.go.move:disable() 
    --print(npc_id.." going to wait")
    --state_info.print_debug = true
    return npc_brain:wait()
end

function calculate_idle_guard(npc_brain, npc_info, state)   
    npc_brain.go.move:disable()
    --print(npc_id.." going to wait")
    --state_info.print_debug = true
    return npc_brain:wait()      
end

function calculate_idle_wander(npc_brain, npc_info, state)   
    npc_brain.go.move:enable()   
    npc_brain.go.turn:enable()
    --print(npc_id.." going to wander")
    --state_info.print_debug = true
    return npc_brain:wander()
end

default_calculate_states = {
    operate = calculate_operate,
    turn_to_target = calculate_turn_to_target,
    goto_target = calculate_goto_target,
    goto_xy = calculate_goto_xy,
    put_item_in_container = calculate_put_item_in_container,
    idle_wait = calculate_idle_wait,
    idle_guard = calculate_idle_guard,
    idle_wander = calculate_idle_wander
}

last_current_states = {}

event_queue = {}
function add_event(npc_id, event)
    table.insert(event_queue[npc_id], event)
end


function onThinkZarchtonNpc(npc_brain)
    local global_scripts = findEntity("global_scripts").script
    local npc_id = npc_brain.go.id
    local npc_info = npc_infos[npc_id]     
    
    if npc_info == nil then
        print("no info on npc "..npc_id)
        return false
    end    
   
    while #event_queue[npc_id] > 0 do
        local event = event_queue[npc_id][1]
        npc_handle_event(npc_id, npc_infos[npc_id].root_state, event)
        table.remove(event_queue[npc_id], 1)
    end
   
    recalculate_state(npc_id)        
    current_state = npc_infos[npc_id].state
   
    if last_current_states[npc_id] ~= current_state then
        print(npc_id.." onthink "..tostring(last_current_states[npc_id].name).." -> "..current_state.name)
        --print_state(npc_id, npc_infos[npc_id].root_state)
    end
    
    if npc_info.print_debug == true then
        print(npc_id.." onthink ".." "..current_state.name)
        npc_info.print_debug = false
    end
    
    
    local calculate_state_func = current_state.on_calculate or default_calculate_states[current_state.name] 
    
    local return_value
    
    if calculate_state_func ~= nil then
        return_value = calculate_state_func(npc_brain, npc_info, current_state)
    else
        return_value = true
    end
       
    if current_state.set_vars ~= nil then
        for var_name, value in pairs(current_state.set_vars) do
            print(var_name.." = "..tostring(value))
            npc_info[var_name] = value
        end
    end
    
    last_current_states[npc_id] = current_state
    
    return return_value
end

distance_maps = {}

function make_pos_key(pos)
    return string.format("%02dx%02d", pos.x, pos.y)
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
        if obstacle_type == nil or obstacle_type == "dynamic_obstacle" then -- and neighbour_pos.x == party.x and neighbour_pos.y == party.y) then    
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
        --spawn("magic_bridge", pathfinding_target.level, pos.x, pos.y, 0, 0)
        arrived = (pos.x == pathfinding_target.x and pos.y == pathfinding_target.y)
    end
end

function init()
    pickup_item_callback_id = global_scripts.script.register_party_hook("onPickUpItem", "npc_script_entity", "npc_check_party_pickup_item", data)
end