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

function close_trapdoor(time_delta, animation)    
    local trapdoor = findEntity(animation.trapdoor_id)
    trapdoor.pit:close()    
end

function lower_guard_platform(time_delta, animation)    
    local run_animation = triels_robin_script_entitiy.script.raisePedestal(animation.platform_id, true, -1)   
    run_animation.trapdoor_id = animation.trapdoor_id
    --run_animation.on_finish = close_trapdoor   
    close_trapdoor(time_delta, animation) 
    
    global_scripts.script.add_animation(merchants_script_entity.level, run_animation)
end

function activate_guard(time_delta, animation)
    local guard = findEntity(animation.guard_id)
    guard:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    guard.brain:enable()
    if guard.alert ~= nil then
        guard.alert:enable()
    end
end

raise_monster_infos = {merchants_hq_guard_1 = {platform_id = "merchants_hq_guard_platform_1", trapdoor_id = "merchants_hq_trapdoor_1"},
                    merchants_hq_guard_2 = {platform_id = "merchants_hq_guard_platform_2", trapdoor_id = "merchants_hq_trapdoor_2"},
                    merchants_hq_guard_3 = {platform_id = "merchants_hq_guard_platform_3", trapdoor_id = "merchants_hq_trapdoor_3"},
                    merchants_hq_guard_4 = {platform_id = "merchants_hq_guard_platform_4", trapdoor_id = "merchants_hq_trapdoor_4"},
                    merchants_hq_guard_5 = {platform_id = "merchants_hq_guard_platform_5", trapdoor_id = "merchants_hq_trapdoor_5"},
                    herder_small_2 = {platform_id = "merchants_combat_1_platform", trapdoor_id = "merchants_combat_1_trapdoor"},
                    twigroot_1 = {platform_id = "merchants_combat_4_platform", trapdoor_id = "merchants_combat_4_trapdoor"},
                    herder_small_1 = {platform_id = "merchants_combat_3_platform", trapdoor_id = "merchants_combat_3_trapdoor"},
                    twigroot_2 = {platform_id = "merchants_combat_2_platform", trapdoor_id = "merchants_combat_2_trapdoor"}}
                    
function raiseMonster(monster_id, animations)
    local animation
    
    animations[monster_id] = {}
    
    local raise_monster_info = raise_monster_infos[monster_id]
    
    animation = triels_robin_script_entitiy.script.raisePedestal(raise_monster_info.platform_id, true)
    animation.platform_id = raise_monster_info.platform_id
    animation.trapdoor_id = raise_monster_info.trapdoor_id
    animation.on_finish = lower_guard_platform 
    animations[monster_id]["move_platform"] = animation
    
    animation = triels_robin_script_entitiy.script.raisePedestal(monster_id, true)
    animation.guard_id = monster_id
    animation.on_finish = activate_guard
    animations[monster_id]["move_monster"] = animation
    
    local trapdoor = findEntity(raise_monster_info.trapdoor_id)
    trapdoor.pit:open()
end

function raiseGuards()    
    local animations = {}
    
    for _, monster_id in ipairs({"merchants_hq_guard_1", "merchants_hq_guard_2", "merchants_hq_guard_3", "merchants_hq_guard_4", "merchants_hq_guard_5"}) do
        raiseMonster(monster_id, animations)
    end      
    
    for monster_id, monster_animations in pairs(animations) do
        for _, animation in pairs(monster_animations) do
            global_scripts.script.add_animation(merchants_script_entity.level, animation)
        end
    end
end

function finishCombatTrial()
    combat_trial_boss_fight.bossfight:deactivate()
    spawn("cannon_ball", party.level, party.x, party.y, party.facing, party.elevation, "merchants_resource_master_combat_token")
    cemetery_fence_01_sl_1.door:open()
end

combat_trial_first = "herder_small_2"
combat_trial_order = {herder_small_2 = "twigroot_1",
                      twigroot_1 = "herder_small_1",
                      herder_small_1 = "twigroot_2",
                      twigroot_2 = ""}
combat_trial_doors = {herder_small_2 = "mine_door_spear_7",
                      twigroot_1 = "mine_door_spear_10",
                      herder_small_1 = "mine_door_spear_8",
                      twigroot_2 = "mine_door_spear_9"}

function onFinishMoveCombatMonster(time_delta, animation)
    activate_guard(time_delta, animation)
    local door = findEntity(animation.door_id)
    door.door:open()
end

function nextInCombatTrail(monster)
    monster = global_scripts.script.getGO(monster)
    local next_monster_id = combat_trial_order[monster.id]    
    if next_monster_id ~= "" then
        local animations = {}
        raiseMonster(next_monster_id, animations)
        animations[next_monster_id]["move_monster"].door_id = combat_trial_doors[next_monster_id]
        animations[next_monster_id]["move_monster"].on_finish = onFinishMoveCombatMonster
        for _, animation in pairs(animations[next_monster_id]) do
            global_scripts.script.add_animation(merchants_script_entity.level, animation)
        end 
    end
end

function startCombatTrial()
    cemetery_fence_01_sl_1.door:close()
    local monster
    for monster_id,_ in pairs(combat_trial_order) do
        monster = findEntity(monster_id)
        combat_trial_boss_fight.bossfight:addMonster(monster.monster)        
    end
    
    combat_trial_boss_fight.bossfight:activate()
    
    local animations = {}
       
    raiseMonster(combat_trial_first, animations) 
    animations[combat_trial_first]["move_monster"].door_id = combat_trial_doors[combat_trial_first]
    animations[combat_trial_first]["move_monster"].on_finish = onFinishMoveCombatMonster  
    
    for _, animation in pairs(animations[combat_trial_first]) do
        global_scripts.script.add_animation(merchants_script_entity.level, animation)
    end
end

function openCheesefieldGate(npc_id)
    local npc = findEntity(npc_id)
    party:spawn("smoked_bass")
    party:spawn("smoked_bass")
    party:spawn("smoked_bass")
    party:spawn("smoked_bass")
end

function happyParty()
    --party:spawn("dispel_blast")
end

function leaveGame()
    hudPrint("You leave.\nHaving nothing to do with the Merchants of East Company is propbably better for your health.\nYou can't help but wonder though, what great adventure you've missed.")
end

function closeReceptionistPit(time_delta, animation)
    merchants_receptionist_trapdoor.pit:close()
    
    merchants_hq_entry_fence.door:open()

end

function onTakeEntryScroll(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
        
    if pedestal.surface:count() ~= 0 then
        dialog_system.script.changeNPCState("Merchants_HQ_Receptionist", "take_your_things") 
        return
    else
        dialog_system.script.changeNPCState("Merchants_HQ_Receptionist", "leave_me_alone") 
    end
    
    pedestal.surface:disable()
    

    merchants_receptionist_trapdoor.pit:open()
    local animation = triels_robin_script_entitiy.script.raisePedestal("merchants_receptionist_desk", true, -1)
    animation.on_finish=closeReceptionistPit
    global_scripts.script.add_animation(merchants_receptionist_desk.level, animation)
end

function onFinishRaiseDesk(time_delta, animation)
    --print("onFinishRaiseDesk "..animation.work_as)
    local entry_scroll_id
    if animation.work_as == "look_for_work_pirates" then
        entry_scroll_id = "merchants_entry_scroll_pirates"
    elseif  animation.work_as == "look_for_work_work" then
        entry_scroll_id = "merchants_entry_scroll_driftwood"
    end
    local scroll = spawn("scroll", merchants_receptionist_desk.level, 0, 0, 0, 0, entry_scroll_id)    
    
    merchants_receptionist_pedestal.surface:addItem(scroll.item)
    merchants_receptionist_trapdoor.pit:close()
    
    if merchants_npcs["Merchants_HQ_Receptionist"]["handed_in_free_lunch_ticket"] == true then
        for i=1,4 do
            local food = spawn("cheese")
            merchants_receptionist_pedestal.surface:addItem(food.item)
        end
    end
    
end

function raiseDesk(npc_id, state_info)
    merchants_receptionist_trapdoor.pit:open()
    local animation = triels_robin_script_entitiy.script.raisePedestal("merchants_receptionist_desk", true)
    animation.work_as = dialog_system.script.dialog_states[npc_id]
    animation.on_finish=onFinishRaiseDesk
    global_scripts.script.add_animation(merchants_receptionist_desk.level, animation)
end

function onRemoveItem(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
    if pedestal.id == "merchants_resource_master_socket" then
        if item.id == "merchants_quartermaster_token" then
            dialog_system.script.dialog_states["Merchants_Resources_Master"] = "dont_bother_me"
            dialog_system.script.set_npc_dialog_text("Merchants_Resources_Master", false)
        end
    elseif pedestal.id == "merchants_quarter_master_socket" then
        if item.id == "merchants_travel_pass_hunt_beasts" then
            dialog_system.script.changeNPCState("Merchants_Quarter_Master", "wait_for_trophies")
        end
    end
end



function onPutItem(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
            
    --print(item.id)
    if pedestal.id == "merchants_resource_master_socket" then                
        if item.id == "merchants_entry_scroll_pirates" or item.id == "merchants_entry_scroll_driftwood" then
            item:destroyDelayed()
            dialog_system.script.changeNPCState("Merchants_Resources_Master", "scroll_placed")
        elseif item.id == "merchants_pickaxe_token" then
            item:destroyDelayed()
            dialog_system.script.changeNPCState("Merchants_Resources_Master", "pickaxe_trial_done")
        elseif item.id == "merchants_resource_master_combat_token" then
            item:destroyDelayed()
            dialog_system.script.changeNPCState("Merchants_Resources_Master", "combat_trial_done")
        end   
    elseif pedestal.id == "merchants_quarter_master_socket" then 
        if item.id == "merchants_quartermaster_token" then
            item:destroyDelayed()
            dialog_system.script.changeNPCState("Merchants_Quarter_Master", "token_given")
        elseif item.id == "merchants_token_sack_1" then
            beacon_furnace_5.surface:addItem(item.item)
            castle_door_portcullis_keep_pillars_1.door:close()  
            dialog_system.script.changeNPCState("Merchants_Quarter_Master", "give_hunting_island_pass") 
        end
    elseif pedestal.id == "merchants_captain_socket" then    
        if item.id == "merchants_travel_pass_hunt_beasts" then
            item:destroyDelayed()
            dialog_system.script.cleanup_dialog_answer("Merchants_Captain")   
            table.insert(dialog_system.script.dialog_state_machines["Merchants_Captain"]["ready_to_travel"].answers, 
                        {say = "We wan't to go to the beast hunting island.", func=set_captain_target, target="hunting_island", new_state = "off_we_go"})
        elseif item.id == "merchants_travel_pass_island" then
            item:destroyDelayed()
            dialog_system.script.cleanup_dialog_answer("Merchants_Captain")   
            table.insert(dialog_system.script.dialog_state_machines["Merchants_Captain"]["ready_to_travel"].answers, 
                        {say = "We're off to follow Malek's squad.", func=set_captain_target, target="beginning_beach", new_state = "off_we_go"})                
        end
    elseif pedestal.id == "merchants_receptionist_socket" then
        if item.id == "merchants_recruiter_free_lunch_ticket" then
            item:destroyDelayed()             
            merchants_npcs["Merchants_HQ_Receptionist"]["handed_in_free_lunch_ticket"] = true
            local dialog_state =  dialog_system.script.dialog_states["Merchants_HQ_Receptionist"]
            dialog_system.script.dialog_state_machines["Merchants_HQ_Receptionist"]["handed_in_free_lunch_ticket"].new_state = dialog_state 
            dialog_system.script.changeNPCState("Merchants_HQ_Receptionist", "handed_in_free_lunch_ticket") 
        end
    elseif pedestal.id == "merchants_fisher_socket" then
        if item.id == "letter_from_merchants_fisher" then
            merchants_npcs["Merchants_Fisher"].letter_given = true
            item:destroyDelayed()  
            local dialog_state =  dialog_system.script.dialog_states["Merchants_Fisher"]
            dialog_system.script.dialog_state_machines["Merchants_Fisher"]["letter_given"].new_state = dialog_state
            dialog_system.script.changeNPCState("Merchants_Fisher", "letter_given")
            
        elseif item.id == "fishers_ice_guardian" then
            if merchants_npcs["Merchants_Fisher"].letter_given == true then
                merchants_npcs["Merchants_Fisher"].figurine_given = true
                item:destroyDelayed()  
                local dialog_state =  dialog_system.script.dialog_states["Merchants_Fisher"]
                dialog_system.script.dialog_state_machines["Merchants_Fisher"]["figurine_given"].new_state = dialog_state
                dialog_system.script.changeNPCState("Merchants_Fisher", "figurine_given")
            else  
                local dialog_state =  dialog_system.script.dialog_states["Merchants_Fisher"]
                dialog_system.script.dialog_state_machines["Merchants_Fisher"]["figurine_unknown"].new_state = dialog_state
                dialog_system.script.changeNPCState("Merchants_Fisher", "figurine_unknown")
            end
        end
    end
end

function set_captain_target(npc_id, state_info)
    --print("Captain will travel to "..state_info.answer.target)
    merchants_npcs["Merchants_Captain"].travel_target = state_info.answer.target
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
    merchants_resource_master_dog.animation:play("attack", false)
    global_scripts.script.playSoundAtObject("warg_howl", merchants_resource_master_dog)
end

function spawn_quartermaster_token()
    local token = spawn("blue_gem", merchants_resource_master_socket.level, 0, 0, 0, 0, "merchants_quartermaster_token")  
    merchants_resource_master_socket:spawn("dispel_blast")  
    merchants_resource_master_socket.socket:addItem(token.item)
end

function give_arena_key()
    local key = spawn("iron_key")
    merchants_resource_master_socket:spawn("dispel_blast")
    merchants_resource_master_socket.socket:addItem(key.item)
end

function countdown(time_delta, animation)
    dialog_system.script.print_npc_text("Merchants_Resources_Master", tostring(animation.counter))
    dialog_system.script.add_history("Merchants_Resources_Master", "Merchants_Resources_Master", tostring(animation.counter))
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

function resources_master_fight()
    Merchants_Resources_Master.brain:enable()
    Merchants_Resources_Master.monster:setMonsterFlag("Invulnerable", false)
    local dialog_clickable = dialog_system.script.get_dialog_clickable("Merchants_Resources_Master")
    dialog_clickable.particles:stop()
    dialog_clickable.model:disable()
end

function quarter_master_gives_tokens()
    castle_door_portcullis_keep_pillars_1.door:open()
end

merchants_quarter_master_stories = {"I oonce caught a cheesefish! It was soooo gooood!", "Oone time, we fouought ooff an entire fleet oof Zarchtoons, cannooons gooed booom!", "Thiis quaarter we made sooo much coooin!"}
function change_story(npc_id, state_info)
    local state = dialog_states[npc_id]
    local story = merchants_quarter_master_stories[math.random(#merchants_quarter_master_stories)]       
    dialog_system.script.dialog_state_machines["Merchants_Quarter_Master"][state].say = story
end

function enable_boat_trigger(npc_id, state_info)
    --print(state_info.floor_trigger_id)
    local floor_trigger = findEntity(state_info.floor_trigger_id)
    floor_trigger.floortrigger:enable()
end

function doMerchantsCaptainTravel(time_delta, animation)
    GameMode.fadeIn(1, 1)
    GameMode.setEnableControls(true)    
end

function merchantsCaptainTravel(trigger)
    trigger = global_scripts.script.getGO(trigger)
    --print("going to "..merchants_npcs["Merchants_Captain"].travel_target)
    trigger.floortrigger:disable()
    local travel_info = merchants_npcs["Merchants_Captain"].travel_targets[merchants_npcs["Merchants_Captain"].travel_target]
    if travel_info.captains_spawn_id ~= nil then
        local spawn_pos = global_scripts.script.copy_pos(findEntity(travel_info.captains_spawn_id))
        global_scripts.script.moveObjectToObject(Merchants_Captain, spawn_pos)
        
        tricksters_domain_script_entity.script.pos_straight_ahead(spawn_pos)
        tricksters_domain_script_entity.script.pos_reverse(spawn_pos)
        local dialog_clickable = dialog_system.script.get_dialog_clickable("Merchants_Captain")
        local dialog_history_button = dialog_system.script.get_history_button("Merchants_Captain")
        local dialog_socket = dialog_system.script.get_dialog_socket("Merchants_Captain")
        global_scripts.script.moveObjectToObject(dialog_clickable, spawn_pos)
        global_scripts.script.moveObjectToObject(dialog_history_button, spawn_pos)
        global_scripts.script.moveObjectToObject(dialog_socket, spawn_pos)        
        
        dialog_system.script.dialog_state_machines["Merchants_Captain"]["off_we_go"].floor_trigger_id = travel_info.floor_trigger_id
        
        dialog_system.script.changeNPCState("Merchants_Captain", travel_info.new_state)
    end        
    local pos = global_scripts.script.copy_pos(travel_info)
    
    --playSound("chonghoizatsingsiu_short")
    GameMode.fadeOut(0, 1)
    GameMode.setEnableControls(false)
    GameMode.playVideo("mod_assets/cinematics/travelin_with_merchant_captain.v002.ivf")
    --GameMode.showImage("mod_assets/cinematics/boat_ride_with_rat_captain.v001.dds") -- this is not so good, the player has to press a key to dismiss
    -- the image, it would be nicer if that wasn't needed
    
    party:setPosition(pos.x, pos.y, pos.facing, pos.elevation, pos.level)
    local animation = {on_finish=doMerchantsCaptainTravel, step=16.2, duration=16.1, pos=pos} -- the video above is about 16 seconds long
    global_scripts.script.add_animation(0, animation)    
end

function give_hunting_island_pass()
    local hunting_island_pass = spawn("note", merchants_quarter_master_socket.level, 0, 0, 0, 0, "merchants_travel_pass_hunt_beasts")
    hunting_island_pass.scrollitem:setScrollText("To the Island of Beasts\n/QuaterMaster")          
    merchants_quarter_master_socket.socket:addItem(hunting_island_pass.item)
end

function recruiter_give_note()
    local recruitment_drive_note = spawn("note", merchants_quarter_master_socket.level, 0, 0, 0, 0, "merchants_recruiter_free_lunch_ticket")
    recruitment_drive_note.scrollitem:setScrollText("One free lunch.\n/Recruiter #35")
    merchants_recruiter_socket.socket:addItem(recruitment_drive_note.item)
end

function receptionist_receive_lunch_ticket()
    
end

function check_party(npc_id, state_info)
    local fate_sprites = 0
    for i=1,4 do
        local champion = party.party:getChampion(i)
        if champion:getClass() == "sprite" then
            fate_sprites = fate_sprites + 1
        end
    end
    
    if not merchants_npcs["Merchants_HQ_Receptionist"].party_checked and fate_sprites ~= 0 then       
        dialog_system.script.changeNPCState(npc_id, "reject_part_needs_4")
        merchants_npcs["Merchants_HQ_Receptionist"].party_checked = true
    end
end

function give_ice_fish(npc_id, state_info)
    hudPrint("Here, you get an ice fish, that gives permanent +5 energy, maybe +10")
end

merchants_npcs = {
    Merchants_Fisher = {
        id = "Merchants_Fisher",
        state = "init",
        offset = "left",
        clickable_id = "dialog_system_clickable_1",
        history_button_id = "dialog_system_show_history_button_2",
        socket_id = "merchants_fisher_socket",
        dialog = {
            init = {say = "Hello, Adventurers!\nNice day for fishing, ain't it?", 
                   answers = {{say = "We think so, too!", new_state = "happy", func=happyParty},
                              {say = "We don't like fishing...", new_state = "sad"},
                              {say = "We have no time for fishing...", new_state = "sad"}}},
            happy = {say = "You're nice Adventurers! Welcome to the town of Cheesefield!", one_time_func=openCheesefieldGate, func_called=false, new_state="chit_chat"},
            chit_chat = {say = "Hello, Adventurers!", 
                        answers = {{say = "Do you know where the Pickaxe Trial is?", new_state="give_directions_to_pickaxe_trial"},
                                   {say = "Why the cannon shots?", new_state="explain_time_keeping"},
                                   {say = "Where's the Combat Trial?", new_state="give_directions_to_combat_trial"}}},
            give_directions_to_pickaxe_trial = {say = "That is straight between the morning and noon from here. I'm sure it's easy to find.", new_state = "chit_chat"},
            explain_time_keeping = {say = "The ancient cannon daemons fire to mark the time. Because people kept getting blown to bits, we sound a horn just before.", new_state = "chit_chat"},
            give_directions_to_combat_trial = {say = "There's an arena next to the Quarter Master's Office.", new_state="chit_chat"},
            sad = {say = "You make me sad!",
                  answers = {{say = "We're sorry you're sad!", new_state = "happy"},
                             {say = "We don't care you're sad!", new_state = "angry"}}},
            angry = {say = "I don't much like you, leave me be!", new_state = "angry"},
            letter_given = {say = "Thank you so much!", new_state = "chit_chat"},
            figurine_unknown = {say = "What am I doing with this?", new_state = "chit_chat"},
            figurine_given = {say = "Adventurers, *starts crying*... \nI've caught this special fish, I give it to you!\n", one_time_func=give_ice_fish, func_called=false, new_state = "chit_chat"}
        },
    },
    Merchants_Resources_Master = {
        id = "Merchants_Resources_Master",
        state = "init",
        offset = "left",
        clickable_id = "dialog_system_clickable_3",
        history_button_id = "dialog_system_show_history_button_3",
        dialog = {
            init = {say = "If you ain't got business with me, go away", func=dog_growl, new_state="init"},
            scroll_placed = {say = "Ok, ya resources, go and do the pickaxe trial.\nReturn the token.\nDon't even think about running away with it.", 
                            answers = {{say = "We're on it!", new_state="pickaxe_trial"},
                                       {say = "Where's the trial?", new_state="pre_pickaxe_trial"}}},
            pre_pickaxe_trial = {say = "If ya driftwood can't e'en find a pickaxe in a house, you might only be good for dog food after all.", new_state="pickaxe_trial", func=dog_growl},
            pickaxe_trial = {say = "Are you still here?", func=dog_growl, new_state="pickaxe_trial"},
            pickaxe_trial_done = {say = "Great, we're got some beasties and y're gonna fight 'em. And if ya come back, you pass.", one_time_func=give_arena_key, func_called=false, new_state="combat_trial"},
            combat_trial = {say = "Be off! If ya don't wanna fight me instead.",
                                answers = {{say = "We'll be right back!", new_state="combat_trial"},
                                           {say = "We'll fight you!", new_state="combat"}}},
            combat = {say = "Right, what a way to waste resources...", one_time_func=resources_master_fight, func_called=false, new_state="combat_trial"},
            combat_trial_done = {say = "Here's my final quest: Take this to the Quater Master and don't bother me no more!", one_time_func=spawn_quartermaster_token, func_called=false, new_state="dont_bother_me"},
            dont_bother_me = {say = "Me dog is hungry, ya looks like food and y're about to fail my final quest.", func=dog_growl, one_time_func=dialog_system_next_state, func_called=false, new_state="annoyed"},
            annoyed = {say = "You fail the quest of Don't Bother Me No More.\nYour reward will be a cannonball.", func=resources_master_boom, new_state="annoyed"}
        },
    },
    Merchants_HQ_Receptionist = {
        id = "Merchants_HQ_Receptionist",
        state = "init",
        offset = "right",
        clickable_id = "dialog_system_clickable_2",
        history_button_id = "dialog_system_show_history_button_1",
        party_checked = false,
        dialog = {
            init = {say = "What do you lowlifes want??",
                 answers = {{say = "We're looking for work.", func=check_party, new_state = "look_for_work_work"},
                             {say = "Actually, nothing, from you. Goodday!", new_state = "init", func=leaveGame},
                             {say = "We want to be pirates!", func=check_party, new_state = "look_for_work_pirates"}}},
            reinit = {say = "So, what do you lowlifes want??",
                 answers = {{say = "We're still looking for work.", func=check_party, new_state = "look_for_work_work"},
                             {say = "Actually, still nothing, from you. Goodday!", new_state = "reinit", func=leaveGame},
                             {say = "We still want to be pirates!", func=check_party, new_state = "look_for_work_pirates"}}},
            reject_part_needs_4 = {say = "We always assign assignments for teams of 4. Are you $n are ready for this?",
                                answers = {{say = "Aye, we're awesome!", new_state = "reinit"},
                                           {say = "Well, we'll come again!", new_state = "reinit"}}},
            look_for_work_work = {say = "Great, more wood to toss on the fire.\nTake this scroll and present\nyourself to the resources master!", new_state = "leave_me_alone", one_time_func=raiseDesk, func_called=false},
            look_for_work_pirates = {say = "Well, great, more bodies to bury at sea.\nTake this scroll and present\nyourself to the resources master!", new_state = "leave_me_alone", one_time_func=raiseDesk, func_called=false},                                                     
            leave_me_alone = {say = "Be off!", new_state = "leave_me_alone"},
            take_your_things = {say = "Take your things and be off!", new_state = "take_your_things"},
            handed_in_free_lunch_ticket = {say = "Great, you sign on, we give you the food.", one_time_fun=check_free_lunch, func_called=false, new_state = nil},
        },                   
    },
    Merchants_Captain = {
        id = "Merchants_Captain",
        state = "init",
        offset = "left",
        clickable_id = "dialog_system_clickable_5",
        history_button_id = "dialog_system_show_history_button_5",
        party_checked = false,
        socket_id="merchants_captain_socket", 
        travel_target=nil, 
        travel_targets={hunting_island={x=16, y=31, level=19, elevation=0, facing=0, captains_spawn_id="hunters_merchants_captain_spawn", floor_trigger_id="hunting_island_boat_trigger", new_state="ready_to_return"}, 
                       beginning_beach={x=14, y=30, level=10, elevation=1, facing=2}, 
                       merchants_hq={x=15, y=18, level=5, elevation=1, facing=2, captains_spawn_id="merchants_captain_spawn", floor_trigger_id="merchants_hq_boat_trigger", new_state="ready_to_travel"}},
        dialog = {
            init = {say = "Ahoy!", answers = {{say = "Ahoy, can we travel with your boat, captain?", new_state="explain_travel"}}},
            explain_travel = {say = "If you have a travel pass, you can come along.", new_state="ready_to_travel"},
            ready_to_travel = {say = "So, where to?", answers = {{say = "For now, we need to stay here.", new_state="ready_to_travel"}}},
            off_we_go = {say = "Step into the boat and we'll be off!", func=enable_boat_trigger,  floor_trigger_id="merchants_hq_boat_trigger", new_state="off_we_go"},
            ready_to_return = {say = "Ready to go back?", 
                            answers = {{say = "Yeah!", func=set_captain_target, target="merchants_hq", new_state="off_we_go"}, 
                                       {say = "We need to stay a while longer.", new_state="ready_to_return"}}}
        },    
    },
    Merchants_Quarter_Master = {
        id = "Merchants_Quarter_Master",
        state = "init",
        offset = "left",
        clickable_id = "dialog_system_clickable_4",
        history_button_id = "dialog_system_show_history_button_6",
        dialog = {
            init = {say = "Doo you have a tooken? If noot, goo away!", new_state = "init"},
            token_given = {say = "Very gooood, take these tookens and goo buy equiipment. Briing back the saack.", one_time_func=quarter_master_gives_tokens, func_called=false, new_state="wait_for_sack"},
            stay_a_while = {say = "I oonce caught a cheeeesefish! It was soooo gooood!", func=change_story, new_state="stay_a_while"},
            wait_for_sack = {say = "Pleease retoorn the saack!", new_state="wait_for_sack"},
            give_hunting_island_pass = {say = "Teeaak this paaass tooo the captaiin. Goo huntiing, retuurn with troophies!", one_time_func=give_hunting_island_pass, func_called=false, new_state="wait_for_trophies"},
            wait_for_trophies = {say = "Goooo huuunt", new_state="wait_for_trophies"},
        },
    },
    Merchants_Recruiter = {
        id = "Merchants_Recruiter",
        state = "init",
        offset = "right",
        clickable_id = "dialog_system_clickable_6",
        history_button_id = "dialog_system_show_history_button_4",
        dialog = {
            init = {say = "Hey!\nYou looks like the curious sort!\nYou should go to the Merchants of East HQ and hire on!\nTake this note, for one free meal if you signs on", one_time_func=recruiter_give_note, func_called=false, new_state="here_again"},
            here_again = {say = "Hey!\nYou looks like...\n\n...the party what were here just now!\nThe HQ is just towards noon from here!\nOf you go!", new_state="off_you_go"},
            off_you_go = {say = "Well, offs you go!", new_state="off_you_go"}
        },
    },
}

function init_dialog_system()
    for npc_id, npc_data in pairs(merchants_npcs) do
        dialog_system.script.add_npc(npc_data)
    end
end

shop_system = {merchants_shop_healing_potion_alcove = {cost = 1, paid = 0, item_data = {class = "potion_healing", type = "single", count = 1}},
               merchants_shop_healing_crystal_alcove = {cost = 3, paid = 0, item_data = {class = "crystal_shard_healing", type = "single", count = 1}},
               merchants_shop_energy_potion_alcove = {cost = 1, paid = 0, item_data = {class = "potion_energy", type = "stack", count = 2}},
               merchants_shop_antidote_alcove = {cost = 1, paid = 0, item_data = {class = "potion_cure_poison", type = "single", count = 1}},
               merchants_shop_pellets_alcove = {cost = 1, paid = 0, item_data = {class = "pellet_box", type = "stack", count = 50}},
               merchants_shop_darts_alcove = {cost = 1, paid = 0, item_data = {class = "dart", type = "stack", count = 10}},
               merchants_shop_arrows_alcove = {cost = 1, paid = 0, item_data = {class = "arrow", type = "stack", count = 5}},
               merchants_shop_lunch_alcove = {cost = 1, paid = 0, item_data = {class = "cheese", type = "single", count = 4}}}

shop_system_paid_tokens = {merchants_shop_healing_potion_alcove = {},
                           merchants_shop_healing_crystal_alcove = {},
                           merchants_shop_energy_potion_alcove = {},
                           merchants_shop_antidote_alcove = {},
                           merchants_shop_pellets_alcove = {},
                           merchants_shop_darts_alcove = {},
                           merchants_shop_arrows_alcove = {},
                           merchants_shop_lunch_alcove = {}}

merchants_shop_text_ids = {"merchants_shop_healing_potion_text", "merchants_shop_healing_crystal_text", "merchants_shop_energy_potion_text","merchants_shop_antidote_text", "merchants_shop_pellets_text", "merchants_shop_darts_text", "merchants_shop_arrows_text", "merchants_shop_lunch_text"}


function init_shop_system()
    for _, text_id in ipairs(merchants_shop_text_ids) do
        local text = findEntity(text_id)
        local w_pos_y = text:getWorldPositionY()
        text:setWorldPositionY(w_pos_y+0.5)
    end
end

function onRemoveItemShop(surface, item)
    local item = global_scripts.script.getGO(item)
    local shop_alcove = global_scripts.script.getGO(surface)
    
    if shop_system[shop_alcove.id] == nil then
        return
    end
    
    if item.name == "blue_gem" then
        shop_system_paid_tokens[shop_alcove.id][item.id] = nil        
    end
    
    shop_system[shop_alcove.id].paid = 0
    for _, item in surface:contents() do
        if item.go.id == "blue_gem" then
            shop_system[shop_alcove.id].paid = shop_system[shop_alcove.id].paid + 1
        end
    end
    
end

function onPutToken(surface, item)
    local item = global_scripts.script.getGO(item)
    local shop_alcove = global_scripts.script.getGO(surface)
    
    if shop_system[shop_alcove.id] == nil then
        return
    end
    
    --print(tostring(shop_system[shop_alcove.id].paid))
    
    if item.name == "blue_gem" then
        shop_system_paid_tokens[shop_alcove.id][item.id] = true
        shop_system[shop_alcove.id].paid = shop_system[shop_alcove.id].paid + 1
        
        if shop_system[shop_alcove.id].paid == shop_system[shop_alcove.id].cost then                    
            for token_id, _ in pairs(shop_system_paid_tokens[shop_alcove.id]) do
                local token = findEntity(token_id)
                token:destroyDelayed()
            end            
            shop_system_paid_tokens[shop_alcove.id] = {}
                        
            shop_alcove:spawn("dispel_blast")
                        
            local shop_item_data = shop_system[shop_alcove.id].item_data
            local shop_item
            if shop_item_data.type == "single" then
                for i=1,shop_item_data.count do
                    shop_item = spawn(shop_item_data.class).item
                    surface:addItem(shop_item)
                end
            elseif shop_item_data.type == "stack" then                    
                shop_item = spawn(shop_item_data.class).item
                shop_item:setStackSize(shop_item_data.count)
                surface:addItem(shop_item)
            end
                        
            shop_system[shop_alcove.id].paid = 0
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

function enterLevel()
    GameMode.setTimeOfDay(1.98)
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
    init_shop_system()
    local w_pos = tomb_torch_holder_2:getWorldPosition()
    w_pos.y = w_pos.y - 1
    tomb_torch_holder_2:setWorldPosition(w_pos)
    local torch = tomb_torch_holder_1.socket:getItem()
    w_pos = torch.go:getWorldPosition()
    w_pos.y = w_pos.y - 1
    torch.go:setWorldPosition(w_pos)
    w_pos = tomb_torch_holder_1:getWorldPosition()
    w_pos.y = w_pos.y - 1
    tomb_torch_holder_1:setWorldPosition(w_pos)
    torch = tomb_torch_holder_2.socket:getItem()
    w_pos = torch.go:getWorldPosition()
    w_pos.y = w_pos.y - 1
    torch.go:setWorldPosition(w_pos)
end