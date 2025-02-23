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
			color0 = {.2, 0, 0},
			opacity = 1,
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
			velocity = {0.1, 1.4},
			texture = "assets/textures/particles/goromorg_lantern.tga",
			frameRate = 45,
			frameSize = 64,
			frameCount = 16,
			lifetime = {0.25, 0.85},
			colorAnimation = false,
			color0 = {1, 0, 0},
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
			color0 = {1, 0, 0},
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
			color0 = {1, 0, 0},
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
	name = "castle_pillar_light_red",
	components = {
		{
			class = "Model",
			model = "assets/models/env/castle_pillar_light.fbx",
			staticShadow = true,
		},
		
		{
			class = "Particle",
			particleSystem = "wizard_lantern_red",
			offset = vec(0, 1.6, 0),
		},
		{
			class = "Light",
			range = 1.5,
			color = vec(2.5, 0, 0.0),
			brightness = .5,
			castShadow = false,
			--staticShadows = true,
			--shadowMapSize = 256,
			offset = vec(0, 1.6, 0),
			--onUpdate = function(self)
			--	local noise = math.noise(Time.currentTime()*3 + 123) * 0.5 + 0.9
			--	self:setBrightness(noise * 10)
			--end,
		},
	},
	placement = "pillar",
	editorIcon = 108,
}
defineParticleSystem{
	name = "flames_on_wall",
	emitters = {


		-- flames
		{
			emissionRate = 50,
			emissionTime = 0,
			maxParticles = 100,
			boxMin = {-0.53, -0.03, 0.53},
			boxMax = { 0.53, 0.03,  -0.53},
			sprayAngle = {10,50},
			velocity = {0.2, 6},
			texture = "assets/textures/particles/torch_flame.tga",
			frameRate = 35,
			frameSize = 64,
			frameCount = 16,
			lifetime = {0.55, 1.85},
			colorAnimation = true,
			color0 = {2, 2, 2},
			color1 = {1.0, 1.0, 1.0},
			color2 = {1.0, 0.5, 0.25},
			color3 = {1.0, 0.3, 0.1},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {1.35, 1.015},
			gravity = {0,0,0},
			airResistance = 1.0,
			rotationSpeed = 1,
			blendMode = "Additive",
			depthBias = 0.1,
		},

		-- glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0,0,-0.1},
			boxMax = {0,0,-0.1},
			sprayAngle = {0,30},
			velocity = {0,4},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.23, 0.11, 0.08},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {2, 2},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
		}
	}
}


defineObject{
    name = "dungeon_wall_burning_01",
    baseObject = "dungeon_wall_01",
    components = {
        {
			class = "Particle",
            name = "smoke",
			particleSystem = "floor_vent_steam",
			offset = vec(00, 4, .9)
        },
        {
			class = "Particle",
            name = "flames",
			particleSystem = "flames_on_wall",
			offset = vec(0, 1.85, 1)
        },
    },
    minimalSaveState = false
}

defineObject{
    name = "dungeon_wall_broken_burning_01",
    baseObject = "dungeon_wall_broken_01",
    components = {
        {
			class = "Particle",
            name = "smoke",
			particleSystem = "floor_vent_steam",
			offset = vec(00, 4, .9)
        },
        {
			class = "Particle",
            name = "flames",
			particleSystem = "flames_on_wall",
			offset = vec(0, 1.85, 1)
        },
    },
    minimalSaveState = false
}

defineObject{
    name = "dungeon_wall_broken_burning_02",
    baseObject = "dungeon_wall_broken_02",
    components = {
        {
			class = "Particle",
            name = "smoke",
			particleSystem = "floor_vent_steam",
			offset = vec(00, 4, .9)
        },
        {
			class = "Particle",
            name = "flames",
			particleSystem = "flames_on_wall",
			offset = vec(0, 1.85, 1)
        },
    },
    minimalSaveState = false
}

defineObject{
    name = "dungeon_wall_broken_01_sl",
    baseObject = "dungeon_wall_broken_01",    
    minimalSaveState = false
}

defineObject{
    name = "dungeon_wall_broken_02_sl",
    baseObject = "dungeon_wall_broken_02",    
    minimalSaveState = false
}

defineObject{
    name = "cemetery_wall_01_sl",
    baseObject = "cemetery_wall_01",
    minimalSaveState = false
}

defineObject{
    name = "dungeon_pillar_sl",
    baseObject = "dungeon_pillar",
    minimalSaveState = false    
}

defineObject{
    name = "forest_plant_cluster_01_sl",
    baseObject = "forest_plant_cluster_01",
    minimalSaveState = false
}

defineObject{
    name = "pushblock_robin",
    baseObject = "pushable_block",
    components = {
        {
			class = "Model",
			model = "assets/models/monsters/skeleton_knight_commander.fbx",
			storeSourceData = true, -- must be enabled for mesh particles to work
        }
    },
    minimalSaveState = false
}

defineObject{
	name = "pushblock_floor_trigger_blue",
	baseObject = "pushable_block_floor",
	components = {
		{
			class = "Model",
			name = "lightStrip",
			model = "assets/models/env/pushable_block_floor_beam_white.fbx",
			staticShadow = true,
			enabled = false,
		},
		{
			class = "Particle",
			particleSystem = "pushable_block_red",
			emitterMesh = "assets/models/env/pushable_block_floor_light.fbx",
			enabled = false,
		},		
		{
			class = "Light",
			offset = vec(0, 0, 0),
			range = 3,
			color = vec(1, 0.35, 0.2),
			brightness = 35,
			enabled = false,
			fillLight = true,
        },
		{
			class = "FloorTrigger",
			triggeredByParty = false,
			triggeredByMonster = false,
			triggeredByItem = false,
			triggeredByPushableBlock = true,
		},
	},
	editorIcon = 228,
	replacesFloor = true,
}

defineObject{
	name = "boat_small",
	baseObject = "base_floor_decoration",
	components = {
		{
			class = "Model",
			model = "mod_assets/models/boat.fbx",
			dissolveStart = 6,
			dissolveEnd = 9,
			staticShadow = true,
		},
	},
	editorIcon = 108,
	minimalSaveState = true,
}

defineObject{
    name = "rubble_pedestal",
    baseObject = "pedestal",
    components = {
        {
            class = "Surface",			
            offset = vec(0, 0.85, 0),
			size = vec(1, 0.65),			
            onAcceptItem = function(self, item)
                return (self:count() == 0 and item.go.name == "pickaxe")
            end
        }
    }
}

defineObject{
	name = "surface_catacomb_alcove_lower",
	baseObject = "base_wall",
	components = {
		{
			class = "Surface",
			offset = vec(0, 0.85, 0.2), 
			size = vec(2, 0.2),
			--debugDraw = true,
		}, 
		{
			class = "Clickable",
			offset = vec(0, 0.85, 0.2), 
			size = vec(2, 0.2),
			-- debugDraw = true,
		},		
        {
			class = "Light",
			range = 3.5,
			color = vec(1, 0, 0),
			brightness = 7,
			castShadow = true,
			staticShadows = true,
			shadowMapSize = 256,
			--fillLight = true,
			offset = vec(0, 0.85, 0.2),
			onUpdate = function(self)
				local noise = math.noise(Time.currentTime()*3 + 123) * 0.5 + 0.9
				self:setBrightness(noise * 10)
			end,
		},
	},
	editorIcon = 92,
	minimalSaveState = false,
}
defineObject{
	name = "surface_catacomb_alcove_upper",
	baseObject = "base_wall",
	components = {
		{
			class = "Surface",
			offset = vec(0, 1.85, 0.2), 
			size = vec(2, 0.2),
			--debugDraw = true,
		}, 
		{
			class = "Clickable",
			offset = vec(0, 2, 0.2), 
			size = vec(2, 0.2),
			-- debugDraw = true,
		},        
        {
			class = "Light",
			range = 3.5,
			color = vec(1, 0, 0),
			brightness = 7,
			castShadow = true,
			staticShadows = true,
			shadowMapSize = 256,
			--fillLight = true,
			offset = vec(0, 1.85, 0.2),
			onUpdate = function(self)
				local noise = math.noise(Time.currentTime()*3 + 123) * 0.5 + 0.9
				self:setBrightness(noise * 10)
			end,
		},
	},
	editorIcon = 92,
	minimalSaveState = false,
}