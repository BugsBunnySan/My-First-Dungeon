function initDungeon()    
    initGlobals()    
    --initParty()
    initCastleOfWater()
    initMoistCatacombs()
    initCloister()
    initBeach()
    initBeginningDungeon()
    initFieldOfHerbs()
    initTrialsRobin()
    initTrickstersDomain()
    initForest()
    initIdioma()
    initHallOfHeroes()
    initMerchantsHQ()
end

function initGlobals()
    GameMode.setTimeOfDay(0.5)
    --global_scripts.script.last_tick = -1
end

function initParty()
    local light_weapons = party.party:getChampion(1)
    light_weapons:trainSkill("light_weapons", 5, false)
    light_weapons:trainSkill("accuracy", 5, false)
    light_weapons:trainSkill("armors", 5, false)
    light_weapons:trainSkill("critical", 5, false)
    light_weapons:insertItem(ItemSlot.Weapon, spawn("bone_blade").item)  
    light_weapons:insertItem(ItemSlot.OffHand, spawn("meteor_shield").item)   
    light_weapons:insertItem(ItemSlot.Head, spawn("meteor_helmet").item)
    light_weapons:insertItem(ItemSlot.Chest, spawn("meteor_cuirass").item) 
    light_weapons:insertItem(ItemSlot.Gloves, spawn("meteor_gauntlets").item)    
    light_weapons:insertItem(ItemSlot.Legs, spawn("meteor_cuisse").item)
    light_weapons:insertItem(ItemSlot.Feet, spawn("meteor_boots").item)    
    local heavy_weapons = party.party:getChampion(2)
    heavy_weapons:trainSkill("heavy_weapons", 5, false)
    heavy_weapons:trainSkill("accuracy", 5, false)
    heavy_weapons:trainSkill("armors", 5, false)    
    heavy_weapons:trainSkill("critical", 5, false)
    heavy_weapons:insertItem(ItemSlot.Weapon, spawn("bane").item) 
    heavy_weapons:insertItem(ItemSlot.OffHand, spawn("crystal_shield").item) 
    heavy_weapons:insertItem(ItemSlot.Head, spawn("crystal_helmet").item)
    heavy_weapons:insertItem(ItemSlot.Chest, spawn("crystal_cuirass").item) 
    heavy_weapons:insertItem(ItemSlot.Gloves, spawn("crystal_gauntlets").item)    
    heavy_weapons:insertItem(ItemSlot.Legs, spawn("crystal_greaves").item)
    heavy_weapons:insertItem(ItemSlot.Feet, spawn("crystal_boots").item)
    local rogue = party.party:getChampion(3)
    rogue:trainSkill("light_weapons", 5, false)
    rogue:trainSkill("accuracy", 5, false)
    rogue:trainSkill("armors", 5, false)
    rogue:trainSkill("critical", 5, false)
    rogue:trainSkill("dodge", 5, false)
    rogue:insertItem(ItemSlot.Weapon, spawn("moonblade").item)
    rogue:insertItem(ItemSlot.OffHand, spawn("moonblade").item)
    rogue:insertItem(ItemSlot.Head, spawn("rogue_hood").item)
    rogue:insertItem(ItemSlot.Chest, spawn("rogue_vest").item) 
    rogue:insertItem(ItemSlot.Gloves, spawn("rogue_gloves").item)    
    rogue:insertItem(ItemSlot.Legs, spawn("rogue_pants").item)
    rogue:insertItem(ItemSlot.Feet, spawn("rogue_boots").item)
    local wizard = party.party:getChampion(4)
    wizard:trainSkill("concentration", 5, false)
    wizard:trainSkill("fire_magic", 5, false)
    wizard:trainSkill("air_magic", 5, false)
    wizard:trainSkill("water_magic", 5, false)
    wizard:trainSkill("earth_magic", 5, false)
    wizard:insertItem(ItemSlot.Weapon, spawn("acolyte_staff").item)        
    wizard:insertItem(ItemSlot.Head, spawn("archmage_hat").item)
    wizard:insertItem(ItemSlot.Chest, spawn("archmage_scapular").item)    
    wizard:insertItem(ItemSlot.Legs, spawn("archmage_mantle").item)
    wizard:insertItem(ItemSlot.Feet, spawn("archmage_loafers").item)
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