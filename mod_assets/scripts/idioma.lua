idioma = "englisch"

floor_trigger_idiomas = {floor_trigger_english = "english",
                         floor_trigger_espanol = "espanol",
                         floor_trigger_deutsch = "deutsch"}

teleporter_ids = {"teleporter_english", "teleporter_espanol", "teleporter_deutsch"}

function floorTriggerSteppedOn(trigger)
    trigger = global_scripts.script.getGO(trigger)
    
    idioma = floor_trigger_idiomas[trigger.id]
    
    for _,teleporter_id in ipairs(teleporter_ids) do
        local teleporter = findEntity(teleporter_id)
        teleporter.teleporter:setTriggeredByParty(true)       
    end
end
    