roses_on_pedestal = 2
pedestal_active = true

function init()
    for _, guardian_id in ipairs({"por_guardian_1", "por_guardian_2", "por_guardian_3", "por_guardian_4"}) do
        local guardian = findEntity(guardian_id)
        guardian.monster:setMonsterFlag("Invulnerable", true)
        guardian.model:setMaterial("medusa_stone")
        guardian:setWorldPositionY(.65)
    end
    for _, petrifying_light_id in ipairs({"por_guardian_petrify_light_1", "por_guardian_petrify_light_2", "por_guardian_petrify_light_3", "por_guardian_petrify_light_4"}) do
        local petrifying_light = findEntity(petrifying_light_id)        
        petrifying_light.pointlight:setColor(vec(0.5,0.5,0.5))
    end
end

function delete_platform(time_delta, animation)
    local platform = findEntity(animation.platform_id)
    platform:destroyDelayed()
end

function onEndBossFight()
    por_boss_fight.bossfight:deactivate()   
    pedestal_of_roses_door.door:open()
end

function onRemoveItemPedestalOfRoses(pedestal, item)
    pedestal = global_scripts.script.getGO(pedestal)
    item = global_scripts.script.getGO(item)
    
    if item.name == "red_gem" then
        roses_on_pedestal = roses_on_pedestal - 1
    end
    
    if roses_on_pedestal == 0 and pedestal_active then
        pedestal_active = false
        for _, guardian_id in ipairs({"por_guardian_1", "por_guardian_2", "por_guardian_3", "por_guardian_4"}) do
            local guardian = findEntity(guardian_id)
            guardian:setWorldPositionY(0)
            guardian.monster:setMonsterFlag("Invulnerable", false)
            guardian.model:setMaterial("spirit_light")
            guardian.animation:enable()
            guardian.brain:enable()
            por_boss_fight.bossfight:addMonster(guardian.monster)            
        end
        por_boss_fight.bossfight:activate()
        pedestal_of_roses_door.door:close()
        for _, petrifying_slime_id in ipairs({"por_petrifying_slime_1", "por_petrifying_slime_2", "por_petrifying_slime_3", "por_petrifying_slime_4"}) do
            local petrifying_slime = findEntity(petrifying_slime_id)
            petrifying_slime.petrification_dustParticles:stop()
        end
        for _, petrifying_light_id in ipairs({"por_guardian_petrify_light_1", "por_guardian_petrify_light_2", "por_guardian_petrify_light_3", "por_guardian_petrify_light_4"}) do
            local petrifying_light = findEntity(petrifying_light_id)
            petrifying_light.pointlight:disable()
        end
        for _, platform_id in ipairs({"beacon_furnace_1", "beacon_furnace_2", "beacon_furnace_3", "beacon_furnace_4"}) do
            local animation = triels_robin_script_entitiy.script.raisePedestal(platform_id, true, -1)
            animation.platform_id = platform_id
            animation.on_finish = delete_platform
            global_scripts.script.add_animation(pedestal.level, animation)
        end
        for _, rune_id in ipairs({"beacon_furnace_rune_earth_1", "beacon_furnace_rune_earth_2", "beacon_furnace_rune_earth_3", "beacon_furnace_rune_earth_4"}) do
            local rune = findEntity(rune_id)
            rune:destroyDelayed()
        end
        -- for _, spawn_point_id in ipairs({"por_spawn_guardian_01", "por_spawn_guardian_02", "por_spawn_guardian_03", "por_spawn_guardian_04"}) do
            -- local spawn_point = findEntity(spawn_point_id)
            -- spawn_point:spawn("medusa")
        -- end
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

function make_special_entry(pos)
    local light = global_scripts.script.spawnAtObject("catacomb_altar_candle_01", pos, pos.facing)
    light.surface:disable()
    light.clickable:disable()
    light.obstacle:disable()
    light.projectilecollider:disable()
    light.model:disable()
    --light.light:setRange(5)
    return light
end

function check_exits(enter_section, entry_marker, start_spawn_pos, party_pos)
    local exit_idx = -1

    if enter_section.section_type == "straight" then
        if enter_section.pos.facing == 0 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                               
            start_spawn_pos.y = start_spawn_pos.y + 3                                       
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "left_turn" and enter_section.pos.facing == 1 then
        exit_idx = 2
        start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
        start_spawn_pos.y = start_spawn_pos.y + 2
        start_spawn_pos.x = start_spawn_pos.x - 1                                    
        party_pos = global_scripts.script.copy_pos(start_spawn_pos)
        start_spawn_pos.facing = enter_section.pos.facing
    elseif enter_section.section_type == "right_turn" and enter_section.pos.facing == 3 then
        exit_idx = 2
        start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
        start_spawn_pos.y = start_spawn_pos.y + 2
        start_spawn_pos.x = start_spawn_pos.x + 1                                    
        party_pos = global_scripts.script.copy_pos(start_spawn_pos)
        start_spawn_pos.facing = enter_section.pos.facing
    elseif enter_section.section_type == "T_junction_left" then
        if enter_section.pos.facing == 0 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                        
            start_spawn_pos.y = start_spawn_pos.y + 3                            
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 1 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
            start_spawn_pos.x = start_spawn_pos.x - 1                            
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "T_junction_T" then
        if enter_section.pos.facing == 1 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
            start_spawn_pos.x = start_spawn_pos.x - 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 3 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
            start_spawn_pos.x = start_spawn_pos.x + 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "T_junction_right" then
        if enter_section.pos.facing == 0 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)                                        
            start_spawn_pos.y = start_spawn_pos.y + 3                            
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 3 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
            start_spawn_pos.x = start_spawn_pos.x + 1                        
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        end
    elseif enter_section.section_type == "X_junction" then
        if enter_section.pos.facing == 0 then
            exit_idx = 3
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)              
            start_spawn_pos.y = start_spawn_pos.y + 3                        
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 1 then
            exit_idx = 2
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
            start_spawn_pos.x = start_spawn_pos.x - 1                                    
            party_pos = global_scripts.script.copy_pos(start_spawn_pos)
            start_spawn_pos.facing = enter_section.pos.facing
        elseif enter_section.pos.facing == 3 then
            exit_idx = 4
            start_spawn_pos = global_scripts.script.copy_pos(entry_marker)
            start_spawn_pos.y = start_spawn_pos.y + 2
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
        is_in_range = (check_pos.facing == 0)
    elseif enter_section.section_type == "straight" and enter_section.pos.facing == 0 then
        check_pos.y = check_pos.y - 3
        is_in_range = true
    elseif enter_section.section_type == "left_turn" and enter_section.pos.facing == 1 then
        check_pos.y = check_pos.y - 2
        check_pos.x = check_pos.x + 1
        is_in_range = true
    elseif enter_section.section_type == "right_turn" and enter_section.pos.facing == 3 then
        check_pos.y = check_pos.y - 2
        check_pos.x = check_pos.x - 1 
        is_in_range = true
    elseif enter_section.section_type == "T_junction_left" then
        if enter_section.pos.facing == 0 then
            check_pos.y = check_pos.y - 3
            is_in_range = true
        elseif enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x + 1
            is_in_range = true
        end
    elseif enter_section.section_type == "T_junction_T" then
        if enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x + 1 
            is_in_range = true
        elseif enter_section.pos.facing == 3 then 
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x - 1  
            is_in_range = true            
        end
    elseif enter_section.section_type == "T_junction_right" then
        if enter_section.pos.facing == 0 then                                       
            check_pos.y = check_pos.y - 3
            is_in_range = true
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x - 1 
            is_in_range = true
        end
    elseif enter_section.section_type == "X_junction" then
        if enter_section.pos.facing == 0 then          
            check_pos.y = check_pos.y - 3 
            is_in_range = true
        elseif enter_section.pos.facing == 1 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x + 1
            is_in_range = true
        elseif enter_section.pos.facing == 3 then
            check_pos.y = check_pos.y - 2
            check_pos.x = check_pos.x - 1 
            is_in_range = true
        end
    end
    
    is_in_range = is_in_range and (check_pos.x >= special_place.x1 and check_pos.x <= special_place.x2 and check_pos.y >= special_place.y1 and check_pos.y <= special_place.y2)
    
    return is_in_range
end