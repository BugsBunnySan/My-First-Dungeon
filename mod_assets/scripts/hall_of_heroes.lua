function leverPulled(lever)
    global_scripts.script.party_level_up_champions({1,2,3,4})
end
    

function buttonPressed()
    --context.drawGuiItem("EnterTextDialog", 100, 100)
end

function init()
end

hero_button_ids = {heroes_cleric_button = "cleric",
                   heroes_paladin_button = "paladin",
                   heroes_ranger_button = "ranger",
                   heroes_barbarian_button = "barbarian"}

heroes = {cleric = {name = "Kavadoc",
                    class = "cleric",
                    race = "human",
                    sex = "male",
                    portrait = "mod_assets/textures/portraits/omar_khayyam.tga",
                    skills = {divine_magic = 1,
                              concentration = 1,
                              armors = 1},
                    traits = {"natural_armor", "meditation"},
                    stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                    equipment = {[ItemSlot.Weapon] = nil,
                                 [ItemSlot.OffHand] = "whitewood_cleric_wand",
                                 [ItemSlot.Head] = "xafi_shemagh",
                                 [ItemSlot.Chest] = "xafi_robe",
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = "xafi_khakis",
                                 [ItemSlot.Feet] = "sandals"},
                     pack = {potion_healing = {type="stack", count=1},
                             bread = {type="single", count=1}}
                    
        },
         samurai = {name = "Iado",
                    class = "",
                     race = "human",
                     sex = "male",
                     portait = "mod_assets/textures/portraits/iado.tga",
                     skills = {},
                     traits = {"martial_training"},
                     stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                     equipment = {[ItemSlot.Weapon] = nil,
                                 [ItemSlot.OffHand] = nil,
                                 [ItemSlot.Head] = nil,
                                 [ItemSlot.Chest] = nil,
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = nil,
                                 [ItemSlot.Feet] = nil},
                     pack = {}
        },
        ranger = {name = "Lauryn",
                  class = "rogue",
                   race = "ratling",
                   sex = "female",
                   portrait = "assets/textures/portraits/ratling_female_04.tga",
                     skills = {missile_weapons = 2,
                               accuracy = 1},
                     traits = {"aggressive", "agile"},
                     stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                     equipment = {[ItemSlot.Weapon] = "blowpipe",
                                 [ItemSlot.OffHand] = nil,
                                 [ItemSlot.Head] = "flarefeather_cap",
                                 [ItemSlot.Chest] = "tattered_shirt",
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = "torn_breeches",
                                 [ItemSlot.Feet] = "pointy_shoes"},
                     pack = {dart = {type="stack", count=5}}          
        },
        firearmer = {name = "",
                    class = "",
                     race = "lizardman",
                     sex = "female",
                     portrait = "",
                     skills = {alchemy = 1,
                               firearms = 1,
                               dodge = 1},
                     traits = {"immune_poison", "fast_metabolism"},
                     stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                     equipment = {[ItemSlot.Weapon] = "flintlock",
                                 [ItemSlot.OffHand] = nil,
                                 [ItemSlot.Head] = nil,
                                 [ItemSlot.Chest] = nil,
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = nil,
                                 [ItemSlot.Feet] = nil},
                     pack = {mortal_and_pestal = {type="single", count=1},
                             pellets = {type="stack", count=50}}
        },
        barbarian = {name = "Torre'on",
                    class = "barbarian",
                     race = "minotaur",
                     sex = "male",
                     portrait = "assets/textures/portraits/minotaur_male_01.tga",
                     skills = {heavy_weapons = 2, athletics = 1},
                     traits = {"head_hunter", "tough"},
                     stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                     equipment = {[ItemSlot.Weapon] = "cudgel",
                                 [ItemSlot.OffHand] = nil,
                                 [ItemSlot.Head] = nil,
                                 [ItemSlot.Chest] = nil,
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = "loincloth",
                                 [ItemSlot.Feet] = "sandals"},
                     pack = {lizard_stick = {type="single", count=1}}                    
        },
        paladin = {name = "Palad'in",
                   class = "knight",
                     race = "insectoid",
                     sex = "female",
                     portrait = "assets/textures/portraits/insectoid_female_01.tga",
                     skills = {armors=2, light_weapons=1, aura=1},
                     traits = {"chitin_armor", "paladin_shield"},
                     stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                     equipment = {[ItemSlot.Weapon] = "bone_club",
                                 [ItemSlot.OffHand] = "round_shield",
                                 [ItemSlot.Head] = nil,
                                 [ItemSlot.Chest] = nil,
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = nil,
                                 [ItemSlot.Feet] = nil},
                     pack = {}
        },
}

function checkHeroesSelected(button)
    local number_of_sprites = 0   
    for i=1,4 do
        local champion = party.party:getChampion(i)
        if champion:getClass() == "sprite" then
            number_of_sprites = number_of_sprites + 1
        end
    end
    if number_of_sprites == 0 then
        dungeon_door_wooden_9.door:open()
    else
        dungeon_door_wooden_9.door:close()
        hudPrint("Four were the heroes that set out on this adventure!")
    end
end

function HeroResetButtonPressed(button)
    init_dungeon.script.initChampion(1)
end

function HeroButtonPressed(button)
    button = global_scripts.script.getGO(button)
    local hero_class = hero_button_ids[button.id]
    
    local hero = heroes[hero_class]
   
    local champion_idx = 0
    local champion
    for i=1,4 do
        champion = party.party:getChampion(i)
        if champion:getClass() == "sprite" and champion_idx == 0 then
            champion_idx = i
        end
    end

    if champion_idx == 0 then
        return
    end
        
    champion = party.party:getChampion(champion_idx)
    
    champion:setRace(hero.race)
    champion:setClass(hero.class)    
    champion:setSex(hero.sex)   
    champion:setName(hero.name)
    champion:setPortrait(hero.portrait)
    
    for stat_name, value in pairs(hero.stats) do
        champion:setBaseStat(stat_name, value)
    end
    
    for _, trait_name in pairs(hero.traits) do
        champion:addTrait(trait_name)
    end
    
    for skill_name, skill_level in pairs(hero.skills) do
        champion:trainSkill(skill_name, skill_level, false)
    end 
    
    for item_slot, item_name in pairs(hero.equipment) do
        if champion:getItem(item_slot) == nil then
            champion:insertItem(item_slot, spawn(item_name).item)
        end
    end 
    
    local item_slot = ItemSlot.BackpackFirst
    local item
    for item_class, item_data in pairs(hero.pack) do
        if item_data.type == "single" then
            item = spawn(item_class).item
        elseif item_data.type == "stack" then                    
            item = spawn(item_class).item
            item:setStackSize(item_data.count)
        end
        champion:insertItem(item_slot, item)        
    end
end
