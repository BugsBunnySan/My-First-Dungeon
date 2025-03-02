function armCannon1(self, initial)    
    cannon_daemon_1.brain:enable()
    cannon_daemon_1_light.light:enable()
    cannon_daemon_1_light.sound:enable()
    cannon_daemon_1_light.particle:enable()
    cannon_daemon_1_light.socket:enable()
    local torchCount = cannon_daemon_1_light.socket:count()            
    if torchCount == 0 then
        local torch = spawn("torch").item
        cannon_daemon_1_light.socket:addItem(torch)
    end
    cannon_daemon_1_light.controller:setHasTorch(true)
    cannon_daemon_1_pilot_light.controller:activate()
    if initial == nil then
        cannon_daemon_1.brain:performAction("manualAlert")     
        hudPrint("Security System Activated")  
    end
end

function disableCannon1(self)
    cannon_daemon_1_light.light:disable()
    cannon_daemon_1_light.sound:disable()
    cannon_daemon_1_light.particle:disable()
    local torchCount = cannon_daemon_1_light.socket:count()            
    if torchCount > 0 then
        local torch = cannon_daemon_1_light.socket:getItem()
        torch.go:destroyDelayed()
    end
    cannon_daemon_1_light.controller:setHasTorch(false)
    cannon_daemon_1_pilot_light.controller:deactivate()
    cannon_daemon_1.brain:disable()
    hudPrint("Security System Deactivated")
end

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
    global_scripts.script.party_gain_health({1, 2, 3, 4}, 15)
    global_scripts.script.party_conditions({1, 2, 3, 4}, {"water_breathing"}, {})
end

function init()
    local guard_med_cab_note = spawn("scroll").item
    guard_med_cab_note.go.scrollitem:setScrollText("If you mess up with the security system again\nremember the code to the medical cabinet is\n UpDownUpDownUpDownUpDown")
    guard_personal_alcove.surface:addItem(guard_med_cab_note)
    local y = water_disciple_5_teleporter.teleporter.go:getWorldPositionY()
    water_disciple_5_teleporter.teleporter.go:setWorldPositionY(y+.1)
    med_station_light.light:disable()
    
    fish_timer.timer:start()   
    energy_pool_timer.timer:disable()
    energy_pool_timer.timer:setTimerInterval(1)
    
    castle_of_water_script_entity.script.armCannon1(nil, true)       

    sg_power_timer.timer:disable() 
end