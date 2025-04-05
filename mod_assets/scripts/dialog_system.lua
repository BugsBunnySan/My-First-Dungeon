dialog_states = {}
dialog_offset = {}
dialog_state_machines = {}
dialog_system_clickable_ids = {}
dialog_system_clickable_npc_ids = {}
dialog_system_show_history_button_npc_ids = {}
dialog_system_history_button_ids = {}
dialog_sysyem_socket_ids = {}
dialog_button_funcs = {}
dialog_button_next_states = {}
dialog_answer_entity_ids = {}
dialog_system_history = {}

function get_dialog_clickable(npc_id)
    return findEntity(dialog_system_clickable_ids[npc_id])
end

function get_history_button(npc_id)
    return findEntity(dialog_system_history_button_ids[npc_id])
end

function get_history_npc_id(button_id)
    return dialog_system_show_history_button_npc_ids[button_id]
end

function get_dialog_socket(npc_id)
    return findEntity(dialog_system_clickable_ids[npc_id])
end

function add_npc(npc, add_connections)
    dialog_states[npc.id] = npc.state
    dialog_offset[npc.id] = npc.offset
    dialog_state_machines[npc.id] = npc.dialog
    dialog_system_clickable_ids[npc.id] = npc.clickable_id
    dialog_system_clickable_npc_ids[npc.clickable_id] = npc.id
    dialog_system_show_history_button_npc_ids[npc.history_button_id] = npc.id
    dialog_system_history_button_ids[npc.id] = npc.history_button_id
    dialog_sysyem_socket_ids[npc.id] = npc.socket_id
    dialog_answer_entity_ids[npc.id] = {}
    dialog_system_history[npc.id] = ""
    
    findEntity(npc.id).monster:setMonsterFlag("Invulnerable", true)
    set_npc_dialog_text(npc.id, false)
        
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc.id])   
    dialog_system_clickable.dialog_particles_left:stop()        
    dialog_system_clickable.dialog_particles_right:stop()
    if dialog_system_clickable.facing == 0 then        
        dialog_system_clickable.dialog_particles_left:setRotationAngles(0, 90, 0) 
        dialog_system_clickable.dialog_particles_right:setRotationAngles(0, 270, 0)
    elseif dialog_system_clickable.facing == 1 then    
        dialog_system_clickable.dialog_particles_left:setRotationAngles(0, 90, 0) 
        dialog_system_clickable.dialog_particles_right:setRotationAngles(0, 90, 0)
    elseif dialog_system_clickable.facing == 2 then        
        dialog_system_clickable.dialog_particles_left:setRotationAngles(0, 90, 0) 
        dialog_system_clickable.dialog_particles_right:setRotationAngles(0, 90, 0)
    end        
    
    if add_connections then
        local dialog_clickable = findEntity(dialog_system_clickable_ids[npc.id])
        local dialog_history_button = findEntity(npc.history_button_id)
        if dialog_clickable ~= nil then
            dialog_clickable.button:addConnector("onActivate", "dialog_system", "onClickDialog")
        end
        if dialog_history_button ~= nil then
            dialog_history_button.button:addConnector("onActivate", "dialog_system", "showDialogHistory")            
        end
    end
end

function showDialogHistory(button)
    button = global_scripts.script.getGO(button) 
    local npc_id = dialog_system_show_history_button_npc_ids[button.id]
    --print(button.id.." "..tostring(npc_id))
    button.walltext:setWallText(dialog_system_history[npc_id])
end

function add_history(npc_id, speaker_id, text)    
    dialog_system_history[npc_id] = dialog_system_history[npc_id] .. speaker_id .. ": " .. text .. "\n"
end

function component_offset(component, offset)
    local entity_offset = component:getOffset()
    entity_offset = entity_offset + offset
    component:setOffset(entity_offset)
end

function component_match_offset(component, target)
    local target_offset = target:getOffset()
    component:setOffset(target_offset)
end

function spawn_dialog_answer(npc_id, offset, answer)
    local npc = findEntity(npc_id)
    
    local dialog_pos = global_scripts.script.copy_pos(npc)
    local dialog_offset = dialog_offset[npc_id]
    if dialog_offset == "left" then
        tricksters_domain_script_entity.script.pos_strafe_left(dialog_pos)
        tricksters_domain_script_entity.script.pos_straight_ahead(dialog_pos)
    elseif dialog_offset == "right" then
        tricksters_domain_script_entity.script.pos_strafe_right(dialog_pos)
        tricksters_domain_script_entity.script.pos_straight_ahead(dialog_pos)
    end
    dialog_pos.facing = (dialog_pos.facing + 2) % 4
    local text = spawn("dialog_system_show_selectable_answer", dialog_pos.level, dialog_pos.x, dialog_pos.y, dialog_pos.facing, dialog_pos.elevation)
    component_offset(text.model, offset)
    component_offset(text.clickable, offset)
    component_offset(text.particle, offset)
    component_offset(text.light, offset)
    text.walltext:setWallText(answer)
    local button = spawn("dialog_system_answer", dialog_pos.level, dialog_pos.x, dialog_pos.y, dialog_pos.facing, dialog_pos.elevation)
    component_offset(button.model, offset)
    component_offset(button.clickable, offset)
    component_offset(button.particle, offset)
    component_offset(button.light, offset)
    button.walltext:setWallText(answer)
    
    button.button:addConnector("onActivate", "dialog_system", "onGiveDialogAnswer")
    
    return text.id, button.id
end

function cleanup_dialog_answer(npc_id)
    if dialog_answer_entity_ids[npc_id] ~= nil then
        for _, entity_id in ipairs(dialog_answer_entity_ids[npc_id]) do
            local entity = findEntity(entity_id)
            entity:destroyDelayed()
        end
        dialog_answer_entity_ids[npc_id] = {}
    end
    
    local state = dialog_states[npc_id] 
    local state_info = dialog_state_machines[npc_id][state]
    state_info.answers_spawned = false
    
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])   
    if dialog_offset[npc_id] == "left" then
        dialog_system_clickable.dialog_particles_left:stop()
    elseif dialog_offset[npc_id] == "right" then
        dialog_system_clickable.dialog_particles_right:stop()
    end
end
    
function doSpawnDialogAnswers(npc_id) 
    local state = dialog_states[npc_id] 
    local state_info = dialog_state_machines[npc_id][state]       
    local answers = dialog_state_machines[npc_id][state].answers
   
    local offset = vec(0, -0.6, 0)
    for _,answer in ipairs(answers) do
        local dialog_text_id, dialog_button_id = spawn_dialog_answer(npc_id, offset, answer.say)
        dialog_button_next_states[dialog_button_id] = {npc_id = npc_id, new_state = answer.new_state, answer=answer, text_id=dialog_text_id}
        dialog_button_funcs[dialog_button_id] = answer.func -- this one is called for the party
        table.insert(dialog_answer_entity_ids[npc_id], dialog_text_id)
        table.insert(dialog_answer_entity_ids[npc_id], dialog_button_id)
        offset.y = offset.y + 0.6
    end
end

function spawn_dialog_answers(npc_id) 

    local state = dialog_states[npc_id] 
    local state_info = dialog_state_machines[npc_id][state]
    
    local answers = state_info.answers
    if answers == nil then
        return
    end    
            
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])   
    if dialog_offset[npc_id] == "left" then
        dialog_system_clickable.dialog_particles_left:enable()
        dialog_system_clickable.dialog_particles_left:restart()
    elseif dialog_offset[npc_id] == "right" then
        dialog_system_clickable.dialog_particles_right:restart()
        dialog_system_clickable.dialog_particles_right:enable()
    end
    
    if state_info.answers_spawned ~= true then
        delayedCall("dialog_system", .5, "doSpawnDialogAnswers", npc_id) 
    end
end


function print_npc_text(npc_id, text)
    hudPrint(npc_id..": "..text)
end

function set_npc_dialog_text(npc_id, print_answer, state)
    local dialog_system_clickable_id = dialog_system_clickable_ids[npc_id]
    local dialog_system_clickable = findEntity(dialog_system_clickable_id)      
    state = state or dialog_states[npc_id] 
    
    local say_text = dialog_state_machines[npc_id][state].say  
    
    dialog_system_clickable.walltext:setWallText(say_text)
end

function changeNPCState(npc_id, new_state)
    local dialog_clickable = get_dialog_clickable(npc_id)
    cleanup_dialog_answer(npc_id)   
    dialog_states[npc_id] = new_state
    dialog_clickable.particle:restart()
    set_npc_dialog_text(npc_id, false)   
end

function dialogSystemNextState(npc_id, state_info)
    local state = dialog_states[npc_id]
    state_info = state_info or dialog_state_machines[npc_id][state]
    --print("next state for "..npc_id.." from "..dialog_states[npc_id].." to ".. state_info.new_state)
    if state_info.new_state ~= dialog_states[npc_id] then
        state_info.last_clicked = false
    end
    dialog_states[npc_id] = state_info.new_state
     
        
    
end

function onGiveDialogAnswer(button)    
    button = global_scripts.script.getGO(button) 
    local state_info = dialog_button_next_states[button.id]
    local dialog_system_offset = dialog_offset[state_info.npc_id]
    
    local text = findEntity(state_info.text_id)
    local answer_particles
    if dialog_system_offset == "left" then
        answer_particles = text:spawn("dialog_system_selected_answer_left")
    elseif dialog_system_offset == "right" then
        answer_particles = text:spawn("dialog_system_selected_answer_right")
    end
    component_match_offset(answer_particles.particle_answer, text.light)    
    answer_particles.particle_answer:enable()
    --table.insert(dialog_answer_entity_ids[state_info.npc_id], answer_particles.id)
    
    local party_say = button.walltext:getWallText()
    print_npc_text("Party", party_say)    
    add_history(state_info.npc_id, "Party", party_say)
        
    local party_func = dialog_button_funcs[button.id]
    if party_func ~= nil then
        party_func(state_info.npc_id, state_info)
    end       
    
    local npc_func = dialog_state_machines[state_info.npc_id][dialog_states[state_info.npc_id]].func
    if npc_func ~= nil then
        npc_func(state_info.npc_id, state_info)
    end
        
    cleanup_dialog_answer(state_info.npc_id) 
    dialogSystemNextState(state_info.npc_id, state_info)
end

function onClickDialog(button)
    local dialog_system_clickable = global_scripts.script.getGO(button)
    local npc_id = dialog_system_clickable_npc_ids[dialog_system_clickable.id] 
    set_npc_dialog_text(npc_id, false)     
    
    local state = dialog_states[npc_id]
    local state_info = dialog_state_machines[npc_id][state]
    
    local npc_say = dialog_state_machines[npc_id][state].say
        
    if not state_info.last_clicked == true then
        add_history(npc_id, npc_id, npc_say)
        state_info.last_clicked = true
    end
    
    print_npc_text(npc_id, npc_say)
    
    if state_info.func ~= nil then
        state_info.func(npc_id, state_info)
    end
    
    if state_info.one_time_func ~= nil and state_info.func_called == false then
        state_info.one_time_func(npc_id, state_info)
        state_info.func_called = true
    end
        
    if state_info.answers ~= nil then
        spawn_dialog_answers(npc_id)
        state_info.answers_spawned = true
    else
        dialog_system_clickable.dialog_particles_left:disable()
        dialog_system_clickable.dialog_particles_right:disable()
        dialogSystemNextState(npc_id)
    end
end