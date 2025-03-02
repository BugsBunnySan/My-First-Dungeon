idioma = "english"

floor_trigger_idiomas = {floor_trigger_english = "english",
                         floor_trigger_espanol = "espanol",
                         floor_trigger_deutsch = "deutsch"}

teleporter_ids = {"teleporter_english", "teleporter_espanol", "teleporter_deutsch"}

function floorTriggerSteppedOn(trigger)
    trigger = global_scripts.script.getGO(trigger)
    
    idioma = floor_trigger_idiomas[trigger.id]
    
    set_language()
    
    for _,teleporter_id in ipairs(teleporter_ids) do
        local teleporter = findEntity(teleporter_id)
        teleporter.teleporter:setTriggeredByParty(true)       
    end
end
   
language_table = {heroes_level_up_text = {component = "walltext", english = "Choose Heroes and level up enough\nfor the adventure", 
                                                                  espanol = "Eliga tus heroes y suba bastante niveles\npara la aventura", 
                                                                  deutsch = "Waehle deine Helden und levele sie genuegend\n hoch fuer das Abent3euer"}}
                                    
function init()

end

function set_language()
    for id, language_data in pairs(language_table) do
        local text = findEntity(id):getComponent(language_data.component)
        text:setWallText(language_data[idioma]) 
    end    
end