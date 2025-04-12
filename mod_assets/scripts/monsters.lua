defineObject{
    name = "zarchton_npc",
    baseObject = "zarchton",
    components = {
		{
			class = "Model",
			model = "assets/models/monsters/zarchton.fbx",
			storeSourceData = true, -- must be enabled for mesh particles to work
		},
		{
			class = "Monster",
			meshName = "zarchton_mesh",
			hitSound = "zarchton_hit",
			dieSound = "zarchton_die",
			footstepSound = "zarchton_footstep",
			hitEffect = "hit_blood",
			capsuleHeight = 0.2,
			capsuleRadius = 0.7,
			health = 90,
			evasion = 0,
			exp = 75,
			--lootDrop = { 100, "zarchton_harpoon"},
			resistances = { ["shock"] = "weak" },
		},
		{
			class = "Animation",
			animations = {
				idle = "assets/animations/monsters/zarchton/zarchton_idle.fbx",
				moveForward = "assets/animations/monsters/zarchton/zarchton_walk.fbx",
				moveForward2 = "assets/animations/monsters/zarchton/zarchton_walk.fbx",
				moveForward3 = "assets/animations/monsters/zarchton/zarchton_walk.fbx",
				moveBackward = "assets/animations/monsters/zarchton/zarchton_move_backward.fbx",
				turnLeft = "assets/animations/monsters/zarchton/zarchton_turn_left.fbx",
				turnRight = "assets/animations/monsters/zarchton/zarchton_turn_right.fbx",
				attack = "assets/animations/monsters/zarchton/zarchton_attack.fbx",
				leapAttack = "assets/animations/monsters/zarchton/zarchton_move_attack.fbx",
				getHitFrontLeft = "assets/animations/monsters/zarchton/zarchton_get_hit_front_left.fbx",
				getHitFrontRight = "assets/animations/monsters/zarchton/zarchton_get_hit_front_right.fbx",
				getHitBack = "assets/animations/monsters/zarchton/zarchton_get_hit_back.fbx",
				getHitLeft = "assets/animations/monsters/zarchton/zarchton_get_hit_left.fbx",
				getHitRight = "assets/animations/monsters/zarchton/zarchton_get_hit_right.fbx",
				fall = "assets/animations/monsters/zarchton/zarchton_get_hit_front_left.fbx",
				riseFromWater = "assets/animations/monsters/zarchton/zarchton_rise_from_water.fbx",
                openLock = "mod_assets/animations/zarchton_attack_operate.fbx",
				pullLever = "mod_assets/animations/zarchton_attack_operate.fbx",
				pushLever = "mod_assets/animations/zarchton_attack_operate.fbx",
                fish = "mod_assets/animations/zarchton_fish.fbx",
			},
            onAnimationEvent= function(self, event)
                local npc_script_entity = findEntity("npc_script_entity").script
                return npc_script_entity.onAnimationEvent(self, event)
            end,
			currentLevelOnly = true,
		},
		
		{
			class = "ZarchtonBrain",
			name = "brain",
			sight = 0,
            onThink = function(self)
                local npc_script_entity = findEntity("npc_script_entity").script
                local ret = npc_script_entity.onThinkZarchtonNpc(self)
                if ret == true then
                    return ret
                elseif ret == false then
                    --print("onThink defaults")
                elseif ret == nil then
                    --print("onThink returns "..tostring(ret))
                    ret = true
                end
                return ret
            end,
            onThinkSpecial = function(self)
                local npc_script_entity = findEntity("npc_script_entity").script
                local ret = npc_script_entity.onThinkZarchtonNpc(self)
                if not ret then
                    print("onThinkSpecial returns "..tostring(ret))
                end
                return ret
            end,
		},
        {
            class = "MonsterOperateDevice",
			name = "operateDevice",
			animation = "openLock",
        },
        {
            class = "MonsterAttack",
			name = "fish",
            animation = "fish",
			attackPower = 0,
			accuracy = 0,
			cooldown = 4,
			sound = "water_hit_small"
        },
    }
}

defineAnimationEvent{
	animation = "mod_assets/animations/zarchton_attack_operate.fbx",
	event = "operateDevice",
	frame = 30,
}

defineAnimationEvent{
	animation = "mod_assets/animations/zarchton_fish.fbx",
	event = "fish",
	frame = 30,
}

defineObject{
	name = "merchants_hq_guard1",
    baseObject = "ratling3",
    components = {
        {
			class = "Monster",				
            meshName = "ratling_mesh",
			hitSound = "ratling_hit",
			dieSound = "ratling_die",
			footstepSound = "ratling_footstep",
			hitEffect = "hit_blood_small",
			capsuleHeight = 0.2,
			capsuleRadius = 0.7,		
			health = 1000,
			protection = 10,
			evasion = 12,
			exp = 1500,
		},
		{
			class = "RangedBrain",
			name = "brain",
			sight = 32,
		},
		{
			class = "MonsterMove",
			name = "move",
			sound = "ratling_walk",
			cooldown = 3,
			dashChance = 80,
		},
		{
			class = "MonsterAttack",
			name = "rangedAttack",
			attackType = "firearm",
			attackPower = 150,
			accuracy = 75,
			woundChance = 25,
			cooldown = 5,
			sound = "ratling3_attack",
			screenEffect = "damage_screen",
			onAttack = function(self)
				self.go.muzzleFlash:restart()
				self.go.muzzleFlashLight:enable()
				self.go.muzzleFlashLight:fadeIn(0)
				self.go.muzzleFlashLight:fadeOut(0.1)
			end,
		},
		{
			class = "Particle",
			parentNode = "muzzle_flash",
			name = "muzzleFlash",
			particleSystem = "muzzle_flash_small",
			enabled = false,
		},
		{
			class = "Light",
			parentNode = "muzzle_flash",
			name = "muzzleFlashLight",
			color = vec(1.0, 0.5, 0.2),
			brightness = 20,
			range = 4,
			disableSelf = true,
			enabled = false,
			fillLight = true,
		},
	},
}

defineParticleSystem{
    name = "spirit_fire_pillar",
    emitters = {
        {
			emissionRate = 500,
			emissionTime = 0,
			maxParticles = 500,
			boxMin = {-0.03, .25, 0.03},
			boxMax = { 0.03, .25,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
            texture = "assets/textures/particles/teleporter.tga",
			-- texture = "assets/textures/particles/castle_wall_text.tga",
			-- frameRate = 1,
			-- frameSize = 32,
			-- frameCount = 9,
			lifetime = {5, 7},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {1, 1},
			gravity = {0,7,0},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			objectSpace = false, 
        }            
    }
}

defineParticleSystem{
    name = "flower_petals_in_wind",
    emitters = {
        {
			emissionRate = 5,
			emissionTime = 0,
			maxParticles = 100,
			boxMin = {-0.03, .25, 0.03},
			boxMax = { 0.03, .25,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			texture = "assets/textures/particles/castle_wall_text.tga",
			frameRate = 1,
			frameSize = 32,
			frameCount = 9,
			lifetime = {5, 7},
			colorAnimation = false,
			color0 = {1, 0, 0},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {.1, .1},
			gravity = {-1,0,-1},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			objectSpace = false, 
        }            
    }
}

defineParticleSystem{
    name = "dialog_system_from_npc_left",
    emitters = {
        {
			emissionRate = 15,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {-0.6, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			--texture = "assets/textures/particles/castle_wall_text.tga",
			texture = "assets/textures/env/castle_wall_text_dif.tga",
			frameRate = 2,
			frameSize = 43,
			frameCount = 9,
			lifetime = {3.5, 4},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = .45,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {.1, .1},
			gravity = {-.1, 0.2, -1},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true, 
        },
        {
			emissionRate = 15,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {-0.6, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			texture = "assets/textures/particles/castle_wall_text.tga",
			frameRate = 2,
			frameSize = 32,
			frameCount = 9,
			lifetime = {3.5, 4},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = .45,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {.1, .1},
			gravity = {-.1, 0.2, -1},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			objectSpace = true, 
        },   
		{
			emissionRate = 40,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {-0.6, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {3.5, 4},
			color0 = {2.0,2.0,2.0},
			opacity = .25,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {0.05, 0.5},
			gravity = {-.1, 0.2, -1},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			objectSpace = true, 
		},
		{
			emissionRate = 10,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {0.2, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			objectSpace = true,
			texture = "assets/textures/particles/fog.tga",
			lifetime = {3.5, 4},
			color0 = {0.152941, 0.352941, 0.803922},
			opacity = 1,
			fadeIn = 2.2,
			fadeOut = 2.2,
			size = {0.15, 0.5},
			gravity = {-.1, 0.2, -1},
			airResistance = 1,
			rotationSpeed = 0.3,
			blendMode = "Additive",
		},	            
    }
}

defineParticleSystem{
    name = "dialog_system_from_npc_right",
    emitters = {
        {
			emissionRate = 15,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {-0.6, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			--texture = "assets/textures/particles/castle_wall_text.tga",
			texture = "assets/textures/env/castle_wall_text_dif.tga",
			frameRate = 2,
			frameSize = 43,
			frameCount = 9,
			lifetime = {3.5, 4},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = .45,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {.1, .1},
			gravity = {-.1, 0.2, 1},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true, 
        },
        {
			emissionRate = 15,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {-0.6, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			texture = "assets/textures/particles/castle_wall_text.tga",
			frameRate = 2,
			frameSize = 32,
			frameCount = 9,
			lifetime = {3.5, 4},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = .45,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {.1, .1},
			gravity = {-.1, 0.2, 1},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			objectSpace = true, 
        },   
		{
			emissionRate = 40,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {-0.6, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {3.5, 4},
			color0 = {2.0,2.0,2.0},
			opacity = .25,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {0.05, 0.5},
			gravity = {-.1, 0.2, 1},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			objectSpace = true, 
		},
		{
			emissionRate = 10,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {0.2, -0.5, 0.03},
			boxMax = {0.6, .5,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 1.4},
			objectSpace = true,
			texture = "assets/textures/particles/fog.tga",
			lifetime = {3.5, 4},
			color0 = {0.152941, 0.352941, 0.803922},
			opacity = 1,
			fadeIn = 2.2,
			fadeOut = 2.2,
			size = {0.15, 0.5},
			gravity = {-.1, 0.2, 1},
			airResistance = 1,
			rotationSpeed = 0.3,
			blendMode = "Additive",
		},	            
    }
}

defineObject{
    name = "dialog_system_socket",
    components = {
		{
			class = "Clickable",
			offset = vec(0.0, 1.5, 0.0),
			size = vec(1, 1, 0.15),
			--debugDraw = true,
		},
		{
			class = "Socket",
			offset = vec(0.05, 1.1, -0.25),            
			--rotation = vec(0, -20, -90),
            onAcceptItem = function(self, item)
                return self:count() == 0
            end
			--debugDraw = true,
		},
    },
	placement = "wall",
	editorIcon = 84,
}

defineObject{
    name = "dialog_system_clickable",
    baseObject = "forest_statue_wall_1",
    components = {
		{
			class = "Model",
			model = "assets/models/env/castle_wall_text_long.fbx",
			offset = vec(0, -1, -0.1),
		},
		{
			class = "Clickable",
			offset = vec(0, .7, 0),
			size = vec(1.5, .6, 1.5),
            --debugDraw = true
        },
		{
			class = "Button",
		},
        {
            class = "Timer",
            name = "timer",
            timerInterval = .1,
            disableSelf = true,
            enabled = false,
            onActivate = function(self)
                self.go.button:enable()
                self.go.clickable:enable()                    
            end
        },            
        {
            class = "WallText",
            onShowText = function(self)
                self.go.button:disable()
                self.go.clickable:disable()
                if self.go.dialog_particles_left:isEnabled() then
                    self.go.dialog_particles_left:restart()
                end
                if self.go.dialog_particles_right:isEnabled() then
                    self.go.dialog_particles_right:restart()
                end
            end,
            onDismissText = function(self) 
                self.go.timer:setTimerInterval(.1)  -- this timer protects the button and clickable from the dismiss click and the system from unintended activation of the next state in the dialog
                self.go.timer:enable()
                self.go.timer:start()
            end,
        },
		{
			class = "Particle",
			particleSystem = "castle_wall_text",
			offset = vec(0, -1, -0.2),
		},
		{
			class = "Particle",
            name = "dialog_particles_left",
			particleSystem = "dialog_system_from_npc_left",
			offset = vec(0,0.25, 0),
            enabled = false
		},
		{
			class = "Particle",
            name = "dialog_particles_right",
			particleSystem = "dialog_system_from_npc_right",
			offset = vec(0,0.25, 0),
            enabled = false
		},
        
        {
			class = "Light",
			name = "leftEyeLight",
			offset = vec(0.4, 1.55, 0),
			range = 0.7,
			--debugDraw = true,
            enabled = false,
		},
        {
			class = "Light",
			name = "rightEyeLight",
			offset = vec(0.4, 1.55, 0),
			range = 0.7,
			--debugDraw = true,
            enabled = false,
		},
		{
			class = "Model",
			name = "eyesModel",
			model = "assets/models/env/forest_statue_wall_eyes_1.fbx",
			offset = vec(0, 0, -1.5),
			staticShadow = true,
            enabled = false,
		},		
        {
			class = "StonePhilosopherController",
            enabled = false,
		},
    }
}

defineObject{
    name = "dialog_system_show_history_button",    
    baseObject = "wall_button",
    components = {
		{
			class = "Model",
			model = "assets/models/env/castle_wall_button.fbx",
			--offset = vec(1,-.25,1.2),
            offset = vec(1, 1.125, 1.2)
		},		
        {
			class = "Particle",
			particleSystem = "castle_button",
			offset = vec(1, 1.125, 1.2),
		},
		{
			class = "Light",
			offset = vec(1, 1.125, 1.2),
			range = 1,
			color = vec(0.5, 1.0, 2.5),
			brightness = .2,
			fillLight = true,
		},
        {
            class = "WallText",
            style = "writer"
        },
        {
			class = "Clickable",
			offset = vec(1,1.125,1.2),
			size = vec(0.25, 0.25, 0.25),
            --debugDraw = true
        }
    }    
}


defineObject{
    name = "dialog_system_show_selectable_answer",
    baseObject = "castle_wall_text",
    components = {    
		{
			class = "Model",
			model = "assets/models/env/castle_wall_text_long.fbx",
			offset = vec(0, 0, -0.1),
		},
		{
			class = "Particle",
			particleSystem = "castle_wall_text",
			offset = vec(0, 0, -0.2),
		},
		{
			class = "Clickable",
			offset = vec(0, 1.5, 0),
			size = vec(1.2, 0.8, 0.2),
			frontFacing = true,
			--debugDraw = true,
		},
		{
			class = "Light",
			offset = vec(0, 1.5, -0.2),
			range = 4,
			color = vec(0.5, 1.0, 2.5),
			brightness = 4,
			fillLight = true,
		},
    }
}

defineObject{
    name = "dialog_system_selected_answer_left",
    components = {
        {
            class = "Particle",
            name = "particle_answer_left",
            particleSystem = "dialog_system_answer_to_left",
			offset = vec(0, 1.5, -0.2),
            enabled = false,
        }
    },
	placement = "wall",
	editorIcon = 84,
}

defineObject{
    name = "dialog_system_selected_answer_left",
    components = {
        {
            class = "Particle",
            name = "particle_answer",
            particleSystem = "dialog_system_answer",
			offset = vec(0, 1.5, -0.2),
            rotation = vec(90, -90, 0),
            enabled = false,
        }
    },
	placement = "wall",
	editorIcon = 84,
}

defineObject{
    name = "dialog_system_selected_answer_right",
    components = {
        {
            class = "Particle",
            name = "particle_answer",
            particleSystem = "dialog_system_answer",
			offset = vec(0, 1.5, -0.2),
            rotation = vec(90, 90, 0),
            enabled = false,
        }
    },
	placement = "wall",
	editorIcon = 84,
}

defineParticleSystem{
    name = "dialog_system_answer",
    emitters = {
        {
			emissionRate = 15,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {0,0,-0.1},
			boxMax = {0,0,0.1},
			sprayAngle = {0,0},
			velocity = {.1, 1.4},
			texture = "assets/textures/env/castle_wall_text_dif.tga",
			frameRate = 2,
			frameSize = 43,
			frameCount = 9,
			lifetime = {2.5, 3},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = .45,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {.1, .1},
			gravity = {0, 1, -.2},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true, 
        },
        {
			emissionRate = 15,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,0},
			velocity = {.1, 1.4},
			texture = "assets/textures/particles/castle_wall_text.tga",
			frameRate = 2,
			frameSize = 32,
			frameCount = 9,
			lifetime = {2.5, 3},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = .45,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {.1, .1},
			--gravity = {-.1, 1, 0.2},
			gravity = {0, 1,  -.2},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
			objectSpace = true, 
        },   
		{
			emissionRate = 40,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,0},
			velocity = {.1, 1.4},
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {2.5, 3},
			color0 = {2.0,2.0,2.0},
			opacity = .25,
			fadeIn = 0.5,
			fadeOut = 0.3,
			size = {0.05, 0.5},
			gravity = {0, 1,  -.2},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			objectSpace = true, 
		},
		{
			emissionRate = 10,
			emissionTime = 0,
			maxParticles = 30,
			spawnBurst = true,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,0},
			velocity = {.1, 1.4},
			objectSpace = true,
			texture = "assets/textures/particles/fog.tga",
			lifetime = {2.5, 3},
			color0 = {0.152941, 0.352941, 0.803922},
			opacity = 1,
			fadeIn = 2.2,
			fadeOut = 2.2,
			size = {0.15, 0.5},
			gravity = {0, 1,  -.2},
			airResistance = 1,
			rotationSpeed = 0.3,
			blendMode = "Additive",
		},	            
    }
}

defineObject{
    name = "dialog_system_answer",
    baseObject = "wall_button",
    components = {
		{
			class = "Model",
			model = "assets/models/env/castle_wall_button.fbx",
			--offset = vec(1,.25,0),
            offset = vec(1, 1.5, 0)
		},		
        {
			class = "Particle",
			particleSystem = "castle_button",
			offset = vec(1, 1.5, 0),
		},
		{
			class = "Light",
			offset = vec(1, 1.5, 0),
			range = 1,
			color = vec(0.5, 1.0, 2.5),
			brightness = .2,
			fillLight = true,
		},
        {
            class = "WallText",
            style = "writer"
        },
        {
			class = "Clickable",
			offset = vec(1,1.475,0),
			size = vec(0.25, 0.25, 0.25),
            debugDraw = true
        }
    }    
}


defineObject{
	name = "medusa_guardian",
	baseObject = "medusa",
    components = {
		{
			class = "Model",
			model = "assets/models/monsters/medusa.fbx",
			storeSourceData = true,
            material = "spirit_light", 
		}, 		
        {
			class = "Monster",
			meshName = "medusa_mesh",
			hitSound = "medusa_hit",
			dieSound = "medusa_die",
			hitEffect = "hit_spirit",
			deathEffect = "death_spirit", 
			capsuleHeight = 0.2,
			capsuleRadius = 0.7,
			health = 1000,
			evasion = 5,
			protection = 5,
			exp = 600,
			flying = true,
			immunities = { "sleep", "blinded" },
		},     
		{
			class = "UggardianBrain",
			name = "brain",
			sight = 20,
			morale = 100,
            onThink = function(self)
                local facing_dx, facing_dy = getForward(self.go.facing)
                local dx = self.go.x - party.x
                local dy = self.go.y - party.y
                local delevation = self.go.elevation - party.elevation
                local facing_party_y = (dx == 0 and ((self.go.facing == 0 and dy > 0) or (self.go.facing == 2 and dy < 0)))
                local facing_party_x = (dy == 0 and ((self.go.facing == 3 and dx > 0) or (self.go.facing == 1 and dx < 0)))
                if not self.seesParty or delevation ~= 0 or self.go.level ~= party.level then
                    return false
                elseif delevation == 0 and ((facing_party_x and dx <= 2) or (facing_party_y and dy <= 2)) then
                    return self:performAction("basicAttack")
                elseif delevation == 0 and (facing_party_x or facing_party_y) then
                    local action = math.random(5)    
                    if action <= 4 and not self.blockedFront then
                        return self:performAction("rangedPullAttack", 0)
                    else
                        return self:performAction("rangedAttack")
                    end
                else
                    return false
                end
            end
		},
		-- petrifying gaze attack
		{
			class = "MonsterAttack",
			name = "basicAttack",
			attackPower = 70,
			pierce = 10,
			accuracy = 90,
			cooldown = 7,
			repeatChance = 0,
			animation = "gazeAttack",
			sound = "medusa_gaze",
			onAttack = function(self)
                self.go.eyeFlashParticle:restart()

                if party.elevation == self.go.elevation then
                    local dx,dy = getForward(self.go.facing)
                    if (party.x == self.go.x + dx and party.y == self.go.y + dy) or
                        (party.x == self.go.x + dx*2 and party.y == self.go.y + dy*2) then
                        party.party:shakeCamera(0.3, 0.3)
                        -- choose random target
                        for i=1,40 do
                            local champion = party.party:getChampion(math.random(1,4))
                            if champion:isAlive() and not champion:hasCondition("petrified") then
                                local chance = 70 - champion:getCurrentStat("willpower")*2
                                if math.random(1,100) < chance then
                                    champion:setCondition("petrified", true)
                                end
                                return false
                            end
                        end
                    end
                end
                
				return false
			end,
		},
		-- -- arrow attack
		{
			class = "MonsterAttack",
			name = "rangedAttack",
			attackType = "projectile",
			attackPower = 60,
			cooldown = 3,
			animation = "attack",
			sound = "medusa_attack",
			shootProjectile = "arrow",
			projectileHeight = 1.6,
        },
        {
            class = "MonsterAttack",
            name = "rangedPullAttack",
            attackType = "firearm",
            cooldown = 3,
            attackPower = 100,
            accuracy = 100,
            animation = "attack",
			sound = "medusa_attack",
            onAttack = function(self)
                self.go.eyeFlashParticle:restart()
                self.go:spawn("dispel_blast")
                return true
            end,            
            onAttackHit = function(self, champion)
                hudPrint("Get Over Here!")
                local party_teleport_pos = {}
                party_teleport_pos.x = self.go.x
                party_teleport_pos.y = self.go.y
                party_teleport_pos.elevation = self.go.elevation
                party_teleport_pos.facing = ((self.go.facing + 2) % 4)
                party_teleport_pos.level = self.go.level
                if self.go.facing == 0 then
                    party_teleport_pos.y = self.go.y - 1
                elseif self.go.facing == 1 then
                    party_teleport_pos.x = self.go.x + 1
                elseif self.go.facing == 2 then
                    party_teleport_pos.y = self.go.y + 1
                elseif self.go.facing == 3 then
                    party_teleport_pos.x = self.go.x - 1
                end
                party:setPosition(party_teleport_pos.x, party_teleport_pos.y, party_teleport_pos.facing, party_teleport_pos.elevation, party_teleport_pos.level)
                party:spawn("teleportation_effect")
                local spawn_blast = party:spawn("dispel_blast")
                local w_pos = spawn_blast:getWorldPosition()
                w_pos = w_pos + vec(0, 0.5, 0)    
                spawn_blast:setWorldPosition(w_pos)
                return false
            end
		},
	},
}

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
			gravity = {0,1,0},
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
			gravity = {0,1,0},
			airResistance = 0.1,
			rotationSpeed = 2,
			blendMode = "Additive",
			depthBias = 0.2,
		},
    }
}

defineParticleSystem{
	name = "death_spirit",
	emitters = {
		{
			emitterShape = "MeshShape",
			spawnBurst = true,
			maxParticles = 500,
			sprayAngle = {0,360},
			velocity = {0.5*1.5, 2*1.5},
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {0.3, 1.7},
			colorAnimation = false,
			color0 = {2.0,2.0,2.0},
			fadeIn = 0.1,
            opacity = 0.2,
			fadeOut = 0.5,
			size = {0.05, 0.5},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
		},
		{ -- spirit shape
			emitterShape = "MeshShape",
			spawnBurst = true,
			maxParticles = 1500,
			sprayAngle = {0,360},
			velocity = {0.1, 0.1},
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {.2, 4},
			colorAnimation = false,
			color0 = {2.0,2.0,2.0},
			fadeIn = .1,
			opacity = .45,
			fadeOut = 3,
			size = {0.05, 0.5},
			gravity = {0,-2,0},
			airResistance = .2,
			rotationSpeed = 1,
			blendMode = "Additive",
            clampToGroundPlane = true
		},
		{
			spawnBurst = true,
			maxParticles = 30,
			boxMin = {-0.4, 0.25, -0.4},
			boxMax = { 0.4, 1.5, 0.4},
			sprayAngle = {0,80},
			velocity = {0,1},
			objectSpace = true,
			texture = "assets/textures/particles/fog.tga",
			lifetime = {0.4,2.5},
			color = {0.5, 0.75, 1},
			opacity = 0.5,
			fadeIn = 0.1,
			fadeOut = 1.5,
			size = {0.5, 2},
			gravity = {0,-2,0},
			airResistance = 1,
			rotationSpeed = 0.5,
			blendMode = "Additive",
		},
		{
			spawnBurst = true,
			maxParticles = 1,
			boxMin = {0,0.8,0},
			boxMax = {0,0.8,0},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {0.4, 0.4},
			colorAnimation = false,
			color = {0.25,0.25,0.25},
			fadeIn = 0.01,
			fadeOut = 0.1,
			size = {4, 4},
			gravity = {0,-2,0},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},
	}
}

defineParticleSystem{
	name = "hit_spirit",
	emitters = {
		{
			spawnBurst = true,
			maxParticles = 40,
			sprayAngle = {0,360},
			velocity = {0.5*1.5, 2*1.5},
			texture = "assets/textures/particles/teleporter.tga",
			lifetime = {0.3, 1.7},
			colorAnimation = false,
			color0 = {2.0,2.0,2.0},
			fadeIn = 0.1,
			fadeOut = 0.5,
			size = {0.05, 0.5},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 1,
			blendMode = "Additive",
		},
		{
			spawnBurst = true,
			maxParticles = 3,
			boxMin = {-0.2, 0.2, -0.2},
			boxMax = { 0.2, 0.2,  0.2},
			sprayAngle = {0,80},
			velocity = {0,1},
			objectSpace = true,
			texture = "assets/textures/particles/fog.tga",
			lifetime = {0.4,2.5},
			color = {0.5, 0.75, 1},
			opacity = 0.3,
			fadeIn = 0.1,
			fadeOut = 1.5,
			size = {1.5, 1.5},
			gravity = {0,0,0},
			airResistance = 0.5,
			rotationSpeed = 0.5,
			blendMode = "Additive",
		},
		{
			spawnBurst = true,
			maxParticles = 1,
			boxMin = {0,0.8,0},
			boxMax = {0,0.8,0},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {0.4, 0.4},
			colorAnimation = false,
			color = {0.25,0.25,0.25},
			opacity = 0.5,
			fadeIn = 0.01,
			fadeOut = 0.1,
			size = {4, 4},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 2,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},
	}
}


defineMaterial{
	name = "spirit_light",
	diffuseMap = "assets/textures/effects/force_field_dif.tga",
	normalMap = "assets/textures/env/healing_crystal_normal.tga",
	specularMap = "assets/textures/common/white.tga",
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
    name = "turtle_spirit",
    baseObject = "turtle",
    components = {		
        {
			class = "Model",
			model = "assets/models/monsters/turtle.fbx",
			storeSourceData = true, -- must be enabled for mesh particles to work
            material = "spirit_light", --"healing_crystal",            
            dissolveStart = 1,
            dissolveEnd = 1,
		},
		{
			class = "UggardianFlames",
			particleSystem = "spirit",
            name = "spiritParticles",
			emitFromMaterial = "*",
		},		
        {
			class = "Monster",
			meshName = "turtle_mesh",
			hitSound = "turtle_hit",
			dieSound = "turtle_die",
			footstepSound = "turtle_footstep",
			hitEffect = "hit_spirit",
			deathEffect = "death_spirit",
			health = 90,
			evasion = -10,
			exp = 60,
			lootDrop = { 15, "potion_energy" },
			--resistances = { physical = "immune" },
			traits = { "elemental" },
			headRotation = vec(90, 0, 0),
		},
    }
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
			hitEffect = "hit_ice",
			deathEffect = "death_icy",	
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
			hitEffect = "hit_ice",
			deathEffect = "death_icy",
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
				self.go.leftTorch:start()
				self.go.rightTorch:start()
			end,
			onDeactivate = function(self)
				self.go.light:disable()
				self.go.leftTorch:stop()
				self.go.rightTorch:stop()
			end,
			onToggle = function(self)
				if self.go.light:isEnabled() then
					self.go.light:disable()
                    self.go.leftTorch:stop()
                    self.go.rightTorch:stop()
				else
					self.go.light:enable()
                    self.go.leftTorch:start()
                    self.go.rightTorch:start()
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