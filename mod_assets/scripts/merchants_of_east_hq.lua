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
    item = global_scripts.script.getGO(item)
    item:destroyDelayed()
    
    merchants_hq_rubble_door_2.door:open()
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

dialog_states = {Cheesefield_Town_Guard = "init"}
dialog_offset = {Cheesefield_Town_Guard = "left"} 
dialog_state_machines = {Cheesefield_Town_Guard = {init = {say = "Hello, Adventurers!\nNice day for fishing, ain't it?", 
                                                   answers = {{say = "We think so, too!", new_state = "happy", func=happyParty},
                                                              {say = "We don't like fishing...", new_state = "sad"},
                                                              {say = "Wow! A monster that can talk!", new_state = "angry"}}},
                                       happy = {say = "You're nice Adventurers! Welcome to the town of Cheesefield!", func=openCheesefieldGate},
                                       sad = {say = "You make me sad!",
                                              answers = {{say = "We're sorry you're sad!", new_state = "happy"},
                                                          {say = "We don't care you're sad!", new_state = "angry"}}},
                                       angry = {say = "You anger the monster that can talk!", func=rat_attacks}}}
dialog_system_clickable_ids = {Cheesefield_Town_Guard = "dialog_system_clickable_1"}
dialog_button_next_states = {}
dialog_button_funcs = {}
dialog_answer_entity_ids = {Cheesefield_Town_Guard = {}}

function component_offset(component, offset)
    local entity_offset = component:getOffset()
    entity_offset = entity_offset + offset
    component:setOffset(entity_offset)
end

function onGiveDialogAnswer(button)    
    button = global_scripts.script.getGO(button)    
    hudPrint("Party: "..button.walltext:getWallText())    
    local state_info = dialog_button_next_states[button.id]
    if state_info.new_state ~= nil then
        dialog_states[state_info.npc_id] = state_info.new_state
    end
    local party_func = dialog_button_funcs[button.id]
    if party_func ~= nil then
        party_func(state_info.npc_id)
    end
    local npc_func = dialog_state_machines[state_info.npc_id][dialog_states[state_info.npc_id]].func
    if npc_func ~= nil then
        npc_func(state_info.npc_id)
    end
    set_npc_dialog_text(state_info.npc_id, dialog_states[state_info.npc_id], true)
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
end

function spawn_dialog_answers(npc_id)
    local state = dialog_states[npc_id]
    
    cleanup_dialog_answer(npc_id)    
        
    local answers = dialog_state_machines[npc_id][state].answers
    if answers == nil then
        return
    end
    
    local offset = vec(0, -0.6, 0)
    for _,answer in ipairs(answers) do
        local dialog_text_id, dialog_button_id = spawn_dialog_answer(npc_id, offset, answer.say)
        dialog_button_next_states[dialog_button_id] = {npc_id = npc_id, new_state = answer.new_state}
        dialog_button_funcs[dialog_button_id] = answer.func -- this one is called for the part
        table.insert(dialog_answer_entity_ids[npc_id], dialog_text_id)
        table.insert(dialog_answer_entity_ids[npc_id], dialog_button_id)
        offset.y = offset.y + 0.6
    end
end

function set_npc_dialog_text(npc_id, state, print_answer)
    local dialog_system_clickable_id = dialog_system_clickable_ids[npc_id]
    local dialog_system_clickable = findEntity(dialog_system_clickable_id)
    local say_text = dialog_state_machines[npc_id][state].say    
    if print_answer == true then
        hudPrint(npc_id..": "..dialog_state_machines[npc_id][state].say)
    end
    dialog_system_clickable.walltext:setWallText(say_text)
end

function init_dialog_system()
    for npc_id, state in pairs(dialog_states) do
        findEntity(npc_id).monster:setMonsterFlag("Invulnerable", true)
        set_npc_dialog_text(npc_id, state, false)
        spawn_dialog_answers(npc_id)
    end
end

function dialog_system(npc_id)
    local dialog_state = dialog_states[npc_id]
    local dialog_state_machine = dialog_state_machines[npc_id]
    
    
end

function init()
    init_dialog_system()
    for i = 1,9 do
        local blue_gem = spawn("blue_gem")
        merchants_token_sack_1.containeritem:addItem(blue_gem.item)
        local blue_gem = spawn("blue_gem")
        merchants_token_sack_2.containeritem:addItem(blue_gem.item)
    end
end