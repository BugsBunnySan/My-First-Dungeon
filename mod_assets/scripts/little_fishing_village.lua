water_tiles = {}

function find_water_position()
    return global_scripts.script.findEmptySpot(water_tiles, nil, true)
end

function aggressive()
    global_scripts.script.playSoundAtObject("trickster_laugh", party)
    for _, npc_data in ipairs(npcs) do
        npc_data.state = "aggressive"
    end
end

community_attitude_level_to_party = 0
attitude_levels = {{level = -100, state = "aggressive", func = aggressive},
                   {level = -75, state = "dont_get_close", func = nil},
                   {level = -50, state = "go_away", func = nil},
                   {level = -25, state = "we_dont_like_you", func = nil},
                   {level = 0, state = "neutral", func = nil},
                   {level = 25, state = "we_think_youre_nice", func = nil},
                   {level = 50, state = "we_like_you", func = nil},
                   {level = 75, state = "youre_welcome_to_stay", func = nil},
                   {level = 500000, state = "we_think_youre_awesome", func = nil}
}
attitude_state_levels = {} -- this gets build from above table
current_attitude = {}

function recalculate_attitude()
    local level_idx = 0
    local found = false
    
    while not found do
        level_idx = level_idx + 1
        if community_attitude_level_to_party < attitude_levels[level_idx].level then
            found = true
        end        
    end
    
    current_attitude = attitude_levels[level_idx]
    
    if current_attitude.func ~= nil then
        current_attitude.func()
    end
end

function change_attitude(amount)
    community_attitude_level_to_party = community_attitude_level_to_party + amount
    recalculate_attitude()
end
    
function alert_community(time_delta, animation)
    change_attitude(animation.attitude_change)
end

stealCompassAnimation_id = -1

function putItem(pedestal, item)
    item = global_scripts.script.getGO(item)
    if item.name == "compass" or item.name == "cursed_compass" then
        global_scripts.script.remove_animation(zarchton_altar_compass.level, stealCompassAnimation_id)
        animation = triels_robin_script_entitiy.script.raisePedestal("zarchton_altar_compass", true, 1)
        animation.on_finish_pos = global_scripts.script.copy_pos(altar_pos)
        animation.stop_pos = altar_pos:getWorldPosition()
        global_scripts.script.add_animation(zarchton_altar_compass.level, animation)
    end
end

function stealCompass()    
    global_scripts.script.playSoundAtObject("wind_howl", zarchton_altar_compass)
    change_attitude(-5) -- suspicion grows
    
    local animation = triels_robin_script_entitiy.script.raisePedestal("zarchton_altar_compass", true, -1)       
    animation.duration = 10
    animation.delay = 2    
    animation.on_finish=alert_community
    animation.attitude_change = -500
    stealCompassAnimation_id = global_scripts.script.add_animation(zarchton_altar_compass.level, animation)
end

function partyStealItem(npc, item)
    hudPrint(npc.id.." saw you take their things!")
    npc_script_entity.script.change_npc_state(npc.id, "pursue_party_thiefs", true)
    npc_script_entity.script.npc_states[npc.id].stolen_item = item.id
end

function pursue_party_thiefs(npc_id, state)
    local mouse_item = getMouseItem
    if party.party:isCarrying(npc_infos[npc_id].stolen_item) or (mouse_item ~= nil and mouse_item.id == npc_infos[npc_id].stolen_item)  then
        hudPrint(npc_id.." pursuing the party")
        return npc_brain:pursuit()            
    else
        hudPrint(npc_id.." going back to what it was doing")
        npc_script_entity.script.goto_next_state(npc_id)
        return npc_brain:wait()             
    end
end

function aggressive(npc_id, state)
    npc_brain.go.move:enable()
    npc_brain.go.turn:enable()
    npc_brain.go.basicAttack:enable()
    npc_brain.go.leapAttack:enable()
    return false -- default brain takes over
end

function calm_down(npc_id, state)
    npc_brain.go.move:disable()
    npc_brain.go.turn:disable()
    npc_brain.go.basicAttack:disable()
    npc_brain.go.leapAttack:disable()
    npc_script_entity.script.goto_next_state(npc_id)
    return true
end

-- state utility functions
function calculate_goto_next_state(npc_brain, npc_info, state)
    npc_script_entity.script.goto_next_state(npc_brain.go.id, state)
    return true
end

function calculate_remove_state(npc_brain, npc_info, state, callback)
    npc_script_entity.script.remove_state(npc_brain.go.id, state)
    return true
end

function calculate_true(npc_brain, npc_info, state, callback)
    return true
end

function event_goto_next_state(npc_id, npc_info, state, callback)
    npc_script_entity.script.goto_next_state(npc_id, state)
end

function event_remove_state(npc_id, npc_info, state, callback)
    npc_script_entity.script.remove_state(npc_id, state)
end

-- occupation execute functions
function find_water(npc_brain, npc_info, state)
    local water_pos = find_water_position()
    local new_state = {name="goto_xy", goto_pos=water_pos, state_stack={}}
    --print(npc_id.." is going to find water at ")
    --global_scripts.script.print_pos(new_state.goto_pos)
    npc_script_entity.script.replace_state(npc_id, state, new_state)
    return true
end

function do_fish(npc_brain, npc_info, state)
    local npc = findEntity(npc_brain.go.id)
    npc.move:disable()    
    npc.brain:performAction("fish") -- the animation handler advances states once a fish is successfully caught
    return true
end

-- occupation functions
function send_unoccupied(npc_id, state)
    local condition = {name="zarchton_is_unoccupied", condition="is_unoccupied"}
    npc_script_entity.script.add_event(npc_id, condition)        
end

function going_fishing_handle_caught_fish(npc_id, npc_info, state, callback)
    --print(npc_id.." caught fish "..callback.fish_id)
    print(state.name.." child of "..state.parent_state.name)
    local new_state = {name = "bring_home_catch", on_calculate=calculate_remove_state, on_close=send_unoccupied, fish_id=callback.fish_id}
    
    npc_script_entity.script.add_child_state(new_state, {name="put_item_in_container", container_id=npc_info.home_storage_id, item_id=callback.fish_id})
    
    npc_script_entity.script.add_child_state(new_state, {name="turn_to_target", target_id=npc_info.home_storage_id})
    
    npc_script_entity.script.add_child_state(new_state, {name="goto_target", target_id=npc_info.home_storage_pos_id})
    
    npc_script_entity.script.replace_state(npc_id, state, new_state)
    
    return true
end

function make_going_fishing(npc_id, npc_info)
    local new_state = {name="going_fishing", on_calculate=calculate_true, state_stack={}}

    local child_state = {name="fish", on_calculate=do_fish}
    npc_script_entity.script.add_child_state(new_state, child_state)

    child_state = {name="find_water", on_calculate=find_water}
    npc_script_entity.script.add_child_state(new_state, child_state)
    
    return new_state
end

function find_occupation(npc_id, npc_info)   
    return npc_info.occupation(npc_id, npc_info)
end

-- asleep

function send_woke_up(npc_id, state)
    local condition = {name="zarchton_awake", condition="woke_up"}
    npc_script_entity.script.add_event(npc_id, condition)
end

function wake_up(npc_id, npc_info, state, callback)
    print("wake up from "..state.name.." beacuse "..callback.condition)    
        
    local new_state = {name="wake_up", on_calculate=calculate_remove_state, on_close=send_woke_up, state_stack={}}
    
    local child_state = {name="operate", target_id=npc_info.home_door_lever_id}
    npc_script_entity.script.add_child_state(new_state, child_state)
                
    child_state = {name="goto_target", target_id=npc_info.home_door_lever_id}
    npc_script_entity.script.add_child_state(new_state, child_state)
        
    npc_script_entity.script.add_child_state(state, new_state)    
end

function asleep_handle_woke_up(npc_id, npc_info, state, callback)
    local new_state = make_awake_state(npc_id)
    npc_script_entity.script.replace_state(npc_id, state, new_state)
end

function asleep_handle_dawn(npc_id, npc_info, state, callback)
    wake_up(npc_id, npc_info, state, callback)
end

function calculate_asleep(npc_brain, npc_info, state)
    npc_brain.go.move:disable()   
    npc_brain.go.turn:disable()
    return true
end

function make_asleep_state(npc_id)
    return {name="asleep", on_calculate=calculate_asleep, state_stack={}}
end

-- awake

function send_sleep(npc_id, state)
    local condition = {name="zarchton_go_to_sleep", condition="sleep"}
    npc_script_entity.script.add_event(npc_id, condition)
end

function awake_go_to_sleep(npc_id, npc_info, state)                       
    local new_state = {name="go_to_sleep", on_calculate=calculate_remove_state, on_close=send_sleep, state_stack={}}
                      
    child_state = {name="operate", target_id=npc_info.home_door_lever_id}
    npc_script_entity.script.add_child_state(new_state, child_state)
    
    child_state = {name="goto_target", target_id=npc_info.home_id}
    npc_script_entity.script.add_child_state(new_state, child_state)
        
    npc_script_entity.script.add_child_state(state, new_state, 1)   
    print(state.name.." has the following children states ")
    for _, child_state in ipairs(state.state_stack) do
        print("->"..child_state.name)
    end
end

function awake_handle_sleep(npc_id, npc_info, state, callback)
    local new_state = make_asleep_state(npc_id)
    npc_script_entity.script.replace_state(npc_id, state, new_state)
end

function awake_handle_day_is_over(npc_id, npc_info, state, callback)
    awake_go_to_sleep(npc_id, npc_info, state)
end

function awake_handle_dusk(npc_id, npc_info, state, callback)    
    npc_script_entity.script.add_event(npc_id, {name="zarchtons_go_to_sleep", condition="day_is_over"})
end

function calculate_awake(npc_brain, npc_info, state)   
    local npc_id = npc_brain.go.id
    local new_state = {name="day_occupation", on_calculate=calculate_remove_state, state_stack={}}
    
    
    local occupation_state = find_occupation(npc_id, npc_info)  
    npc_script_entity.script.add_child_state(new_state, occupation_state)  
        
    npc_script_entity.script.add_child_state(state, new_state)
        
    return true
end

function make_awake_state(npc_id)
    return {name="awake", on_calculate=calculate_awake, state_stack={}}
end
--
function animation_event_handler(npc_id, event_name)
    if event_name == "fish" then
        local caught_fish = (math.random(10) > 0)
        if caught_fish then
            local npc = findEntity(npc_id)
            local fish = spawn("silver_roach")
            npc_script_entity.script.add_npc_belongig(fish.id, npc.id)
            npc.monster:addItem(fish.item)
            npc_script_entity.script.npc_handle_event(npc_id, nil, {name="caught_fish", condition="caught_fish", fish_id=fish.id})
        end
    end
end

zarchton_npc = {        
    id = nil,
    level = nil,
    idle_default = "idle_wander",        
    home_id = nil,
    home_door_lever_id = nil,
    home_storage_id = nil,
    home_storage_pos_id = nil,
    party_takes_item_func = partyStealItem,
    importance_to_community = 0,
    belongings_ids = {},
    level = little_fishing_village_script_entity.level,
    script_entity = little_fishing_village_script_entity,
    occupation = nil,
    animation_event_handlers = {
        fish = animation_event_handler
    },
    state_event_funcs = {
        going_fishing = {caught_fish = going_fishing_handle_caught_fish,
                         day_is_over = event_remove_state
        },        
        awake = {dusk = awake_handle_dusk,
                 day_is_over = awake_go_to_sleep,
                 sleep = awake_handle_sleep,
                 is_unoccupied = awake_handle_unoccupied
        },
        asleep = {dawn = asleep_handle_dawn,
                  woke_up = asleep_handle_woke_up
        },
        aggressive = {calm_down = calm_down
        },
    }            
}

    
npc_home_ids = {    
    zarchton_elder = "zarchton_elder_home",
    zarchton_npc_1 = "zarchton_npc_1_home",
    zarchton_npc_2 = "zarchton_npc_2_home",
    zarchton_npc_3 = "zarchton_npc_3_home"
}

npc_home_door_lever_ids = {   
    zarchton_elder = "zarchton_elder_home_lever",
    zarchton_npc_1 = "zarchton_npc_1_home_lever",
    zarchton_npc_2 = "zarchton_npc_2_home_lever",
    zarchton_npc_3 = "zarchton_npc_3_home_lever"    
}
    
npc_home_storage_ids = {  
    zarchton_elder = "zarchton_elder_home_storage",
    zarchton_npc_1 = "zarchton_npc_1_home_storage",
    zarchton_npc_2 = "zarchton_npc_2_home_storage",
    zarchton_npc_3 = "zarchton_npc_3_home_storage"        
}
 
npc_home_storage_pos_ids = {  
    zarchton_elder = "zarchton_elder_home_storage_pos",
    zarchton_npc_1 = "zarchton_npc_1_home_storage_pos",
    zarchton_npc_2 = "zarchton_npc_2_home_storage_pos",
    zarchton_npc_3 = "zarchton_npc_3_home_storage_pos"        
}
    
npc_belonging_ids = {
    zarchton_npc_1 = {"conjurers_hat_1"}
}
       
function make_zarchton_npc(npc_id, npc_info)
    local zarchton = global_scripts.script.deep_copy(npc_info)
    zarchton.id = npc_id
    zarchton.level = little_fishing_village_script_entity.level
    zarchton.home_id = npc_home_ids[npc_id]
    zarchton.home_door_lever_id = npc_home_door_lever_ids[npc_id]
    zarchton.home_storage_id = npc_home_storage_ids[npc_id]
    zarchton.home_storage_pos_id = npc_home_storage_pos_ids[npc_id]
    
    if npc_belonging_ids[npc_id] ~= nil then
        for _, item_id in ipairs(npc_belonging_ids) do
            table.insert(zarchton.belongings_ids, item_id)
        end
    end
    
    return zarchton
end

function make_zarchton_fisher(npc_id, npc_info)
    local zarchton = make_zarchton_npc(npc_id, npc_info)
    zarchton.idle_default = "idle_wander"
    zarchton.occupation = make_going_fishing
    zarchton.importance_to_community = 100
    
    return zarchton    
end

function make_zarchton_elder(npc_id, npc_info)
    local zarchton = make_zarchton_npc(npc_id, npc_info)
    zarchton.idle_default = "idle_guard"
    zarchton.occupation = make_going_fishing
    zarchton.importance_to_community = 500
    
    return zarchton    
end

function make_zarchton_guard(npc_id, npc_info)
    local zarchton = make_zarchton_npc(npc_id, npc_info)
    zarchton.idle_default = "idle_guard"
    zarchton.occupation = make_going_fishing
    zarchton.importance_to_community = 100
    
    return zarchton    
end

npcs = {       
    zarchton_npc_1 = make_zarchton_fisher,
}
not_npcs = {
    zarchton_npc_2 = make_zarchton_fisher,
    zarchton_npc_3 = make_zarchton_fisher,  
    zarchton_elder = make_zarchton_elder,
}

marea_multiplier = 6/9
marea_height = 0.5

function set_ocean_level(time_delta, animation)    
    for _, ocean_entity_id in ipairs(animation.ocean_entity_ids) do
        local ocean_entity = findEntity(ocean_entity_id)
        local w_pos = ocean_entity:getWorldPosition()
        w_pos.y = marea_height * math.sin(animation.elapsed/2)
        ocean_entity:setWorldPosition(w_pos)
    end
end

function init()
    local animation = {func=set_ocean_level, step=.01, duration=-1, ocean_entity_ids={"beach_ocean_7", "beach_ocean_8", "beach_ocean_9"}}
    global_scripts.script.add_animation(beach_ocean_7.level, animation)
    -- triels_robin_script_entitiy.script.goTilMorning(party)

    dungeon_tile_01.model:setMaterial("dungeon_floor_dirt_meridian_line")

    --merchants_script_entity.script.component_offset(forest_bridge_28.model, vec(0, 1, 0))
    -- merchants_script_entity.script.component_offset(forest_bridge_pillar_8.model, vec(0, 1, 0))
    -- merchants_script_entity.script.component_offset(forest_bridge_pillar_9.model, vec(0, 1, 0))

    local time_callback = {name="npc_support_dawn", condition="dawn", func=npc_script_entity.script.handle_event_time_of_day, level=little_fishing_village_script_entity.level, enabled=true}
    global_scripts.script.add_time_callback(0, time_callback)
    time_callback = {name="npc_support_noon", condition="noon", func=npc_script_entity.script.handle_event_time_of_day, level=little_fishing_village_script_entity.level, enabled=true}
    global_scripts.script.add_time_callback(0, time_callback)
    time_callback = {name="npc_support_dusk", condition="dusk", func=npc_script_entity.script.handle_event_time_of_day, level=little_fishing_village_script_entity.level, enabled=true}
    global_scripts.script.add_time_callback(0, time_callback)
    time_callback = {name="npc_support_midnight", condition="midnight", func=npc_script_entity.script.handle_event_time_of_day, level=little_fishing_village_script_entity.level, enabled=true}
    global_scripts.script.add_time_callback(0, time_callback)

    local time_of_day = GameMode.getTimeOfDay()    

    for npc_id, npc_func in pairs(npcs) do    
        local npc_data = npc_func(npc_id, zarchton_npc)
        npc_script_entity.script.add_npc(npc_data)
        local npc_info = npc_script_entity.script.npc_infos[npc_id]
                
        local state = make_awake_state(npc_id)
        npc_script_entity.script.add_child_state(npc_info.state, state)
        
        if not global_scripts.script.check_for_day(nil, nil, time_of_day) then
            awake_go_to_sleep(npc_id, npc_info, state)  
        end
        local npc = findEntity(npc_info.id)
        npc.brain:enable()
    end
    
    table.sort(attitude_levels, function (left, right)
        return left.level < right.level
    end)
    
    for _, attitude_level in ipairs(attitude_levels) do
        attitude_state_levels[attitude_level.state] = attitude_level.level
    end
    
    local map = Dungeon.getMap(beach_ocean_7.level)
    
    for x=0,31 do
        for y=0,31 do
            local tile_type = map:getAutomapTile(x, y)
            if tile_type == 2 then -- 2 is water
                table.insert(water_tiles, {x=x, y=y, level=beach_ocean_7.level, elevation=0, facing=0})
            end
        end
    end
end
