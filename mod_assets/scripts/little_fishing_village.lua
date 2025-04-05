function alert_community()
    for _, npc_data in ipairs(npcs) do
        npc_data.state = "aggressive"
    end
end

stealCompassAnimation_id = -1

function putItem(pedestal, item)
    if item.name == "compass" or item.name == "cursed_compass" then
        global_scripts.script.remove_animation(zarchton_altar_compass.level, stealCompassAnimation_id)
    end
end

function stealCompass()
    global_scripts.script.playSoundAtObject("cage_rattle", zarchton_altar_compass)
    
    local animation = triels_robin_script_entitiy.script.raisePedestal("zarchton_altar_compass", true, -1)   
    animation.delay = 2
    animation.on_finish=alert_community
    stealCompassAnimation_id = global_scripts.script.add_animation(zarchton_altar_compass.level, animation)
end

marea_multiplier = 6/9
marea_height = 0.5

function set_ocean_level(time_delta, animation)    
    for _, ocean_entity_id in ipairs(animation.ocean_entity_ids) do
        local ocean_entity = findEntity(ocean_entity_id)
        local w_pos = ocean_entity:getWorldPosition()
        w_pos.y = marea_height * math.sin(animation.elapsed/2)
        ocean_entity:setWorldPosition(w_pos)
    end
end

npcs = {
    {
        id = "zarchton_elder",
        idle_default = "idle_guard",
        state = "idle_guard",
        home_id = "zarchton_elder_home",
        home_door_lever_id = "zarchton_elder_home_lever",
        goto = {}
    },
    {
        id = "zarchton_npc_1",
        idle_default = "idle_wander",
        state = "idle_wander",
        home_id = "zarchton_npc_1_home",
        home_door_lever_id = "zarchton_npc_1_home_lever",
        goto = {}
    }
}
function init()
    local animation = {func=set_ocean_level, step=.01, duration=-1, ocean_entity_ids={"beach_ocean_7", "beach_ocean_8", "beach_ocean_9"}}
    global_scripts.script.add_animation(beach_ocean_7.level, animation)
    -- triels_robin_script_entitiy.script.goTilMorning(party)

    dungeon_tile_01.model:setMaterial("dungeon_floor_dirt_meridian_line")

    --merchants_script_entity.script.component_offset(forest_bridge_28.model, vec(0, 1, 0))
    -- merchants_script_entity.script.component_offset(forest_bridge_pillar_8.model, vec(0, 1, 0))
    -- merchants_script_entity.script.component_offset(forest_bridge_pillar_9.model, vec(0, 1, 0))

    for _, npc_data in ipairs(npcs) do
        npc_script_entity.script.add_npc(npc_data)
    end
end
