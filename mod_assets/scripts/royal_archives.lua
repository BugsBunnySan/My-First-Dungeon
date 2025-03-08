onCastSpellHookId = nil

magic_bridges = {}

function castMagicBridge(party, champion, spell, data)
    local spawn_pos = global_scripts.script.copy_pos(party.go)
    local map = party.go.map
    tricksters_domain_script_entity.script.pos_straight_ahead(spawn_pos)					
    if map:isBlocked(spawn_pos.x, spawn_pos.y, spawn_pos.elevation) then
        tricksters_domain_script_entity.script.pos_straight_back(spawn_pos)
    end
    local magic_bridge = global_scripts.script.spawnAtObject("magic_bridge", spawn_pos, spawn_pos.facing)
    local cast_magic_bridge = {duration = champion:getSkillLevel("concentration") * 3, bridge_id=magic_bridge.id}
    table.insert(magic_bridges, cast_magic_bridge)
    return true
end

function destroyMagicBridge(magic_bridge_id)
    local magic_bridge = findEntity(magic_bridge_id)
    magic_bridge:destroyDelayed()
end

function time_out_magic_bridges(time_delta, animation)
    local remove_idx = {}
    for idx, cast_magic_bridge in ipairs(magic_bridges) do
        cast_magic_bridge.duration = cast_magic_bridge.duration - time_delta
        if cast_magic_bridge.duration <= 0 then
            local magic_bridge = findEntity(cast_magic_bridge.bridge_id)
            magic_bridge.controller:deactivate()
            delayedCall("royal_archives_script_entity", .5, "destroyMagicBridge", cast_magic_bridge.bridge_id)
            table.insert(remove_idx, idx)
        end
    end
    
    for _,idx in ipairs(remove_idx) do
        table.remove(magic_bridges, idx)
    end
end

function enableAnimation(time_delta, animation)
    local monster_id = table.remove(animation.monster_ids)
    local monster = findEntity(monster_id)
    monster.animation:enable()
    
    if #animation.monster_ids == 0 then
        animation.duration = 0
    end
end

railings = {ra_sylar_railing_01={x=0, y=-1.6}, ra_sylar_railing_02={x=0, y=-1.6}, ra_sylar_railing_03={x=0, y=-1.6}, ra_sylar_railing_04={x=0, y=-1.6}, ra_sylar_railing_05={x=0, y=-1.6}, ra_sylar_railing_06={x=0, y=-1.6}, ra_sylar_railing_07={x=0, y=-1.6}, ra_sylar_railing_08={x=0, y=-1.6}, ra_sylar_railing_09={x=0, y=-1.6},
ra_sylar_railing_pillar_01={x=-1.5, y=1.4}, ra_sylar_railing_pillar_02={x=-1.5, y=1.4}, ra_sylar_railing_pillar_03={x=-1.5, y=1.4}, ra_sylar_railing_pillar_04={x=-1.5, y=1.4}, ra_sylar_railing_pillar_05={x=-1.5, y=1.4}, ra_sylar_railing_pillar_06={x=-1.5, y=1.4}, ra_sylar_railing_pillar_07={x=-1.5, y=1.4},  ra_sylar_railing_pillar_08={x=-1.5, y=1.4},
ra_carals_railing_01={x=0, y=-1.4}, ra_carals_railing_02={x=0, y=-1.4}, ra_carals_railing_03={x=0, y=-1.4}, ra_carals_railing_04={x=0, y=-1.4}, ra_carals_railing_05={x=0, y=-1.4}, ra_carals_railing_06={x=0, y=-1.4}, ra_carals_railing_07={x=0, y=-1.4}, ra_carals_railing_08={x=0, y=-1.4}, ra_carals_railing_09={x=0, y=-1.4},
ra_carals_railing_pillar_01={x=-1.5, y=1.6}, ra_carals_railing_pillar_02={x=-1.5, y=1.6}, ra_carals_railing_pillar_03={x=-1.5, y=1.6}, ra_carals_railing_pillar_04={x=-1.5, y=1.6}, ra_carals_railing_pillar_05={x=-1.5, y=1.6}, ra_carals_railing_pillar_06={x=-1.5, y=1.6}, ra_carals_railing_pillar_07={x=-1.5, y=1.6},  ra_carals_railing_pillar_08={x=-1.5, y=1.6}, 
castle_wall_cloth_17={x=1.6, y=0}, castle_wall_cloth_18={x=1.6, y=0}, castle_wall_cloth_20={x=1.6, y=0}}

function init()
    local animation = {func=time_out_magic_bridges, step=0.1, duration=-1}
    global_scripts.script.add_animation(0, animation)
    
    onCastSpellHookId = global_scripts.script.register_party_hook("onCastSpell", "royal_archives_script_entity", "castMagicBridge", {spell_name="cast_magic_bridge"})  


    local animation = {func=enableAnimation, step=.25, duration=-1, monster_ids={"dark_acolyte_spirit_1", "skeleton_commander_spirit_1", "dark_acolyte_spirit_2","skeleton_commander_spirit_2",  "dark_acolyte_spirit_3", "skeleton_commander_spirit_3",  "dark_acolyte_spirit_4", "skeleton_commander_spirit_4",  "dark_acolyte_spirit_5", "skeleton_commander_spirit_5", "dark_acolyte_spirit_6", "skeleton_commander_spirit_6", "dark_acolyte_spirit_7", "skeleton_commander_spirit_7",}}
    global_scripts.script.add_animation(royal_archives_script_entity.level, animation)
        
    for entity_id, offset in pairs(railings) do
        local entity = findEntity(entity_id)
        entity:setSubtileOffset(offset.x, offset.y)
    end
    
end

