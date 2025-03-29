defineCharClass{
    name = "cleric",
    uiName = "Cleric",
	traits = { "hand_caster" },
	optionalTraits = 2,
}

defineTrait{
	name = "cleric",
	uiName = "Cleric",
	icon = 33,
	description = "As a Cleric you can cast healing and protection and hit things with a staff.",
	gameEffect = [[
	- Health 35 (+3 per level), Energy 50 (+7 per level)
	- Willpower +2
	- You can cast spells with bare hands.]],
	onRecomputeStats = function(champion, level)
		if level > 0 then
			level = champion:getLevel()
			champion:addStatModifier("willpower", 2)
			champion:addStatModifier("max_health", 35 + (level-1) * 3)
			champion:addStatModifier("max_energy", 50 + (level-1) * 7)
		end
	end,
}

defineCharClass{
    name = "paladin",
    uiName = "Cleric",
	traits = { "hand_caster" },
	optionalTraits = 2,
}

defineTrait{
    name = "paladin_shield",
    uiName = "Shield Aura of the Paladin",
    icon = 32,
    description = "A Paladin is a shield to those behind them and armor to those that stand beside them",
    onRecomputeStats = function(champion, level)
        if not champion:isAlive() then
            party.party:getChampion(1):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(1):removeTrait("paladin_aura_receive_protection")
            party.party:getChampion(2):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(2):removeTrait("paladin_aura_receive_protection")
            party.party:getChampion(3):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(3):removeTrait("paladin_aura_receive_protection")
            party.party:getChampion(4):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(4):removeTrait("paladin_aura_receive_protection")
            return
        end
        local paladin_shield_level = champion:getSkillLevel("aura")
        
        local paladin_ordinal = champion:getOrdinal()
        
        local sibling_in_arms = nil
        local back_row = nil
        
        local shared_evasion = math.max(0, champion:getEvasion())
        local shared_protection = math.max(0, champion:getProtection())
        
        spell_support.script.paladin.ordinal = paladin_ordinal        
        spell_support.script.paladin.shared_evasion = math.ceil((shared_evasion / 2) * paladin_shield_level)
        spell_support.script.paladin.shared_protection = math.ceil((shared_protection / 2) * paladin_shield_level)
                
        if party.party:getChampion(1):getOrdinal() == paladin_ordinal then
            sibling_in_arms = party.party:getChampion(2)
            sibling_in_arms:removeTrait("paladin_aura_receive_evasion")
            sibling_in_arms:addTrait("paladin_aura_receive_protection")
            back_row = party.party:getChampion(3)
            back_row:removeTrait("paladin_aura_receive_protection")
            back_row:addTrait("paladin_aura_receive_evasion")
            back_row = party.party:getChampion(4)
            back_row:removeTrait("paladin_aura_receive_protection")
            back_row:addTrait("paladin_aura_receive_evasion")
        elseif party.party:getChampion(2):getOrdinal() == paladin_ordinal then
            sibling_in_arms = party.party:getChampion(1)
            sibling_in_arms:addTrait("paladin_aura_receive_protection")
            sibling_in_arms:removeTrait("paladin_aura_receive_evasion")
            back_row = party.party:getChampion(3)
            back_row:removeTrait("paladin_aura_receive_protection")
            back_row:addTrait("paladin_aura_receive_evasion")
            back_row = party.party:getChampion(4)
            back_row:removeTrait("paladin_aura_receive_protection")
            back_row:addTrait("paladin_aura_receive_evasion")
        else
            party.party:getChampion(1):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(1):removeTrait("paladin_aura_receive_protection")
            party.party:getChampion(2):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(2):removeTrait("paladin_aura_receive_protection")
            party.party:getChampion(3):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(3):removeTrait("paladin_aura_receive_protection")
            party.party:getChampion(4):removeTrait("paladin_aura_receive_evasion")
            party.party:getChampion(4):removeTrait("paladin_aura_receive_protection")
        end        
    end
}
    
defineTrait{
    name = "paladin_aura_receive_protection",
    uiName = "Paladin's Protection Aura",
    icon = 33,
    description = "A Paladin's armor protects you!",
    onRecomputeStats = function(champion, level)
        champion:addStatModifier("protection", spell_support.script.paladin.shared_protection)
    end
}    

defineTrait{
    name = "paladin_aura_receive_evasion",
    uiName = "Paladin's Evasion Aura",
    icon = 33,
    description = "A Paladin's shield protects you!",
    onRecomputeStats = function(champion, level)
        champion:addStatModifier("evasion", spell_support.script.paladin.shared_evasion)
    end
}

defineCharClass{
    name = "sprite",
    uiName = "Sprite",
    optionaTraits = 0
}

defineTrait{
    name = "sprite",
    uiName = "Sprite",
    icon = 33,
    description = "A sprite, a spark of life, that can become a person.",
    gameEffect = [[
    Reincarnate as a person in the world. ]],
    onRecomputeStats = function(champion, level)
        
    end
}

defineRace{
	name = "sprite",
	uiName = "Sprite",
	inventoryBackground = "assets/textures/gui/inventory_backgrounds/human_$sex.tga",
	traits = { "sprite" },
}

defineTrait{
    name = "cleric_shield",
    uiName = "Shield Cleric",
    description = "Your spells are as a shield to your party"
}

defineTrait{
    name = "cleric_sword",
    uiName = "Sword Cleric",
    description = "Your spells are as a sword to your party"
}

defineTrait{
    name = "cleric_added_damage",
    uiName = "Divine added damage",
    description = "Divine power adds to your damage",
    onComputeCritChance = function(champion, weapon, attack, attackType, skillLevel) -- it seems these fuctions get added to every champions recalculation of these values, if any champion has this trait even once... so there's this check...
        if champion:hasTrait("cleric_added_damage") and champion:hasCondition("added_damage") then
            local script_entity = findEntity("spell_support")
            local condition_level = script_entity.script.getConditionLevel(champion:getOrdinal(), "added_damage")
            return condition_level * 14
        else
            return 0
        end
    end,
    onComputeAccuracy = function(champion, weapon, attack, attackType, skillLevel)
        if champion:hasTrait("cleric_added_damage") and champion:hasCondition("added_damage") then
            local script_entity = findEntity("spell_support")
            local condition_level = script_entity.script.getConditionLevel(champion:getOrdinal(), "added_damage")
            return condition_level * 10
        else
            return 0
        end
            
    end
}

defineTrait{
    name = "cleric_divine_regeneration",
    uiName = "Divine regeneration",
    description = "DIvine power renegerates your health",
    onRecomputeStats = function(champion, level)
    end
}

defineSkill{
	name = "divine_magic",
	uiName = "Divine Magic",
	priority = 10,
	icon = 20,
	description = "Your Cleric Spells last longer and have more effect.",
	traits = { },
}

defineSkill{
    name = "aura",
    uiName = "Aura Strength",
	priority = 10,
	icon = 20,
    description = "Strength of Aura effects",
    
}

defineObject{
	name = "whitewood_cleric_wand",
	baseObject = "base_item",
	components = {
		{
			class = "Model",
			model = "assets/models/items/whitewood_wand.fbx",
		},
		{
			class = "Item",
			uiName = "Whitewood Cleric Wand",
			description = "A beautifully crafted wooden wand that can be used to channel a cleric's energy.",
			gfxIndex = 15, -- 15 is shield, 84 is sword
			impactSound = "impact_blunt",
			weight = 3.5,
            onEquipItem = function(self, champion, slot)
                local gfxIndex = self:getGfxIndex()
                if gfxIndex == 15 then
                    if champion:hasTrait("cleric_sword") then
                        champion:removeTrait("cleric_sword")
                    end
                    champion:addTrait("cleric_shield")
                elseif gfxIndex == 84 then
                  if champion:hasTrait("cleric_shield") then
                        champion:removeTrait("cleric_shield")
                    end
                    champion:addTrait("cleric_sword")                  
                end
            end,
            
            onUnequipItem = function(self, champion, slot)
                champion:removeTrait("cleric_shield")
                champion:removeTrait("cleric_sword")
            end
		},
        {
            class = "UsableItem",
            onUseItem = function (self, champion)
                if champion:hasTrait("cleric_shield") then
                    champion:removeTrait("cleric_shield")
                    champion:addTrait("cleric_sword")
                    self.go.item:setGfxIndex(84)
                elseif champion:hasTrait("cleric_sword") then
                    champion:removeTrait("cleric_sword")
                    champion:addTrait("cleric_shield")
                    self.go.item:setGfxIndex(15)
                else
                    champion:addTrait("cleric_shield")
                    self.go.item:setGfxIndex(15)
                end
                return false
            end
        }
	},
}

defineCondition{
    name = "added_damage",
    uiName = "added_damage",
    description = "Critical Chance / Accuracy gain +10 / +14 (*divine magic)",
    icon = 1,
    iconAtlas = "mod_assets/textures/medusa_stone_dif.tga",
    beneficial = true,
    harmful = false,
    tickInterval = 1,
    onStart = function(self, champion)        
        hudPrint(champion:getName().." is infused with power!")
        champion:addTrait("cleric_added_damage")
    end,
    onStop = function(self, champion)
        hudPrint(champion:getName().." feels weak!")
        champion:removeTrait("cleric_added_damage")
        local script_entity = findEntity("spell_support")
        script_entity.script.clearConditionLevel(champion:getOrdinal(), "added_damage")
    end,
}

defineCondition{
    name = "divine_regeneration",
    uiName = "divine regeneration",
    description = "Regenerate divine magic hitpoints per second that passes",
    icon = 1,   
    iconAtlas = "mod_assets/textures/medusa_stone_dif.tga",    
    beneficial = true,
    harmful = false,
    tickInterval = 1,
    onTick = function(self, champion)        
        local script_entity = findEntity("spell_support")
        local condition_level = script_entity.script.getConditionLevel(champion:getOrdinal(), "divine_regeneration")
        champion:regainHealth(condition_level)
    end,
    onStop = function(self, champion)        
        local script_entity = findEntity("spell_support")
        script_entity.script.clearConditionLevel(champion:getOrdinal(), "divine_regeneration")
    end,
    
}

defineSpell{
    name = "spell_5",
    uiName = "CL:Diving4_1",
    gesture = 5,
    manaCost = 10,
    skill = "concentration",	
    requirements = { "concentration", 1},
	icon = 58,
	spellIcon = 18,
    description = "Cleric:Divine Power Regenerates the Party",
    onCast = function(champion, x, y, direction, elevation, skillLevel)
           local class = champion:getClass()        
        if class == "cleric" then
            local script_entity = findEntity("spell_support")
            return script_entity.script.castClericSpell(5, champion, x, y, direction, elevation, skillLevel)
        else
            return false
        end    
    end
}
    

defineSpell{
    name = "spell_125",
    uiName = "CL:Divine1",
    gesture = 125,
    manaCost = 10,
    skill = "concentration",	
    requirements = { "concentration", 1},
	icon = 58,
	spellIcon = 18,
	description = "Cleric:Divine Power to Front Row Dusk",
    onCast = function(champion, x, y, direction, elevation, skillLevel)
        local class = champion:getClass()        
        if class == "cleric" then
            local script_entity = findEntity("spell_support")
            return script_entity.script.castClericSpell(125, champion, x, y, direction, elevation, skillLevel)
        else
            return false
        end
    end,
}

defineSpell{
    name = "spell_325",
    uiName = "CL:Divine2",
    gesture = 325,
    manaCost = 10,
    skill = "concentration",	
    requirements = { "concentration", 1},
	icon = 58,
	spellIcon = 18,
	description = "Cleric:Divine Power to Front Row Dawn",
    onCast = function(champion, x, y, direction, elevation, skillLevel)
        local class = champion:getClass()        
        if class == "cleric" then
            local script_entity = findEntity("spell_support")
            return script_entity.script.castClericSpell(325, champion, x, y, direction, elevation, skillLevel)
        else
            return false
        end
    end,
}

defineSpell{
    name = "spell_587",
    uiName = "CL:Divine2",
    gesture = 587,
    manaCost = 10,
    skill = "concentration",	
    requirements = { "concentration", 1},
	icon = 58,
	spellIcon = 18,
	description = "Cleric:Divine Power to Back Row Dusk",
    onCast = function(champion, x, y, direction, elevation, skillLevel)
        local class = champion:getClass()        
        if class == "cleric" then
            local script_entity = findEntity("spell_support")
            return script_entity.script.castClericSpell(587, champion, x, y, direction, elevation, skillLevel)
        else
            return false
        end
    end,
}

defineSpell{
    name = "spell_589",
    uiName = "CL:Divine2",
    gesture = 589,
    manaCost = 10,
    skill = "concentration",	
    requirements = { "concentration", 1},
	icon = 58,
	spellIcon = 18,
	description = "Cleric:Divine Power to Back Row Dawn",
    onCast = function(champion, x, y, direction, elevation, skillLevel)
        local class = champion:getClass()        
        if class == "cleric" then
            local script_entity = findEntity("spell_support")
            return script_entity.script.castClericSpell(589, champion, x, y, direction, elevation, skillLevel)
        else
            return false
        end
    end,
}


defineSpell{
	name = "cast_magic_bridge",
	uiName = "Magic Bridge",
	gesture = 6547,
	manaCost = 35,
	onCast = function()end,
	skill = "concentration",
	requirements = { "earth_magic", 3, "air_magic", 3 },
	icon = 58,
	spellIcon = 18,
	description = "Conjures a magic bridge for your path.",
}

defineObject{
	name = "cast_magic_bridge",
	baseObject = "base_spell",
	placement = "floor",
	tags = { "spell" },
	editorIcon = 100,
}

defineObject{
    name = "fireball_large_fadeout",
    baseObject = "fireball_large",
    components = {
        {
            class = "Particle",
            particleSystem = "fireball_large",
        },		
        {
			class = "Projectile",
			spawnOffsetY = 1.35,
			velocity = 15,
			radius = 0.1,
            gravity = .4,
            hitEffect = "water_splash_spell"
		},
		{
			class = "Light",
			color = vec(1, 0.5, 0.25),
			brightness = 15,
			range = 7,
			castShadow = true,
		},
    }
}

defineObject{
	name = "water_splash_spell",
	baseObject = "base_spell",
	components = {
		{
			class = "Particle",
			particleSystem = "water_splash",
			destroyObject = true,
		},
	},
}

defineParticleSystem{
    name = "water_splash",
    emitters = {
        {
            spawnBurst = true,
			maxParticles = 200,
			boxMin = {-1.0, 0.0, -1.0},
			boxMax = {1.0, 0.0, 1.0},
			velocity = {1,15},
			sprayAngle = {0,10},
			airResistance = 4.5,
			lifetime = {1,5},
            gravity = {0, -7, 0},
			--texture = "assets/textures/particles/ice_guardian_smoke.tga",
			texture = "assets/textures/particles/particle.tga",
			color0 = {1, 1, 1},
			opacity = .9,
			fadeIn = 0.1,
			fadeOut = 0.9,
			size = {0.1, 2},
			rotationSpeed = .1,
			blendMode = "Additive",
            clampToGroundPlane = true,
            
            
        }
    }
}

defineParticleSystem{
	name = "fireball_large_fadeout",
	emitters = {
		-- smoke
		{
			emissionRate = 30,
			emissionTime = 2,
			maxParticles = 100,
			boxMin = {0.0, 0.0, 0.0},
			boxMax = {0.0, 0.0, 0.0},
			sprayAngle = {0,360},
			velocity = {0.1,0.1},
			texture = "assets/textures/particles/smoke_01.tga",
			lifetime = {1,1},
			color0 = {0.25, 0.25, 0.25},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.9,
			size = {0.4, 0.6},
			gravity = {0,0,0},
			airResistance = 0.1,
			rotationSpeed = 1,
			blendMode = "Translucent",
		},

		-- flames
		{
			emissionRate = 100,
			emissionTime = 1.5,
			maxParticles = 100,
			boxMin = {-0.03, -0.03, 0.03},
			boxMax = { 0.03, 0.03,  -0.03},
			sprayAngle = {0,360},
			velocity = {0.5, 0.7},
			texture = "assets/textures/particles/torch_flame.tga",
			frameRate = 35,
			frameSize = 64,
			frameCount = 16,
			lifetime = {0.8, 0.8},
			colorAnimation = true,
			color0 = {2, 2, 2},
			color1 = {1.0, 1.0, 1.0},
			color2 = {1.0, 0.5, 0.25},
			color3 = {1.0, 0.3, 0.1},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {0.25, 0.35},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			objectSpace = true,
		},

		-- flame trail
		{
			emissionRate = 80,
			emissionTime = 1.5,
			maxParticles = 100,
			boxMin = {0.0, 0.0, 0.0},
			boxMax = {0.0, 0.0, 0.0},
			sprayAngle = {0,360},
			velocity = {0.1, 0.3},
			texture = "assets/textures/particles/torch_flame.tga",
			frameRate = 35,
			frameSize = 64,
			frameCount = 16,
			lifetime = {0.2, 0.3},
			colorAnimation = true,
			color0 = {2, 2, 2},
			color1 = {1.0, 1.0, 1.0},
			color2 = {1.0, 0.5, 0.25},
			color3 = {1.0, 0.3, 0.1},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {0.2, 0.5},
			gravity = {0,0,0},
			airResistance = 1.0,
			rotationSpeed = 1,
			blendMode = "Additive",
		},

		-- glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 1.5,
			maxParticles = 1,
			boxMin = {0,0,-0.1},
			boxMax = {0,0,-0.1},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.3, 0.13, 0.06},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {1.5, 1.5},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			objectSpace = true,
		}
	}
}