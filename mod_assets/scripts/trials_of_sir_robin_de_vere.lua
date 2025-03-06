pushblock_floors = {["start"] = {"pushblock_trigger_robin_start", "pushblock_trigger_r1", "pushblock_trigger_rs1"},
                    ["pushblock_trigger_rs1"] = {on = {"pushblock_trigger_rs2"}, off = nil},
                    ["pushblock_trigger_rs2"] = {on = {"pushblock_trigger_rs3"}, off = {"pushblock_trigger_rs1"}},
                    ["pushblock_trigger_rs3"] = {on = {"pushblock_trigger_rs4"}, off = {"pushblock_trigger_rs2"}},
                    ["pushblock_trigger_rs4"] = {on = {"pushblock_trigger_robin_home"}, off = {"pushblock_trigger_rs3"}},
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
                    ["pushblock_trigger_r12"] = {on = {"pushblock_trigger_r13"}, off = nil},
                    ["pushblock_trigger_r13"] = {on = {"pushblock_trigger_r14"}, off = {"pushblock_trigger_r12"}},
                    ["pushblock_trigger_r14"] = {on = {"pushblock_trigger_r15"}, off = {"pushblock_trigger_r13"}},
                    ["pushblock_trigger_r15"] = {on = {"pushblock_trigger_r16"}, off = {"pushblock_trigger_r14"}},
                    ["pushblock_trigger_r16"] = {on = {"pushblock_trigger_r17"}, off = {"pushblock_trigger_r15"}},
                    ["pushblock_trigger_r17"] = {on = {"pushblock_trigger_robin_after_forest"}, off = {"pushblock_trigger_r16"}},
                    ["pushblock_trigger_robin_after_forest"] = {on = {"pushblock_trigger_r99", "pushblock_trigger_r18"}, off = {"pushblock_trigger_r17"}},
                    ["pushblock_trigger_r18"] = {on = {"pushblock_trigger_r19"}, off = {"pushblock_trigger_r99"}},
                    ["pushblock_trigger_r19"] = {on = {"pushblock_trigger_r20"}, off = {"pushblock_trigger_r18"}},
                    ["pushblock_trigger_r20"] = {on = {"pushblock_trigger_robin_treasure_hunt"}, off = {"pushblock_trigger_r19"}},  
                    ["pushblock_trigger_robin_treasure_hunt"] = {on = {"pushblock_trigger_r21"}, off = {"pushblock_trigger_r20"}}, 
                    ["pushblock_trigger_r21"] = {on = {"pushblock_trigger_r22"}, off = nil},  
                    ["pushblock_trigger_r22"] = {on = {"pushblock_trigger_r23"}, off = {"pushblock_trigger_r21"}},    
                    ["pushblock_trigger_r23"] = {on = {"pushblock_trigger_r24"}, off = {"pushblock_trigger_r22"}},                   
                    ["pushblock_trigger_r24"] = {on = {"pushblock_trigger_r25"}, off = {"pushblock_trigger_r22"}},                   
                    ["pushblock_trigger_r25"] = {on = {"pushblock_trigger_r26"}, off = {"pushblock_trigger_r23"}},                    
                    ["pushblock_trigger_r26"] = {on = {"pushblock_trigger_r27"}, off = {"pushblock_trigger_r24"}},                    
                    ["pushblock_trigger_r27"] = {on = {"pushblock_trigger_r28"}, off = {"pushblock_trigger_r25"}},                    
                    ["pushblock_trigger_r28"] = {on = {"pushblock_trigger_r29"}, off = {"pushblock_trigger_r26"}},                    
                    ["pushblock_trigger_r29"] = {on = {"pushblock_trigger_r30"}, off = {"pushblock_trigger_r27"}},                    
                    ["pushblock_trigger_r30"] = {on = {"pushblock_trigger_robin_castle"}, off = {"pushblock_trigger_r28"}},     
                    ["pushblock_trigger_robin_castle"] = {on = {"pushblock_trigger_r31"}, off = {"pushblock_trigger_r30"}},    
                    ["pushblock_trigger_r31"] = {on = {"pushblock_trigger_r32"}, off = nil},                   
                    ["pushblock_trigger_r32"] = {on = {"pushblock_trigger_r33"}, off = {"pushblock_trigger_r31"}},                   
                    ["pushblock_trigger_r33"] = {on = {"pushblock_trigger_r34"}, off = {"pushblock_trigger_r32"}},                    
                    ["pushblock_trigger_r34"] = {on = {"pushblock_trigger_r35"}, off = {"pushblock_trigger_r33"}},                    
                    ["pushblock_trigger_r35"] = {on = {"pushblock_trigger_r36"}, off = {"pushblock_trigger_r34"}},                    
                    ["pushblock_trigger_r36"] = {on = {"pushblock_trigger_r37"}, off = {"pushblock_trigger_r35"}},                    
                    ["pushblock_trigger_r37"] = {on = {"pushblock_trigger_r38"}, off = {"pushblock_trigger_r36"}},    
                    ["pushblock_trigger_r38"] = {on = {"pushblock_trigger_r39"}, off = {"pushblock_trigger_r37"}},                   
                    ["pushblock_trigger_r39"] = {on = {"pushblock_trigger_r40"}, off = {"pushblock_trigger_r38"}},                    
                    ["pushblock_trigger_r40"] = {on = {"pushblock_trigger_r41"}, off = {"pushblock_trigger_r39"}},                    
                    ["pushblock_trigger_r41"] = {on = {"pushblock_trigger_in_the_desert"}, off = {"pushblock_trigger_r40"}},                    
                    ["pushblock_trigger_in_the_desert"] = {on = {"pushblock_trigger_r43"}, off = {"pushblock_trigger_r41"}},                    
                    ["pushblock_trigger_r43"] = {on = {"pushblock_trigger_r44"}, off = nil},                     
                    ["pushblock_trigger_r44"] = {on = {"pushblock_trigger_r45"}, off = {"pushblock_trigger_r43"}},                    
                    ["pushblock_trigger_r45"] = {on = {"pushblock_trigger_r46"}, off = {"pushblock_trigger_r44"}},                    
                    ["pushblock_trigger_r46"] = {on = {"pushblock_trigger_r47"}, off = {"pushblock_trigger_r45"}},                    
                    ["pushblock_trigger_r47"] = {on = {"pushblock_trigger_robin_builds_castle"}, off = {"pushblock_trigger_r46"}},                    
                    ["pushblock_trigger_robin_builds_castle"] = {on = nil, off = {"pushblock_trigger_r47"}},                                                         
}

pushblock_floor_trigger_push = {["pushblock_trigger_rs1"] = true, ["pushblock_trigger_r1"] = true, ["pushblock_trigger_r21"] = true, ["pushblock_trigger_r35"] = true, ["pushblock_trigger_r31"] = true, ["pushblock_trigger_r21"] = true, ["pushblock_trigger_r43"] = true}

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
    trigger:disable()
    local push = false
    if pushblock_robin.facing ~= trigger.go.facing then
        pushblock_robin:setPosition(pushblock_robin.x, pushblock_robin.y, trigger.go.facing, pushblock_robin.elevation, pushblock_robin.level)
        push = pushblock_floor_trigger_push[trigger.go.id]
    else
        push = true
    end
    if pushblock_floors[trigger.go.id] ~= nil and pushblock_floors[trigger.go.id]["on"] ~= nil then       
        for _,pushblock_floor_id in ipairs(pushblock_floors[trigger.go.id]["on"]) do
            if pushblock_floor_triggered[pushblock_floor_id] == nil then
                pushblock_floor_triggered[pushblock_floor_id] = true                      
                start_lite_up_pushblock_floor(pushblock_floor_id, push, pushblock_floors[trigger.go.id]["off"])
            end
        end
    end 
end

function finish_raise_bridge(time_delta, animation)
    local bridge = findEntity(animation.bridge_id)    
    bridge:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    if animation.pushblock_trigger_id ~= nil then
        start_lite_up_pushblock_floor(animation.pushblock_trigger_id)  
        global_scripts.script.faceObject(pushblock_robin, 1)                
    end
end

function raise_bridge(time_delta, animation)
    local bridge = findEntity(animation.bridge_id)
    local percentage = animation.elapsed / animation.duration 
    if animation.curve ~= nil then
        percentage = global_scripts.script.bezier(animation.curve, percentage)  
    end
    local start_pos = vec(animation.start_pos.x, animation.start_pos.y, animation.start_pos.z)
    local stop_pos = vec(animation.stop_pos.x, animation.stop_pos.y, animation.stop_pos.z)
    local w_pos = ((stop_pos - start_pos) * percentage) + start_pos 
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

function finish_plop_object(time_delta, animation)
    local object = findEntity(animation.object_id)    
    object:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    for entity in Dungeon.getMap(object.level):entitiesAt(object.x, object.y) do
        if entity.name == "forest_ground_01" then
            entity:destroyDelayed()           
        end
    end
    object:spawn(animation.on_finish_floor_type)
    object:destroyDelayed()
end

function plop_object(time_delta, animation)
    local object = findEntity(animation.object_id)
    local percentage = (2*(animation.elapsed / animation.duration)) - 1
    
    local dy = ((-1 * (percentage * percentage)) + 1) * animation.height
    
    local w_pos = vec(animation.start_pos.x, animation.start_pos.y+dy, animation.start_pos.z)
    
    object:setWorldPosition(w_pos)
end

function finish_slam_object(time_delta, animation)
    local object = findEntity(animation.object_id)    
    object:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    global_scripts.script.playSoundAtObject("pressure_plate_pressed_loud", object)                           
    
    local forest_door = object:spawn("forest_ruins_secret_door")
    forest_door.model:disable()
end

function slam_object(time_delta, animation)
    local object = findEntity(animation.object_id)
    local percentage = animation.elapsed / animation.duration
    percentage = percentage * percentage
    
    local dx = animation.dx * percentage
    local dy = animation.dy * percentage
    local dz = animation.dz * percentage
    
    local w_pos = vec(animation.start_pos.x + dx, animation.start_pos.y + dy, animation.start_pos.z + dz)
    
    object:setWorldPosition(w_pos)
end

function finish_move_object(time_delta, animation)
    local object = findEntity(animation.object_id)    
    object:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
end

function move_object(time_delta, animation)
    local object = findEntity(animation.object_id)
    local percentage = animation.duration / animation.elapsed
    local start_pos = vec(animation.start_pos.x, animation.start_pos.y, animation.start_pos.z)
    local stop_pos = vec(animation.stop_pos.x, animation.stop_pos.y, animation.stop_pos.z)
    local w_pos = ((stop_pos - start_pos) / percentage) + start_pos
    object:setWorldPosition(w_pos)
end

castle_of_caral = {well = {"castle_carral_well_cover"},
                   walls = {"robin_castle_spawn_wall_15", "robin_castle_spawn_wall_16",
                            "robin_castle_spawn_wall_01", "robin_castle_spawn_wall_02", "robin_castle_spawn_wall_03", "robin_castle_spawn_wall_04",
                            "robin_castle_spawn_wall_05", "robin_castle_spawn_wall_06", "robin_castle_spawn_wall_07", "robin_castle_spawn_wall_08",
                            "robin_castle_spawn_wall_09", "robin_castle_spawn_wall_10", "robin_castle_spawn_wall_11", "robin_castle_spawn_wall_12",
                            "robin_castle_spawn_wall_13", "robin_castle_spawn_wall_14"
                   },
                   ceilings = {"castle_bridge_robin_01", "castle_bridge_robin_02", "castle_bridge_robin_03", "castle_bridge_robin_04",
                               "castle_bridge_robin_05", "castle_bridge_robin_06", "castle_bridge_robin_07", "castle_bridge_robin_08",
                               "castle_bridge_robin_09", "castle_bridge_robin_10", "castle_bridge_robin_11"},
                   pillars = {"tomb_pillar_robin_castle_se", "tomb_pillar_robin_castle_sw", "tomb_pillar_robin_castle_ne", "tomb_pillar_robin_castle_nw",
                              "tomb_pillar_robin_castle_01", "tomb_pillar_robin_castle_02", "tomb_pillar_robin_castle_03", "tomb_pillar_robin_castle_04",
                              "tomb_pillar_robin_castle_05", "tomb_pillar_robin_castle_06", "tomb_pillar_robin_castle_07", "tomb_pillar_robin_castle_08", 
                              "tomb_pillar_robin_castle_09", "tomb_pillar_robin_castle_10", "tomb_pillar_robin_castle_11", "tomb_pillar_robin_castle_12",
                   },
                   domes = {entrances = {"dome_robin_castle_s","dome_robin_castle_e", "dome_robin_castle_w", "dome_robin_castle_n"},
                            towers = {"dome_robin_castle_sw", "dome_robin_castle_se", "dome_robin_castle_nw", "dome_robin_castle_ne"}
                   },
                   pedestals = {"robin_castle_pedestal_se", "robin_castle_pedestal_sw", "robin_castle_pedestal_ne", "robin_castle_pedestal_nw"}}
castle_of_caral_virtues = {tome_health = 1,
                           tome_energy = 1,
                           tome_leadership = 1,
                           tome_wisdom = 1,
                           count = 4}
castle_of_caral_build_order = {"well", "floor_cover", "pillars", "walls", "ceilings", "towers"}

function spawn_floor(animation)
    local floor_tile = spawn(animation.floor_type)
    floor_tile:setPosition(animation.spawn_pos.x, animation.spawn_pos.y, animation.spawn_pos.facing, animation.spawn_pos.elevation, animation.spawn_pos.level)
    floor_tile:spawn("teleportation_effect")
    animation.object_id = floor_tile.id    
    if animation.sound ~= nil then
        global_scripts.script.playSoundAtObject(animation.sound, floor_tile)
    end
end

function make_floor_animation(middle_pos, middle_w_pos, x, y, height, delay, floor_type, on_finish_floor_type, sound)
    local spawn_pos = {x=middle_pos.x - 2 + x, y=middle_pos.y - 2 + y, facing=middle_pos.facing, elevation=middle_pos.elevation, level=middle_pos.level}
    local start_pos = {x=middle_w_pos.x - 6 + 3*x, y=middle_w_pos.y, z=middle_w_pos.z + 6 - 3*y}
    local stop_pos = {x=middle_w_pos.x - 6 + 3*x, y=middle_w_pos.y, z=middle_w_pos.z + 6 - 3*y}
    local on_finish_pos = {x=middle_pos.x - 2 + x, y=middle_pos.y - 2 + y, facing=middle_pos.facing, elevation=middle_pos.elevation, level=middle_pos.level}
    local animation = {on_start=spawn_floor, func=plop_object, on_finish=finish_plop_object, step=0.05, duration=1, delay=delay, start_pos=start_pos, height=height, spawn_pos=spawn_pos, on_finish_pos=on_finish_pos, floor_type=floor_type, on_finish_floor_type=on_finish_floor_type, sound=sound}
    return animation
end

function finish_floors(time_delta, animation)
    finish_plop_object(time_delta, animation)
    grow_pillars(animation.well_of_caral_id)
end

function lay_floors(well_of_caral)
    local well_of_caral_pos = {x=well_of_caral.x, y=well_of_caral.y, facing=well_of_caral.facing, elevation=well_of_caral.elevation, level=well_of_caral.level}
    local well_of_caral_w_pos = well_of_caral:getWorldPosition()   

    local animations = {}
    
    local delay = 2.2
    local animation = make_floor_animation(well_of_caral_pos, well_of_caral_w_pos, 2, 2, 1, delay, "castle_bridge_grating", "castle_bridge_grating", "water_hit_large_loud")
    table.insert(animations, animation)   
    delay = 2.6
    for _, xy in ipairs({{1,1}, {2,1}, {3,1}, {1,2}, {3,2}, {1,3}, {2,3}, {3,3}}) do
        local x, y = xy[1],xy[2] 
        local animation = make_floor_animation(well_of_caral_pos, well_of_caral_w_pos, x, y, 0.7, delay, "castle_bridge_grating", "tomb_floor_01")
        table.insert(animations, animation)           
    end
    delay = 3
    for _,xy in ipairs({{0,0}, {1,0}, {2,0}, {3,0}, {4,0}, {0,1}, {4,1}, {0,2}, {4,2}, {0,3}, {4,3}, {0,4}, {1,4}, {2,4}, {3,4}}) do
        local x, y = xy[1],xy[2]
        --print(tostring(x).." "..tostring(y))
        local animation = make_floor_animation(well_of_caral_pos, well_of_caral_w_pos, x, y, 0.3, delay, "castle_bridge_grating", "tomb_floor_01")
        table.insert(animations, animation)        
    end
    
    local animation = make_floor_animation(well_of_caral_pos, well_of_caral_w_pos, 4, 4, 0.3, delay, "castle_bridge_grating", "tomb_floor_01")
    animation.well_of_caral_id = well_of_caral.id
    animation.on_finish=finish_floors
    table.insert(animations, animation)        
    
    for _,a in ipairs(animations) do
        global_scripts.script.add_animation(well_of_caral.level, a)
    end
end

function finish_grow_pillars(time_delta, animation)
    finish_raise_bridge(time_delta, animation)
    fly_in_walls(animation.well_of_caral_id)
end

function grow_pillars(well_of_caral_id)
    local well_of_caral = findEntity(well_of_caral_id)
    local animation
    local animations = {}
    for _, entrance_dome_id in ipairs(castle_of_caral["domes"]["entrances"]) do
        animation = raisePedestal(entrance_dome_id, true)
        animation.sound_name = "water_hit_small"
        table.insert(animations, animation)
    end
    for _, tower_dome_id in ipairs(castle_of_caral["domes"]["towers"]) do
        animation = raisePedestal(tower_dome_id, true)
        animation.sound_name = "water_hit_small"
        table.insert(animations, animation)
    end
    
    for _, pillar_id in ipairs(castle_of_caral["pillars"]) do
        animation = raisePedestal(pillar_id, true)
        animation.sound_name = "viper_root_rise"
        animation.delay = 3
        table.insert(animations, animation)
    end
    for _, ceiling_id in ipairs(castle_of_caral["ceilings"]) do
        animation = raisePedestal(ceiling_id, true)
        animation.sound_name = nil
        animation.delay = 3
        table.insert(animations, animation)
    end
    for _, entrance_dome_id in ipairs(castle_of_caral["domes"]["entrances"]) do
        animation = raisePedestal(entrance_dome_id, true)
        animation.delay = 3
        animation.start_pos.y = animation.start_pos.y + 3
        animation.on_finish_pos.elevation = animation.on_finish_pos.elevation + 1
        animation.stop_pos.y = animation.stop_pos.y + 3
        table.insert(animations, animation)
    end
    for _, tower_dome_id in ipairs(castle_of_caral["domes"]["towers"]) do
        animation = raisePedestal(tower_dome_id, true)
        animation.delay = 3
        animation.start_pos.y = animation.start_pos.y + 3
        animation.stop_pos.y = animation.stop_pos.y + 3
        animation.on_finish_pos.elevation = animation.on_finish_pos.elevation + 1
        table.insert(animations, animation)
    end
    
    
    for _, ceiling_id in ipairs(castle_of_caral["ceilings"]) do
        animation = raisePedestal(ceiling_id, true)
        animation.sound_name = nil
        animation.delay = 6
        animation.start_pos.y = animation.start_pos.y + 3
        animation.stop_pos.y = animation.stop_pos.y + 3
        animation.on_finish_pos.elevation = animation.on_finish_pos.elevation + 1
        table.insert(animations, animation)
    end
    for _, tower_dome_id in ipairs(castle_of_caral["domes"]["towers"]) do
        animation = raisePedestal(tower_dome_id, true)
        animation.delay = 6
        animation.start_pos.y = animation.start_pos.y + 6
        animation.stop_pos.y = animation.stop_pos.y + 6
        animation.on_finish_pos.elevation = animation.on_finish_pos.elevation + 2
        table.insert(animations, animation)
    end
    
    animation = raisePedestal("castle_bridge_robin_12", true)
    animation.sound_name = nil
    animation.delay = 6
    animation.start_pos.y = animation.start_pos.y + 3
    animation.stop_pos.y = animation.stop_pos.y + 3
    animation.on_finish_pos.elevation = animation.on_finish_pos.elevation + 1
    animation.on_finish = finish_grow_pillars
    animation.well_of_caral_id = well_of_caral.id
    table.insert(animations, animation)
    
    for _,a in ipairs(animations) do
        global_scripts.script.add_animation(well_of_caral.level, a)
    end
end

function spawn_wall(animation)
    local spawn_wall_marker = findEntity(animation.spawn_wall_marker_id)
    
    local wall = spawn_wall_marker:spawn("tomb_door_serpent")
    wall.door:disable()
    wall.controller:disable()
    wall:spawn("teleportation_effect")
    
    animation.object_id = wall.id
    animation.start_pos = wall:getWorldPosition()
    
    animation.on_finish_pos = {x=wall.x, y=wall.y, facing=wall.facing, elevation=wall.elevation, level=wall.level}
    animation.dx = 0
    animation.dy = 0
    animation.dz = 0
    if wall.facing == 0 then
        animation.dz = 3
        animation.on_finish_pos.y = animation.on_finish_pos.y - 1
    elseif wall.facing == 1 then
        animation.dx = 3
        animation.on_finish_pos.x = animation.on_finish_pos.x + 1
    elseif wall.facing == 2 then
        animation.dz = -3
        animation.on_finish_pos.y = animation.on_finish_pos.y + 1
    elseif wall.facing == 3 then        
        animation.dx = -3
        animation.on_finish_pos.x = animation.on_finish_pos.x - 1
    end    
end

function do_light_up_glow_light(dome_id)
    local dome = findEntity(dome_id)
    local glow_light = global_scripts.script.spawnAtObject("pushable_block_floor_trigger", dome, nil, nil, nil, 1)
    glow_light.model:disable()
    glow_light.controller:disable()
    glow_light.floortrigger:disable()
    glow_light.light:enable()
    glow_light.particle:enable()
end

function light_up_glow_light(animation)
    do_light_up_glow_light(animation.dome_id)
end

function light_up_well(animation)
    local well_of_caral = findEntity(animation.well_of_caral_id)
    local light = global_scripts.script.spawnAtObject("pushable_block_floor", well_of_caral)
    light.model:disable()
    light.controller:disable()
    light.light:enable()
    light.particle:enable()    
end

function finish_build_castle(animation)
    local well_of_caral = findEntity(animation.well_of_caral_id)    
    -- deactivate pushblock trigger, keep light ofc
    global_scripts.script.faceObject(pushblock_robin, 1)
    global_scripts.script.party_level_up_champions({1,2,3,4})
    goTilNoon(well_of_caral)    
end

function light_up(well_of_caral_id)
    local animations = {}
    local well_of_caral = findEntity(well_of_caral_id)
    
    local animation = {on_start=light_up_well, func=nil, on_finish=nil, step=1, duration=-1, delay=.5, well_of_caral_id=well_of_caral.id}
    table.insert(animations, animation)
    
    for _, entrance_dome_id in ipairs(castle_of_caral["domes"]["entrances"]) do
        animation = {on_start=light_up_glow_light, func=nil, on_finish=nil, step=1, duration=-1, delay=1, dome_id=entrance_dome_id}
        table.insert(animations, animation)
    end
    
    for _, tower_dome_id in ipairs(castle_of_caral["domes"]["towers"]) do
        animation = {on_start=light_up_glow_light, func=nil, on_finish=nil, step=1, duration=-1, delay=1.5, dome_id=tower_dome_id}
        table.insert(animations, animation)
    end
    
    animation = {on_start=finish_build_castle, func=nil, on_finish=nil, step=1, duration=-1, delay=2, dome_id=tower_dome_id}
    animation.well_of_caral_id = well_of_caral_id
    table.insert(animations, animation)
    
    for _,a in ipairs(animations) do
        global_scripts.script.add_animation(well_of_caral.level, a)
    end
end

function finish_fly_in_walls(time_delta, animation)
    finish_slam_object(time_delta, animation)
    light_up(animation.well_of_caral_id)
end

function fly_in_walls(well_of_caral_id)
    local well_of_caral = findEntity(well_of_caral_id)
    local delay = 0
    local animations = {}
    for _, spawn_wall_marker_id in ipairs(castle_of_caral["walls"]) do
        local animation = {on_start=spawn_wall, func=slam_object, on_finish=finish_slam_object, step=0.05, duration=1, delay=delay, spawn_wall_marker_id=spawn_wall_marker_id}
        table.insert(animations, animation)
        delay = delay + .2
    end
    
    local animation = {on_start=spawn_wall, func=slam_object, on_finish=finish_fly_in_walls, step=0.05, duration=1, delay=delay, spawn_wall_marker_id="robin_castle_spawn_wall_16"}
    animation.well_of_caral_id = well_of_caral_id
    table.insert(animations, animation)
    
    for _,a in ipairs(animations) do
        global_scripts.script.add_animation(well_of_caral.level, a)
    end 
end

function grow_towers(well_of_caral_id)
    local well_of_caral = findEntity(well_of_carals_id)
    for _, tower_id in ipairs(castle_of_caral["corner_towers"]) do
    
    end
end

function buildCastle()  
    --hudPrint("A gentle force moves you")
    --global_scripts.script.moveObjectToObject(party, robin_build_castle_observe)
    for _,pedestal_id in ipairs(castle_of_caral.pedestals) do
        local animation = raisePedestal(pedestal_id, true)
        animation.stop_pos.y = animation.stop_pos.y + - 6
        animation.on_finish_pos.elevation = animation.on_finish_pos.elevation - 2
        global_scripts.script.add_animation(well_of_caral.level, animation)     
    end
    playSound("blow_horn")    
    local well_of_caral = findEntity("well_of_caral")  
    lay_floors(well_of_caral)
end

function castleCornerStonePedestalOnInsertItem(pedestal, item)
    if castle_of_caral_virtues[item.go.name] == 1 then
        castle_of_caral_virtues[item.go.name] = nil
        castle_of_caral_virtues.count = castle_of_caral_virtues.count - 1
    end
    if castle_of_caral_virtues.count == 0 then
        buildCastle()
    end
end

function start_raise_pedestal(animation)
    if animation.sound_name == nil then
        return
    end
    local pedestal = findEntity(animation.bridge_id)
    global_scripts.script.playSoundAtObject(animation.sound_name, pedestal)    
end

function raisePedestal(pedestal_id, return_animation, direction)    
    local pedestal = findEntity(pedestal_id)
    local pedestal_w_pos = pedestal:getWorldPosition()
    
    direction = direction or 1
    
    local start_pos = {x=pedestal_w_pos.x, y=pedestal_w_pos.y, z=pedestal_w_pos.z}
    local stop_pos  = {x=pedestal_w_pos.x, y=pedestal_w_pos.y+(3 * direction), z=pedestal_w_pos.z}
    
    local curve = {p1 = {x=0, y=0},
                   p2 = {x=0.5,y=0},
                   p3 = {x=0.5,y=1},
                   p4 = {x=1, y=1}}

    local on_finish_pos = {x=pedestal.x, y=pedestal.y, facing=pedestal.facing, elevation=pedestal.elevation+direction, level=pedestal.level}
    local animation = {on_start=start_raise_pedestal, func=raise_bridge, on_finish=finish_raise_bridge, step=0.05, duration=2, delay=-1, start_pos=start_pos, stop_pos=stop_pos, bridge_id=pedestal.id, on_finish_pos=on_finish_pos, curve=curve, sound_name="gate_iron_open"}
    if return_animation then
        return animation
    else
        global_scripts.script.add_animation(pedestal.level, animation)
    end
end

function robinBuildsCastle(trigger)            
    pushblock_trigger_r47.controller:deactivate()
    pushblock_trigger_r47.light:enable()
    for _,pedestal_id in ipairs(castle_of_caral.pedestals) do
        raisePedestal(pedestal_id)
    end
end

desert_provisions = {bread = 1, water_flask = 1, count=2}

function desertProvisionsGiven()
    start_lite_up_pushblock_floor("pushblock_trigger_r43", false, {})
end

function onGiveDesertProvisions(pedestal, item)
    if desert_provisions[item.go.name] ~= nil then
        desert_provisions[item.go.name] = nil
        desert_provisions.count = desert_provisions.count - 1
    end
    if desert_provisions.count == 0 then
        desertProvisionsGiven()
    end
end

function inTheDesert(trigger)           
    pushblock_trigger_r41.controller:deactivate()
    pushblock_trigger_r41.light:enable()
    raisePedestal("pedestal_robin_desert_s")
    raisePedestal("pedestal_robin_desert_n")
end

function on_finish_robin_castle_countdown(time_delta, animation)
    boss_fight_robin_castle.bossfight:deactivate()
    liteUpPushblockFloorAnimation(pushblock_trigger_robin_castle.floortrigger)
end
                               
robin_castle_sections = {{parapet =  {"robin_castle_parapet_01", "robin_castle_parapet_02", "robin_castle_parapet_03", "robin_castle_pillar_03", "robin_castle_pillar_04"},
                           undamaged = {"robin_castle_wall_01", "robin_castle_wall_02", "robin_castle_wall_03"},
                           damaged_1 = {"robin_castle_broken_01_01", "robin_castle_broken_01_02", "robin_castle_broken_01_03"},
                           damaged_2 = {"robin_castle_broken_02_01", "robin_castle_broken_02_02", "robin_castle_broken_02_03"},
                           rubble_spawn = "robin_castle_rubble_01"},
                          {parapet =  {"robin_castle_parapet_04", "robin_castle_parapet_06"},
                           undamaged = {"robin_castle_wall_04", "robin_castle_wall_05", "robin_castle_wall_06"},
                           damaged_1 = {"robin_castle_broken_01_04", "robin_castle_broken_01_05", "robin_castle_broken_01_06"},
                           damaged_2 = {"robin_castle_broken_02_04", "robin_castle_broken_02_05", "robin_castle_broken_02_06"},
                           rubble_spawn = "robin_castle_rubble_02"},
                          {parapet = {"robin_castle_parapet_07", "robin_castle_parapet_09"},
                           undamaged = {"robin_castle_wall_07", "robin_castle_wall_08", "robin_castle_wall_09", "robin_castle_wall_10"},
                           damaged_1 = {"robin_castle_door_portcullis_3", "robin_castle_broken_01_08", "robin_castle_broken_01_10"},
                           damaged_2 = {"robin_castle_door_wood_6", "robin_castle_broken_02_08", "robin_castle_broken_02_10"},
                           rubble_spawn = "robin_castle_rubble_05"},
                          {parapet =  {"robin_castle_parapet_11", "robin_castle_parapet_13"},
                           undamaged = {"robin_castle_wall_11", "robin_castle_wall_12", "robin_castle_wall_13"},
                           damaged_1 = {"robin_castle_broken_01_11", "robin_castle_broken_01_12", "robin_castle_broken_01_13"},
                           damaged_2 = {"robin_castle_broken_02_11", "robin_castle_broken_02_12", "robin_castle_broken_02_13"},
                           rubble_spawn = "robin_castle_rubble_03"},
                          {parapet =  {"robin_castle_parapet_14", "robin_castle_parapet_15", "robin_castle_parapet_16"},
                           undamaged = {"robin_castle_wall_14", "robin_castle_wall_15", "robin_castle_wall_16"},
                           damaged_1 = {"robin_castle_broken_01_14", "robin_castle_broken_01_15", "robin_castle_broken_01_16"},
                           damaged_2 = {"robin_castle_broken_02_14", "robin_castle_broken_02_15", "robin_castle_broken_02_16"},
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
        wall:destroyDelayed()
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
        wall:destroyDelayed()
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
    if ratling_boss == nil then
        animation.duration = -1
    else
        local ratling_type = ratling_types[math.random(#ratling_types)]    
        local ratling = ratling_boss:spawn(ratling_type)
        ratling.monster:setMaxHealth(1)
    end
end

function robinAtTheCastle(trigger)
    local monster = findEntity("robin_castle_ogre").monster
    boss_fight_robin_castle.bossfight:addMonster(monster)    
    boss_fight_robin_castle.bossfight:activate()    
    local countdown_animation = {func=robin_castle_countdown, on_finish=on_finish_robin_castle_countdown, step=.1, duration=250000, elapsed=0, last_called=-1, starting_health=5000, health_tick=10, monster_id="robin_castle_ogre", health_tick_stages = {4500, 4000, 3500, 3000, 2500, 2000, 1500, 1000, 500}}
    global_scripts.script.add_animation(boss_fight_robin_castle.level, countdown_animation)
    
    local spawner = findEntity("spawn_robin_castle_1")
    local ratling_boss = spawner:spawn("ratling_boss") 
    ratling_boss.monster:setMaxHealth(1)
    spawner = findEntity("spawn_robin_castle_2")
    local ogre = spawner:spawn("forest_ogre")
    ogre.monster:setMaxHealth(1)
    spawner = findEntity("spawn_robin_castle_3")
    local elemental = spawner:spawn("fire_elemental")    
    elemental.monster:setMaxHealth(1)
    local ratling = spawner:spawn("ratling1")
    ratling.monster:setMaxHealth(1)

    local ratling_boss_spawn_animation = {func=robin_castle_spawn_ratling, on_finish=nil, step=10, duration=250000, elapsed=0, last_called=-1, spawn_at=ratling_boss.id}
    global_scripts.script.add_animation(boss_fight_robin_castle.level, ratling_boss_spawn_animation)
    global_scripts.script.faceObject(pushblock_robin, trigger.go.facing)
end

function onFindTreasure(chest, item) 
    if chest.go.surface:count() == 0 then   
        start_lite_up_pushblock_floor("pushblock_trigger_r21")
        chest.go.surface:removeConnector("onRemoveItem", "triels_robin_script_entitiy", "onFindTreasure")
    end
end

function robinDigUpTreasure(trigger)
    trigger.go:spawn("dig_hole")
    local chest = trigger.go:spawn("chest")  
    chest.surface:addConnector("onRemoveItem", "triels_robin_script_entitiy", "onFindTreasure")  
    for _,treasure_type in ipairs({"tome_health", "tome_energy", "tome_leadership", "tome_wisdom"}) do
        local treasure = spawn(treasure_type)
        chest.surface:addItem(treasure.item)
    end
end

function robinTreasureHunt(trigger)    
    trigger:disable()
    if pushblock_floors[trigger.go.id]["off"] ~= nil then
        for _,pushblock_floor_id in ipairs(pushblock_floors[trigger.go.id]["off"]) do            
            local pushblock_floor = findEntity(pushblock_floor_id)
            pushblock_floor.controller:deactivate()
            pushblock_floor.light:enable()
        end
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
    local animation = {func=move_object, on_finish=finish_move_object, step=0.05, duration=2, elapsed=0, last_called=-1, start_pos=start_pos, stop_pos=stop_pos, on_finish_pos=on_finish_pos, object_id="forest_oak_cluster_2"}
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
        monster.monster:setMaxHealth(1)
    end
    boss_fight_robin_forest.bossfight:activate()
end

function robinAtTheBridge(trigger)
    global_scripts.script.faceObject(pushblock_robin, 0)
    global_scripts.script.spawnAtObject("magma_golem_meteor_impact_ground", robin_magma_golem_spawn)
    raisePedestal("pedestal_robin_bridge")
    local magma_golem = global_scripts.script.spawnAtObject("magma_golem", robin_magma_golem_spawn)
    local meteorite = spawn("meteorite").item
    magma_golem.monster:addItem(meteorite)
    magma_golem.monster:setMaxHealth(1)
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

function wrongMove(trigger)
    trigger:disable()
    hudPrint("You chose poorly.")
    global_scripts.script.spawnAtObject("shockburst", party, nil, 0, 0, 0)
    local damage_flags = DamageFlags.CameraShake
    damageTile(party.level, party.x, party.y, party.facing, party.elevation, damage_flags, "shock", 10)
    hudPrint("Though he never forgot his farming origins, neither did he ever return to them.")
    local animation = {func=nil, on_finish=reset_sir_robin, step=1.7, duration=1.8, elapsed=0, last_called=-1} -- wait till the pushblock miovng finishes movbing pushblock_robin before teleporting him
    global_scripts.script.add_animation(pushblock_robin.level, animation)
    pushblock_trigger_rs4.controller:deactivate()
    pushblock_trigger_rs4.light:enable()
end

function start_journey(state_data)
    for _, pushblock_floor in ipairs(pushblock_floors["start"]) do
        start_lite_up_pushblock_floor(pushblock_floor, false)
    end  
end

rat_spawn_location_ids = {"spawn_robin_rats_01", "spawn_robin_rats_02", "spawn_robin_rats_03"}
rat_spawn_floor_trigger_ids = {"floor_trigger_robin_rats_01", "floor_trigger_robin_rats_02", "floor_trigger_robin_rats_03"}
rat_spawn_connections = {floor_trigger_robin_rats_01 = "spawn_robin_rats_01",
                         floor_trigger_robin_rats_02 = "spawn_robin_rats_02",
                         floor_trigger_robin_rats_03 = "spawn_robin_rats_03",
                         count = 3,
                         animation = nil,
                         spawn_robin_rats_01 = "robin_rat_hole_01",
                         spawn_robin_rats_02 = "robin_rat_hole_02",
                         spawn_robin_rats_03 = "robin_rat_hole_03"}

function spawn_rat_swarm(animation)
    local spawn_pos_id = rat_spawn_location_ids[math.random(3)]
    local spawn_pos = findEntity(spawn_pos_id)
    if spawn_pos ~= nil then
        spawn_pos:spawn("rat_swarm")
    end
end

function destroyRatNest(trigger)
    trigger = global_scripts.script.getGO(trigger)
    
    local rat_spawn_pos    = findEntity(rat_spawn_connections[trigger.id])  
    print(rat_spawn_connections[rat_spawn_pos.id])  
    local teleport_pos = findEntity(rat_spawn_connections[rat_spawn_pos.id])
    
    party:setPosition(teleport_pos.x, teleport_pos.y, teleport_pos.facing, teleport_pos.elevation, teleport_pos.level)
    --spawn_pos:destroyDelayed()
    --trigger:destroyDelayed()
    
    rat_spawn_connections.count = rat_spawn_connections.count - 1
    
    if rat_spawn_connections.count == 0 then
        rat_spawn_connections.animation.duration = 0
    end
end

function start_spawn_rats()
    for i = 1,3 do
        local spawn_pos = global_scripts.script.findSpawnSpot(7, 9, 24, 30, 0, pushblock_robin.level, {"dig_hole"})
        spawn("dig_hole", pushblock_robin.level, spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, rat_spawn_location_ids[i]) -- beach_sandpile
        local floor_trigger = spawn("floor_trigger", pushblock_robin.level, spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, rat_spawn_floor_trigger_ids[i])
        floor_trigger.floortrigger:setTriggeredByDigging(true)
        floor_trigger.floortrigger:setTriggeredByItem(false)
        floor_trigger.floortrigger:setTriggeredByMonster(false)
        floor_trigger.floortrigger:setTriggeredByParty(false)
        floor_trigger.floortrigger:setTriggeredByPushableBlock(false)
        floor_trigger.floortrigger:addConnector("onActivate", "triels_robin_script_entitiy", "destroyRatNest")
    end
    rat_spawn_connections.animation = {func=spawn_rat_swarm, step=12, duration=999999}
    --global_scripts.script.add_animation(pushblock_robin.level, rat_spawn_connections.animation)
    --spawn_rat_swarm(animation)
    --spawn_rat_swarm(animation)
    --spawn_rat_swarm(animation)
end

function rats_defeated(state_data)
    return state_data.next_state
end

function count_farming(state_data)
    state_data.count = state_data.count - 1
    hudPrint(tostring(state_data.count))
    if state_data.count == 0 then
        time_callbacks["blooddrop_cap_lower"] = nil
        time_callbacks["blooddrop_cap_raise"] = nil
        return state_data.next_state
    else
        local spawn_pos = global_scripts.script.findSpawnSpot(7, 9, 24, 30, 0, pushblock_robin.level, nil)
        spawn("blooddrop_cap", pushblock_robin.level, spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation)
        return state
    end
end

function spawn_bandits(state_data)
    local spiked_club = spawn("spiked_club")
    local ogre = robin_bandit_spawner:spawn("forest_ogre")
    ogre.monster:addItem(spiked_club.item)
    ogre.monster:setMaxHealth(1)
end

function onPutItem(surface, item)
    --hudPrint(item.go.name)
    --hudPrint(tostring(surface:count()))
    local state_data = states[state]
    if state_data[item.go.name] == nil then
        return
    end
    state = state_data[item.go.name].func(state_data[item.go.name])
    local state_data = states[state]
    if state_data ~= nil and state_data.init_func ~= nil then
        state_data.init_func()
    end
    --hudPrint(state)
end

state = "initial" 
states = {["initial"] = {["blooddrop_cap"] = {func = count_farming, next_state = "rat_plague", count = 1},
                         init_func = nil},
          ["rat_plague"] = {["rat_shank"] = {func = rats_defeated, next_state = "bandits", count = 1},
                            init_func = start_spawn_rats},
          ["bandits"] = {["spiked_club"] = {func = start_journey, next_state = "init_journey", count = 1},
                         init_func = spawn_bandits},
          ["init_journey"] = {init_func = start_journey}}

morning = 0
noon = 0.5
evening = 1
midnight = 1.5
maxtime = 1.9999 -- this then becomes morning
onehour = 1/12

function raise_robin_pedestal(key, callback)
    raisePedestal("robin_pedestal")
    local callback = {name="blooddrop_cap_lower", check_func=check_for_not_morning, func=lower_robin_pedestal, oneshot=true, enabled=true}
    time_callbacks[callback.name] = callback
end

function lower_robin_pedestal(key, callback)
    raisePedestal("robin_pedestal", false, -1)
    local callback = {name="blooddrop_cap_raise", check_func=check_for_morning, func=raise_robin_pedestal, oneshot=true, enabled=true}
    time_callbacks[callback.name] = callback    
end

function check_for_not_morning(key, callback, time_of_day)    
    local pass = not check_for_morning(key, callback, time_of_day)
    return pass
end

function check_for_morning(key, callback, time_of_day)    
    local pass = false
   
    if ((time_of_day >= maxtime - onehour) or (time_of_day < morning + (3 * onehour))) then
        pass = true
    end
    
    return pass
end

function check_timed_events(animation)
    local time_of_day = GameMode.getTimeOfDay()
    print("time of day "..tostring(time_of_day))
    
    local remove_callback_keys = {}
    
    for key,callback in pairs(time_callbacks) do
        if  callback.check_func(key, callback, time_of_day) == true then
            if callback.enabled == true then
                callback.func(key, callback)
                if callback.oneshot == true then
                    table.insert(remove_callback_keys, key)
                end
            end
        end
    end
    
    for _,key in ipairs(remove_callback_keys) do
        time_callbacks[key] = nil
    end
end


function enterTheTrials(trigger)
    trigger:disable()
    
    GameMode.setTimeOfDay(morning)
    
    trials_robin_forest_sky.sky:setFogRange({1,1}) 
    
    local spawn_pos = global_scripts.script.findSpawnSpot(7, 9, 24, 30, 0, pushblock_robin.level, nil)
    spawn("blooddrop_cap", pushblock_robin.level, spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation)
    
    local animation = {func=check_timed_events, step=1, duration=-1}
    global_scripts.script.add_animation(trigger.go.level, animation)
end

time_callbacks = {blooddrop_cap_riase = {check_func=check_for_morning, func=raise_robin_pedestal, oneshot=true, enabled=true}}


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
    local lever = global_scripts.script.getGO(lever)
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
    global_scripts.script.add_animation(lever.level, animation)
end

function goTilNoon(lever)
    local lever = global_scripts.script.getGO(lever)
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
    global_scripts.script.add_animation(lever.level, animation)
end

function goTilEvening(lever)
    local lever = global_scripts.script.getGO(lever)
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
    global_scripts.script.add_animation(lever.level, animation)
end

function goTilMidnight(lever)
    local lever = global_scripts.script.getGO(lever)
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
    global_scripts.script.add_animation(lever.level, animation)
end

function init()
    --trials_robin_forest_sky.sky:setFogRange({1,2})    
    --trials_robin_forest_sky.sky:setFogMode("dense")
end