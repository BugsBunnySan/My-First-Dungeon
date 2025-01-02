function leverBreaks()
    playSoundAt("cage_rattle", blob_door_lever.model.go.level, blob_door_lever.model.go.x, blob_door_lever.model.go.y+1)
    blob_door_lever.lever:disable()
    blob_door_lever.clickable:disable()
    spawn("gear_necklace", blob_door_lever.model.go.level, blob_door_lever.model.go.x, blob_door_lever.model.go.y, 3, -1)
end

rubble_pedestals = {["rubble_pedestal_2"] = {["rubble"] = {"rubble_2"},
                                            ["kin"] = {"rubble_pedestal_1"}},
                    ["rubble_pedestal_1"] = {["rubble"] = {"rubble_1"},
                                            ["kin"] = {"rubble_pedestal_2"}}
                   }

function clearRubble(pedestal, item)
    if pedestal.go ~= nil then
        pedestal = pedestal.go
    end
    for _, rubble_n in ipairs(rubble_pedestals[pedestal.id]["rubble"]) do
        local rubble = findEntity(rubble_n)
        rubble:destroyDelayed()
    end
    if item ~= nil then
        spawn(item.go.name, item.go.level, item.go.x, item.go.y, item.go.facing, item.go.elevation)
        item.go:destroyDelayed()        
        for _, kin_n in ipairs(rubble_pedestals[pedestal.id]["kin"]) do            
            local kin = findEntity(kin_n)            
            clearRubble(kin, nil)
        end
    end
    pedestal:destroyDelayed()
end