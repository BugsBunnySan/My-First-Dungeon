function initDungeon()    
    initGlobals()    
    --initPartyOP()
    --levelUpParty()
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
    GameMode.setTimeOfDay(1.98)
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
                            [ItemSlot.OffHand] = "compass" ,
                            [ItemSlot.Head] = "archmage_hat",
                            [ItemSlot.Chest] = "archmage_scapular",
                            [ItemSlot.Legs] = "archmage_mantle",
                            [ItemSlot.Feet] = "archmage_loafers"}}

trait_names = {
    "head_hunter",
    "skilled",
    "fast_learner",
    "rag",
    "fast_metabolism",
    "endure_elements",
    "poison_immunity",
    "chitin_armor",
    "quick",
    "mutation",
    "aggressive",
    "agile",
    "healthy",
    "athletic",
    "strong_mind",
    "aura",
    "tough",
    "cold_resistant",
    "evasive",
    "fire_resistant",
    "weapon_specialization",
    "endurance",
    "lightning_speed",
    "natural_armor",
    "poison_resistant",
    "uncanny_speed",
    "leadership",
    "nightstalker",
    "pack_mule",
    "meditation",
    "two_handed_mastery",
    "light_armor_proficiency",
    "heavy_armor_proficiency",
    "armor_expert",
    "shield_expert",
    "staff_defence",
    "improved_alchemy",
    "bomb_expert",
    "backstab",
    "assassin",
    "firearm_mastery",
    "dual_wield",
    "improved_dual_wield",
    "piercing_arrows",
    "double_throw",
    "reach",
    "uncanny_speed",
    "fire_mastery",
    "air_mastery",
    "earth_mastery",
    "water_mastery",
    "cleric_added_damage",
    "cleric_divine_regeneration",
    "paladin_shield",
    "paladin_aura_receive_protection",
    "paladin_aura_receive_evasion"}

skill_names = {
    "alchemy",
    "athletics",
    "concentration",
    "light_weapons",
    "heavy_weapons",
    "missile_weapons",
    "poison_immunity",
    "throwing",
    "firearms",
    "accuracy",
    "critical",
    "armors",
    "dodge",
    "fire_magic",
    "air_magic",
    "earth_magic",
    "water_magic",
    "divine_magic",
    "aura",    
}

default_stats = {
    strength=10, 
    dexterity=10, 
    vitality=10, 
    willpower=10,
    evasion=0,
    protection=0,
    resist_shock=0,
    resist_poison=0,
    resist_fire=0,
    resist_cold=0
}

function removeTraits(champion)
    for _,trait_name in ipairs(trait_names) do
        champion:removeTrait(trait_name)
    end
end
             
function resetSkills(champion)
    for _,skill_name in ipairs(skill_names) do
        for i=1,champion:getSkillLevel(skill_name) do
            champion:trainSkill(skill_name, -1, false)
        end
    end
end             
            
function resetStats(champion)
    for stat_name, value in pairs(default_stats) do
        champion:setBaseStat(stat_name, value)
    end
end
          
function removeItems(champion)
    for i=1,ItemSlot.MaxSlots do
        champion:removeItemFromSlot(i)
    end
end
          
function initChampion(champion_idx)
    local champion = party.party:getChampion(champion_idx)
    champion:resetExp()
    champion:setName("Sprite")
    champion:setRace("sprite")
    champion:setClass("sprite")
    champion:setPortrait("assets/textures/particles/teleporter.tga")
    removeTraits(champion)
    resetSkills(champion)
    resetStats(champion)
    removeItems(champion)    
end          
          
function initParty()
    for i=1,4 do
        initChampion(i)
    end
 end
             
function initPartyOP()
    local light_weapons = party.party:getChampion(light_weapons_idx)
    light_weapons:setClass("fighter")    
    light_weapons:trainSkill("light_weapons", 5, false)
    light_weapons:trainSkill("accuracy", 5, false)
    light_weapons:trainSkill("armors", 5, false)
    light_weapons:trainSkill("critical", 5, false)
    for item_slot, item_name in pairs(equipment[light_weapons_idx]) do
        local item_check = light_weapons:getItem(item_slot)
        if item_check ~= nil then
            local item = light_weapons:getItem(item_slot)            
            light_weapons:removeItem(item)            
            --global_scripts.script.moveObjectToObject(item.go, party)
        end
        
        light_weapons:insertItem(item_slot, spawn(item_name).item)        
    end  
    local heavy_weapons = party.party:getChampion(2)
    heavy_weapons:setClass("barbarian")
    heavy_weapons:trainSkill("heavy_weapons", 5, false)
    heavy_weapons:trainSkill("accuracy", 5, false)
    heavy_weapons:trainSkill("armors", 5, false)    
    heavy_weapons:trainSkill("critical", 5, false)
    for item_slot, item_name in pairs(equipment[heavy_weapons_idx]) do
    local item_check = heavy_weapons:getItem(item_slot)
        if item_check ~= nil then
            local item = heavy_weapons:removeItemFromSlot(item_slot)
            --global_scripts.script.moveObjectToObject(item.go.id, party.id)
        end
        heavy_weapons:insertItem(item_slot, spawn(item_name).item)
    end  
    local rogue = party.party:getChampion(3)
    rogue:setClass("rogue")
    rogue:trainSkill("light_weapons", 5, false)
    rogue:trainSkill("accuracy", 5, false)
    rogue:trainSkill("armors", 5, false)
    rogue:trainSkill("critical", 5, false)
    rogue:trainSkill("dodge", 5, false)    
    for item_slot, item_name in pairs(equipment[rogue_idx]) do
    local item_check = rogue:getItem(item_slot)
        if item_check ~= nil then
            local item = rogue:removeItemFromSlot(item_slot)
            --global_scripts.script.moveObjectToObject(item.go.id, party.id)
        end
        rogue:insertItem(item_slot, spawn(item_name).item)
    end     
    local wizard = party.party:getChampion(4)
    wizard:setClass("wizard")
    wizard:trainSkill("concentration", 5, false)
    wizard:trainSkill("fire_magic", 5, false)
    wizard:trainSkill("air_magic", 5, false)
    wizard:trainSkill("water_magic", 5, false)
    wizard:trainSkill("earth_magic", 5, false)
    for item_slot, item_name in pairs(equipment[wizard_idx]) do
        local item_check = wizard:getItem(item_slot)
        if item_check ~= nil then
            local item = wizard:removeItemFromSlot(item_slot)
            --global_scripts.script.moveObjectToObject(item.go.id, party.id)
        end
        wizard:insertItem(item_slot, spawn(item_name).item)
    end   
    levelUpParty()
    --wizard:castSpell(25)
    
    for i=1,4 do
        delayedCall("hall_of_heroes_script_entity", 0.1, "HeroRegainHealthAndEnergy", i) -- give champion time to recomputestats
    end
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
    forest_script_entity.script.init()
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