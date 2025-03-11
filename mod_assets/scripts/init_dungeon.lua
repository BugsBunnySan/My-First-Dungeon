function initDungeon()    
    initGlobals()    
    initParty()
    levelUpParty()
    initCastleOfWater()
    initMoistCatacombs()
    initCloister()
    initBeach()
    initBeginningDungeon()
    initFieldOfHerbs()
    initLittleFishingVillage()
    initTrialsRobin()
    initTrickstersDomain()
    initTrickstersLocations()
    initForest()
    initIdioma()
    initHallOfHeroes()
    initMerchantsHQ()
    initRoyalArchives()    
end

function initGlobals()
    GameMode.setTimeOfDay(0)
    --global_scripts.script.last_tick = -1
end


function levelUpParty()
    local level = party.party:getChampion(1):getLevel()
    if level <= 28 then
        local level_ups = 28 - level
        for i=1,level_ups do
            global_scripts.script.party_level_up_champions({1,2,3,4})
        end
    end
end

light_weapons_idx = 1
heavy_weapons_idx = 2
rogue_idx = 3
wizard_idx = 4 
equipment = {[light_weapons_idx] = {[ItemSlot.Weapon] = "bone_blade",
                                    [ItemSlot.OffHand] = "meteor_shield",
                                    [ItemSlot.Head] = "meteor_helmet",
                                    [ItemSlot.Chest] = "meteor_cuirass",
                                    [ItemSlot.Gloves] = "meteor_gauntlets",
                                    [ItemSlot.Legs] = "meteor_cuisse",
                                    [ItemSlot.Feet] = "meteor_boots"},
            [heavy_weapons_idx] = {[ItemSlot.Weapon] = "bane",
                                   [ItemSlot.OffHand] = "crystal_shield",
                                   [ItemSlot.Head] = "crystal_helmet",
                                   [ItemSlot.Chest] = "crystal_cuirass",
                                   [ItemSlot.Gloves] = "crystal_gauntlets",
                                   [ItemSlot.Legs] = "crystal_greaves",
                                   [ItemSlot.Feet] = "crystal_boots"},
            [rogue_idx] = {[ItemSlot.Weapon] = "moonblade",
                           [ItemSlot.OffHand] = "moonblade",
                           [ItemSlot.Head] = "rogue_hood",
                           [ItemSlot.Chest] = "rogue_vest",
                           [ItemSlot.Gloves] = "rogue_gloves",
                           [ItemSlot.Legs] = "rogue_pants",
                           [ItemSlot.Feet] = "rogue_boots"},
            [wizard_idx] = {[ItemSlot.Weapon] = "acolyte_staff",
                            [ItemSlot.OffHand] = "serpent_staff",
                            [ItemSlot.Head] = "archmage_hat",
                            [ItemSlot.Chest] = "archmage_scapular",
                            [ItemSlot.Legs] = "archmage_mantle",
                            [ItemSlot.Feet] = "archmage_loafers"}}
             
function initParty()
    local light_weapons = party.party:getChampion(light_weapons_idx)
    light_weapons:trainSkill("light_weapons", 5, false)
    light_weapons:trainSkill("accuracy", 5, false)
    light_weapons:trainSkill("armors", 5, false)
    light_weapons:trainSkill("critical", 5, false)
    for item_slot, item_name in pairs(equipment[light_weapons_idx]) do
        if light_weapons:getItem(item_slot) == nil then
            light_weapons:insertItem(item_slot, spawn(item_name).item)
        end
    end  
    local heavy_weapons = party.party:getChampion(2)
    heavy_weapons:trainSkill("heavy_weapons", 5, false)
    heavy_weapons:trainSkill("accuracy", 5, false)
    heavy_weapons:trainSkill("armors", 5, false)    
    heavy_weapons:trainSkill("critical", 5, false)
    for item_slot, item_name in pairs(equipment[heavy_weapons_idx]) do
        if heavy_weapons:getItem(item_slot) == nil then
            heavy_weapons:insertItem(item_slot, spawn(item_name).item)
        end
    end  
    local rogue = party.party:getChampion(3)
    rogue:trainSkill("light_weapons", 5, false)
    rogue:trainSkill("accuracy", 5, false)
    rogue:trainSkill("armors", 5, false)
    rogue:trainSkill("critical", 5, false)
    rogue:trainSkill("dodge", 5, false)
    for item_slot, item_name in pairs(equipment[rogue_idx]) do
        if rogue:getItem(item_slot) == nil then
            rogue:insertItem(item_slot, spawn(item_name).item)
        end
    end  
    local wizard = party.party:getChampion(4)
    wizard:trainSkill("concentration", 5, false)
    wizard:trainSkill("fire_magic", 5, false)
    wizard:trainSkill("air_magic", 5, false)
    wizard:trainSkill("water_magic", 5, false)
    wizard:trainSkill("earth_magic", 5, false)
    for item_slot, item_name in pairs(equipment[wizard_idx]) do
        if wizard:getItem(item_slot) == nil then
            wizard:insertItem(item_slot, spawn(item_name).item)
        end
    end  
    wizard:castSpell(25)
end

function initCastleOfWater()
   castle_of_water_script_entity.script.init()
end

function initMoistCatacombs()
    moist_script_entity.script.init()
end

function initCloister()    
    cloister_script_entity.script.init()
end

function initBeach()
    hudPrint(tostring(pushable_block_floor_12.light:getBrightness()))
end

function initBeginningDungeon()
    beach_dungeon_script_entity.script.init()
end

function initFieldOfHerbs()
    field_of_herbs_script_entity.script.init()
end

function initLittleFishingVillage()
    little_fishing_village_script_entity.script.init()
end

function initTrialsRobin()
    triels_robin_script_entitiy.script.init()
end

function initTrickstersDomain()
    tricksters_domain_script_entity.script.init()
end

function initTrickstersLocations()
    tricksters_locations_script_entity.script.init()
end

function initForest()
    --forest_script_entity.script.time_of_day = GameMode.getTimeOfDay()
end

function initIdioma()
    idioma_script_entity.script.init()
end

function initHallOfHeroes()
    hall_of_heroes_script_entity.script.init()
end


function initMerchantsHQ()
    merchants_script_entity.script.init()
end

function initRoyalArchives()
    royal_archives_script_entity.script.init()
end