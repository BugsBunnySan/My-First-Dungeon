-- {"pushblock_floor_r1", "pushblock_floor_r2", "pushblock_floor_rs1", "pushblock_floor_rs2", "pushblock_floor_rs3", "pushblock_floor_trigger_rs4", "pushblock_floor_trigger_r5", "pushblock_floor_trigger_r0", "pushblock_floor_trigger_r12"},

pushblock_floors = {["start"] = {"pushblock_trigger_robin_start", "pushblock_trigger_r1", "pushblock_trigger_rs1"},
                    ["pushblock_trigger_rs1"] = {on = {"pushblock_trigger_rs2"}, off = nil},
                    ["pushblock_trigger_rs2"] = {on = {"pushblock_trigger_rs3"}, off = {"pushblock_trigger_rs1"}},
                    ["pushblock_trigger_rs3"] = {on = {"pushblock_trigger_robin_home"}, off = {"pushblock_trigger_rs2"}},
                    ["pushblock_trigger_r1"] = {on = {"pushblock_trigger_r2"}, off = nil},
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
}

pushblock_floor_triggered = {}

function finish_lite_up_pushblock_floor(time_delta, animation)
    local pushblock_floor = findEntity(animation.pushblock_floor_id)
    pushblock_floor.controller:activate()    
    if pushblock_floors[animation.pushblock_floor_id] ~= nil and pushblock_floors[animation.pushblock_floor_id]["off"] ~= nil then
        for _,pushblock_floor_id in ipairs(pushblock_floors[animation.pushblock_floor_id]["off"]) do
            hudPrint("disable "..pushblock_floor_id)
            local pushblock_floor = findEntity(pushblock_floor_id)
            pushblock_floor.controller:deactivate()
            pushblock_floor.light:enable()
        end
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

function start_lite_up_pushblock_floor(pushblock_floor_id)   
    local pushblock_floor = findEntity(pushblock_floor_id)
    pushblock_floor.light:setBrightness(0)
    pushblock_floor.light:enable()
    local animation = {func=lite_up_pushblock_floor, on_finish=finish_lite_up_pushblock_floor, step=0.05, duration=1, elapsed=0, last_called=-1, pushblock_floor_id=pushblock_floor.id, light_level=35}
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
            start_lite_up_pushblock_floor(pushblock_floor_id)
        end
    end
end

function finish_raise_bridge(time_delta, animation)
    local bridge = findEntity(animation.bridge_id)    
    bridge:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    start_lite_up_pushblock_floor(animation.pushblock_trigger_id)
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
    local magma_golem = global_scripts.script.spawnAtObject("magma_golem", robin_magma_golem_spawn)
    local meteorite = spawn("meteorite").item
    magma_golem.monster:addItem(meteorite) 
    trigger:disable()
    if pushblock_floors[trigger.go.id]["off"] ~= nil then
        for _,pushblock_floor_id in ipairs(pushblock_floors[trigger.go.id]["off"]) do
            hudPrint("disable "..pushblock_floor_id)
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
    hudPrint("Though he never did forget his farming origins, neither did he ever return to them.")
    local animation = {func=nil, on_finish=reset_sir_robin, step=0.7, duration=0.8, elapsed=0, last_called=-1}
    global_scripts.script.add_animation(pushblock_robin.level, animation)
    pushblock_trigger_rs3.controller:deactivate()
    pushblock_trigger_rs3.light:enable()
end

function start_journey(state_data)
    for _, pushblock_floor in ipairs(pushblock_floors["start"]) do
        start_lite_up_pushblock_floor(pushblock_floor)
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