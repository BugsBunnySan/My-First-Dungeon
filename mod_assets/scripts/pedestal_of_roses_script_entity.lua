function check_exits(enter_section, entry_marker, exit_types, start_spawn_pos, party_pos)
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
        elseif enter_section.pos.facing == 3 then
            exit_types[4] = "nop"
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
            start_spawn_pos.x = start_spawn_pos.x + 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    end 

    return start_spawn_pos, party_pos
end