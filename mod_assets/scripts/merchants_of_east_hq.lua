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
    floor_trigger_41.floortrigger:disable()
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
    print("onFinishRaiseDesk")
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

function raiseDesk(npc_id, state_info)
    merchants_receptionist_trapdoor.pit:open()
    local animation = triels_robin_script_entitiy.script.raisePedestal("merchants_receptionist_desk", true)
    print(state_info.new_state)
    animation.work_as = state_info.new_state
    animation.on_finish=onFinishRaiseDesk
    global_scripts.script.add_animation(merchants_receptionist_desk.level, animation)
end

function onPutItem(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
    
    print(item.id)
    if item.id == "merchants_entry_scroll_pirates" or item.id == "merchants_entry_scroll_driftwood" then
        dialog_states["Merchants_Resources_Master"] = "scroll_placed"
        set_npc_dialog_text("Merchants_Resources_Master", dialog_states["Merchants_Resources_Master"], true, false)
        spawn_dialog_answers("Merchants_Resources_Master")   
    elseif item.id == "merchants_pickaxe_token" then
        
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
    global_scripts.script.playSoundAtObject("warg_attack", merchants_resource_master_dog)
end

dialog_states = {Merchants_Fisher = "init", Merchants_HQ_Receptionist = "init", Merchants_Resources_Master = "init"}
dialog_offset = {Merchants_Fisher = "left", Merchants_HQ_Receptionist = "right", Merchants_Resources_Master = "left"} 
dialog_state_machines = {Merchants_Fisher = {init = {say = "Hello, Adventurers!\nNice day for fishing, ain't it?", 
                                                   answers = {{say = "We think so, too!", new_state = "happy", func=happyParty},
                                                              {say = "We don't like fishing...", new_state = "sad"},
                                                              {say = "Wow! A monster that can talk!", new_state = "angry"}}},
                                       happy = {say = "You're nice Adventurers! Welcome to the town of Cheesefield!", func=openCheesefieldGate},
                                       sad = {say = "You make me sad!",
                                              answers = {{say = "We're sorry you're sad!", new_state = "happy"},
                                                          {say = "We don't care you're sad!", new_state = "angry"}}},
                                       angry = {say = "You anger the monster that can talk!", func=rat_attacks}},
                        Merchants_HQ_Receptionist = {init = {say = "What do you lowlifes want??",
                                                             answers = {{say = "We're looking for work.", new_state = "look_for_work_work"},
                                                                         {say = "Actually, nothing, from you. Goodday!", new_state = "init", func=leaveGame},
                                                                         {say = "We want to be pirates!", new_state = "look_for_work_pirates"}}},
                                                     look_for_work_work = {say = "Great, more wood to toss on the fire.\nTake this scroll and present\nyourself to the resources master!", new_state = "leave_me_alone", func=raiseDesk},
                                                     look_for_work_pirates = {say = "Well, great, more bodies to bury at sea.\nTake this scroll and present\nyourself to the resources master!", new_state = "leave_me_alone", func=raiseDesk},
                                                     leave_me_alone = {say = "Be off!"}},
                         Merchants_Resources_Master = {init = {say = "If you ain't got business with me, go away"},
                                                       scroll_placed = {say = "Ok, ya resources, go and do the pickaxe trial.\nReturn the token.\nDon't even think about running away with it.", 
                                                                        answers = {{say = "We're on it!", new_state="pickaxe_trial"},
                                                                                   {say = "Where's the trial?", new_state="pre_pickaxe_trial"}}},
                                                        pre_pickaxe_trial = {say = "If ya driftwood can't e'en find a pickaxe in a house, you might only be good for dog food after all.", new_state="pickaxe_trial", func=dog_growl},
                                                        pickaxe_trial = {say = "Are you still here?", func=dog_growl}}
                                                    
                       }
dialog_system_clickable_ids = {Merchants_Fisher = "dialog_system_clickable_1",
                               Merchants_HQ_Receptionist = "dialog_system_clickable_2",
                               Merchants_Resources_Master = "dialog_system_clickable_3"}
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

function component_offset(component, offset)
    local entity_offset = component:getOffset()
    entity_offset = entity_offset + offset
    component:setOffset(entity_offset)
end

function onGiveDialogAnswer(button)    
    button = global_scripts.script.getGO(button) 
    local party_say = button.walltext:getWallText()
    hudPrint("Party: "..party_say)
    
    local state_info = dialog_button_next_states[button.id]
    if state_info.new_state ~= nil then
        dialog_states[state_info.npc_id] = state_info.new_state
    end
    
    dialog_system_history[state_info.npc_id] = dialog_system_history[state_info.npc_id] .. "\n" .. "Party: " .. party_say
    
    local party_func = dialog_button_funcs[button.id]
    if party_func ~= nil then
        party_func(state_info.npc_id, state_info)
    end
    local npc_func = dialog_state_machines[state_info.npc_id][dialog_states[state_info.npc_id]].func
    if npc_func ~= nil then
        npc_func(state_info.npc_id, state_info)
    end
    set_npc_dialog_text(state_info.npc_id, dialog_states[state_info.npc_id], true, false)
    spawn_dialog_answers(state_info.npc_id)
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
    
    local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])    if dialog_offset[npc_id] == "left" then
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
    cleanup_dialog_answer(npc_id)    

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

function set_npc_dialog_text(npc_id, state, print_answer, run_func)
    local dialog_system_clickable_id = dialog_system_clickable_ids[npc_id]
    local dialog_system_clickable = findEntity(dialog_system_clickable_id)
    local say_text = dialog_state_machines[npc_id][state].say    
    if print_answer == true then
        hudPrint(npc_id..": "..dialog_state_machines[npc_id][state].say)
    end    
    if run_func == true then
        local func = dialog_state_machines[npc_id][state].func
        if func ~= nil then
            func(npc_id, state)
        end
    end
    dialog_system_history[npc_id] = dialog_system_history[npc_id] .. "\n" .. npc_id..": "..dialog_state_machines[npc_id][state].say
    
    dialog_system_clickable.walltext:setWallText(say_text)
end

function spawnMechantsReceptionistAnswers(tigger)
    spawn_dialog_answers("Merchants_HQ_Receptionist")
    floor_trigger_37.floortrigger:disable()
end

function cleanupMechantsReceptionistAnswers(tigger)
    cleanup_dialog_answer("Merchants_HQ_Receptionist")
    floor_trigger_37.floortrigger:enable()
end

function spawnTownGuardDialogAnswers(trigger)
    spawn_dialog_answers("Merchants_Fisher")
    floor_trigger_33.floortrigger:disable()
end

function cleanupTownGuardDialogAnswers(trigger)
    cleanup_dialog_answer("Merchants_Fisher")
    floor_trigger_33.floortrigger:enable()
end

function spawnMechantsResourceMasterDialogAnswers(trigger)
    spawn_dialog_answers("Merchants_Resources_Master")
    floor_trigger_36.floortrigger:disable()
end

function cleanupMechantsResourceMasterDialogAnswers(trigger)
    cleanup_dialog_answer("Merchants_Resources_Master")
    floor_trigger_36.floortrigger:enable()
end

function init_dialog_system()
    for npc_id, state in pairs(dialog_states) do
        findEntity(npc_id).monster:setMonsterFlag("Invulnerable", true)
        set_npc_dialog_text(npc_id, state, false)  
        local dialog_system_clickable = findEntity(dialog_system_clickable_ids[npc_id])   
        dialog_system_clickable.dialog_particles_left:stop()        
        dialog_system_clickable.dialog_particles_right:stop()
        if dialog_system_clickable.facing == 0 then        
            dialog_system_clickable.dialog_particles_left:setRotationAngles(0, 90, 0) 
            dialog_system_clickable.dialog_particles_right:setRotationAngles(0, 270, 0)
        elseif dialog_system_clickable.facing == 2 then        
            dialog_system_clickable.dialog_particles_left:setRotationAngles(0, 90, 0) 
            dialog_system_clickable.dialog_particles_right:setRotationAngles(0, 90, 0)
        end        
    end
end

function dialog_system(npc_id)
    local dialog_state = dialog_states[npc_id]
    local dialog_state_machine = dialog_state_machines[npc_id]
    
    
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