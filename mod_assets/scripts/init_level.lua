function initLevel()
    GameMode.setTimeOfDay(0.5)
    local wizard = party.party:getChampion(4)
    wizard:trainSkill("concentration", 5, false)
    wizard:trainSkill("fire_magic", 5, false)
    wizard:trainSkill("air_magic", 5, false)
    local guard_med_cab_note = spawn("scroll").item
    guard_med_cab_note.go.scrollitem:setScrollText("If you mess up with the security system again\nremember the code to the medical cabinet is\n UpDownUpDownUpDownUpDown")
    guard_personal_alcove.surface:addItem(guard_med_cab_note)
    local y = water_disciple_5_teleporter.teleporter.go:getWorldPositionY()
    water_disciple_5_teleporter.teleporter.go:setWorldPositionY(y+.1)
end