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
    floor_trigger.floortrigger:addConnector("onActivate", "test_inside_script_entity", "onActivateSectionFloorTrigger")
    floor_trigger.floortrigger:setDisableSelf(true)
    
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
    end

    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)
        
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
    end

    straight_ahead(pos, true, section)
    turn_left(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)
        spawn_arch(exit_pos.x, exit_pos.y, exit_pos.facing, exit_pos.elevation, exit_pos.level, section)        
        
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"right_turn"}, exit_pos.facing, false)
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
    end

    straight_ahead(pos, true, section)
    turn_right(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)
        spawn_arch(exit_pos.x, exit_pos.y, exit_pos.facing, exit_pos.elevation, exit_pos.level, section)        
        
        exit_section = spawn_functions["empty"]("empty", exit_pos, {"left_turn"}, exit_pos.facing, false)
        section.exit_types[2] = exit_section.section_type 
    end
        
    table.insert(dungeon_sections, section) 
    
    return section 
end

function spawn_random_section(ignored, pos, exit_types, arch_facing, spawn_exits)
    local section_type = section_types[math.random(3)]
    local section_sub_type = section_sub_types[section_type][math.random(#section_sub_types[section_type])]
    
    local section = spawn_functions[section_sub_type](section_sub_type, pos, exit_types, arch_facing, spawn_exits)
    
    return section
end

spawn_functions = {empty = spawn_random_section,
                   straight = spawn_straight,
                   left_turn = spawn_left_turn,
                   right_turn = spawn_right_turn,
                   T_junction1 = spawn_T_junction,
                   T_junction2 = spawn_T_junction,
                   T_junction3 = spawn_T_junction,
                   X_junction1 = spawn_X_junction,
                   X_junction2 = spawn_X_junction,
                   X_junction3 = spawn_X_junction,
                   X_junction4 = spawn_X_junction
                   }
          
section_types = {"straight", "left_turn", "right_turn", "T_junction", "X_junction"}
          
section_sub_types = {straight = {"straight"}, left_turn = {"left_turn"}, right_turn = {"right_turn"}, 
                     T_junction = {"T_junction1", "T_junction2", "T_junction3"}, 
                     X_junction = {"X_junction1", "X_junction2", "X_junction3", "X_junction4"}}

function stepTeleport(trigger_id)
    print("step")
    local trigger = findEntity(trigger_id)
    
    local enter_section = sections[trigger.id]
    
    print(enter_section.exit_types[1])
    
    local facing = enter_section.facing 
    
    start_pos.facing = facing
    start_pos.level = trigger.level    

    if facing_is_reversed(facing, party.facing) then
        print("party entered backwards")
    else
        print("party entered forwards")        
    end
    
   for i, section in ipairs(dungeon_sections) do
        print(tostring(i).." "..section.section_type)
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
    
   
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)    
    local new_section = spawn_functions[enter_section.section_type](enter_section.section_type, start_spawn_pos, enter_section.exit_types, enter_section.arch_facing, true)
    table.insert(dungeon_sections, new_section)  
    
    party:setPosition(start_pos.x, start_pos.y, party.facing, start_pos.elevation, start_pos.level)  
end
function nop()
    
   
       
    
    for _, section in ipairs(dungeon_sections) do
        for _, go_id in ipairs(section.walls) do
            go = findEntity(go_id)
            --go:destroyDelayed()
        end
        for _, go_id in ipairs(section.floor_triggers) do
            go = findEntity(go_id)
            --go:destroyDelayed()
        end
    end
end

function onActivateSectionFloorTrigger(trigger)    
    trigger = global_scripts.script.getGO(trigger)               
    
    if math.random(5) == 5 then
        global_scripts.script.playSoundAtObject("trickster_walk_low", party)
    end
    delayedCall("test_inside_script_entity", .2, "stepTeleport", trigger.id)
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