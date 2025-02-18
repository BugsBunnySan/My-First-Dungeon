start_pos = {x=10, y=17, facing=0, elevation=0}
virtual_pos = {x=0, y=0, facing=9, elevation=0}
dungeon_sections = {}
sections = {}

special_places = {["pedestal_of_roses"] = {x1=-5, y1=-12, x2=5, y2=-8, entry_id="pedestal_of_roses_marker", door_id="", spawn_pos={}}}--pedestal_of_roses_door"}}
special_entities = {}
special_door_id = ""

function spawn_wall(x, y, facing, elevation, level, section)
    local wall = spawn("dungeon_secret_door")
    wall:setPosition(x, y, facing, elevation, level)
    --wall.door:disable()
    table.insert(section.walls, wall.id)    
end

function spawn_floor(x, y, facing, elevation, level, section)
    local dungeon_floor = spawn("dungeon_floor_dirt_01")
    dungeon_floor:setPosition(x, y, facing, elevation, level)
    table.insert(section.walls, dungeon_floor.id)       
    local dungeon_ceiling = spawn("dungeon_ceiling")
    dungeon_ceiling:setPosition(x, y, facing, elevation, level)
    table.insert(section.walls, dungeon_ceiling.id)       
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
    floor_trigger.floortrigger:addConnector("onActivate", "tricksters_domain_script_entity", "onActivateSectionFloorTrigger")
 
    --floor_trigger.floortrigger:disable()
    table.insert(section.floor_triggers, floor_trigger.id)    
end

function spawn_projectile_catcher(x, y, facing, elevation, level, section)
    local teleporter = spawn("invisible_teleporter")
    
    teleporter:setPosition(x, y, facing, elevation, level)
    teleporter.teleporter:setTeleportTarget(level, 31, 0, elevation)
    teleporter.teleporter:setSpin("north")
    teleporter.teleporter:setTriggeredByParty(false)
    teleporter.teleporter:setTriggeredByItem(false)
    teleporter.teleporter:setTriggeredByMonster(false)
    teleporter.teleporter:setTriggeredBySpell(true)
    
    table.insert(section.floor_triggers, teleporter.id)    
end

function pos_straight_ahead(pos, steps)
    steps = steps or 1
    if pos.facing == 0 then
        pos.y = pos.y - steps
    elseif pos.facing == 1 then
        pos.x = pos.x + steps
    elseif pos.facing == 2 then
        pos.y = pos.y + steps
    elseif pos.facing == 3 then
        pos.x = pos.x - steps
    end
end

function pos_straight_back(pos, steps)
    steps = steps or 1
    if pos.facing == 0 then
        pos.y = pos.y + steps
    elseif pos.facing == 1 then
        pos.x = pos.x - steps
    elseif pos.facing == 2 then
        pos.y = pos.y - steps
    elseif pos.facing == 3 then
        pos.x = pos.x + steps
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
        spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)
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
        spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)
    end
    
    pos_straight_ahead(pos)
end

function straight_ahead_right(pos, spawn, section)
    if spawn then
        spawn_wall(pos.x, pos.y, modulo_facing(pos.facing + 1), pos.elevation, pos.level, section)       
        spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)
    end
    
    pos_straight_ahead(pos)
end

function straight_ahead_ahead(pos, spawn, section)
    if spawn then
        spawn_wall(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)               
        spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)
    end
    
    pos_straight_ahead(pos)
end

function turn_left(pos, spawn, section)
    if spawn then
        local left = modulo_facing(pos.facing + 1)
        wall = spawn_wall(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)        
        wall = spawn_wall(pos.x, pos.y, left, pos.elevation, pos.level, section)               
        spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)
    end

    pos_left(pos)
    pos_straight_ahead(pos)
end

function turn_right(pos, spawn, section)
    if spawn then
        local right = modulo_facing(pos.facing - 1)
        spawn_wall(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)
        spawn_wall(pos.x, pos.y, right, pos.elevation, pos.level, section)                
        spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)
    end

    pos_right(pos)
    pos_straight_ahead(pos)
end
  
function spawn_nothing(section_type, pos, exit_types, arch_facing, section, spawn_exits)
    local section = {section_type = "nop",                  
                     pos = global_scripts.script.copy_pos(pos), 
                     arch_facing=arch_facing,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty"}}
    --pos_straight_ahead(pos)
    --spawn("dispel_blast", pos.level, pos.x, pos.y, pos.facing, pos.elevation)

    return section
end    
  
function spawn_straight(section_type, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
    local section = {section_type = "straight",                     
                     pos = global_scripts.script.copy_pos(pos), 
                     arch_facing=arch_facing,
                     special_position = special_position,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty"}}       
    local exit_section
                  
    local arch_pos = global_scripts.script.copy_pos(pos)
    
    for i, exit_type in ipairs(section.exit_types) do
        exit_types[i] = exit_types[i] or section.exit_types[i]
    end
    
    if arch_facing == "inward" then
        pos_straight_back(arch_pos)
        arch_facing = "outward"
    elseif arch_facing == "outward" then
        pos_reverse(arch_pos)
        arch_facing = "inward"
    end
           
    if spawn_exits == true then    
        local exit_pos = global_scripts.script.copy_pos(pos) 
    
        pos_reverse(exit_pos)      
        pos_straight_ahead(exit_pos) 
        
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"straight"}, arch_facing, false, section, special_position)
        section.exit_types[1] = exit_section.section_type
    else        
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if special_position ~=  "" then
            special_places[special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)
            
        end

        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)
                
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end          
    end

    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    
    exit_pos = global_scripts.script.copy_pos(pos) 
    
    if spawn_exits == true then                   
        exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"straight"}, "outward", false, section, special_position)
        section.exit_types[2] = exit_section.section_type 
    else
        spawn_arch(exit_pos.x, exit_pos.y, modulo_facing(exit_pos.facing+2), exit_pos.elevation, exit_pos.level, section)
        spawn_projectile_catcher(exit_pos.x, exit_pos.y, exit_pos.facing, exit_pos.elevation, exit_pos.level, section)
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function spawn_left_turn(section_type, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
    local section = {section_type = "left_turn",                     
                     pos = global_scripts.script.copy_pos(pos), 
                     arch_facing=arch_facing,
                     special_position = special_position,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty"}} 

    local exit_section
                  
    local arch_pos = global_scripts.script.copy_pos(pos)
    
    for i, exit_type in ipairs(section.exit_types) do
        exit_types[i] = exit_types[i] or section.exit_types[i]
    end
    
    if arch_facing == "inward" then
        pos_straight_back(arch_pos)
        arch_facing = "outward"
    elseif arch_facing == "outward" then
        pos_reverse(arch_pos)
        arch_facing = "inward"
    end
                      
    virtual_pos.facing = pos.facing
    
    if spawn_exits == true then    
        local exit_pos = global_scripts.script.copy_pos(pos)    
        
        pos_reverse(exit_pos)      
        pos_straight_ahead(exit_pos)     
        
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"left_turn"}, arch_facing, false, section, special_position)
        section.exit_types[1] = exit_section.section_type
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if special_position ~=  "" then
            special_places[special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)
        end                                        

        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)
      
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end           
    end

    straight_ahead(pos, true, section)
    turn_left(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos) 
                       
        exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"right_turn"}, "outward", false, section, special_position)
        section.exit_types[2] = exit_section.section_type
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function spawn_right_turn(section_type, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
    local section = {section_type = "right_turn",                     
                     pos = global_scripts.script.copy_pos(pos), 
                     arch_facing=arch_facing,
                     special_position = special_position,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty"}}

    local exit_section
                  
    local arch_pos = global_scripts.script.copy_pos(pos)

    for i, exit_type in ipairs(section.exit_types) do
        exit_types[i] = exit_types[i] or section.exit_types[i]
    end
    
    if arch_facing == "inward" then
        pos_straight_back(arch_pos)
        arch_facing = "outward"
    elseif arch_facing == "outward" then
        pos_reverse(arch_pos)
        arch_facing = "inward"
    end
                      
    virtual_pos.facing = pos.facing
                     
    if spawn_exits == true then    
        local exit_pos = global_scripts.script.copy_pos(pos)    
        
        pos_reverse(exit_pos)      
        pos_straight_ahead(exit_pos)          
        
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"right_turn"}, arch_facing, false, section, special_position)
        section.exit_types[1] = exit_section.section_type
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                      
        if special_position ~=  "" then
            special_places[special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)
        end                                       

        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)
      
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end           
    end

    straight_ahead(pos, true, section)
    turn_right(pos, true, section)
    straight_ahead(pos, true, section)
    
    if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)   
        
        exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"left_turn"}, "outward", false, section, special_position)
        section.exit_types[2] = exit_section.section_type
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function spawn_T_junction(section_type, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
    local section = {section_type = section_type,                     
                     pos = global_scripts.script.copy_pos(pos), 
                     arch_facing = arch_facing,
                     special_position = special_position,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty", "empty"}}

    local exit_section
    local exit_pos
        
    for i, exit_type in ipairs(section.exit_types) do
        exit_types[i] = exit_types[i] or section.exit_types[i]
    end
        
    local arch_pos = global_scripts.script.copy_pos(pos)
    
    if arch_facing == "inward" then
        pos_straight_back(arch_pos)
        arch_facing = "outward"
    elseif arch_facing == "outward" then
        pos_reverse(arch_pos)
        arch_facing = "inward"
    end
                      
    virtual_pos.facing = pos.facing

    if spawn_exits == true then
        if section_type == "T_junction_left" then
            -- exit 1
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_reverse(exit_pos)
            pos_straight_ahead(exit_pos)
                   
            exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"T_junction_left"}, arch_facing, false, section, special_position)
            section.exit_types[1] = exit_section.section_type 
            
            -- exit 2
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_left(exit_pos)
            pos_straight_ahead(exit_pos, 2)
                  
            exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"T_junction_T"}, "outward", false, section, special_position)
            section.exit_types[2] = exit_section.section_type 
            
            -- exit 3
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos, 3)
  
            exit_section = spawn_functions[exit_types[3]](exit_types[3], exit_pos, {"T_junction_right"}, "outward", false, section, special_position)
            section.exit_types[3] = exit_section.section_type                        
        elseif section_type == "T_junction_T" then  
            -- exit 1
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_reverse(exit_pos)      
            pos_straight_ahead(exit_pos)
                    
            exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"T_junction_T"}, arch_facing, false, section, special_position)
            section.exit_types[1] = exit_section.section_type 
            
            -- exit 2
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_left(exit_pos)
            pos_straight_ahead(exit_pos, 2) 
                 
            exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"T_junction_right"}, "outward", false, section, special_position)
            section.exit_types[2] = exit_section.section_type      
            
            --exit 3
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_right(exit_pos)
            pos_straight_ahead(exit_pos, 2) 
                       
            exit_section = spawn_functions[exit_types[3]](exit_types[3], exit_pos, {"T_junction_left"}, "outward", false, section, special_position)
            section.exit_types[3] = exit_section.section_type 
        elseif section_type == "T_junction_right" then 
            -- exit 1
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_reverse(exit_pos)      
            pos_straight_ahead(exit_pos)
            
            exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"T_junction_right"}, arch_facing, false, section, special_position)
            section.exit_types[1] = exit_section.section_type            
             
            -- exit 2
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos, 3)
                    
            exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"T_junction_left"}, "outward", false, section, special_position)
            section.exit_types[2] = exit_section.section_type 
            
            -- exit 3
            exit_pos = global_scripts.script.copy_pos(pos)
            pos_straight_ahead(exit_pos)
            pos_right(exit_pos)
            pos_straight_ahead(exit_pos, 2)
            
            exit_section = spawn_functions[exit_types[3]](exit_types[3], exit_pos, {"T_junction_T"}, "outward", false, section, special_position)
            section.exit_types[3] = exit_section.section_type                        
        end
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                      
        if special_position ~= "" then
            special_places[special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)
        end                                           

        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)
             
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
            
                
        if spawn_exits == false then           
            spawn_arch(pos.x, pos.y, modulo_facing(pos.facing+2), pos.elevation, pos.level, section)
            spawn_projectile_catcher(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)
        end
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

        if spawn_exits == false then           
            spawn_arch(pos.x, pos.y, modulo_facing(pos.facing+2), pos.elevation, pos.level, section)
            spawn_projectile_catcher(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)
        end        
    end
    
    table.insert(dungeon_sections, section) 
    
    return section 
end

function spawn_X_junction(section_type, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
     local section = {section_type = section_type,                     
                     pos = global_scripts.script.copy_pos(pos), 
                     arch_facing = arch_facing,
                     special_position = special_position,
                     walls = {},
                     floor_triggers = {},
                     exit_types = {"empty", "empty", "empty", "empty"}}

    local exit_section
    local exit_pos  

     for i, exit_type in ipairs(section.exit_types) do
        exit_types[i] = exit_types[i] or section.exit_types[i]
    end
    
    local arch_pos = global_scripts.script.copy_pos(pos)
    
    if arch_facing == "inward" then
        pos_straight_back(arch_pos)
        arch_facing = "outward"
    elseif arch_facing == "outward" then
        pos_reverse(arch_pos)
        arch_facing = "inward"
    end 
    
    if spawn_exits == true then
        -- exit 1
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_reverse(exit_pos)
        pos_straight_ahead(exit_pos)
                 
        exit_section = spawn_functions[exit_types[1]](exit_types[1], exit_pos, {"X_junction"}, arch_facing, false, section, special_position)
        section.exit_types[1] = exit_section.section_type 
        
        -- exit 2
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_straight_ahead(exit_pos)
        pos_left(exit_pos)
        pos_straight_ahead(exit_pos)
        pos_straight_ahead(exit_pos)
               
        exit_section = spawn_functions[exit_types[2]](exit_types[2], exit_pos, {"X_junction"}, "outward", false, section, special_position)
        section.exit_types[2] = exit_section.section_type 
        
        -- exit 3
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_straight_ahead(exit_pos)
        pos_straight_ahead(exit_pos)
        pos_straight_ahead(exit_pos)
        
        
        exit_section = spawn_functions[exit_types[3]](exit_types[3], exit_pos, {"X_junction"}, "outward", false, section, special_position)
        section.exit_types[3] = exit_section.section_type 
        
        -- exit 4
        exit_pos = global_scripts.script.copy_pos(pos)
        pos_straight_ahead(exit_pos)
        pos_right(exit_pos)
        pos_straight_ahead(exit_pos)
        pos_straight_ahead(exit_pos)
                
        exit_section = spawn_functions[exit_types[4]](exit_types[4], exit_pos, {"X_junction"}, "outward", false, section, special_position)
        section.exit_types[4] = exit_section.section_type         
    else
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if special_position ~=  "" then
            special_places[special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)
        end                                             

        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)
                       
        for i, exit_type in ipairs(exit_types) do
            section.exit_types[i] = exit_type
        end    
    end
    
    straight_ahead(pos, true, section)
    spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)    
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_left(spawn_pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section)
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section) 
    
    if spawn_exits == false then           
        spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing+2), spawn_pos.elevation, spawn_pos.level, section)
        spawn_projectile_catcher(spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, spawn_pos.level, section)
    end
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_right(spawn_pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section)
    
    table.insert(dungeon_sections, section)
    
    return section
end

function spawn_random_section(ignored, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
    local section_type = section_types[math.random(5)]
    local section_sub_type = section_sub_types[section_type][math.random(#section_sub_types[section_type])]
    
    local section = spawn_functions[section_sub_type](section_sub_type, pos, exit_types, arch_facing, spawn_exits, come_from_section, special_position)
    
    return section
end

spawn_functions = {nop = spawn_nothing,
                   empty = spawn_random_section,
                   straight = spawn_straight,
                   left_turn = spawn_left_turn,
                   right_turn = spawn_right_turn,
                   T_junction_left = spawn_T_junction,
                   T_junction_T = spawn_T_junction,
                   T_junction_right = spawn_T_junction,
                   X_junction = spawn_X_junction,
                   pedestal_of_roses = spawn_pedestal_of_roses_portal
                   }
          
section_types = {"straight", "left_turn", "right_turn", "T_junction", "X_junction"}
          
section_sub_types = {nop = {"nop"}, straight = {"straight"}, left_turn = {"left_turn"}, right_turn = {"right_turn"}, 
                     T_junction = {"T_junction_left", "T_junction_T", "T_junction_right"}, 
                     X_junction = {"X_junction"}}

special_spawn_function = {pedestal_of_roses = spawn_pedestal_of_roses}

function stepTeleport(trigger_id)
    local trigger = findEntity(trigger_id)       
    
    local enter_section = sections[trigger.id]    
    
    --print("stepTeleport")
    --print("coming from "..enter_section.section_type)
    
    --global_scripts.script.print_pos(virtual_pos)    
    virtual_pos.x = virtual_pos.x + (trigger.x - start_pos.x)
    virtual_pos.y = virtual_pos.y + (trigger.y - start_pos.y)
    virtual_pos.facing = trigger.facing      
    --global_scripts.script.print_pos(virtual_pos)
    
    print(tostring(enter_section.special_position))
    
    if enter_section.special_position ~= "" then
        print("    from special place")
        --global_scripts.script.print_pos(virtual_pos)
        local entry_marker = findEntity(special_places[enter_section.special_position].entry_id)
        virtual_pos.x = virtual_pos.x + (start_pos.x - special_places[enter_section.special_position].spawn_pos.x)
        virtual_pos.y = virtual_pos.y + (start_pos.y - special_places[enter_section.special_position].spawn_pos.y)
        --global_scripts.script.print_pos(virtual_pos)
    end
    
    local facing = enter_section.pos.facing 

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
            if go.floortrigger ~= nil then
                go.floortrigger:disable()
            elseif go.teleporter ~= nil then
                go.teleporter:disable()
            end
            go:destroyDelayed()
        end
    end
    
    for _, special_entity_id in ipairs(special_entities) do
        local special_entity = findEntity(special_entity_id)
        special_entity:destroyDelayed()
    end
    
    dungeon_sections = {}
    sections = {}    
    special_entities = {}
    
    local exit_types = enter_section.exit_types
    if not facing_is_reversed(facing, party.facing) then -- if the party enters a section backwards, they'd see the section they came from change, this prevents that
        exit_types[1] = "empty"
    end
   
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)    
    local party_pos = global_scripts.script.copy_pos(start_pos)
    local spawn_special = ""
    --print(tostring(virtual_pos.x).." "..tostring(virtual_pos.y))
    
    for name, pos in pairs(special_places) do           
        local entry_marker = findEntity(pos.entry_id)
        if virtual_pos.x >= pos.x1 and virtual_pos.x <= pos.x2 and virtual_pos.y >= pos.y1 and virtual_pos.y <= pos.y2 then
            spawn_special = name    -- also sections that don't exit to the special places need to remember they were in that area when we come back from them     
            if enter_section.section_type == "straight" then
                if enter_section.pos.facing == 0 then
                    exit_types[2] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                               
                    start_spawn_pos.y = start_spawn_pos.y + 3                                       
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                end
            elseif enter_section.section_type == "left_turn" and enter_section.pos.facing == 1 then
                exit_types[2] = "nop"
                start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                start_spawn_pos.y = start_spawn_pos.y + 2
                start_spawn_pos.x = start_spawn_pos.x - 1                                    
                party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                start_spawn_pos.facing = enter_section.pos.facing
            elseif enter_section.section_type == "right_turn" and enter_section.pos.facing == 3 then
                exit_types[2] = "nop"
                start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                start_spawn_pos.y = start_spawn_pos.y + 2
                start_spawn_pos.x = start_spawn_pos.x + 1                                    
                party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                start_spawn_pos.facing = enter_section.pos.facing
            elseif enter_section.section_type == "T_junction_left" then
                if enter_section.pos.facing == 0 then
                    exit_types[3] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                        
                    start_spawn_pos.y = start_spawn_pos.y + 3                            
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                elseif enter_section.pos.facing == 1 then
                    exit_types[2] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                    start_spawn_pos.y = start_spawn_pos.y + 2
                    start_spawn_pos.x = start_spawn_pos.x - 1                            
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                end
            elseif enter_section.section_type == "T_junction_T" then
                if enter_section.pos.facing == 1 then
                    exit_types[2] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                    start_spawn_pos.y = start_spawn_pos.y + 2
                    start_spawn_pos.x = start_spawn_pos.x - 1                                    
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                elseif enter_section.pos.facing == 3 then
                    exit_types[3] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                    start_spawn_pos.y = start_spawn_pos.y + 2
                    start_spawn_pos.x = start_spawn_pos.x + 1                                    
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                end
            elseif enter_section.section_type == "T_junction_right" then
                if enter_section.pos.facing == 0 then
                    exit_types[2] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                        
                    start_spawn_pos.y = start_spawn_pos.y + 3                            
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                elseif enter_section.pos.facing == 3 then
                    exit_types[3] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                    start_spawn_pos.y = start_spawn_pos.y + 2
                    start_spawn_pos.x = start_spawn_pos.x + 1                        
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                end
            elseif enter_section.section_type == "X_junction" then
                if enter_section.pos.facing == 0 then
                    exit_types[3] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)              
                    start_spawn_pos.y = start_spawn_pos.y + 3                        
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                elseif enter_section.pos.facing == 1 then
                    exit_types[2] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                    start_spawn_pos.y = start_spawn_pos.y + 2
                    start_spawn_pos.x = start_spawn_pos.x - 1                                    
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                elseif enter_section.pos.facing == 2 then
                    exit_types[1] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)              
                    start_spawn_pos.y = start_spawn_pos.y - 3                        
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                elseif enter_section.pos.facing == 3 then
                    exit_types[4] = "nop"
                    start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
                    start_spawn_pos.y = start_spawn_pos.y + 2
                    start_spawn_pos.x = start_spawn_pos.x + 1                                    
                    party_pos = global_scripts.script.copy_pos(start_spawn_pos)
                    start_spawn_pos.facing = enter_section.pos.facing
                end
            end
        end
    end
    
   
    local new_section = spawn_functions[enter_section.section_type](enter_section.section_type, start_spawn_pos, exit_types, enter_section.arch_facing, true, nil, spawn_special)
    table.insert(dungeon_sections, new_section)
    party:setPosition(party_pos.x, party_pos.y, party.facing, party_pos.elevation, party_pos.level)
    if special_door_id ~= "" then
        local special_door = findEntity(special_door_id)
        special_door.door:open()
    end
end

function onActivateSectionFloorTrigger(trigger)    
    trigger = global_scripts.script.getGO(trigger)               
    
    local chance = math.random(24)
    if chance == -1 then
        local spawn_pos = global_scripts.script.findSpawnSpot(start_pos.x - 4, start_pos.x + 4, start_pos.y - 4, start_pos.y + 4, start_pos.elevation, start_pos.level, {["party"] = true, ["turtle"] = true})
        local turtle = spawn("turtle")
        turtle:setPosition(spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, spawn_pos.level)
    elseif chance <= -12 then
        local facing = modulo_facing(party.facing + math.random(3))
        local sound_pos = global_scripts.script.copy_pos(party)
        pos_straight_ahead(sound_pos)
            
        playSoundAt("trickster_walk_low", sound_pos.level, sound_pos.x, sound_pos.y)
    end

    if special_door_id ~= "" then
        local special_door = findEntity(special_door_id)
        special_door.door:close()
        special_door_id = ""
    end
    
    delayedCall("tricksters_domain_script_entity", .19, "stepTeleport", trigger.id) -- 0.18 seconds is exactly the right amount of time to let the step animation finish before moving the party
end

function onEnterDungeon(trigger)
    --print("-----------------------------------")
    trigger = global_scripts.script.getGO(trigger)
    
    start_pos.facing = trigger.facing
    start_pos.elevation = trigger.elevation
    start_pos.level = trigger.level
    virtual_pos.level = trigger.level
    
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)
    
    spawn_random_section("empty", start_spawn_pos, {"empty"}, "outward", true, nil, "")
end

function init()    
    --tricksters_domain_sky.sky:setFogMode("dense")
    --tricksters_domain_sky.sky:setFogRange({1,2})
    dungeon_door_iron_barred_1.door:close()
end