function initDungeon()    
    GameMode.setTimeOfDay(0.5)
    initParty()
    initCastleOfWater()
    initMoistCatacombs()
    initCloister()
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
    GameMode.setTimeOfDay(0.0)
end