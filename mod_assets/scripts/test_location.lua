function make_special_entry(pos)
    local light = global_scripts.script.spawnAtObject("catacomb_altar_candle_01", pos, pos.facing)
    light.surface:disable()
    light.clickable:disable()
    light.obstacle:disable()
    light.projectilecollider:disable()
    light.model:disable()
    light.light:setRange(5)
    return light
end

function check_exits(enter_section, entry_marker, exit_types, start_spawn_pos, party_pos)
    local exit_idx = -1

    if enter_section.section_type == "straight" then
        if enter_section.pos.facing == 2 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                               
            start_spawn_pos.y = start_spawn_pos.y - 3                                       
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "left_turn" and enter_section.pos.facing == 3 then
            exit_idx = 2
        start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
        start_spawn_pos.y = start_spawn_pos.y - 2
        start_spawn_pos.x = start_spawn_pos.x + 1                                    
        party_pos = global_scripts.script.copy_pos(start_spawn_pos)
        start_spawn_pos.facing = enter_section.pos.facing
    elseif enter_section.section_type == "right_turn" and enter_section.pos.facing == 1 then
            exit_idx = 2
        start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
        start_spawn_pos.y = start_spawn_pos.y - 2
        start_spawn_pos.x = start_spawn_pos.x - 1                                    
        party_pos = global_scripts.script.copy_pos(start_spawn_pos)
        start_spawn_pos.facing = enter_section.pos.facing
    elseif enter_section.section_type == "T_junction_left" then
        if enter_section.pos.facing == 2 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                        
            start_spawn_pos.y = start_spawn_pos.y - 3                            
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 3 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y - 2
            start_spawn_pos.x = start_spawn_pos.x + 1                            
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "T_junction_T" then
        if enter_section.pos.facing == 1 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y - 2
            start_spawn_pos.x = start_spawn_pos.x - 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 3 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y - 2
            start_spawn_pos.x = start_spawn_pos.x + 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "T_junction_right" then
        if enter_section.pos.facing == 2 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                        
            start_spawn_pos.y = start_spawn_pos.y - 3                            
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 1 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y - 2
            start_spawn_pos.x = start_spawn_pos.x - 1                        
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "X_junction" then
        if enter_section.pos.facing == 2 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)              
            start_spawn_pos.y = start_spawn_pos.y - 3                        
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 1 then
            exit_idx = 4
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y - 2
            start_spawn_pos.x = start_spawn_pos.x - 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 3 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y - 2
            start_spawn_pos.x = start_spawn_pos.x + 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    end 

    return start_spawn_pos, party_pos, exit_idx
end

function in_range(virtual_pos, special_place, enter_section)
    local is_in_range = false
    
    local check_pos = global_scripts.script.copy_pos(virtual_pos)
    
    if enter_section == nil then
        is_in_range = (check_pos.facing == 2)
    elseif enter_section.section_type == "straight" and enter_section.pos.facing == 2 then                                          
        check_pos.y = check_pos.y + 3 
        is_in_range = true 
    elseif enter_section.section_type == "left_turn" and enter_section.pos.facing == 3 then
        check_pos.y = check_pos.y + 2
        check_pos.x = check_pos.x - 1 
        is_in_range = true   
    elseif enter_section.section_type == "right_turn" and enter_section.pos.facing == 1 then
        check_pos.y = check_pos.y + 2
        check_pos.x = check_pos.x + 1 
        is_in_range = true  
    elseif enter_section.section_type == "T_junction_left" then
        if enter_section.pos.facing == 2 then                               
            check_pos.y = check_pos.y + 3 
            is_in_range = true            
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y + 2
            check_pos.x = check_pos.x - 1 
            is_in_range = true  
        end
    elseif enter_section.section_type == "T_junction_T" then
        if enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y + 2
            check_pos.x = check_pos.x + 1   
            is_in_range = true
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y + 2
            check_pos.x = check_pos.x - 1  
            is_in_range = true  
        end
    elseif enter_section.section_type == "T_junction_right" then
        if enter_section.pos.facing == 2 then                                     
            check_pos.y = check_pos.y + 3   
            is_in_range = true   
        elseif enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y + 2
            check_pos.x = check_pos.x + 1  
            is_in_range = true  
        end
    elseif enter_section.section_type == "X_junction" then
        if enter_section.pos.facing == 2 then        
            check_pos.y = check_pos.y + 3   
            is_in_range = true         
        elseif enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y + 2
            check_pos.x = check_pos.x + 1 
            is_in_range = true            
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y + 2
            check_pos.x = check_pos.x - 1
            is_in_range = true 
        end
    end 
    
    is_in_range = is_in_range and (check_pos.x >= special_place.x1 and check_pos.x <= special_place.x2 and check_pos.y >= special_place.y1 and check_pos.y <= special_place.y2)
    
    return is_in_range
end