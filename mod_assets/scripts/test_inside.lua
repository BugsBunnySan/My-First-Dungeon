start_pos = {x=10, y=17, facing=0, elevation=0}
dungeon_sections = {}
exit_sections = {}

function spawn_wall(x, y, facing, trigger, section)
    local wall = spawn("dungeon_secret_door")
    wall:setPosition(x, y, facing, trigger.elevation, trigger.level)
    --wall.door:disable()
    table.insert(section.walls, wall)    
end

function spawn_arch(x, y, facing, trigger, section)
    local arch = spawn("forest_ruins_arch")
    arch:setPosition(x, y, facing, trigger.elevation, trigger.level)
    table.insert(section.walls, arch)
end

function spawn_teleporter(x, y, trigger, facing, section, target_pos)
    local teleporter = spawn("invisible_teleporter")
    teleporter:setPosition(x, y, facing, trigger.elevation, trigger.level)
    teleporter.teleporter:setTeleportTarget(target_pos.level, target_pos.x, target_pos.y, target_pos.elevation)
    teleporter.teleporter:setTriggeredBySpell(false)
    teleporter.teleporter:setTriggeredByItem(false)
    teleporter.teleporter:setTriggeredByMonster(false)
    --teleporter.teleporter:setSpin(global_scripts.script.facing_names[facing])
    
    teleporter.teleporter:disable()
    table.insert(section.teleporters, teleporter)
end

function spawn_floor_trigger(x, y, trigger, section)
    local floor_trigger = spawn("floor_trigger")
    
    exit_sections[floor_trigger.id] = section
    
    floor_trigger:setPosition(x, y, trigger.facing, trigger.elevation, trigger.level)
    floor_trigger.floortrigger:addConnector("onActivate", "test_inside_script_entity", "onActivateSectionFloorTrigger")
    floor_trigger.floortrigger:setDisableSelf(true)
    
    --floor_trigger.floortrigger:disable()
    table.insert(section.floor_triggers, floor_trigger)    
end

function spawn_exit_marker(x, y, trigger, facing, section)
    local exit_marker = spawn("invisible_wall")
    exit_marker:setPosition(x, y, facing, trigger.elevation, trigger.level)
    exit_marker.obstacle:disable()
    exit_marker.projectcolider:disable()
    table.insert(section, exit_marker)
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

function pos_left(pos)
    local facing = pos.facing - 1
    pos.facing = math.fmod((math.fmod(facing, 4) + 4), 4) -- assure result is positive
end

function pos_right(pos)
    local facing = pos.facing + 1
    pos.facing = math.fmod((math.fmod(facing, 4) + 4), 4)
end

function pos_reverse(pos)
    local facing = pos.facing + 2
    pos.facing = math.fmod((math.fmod(facing, 4) + 4), 4)
end

function straight_ahead(pos, spawn, section)
    if spawn then
        if pos.facing == 0 then
            spawn_wall(pos.x, pos.y, 1, pos, section)
            spawn_wall(pos.x, pos.y, 3, pos, section)
        elseif pos.facing == 1 then
            spawn_wall(pos.x, pos.y, 0, pos, section)
            spawn_wall(pos.x, pos.y, 2, pos, section) 
        elseif pos.facing == 2 then
            spawn_wall(pos.x, pos.y, 1, pos, section)            
            spawn_wall(pos.x, pos.y, 3, pos, section) 
        elseif pos.facing == 3 then
            spawn_wall(pos.x, pos.y, 0, pos, section)            
            spawn_wall(pos.x, pos.y, 2, pos, section) 
        end        
        spawn_teleporter(pos.x, pos.y, pos, pos.facing, section, pos)   
    end
    
    pos_straight_ahead(pos)
end

function turn_left(pos, spawn, section)
    if spawn then
        wall = spawn_wall(pos.x, pos.y, pos.facing, pos, section)        
        wall = spawn_wall(pos.x, pos.y, math.fmod(pos.facing + 1, 4), pos, section)        
        spawn_teleporter(pos.x, pos.y, pos, pos.facing, section, pos) 
    end

    pos_left(pos)
    pos_straight_ahead(pos)
end

function turn_right(pos, spawn, section)
    if spawn then
        spawn_wall(pos.x, pos.y, pos.facing, pos, section)
        spawn_wall(pos.x, pos.y, math.fmod(pos.facing - 1, 4), pos, section)         
        spawn_teleporter(pos.x, pos.y, pos, pos.facing, section, pos)         
    end

    pos_right(pos)
    pos_straight_ahead(pos)
end

function spawn_straight(pos, spawn_exits)
    print("spawn straight")
    local section = {section_type = "straight",
                     facing = pos.facing,
                     walls = {},
                     floor_triggers = {},
                     teleporters = {}
                    }
    local exit_pos = global_scripts.script.copy_pos(pos)
    pos_reverse(exit_pos)
    
    if spawn_exits == true then
        
        pos_straight_ahead(exit_pos)    
        
        exit_section = spawn_random_section(exit_pos, false)               
    else
        spawn_floor_trigger(pos.x, pos.y, pos, section)
        --spawn_arch(pos.x, pos.y, exit_pos.facing, pos, section)
    end
               
    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)
    straight_ahead(pos, true, section)

   if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)
        
        spawn_random_section(exit_pos, false)
    end
    
    return section
end

function spawn_left_turn(pos, spawn_exits)
    print("spawn left turn")
    local section = {section_type = "left_turn",
                     facing = pos.facing,
                     walls = {},
                     floor_triggers = {},
                     teleporters = {}
                    }
    local exit_pos = global_scripts.script.copy_pos(pos)
    pos_reverse(exit_pos)
    
    if spawn_exits == true then
        
        pos_straight_ahead(exit_pos)    
        
        exit_section = spawn_random_section(exit_pos, false)               
    else
        spawn_floor_trigger(pos.x, pos.y, pos, section)
        --spawn_arch(pos.x, pos.y, exit_pos.facing, pos, section)
    end
           
    straight_ahead(pos, true, section)
    turn_left(pos, true, section)
    straight_ahead(pos, true, section)

   if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)
        
        spawn_random_section(exit_pos, false)
    end
    
    return section
end

function spawn_right_turn(pos, spawn_exits)
    print("spawn right turn")
    local section = {section_type = "right_turn",
                     facing = pos.facing,
                     walls = {},
                     floor_triggers = {},
                     teleporters = {}
                    }
    local exit_pos = global_scripts.script.copy_pos(pos)
    pos_reverse(exit_pos)
    
    if spawn_exits == true then
        
        pos_straight_ahead(exit_pos)    
        
        exit_section = spawn_random_section(exit_pos, false)               
    else
        spawn_floor_trigger(pos.x, pos.y, pos, section)
        --spawn_arch(pos.x, pos.y, exit_pos.facing, pos, section)
    end
           
    straight_ahead(pos, true, section)
    turn_right(pos, true, section)
    straight_ahead(pos, true, section)

   if spawn_exits == true then
        exit_pos = global_scripts.script.copy_pos(pos)
        
        spawn_random_section(exit_pos, false)
    end
    
    return section
end

section_type = {"straight", "left_turn", "right_turn"}

spawn_functions = {straight = spawn_straight,
                   left_turn = spawn_left_turn,
                   right_turn = spawn_right_turn
                  }

function spawn_random_section(pos, do_exits)
    local section_type = section_type[math.random(3)]
    
    local section = spawn_functions[section_type](pos, do_exits)
    table.insert(dungeon_sections, section)
    
    return section
end

function stepTeleport(trigger_id)
    local trigger = findEntity(trigger_id)
    
    local section_type = exit_sections[trigger.id].section_type
    print("came from id "..trigger.id.." which was a "..section_type)
    local facing = exit_sections[trigger.id].facing 
    
    start_pos.facing = facing
    start_pos.level = trigger.level    
    
    for _, section in ipairs(dungeon_sections) do
        for _, go in ipairs(section.walls) do
            go:destroyDelayed()
        end
        for _, go in ipairs(section.floor_triggers) do
            go:destroyDelayed()
        end
        for _, go in ipairs(section.teleporters) do
            go:destroyDelayed()
        end
    end
    
    dungeon_sections = {}
    exit_sections = {}

    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)
    local section = spawn_functions[section_type](start_spawn_pos, true)
    table.insert(dungeon_sections, section)        

    party:setPosition(start_pos.x, start_pos.y, party.facing, start_pos.elevation, start_pos.level)
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
    start_pos.level = trigger.level
    
    local start_spawn_pos = global_scripts.script.copy_pos(start_pos)
    
    spawn_random_section(start_spawn_pos, true)
end

function init()    
    --test_inside_sky.sky:setFogMode("dense")
    --test_inside_sky.sky:setFogRange({1,2})
    dungeon_door_iron_barred_1.door:close()
end