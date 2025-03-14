function enterLevel()
    init_dungeon.script.initParty()
    global_scripts.script.party_gain_health({1,2,3,4}, 500)
    global_scripts.script.party_gain_energy({1,2,3,4}, 500)
end

door_ids = {merchants_pickaxe_enter_floor_trigger = "merchants_hq_rubble_door_1",
            merchants_pickaxe_exit_floor_trigger = "merchants_hq_rubble_door_2"}
            
rubble_locations = {merchants_hq_rubble_spawn_location_1 = "merchants_hq_rubble_1",
                    merchants_hq_rubble_spawn_location_2 = "merchants_hq_rubble_2",
                    merchants_hq_rubble_spawn_location_3 = "merchants_hq_rubble_3"}
            
function closeDoor(trigger)
    trigger = global_scripts.script.getGO(trigger)
    local door_id = door_ids[trigger.id]
    local door = findEntity(door_id)
    door.door:close()
end

function onReturnPickaxe(alcove, item)
    item = global_scripts.script.getGO(item)
    item:destroyDelayed()
    
    merchants_hq_rubble_door_2.door:open()
end

function onEnterMiningTurotial(trigger)
    trigger:disable()
    merchants_pickaxe_exit_floor_trigger.floortrigger:enable()
    closeDoor(trigger)
end

function onExitMiningTutorial(trigger)
    trigger:disable()
    for location_id, rubble_id in pairs(rubble_locations) do
        local spawn_pos = findEntity(location_id)
        spawn("dungeon_cave_in", spawn_pos.level, spawn_pos.x ,spawn_pos.y, spawn_pos.facing, spawn_pos.elevation, rubble_id) 
        global_scripts.script.playSoundAtObject("summon_stone_attack", spawn_pos)        
    end
    global_scripts.script.resetRubblePedestal("merchants_hq_rubble_pedestal_1")
    global_scripts.script.resetRubblePedestal("merchants_hq_rubble_pedestal_2")
    closeDoor(trigger)
    local pickaxe = spawn("pickaxe")
    merchants_hq_pickaxe_dispenser.surface:addItem(pickaxe.item)
    merchants_pickaxe_enter_floor_trigger.floortrigger:enable()
end

function init()

end