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

function handle_event_time_of_day(key, callback)
    all_handle_event(callback.condition)
end

function init()
    pickup_item_callback_id = global_scripts.script.register_party_hook("onPickUpItem", "npc_script_entity", "npc_check_party_pickup_item", data)
    local time_callback = {name="npc_support_dawn", condition="dawn", func=handle_event_time_of_day}
    global_scripts.script.add_time_callback(npc_script_entity.level, time_callback)
    time_callback = {name="npc_support_noon", condition="noon", func=handle_event_time_of_day}
    global_scripts.script.add_time_callback(npc_script_entity.level, time_callback)
    time_callback = {name="npc_support_dusk", condition="dusk", func=handle_event_time_of_day}
    global_scripts.script.add_time_callback(npc_script_entity.level, time_callback)
    time_callback = {name="npc_support_midnight", condition="midnight", func=handle_event_time_of_day}
    global_scripts.script.add_time_callback(npc_script_entity.level, time_callback)
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
end

function add_state(npc_id, state)
    if state.state_stack == nil then
        state.state_stack = {}
    end
    table.insert(npc_infos[npc_id].state.state_stack, state)
end

function parent_state(state)    
    print("parent state of "..state.name)
    if state.parent_state == nil then
        print("is root state")
        return state
    else
        print("is "..state.parent_state.name)
        return state.parent_state
    end
end

function pop_state(npc_id, state)
    state = state or npc_infos[npc_id].state
    local prev_state = nil
    if #state.state_stack  > 0 then
        prev_state = table.remove(state.state_stack)
        if prev_state.on_close ~= nil then
            prev_state.on_close(npc_id, prev_state)
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

function goto_next_state(npc_id)
    local parent_state = parent_state(npc_infos[npc_id].state)
    if #parent_state.state_stack > 0 then -- if there's sibling states, or we're the last child, this returns the next sibling or the parent
        pop_state(npc_id, parent_state)
        npc_infos[npc_id].state = find_tos(npc_id, parent_state)
    else -- there's no more child states of the parent state, so we go up another level and look for the tos
        local grand_parent_state = parent_state(npc_id, parent_state)
        grand_parent_state.remove_state(npc_id, parent_state) -- this recalculates the state from root_state        
    end
end    


function add_child_state(parent_state, child_state)
    child_state.parent_state = parent_state
    if parent_state.state_stack == nil then
        parent_state.state_stack = {}
    end
    if child_state.state_stack == nil then
        child_state.state_stack = {}
    end
    table.insert(parent_state.state_stack, child_state)
end

function add_state_tos(npc_id, state)
    if state.state_stack == nil then
        state.state_stack = {}
    end
    add_child_state(npc_infos[npc_id].state, state)    
    
    do_recalculate_state(npc_id, state)
end

function replace_tos(npc_id, state, up_levels)
    up_levels = up_levels or 1
    if state.state_stack == nil then
        state.state_stack = {}
    end
    
    local parent_state = npc_infos[npc_id].state
    for i=1,up_levels do
        parent_state = parent_state(parent_state)
    end
    local prev_state = pop_state(npc_id, parent_state)
    push_state(npc_id, state, nil, parent_state)
        
    do_recalculate_state(npc_id, state)
end

function insert_state(npc_id, state, idx)
    table.insert(npc_infos[npc_id].state.state_stack, idx, state)
    state.parent_state = npc_infos[npc_id].state
end

function replace_state(npc_id, state, new_state)
    local parent_state = parent_state(state)
    for idx=1,#parent_state.state_stack do
        if parent_state.state_stack[idx] == state then
            parent_state.state_stack[idx] = new_state
            new_state.parent_state = parent_state
            if state.on_close ~= nil then
                state.on_close(npc_id, state)
            end
            break
        end
    end
    recalculate_state(npc_id)
end

function do_find_state(start_state, state_name)    
    local found_state = nil
    if start_state.name == state_name then
        found_state = start_state
    else
        for _, state in ipairs(state.state_stack) do            
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

function find_state(npc_id, state_name)
    return do_find_state(npc_infos[npc_id].root_state, state_name)
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
        if remove_state.on_close ~= nil then
            remove_state.on_close(npc_id, remove_state)
        end
    end
    recalculate_state(npc_id)
end

function do_recalculate_state(npc_id, state)
   npc_infos[npc_id].state = find_tos(npc_id, state)
end

function recalculate_state(npc_id)
    do_recalculate_state(npc_id, npc_infos[npc_id].root_state)
end

function handle_event(npc_id, event, state)
    state = state or npc_infos[npc_id].state    
    local event_funcs = npc_infos[npc_id].state_event_funcs[state.name]
    local event_func
    local handled = false
    if event_funcs ~= nil then
        event_func = event_funcs[event.name]
        if event_func ~= nil then
            handled = event_func(npc_id, state, event)
        end
    end
    if handled == false and state.parent_state ~= nil then -- avoid using parent_state(state) to stop processing when reaching root_state
        handle_event(npc_id, event, state.parent_state)
    end
end

function all_handle_event(event)
    for npc_id, _ in pairs(npc_infos) do
        handle_event(npc_id, event)
    end
end

function onAnimationEvent(animation, event_name)
    local npc_id = animation.go.id
    --print(npc_id.." "..tostring(event))
    local event_handler = npc_infos[npc_id].animation_event_handlers[event_name]
    if event_handler ~= nil then
        event_handler(npc_id, event_name)
    end
end
    

function onThinkZarchtonNpc(npc_brain)
    local global_scripts = findEntity("global_scripts").script
    local npc_id = npc_brain.go.id
    local state_info = npc_infos[npc_id]     
    
    if state_info == nil then
        print("no info on npc "..npc_id)
        return false
    end    
        
    current_state = npc_infos[npc_id].state
    
    --print(npc_id.." onthink ".." "..current_state.name)
    
    if state_info.print_debug == true then
        print(npc_id.." onthink ".." "..current_state.name)
        state_info.print_debug = false
    end
    
    local return_value
    
    if current_state.name == "operate" then
        if state_info.last_operated_id ~= current_state.target_id then
            npc_targets[current_state.target_id] = npc_id
            -- get the npc to face the thing their supposed to operate
            return_value = npc_brain:operate(current_state.target_id)         
        else
            goto_next_state(npc_id)
            return_value = true
        end
    elseif current_state.name == "goto_target" then
        if npc_brain:here(current_state.target_id) then
            --print(npc_brain.go.id.." has reached their destination "..current_state.target_id)
            goto_next_state(npc_id)
            return_value = true
        else
            npc_brain.go.move:enable()   
            npc_brain.go.turn:enable() 
            return_value = npc_brain:goTo(current_state.target_id)           
        end
    elseif current_state.name == "goto_xy" then
    
        --print(npc_id.." off to "..tostring(current_state.goto_pos.x).." "..tostring(current_state.goto_pos.y))
        
        if npc_brain.go.x == current_state.goto_pos.x and npc_brain.go.y == current_state.goto_pos.y then
            goto_next_state(npc_id)
            return_value = true
        else
            npc_brain.go.move:enable()   
            npc_brain.go.turn:enable() 
            npc_brain:seek(current_state.goto_pos.x, current_state.goto_pos.y)            
            return_value = true
        end    
    elseif current_state.name == "put_item_in_container" then
        local item
        for _, inventory_item in npc_brain.go.monster:contents() do
            --print(current_state.item_id.." =? "..inventory_item.go.id)
            if inventory_item.go.id == current_state.item_id then
                item = inventory_item.go
                break
            end
        end
        
        local container = findEntity(current_state.container_id)
        --print("take item "..item.id)
        npc_brain.go.monster:removeItem(item.item)
        container.surface:addItem(item.item)
        goto_next_state(npc_id)
        return_value = true    
    elseif current_state.name == "idle_wait" then   
        npc_brain.go.move:disable() 
        print(npc_id.." going to wait")
        state_info.print_debug = true
        return_value = npc_brain:wait()
    elseif current_state.name == "idle_wander" then    
        npc_brain.go.move:enable()   
        npc_brain.go.turn:enable()
        print(npc_id.." going to wander")
        state_info.print_debug = true
        return_value = npc_brain:wander()
    elseif current_state.name == "idle_guard" then    
        npc_brain.go.move:disable()
        print(npc_id.." going to wait")
        state_info.print_debug = true
        return_value = npc_brain:wait()  
    elseif current_state.on_calculate ~= nil then
        return_value = current_state.on_calculate(npc_id, current_state)
    else
        return_value = true
    end
       
    if current_state.set_vars ~= nil then
        for var_name, value in pairs(state.set_vars) do
            print(var_name.." = "..tostring(value))
            state_info[var_name] = value
        end
    end
    
    return return_value
end