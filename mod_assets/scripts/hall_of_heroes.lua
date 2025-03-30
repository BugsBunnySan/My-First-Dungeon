function leverPulled(lever)
    global_scripts.script.party_level_up_champions({1,2,3,4})
end
    

function buttonPressed()
    --context.drawGuiItem("EnterTextDialog", 100, 100)
end

function offset_button(button_id, offset)
    local button = findEntity(button_id)
    --button.clickable:setDebugDraw(true)
    for _, component in ipairs({button.model, button.clickable, button.light, button.particle}) do
        if component ~= nil then
            local base_offset = component:getOffset() or vec(0, 0, 0)        
            base_offset = base_offset + offset
            component:setOffset(base_offset)
        end
   end
end


function openMerchantsHQDoor(time_delta, animation)
    castle_entrance_door_1.door:open()
end

function ringDoorBell(button)
    button = global_scripts.script.getGO(button)
    global_scripts.script.playSoundAtObject("doorbell_bigbennish", button)
    local animation = {on_finish=openMerchantsHQDoor, step=5.1, duration=5}
    global_scripts.script.add_animation(button.level, animation)
end

function init()
    for button_id, _ in pairs(hero_button_ids) do
        offset_button(button_id, vec(0.8, 0, 0))    
    end
    offset_button("heroes_reset_button_1", vec(-0.15, -0.5, 0))
    offset_button("heroes_reset_button_2", vec(0.15, -0.5, 0))
    offset_button("heroes_reset_button_3", vec(-0.15, -0.8, 0))
    offset_button("heroes_reset_button_4", vec(0.15, -0.8, 0))
    
    offset_button("merchants_hq_doorbell", vec(1.5, 0, -0.2))
end

hero_button_ids = {heroes_cleric_button = "cleric",
                   heroes_rogue_button = "rogue",
                   heroes_fighter_button = "fighter",
                   heroes_ranger_button = "ranger",
                   heroes_firearmer_button = "firearmer",
                   heroes_barbarian_button = "barbarian",
                   heroes_paladin_button = "paladin",
                   }

button_id_heroes = {["Omar"] = "heroes_cleric_button",
                   ["Grimrick"] = "heroes_rogue_button",
                   ["Cristóbal"] = "heroes_fighter_button",
                   ["Lauryn"] = "heroes_ranger_button",
                   ["Billy"] = "heroes_firearmer_button",
                   ["Torre'on"] = "heroes_barbarian_button",
                   ["Palad'in"] = "heroes_paladin_button",
}

heroes = {cleric = {name = "Omar",
                    class = "cleric",
                    race = "human",
                    sex = "male",
                    portrait = "mod_assets/textures/portraits/omar_khayyam.tga",
                    skills = {divine_magic = 1,
                              concentration = 1,
                              armors = 1},
                    traits = {"natural_armor", "meditation"},
                    stats = {strength=9, dexterity=9, vitality=10, willpower=12},
                    equipment = {[ItemSlot.Weapon] = nil,
                                 [ItemSlot.OffHand] = "whitewood_cleric_wand",
                                 [ItemSlot.Head] = "xafi_shemagh",
                                 [ItemSlot.Chest] = "xafi_robe",
                                 [ItemSlot.Gloves] = nil,
                                 [ItemSlot.Legs] = "xafi_khakis",
                                 [ItemSlot.Feet] = "sandals"},
                     pack = {potion_healing = {type="stack", count=1},
                             bread = {type="single", count=1}},
                    
        },
        rogue = {
            name = "Grimrick",
            class = "rogue",
            race = "ratling",
            sex = "male",
            portrait = "assets/textures/portraits/ratling_male_05.tga",
            skills = {light_weapons = 1, accuracy = 1, critical = 1},
            traits = {"aggressive", "agile"},
            stats = {strength=10, dexterity=12, vitality=9, willpower=9},
            equipment = {[ItemSlot.Weapon] = "dagger",
                         [ItemSlot.OffHand] = nil,
                         [ItemSlot.Head] = "peasant_cap",
                         [ItemSlot.Chest] = "peasant_tunic",
                         [ItemSlot.Gloves] = nil,
                         [ItemSlot.Legs] = "peasant_breeches",
                         [ItemSlot.Feet] = "shoes"},
            pack = {}
        },
        fighter = {name = "Cristóbal",
                   class = "fighter",
                   race = "human",
                   sex = "male",
                   portrait = "assets/textures/portraits/human_male_02.tga",
                   skills = {armors = 2, light_weapons = 1},
                   traits = {"uncanny_speed", "fast_learner"},
                   stats = {strength=12, dexterity=8, vitality=12, willpower=8},
                   equipment = {[ItemSlot.Weapon] = "machete",
                                [ItemSlot.OffHand] = nil,
                                [ItemSlot.Head] = "leather_cap",
                                [ItemSlot.Chest] = "hide_vest",
                                [ItemSlot.Gloves] = nil,
                                [ItemSlot.Legs] = nil,
                                [ItemSlot.Feet] = "leather_boots"},
                    pack = {}
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
                     pack = {dart = {type="stack", count=10}}          
        },
        firearmer = {name = "Billy",
                    class = "alchemist",
                     race = "lizardman",
                     sex = "female",
                     portrait = "assets/textures/portraits/lizardman_female_03.tga",
                     skills = {alchemy = 1,
                               firearms = 1,
                               dodge = 1},
                     traits = {"poison_immunity", "fast_metabolism"},
                     stats = {strength=10, dexterity=10, vitality=10, willpower=10},
                     equipment = {[ItemSlot.Weapon] = "flintlock",
                                 [ItemSlot.OffHand] = nil,
                                 [ItemSlot.Cloak] = "tattered_cloak",
                                 [ItemSlot.Head] = nil,
                                 [ItemSlot.Chest] = "tattered_shirt",
                                 [ItemSlot.Gloves] = "leather_gloves",
                                 [ItemSlot.Legs] = "torn_breeches",
                                 [ItemSlot.Feet] = nil},
                     pack = {mortar = {type="single", count=1},
                             pellet_box = {type="stack", count=50}}
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
                                 [ItemSlot.Chest] = "leather_brigandine",
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

hero_reset_buttons = {heroes_reset_button_1 = 1,
                      heroes_reset_button_2 = 2,
                      heroes_reset_button_3 = 3,
                      heroes_reset_button_4 = 4}

function HeroResetButtonPressed(button)
    button = global_scripts.script.getGO(button)
    local champion_idx = hero_reset_buttons[button.id]
        
    local champion = party.party:getChampion(champion_idx)
    local hero_button_id = button_id_heroes[champion:getName()]
    if hero_button_id ~= nil then
        local hero_button = findEntity(hero_button_id)
        hero_button.button:enable()
        hero_button.clickable:enable()
        hero_button.light:enable()
        hero_button.particle:enable()
    end
        
    init_dungeon.script.initChampion(champion_idx)
end

function HeroRegainHealthAndEnergy(champion_ordinal)
    local champion = party.party:getChampionByOrdinal(champion_ordinal)
    
    champion:regainHealth(champion:getMaxHealth())
    champion:regainEnergy(champion:getMaxEnergy())      
end

function HeroButtonPressed(button)
    button = global_scripts.script.getGO(button)
    
    local hero_class = hero_button_ids[button.id]
    
    local hero = heroes[hero_class]

        
    local hero_button_id = button_id_heroes[hero.name]
    local hero_button = findEntity(hero_button_id)
    if hero_button ~= nil then
        hero_button.button:disable()
        hero_button.clickable:disable()
        hero_button.light:disable()
        hero_button.particle:disable()
    end
   
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
        item_slot = item_slot + 1
    end
   
    delayedCall("hall_of_heroes_script_entity", 0.1, "HeroRegainHealthAndEnergy", champion:getOrdinal()) -- give champion time to recomputestats
   
end
