dungeon_parts = {}

function spawn_wall(x, y, facing, trigger)
    local wall = spawn("dungeon_secret_door")
    wall:setPosition(x, y, facing, trigger.elevation, trigger.level)
    table.insert(dungeon_parts, wall)    
end

function spawn_teleporter(x, y, trigger, facing)
    local teleporter = spawn("invisible_teleporter")
    teleporter:setPosition(x, y, facing, trigger.elevation, trigger.level)
    teleporter.teleporter:setTeleportTarget(trigger.level, trigger.x, trigger.y, trigger.elevation)
    teleporter.teleporter:setSpin(global_scripts.script.facing_names[facing])
    table.insert(dungeon_parts, teleporter)
end

function spawn_exit_marker(x, y, trigger, facing)
    local exit_marker = spawn("invisible_wall")
    exit_marker:setPosition(x, y, facing, trigger.elevation, trigger.level)
    exit_marker.obstacle:disable()
    exit_marker.projectcolider:disable()
    table.insert(dungeon_parts, exit_marker)
end

function spawn_hallway(spawn_marker, dx, dy, dfacing)
    local facing = dfacing or spawn_marker.facing
    if facing == 0 or facing == 2 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 1, spawn_marker)
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 3, spawn_marker)
    elseif facing == 1 or facing == 3 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 0, spawn_marker)
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 2, spawn_marker)
    end
end

function spawn_left_corner(spawn_marker, dx, dy, dfacing)
    local facing = dfacing or spawn_marker.facing
    if facing == 0 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 0, spawn_marker)
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 3, spawn_marker)
    elseif facing == 1 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 1, spawn_marker) 
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 0, spawn_marker)      
    elseif facing == 2 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 2, spawn_marker) 
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 1, spawn_marker)       
    elseif facing == 3 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 3, spawn_marker) 
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 2, spawn_marker)      
    end    
end

function spawn_right_corner(spawn_marker, dx, dy, dfacing)
    local facing = dfacing or spawn_marker.facing
    if facing == 0 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 0, spawn_marker)
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 1, spawn_marker)
    elseif facing == 1 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 1, spawn_marker)
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 2, spawn_marker)       
    elseif facing == 2 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 2, spawn_marker) 
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 3, spawn_marker)       
    elseif facing == 3 then
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 3, spawn_marker) 
        spawn_wall(spawn_marker.x+dx, spawn_marker.y+dy, 0, spawn_marker)      
    end    
end

function gen_left_turn(trigger)
    spawn_hallway(trigger, 0, 0)
    spawn_left_corner(trigger, 0, -1)
    spawn_hallway(trigger, -1, -1, 3)
    
    spawn_exit_marker(trigger.x, trigger.y+1, trigger, 2)
    spawn_exit_marker(trigger.x-2, trigger.y-1, trigger, 3)
    
    spawn_teleporter(trigger.x-2, trigger.y-1, trigger, 0)
end

function gen_right_turn(trigger)
    spawn_hallway(trigger, 0, 0)
    spawn_left_corner(trigger, 0, -1)
    spawn_hallway(trigger, -1, -1, 3)
    
    spawn_exit_marker(trigger.x, trigger.y+1, trigger, 2)
    spawn_exit_marker(trigger.x-2, trigger.y-1, trigger, 3)
    
    spawn_teleporter(trigger.x+2, trigger.y-1, trigger, 0)    
end

function gen_straight(trigger)
    spawn_wall(trigger.x, trigger.y, 1, trigger)
    spawn_wall(trigger.x, trigger.y, 3, trigger)
    spawn_wall(trigger.x, trigger.y-1, 1, trigger)
    spawn_wall(trigger.x, trigger.y-1, 3, trigger)
    spawn_wall(trigger.x, trigger.y-2, 1, trigger)
    spawn_wall(trigger.x, trigger.y-2, 3, trigger)
    
    spawn_teleporter(trigger.x, trigger.y-3, trigger, 0)  
end

function gen_t_junction(trigger)
    spawn_wall(trigger.x, trigger.y, 1, trigger)
    spawn_wall(trigger.x, trigger.y, 3, trigger)
    spawn_wall(trigger.x, trigger.y-1, 0, trigger)
    spawn_wall(trigger.x-1, trigger.y-1, 0, trigger)
    spawn_wall(trigger.x-1, trigger.y-1, 2, trigger)
    spawn_wall(trigger.x+1, trigger.y-1, 0, trigger)
    spawn_wall(trigger.x+1, trigger.y-1, 2, trigger)
    
    spawn_teleporter(trigger.x-1, trigger.y-1, trigger, 0)
    spawn_teleporter(trigger.x+1, trigger.y-1, trigger, 0)
end

function gen_x_junction(trigger)
    spawn_wall(trigger.x, trigger.y, 1, trigger)
    spawn_wall(trigger.x, trigger.y, 3, trigger)
    spawn_wall(trigger.x-1, trigger.y-1, 0, trigger)
    spawn_wall(trigger.x-1, trigger.y-1, 2, trigger)
    spawn_wall(trigger.x+1, trigger.y-1, 0, trigger)
    spawn_wall(trigger.x+1, trigger.y-1, 2, trigger)
    spawn_wall(trigger.x, trigger.y-2, 1, trigger)
    spawn_wall(trigger.x, trigger.y-2, 3, trigger)
    
    spawn_teleporter(trigger.x-1, trigger.y-1, trigger, 0)
    spawn_teleporter(trigger.x+1, trigger.y-1, trigger, 0)
    spawn_teleporter(trigger.x, trigger.y-2, trigger, 0)
end




sections = {gen_left_turn,
            gen_right_turn,
            gen_straight,
            gen_t_junction,
            gen_x_junction}          

last_section = 3

function spawnDungeonSection(trigger)  
    trigger = global_scripts.script.getGO(trigger)
    --global_scripts.script.playSoundAtObject("wall_sliding", trigger)
    local section = math.random(3)    
    for _, dungeon_part in ipairs(dungeon_parts) do
        dungeon_part:destroyDelayed()        
    end
    dungeon_parts = {}
    sections[section](trigger)
    last_sections[last_section](spawn_last_section, trigger)
    last_section = section
end

function init()    
    --test_inside_sky.sky:setFogMode("dense")
    --test_inside_sky.sky:setFogRange({1,2})
    dungeon_door_iron_barred_1.door:close()
end