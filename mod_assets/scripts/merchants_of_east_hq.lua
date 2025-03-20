function enterLevel()
    init_dungeon.script.initParty()
    global_scripts.script.party_gain_health({1,2,3,4}, 500)
    global_scripts.script.party_gain_energy({1,2,3,4}, 500)
end

door_ids = {merchants_pickaxe_enter_floor_trigger = "merchants_hq_rubble_door_1",
            merchants_pickaxe_exit_floor_trigger = "merchants_hq_rubble_door_2"}
            
rubble_locations = {merchants_hq_rubble_spawn_location_1 = "merchants_hq_rubble_1",
                    merchants_hq_rubble_spawn_location_2 = "merchants_hq_rubble_2",
                    merchants_hq_rubble_spawn_location_3 = "merchants_hq_rubble_3"}
            
function closeDoor(trigger)
    trigger = global_scripts.script.getGO(trigger)
    local door_id = door_ids[trigger.id]
    local door = findEntity(door_id)
    door.door:close()
end

function onReturnPickaxe(alcove, item) 
    alcove = global_scripts.script.getGO(alcove)
    item = global_scripts.script.getGO(item) 
    if item.name == "pickaxe" then
        item:spawn("dispel_blast")
        item:destroyDelayed()
        local token = spawn("cannon_ball", alcove.level, 0, 0, 0, 0, "merchants_pickaxe_token")
        alcove.surface:addItem(token.item)
        
        merchants_hq_rubble_door_2.door:open()
    end
        
end

function onEnterMiningTurotial(trigger)
    trigger:disable()
    merchants_pickaxe_exit_floor_trigger.floortrigger:enable()
    closeDoor(trigger)
end

function onExitMiningTutorial(trigger)
    trigger:disable()
    for location_id, rubble_id in pairs(rubble_locations) do
        local spawn_pos = findEntity(location_id)
        spawn("dungeon_cave_in", spawn_pos.level, spawn_pos.x ,spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, rubble_id) 
        global_scripts.script.playSoundAtObject("summon_stone_attack", spawn_pos)        
    end
    global_scripts.script.resetRubblePedestal("merchants_hq_rubble_pedestal_1")
    global_scripts.script.resetRubblePedestal("merchants_hq_rubble_pedestal_2")
    closeDoor(trigger)
    local pickaxe = spawn("pickaxe")
    merchants_hq_pickaxe_dispenser.surface:addItem(pickaxe.item)
    merchants_pickaxe_enter_floor_trigger.floortrigger:enable()
end

function rat_attacks(npc_id)
    local npc = findEntity(npc_id)
    npc.brain:enable()
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])
    dialog_system_clickable.clickable:disable()
    dialog_system_clickable.model:disable()
    dialog_system_clickable.particle:disable()
    findEntity(npc_id).monster:setMonsterFlag("Invulnerable", false)
end

function openCheesefieldGate(npc_id)
    local npc = findEntity(npc_id)
    party:spawn("smoked_bass")
end

function happyParty()
    party:spawn("dispel_blast")
end

function partyLeaves()
    hudPrint("You leave.\nHaving nothing to do with the Merchants of East Company is propbably better for your health.\nYou can't help but wonder though what great adventure you've missed.")
end

function closeReceptionistPit(time_delta, animation)
    merchants_receptionist_trapdoor.pit:close()

end

function onTakeEntryScroll(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    pedestal.surface:disable()
    
    dialog_states["Merchants_HQ_Receptionist"] = "leave_me_alone"
    set_npc_dialog_text("Merchants_HQ_Receptionist", "leave_me_alone", false)
    merchants_receptionist_trapdoor.pit:open()
    local animation = triels_robin_script_entitiy.script.raisePedestal("merchants_receptionist_desk", true, -1)
    animation.on_finish=closeReceptionistPit
    global_scripts.script.add_animation(merchants_receptionist_desk.level, animation)
end

function onFinishRaiseDesk(time_delta, animation)
    print("onFinishRaiseDesk "..animation.work_as)
    local entry_scroll_id
    if animation.work_as == "look_for_work_pirates" then
        entry_scroll_id = "merchants_entry_scroll_pirates"
    elseif  animation.work_as == "look_for_work_work" then
        entry_scroll_id = "merchants_entry_scroll_driftwood"
    end
    local scroll = spawn("scroll", merchants_receptionist_desk.level, 0, 0, 0, 0, entry_scroll_id)    
    
    merchants_receptionist_pedestal.surface:addItem(scroll.item)
    merchants_hq_entry_fence.door:open()
    merchants_receptionist_trapdoor.pit:close()
    
end

function raiseDesk(npc_id, state, state_info)
    merchants_receptionist_trapdoor.pit:open()
    local animation = triels_robin_script_entitiy.script.raisePedestal("merchants_receptionist_desk", true)
    animation.work_as = state
    animation.on_finish=onFinishRaiseDesk
    global_scripts.script.add_animation(merchants_receptionist_desk.level, animation)
end

function onPutItem(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
        
    print(item.id)
    if item.id == "merchants_entry_scroll_pirates" or item.id == "merchants_entry_scroll_driftwood" then
        item:destroyDelayed()
        cleanup_dialog_answer("Merchants_Resources_Master")   
        dialog_states["Merchants_Resources_Master"] = "scroll_placed"
        set_npc_dialog_text("Merchants_Resources_Master", false)
    elseif item.id == "merchants_pickaxe_token" then
        item:destroyDelayed()
        cleanup_dialog_answer("Merchants_Resources_Master")   
        dialog_states["Merchants_Resources_Master"] = "pickaxe_trial_done"
        set_npc_dialog_text("Merchants_Resources_Master", false)
    end   
end

function waterSplash(trigger)
    trigger = global_scripts.script.getGO(trigger)
    spawn("furnace_explosion", trigger.level, trigger.x, trigger.y, trigger.facing, trigger.elevation)    
end

function reLoadCannons(time_delta, animation)
    
     for _, cannon_daemon_id in ipairs(animation.cannon_daemon_ids) do
        local cannon_daemon = findEntity(cannon_daemon_id)
        cannon_daemon.brain:performAction("manualAlert")
    end
    for _, pilot_light_id in ipairs(animation.pilot_light_ids) do
        local pilot_light = findEntity(pilot_light_id)
        pilot_light.controller:activate()
    end
end

function reenableCannonLever(time_delta, animation)
    local lever = findEntity(animation.lever_id)
    lever.lever:setState("deactivated")
    lever.clickable:enable()    
    lever.lever:enable()    

end

function doFireCannons(time_delta, animation)
    local cannon_ball_ids = {}
    local cannon_daemon_ids = {"cannon_daemon_2", "cannon_daemon_3", "cannon_daemon_4"}
    for _, cannon_daemon_id in ipairs(cannon_daemon_ids) do
        local cannon_daemon = findEntity(cannon_daemon_id)
        cannon_daemon.rangedAttack:enable()
        cannon_daemon.brain:performAction("rangedAttack")
        cannon_daemon.rangedAttack:disable()
        global_scripts.script.playSoundAtObject("cannon_shot", cannon_daemon)
        local cannon_ball = spawn("fireball_large_fadeout", cannon_daemon.level, cannon_daemon.x, cannon_daemon.y-1, cannon_daemon.facing, cannon_daemon.elevation)
        table.insert(cannon_ball_ids, cannon_ball.id)
    end
    merchants_hq_cannon_lever.animation:play("deactivate", false)
    merchants_hq_cannon_lever.lever:disable()       
    merchants_hq_cannon_lever.clickable:disable()     
    
    local pilot_light_ids = {"cannon_daemon_pilot_light_1", "cannon_daemon_pilot_light_2", "cannon_daemon_pilot_light_3",}
       
    for _, pilot_light_id in ipairs(pilot_light_ids) do
        local pilot_light = findEntity(pilot_light_id)
        pilot_light.controller:deactivate()
    end
    
    local animation = {on_finish=reLoadCannons, step=5.1, duration=5, pilot_light_ids=pilot_light_ids, cannon_daemon_ids=cannon_daemon_ids}
    global_scripts.script.add_animation(merchants_script_entity.level, animation)
    local animation = {on_finish=reenableCannonLever, step=8.1, duration=8, lever_id="merchants_hq_cannon_lever", }
    global_scripts.script.add_animation(merchants_script_entity.level, animation)
end

function fireCannons(key, callback)
    playSound("blow_horn")

    local animation = {on_finish=doFireCannons, step=1.1, duration=1}
    global_scripts.script.add_animation(merchants_script_entity.level, animation)
    
    if callback ~= nil then
        if callback.check_for == "morning" then
            callback.check_for = "noon"
            callback.check_func=global_scripts.script.check_for_noon
        elseif callback.check_for == "noon" then
            callback.check_for = "evening"
            callback.check_func=global_scripts.script.check_for_evening
        elseif callback.check_for == "evening" then
            callback.check_for = "morning"
            callback.check_func=global_scripts.script.check_for_morning
        end
    end
end

function dog_growl()
    global_scripts.script.playSoundAtObject("warg_howl", merchants_resource_master_dog)
end

function onRemoveItem(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
    if item.id == "merchants_quartermaster_token" then
        dialog_states["Merchants_Resources_Master"] = "dont_bother_me"
        set_npc_dialog_text("Merchants_Resources_Master", dialog_states["Merchants_Resources_Master"], false, false)
    end
end

function spawn_quartermaster_token()
    local token = spawn("blue_gem", merchants_resource_master_pedestal.level, 0, 0, 0, 0, "merchants_quartermaster_token")
    merchants_resource_master_pedestal.surface:addItem(token.item)
end

function countdown(time_delta, animation)
    print_npc_text("Merchants_Resources_Master", tostring(animation.counter))
    add_history("Merchants_Resources_Master", "Merchants_Resources_Master", tostring(animation.counter))
    animation.counter = animation.counter - 1
end

function doResourcesMasterBoom()
    Merchants_Resources_Master.brain:enable()
    Merchants_Resources_Master.brain:performAction("rangedAttack")
    Merchants_Resources_Master.brain:disable()
    party:spawn("cannon_ball")
end

function resources_master_boom()
    Merchants_Resources_Master.animation:play("alert", false)
    local animation = {func=countdown, on_finish=doResourcesMasterBoom, step=1, duration=3.1, counter=3}
    global_scripts.script.add_animation(Merchants_Resources_Master.level, animation)
end

merchants_npcs = {Merchants_Resources_Master = {}}

dialog_states = {Merchants_Fisher = "init", Merchants_HQ_Receptionist = "init", Merchants_Resources_Master = "init"}
dialog_offset = {Merchants_Fisher = "left", Merchants_HQ_Receptionist = "right", Merchants_Resources_Master = "left"} 
dialog_state_machines = {Merchants_Fisher = {init = {say = "Hello, Adventurers!\nNice day for fishing, ain't it?", 
                                                   answers = {{say = "We think so, too!", new_state = "happy", func=happyParty},
                                                              {say = "We don't like fishing...", new_state = "sad"},
                                                              {say = "We have no time for fishing...", new_state = "sad"}}},
                                       happy = {say = "You're nice Adventurers! Welcome to the town of Cheesefield!", one_time_func=openCheesefieldGate, func_called=false, new_state="chit_chat"},
                                       chit_chat = {say = "Hello, Adventurers!", 
                                                    answers = {{say = "Do you know where the Pickaxe Trial is?", new_state="give_directions_to_pickaxe_trial"},
                                                               {say = "Why the cannon shots?", new_state="explain_time_keeping"}}},
                                       give_directions_to_pickaxe_trial = {say = "That is between the morning and noon. I'm sure it's easy to find", new_state = "chit_chat"},
                                       explain_time_keeping = {say = "The cannon daemons fire to mark the time. Because people kept getting blown to bits, we sound a horn just before.", new_state = "chit_chat"},
                                       sad = {say = "You make me sad!",
                                              answers = {{say = "We're sorry you're sad!", new_state = "happy"},
                                                         {say = "We don't care you're sad!", new_state = "angry"}}},
                                       angry = {say = "You anger the monster that can talk!", func=rat_attacks, new_state = "angry"}},
                        Merchants_HQ_Receptionist = {init = {say = "What do you lowlifes want??",
                                                             answers = {{say = "We're looking for work.", new_state = "look_for_work_work"},
                                                                         {say = "Actually, nothing, from you. Goodday!", new_state = "init", func=leaveGame},
                                                                         {say = "We want to be pirates!", new_state = "look_for_work_pirates"}}},
                                                     look_for_work_work = {say = "Great, more wood to toss on the fire.\nTake this scroll and present\nyourself to the resources master!", new_state = "leave_me_alone", one_time_func=raiseDesk, func_called=false},
                                                     look_for_work_pirates = {say = "Well, great, more bodies to bury at sea.\nTake this scroll and present\nyourself to the resources master!", new_state = "leave_me_alone", one_time_func=raiseDesk, func_called=false},
                                                     leave_me_alone = {say = "Be off!", new_state = "leave_me_alone"}},
                         Merchants_Resources_Master = {init = {say = "If you ain't got business with me, go away", func=dog_growl, new_state="init"},
                                                       scroll_placed = {say = "Ok, ya resources, go and do the pickaxe trial.\nReturn the token.\nDon't even think about running away with it.", 
                                                                        answers = {{say = "We're on it!", new_state="pickaxe_trial"},
                                                                                   {say = "Where's the trial?", new_state="pre_pickaxe_trial"}}},
                                                        pre_pickaxe_trial = {say = "If ya driftwood can't e'en find a pickaxe in a house, you might only be good for dog food after all.", new_state="pickaxe_trial", func=dog_growl},
                                                        pickaxe_trial = {say = "Are you still here?", func=dog_growl, new_state="pickaxe_trial"},
                                                        pickaxe_trial_done = {say = "Here's my final quest: Take this to the Quater Master and don't bother me no more!", one_time_func=spawn_quartermaster_token, func_called=false, new_state="dont_bother_me"},
                                                        dont_bother_me = {say = "Me dog is hungry, ya looks like food and y're about to fail my final quest.", func=dog_growl, one_time_func=dialog_system_next_state, func_called=false, new_state="annoyed"},
                                                        annoyed = {say = "You fail the quest of Don't Bother Me No More.\nYour reward will be a cannonball.", func=resources_master_boom, new_state="annoyed"}}
                                                    
                       }
dialog_system_clickable_ids = {Merchants_Fisher = "dialog_system_clickable_1",
                               Merchants_HQ_Receptionist = "dialog_system_clickable_2",
                               Merchants_Resources_Master = "dialog_system_clickable_3"}
dialog_system_clickable_npc_ids = {dialog_system_clickable_1 = "Merchants_Fisher",
                                   dialog_system_clickable_2 = "Merchants_HQ_Receptionist",
                                   dialog_system_clickable_3 = "Merchants_Resources_Master"}
dialog_system_show_history_button_ids = {dialog_system_show_history_button_2 = "Merchants_Fisher", dialog_system_show_history_button_1 = "Merchants_HQ_Receptionist", dialog_system_show_history_button_3 = "Merchants_Resources_Master"}
dialog_button_next_states = {}
dialog_button_funcs = {}
dialog_answer_entity_ids = {Merchants_Fisher = {}, Merchants_HQ_Receptionist = {}, Merchants_Resources_Master={}}
dialog_system_history = {Merchants_Fisher = "", Merchants_HQ_Receptionist = "", Merchants_Resources_Master = ""}

function showDialogHistory(button)
    button = global_scripts.script.getGO(button) 
    local npc_id = dialog_system_show_history_button_ids[button.id]
    button.walltext:setWallText(dialog_system_history[npc_id])
end

function add_history(npc_id, speaker_id, text)    
    dialog_system_history[npc_id] = dialog_system_history[npc_id] .. "\n" .. speaker_id .. ": " .. text
end

function component_offset(component, offset)
    local entity_offset = component:getOffset()
    entity_offset = entity_offset + offset
    component:setOffset(entity_offset)
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
    button.walltext:setWallText(answer)
    
    button.button:addConnector("onActivate", "merchants_script_entity", "onGiveDialogAnswer")
    
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
    
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])   
    if dialog_offset[npc_id] == "left" then
        dialog_system_clickable.dialog_particles_left:stop()
    elseif dialog_offset[npc_id] == "right" then
        dialog_system_clickable.dialog_particles_right:stop()
    end
end
    
function doSpawnDialogAnswers(npc_id) 
    local state = dialog_states[npc_id]        
    local answers = dialog_state_machines[npc_id][state].answers
   
    local offset = vec(0, -0.6, 0)
    for _,answer in ipairs(answers) do
        local dialog_text_id, dialog_button_id = spawn_dialog_answer(npc_id, offset, answer.say)
        dialog_button_next_states[dialog_button_id] = {npc_id = npc_id, new_state = answer.new_state}
        dialog_button_funcs[dialog_button_id] = answer.func -- this one is called for the party
        table.insert(dialog_answer_entity_ids[npc_id], dialog_text_id)
        table.insert(dialog_answer_entity_ids[npc_id], dialog_button_id)
        offset.y = offset.y + 0.6
    end
end

function spawn_dialog_answers(npc_id) 

    local state = dialog_states[npc_id]        
    local answers = dialog_state_machines[npc_id][state].answers
    if answers == nil then
        return
    end
    
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])   
    if dialog_offset[npc_id] == "left" then
        dialog_system_clickable.dialog_particles_left:restart()
    elseif dialog_offset[npc_id] == "right" then
        dialog_system_clickable.dialog_particles_right:restart()
    end
    
    delayedCall("merchants_script_entity", 1, "doSpawnDialogAnswers", npc_id) 
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

function dialogSystemNextState(npc_id, state_info)
    cleanup_dialog_answer(npc_id)   
    local state = dialog_states[npc_id]
    state_info = state_info or dialog_state_machines[npc_id][state]
    print("next state for "..npc_id.." from "..dialog_states[npc_id].." to ".. state_info.new_state)
    if state_info.new_state ~= dialog_states[npc_id] then
        state_info.last_clicked = false
    end
    dialog_states[npc_id] = state_info.new_state
     
        
    
end

function onGiveDialogAnswer(button)    
    button = global_scripts.script.getGO(button) 
    local state_info = dialog_button_next_states[button.id]
    
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
        state_info.func(npc_id, state, state_info)
    end
    
    if state_info.one_time_func ~= nil and state_info.func_called == false then
        state_info.one_time_func(npc_id, state, state_info)
        state_info.func_called = true
    end
        
    if state_info.answers ~= nil then
        spawn_dialog_answers(npc_id)
    else
        dialogSystemNextState(npc_id)
    end
end

function init_dialog_system()
    for npc_id, state in pairs(dialog_states) do
        findEntity(npc_id).monster:setMonsterFlag("Invulnerable", true)
        set_npc_dialog_text(npc_id, false)
        
        local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])   
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
    end
end

merchants_marea_multiplier = 6/9
merchants_marea_height = .25
merchants_marea_ref_heights = {merchants_ocean_ref_height = 0, merchants_boat_ref_height = 0}
function merchants_set_ocean_level(time_delta, animation)    
    for _, ocean_entity_id in ipairs(animation.ocean_entity_ids) do
        local ocean_entity = findEntity(ocean_entity_id)
        local w_pos = ocean_entity:getWorldPosition()
        w_pos.y = merchants_marea_height * math.sin(animation.elapsed/2) + merchants_marea_ref_heights[ocean_entity_id]
        ocean_entity:setWorldPosition(w_pos)
    end
end

function init()    
    init_dialog_system()
    merchants_marea_ref_heights["merchants_beach_ocean"] = merchants_beach_ocean:getWorldPosition().y
    merchants_marea_ref_heights["merchants_boat_small"] = merchants_boat_small:getWorldPosition().y
    local animation = {func=merchants_set_ocean_level, step=.01, duration=-1, ocean_entity_ids={"merchants_beach_ocean", "merchants_boat_small"}}
    global_scripts.script.add_animation(merchants_beach_ocean.level, animation)
    for i = 1,9 do
        local blue_gem = spawn("blue_gem")
        merchants_token_sack_1.containeritem:addItem(blue_gem.item)
        local blue_gem = spawn("blue_gem")
        merchants_token_sack_2.containeritem:addItem(blue_gem.item)
    end
    local callback = {name="fire_cannons", check_func=global_scripts.script.check_for_morning, func=fireCannons, oneshot=false, enabled=true, check_for="morning"}
    global_scripts.script.add_time_callback(merchants_script_entity.level, callback)  
    
end