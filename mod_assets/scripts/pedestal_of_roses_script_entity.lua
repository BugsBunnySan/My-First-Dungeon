roses_on_pedestal = 2
pedestal_active = true

function onRemoveItemPedestalOfRoses(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
    
    if item.name == "red_gem" then
        roses_on_pedestal = roses_on_pedestal - 1
    end
    
    if roses_on_pedestal == 0 and pedestal_active then
        pedestal_active = false
        for _, spawn_point_id in ipairs({"por_spawn_guardian_01", "por_spawn_guardian_02", "por_spawn_guardian_03", "por_spawn_guardian_04"}) do
            local spawn_point = findEntity(spawn_point_id)
            spawn_point:spawn("medusa")
        end
    end
end

function onInsertItemPedestalOfRoses(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
    
    if item.name == "red_gem" then
        roses_on_pedestal = roses_on_pedestal + 1
    end
end

function straight_offset(section, pos)        
    if section.pos.facing == 0 then
        exit_types[2] = "nop"
        start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                               
        start_spawn_pos.y = start_spawn_pos.y + 3                                       
        party_pos = global_scripts.script.copy_pos(start_spawn_pos)
        start_spawn_pos.facing = enter_section.pos.facing
    end
    
end

function check_exits(enter_section, entry_marker, start_spawn_pos, party_pos)
    if enter_section.section_type == "straight" then
        if enter_section.pos.facing == 0 then
            enter_section.exit_types[2] = "nop"
            enter_section.exits[2] = tricksters_domain_script_entity.script.makeNop()
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

function in_range(virtual_pos, special_place, enter_section, check_exits)
    local is_in_range = false
    local check_pos = global_scripts.script.copy_pos(virtual_pos)
    if enter_section.section_type == "straight" and enter_section.pos.facing == 0 then
        check_pos.y = check_pos.y - 3
        if check_exits == true then
            is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
        end
    elseif enter_section.section_type == "left_turn" and enter_section.pos.facing == 1 then
        check_pos.y = check_pos.y - 2
        check_pos.x = check_pos.x + 1
        if check_exits == true then
            is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
        end
    elseif enter_section.section_type == "right_turn" and enter_section.pos.facing == 3 then
        check_pos.y = check_pos.y - 2
        check_pos.x = check_pos.x - 1   
        if check_exits == true then
            is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
        end                    
    elseif enter_section.section_type == "T_junction_left" then
        if enter_section.pos.facing == 0 then
            check_pos.y = check_pos.y - 3
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[3], false)
            end
        elseif enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x + 1
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
            end
        end
    elseif enter_section.section_type == "T_junction_T" then
        if enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x + 1 
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
            end 
        elseif enter_section.pos.facing == 3 then 
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x - 1 
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[3], false)
            end                                         
        end
    elseif enter_section.section_type == "T_junction_right" then
        if enter_section.pos.facing == 0 then                                       
            check_pos.y = check_pos.y - 3
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
            end                       
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x - 1 
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[3], false)
            end                      
        end
    elseif enter_section.section_type == "X_junction" then
        if enter_section.pos.facing == 0 then          
            check_pos.y = check_pos.y - 3 
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[3], false)
            end   
        elseif enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x + 1
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[2], false)
            end 
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x - 1 
            if check_exits == true then
                is_in_range = in_range(check_pos, special_place, enter_section.exits[4], false)
            end
        end
    end
    
    if check_exits == false then
        is_in_range = check_pos.x >= special_place.x1 and check_pos.x <= special_place.x2 and check_pos.y >= special_place.y1 and check_pos.y <= special_place.y2 
    end
    return is_in_range
end