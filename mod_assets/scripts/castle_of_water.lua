function spawnFish()
    local max_fishes = 10
    local fishes = global_scripts.script.findEntities("small_fish", fish_spawn_point.level)
    if #fishes < 10 then
        global_scripts.script.spawnAtObject("small_fish", fish_spawn_point)
    end
end

function enablePoolOfEnergy()  
    energy_pool_timer.timer:enable()
    global_scripts.script.party_conditions({1, 2, 3, 4}, {"water_breathing"}, {})
end

function disablePoolOfEnergy()
    energy_pool_timer.timer:disable()
    global_scripts.script.party_conditions({1, 2, 3, 4}, {}, {"water_breathing"})
end

function poolOfEnergy()
    global_scripts.script.party_gain_energy({1, 2, 3, 4}, 15)
    global_scripts.script.party_conditions({1, 2, 3, 4}, {"water_breathing"}, {})
end