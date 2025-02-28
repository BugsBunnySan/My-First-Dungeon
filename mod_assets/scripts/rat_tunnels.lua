return_locations = {floor_trigger_robin_rat_tunnels_01 = "spawn_robin_rats_01",
                    floor_trigger_robin_rat_tunnels_02 = "spawn_robin_rats_02",
                    floor_trigger_robin_rat_tunnels_03 = "spawn_robin_rats_03"}

ladders = {ladder_lever_robin_rats_01 = "ladder_robin_rats_01",
           ladder_lever_robin_rats_02 = "ladder_robin_rats_02",
           ladder_lever_robin_rats_03 = "ladder_robin_rats_03"}

function raiseLadder(trigger)
    trigger = global_scripts.script.getGO(trigger)
   
    local ladder_id = ladders[trigger.id]
    
    triels_robin_script_entitiy.script.raisePedestal(ladder_id, false)   
end

function lowerLadder(trigger)
    trigger = global_scripts.script.getGO(trigger)
   
    local ladder_id = ladders[trigger.id]
    
    triels_robin_script_entitiy.script.raisePedestal(ladder_id, false, -1)   
end

function returnPartyToSurface(trigger)
    trigger = global_scripts.script.getGO(trigger)
    
    local return_pos = findEntity(return_locations[trigger.id])
    
    party:setPosition(return_pos.x, return_pos.y, return_pos.facing, return_pos.elevation, return_pos.level)
end