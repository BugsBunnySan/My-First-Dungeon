npc_states = {
}

npc_targets = {   
}

function add_npc(npc_data)
    npc_states[npc_data.id] = npc_data
end

function setLastOperated(entity)
    local npc_id = npc_targets[entity.go.id]
    print(entity.go.id.." operated by ")
    if npc_id == nil then
        return
    end
    print("    "..npc_id)
    npc_states[npc_id].last_operated_id = entity.go.id
    --dungeon_door_wooden_6.door:toggle()
end

function onThinkZarchtonNpc(zarchton_brain)
    local global_scripts = findEntity("global_scripts").script
    local state_info = npc_states[zarchton_brain.go.id]
    
    if state_info == nil then
        return true
    end
    
    local time_of_day = GameMode.getTimeOfDay()
    
    if global_scripts.check_for_night(nil, nil, time_of_day) then
        if state_info.state ~= "sleep" and state_info.state ~= "do_operate" and state_info.state ~= "operate" then
            state_info.state = "goto_target"
            state_info.goto.target_id = state_info.home_id
            state_info.goto.next_state = {state = "operate", target_id = state_info.home_door_lever_id, new_state = {state = "sleep"}}
        end
    else    
        zarchton_brain.go.move:enable()
        zarchton_brain.go.turn:enable()
        state_info.state = state_info.idle_default
    end
    
    if state_info.state == "operate" then
        zarchton_brain.go.move:enable()
        print(zarchton_brain.go.id.." going to operate "..state_info.goto.target_id)
        if state_info.last_operated_id == state_info.goto.target_id then 
            print("done, going to sleep")
            state_info.state = "sleep"
            return true
         end
        npc_targets[state_info.goto.target_id] = zarchton_brain.go.id
        state_info.state = "operate"
        return zarchton_brain:operate(state_info.goto.target_id) 
    elseif state_info.state == "goto_target" then
      
        zarchton_brain.go.move:enable()
        if zarchton_brain:here(state_info.goto.target_id) then
            print(zarchton_brain.go.id.." has reached their destination "..state_info.goto.target_id)
            state_info.state = state_info.goto.next_state.state
            state_info.goto.target_id = state_info.goto.next_state.target_id
            state_info.goto.next_state = state_info.goto.next_state.new_state
            return true
        else
            return zarchton_brain:goTo(state_info.goto.target_id)
        end
    elseif state_info.state == "goto_xy" then
    
        zarchton_brain.go.move:enable()
        if zarchton_brain.go.x == state_info.goto.x and zarchton_brain.go.y == state_info.goto.y then
            state_info.state = state_info.idle_default
            return true
        else
            return zarchton_brain:seek(state_info.goto.x, state_info.goto.y)
        end
    elseif state_info.state == "idle_wait" then
        return zarchton_brain:wait()
    elseif state_info.state == "idle_wander" then
        return zarchton_brain:wander()
    elseif state_info.state == "idle_guard" then    
        zarchton_brain.go.move:disable()
        zarchton_brain.go.basicAttack:disable()
        zarchton_brain.go.leapAttack:disable()
        return zarchton_brain:wait()    
    elseif state_info.state == "sleep" then
        --print(zarchton_brain.go.id.." should be sleeping ")
        zarchton_brain.go.move:disable()
        zarchton_brain.go.turn:disable()
        return true
    elseif state_info.state == "aggressive" then
        zarchton_brain.go.basicAttack:enable()
        zarchton_brain.go.leapAttack:enable()
        return false -- default brain takes over
    else
        return true
    end
end