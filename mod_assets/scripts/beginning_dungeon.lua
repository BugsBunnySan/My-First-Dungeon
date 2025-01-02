function leverBreaks()
    playSoundAt("cage_rattle", blob_door_lever.model.go.level, blob_door_lever.model.go.x, blob_door_lever.model.go.y)
    blob_door_lever.lever:disable()
    blob_door_lever.clickable:disable()
    spawn("gear_necklace", blob_door_lever.model.go.level, blob_door_lever.model.go.x, blob_door_lever.model.go.y, 3, -1)
end
