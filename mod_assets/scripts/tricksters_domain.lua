-- in the actual game engine, going into an exit section doesn't do the teleport back...
-- "somewhere 10 leagues due north from the center"

start_pos = {x=10, y=17, facing=0, elevation=0}
virtual_pos = {x=0, y=0, facing=9, elevation=0}
null_pos = {x=0, y=0, facing=9, elevation=0}
dungeon_sections = {}
sections = {}

special_places = {["pedestal_of_roses"] = {x1=-5, y1=-12, x2=5, y2=-9, entry_id="pedestal_of_roses_marker", door_id="", spawn_pos={}},} --pedestal_of_roses_door"}}
                  --["test_location"] = {x1=-5, y1=8, x2=5, y2=12, entry_id="crystal_bridge_marker", door_id="", spawn_pos={}},
                  --["tricksters_beach"] = {x1=-42, y1=-500, x2=-32, y2=500, entry_id="tricksters_beach_marker", door_id="", spawn_pos={}}}
special_entities = {}
special_door_id = ""

function spawn_wall(x, y, facing, elevation, level, section)
    local wall = spawn("dungeon_secret_door")
    wall:setPosition(x, y, facing, elevation, level)
    wall.door:disable()
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

function pos_add_pos(pos, offset_pos)
    pos.x = pos.x + offset_pos.x
    pos.y = pos.y + offset_pos.y
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
  
function make_nothing(section_type, exit_types)
    local section = {section_type = "nop",                  
                     pos = null_pos, 
                     spawn_func = spawn_nothing,
                     get_exit_positions_func = get_nothing_exit_positions,
                     make_exits_func = make_nop_exits,
                     special_position = "",
                     walls = {},
                     floor_triggers = {},
                     arch_facings = {},
                     exit_types = {},
                     exits = {}}
    --pos_straight_ahead(pos)
    --spawn("dispel_blast", pos.level, pos.x, pos.y, pos.facing, pos.elevation)

    return section
end
    
function makeNop()
    return make_nothing("nop", {})
end

function get_nothing_exit_positions(section, reference_pos)
    return {}
end

function make_nop_exits()
end

function spawn_nothing(section, pos, spawn_exits, come_from_section, special_position, arch_facing)
    section.pos = global_scripts.script.copy_pos(pos)
    section.special_position = special_position
    return
end
                   
function make_straight(section_type, pos, exit_types, arch_facings, make_exits, flip_arches)
    local section = {section_type = "straight",
                     pos = pos,
                     spawn_func = spawn_straight,
                     get_exit_positions_func = get_straight_exit_positions,
                     make_exits_func = make_straight_exits,                     
                     special_position = "",
                     walls = {},
                     floor_triggers = {},
                     arch_facings = {"outward", "outward"},
                     exit_types = {"empty", "empty"},
                     exits = {}}
                  
    for i,_ in ipairs(section.exit_types) do
        section.exit_types[i] = exit_types[i] or section.exit_types[i]
    end
    
    for i,_ in ipairs(section.arch_facings) do
        section.arch_facings[i] = arch_facings[i] or section.arch_facings[i]
    end
                
    if make_exits == true then
        section:make_exits_func(section.pos, flip_arches)        
    end
    
    return section
end

function get_straight_exit_positions(section, reference_pos)
    local exit_positions = {}
    -- exit 1
    local exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_reverse(exit_pos)      
    pos_straight_ahead(exit_pos) 
    exit_positions[1] = exit_pos
    
    -- exit 2        
    exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_straight_ahead(exit_pos, 3) 
    exit_positions[2] = exit_pos
    
    return exit_positions
end

function make_straight_exits(section, reference_pos, flip_arches)
    local arch_facings = {}
    if flip_arches then
        if section.arch_facings[1] == "outward" then
            arch_facings[1] = "inward"
        elseif section.arch_facings[1] == "inward" then
            arch_facings[1] = "outward"
        end
    end
    
    local exit_positions = section:get_exit_positions_func(reference_pos)
    
    local exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"straight"}, arch_facings, false, false)
    section.exit_types[1] = exit_section.section_type
    section.exits[1] = exit_section      
                                 
    exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"straight"}, {}, false, false)
    section.exit_types[2] = exit_section.section_type
    section.exits[2] = exit_section
end

function spawn_straight(section, pos, spawn_exits, come_from_section, special_position)
    local exit_section
    local exit_pos
    local exit_positions
    section.pos = global_scripts.script.copy_pos(pos)
    section.special_position = special_position 
               
    if spawn_exits == true then
        exit_positions = section:get_exit_positions_func(pos)             
        section.exits[1]:spawn_func(exit_positions[1], false, section, section.special_position)  
        section.exits[2]:spawn_func(exit_positions[2], false, section, section.special_position)  
    end
               
    if spawn_exits == false then
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if section.special_position ~=  "" then
            special_places[section.special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)
            
        end    
        
        local arch_pos = global_scripts.script.copy_pos(pos)
        if section.arch_facings[1] == "outward" then        
            pos_straight_back(arch_pos)
        elseif section.arch_facings[1] == "inward" then
            pos_reverse(arch_pos)
        end
        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)        
    end

    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    
    exit_pos = global_scripts.script.copy_pos(pos) 
    
    if spawn_exits == false then 
        spawn_arch(exit_pos.x, exit_pos.y, modulo_facing(exit_pos.facing + 2), exit_pos.elevation, exit_pos.level, section)
        spawn_projectile_catcher(exit_pos.x, exit_pos.y, exit_pos.facing, exit_pos.elevation, exit_pos.level, section)
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function make_left_turn(section_type, pos, exit_types, arch_facings, make_exits, flip_arches)
    local section = {section_type = "left_turn",
                     pos = pos,
                     spawn_func = spawn_left_turn,
                     get_exit_positions_func = get_left_turn_exit_positions,
                     make_exits_func = make_left_turn_exits,
                     special_position = "",
                     walls = {},
                     floor_triggers = {},
                     arch_facings = {"outward", "outward"},
                     exit_types = {"empty", "empty"},
                     exits = {}} 
                  
    for i, exit_type in ipairs(section.exit_types) do
        section.exit_types[i] = exit_types[i] or section.exit_types[i]
    end  
    
    for i,_ in ipairs(section.arch_facings) do
        section.arch_facings[i] = arch_facings[i] or section.arch_facings[i]
    end
         
    if make_exits == true then
        section:make_exits_func(section.pos, flip_arches)        
    end
                    
    return section
end

function get_left_turn_exit_positions(section, reference_pos)    
    local exit_positions = {}
   
    -- exit 1
    local exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_reverse(exit_pos)      
    pos_straight_ahead(exit_pos)  
    exit_positions[1] = exit_pos 
    
    -- exit 2
    exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_straight_ahead(exit_pos)
    pos_left(exit_pos)
    pos_straight_ahead(exit_pos, 2)    
    exit_positions[2] = exit_pos 
   
    return exit_positions
end

function make_left_turn_exits(section, reference_pos, flip_arches)    
    local arch_facings = {}
    if flip_arches then
        if section.arch_facings[1] == "outward" then
            arch_facings[1] = "inward"
        elseif section.arch_facings[1] == "inward" then
            arch_facings[1] = "outward"
        end
    end
    
    local exit_positions = section:get_exit_positions_func(reference_pos)   
    
    local exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"left_turn"}, arch_facings, false, false)
    section.exit_types[1] = exit_section.section_type
    section.exits[1] = exit_section      
                 
    exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"right_turn"}, {}, false, false)
    section.exit_types[2] = exit_section.section_type
    section.exits[2] = exit_section
end

function spawn_left_turn(section, pos, spawn_exits, come_from_section, special_position)
    local exit_section
    local exit_positions
    local exit_pos
    
    section.pos = global_scripts.script.copy_pos(pos)
    section.special_position = special_position 
               
    virtual_pos.facing = pos.facing  
    
    if spawn_exits == true then
        exit_positions = section:get_exit_positions_func(pos)
        section.exits[1]:spawn_func(exit_positions[1], false, section, section.special_position)
        section.exits[2]:spawn_func(exit_positions[2], false, section, section.special_position)
    end
        
    if spawn_exits == false then
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if section.special_position ~=  "" then
            special_places[section.special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)           
        end    
        local arch_pos = global_scripts.script.copy_pos(pos)
        if section.arch_facings[1] == "outward" then        
            pos_straight_back(arch_pos)
        elseif section.arch_facings[1] == "inward" then
            pos_reverse(arch_pos)
        end
        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)        
    end

    straight_ahead(pos, true, section)
    turn_left(pos, true, section)
    straight_ahead(pos, true, section)
    
    exit_pos = global_scripts.script.copy_pos(pos) 
    
    if spawn_exits == false then
        spawn_arch(exit_pos.x, exit_pos.y, modulo_facing(exit_pos.facing + 2), exit_pos.elevation, exit_pos.level, section)
        spawn_projectile_catcher(exit_pos.x, exit_pos.y, exit_pos.facing, exit_pos.elevation, exit_pos.level, section)
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function make_right_turn(section_type, pos, exit_types, arch_facings, make_exits, flip_arches)
    local section = {section_type = "right_turn",
                     pos = pos,
                     spawn_func = spawn_right_turn,
                     get_exit_positions_func = get_right_turn_exit_positions,
                     make_exits_func = make_right_turn_exits,
                     special_position = "",
                     walls = {},
                     floor_triggers = {},
                     arch_facings = {"outward", "outward"},
                     exit_types = {"empty", "empty"},
                     exits = {}} 
                  
    for i, exit_type in ipairs(section.exit_types) do
        section.exit_types[i] = exit_types[i] or section.exit_types[i]
    end  
    
    for i,_ in ipairs(section.arch_facings) do
        section.arch_facings[i] = arch_facings[i] or section.arch_facings[i]
    end
         
    if make_exits == true then
        section:make_exits_func(section.pos, flip_arches)        
    end
                    
    return section
end

function get_right_turn_exit_positions(section, reference_pos)
    local exit_positions = {}
   
    -- exit 1
    local exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_reverse(exit_pos)      
    pos_straight_ahead(exit_pos)  
    exit_positions[1] = exit_pos 
    
    -- exit 2
    exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_straight_ahead(exit_pos)
    pos_right(exit_pos)
    pos_straight_ahead(exit_pos, 2)    
    exit_positions[2] = exit_pos 
   
    return exit_positions
end

function make_right_turn_exits(section, reference_pos, flip_arches)    
    local arch_facings = {}
    if flip_arches then
        if section.arch_facings[1] == "outward" then
            arch_facings[1] = "inward"
        elseif section.arch_facings[1] == "inward" then
            arch_facings[1] = "outward"
        end
    end
    
    local exit_positions = section:get_exit_positions_func(reference_pos)   
    
    local exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"right_turn"}, arch_facings, false, false)
    section.exit_types[1] = exit_section.section_type
    section.exits[1] = exit_section      
                 
    exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"left_turn"}, {}, false, false)
    section.exit_types[2] = exit_section.section_type
    section.exits[2] = exit_section
end

function spawn_right_turn(section, pos, spawn_exits, come_from_section, special_position)
    local exit_section
    local exit_positions
    local exit_pos
    
    section.pos = global_scripts.script.copy_pos(pos)
    section.special_position = special_position 
               
    virtual_pos.facing = pos.facing  
    
    if spawn_exits == true then
        exit_positions = section:get_exit_positions_func(pos)
        section.exits[1]:spawn_func(exit_positions[1], false, section, section.special_position)
        section.exits[2]:spawn_func(exit_positions[2], false, section, section.special_position)
    end
        
    if spawn_exits == false then
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if section.special_position ~=  "" then
            special_places[section.special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)           
        end    
        local arch_pos = global_scripts.script.copy_pos(pos)
        if section.arch_facings[1] == "outward" then        
            pos_straight_back(arch_pos)
        elseif section.arch_facings[1] == "inward" then
            pos_reverse(arch_pos)
        end
        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)        
    end

    straight_ahead(pos, true, section)
    turn_right(pos, true, section)
    straight_ahead(pos, true, section)
    
    exit_pos = global_scripts.script.copy_pos(pos) 
    
    if spawn_exits == false then
        spawn_arch(exit_pos.x, exit_pos.y, modulo_facing(exit_pos.facing + 2), exit_pos.elevation, exit_pos.level, section)
        spawn_projectile_catcher(exit_pos.x, exit_pos.y, exit_pos.facing, exit_pos.elevation, exit_pos.level, section)
    end
        
    table.insert(dungeon_sections, section)  
    
    return section
end

function make_T_junction(section_type, pos, exit_types, arch_facings, make_exits, flip_arches)
    local section = {section_type = section_type,
                     pos = pos,
                     spawn_func = spawn_T_junction,
                     get_exit_positions_func = get_T_junction_exit_positions,
                     make_exits_func = make_T_junction_exits,
                     special_position = "",
                     walls = {},
                     floor_triggers = {},
                     arch_facings = {"outward", "outward", "outward"},
                     exit_types = {"empty", "empty", "empty"},
                     exits = {}} 
                  
    for i, exit_type in ipairs(section.exit_types) do
        section.exit_types[i] = exit_types[i] or section.exit_types[i]
    end  
    
    for i,_ in ipairs(section.arch_facings) do
        section.arch_facings[i] = arch_facings[i] or section.arch_facings[i]
    end
         
    if make_exits == true then
        section:make_exits_func(section.pos, flip_arches)        
    end
                    
    return section
end

function get_T_junction_exit_positions(section, reference_pos)
    local exit_positions = {}
   
    -- exit 1
    local exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_reverse(exit_pos)      
    pos_straight_ahead(exit_pos)  
    exit_positions[1] = exit_pos 
    
    if section.section_type == "T_junction_left" then
        -- exit 2        
        exit_pos = global_scripts.script.copy_pos(reference_pos)
        pos_straight_ahead(exit_pos)
        pos_left(exit_pos)
        pos_straight_ahead(exit_pos, 2)  
        exit_positions[2] = exit_pos 
        
        -- exit 3
        exit_pos = global_scripts.script.copy_pos(reference_pos)
        pos_straight_ahead(exit_pos, 3)  
        exit_positions[3] = exit_pos     
    elseif section.section_type == "T_junction_T" then 
        -- exit 2        
        exit_pos = global_scripts.script.copy_pos(reference_pos)
        pos_straight_ahead(exit_pos)
        pos_left(exit_pos)
        pos_straight_ahead(exit_pos, 2)  
        exit_positions[2] = exit_pos 
        
        -- exit 3 
        exit_pos = global_scripts.script.copy_pos(reference_pos)
        pos_straight_ahead(exit_pos)
        pos_right(exit_pos)
        pos_straight_ahead(exit_pos, 2) 
        exit_positions[3] = exit_pos         
    elseif section.section_type == "T_junction_right" then
        -- exit 2
        exit_pos = global_scripts.script.copy_pos(reference_pos)
        pos_straight_ahead(exit_pos, 3)  
        exit_positions[2] = exit_pos 
        
        -- exit 3        
        exit_pos = global_scripts.script.copy_pos(reference_pos)
        pos_straight_ahead(exit_pos)
        pos_right(exit_pos)
        pos_straight_ahead(exit_pos, 2)  
        exit_positions[3] = exit_pos       
    end
   
    return exit_positions
end

function make_T_junction_exits(section, reference_pos, flip_arches)
    local exit_pos
    local exit_section 
    local exit_positions 
    
    local arch_facings = {}
    if flip_arches then
        if section.arch_facings[1] == "outward" then
            arch_facings[1] = "inward"
        elseif section.arch_facings[1] == "inward" then
            arch_facings[1] = "outward"
        end
    end

    exit_positions = section:get_exit_positions_func(reference_pos)

    if section.section_type == "T_junction_left" then
        -- exit 1
        exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"T_junction_left"}, arch_facings, false, false)
        section.exit_types[1] = exit_section.section_type
        section.exits[1] = exit_section  
        
        -- exit 2
        exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"T_junction_T"}, {}, false, false)
        section.exit_types[2] = exit_section.section_type 
        section.exits[2] = exit_section 
        
        -- exit 3
        exit_section = make_functions[section.exit_types[3]](section.exit_types[3], exit_positions[3], {"T_junction_right"}, {}, false, false)
        section.exit_types[3] = exit_section.section_type  
        section.exits[3] = exit_section                       
    elseif section.section_type == "T_junction_T" then  
        -- exit 1                 
        exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"T_junction_T"}, arch_facings, false, false)
        section.exit_types[1] = exit_section.section_type 
        section.exits[1] = exit_section  
        
        -- exit 2
        exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"T_junction_right"}, {}, false, false)
        section.exit_types[2] = exit_section.section_type 
        section.exits[2] = exit_section       
        
        --exit 3
        exit_section = make_functions[section.exit_types[3]](section.exit_types[3], exit_positions[3], {"T_junction_left"}, {}, false, false)
        section.exit_types[3] = exit_section.section_type 
        section.exits[3] = exit_section  
    elseif section.section_type == "T_junction_right" then 
        -- exit 1        
        exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"T_junction_right"}, arch_facings, false, false)
        section.exit_types[1] = exit_section.section_type  
        section.exits[1] = exit_section            
         
        -- exit 2               
        exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"T_junction_left"}, {}, false, false)
        section.exit_types[2] = exit_section.section_type 
        section.exits[2] = exit_section  
        
        -- exit 3        
        exit_section = make_functions[section.exit_types[3]](section.exit_types[3], exit_positions[3], {"T_junction_T"}, {}, false, false)
        section.exit_types[3] = exit_section.section_type 
        section.exits[3] = exit_section                         
    end    
end

function spawn_T_junction(section, pos, spawn_exits, come_from_section, special_position)
    local exit_section
    local exit_pos
    local exit_positions
    
    section.pos = global_scripts.script.copy_pos(pos)
    section.special_position = special_position 
       
    virtual_pos.facing = pos.facing 

    if spawn_exits == true then
        exit_positions = section:get_exit_positions_func(pos)
        section.exits[1]:spawn_func(exit_positions[1], false, section, section.special_position)
        section.exits[2]:spawn_func(exit_positions[2], false, section, section.special_position)
        section.exits[3]:spawn_func(exit_positions[3], false, section, section.special_position)
    end

    if spawn_exits == false then
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if section.special_position ~=  "" then
            special_places[section.special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)            
        end   
        
        local arch_pos = global_scripts.script.copy_pos(pos)
        if section.arch_facings[1] == "outward" then        
            pos_straight_back(arch_pos)
        elseif section.arch_facings[1] == "inward" then
            pos_reverse(arch_pos)
        end
        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)        
    end

    if section.section_type == "T_junction_left" then
        straight_ahead(pos, true, section)
        
        local spawn_pos = global_scripts.script.copy_pos(pos)
        pos_left(spawn_pos)
        pos_straight_ahead(spawn_pos)
        if spawn_exits == false then           
            spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing), spawn_pos.elevation, spawn_pos.level, section) 
            straight_ahead(spawn_pos, true, section)
        end
        straight_ahead(spawn_pos, true, section)
        
        straight_ahead_right(pos, true, section)
        straight_ahead(pos, true, section)    
            
                
        if spawn_exits == false then           
            spawn_arch(pos.x, pos.y, modulo_facing(pos.facing+2), pos.elevation, pos.level, section)
            spawn_projectile_catcher(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)            
        end
    elseif section.section_type == "T_junction_T" then 
        straight_ahead(pos, true, section)
        
        local spawn_pos = global_scripts.script.copy_pos(pos)
        pos_left(spawn_pos)
        pos_straight_ahead(spawn_pos)
        if spawn_exits == false then           
            spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing), spawn_pos.elevation, spawn_pos.level, section) 
            straight_ahead(spawn_pos, true, section)
        end
        straight_ahead(spawn_pos, true, section)
        
        pos_right(pos)
        straight_ahead_left(pos, true, section)
        if spawn_exits == false then           
            spawn_arch(pos.x, pos.y, modulo_facing(pos.facing), pos.elevation, pos.level, section) 
            straight_ahead(pos, true, section)
        end
        straight_ahead(pos, true, section)
    elseif section.section_type == "T_junction_right" then
        straight_ahead(pos, true, section)
        
        local spawn_pos = global_scripts.script.copy_pos(pos)
        pos_right(spawn_pos)
        pos_straight_ahead(spawn_pos)
        if spawn_exits == false then           
            spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing), spawn_pos.elevation, spawn_pos.level, section) 
            straight_ahead(spawn_pos, true, section)
        end
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

function make_X_junction(section_type, pos, exit_types, arch_facings, make_exits, flip_arches)
    local section = {section_type = section_type,
                     pos = pos,
                     spawn_func = spawn_X_junction,
                     get_exit_positions_func = get_X_junction_exit_positions,
                     make_exits_func = make_X_junction_exits,
                     special_position = "",
                     walls = {},
                     floor_triggers = {},
                     arch_facings = {"outward", "outward", "outward", "outward"},
                     exit_types = {"empty", "empty", "empty", "empty"},
                     exits = {}} 
                  
    for i, exit_type in ipairs(section.exit_types) do
        section.exit_types[i] = exit_types[i] or section.exit_types[i]
    end  
    
    for i,_ in ipairs(section.arch_facings) do
        section.arch_facings[i] = arch_facings[i] or section.arch_facings[i]
    end
         
    if make_exits == true then
        section:make_exits_func(section.pos, flip_arches)        
    end
                    
    return section
end

function get_X_junction_exit_positions(section, reference_pos)
    local exit_positions = {}
   
    -- exit 1
    local exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_reverse(exit_pos)      
    pos_straight_ahead(exit_pos)  
    exit_positions[1] = exit_pos 
    
    -- exit 2
    exit_pos = global_scripts.script.copy_pos(reference_pos)
    pos_straight_ahead(exit_pos)
    pos_left(exit_pos)
    pos_straight_ahead(exit_pos, 2)    
    exit_positions[2] = exit_pos 
   
    -- exit 3
    exit_pos = global_scripts.script.copy_pos(reference_pos)  
    pos_straight_ahead(exit_pos, 3)
    exit_positions[3] = exit_pos 

    -- exit 4
    exit_pos = global_scripts.script.copy_pos(reference_pos) 
    pos_straight_ahead(exit_pos)
    pos_right(exit_pos)
    pos_straight_ahead(exit_pos, 2)
    exit_positions[4] = exit_pos 

    return exit_positions
end

function make_X_junction_exits(section, reference_pos, flip_arches)
    local exit_pos
    local exit_section 
    local exit_positions 
    
    local arch_facings = {}
    if flip_arches then
        if section.arch_facings[1] == "outward" then
            arch_facings[1] = "inward"
        elseif section.arch_facings[1] == "inward" then
            arch_facings[1] = "outward"
        end
    end

    exit_positions = section:get_exit_positions_func(reference_pos)

    -- exit 1
    exit_section = make_functions[section.exit_types[1]](section.exit_types[1], exit_positions[1], {"X_junction"}, arch_facings, false, false)
    section.exit_types[1] = exit_section.section_type
    section.exits[1] = exit_section  
    
    -- exit 2
    exit_section = make_functions[section.exit_types[2]](section.exit_types[2], exit_positions[2], {"X_junction"}, {}, false, false)
    section.exit_types[2] = exit_section.section_type 
    section.exits[2] = exit_section 
    
    -- exit 3
    exit_section = make_functions[section.exit_types[3]](section.exit_types[3], exit_positions[3], {"X_junction"}, {}, false, false)
    section.exit_types[3] = exit_section.section_type  
    section.exits[3] = exit_section
    
    -- exit 4
    exit_section = make_functions[section.exit_types[4]](section.exit_types[4], exit_positions[4], {"X_junction"}, {}, false, false)
    section.exit_types[4] = exit_section.section_type  
    section.exits[4] = exit_section 
end
        
function spawn_X_junction(section, pos, spawn_exits, come_from_section, special_position)
    local exit_section
    local exit_pos
    local exit_positions
    
    section.pos = global_scripts.script.copy_pos(pos)
    section.special_position = special_position 
       
    virtual_pos.facing = pos.facing 
    
    if spawn_exits == true then
        exit_positions = section:get_exit_positions_func(pos)
        section.exits[1]:spawn_func(exit_positions[1], false, section, section.special_position)
        section.exits[2]:spawn_func(exit_positions[2], false, section, section.special_position)
        section.exits[3]:spawn_func(exit_positions[3], false, section, section.special_position)
        section.exits[4]:spawn_func(exit_positions[4], false, section, section.special_position)
    end
    
    if spawn_exits == false then
        spawn_floor_trigger(pos.x, pos.y, pos.facing, pos.elevation, pos.level, section)                                     
        if section.special_position ~=  "" then
            special_places[section.special_position].spawn_pos = global_scripts.script.copy_pos(come_from_section.pos)            
        end   
        
        local arch_pos = global_scripts.script.copy_pos(pos)
        if section.arch_facings[1] == "outward" then        
            pos_straight_back(arch_pos)
        elseif section.arch_facings[1] == "inward" then
            pos_reverse(arch_pos)
        end
        spawn_arch(arch_pos.x, arch_pos.y, arch_pos.facing, arch_pos.elevation, arch_pos.level, section)        
    end
    
    straight_ahead(pos, true, section)
    spawn_floor(pos.x, pos.y, 0, pos.elevation, pos.level, section)    
    
    local spawn_pos = global_scripts.script.copy_pos(pos)
    pos_left(spawn_pos)
    pos_straight_ahead(spawn_pos)
    if spawn_exits == false then           
        spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing), spawn_pos.elevation, spawn_pos.level, section)
        straight_ahead(spawn_pos, true, section)
    end
    straight_ahead(spawn_pos, true, section)
    
    spawn_pos = global_scripts.script.copy_pos(pos)
    pos_straight_ahead(spawn_pos)
    straight_ahead(spawn_pos, true, section) 
    
    if spawn_exits == false then           
        spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing+2), spawn_pos.elevation, spawn_pos.level, section)
        spawn_projectile_catcher(spawn_pos.x, spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, spawn_pos.level, section)
    end
    
    spawn_pos = global_scripts.script.copy_pos(pos)
    pos_right(spawn_pos)
    pos_straight_ahead(spawn_pos)
    if spawn_exits == false then           
        spawn_arch(spawn_pos.x, spawn_pos.y, modulo_facing(spawn_pos.facing), spawn_pos.elevation, spawn_pos.level, section)
        straight_ahead(spawn_pos, true, section)
    end
    straight_ahead(spawn_pos, true, section)
    
    table.insert(dungeon_sections, section)
    
    return section
end

function generate_random_section_type()
    local section_type = section_types[math.random(5)]
    local section_sub_type = section_sub_types[section_type][math.random(#section_sub_types[section_type])]
    
    return section_sub_type
end
                              
function make_random_section(section_type, pos, exit_types, arch_facings, make_exits, flip_arches)
    local section_sub_type = generate_random_section_type()
       
    local section = make_functions[section_sub_type](section_sub_type, pos, exit_types, arch_facings, make_exits, false)
    
    return section    
end
                              
function spawn_random_section(ignored, pos, exit_types, spawn_exits, come_from_section, special_position)
    print(special_position)
    local section = make_random_section(ignored, pos, exit_types, {}, spawn_exits, false)
    section:spawn_func(pos, spawn_exits, come_from_section, special_position)
    
    return section
end

make_functions = {nop = make_nothing,
                  empty = make_random_section,
                  straight = make_straight,
                  left_turn = make_left_turn,
                  right_turn = make_right_turn,
                  T_junction_left = make_T_junction,
                  T_junction_T = make_T_junction,
                  T_junction_right = make_T_junction,
                  X_junction = make_X_junction,
                  pedestal_of_roses = make_pedestal_of_roses_portal
                  }

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

special_script_entities = {pedestal_of_roses = "pedestal_of_roses_script_entity",
                           test_location = "test_location_script_entity",
                           tricksters_beach = "tricksters_beach_script_entity"}

function stepTeleport(trigger_id)
    local trigger = findEntity(trigger_id)       
    
    local enter_section = sections[trigger.id]    
    
    print("stepTeleport")
    print("coming from "..enter_section.section_type)
    
    global_scripts.script.print_pos(virtual_pos)    
    virtual_pos.x = virtual_pos.x + (trigger.x - start_pos.x)
    virtual_pos.y = virtual_pos.y + (trigger.y - start_pos.y)
    virtual_pos.facing = trigger.facing      
    global_scripts.script.print_pos(virtual_pos)
        
    if enter_section.special_position ~= "" then
        print("    from special place: "..enter_section.special_position)
        global_scripts.script.print_pos(virtual_pos)
        local entry_marker = findEntity(special_places[enter_section.special_position].entry_id)
        virtual_pos.x = virtual_pos.x + (start_pos.x - special_places[enter_section.special_position].spawn_pos.x)
        virtual_pos.y = virtual_pos.y + (start_pos.y - special_places[enter_section.special_position].spawn_pos.y)
        global_scripts.script.print_pos(virtual_pos)
    end
    
    local facing = enter_section.pos.facing 

    start_pos.facing = facing
    
    for i, section in ipairs(dungeon_sections) do
        local go
        for _, go_id in ipairs(section.walls) do
            go = findEntity(go_id)
            if go.door ~= nil then
                go.door:disable()
            end
            go:destroyDelayed()
        end
        section.walls = {}
        for _, go_id in ipairs(section.floor_triggers) do
            go = findEntity(go_id)
            if go.floortrigger ~= nil then
                go.floortrigger:disable()
            elseif go.teleporter ~= nil then
                go.teleporter:disable()
            end
            go:destroyDelayed()
        end
        section.floor_triggers = {}
    end
    
    for _, special_entity_id in ipairs(special_entities) do
        local special_entity = findEntity(special_entity_id)
        special_entity:destroyDelayed()
    end
    
    dungeon_sections = {}
    sections = {}    
    special_entities = {}
    
    
    if not facing_is_reversed(facing, party.facing) then -- if the party enters a section backwards, they'd see the section they came from change, this prevents that
        enter_section.exit_types[1] = "empty"
    end
   
   
    local check_pos = global_scripts.script.copy_pos(virtual_pos)  
    check_pos.facing = enter_section.pos.facing
    enter_section:make_exits_func(check_pos, true)
   
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)    
    local party_pos = global_scripts.script.copy_pos(start_pos)
    local spawn_special = ""
    local spawn_special_entry_exit_idx = nil
    local exit_idx = -1                                       
    --print(tostring(virtual_pos.x).." "..tostring(virtual_pos.y))
            
    for name, pos in pairs(special_places) do
        local script_entity = findEntity(special_script_entities[name])
        local entry_marker = findEntity(pos.entry_id)
        if script_entity.script.in_range(virtual_pos, special_places[name], enter_section) then
            spawn_special = name    -- also sections that don't exit to the special places need to remember they were in that area when we come back from them                
            start_spawn_pos, party_pos, exit_idx = script_entity.script.check_exits(enter_section, entry_marker, start_spawn_pos, party_pos)
            if exit_idx ~= -1 then
                enter_section.exit_types[exit_idx] = "nop"
                enter_section.exits[exit_idx] = tricksters_domain_script_entity.script.makeNop()
            end
        end
        for x, exit_section in ipairs(enter_section.exits) do
            local exit_positions = exit_section:get_exit_positions_func(exit_section.pos)
            for i = 2, #exit_positions do
                exit_exit_pos = exit_positions[i]
                if script_entity.script.in_range(exit_exit_pos, special_places[name], nil) then
                    spawn_special_entry_exit_idx = {x, i, name}
                end
            end
        end       
    end
  
    enter_section:make_exits_func(start_spawn_pos, true)
    
    if spawn_special_entry_exit_idx ~= nil then
        print("exit "..tostring(spawn_special_entry_exit_idx[1]).." should spawn a special places special entry entities at its exit "..tostring(spawn_special_entry_exit_idx[2]))
        local x = spawn_special_entry_exit_idx[1]
        local i = spawn_special_entry_exit_idx[2]
        local special_name = spawn_special_entry_exit_idx[3]
        local torch_pos = enter_section.exits[x]:get_exit_positions_func(enter_section.exits[x].pos)[i]
        local script_entity = findEntity(special_script_entities[special_name])
        local special_light = script_entity.script.make_special_entry(torch_pos)
        if special_light ~= nil then
            table.insert(enter_section.walls, special_light.id)     
        end
    end
   
   
    --local new_section = spawn_functions[enter_section.section_type](enter_section.section_type, start_spawn_pos, exit_types, enter_section.arch_facing, true, nil)
    enter_section:spawn_func(start_spawn_pos, true, nil, spawn_special)
    --table.insert(dungeon_sections, new_section)
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
    
    delayedCall("tricksters_domain_script_entity", .19, "stepTeleport", trigger.id) -- 0.19 seconds is exactly the right amount of time to let the step animation finish before moving the party
    -- it is also a lot of time to already prepare the landing place, if it takes longer than 0.19 seconds, that means we're at ~5 frames per second, some thinngs are going
    -- to look weird if that's the case, maybe put a safeguard in anyhow?
end

function onEnterDungeon(trigger)
    print("-----------------------------------")
    
    dungeon_door_iron_barred_1.door:close()
    trigger = global_scripts.script.getGO(trigger)
    
    start_pos.facing = trigger.facing
    start_pos.elevation = trigger.elevation
    start_pos.level = trigger.level
    virtual_pos.level = trigger.level
    null_pos.level = trigger.level
    
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)
                                        
    spawn_random_section("empty", start_spawn_pos, {"empty"}, true, nil, "")
end

function init()    
    --tricksters_domain_sky.sky:setFogMode("dense")
    --tricksters_domain_sky.sky:setFogRange({1,2})
end