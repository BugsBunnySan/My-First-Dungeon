defineParticleSystem{
	name = "wizard_lantern_red",
	emitters = {
		-- smoke
		{
			emissionRate = 5,
			emissionTime = 0,
			maxParticles = 50,
			boxMin = {-0.03, 0.0, -0.03},
			boxMax = { 0.03, 0.0,  0.03},
			sprayAngle = {0,30},
			velocity = {0.1,0.5},
			texture = "assets/textures/particles/smoke_01.tga",
			lifetime = {1,1},
			color0 = {0.15, 0.11, 0.08},
			opacity = 0.2,
			fadeIn = 0.5,
			fadeOut = 0.5,
			size = {0.3, 0.3},
			gravity = {0,0,0},
			airResistance = 0.1,
			rotationSpeed = 0.6,
			blendMode = "Translucent",
			objectSpace = false,
		},

		-- flames
		{
			emissionRate = 30,
			emissionTime = 0,
			maxParticles = 100,
			boxMin = {-0.03, -0.07, 0.03},
			boxMax = { 0.03, -0.07,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 0.4},
			texture = "assets/textures/particles/goromorg_lantern.tga",
			frameRate = 45,
			frameSize = 64,
			frameCount = 16,
			lifetime = {0.25, 0.85},
			colorAnimation = false,
			color0 = {1.5, 1.5, 1.5},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {0.17, 0.015},
			gravity = {0,0,0},
			airResistance = 1.0,
			rotationSpeed = 1,
			blendMode = "Additive",
			depthBias = 0,
			objectSpace = true,
		},

		-- inner glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.23, 0.11, 0.07},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.5, 0.5},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},

		-- outer glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.23, 0.11, 0.07},
			opacity = 0.25,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {2, 2},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		}
	}
}

defineObject{
	name = "emperor_eamon",
	baseObject = "wizard",
    components = {		
    		{
			class = "Particle",
			parentNode = "light1",
			particleSystem = "wizard_lantern_red",
		},
    }
}

defineParticleSystem{
	name = "spirit",
	emitters = {
		-- stars
		{
			emitterShape = "MeshShape",
			emissionRate = 40,
			emissionTime = 0,
			maxParticles = 1000,
			sprayAngle = {0,360},
			velocity = {0, 0},
			objectSpace = false,
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {2,3},
			color0 = {2.0,2.0,2.0},
			opacity = .45,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.05, 0.5},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
		},	
		{
			emitterShape = "MeshShape",
			maxParticles = 20,
			emissionRate = 50,
			emissionTime = 0,
			sprayAngle = {0,360},
			velocity = {0.1, 0.1},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {2.8, 2.8},
			colorAnimation = false,
			color0 = {0.75,0.75,0.75},
			opacity = .1,
			fadeIn = 3.5,
			fadeOut = 0.1,
			size = {.25, .25},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			objectSpace = false,
			depthBias = -0.005,
		},
		{
			emitterShape = "MeshShape",
			boxMin = {-1.0, 0.5,-0.15},
			boxMax = { 1.0, 2.5, 0.15},
			emissionRate = 20,
			emissionTime = 0,
			maxParticles = 1000,
			sprayAngle = {0,360},
			velocity = {0.1,1},
			objectSpace = false,
			texture = "assets/textures/particles/fog.tga",
			lifetime = {1,2},
			color0 = {0.31, 0.31, 0.41},
			opacity = .23,
			fadeIn = 1.5,
			fadeOut = 1.5,
			size = {2, 2},
			gravity = {0,0,0},
			airResistance = 0.1,
			rotationSpeed = 0.3,
			blendMode = "Additive",
		},		-- rim
		{
			emitterShape = "MeshShape",
			emissionRate = 1000,
			emissionTime = 0,
			maxParticles = 1000,
			boxMin = {-1.5,-0.5,-0.15},
			boxMax = { 1.5, 2.5, 0.0},
			sprayAngle = {0,360},
			--velocity = {0.05, 0.25},
			velocity = {0, 0},
			objectSpace = true,
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {0.2,0.4},
			color0 = {2, 2, 2},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.1, 0.2},
			gravity = {0,0,0},
			airResistance = 0.1,
			rotationSpeed = 2,
			blendMode = "Additive",
			depthBias = 0.2,
		},
    }
}

defineMaterial{
	name = "spirit_light",
	diffuseMap = "assets/textures/effects/force_field_dif.tga",
	normalMap = "assets/textures/env/healing_crystal_normal.tga",
	doubleSided = false,
	lighting = false,
	alphaTest = false,
	ambientOcclusion = false,
	blendMode = "Additive",
	textureAddressMode = "Wrap",
	glossiness = 100,
	depthBias = 0,
}

defineObject{
    name = "skeleton_commander_spirit",
    baseObject = "skeleton_commander",
    components = {		
        {
			class = "Model",
			model = "assets/models/monsters/skeleton_knight_commander.fbx",
			storeSourceData = true, -- must be enabled for mesh particles to work
            material = "spirit_light"--"healing_crystal",
		},
		{
			class = "UggardianFlames",
			particleSystem = "spirit",
            name = "spiritParticles",
			emitFromMaterial = "*",
		},		
        {
			class = "Monster",
			meshName = "skeleton_knight_commander_mesh",
			footstepSound = "skeleton_footstep",
			hitSound = "skeleton_hit",
			dieSound = "skeleton_die",
			hitEffect = "hit_dust",			
            capsuleHeight = 0,
			capsuleRadius = 0,
			collisionRadius = 0,		
			health = 900,
			protection = 15,
			evasion = 0,
            traits = { "elemental" },			
            immunities = { "sleep", "blinded", "frozen", "knockback" },
            resistances = {
                fire = "immune",
                cold = "immune",
                poison = "immune",
                shock = "immune",
                physical = "immune"
            }, 
        },
		{
			class = "Sound",
			sound = "evil_whisper",
			parentNode = "head",
		},
    }
}

defineObject{
	name = "dark_acolyte_spirit",
	baseObject = "dark_acolyte",
	components = {
		{
			class = "Model",
			model = "assets/models/monsters/dark_acolyte.fbx",
			storeSourceData = true,
            material = "spirit_light"--"healing_crystal",
		},
		{
			class = "UggardianFlames",
			particleSystem = "spirit",
            name = "spiritParticles",
			emitFromMaterial = "*",
		},
        {
            class = "Monster",
			meshName = "dark_acolyte_mesh",
			hitSound = "dark_acolyte_hit",
			dieSound = "dark_acolyte_die",
			hitEffect = "hit_goo",		
            capsuleHeight = 0,
			capsuleRadius = 0,
			collisionRadius = 0,	
			health = 800,
			protection = 0,
			evasion = 10,
            traits = { "elemental" },
            immunities = { "sleep", "blinded", "frozen", "knockback" },
            resistances = {
                fire = "immune",
                cold = "immune",
                poison = "immune",
                shock = "immune",
                physical = "immune"
            },         
        },
		{
			class = "Sound",
			sound = "evil_whisper",
			parentNode = "head",
		},
    }
}

defineObject{
    name = "doctor",
    baseObject = "mummy",
    components = {
        {
			class = "Particle",
            name = "crystal",
			particleSystem = "crystal",
            enabled = false
		},
		{
			class = "Light",
			offset = vec(0,1,0),
			color = vec(39/255, 90/255, 205/255),
			range = 7,
			shadowMapSize = 128,
			castShadow = true,
			staticShadows = true,
		},
        {
            class = "Timer",
            name = "timer",
            timerInterval = 120, -- this needs to sync with cooldown of the monsterattack (there is not onCooldownReset on the attack)
            disableSelf = true,
            enabled = false,
            onActivate = function(self)
                self.go.crystal:fadeIn(2.5)                       
            end
        },
        {
            class = "MonsterAttack",
            name = "basicAttack",
            attackPower = 0,
            cooldown = 120,
            --sound = "crystal_ambient",
            animationSpeed = 0.8,
            accuracy = 100,
            onAttack = function(self)
                self.go.crystal:fadeOut(2.5)
                self.go.timer:setTimerInterval(120) -- this needs to sync with cooldown of the monsterattack (there is not onCooldownReset on the attack)
                self.go.timer:start()
                return true
            end,
            onAttackHit = function(self, champion)
                party.party:heal()
            end
        },
    }
}

defineObject{
    name = "sage_of_water",
    baseObject = "beacon_water",
    components = {
		{
			class = "Socket",     
			offset = vec(0, 0.85, -1.1),            
			onAcceptItem = function(self, item)
				return self:count() == 0
			end,
            onInit = function(self)
                local sage_of_water_quest = seven_disciples_script.script.sage_of_water_quest
                sage_of_water_quest.state = "initial"
                sage_of_water_quest.auto_inserting = false
            end,
			onInsertItem = function(self, item)
                local sage_of_water_quest = seven_disciples_script.script.sage_of_water_quest
                if sage_of_water_quest.auto_inserting then
                    sage_of_water_quest.auto_inserting = false
                    return
                end
                print(seven_disciples_script.script.sage_of_water_quest.state)
                local state = sage_of_water_quest.state_table[sage_of_water_quest.state]
                local trans = state[item.go.name]
                if trans ~= nil then
                    if trans["action"] ~= nil then
                        trans["action"](self, item)
                    end
                    if trans["message"] ~= nil then
                        hudPrint(trans["message"])
                    end
                    sage_of_water_quest.state = trans["new_state"]
                end               
			end,
			--debugDraw = true,
		},
    }
}

defineObject{
    name = "disciple_of_water_trigger",
    baseObject = "beacon_furnace_head",
    components = {
        {
			class = "Particle",
            name = "splash",
			particleSystem = "frostbolt_hit",
            offset = vec(0, 1, 0),
            enabled = false
		},
		{
			class = "WallTrigger",
            name = "walltrigger",
            enabled = false,
			onActivate = function(self, entity)
                if entity.name == "water_flask" then
                    self:disable()
                    entity:destroyDelayed()
                    playSoundAt("water_hit_large", self.go.level, self.go.x, self.go.y)
                    playSoundAt("gun_shot_cannon", self.go.level, self.go.x, self.go.y)
                    spawn("mine_floor_sandpile", self.go.level, self.go.x-1, self.go.y, self.go.facing, self.go.elevation)                    
                    spawn("invisible_wall", self.go.level, self.go.x-1, self.go.y, self.go.facing, self.go.elevation)
                    self.go.model:disable()
                    self.go.eyesModel:disable()
                    self.go.leftEyeLight:disable()
                    self.go.rightEyeLight:disable()
                    self.go.splash:enable()
                    water_disciple_5_teleporter.teleporter:disable()
                    water_disciple_5_spell_teleporter.teleporter:disable()
                    local essence_of_water = spawn("essence_water").item
                    sage_of_water.socket:addItem(essence_of_water)
                end
            end
		},
        {
			class = "ProjectileCollider",
			size = vec(2.5, 3, 0.5),
            offset = vec(0, 0, 3)
		},
    },
}

defineObject{
	name = "cannon_daemon_pilot_light",
	components = {
		{
			class = "Light",
			offset = vec(0, 0.4, 0),
			range = 0,
			color = math.saturation(vec(1, 0.5, 0.1), 0.8),
			brightness = 0,
			castShadow = true,
			shadowMapSize = 64,
			staticShadows = true,
			staticShadowDistance = 0,	-- use static shadows always
			onInit = function(self)
				-- optimization: disable casting light towards -Y
				self:setClipDistance(3, 0)
			end,
			onUpdate = function(self)
				local noise = math.noise(Time.currentTime()*3 + 123) * .5 + .9
				self:setBrightness(noise * 10)
			end,
		},
		{
			class = "Particle",
            name = "leftTorch",
			particleSystem = "torch",
			offset = vec(-0.25, 1.5, 0.25),
		},
		{
			class = "Particle",
            name = "rightTorch",
			particleSystem = "torch",
			offset = vec(0.25, 1.5, 0.25),
		},
		{
			class = "Controller",
			onActivate = function(self)
				self.go.light:enable()
				self.go.leftTorch:enable()
				self.go.rightTorch:enable()
			end,
			onDeactivate = function(self)
				self.go.light:disable()
				self.go.leftTorch:disable()
				self.go.rightTorch:disable()
			end,
			onToggle = function(self)
				if self.go.light:isEnabled() then
					self.go.light:disable()
                    self.go.leftTorch:disable()
                    self.go.rightTorch:disable()
				else
					self.go.light:enable()
                    self.go.leftTorch:enable()
                    self.go.rightTorch:enable()
				end
			end,
		},
	},
	placement = "wall",
	editorIcon = 88,
}

defineObject{
    name = "cannon_daemon",
    baseObject = "ratling_boss",
    components = {
        {
            class = "RatlingBossBrain",
            name = "brain",
            allAroundSight = true,
            onThink = function(self)
                return nil
            end,
        },
		{
			class = "MonsterAction",
			name = "alert",
			cooldown = 1000,
			animation = "alert",
			sound = "cannon_daemon_alert",
            onBeginAction = function(self) 
                self.go.muzzleFlash:restart()
                self.go.muzzleFlashLight:enable()
                self.go.muzzleFlashLight:fadeIn(0.5)
                self.go.muzzleFlashLight:fadeOut(2.5)  
            end,
		},		
        { -- repeatable alert action with low cooldown
			class = "MonsterAction",
			name = "manualAlert",
			cooldown = 2,
			animation = "alert",
			sound = "cannon_daemon_alert",
            onBeginAction = function(self) 
                self.go.muzzleFlash:restart()
                self.go.muzzleFlashLight:enable()
                self.go.muzzleFlashLight:fadeIn(0.5)
                self.go.muzzleFlashLight:fadeOut(2.5)  
            end,
		},		
        {
			class = "MonsterAttack",
			name = "rangedAttack",
			attackType = "firearm",
			attackPower = 900,
			pierce = 20,
			accuracy = 100,
			woundChance = 60,
			cooldown = 3,
			sound = "ratling_boss_attack",
			knockback = true,
			screenEffect = "damage_screen",
			cameraShake = true,
			onAttack = function(self)
				self.go.muzzleFlash:restart()
				self.go.muzzleFlashLight:enable()
				self.go.muzzleFlashLight:fadeIn(0)
				self.go.muzzleFlashLight:fadeOut(0.2)
                local facing = self.go.facing
                local from_x = self.go.x
                local from_y = self.go.y
                if facing == 0 then -- north
                    from_x = self.go.x
                    from_y = self.go.y-1
                elseif facing == 1 then -- east
                    from_x = self.go.x+1
                    from_y = self.go.y
                elseif facing == 2 then -- south
                    from_x = self.go.x
                    from_y = self.go.y+1
                elseif facing == 3 then -- west
                    from_x = self.go.x-1
                    from_y = self.go.y
                end
                spawn("fireburst", self.go.level, from_x, from_y, facing, self.go.elevation) 
			end,
		},
    },
}

defineSound{
	name = "cannon_daemon_alert",
	filename = "mod_assets/sounds/light-fuse.wav",
	loop = false,
	volume = 1,
	minDistance = 5,
	maxDistance = 12,
}