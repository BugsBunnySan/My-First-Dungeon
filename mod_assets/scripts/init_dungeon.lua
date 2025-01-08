function initDungeon()    
    GameMode.setTimeOfDay(0.5)
    initParty()
    initCastleOfWater()
    initMoistCatacombs()
    initCloister()
    initBeach()
    initBeginningDungeon()
    initFieldOfHerbs()
end

function initParty()
    local wizard = party.party:getChampion(4)
    wizard:trainSkill("concentration", 5, false)
    wizard:trainSkill("fire_magic", 5, false)
    wizard:trainSkill("air_magic", 5, false)
    wizard:trainSkill("water_magic", 5, false)
    wizard:trainSkill("earth_magic", 5, false)
end

function initCastleOfWater()
    local guard_med_cab_note = spawn("scroll").item
    guard_med_cab_note.go.scrollitem:setScrollText("If you mess up with the security system again\nremember the code to the medical cabinet is\n UpDownUpDownUpDownUpDown")
    guard_personal_alcove.surface:addItem(guard_med_cab_note)
    local y = water_disciple_5_teleporter.teleporter.go:getWorldPositionY()
    water_disciple_5_teleporter.teleporter.go:setWorldPositionY(y+.1)
    med_station_light.light:disable()
    
    fish_timer.timer:start()
    energy_pool_timer.timer:disable()
    
    castle_of_water_script_entity.script.armCannon1(nil, true)
end

function initMoistCatacombs()
    cemetery_sky.sky:setFogMode("dense")
    cemetery_sky.sky:enable()
    cemetery_sky.fogparticles:setColor1(vec(0.2, 0.3, 0.9, 0))
    cemetery_sky.fogparticles:setColor2(vec(0.1, 0.15, 0.5, 0))
    cemetery_sky.fogparticles:setColor3(vec(0.1, 0.1, 0.3, 0))
    cemetery_sky.fogparticles:setOpacity(1)
    cemetery_sky.fogparticles:enable()
    forest_day_sky.sky:disable()
    forest_day_sky.light:disable()
    forest_day_sky.ambient:disable()
end

function initCloister()    
    local essence_of_air = spawn("essence_air").item
    beacon_air.socket:addItem(essence_of_air)
    timer_4.timer:start()
end

function initBeach()
end

function initBeginningDungeon()
    -- fix the utter stupidity which is the offset of this door model, like WTactualF
    beach_door_wood_3.frame.go:setSubtileOffset(-1.5, -1)
    beach_door_wood_4.frame.go:setSubtileOffset(-1.5, -1)
    beach_door_wood_5.frame.go:setSubtileOffset(-1.5, -2)
    beach_door_wood_6.frame.go:setSubtileOffset(-1.5, -2)
    
    timer_1.timer:stop()
    timer_2.timer:stop()
    timer_3.timer:stop()
    
    local w_pos = small_key_lock:getWorldPosition()
    w_pos = w_pos + vec(-0.2, -0.05, 1.55)    
    small_key_lock:setWorldPosition(w_pos)
end

function initFieldOfHerbs()
    herb_timer.timer:disable()
    herb_raiser_timer.timer:disable()
    --main_gate.door:setOpenVelocity(0.1)
end