function checkEntrance()
    local wearing_champions = global_scripts.script.party_wears_item({1, 2, 3, 4}, ItemSlot.Necklace, "runestone_necklace")
    hudPrint(tostring(#wearing_champions))
    if #wearing_champions > 0 then
        grantEntrance()
    else
        denyEntrance()
    end
end

function grantEntrance()
    medusa_left.brain:disable()
    medusa_right.brain:disable()
    main_gate.door:open()
end

function denyEntrance()
    medusa_left.brain:enable()
    medusa_right.brain:enable()    
    back_gate.door:close()
    back_gate_timer.timer:start()
end

function openBackGate()   
    back_gate.door:open()
    back_gate_timer.timer:stop()    
    medusa_left.brain:disable()
    medusa_right.brain:disable()
end

function spawnHerb()
    local herb_spawn = {{name = "blackmoss", max = 10, ground = {"swamp_ground", "swamp_ground2"}},
                        {name = "blooddrop_cap", max = 10, ground = {"forest_trees"}},
                        {name = "etherweed", max = 10, ground = {"mine_floor_crystal"}},
                        {name = "falconskyre", max = 10, ground = {"mine_floor_grass"}},
                        {name = "mudwort", max = 10, ground = {"swamp_ground", "swamp_ground2"}}}
    local herb_index = math.random(#herb_spawn)
    local herb = herb_spawn[herb_index]
    --hudPrint("Would spawn "..herb.name)
    -- if global_scripts.script.findEntities(herb.name, herb_spawn.level) < herb.max then
        -- local tile = global_scripts.script.findMapTiles(herb.ground, 1, true)
        -- if tile ~= nil then
            -- spawn(herb.name, herb_spawn.level, tile.x, tile.y, tile.facing, tile.elevation)
        -- end
    -- end
end