doors = {pedestal_of_roses_lock = "pedestal_of_roses_door"}

function openDoor(lock)
    local lock = global_scripts.script.getGO(lock)
    local door = findEntity(doors[lock.id])
    door.door:open()
end

function init()
    pedestal_of_roses_script_entity.script.init()
    --pedestal_of_roses_candle_ilght.light:setRange(5)
end