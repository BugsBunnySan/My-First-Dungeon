-- {"pushblock_floor_r1", "pushblock_floor_r2", "pushblock_floor_rs1", "pushblock_floor_rs2", "pushblock_floor_rs3", "pushblock_floor_trigger_rs4", "pushblock_floor_trigger_r5", "pushblock_floor_trigger_r0", "pushblock_floor_trigger_r12"},

pushblock_floors = {["start"] = {"pushblock_trigger_robin_start", "pushblock_trigger_r1", "pushblock_trigger_rs1"},
                    ["pushblock_trigger_rs1"] = {on = {"pushblock_trigger_rs2"}, off = nil},
                    ["pushblock_trigger_rs2"] = {on = {"pushblock_trigger_rs3"}, off = {"pushblock_trigger_rs1"}},
                    ["pushblock_trigger_rs3"] = {on = {"pushblock_trigger_robin_home"}, off = {"pushblock_trigger_rs2"}},
                    ["pushblock_trigger_r1"] = {on = {"pushblock_trigger_r2"}, off = {"pushblock_trigger_rs1"}},
                    ["pushblock_trigger_r2"] = {on = {"pushblock_trigger_r3"}, off = {"pushblock_trigger_r1"}},
                    ["pushblock_trigger_r3"] = {on = {"pushblock_trigger_r4"}, off = {"pushblock_trigger_r2"}},
                    ["pushblock_trigger_r4"] = {on = {"pushblock_trigger_r5"}, off = {"pushblock_trigger_r3"}},
                    ["pushblock_trigger_r5"] = {on = {"pushblock_trigger_robin_bridge"}, off = {"pushblock_trigger_r4"}},               
                    ["pushblock_trigger_robin_bridge"] = {on = {"pushblock_trigger_r6"}, off = {"pushblock_trigger_r5"}},
                    ["pushblock_trigger_r6"] = {on = {"pushblock_trigger_r7"}, off = {"pushblock_trigger_robin_bridge"}},
                    ["pushblock_trigger_r7"] = {on = {"pushblock_trigger_r8"}, off = {"pushblock_trigger_r6"}},
                    ["pushblock_trigger_r8"] = {on = {"pushblock_trigger_r9"}, off = {"pushblock_trigger_r7"}},
                    ["pushblock_trigger_r9"] = {on = {"pushblock_trigger_r10"}, off = {"pushblock_trigger_r8"}},
                    ["pushblock_trigger_r10"] = {on = {"pushblock_trigger_r11"}, off = {"pushblock_trigger_r9"}},
                    ["pushblock_trigger_r11"] = {on = {"pushblock_trigger_robin_forest"}, off = {"pushblock_trigger_r10"}},
                    ["pushblock_trigger_r12"] = {on = {"pushblock_trigger_r13"}, off = {"pushblock_trigger_robin_forest"}},
                    ["pushblock_trigger_r13"] = {on = {"pushblock_trigger_r14"}, off = {"pushblock_trigger_r12"}},
                    ["pushblock_trigger_r14"] = {on = {"pushblock_trigger_r15"}, off = {"pushblock_trigger_r13"}},
                    ["pushblock_trigger_r15"] = {on = {"pushblock_trigger_r16"}, off = {"pushblock_trigger_r14"}},
                    ["pushblock_trigger_r16"] = {on = {"pushblock_trigger_r17"}, off = {"pushblock_trigger_r15"}},
                    ["pushblock_trigger_r17"] = {on = {"pushblock_trigger_robin_after_forest"}, off = {"pushblock_trigger_r16"}},
                    ["pushblock_trigger_robin_after_forest"] = {on = {"pushblock_trigger_r99", "pushblock_trigger_r19"}, off = {"pushblock_trigger_r17"}},
}

pushblock_floor_triggered = {}

function finish_lite_up_pushblock_floor(time_delta, animation)
    local pushblock_floor = findEntity(animation.pushblock_floor_id)
    pushblock_floor.controller:activate()
    if animation.pushblock_floors_off ~= nil then
        for _,pushblock_floor_id in ipairs(animation.pushblock_floors_off) do            
            local pushblock_floor = findEntity(pushblock_floor_id)
            pushblock_floor.controller:deactivate()
            pushblock_floor.light:enable()
        end
    end
    if animation.push then
        pushblock_robin.pushableblock:push(pushblock_robin.facing)
    end
end

function lite_up_pushblock_floor(time_delta, animation)
    local brightness = (animation.elapsed / animation.duration) * animation.light_level    
    local pushblock_floor = findEntity(animation.pushblock_floor_id)
    pushblock_floor.light:setBrightness(brightness)    
    if brightness >= animation.light_level / 2 then
        pushblock_floor.particle:enable()
    end
end

function start_lite_up_pushblock_floor(pushblock_floor_id, push, pushblock_floors_off)   
    local pushblock_floor = findEntity(pushblock_floor_id)
    pushblock_floor.light:setBrightness(0)
    pushblock_floor.light:enable()
    local animation = {func=lite_up_pushblock_floor, on_finish=finish_lite_up_pushblock_floor, step=0.05, duration=1, elapsed=0, last_called=-1, pushblock_floor_id=pushblock_floor.id, light_level=35, push=push, pushblock_floors_off=pushblock_floors_off}
    global_scripts.script.add_animation(pushblock_floor.level, animation)
    global_scripts.script.playSoundAtObject("charge_up", pushblock_floor)
end

function liteUpPushblockFloorAnimation(trigger)
    if pushblock_floors[trigger.go.id] == nil then
        hudPrint(trigger.go.id.." no continuation found")
        return
    end    
    trigger:disable()
    pushblock_robin:setPosition(pushblock_robin.x, pushblock_robin.y, trigger.go.facing, pushblock_robin.elevation, pushblock_robin.level)      
    for _,pushblock_floor_id in ipairs(pushblock_floors[trigger.go.id]["on"]) do
        if pushblock_floor_triggered[pushblock_floor_id] == nil then
            pushblock_floor_triggered[pushblock_floor_id] = true                      
            start_lite_up_pushblock_floor(pushblock_floor_id, true, pushblock_floors[trigger.go.id]["off"])
        end
    end
end

function finish_raise_bridge(time_delta, animation)
    local bridge = findEntity(animation.bridge_id)    
    bridge:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    start_lite_up_pushblock_floor(animation.pushblock_trigger_id)
    global_scripts.script.faceObject(pushblock_robin, 1)
end

function raise_bridge(time_Delta, animation)
    local bridge = findEntity(animation.bridge_id)
    local percentage = animation.duration / animation.elapsed
    local start_pos = vec(animation.start_pos.x, animation.start_pos.y, animation.start_pos.z)
    local stop_pos = vec(animation.stop_pos.x, animation.stop_pos.y, animation.stop_pos.z)
    local w_pos = ((stop_pos - start_pos) / percentage) + start_pos
    bridge:setWorldPosition(w_pos)
end

function onBridgePedestalInsertItem(pedestal, item)
    hudPrint(item.go.name)
    if item.go.name == "meteorite" then
        local bridge = global_scripts.script.spawnAtObject("castle_bridge", robin_first_bridge)
        local bridge_w_pos = bridge:getWorldPosition()
        local start_pos = {x=bridge_w_pos.x, y=bridge_w_pos.y, z=bridge_w_pos.z}
        local stop_pos  = {x=bridge_w_pos.x, y=bridge_w_pos.y+3, z=bridge_w_pos.z}
        local on_finish_pos = {x=bridge.x, y=bridge.y, facing=bridge.facing, elevation=bridge.elevation+1, level=bridge.level}
        local animation = {func=raise_bridge, on_finish=finish_raise_bridge, step=0.05, duration=2, elapsed=0, last_called=-1, start_pos=start_pos, stop_pos=stop_pos, bridge_id=bridge.id, on_finish_pos=on_finish_pos, pushblock_trigger_id="pushblock_trigger_r6"}
        global_scripts.script.add_animation(pedestal.go.level, animation)
        global_scripts.script.playSoundAtObject("gate_iron_open", bridge)
    end
end

function finish_lower_object(time_delta, animation)
    local object = findEntity(animation.object_id)    
    object:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
end

function lower_object(time_delta, animation)
    local object = findEntity(animation.object_id)
    local percentage = animation.duration / animation.elapsed
    local start_pos = vec(animation.start_pos.x, animation.start_pos.y, animation.start_pos.z)
    local stop_pos = vec(animation.stop_pos.x, animation.stop_pos.y, animation.stop_pos.z)
    local w_pos = ((stop_pos - start_pos) / percentage) + start_pos
    object:setWorldPosition(w_pos)
end

function on_finish_robin_castle_countdown(time_delta, animation)
    boss_fight_robin_castle.bossfight:deactivate()
end
                               
robin_castle_sections = {{parapet =  {"robin_castle_parapet_01", "robin_castle_parapet_06", "robin_castle_parapet_11", "robin_castle_pillar_14", "robin_castle_pillar_20"},
                           undamaged = {"robin_castle_wall_01", "robin_castle_wall_09", "robin_castle_wall_10"},
                           damaged_1 = {"robin_castle_broken_01_01", "robin_castle_broken_01_09", "robin_castle_broken_01_10"},
                           damaged_2 = {"robin_castle_broken_02_01", "robin_castle_broken_02_09", "robin_castle_broken_02_10"},
                           rubble_spawn = "robin_castle_rubble_01"},
                          {parapet =  {"robin_castle_parapet_02", "robin_castle_parapet_07"},
                           undamaged = {"robin_castle_wall_02", "robin_castle_wall_08", "robin_castle_wall_13"},
                           damaged_1 = {"robin_castle_broken_01_02", "robin_castle_broken_01_08", "robin_castle_broken_01_11"},
                           damaged_2 = {"robin_castle_broken_02_02", "robin_castle_broken_02_08", "robin_castle_broken_02_11"},
                           rubble_spawn = "robin_castle_rubble_02"},
                          {parapet = {"robin_castle_parapet_03", "robin_castle_parapet_10"},
                           undamaged = {"robin_castle_wall_16", "robin_castle_wall_11", "robin_castle_wall_12", "robin_castle_wall_14"},
                           damaged_1 = {"robin_castle_door_portcullis_3", "robin_castle_broken_01_12", "robin_castle_broken_01_13"},
                           damaged_2 = {"robin_castle_door_wood_6", "robin_castle_broken_02_12", "robin_castle_broken_02_13"},
                           rubble_spawn = "robin_castle_rubble_05"},
                          {parapet =  {"robin_castle_parapet_04", "robin_castle_parapet_08"},
                           undamaged = {"robin_castle_wall_03", "robin_castle_wall_07", "robin_castle_wall_15"},
                           damaged_1 = {"robin_castle_broken_01_03", "robin_castle_broken_01_07", "robin_castle_broken_01_14"},
                           damaged_2 = {"robin_castle_broken_02_03", "robin_castle_broken_02_07", "robin_castle_broken_02_14"},
                           rubble_spawn = "robin_castle_rubble_03"},
                          {parapet =  {"robin_castle_parapet_05", "robin_castle_parapet_09", "robin_castle_parapet_12"},
                           undamaged = {"robin_castle_wall_04", "robin_castle_wall_05", "robin_castle_wall_06"},
                           damaged_1 = {"robin_castle_broken_01_04", "robin_castle_broken_01_05", "robin_castle_broken_01_06"},
                           damaged_2 = {"robin_castle_broken_02_04", "robin_castle_broken_02_05", "robin_castle_broken_02_06"},
                           rubble_spawn = "robin_castle_rubble_04"}
}                           

function castle_section_smoke(section)
    for _, wall_id in ipairs(robin_castle_sections[section].undamaged) do
        local smoke_wall = findEntity(wall_id)
        smoke_wall.smoke:enable()        
    end
end

function castle_section_flames(section)
    local rubble_spawner = findEntity(robin_castle_sections[section].rubble_spawn)
    rubble_spawner:spawn("wall_fire")
    for _, wall_id in ipairs(robin_castle_sections[section].undamaged) do
        local fire_wall = findEntity(wall_id)
        fire_wall.flames:enable()
    end
end

function castle_section_damage_1(section)
    for _, wall_id in ipairs(robin_castle_sections[section].undamaged) do
        local wall = findEntity(wall_id)
        wall.model:disable()
        if wall.occluder ~= nil then
            wall.occluder:disable()
        end
    end
    for _, wall_id in ipairs(robin_castle_sections[section].parapet) do
        local wall = findEntity(wall_id)
        wall.model:disable()
        if wall.occluder ~= nil then
            wall.occluder:disable()
        end
    end
    for _, wall_id in ipairs(robin_castle_sections[section].damaged_1) do
        local wall = findEntity(wall_id)
        wall.model:enable()
        if wall.occluder ~= nil then
            wall.occluder:enable()
        end
    end
end

function castle_section_damage_2(section)
    for _, wall_id in ipairs(robin_castle_sections[section].damaged_1) do
        local wall = findEntity(wall_id)
        wall.model:disable()
        if wall.occluder ~= nil then
            wall.occluder:disable()
        end
    end
    for _, wall_id in ipairs(robin_castle_sections[section].damaged_2) do
        local wall = findEntity(wall_id)
        wall.model:enable()
        if wall.occluder ~= nil then
            wall.occluder:enable()
        end
    end        
end

function castle_section_rubble(section)    
    local rubble_spawner = findEntity(robin_castle_sections[section].rubble_spawn)
    global_scripts.script.playSoundAtObject("gun_shot_cannon", rubble_spawner)
    rubble_spawner:spawn("mine_floor_sandpile")
    rubble_spawner:destroyDelayed()
    for _, wall_id in ipairs(robin_castle_sections[section].undamaged) do
        local smoke_fire_wall = findEntity(wall_id)
        smoke_fire_wall:destroyDelayed()
    end
    for _, wall_id in ipairs(robin_castle_sections[section].damaged_1) do
        local wall = findEntity(wall_id)
        wall:destroyDelayed()
    end
    for _, wall_id in ipairs(robin_castle_sections[section].damaged_2) do
        local wall = findEntity(wall_id)
        wall:destroyDelayed()
    end
end

function damage_castle(percentage)
    if percentage <= 0.9 and percentage > 0.8 then
        castle_section_smoke(1)
    elseif percentage <= 0.8 and percentage > 0.7 then
        castle_section_flames(1)
        castle_section_smoke(5)
    elseif percentage <= 0.7 and percentage > 0.6 then
        castle_section_damage_1(1)        
        castle_section_flames(5)
        castle_section_smoke(2)                
    elseif percentage <= 0.6 and percentage > 0.5 then
        castle_section_damage_2(1)
        castle_section_damage_1(5)
        castle_section_flames(2)
        castle_section_smoke(4)
    elseif percentage <= 0.5 and percentage > 0.4 then
        castle_section_rubble(1)
        castle_section_damage_2(5)
        castle_section_damage_1(2)
        castle_section_flames(4)
        castle_section_smoke(3)
    elseif percentage <= 0.4 and percentage > 0.3 then
        castle_section_rubble(5)
        castle_section_damage_2(2)
        castle_section_damage_1(4)
        castle_section_flames(3) 
    elseif percentage <= 0.3 and percentage > 0.2 then
        castle_section_rubble(2)
        castle_section_damage_2(4)
        castle_section_damage_1(3)
    elseif percentage <= 0.2 and percentage > 0.1 then
        castle_section_rubble(4)
        castle_section_damage_2(3)
    elseif percentage <= 0.2 then
        castle_section_rubble(3)
    end
end

function robin_castle_countdown(time_delta, animation)
    local monster = findEntity(animation.monster_id)
    local monster_health = monster.monster:getHealth() - animation.health_tick
    if monster_health > 0 then
        monster.monster:setHealth(monster_health)
        if animation.health_tick_stages[1] ~= nil and monster_health <= animation.health_tick_stages[1] then
            table.remove(animation.health_tick_stages, 1)
            damage_castle(monster_health / animation.starting_health)
        end
    else    
        animation.elapsed = animation.duration+animation.step
    end
end

ratling_types = {"ratling1", "ratling2", "ratling3", "rat_swarm"}

function robin_castle_spawn_ratling(time_delta, animation)
    local ratling_boss = findEntity(animation.spawn_at)
    if ratling_boss ~= nil then
        animation.duration = -1
    else
        local ratling_type = ratling_types[math.random(#ratling_types)]    
        ratling_boss:spawn(ratling_type)
    end
end

function robinAtTheCastle(trigger)
    local monster = findEntity("robin_castle_ogre").monster
    boss_fight_robin_castle.bossfight:addMonster(monster)    
    boss_fight_robin_castle.bossfight:activate()    local countdown_animation = {func=robin_castle_countdown, on_finish=on_finish_robin_castle_countdown, step=.1, duration=250000, elapsed=0, last_called=-1, starting_health=5000, health_tick=10, monster_id="robin_castle_ogre", health_tick_stages = {4500, 4000, 3500, 3000, 2500, 2000, 1500, 1000, 500}}
    global_scripts.script.add_animation(boss_fight_robin_castle.level, countdown_animation)
    
    local spawner = findEntity("spawn_robin_castle_1")
    ratling_boss = spawner:spawn("ratling_boss")    
    spawner = findEntity("spawn_robin_castle_2")
    spawner:spawn("forest_ogre")
    spawner = findEntity("spawn_robin_castle_3")
    spawner:spawn("fire_elemental")    
    spawner:spawn("ratling1")

    local ratling_boss_spawn_animation = {func=robin_castle_spawn_ratling, on_finish=nil, step=10, duration=250000, elapsed=0, last_called=-1, spawn_at=ratling_boss.id}
    global_scripts.script.add_animation(boss_fight_robin_castle.level, ratling_boss_spawn_animation)
end

function robinDigUpTreasure(trigger)
    trigger.go:spawn("dig_hole")
    local chest = trigger.go:spawn("chest")    
    for _,treasure_type in ipairs({"red_gem", "figure_skeleton"}) do
        local treasure = spawn(treasure_type)
        chest.surface:addItem(treasure.item)
    end
end

function robinAfterTheForest(trigger)
    
end

function onFinishRobinInTheForest()
    boss_fight_robin_forest.bossfight:deactivate()
    start_lite_up_pushblock_floor("pushblock_trigger_r12")
    local oaks_w_pos = forest_oak_cluster_2:getWorldPosition()
    local start_pos = {x=oaks_w_pos.x, y=oaks_w_pos.y, z=oaks_w_pos.z}
    local stop_pos = {x=oaks_w_pos.x, y=oaks_w_pos.y-9, z=oaks_w_pos.z}
    local on_finish_pos = {x=forest_oak_cluster_2.x, y=forest_oak_cluster_2.y, facing=forest_oak_cluster_2.facing, elevation=forest_oak_cluster_2.elevation-3, level=forest_oak_cluster_2.level}
    local animation = {func=lower_object, on_finish=finish_lower_object, step=0.05, duration=2, elapsed=0, last_called=-1, start_pos=start_pos, stop_pos=stop_pos, on_finish_pos=on_finish_pos, object_id="forest_oak_cluster_2"}
    global_scripts.script.add_animation(forest_oak_cluster_2.level, animation)
end

robin_monsters_forest = {"fjeld_warg_1", "fjeld_warg_2", "fjeld_warg_3", "fjeld_warg_4"}

function robinInTheForest(trigger)
    pushblock_trigger_r11.controller:deactivate()
    pushblock_trigger_r11.light:enable()
    robin_counter_forest.counter:setValue(#robin_monsters_forest)
    for _,monster_id in ipairs(robin_monsters_forest) do
        local monster = findEntity(monster_id)
        boss_fight_robin_forest.bossfight:addMonster(monster.monster)
        monster.brain:enable()
    end
    boss_fight_robin_forest.bossfight:activate()
end

function robinAtTheBridge(trigger)
    global_scripts.script.faceObject(pushblock_robin, 0)
    global_scripts.script.spawnAtObject("magma_golem_meteor_impact_ground", robin_magma_golem_spawn)
    local magma_golem = global_scripts.script.spawnAtObject("magma_golem", robin_magma_golem_spawn)
    local meteorite = spawn("meteorite").item
    magma_golem.monster:addItem(meteorite) 
    trigger:disable()
    if pushblock_floors[trigger.go.id]["off"] ~= nil then
        for _,pushblock_floor_id in ipairs(pushblock_floors[trigger.go.id]["off"]) do            
            local pushblock_floor = findEntity(pushblock_floor_id)
            pushblock_floor.controller:deactivate()
            pushblock_floor.light:enable()
        end
    end
end

function reset_sir_robin()
    global_scripts.script.moveObjectToObject(pushblock_robin, robin_start)
end

function wrongMove()
    hudPrint("You chose poorly.")
    global_scripts.script.spawnAtObject("shockburst", party, nil, 0, 0, 0)
    local damage_flags = DamageFlags.CameraShake
    damageTile(party.level, party.x, party.y, party.facing, party.elevation, damage_flags, "shock", 10)
    hudPrint("Though he never forgot his farming origins, neither did he ever return to them.")
    local animation = {func=nil, on_finish=reset_sir_robin, step=0.7, duration=0.8, elapsed=0, last_called=-1} -- wait till the pushblock miovng finishes movbing pushblock_robin before teleporting him
    global_scripts.script.add_animation(pushblock_robin.level, animation)
    pushblock_trigger_rs3.controller:deactivate()
    pushblock_trigger_rs3.light:enable()
end

function start_journey(state_data)
    for _, pushblock_floor in ipairs(pushblock_floors["start"]) do
        start_lite_up_pushblock_floor(pushblock_floor, false)
    end    
    return state_data.next_state
end

function rats_defeated(state_data)
    return state_data.next_state
end

function count_farming(state_data)
    state_data.count = state_data.count - 1
    hudPrint(tostring(state_data.count))
    if state_data.count == 0 then
        return state_data.next_state
    else
        return state
    end
end

morning = 0
noon = 0.5
evening = 1
midnight = 1.5
maxtime = 1.99 -- this then becomes morning
onehour = 1/12

time_of_day = 1.5
keep_time_of_day = true

step = 0.05
tick = 0.1

time_control_levers = {"robin_timeofday_lever_morning", "robin_timeofday_lever_noon", "robin_timeofday_lever_evening", "robin_timeofday_lever_midnight"}

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

function goTilMorning(lever)
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
    global_scripts.script.add_animation(lever.go.level, animation)
end

function goTilNoon(lever)
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
    global_scripts.script.add_animation(lever.go.level, animation)
end

function goTilEvening(lever)
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
    global_scripts.script.add_animation(lever.go.level, animation)
end

function goTilMidnight(lever)
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
    global_scripts.script.add_animation(lever.go.level, animation)
end

function onPutItem(surface, item)
    hudPrint(item.go.name)
    hudPrint(tostring(surface:count()))
    local state_data = states[state][item.go.name]
    if state_data == nil then
        return
    end
    state = state_data.func(state_data)
    hudPrint(state)
end

function enterTheTrials()
    trials_robin_forest_sky.sky:setFogRange({1,1}) 
end

state = "bandits" 
states = {["initial"] = {["blooddrop_cap"] = {func = count_farming, next_state = "rat_plague", count = 5}},
          ["rat_plague"] = {["rat_shank"] = {func = rats_defeated, next_state = "bandits"}},
          ["bandits"] = {["spiked_club"] = {func = start_journey, next_state = "init_journey"}}}