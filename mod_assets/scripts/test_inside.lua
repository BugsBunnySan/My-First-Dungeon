start_pos = {x=10, y=17, facing=0, elevation=0}
dungeon_sections = {}
sections = {}

function spawn_wall(x, y, facing, elevation, level, section)
    local wall = spawn("dungeon_secret_door")
    wall:setPosition(x, y, facing, elevation, level)    
    table.insert(section.walls, wall.id)    
end

function spawn_arch(x, y, facing, elevation, level, section)
    local arch = spawn("forest_ruins_arch")
    arch:setPosition(x, y, facing, elevation, level)
    table.insert(section.walls, arch.id)
end

function spawn_floor_trigger(x, y, facing, elevation, level, section)
    local floor_trigger = spawn("floor_trigger")
    
    sections[floor_trigger.id] = section
    
    floor_trigger:setPosition(x, y, facing, elevation, level)
    floor_trigger.floortrigger:setTriggeredByItem(false)
    floor_trigger.floortrigger:setTriggeredByMonster(false)
    floor_trigger.floortrigger:setTriggeredByDigging(false)
    floor_trigger.floortrigger:setDisableSelf(true)
    floor_trigger.floortrigger:addConnector("onActivate", "test_inside_script_entity", "onActivateSectionFloorTrigger")
        
    --floor_trigger.floortrigger:disable()
    table.insert(section.floor_triggers, floor_trigger.id)    
end

function pos_straight_ahead(pos)
    if pos.facing == 0 then
        pos.y = pos.y - 1
    elseif pos.facing == 1 then
        pos.x = pos.x + 1
    elseif pos.facing == 2 then
        pos.y = pos.y + 1
    elseif pos.facing == 3 then
        pos.x = pos.x - 1
    end
end

function pos_straight_back(pos)
    if pos.facing == 0 then
        pos.y = pos.y + 1
    elseif pos.facing == 1 then
        pos.x = pos.x - 1
    elseif pos.facing == 2 then
        pos.y = pos.y - 1
    elseif pos.facing == 3 then
        pos.x = pos.x + 1
    end
end

function modulo_facing(facing)
    return math.fmod((math.fmod(facing, 4) + 4), 4)-- assure result is positive
end

function pos_left(pos)
    local facing = pos.facing - 1
    pos.facing = modulo_facing(facing)
end

function pos_right(pos)
    local facing = pos.facing + 1
    pos.facing = modulo_facing(facing)
end

function pos_reverse(pos)
    local facing = pos.facing + 2
    pos.facing = modulo_facing(facing)
end

function facing_is_reversed(facing_a, facing_b)
    if facing_a == modulo_facing(facing_b + 2) then
        return true
    else
        return false
    end
end

function straight_ahead(pos, spawn, section)
    if spawn then
        if pos.facing == 0 then
            spawn_wall(pos.x, pos.y, 1, pos.elevation, pos.level, section)
            spawn_wall(pos.x, pos.y, 3, pos.elevation, pos.level, section)
        elseif pos.facing == 1 then
            spawn_wall(pos.x, pos.y, 0, pos.elevation, pos.level, section)
            spawn_wall(pos.x, pos.y, 2, pos.elevation, pos.level, section) 
        elseif pos.facing == 2 then
            spawn_wall(pos.x, pos.y, 1, pos.elevation, pos.level, section)            
            spawn_wall(pos.x, pos.y, 3, pos.elevation, pos.level, section) 
        elseif pos.facing == 3 then
            spawn_wall(pos.x, pos.y, 0, pos.elevation, pos.level, section)            
            spawn_wall(pos.x, pos.y, 2, pos.elevation, pos.level, section) 
        end
    end
    
    pos_straight_ahead(pos)
end

function straight_ahead_left(pos, spawn, section)
    if spawn then
        spawn_wall(pos.x, pos.y, modulo_facing(pos.facing - 1), pos.elevation, pos.level, section)
    end
    
    pos_straight_ahead(pos)
end

function straight_ahead_right(pos, spawn, section)
    if spawn then
        spawn_wall(pos.x, pos.y, modulo_facing(pos.facing + 1), pos.elevation, pos.level, section)
    end
    
    pos_straight_ahead(pos)
end

function straight_ahead_ahead(pos, spawn, section)
    if spawn then
        spawn_wall(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)
    end
    
    pos_straight_ahead(pos)
end

function turn_left(pos, spawn, section)
    if spawn then
        local left = modulo_facing(pos.facing + 1)
        wall = spawn_wall(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)        
        wall = spawn_wall(pos.x, pos.y, left, pos.elevation, pos.level, section) 
    end

    pos_left(pos)
    pos_straight_ahead(pos)
end

function turn_right(pos, spawn, section)
    if spawn then
        local right = modulo_facing(pos.facing - 1)
        spawn_wall(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)
        spawn_wall(pos.x, pos.y, right, pos.elevation, pos.level, section)  
    end

    pos_right(pos)
    pos_straight_ahead(pos)
end
  
function spawn_straight(section_type, pos, exit_types, arch_facing, spawn_exits)
    local section = {section_type = "straight",
                     facing = pos.facing,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty"}}

    local exit_section
                     
    if spawn_exits == true then    
        local exit_pos = global_scripts.script.copy_pos(pos)   
        arch_facing = arch_facing or modulo_facing(pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)       
        
        pos_reverse(exit_pos)      
        pos_straight_ahead(exit_pos)               
        
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"straight"}, arch_facing, false)
        section.exit_types[1] = exit_section.section_type
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)             
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end          
    end

    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos) 
        arch_facing = modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)       
        
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"straight"}, arch_facing, false)
        section.exit_types[2] = exit_section.section_type 
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function spawn_left_turn(section_type, pos, exit_types, arch_facing, spawn_exits)
    local section = {section_type = "left_turn",
                     facing = pos.facing,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty"}}

    local exit_section
                     
    if spawn_exits == true then    
        local exit_pos = global_scripts.script.copy_pos(pos)   
        arch_facing = arch_facing or modulo_facing(pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)       
        
        pos_reverse(exit_pos)      
        pos_straight_ahead(exit_pos)               
        
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"left_turn"}, arch_facing, false)
        section.exit_types[1] = exit_section.section_type
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)           
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end           
    end

    straight_ahead(pos, true, section)
    turn_left(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos) 
        arch_facing = modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)       
        
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"right_turn"}, arch_facing, false)
        section.exit_types[2] = exit_section.section_type
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function spawn_right_turn(section_type, pos, exit_types, arch_facing, spawn_exits)
    local section = {section_type = "right_turn",
                     facing = pos.facing,
                     arch_facing = arch_facing,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty"}}

    local exit_section
                                             
    if spawn_exits == true then
        local exit_pos = global_scripts.script.copy_pos(pos)  
        arch_facing = arch_facing or modulo_facing(pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)        
        
        pos_reverse(exit_pos)      
        pos_straight_ahead(exit_pos)               
        
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"right_turn"}, arch_facing, false)
        section.exit_types[1] = exit_section.section_type  
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)            
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end
    end

    straight_ahead(pos, true, section)
    turn_right(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)  
        arch_facing = modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)        
        
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"left_turn"}, arch_facing, false)
        section.exit_types[2] = exit_section.section_type 
    end
        
    table.insert(dungeon_sections, section) 
    
    return section 
end

function spawn_T_junction(section_type, pos, exit_types, arch_facing, spawn_exits)
    local section = {section_type = section_type,
                     facing = pos.facing,
                     arch_facing = arch_facing,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty", "empty"}}

    local exit_section
    local exit_pos

    if spawn_exits == true then
        if section_type == "T_junction_left" then
            -- exit 1
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_reverse(exit_pos)
            pos_straight_ahead(exit_pos)
            
            arch_facing = arch_facing or modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)             
            exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"T_junction_left"}, arch_facing, false)
            section.exit_types[1] = exit_section.section_type 
            
            -- exit 2
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_left(exit_pos)
            pos_straight_ahead(exit_pos)
            pos_straight_ahead(exit_pos)
            
            arch_facing = modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)             
            exit_section = spawn_functions["empty"]("empty", exit_pos, {"T_junction_T"}, arch_facing, false)
            section.exit_types[2] = exit_section.section_type 
            
            -- exit 3
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_straight_ahead(exit_pos)
            pos_straight_ahead(exit_pos)

            arch_facing = modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions["empty"]("empty", exit_pos, {"T_junction_right"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type                        
        elseif section_type == "T_junction_T" then  
            -- exit 1
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_reverse(exit_pos)      
            pos_straight_ahead(exit_pos) 
            
            arch_facing = arch_facing or modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"T_junction_T"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type 
            
            -- exit 2
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_left(exit_pos)
            pos_straight_ahead(exit_pos) 
            
            arch_facing = modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions["empty"]("empty", exit_pos, {"T_junction_right"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type      
            
            --exit 3
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_right(exit_pos)
            pos_straight_ahead(exit_pos)    
            
            arch_facing = modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions["empty"]("empty", exit_pos, {"T_junction_left"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type 
        elseif section_type == "T_junction_right" then 
            -- exit 1
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_reverse(exit_pos)      
            pos_straight_ahead(exit_pos)    
            
            arch_facing = arch_facing or modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"T_junction_right"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type            
             
            -- exit 2
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_straight_ahead(exit_pos)
            pos_straight_ahead(exit_pos)    
            
            arch_facing = modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions["empty"]("empty", exit_pos, {"T_junction_left"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type 
            
            -- exit 3
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_right(exit_pos)
            pos_straight_ahead(exit_pos)
            pos_straight_ahead(exit_pos)    
            
            arch_facing = modulo_facing(exit_pos.facing + 2)
            spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)            
            exit_section = spawn_functions["empty"]("empty", exit_pos, {"T_junction_T"}, arch_facing, false)
            section.exit_types[3] = exit_section.section_type                        
        end
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)            
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end
    end

    if section_type == "T_junction_left" then
        straight_ahead(pos, true, section)
        
        local spawn_pos = global_scripts.script.copy_pos(pos)
        pos_left(spawn_pos)
        pos_straight_ahead(spawn_pos)
        straight_ahead(spawn_pos, true, section)
        
        straight_ahead_right(pos, true, section)
        straight_ahead(pos, true, section)        
    elseif section_type == "T_junction_T" then 
        straight_ahead(pos, true, section)
        
        local spawn_pos = global_scripts.script.copy_pos(pos)
        pos_left(spawn_pos)
        pos_straight_ahead(spawn_pos)
        straight_ahead(spawn_pos, true, section)
        
        pos_right(pos)
        straight_ahead_left(pos, true, section)
        straight_ahead(pos, true, section)        
    elseif section_type == "T_junction_right" then
        straight_ahead(pos, true, section)
        
        local spawn_pos = global_scripts.script.copy_pos(pos)
        pos_right(spawn_pos)
        pos_straight_ahead(spawn_pos)
        straight_ahead(spawn_pos, true, section)
        
        straight_ahead_left(pos, true, section)
        straight_ahead(pos, true, section)        
    end
    
    table.insert(dungeon_sections, section) 
    
    return section 
end

function spawn_X_junction(section_type, pos, exit_types, arch_facing, spawn_exits)
     local section = {section_type = section_type,
                     facing = pos.facing,
                     arch_facing = arch_facing,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty", "empty", "empty"}}

    local exit_section
    local exit_pos   
    
    if spawn_exits == true then
        -- exit 1
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_reverse(exit_pos)
        pos_straight_ahead(exit_pos)
            
        arch_facing = arch_facing or modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)             
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"X_junction"}, arch_facing, false)
        section.exit_types[1] = exit_section.section_type 
        
        -- exit 2
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_straight_ahead(exit_pos)
        pos_left(exit_pos)
        pos_straight_ahead(exit_pos)
        
        arch_facing = modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)             
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"X_junction"}, arch_facing, false)
        section.exit_types[2] = exit_section.section_type 
        
        -- exit 3
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_straight_ahead(exit_pos)
        pos_straight_ahead(exit_pos)
        pos_straight_ahead(exit_pos)
        
        arch_facing = modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)             
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"X_junction"}, arch_facing, false)
        section.exit_types[3] = exit_section.section_type 
        
        -- exit 4
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_straight_ahead(exit_pos)
        pos_right(exit_pos)
        pos_straight_ahead(exit_pos)
        
        arch_facing = modulo_facing(exit_pos.facing + 2)
        spawn_arch(exit_pos.x, exit_pos.y, arch_facing, exit_pos.elevation, exit_pos.level, section)             
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"X_junction"}, arch_facing, false)
        section.exit_types[4] = exit_section.section_type         
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)            
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end    
    end
    
    straight_ahead(pos, true, section)
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_left(spawn_pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section)
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section)
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_right(spawn_pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section)
    
    table.insert(dungeon_sections, section)
    
    return section
end

function spawn_random_section(ignored, pos, exit_types, arch_facing, spawn_exits)
    local section_type = section_types[math.random(5)]
    local section_sub_type = section_sub_types[section_type][math.random(#section_sub_types[section_type])]
    
    local section = spawn_functions[section_sub_type](section_sub_type, pos, exit_types, arch_facing, spawn_exits)
    
    return section
end

spawn_functions = {empty = spawn_random_section,
                   straight = spawn_straight,
                   left_turn = spawn_left_turn,
                   right_turn = spawn_right_turn,
                   T_junction_left = spawn_T_junction,
                   T_junction_T = spawn_T_junction,
                   T_junction_right = spawn_T_junction,
                   X_junction = spawn_X_junction
                   }
          
section_types = {"straight", "left_turn", "right_turn", "T_junction", "X_junction"}
          
section_sub_types = {straight = {"straight"}, left_turn = {"left_turn"}, right_turn = {"right_turn"}, 
                     T_junction = {"T_junction_left", "T_junction_T", "T_junction_right"}, 
                     X_junction = {"X_junction"}}

function stepTeleport(trigger_id)
    local trigger = findEntity(trigger_id)
    
    local enter_section = sections[trigger.id]    
    
    local facing = enter_section.facing 

    start_pos.facing = facing
    start_pos.level = trigger.level    
    
    for i, section in ipairs(dungeon_sections) do
        local go
        for _, go_id in ipairs(section.walls) do
            go = findEntity(go_id)
            if go.door ~= nil then
                go.door:disable()
            end
            go:destroyDelayed()
        end
        for _, go_id in ipairs(section.floor_triggers) do
            go = findEntity(go_id)
            go.floortrigger:disable()
            go:destroyDelayed()
        end
    end
    
    dungeon_sections = {}
    sections = {}    
    
    local exit_types
    if facing_is_reversed(facing, party.facing) then
        print("party entered backwards")
        exit_types = enter_section.exit_types
    else
        print("party entered forwards")
        exit_types = {"empty"}
    end
   
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)    
    print("copying section to start position")
    for _, exit_type in ipairs(enter_section.exit_types) do
        print("    "..exit_type)
    end
    local new_section = spawn_functions[enter_section.section_type](enter_section.section_type, start_spawn_pos, exit_types, enter_section.arch_facing, true)
    table.insert(dungeon_sections, new_section)  
    
    party:setPosition(start_pos.x, start_pos.y, party.facing, start_pos.elevation, start_pos.level)  
end

function onActivateSectionFloorTrigger(trigger)    
    trigger = global_scripts.script.getGO(trigger)               
    
    if math.random(3) == 3 then
        local facing = modulo_facing(party.facing + math.random(3))
        local sound_pos = global_scripts.script.copy_pos(party)
        pos_straight_ahead(sound_pos)
            
        playSoundAt("trickster_walk_low", sound_pos.level, sound_pos.x, sound_pos.y)        
    end
    delayedCall("test_inside_script_entity", .19, "stepTeleport", trigger.id)
end

function onEnterDungeon(trigger)
    print("-----------------------------------")
    trigger = global_scripts.script.getGO(trigger)
    
    start_pos.facing = trigger.facing
    start_pos.elevation = trigger.elevation
    start_pos.level = trigger.level
    
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)
    
    spawn_random_section("empty", start_spawn_pos, {"empty"}, nil, true)
end

function init()    
    --test_inside_sky.sky:setFogMode("dense")
    --test_inside_sky.sky:setFogRange({1,2})
    dungeon_door_iron_barred_1.door:close()
end