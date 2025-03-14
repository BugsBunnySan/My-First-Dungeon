marea_multiplier = 6/9
marea_height = 2

function set_ocean_level(time_delta, animation)    
    for _, ocean_entity_id in ipairs(animation.ocean_entity_ids) do
        local ocean_entity = findEntity(ocean_entity_id)
        local w_pos = ocean_entity:getWorldPosition()
        w_pos.y = marea_height * math.sin(animation.elapsed/2)
        ocean_entity:setWorldPosition(w_pos)
    end
end

function init()
    local animation = {func=set_ocean_level, step=.01, duration=-1, ocean_entity_ids={"beach_ocean_7", "beach_ocean_8", "beach_ocean_9"}}
    global_scripts.script.add_animation(beach_ocean_7.level, animation)
   -- triels_robin_script_entitiy.script.goTilMorning(party)
    
    dungeon_tile_01.model:setMaterial("dungeon_floor_dirt_meridian_line")
end
