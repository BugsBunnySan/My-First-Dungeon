defineObject{
    name = "dungeon_floor_dirt_meridian_01",
    baseObject = "dungeon_floor_dirt_01",
    components = {
        {
            class = "Model",
            material = "dungeon_floor_dirt_meridian_line",
            model = "assets/models/env/dungeon_floor_dirt_01.fbx",
            staticShadow = true,
        }
    }
}

defineObject{
    name = "dungeon_floor_dirt_equator_01",
    baseObject = "dungeon_floor_dirt_01",
    components = {
        {
            class = "Model",
            material = "dungeon_floor_dirt_equator_line",
            model = "assets/models/env/dungeon_floor_dirt_01.fbx",
            staticShadow = true,
        }
    }
}


defineObject{
	name = "castle_ceiling_light_red",
	components = {
		{
			class = "Light",
			type = "spot",
			spotAngle = 90,
			rotation = vec(-90, 0, 0),
			spotSharpness = 0.7,
			offset = vec(0, 4.5, 0),
			range = 20,
			--color = vec(0.45, 0.8, 1.55),
			color = math.saturation(vec(2.5, 0.45, 0.45), 0.9),
			brightness = 6,
			castShadow = true,
			shadowMapSize = 1024,
			--debugDraw = true,
		},
		{
			class = "Light",
			name = "pointlight",
			type = "point",
			offset = vec(0, 4.5, 0),
			range = 6,
			--color = vec(0.45, 0.8, 1.55),
			color = math.saturation(vec(2.5, 0.47, 0.47), 0.9),
			brightness = 3,
		},
		
		{
			class = "Particle",
			particleSystem = "castle_ceiling_light",
			offset = vec(0, 4.75, 0),
		},
		{
			class = "Controller",
			onActivate = function(self)
				self.go.light:enable()
				self.go.pointlight:enable()
				self.go.particle:enable()
			end,
			onDeactivate = function(self)
				self.go.light:disable()
				self.go.pointlight:disable()
				self.go.particle:disable()
			end,
			onToggle = function(self)
				if self.go.light:isEnabled() then
					self.go.light:disable()
					self.go.pointlight:disable()
					self.go.particle:disable()
				else
					self.go.light:enable()
					self.go.pointlight:enable()
					self.go.particle:enable()
				end
			end,
		},
	},
	placement = "floor",
	editorIcon = 88,
}
defineParticleSystem{
	name = "castle_pillar_candles_blue",
	emitters = {
				-- flame1
		{
			spawnBurst = true,
			maxParticles = 1,
			boxMin = {0.03,-0.16, 0.17},
			boxMax = {0.03,-0.16, 0.17},
			sprayAngle = {0,10},
			velocity = {0, 0},
			texture = "assets/textures/particles/candle_flame.tga",
			frameRate = 32,
			frameSize = 64,
			frameCount = 16,
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.1, 0.1},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
			randomInitialRotation = false,
		},

		-- flame 1 glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0.02,-0.16, 0.18},
			boxMax = {0.02,-0.16, 0.18},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.18, 0.21, 0.33},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.25, 0.25},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},
		
		-- flame 2 glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0.05, -0.03, 0.27},
			boxMax = {0.05, -0.03, 0.27},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.18, 0.21, 0.33},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.25, 0.25},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},
		
		-- flame2
		{
			spawnBurst = true,
			maxParticles = 1,
			boxMin = {0.05, -0.03, 0.27},
			boxMax = {0.05, -0.03, 0.27},
			sprayAngle = {0,10},
			velocity = {0, 0},
			texture = "assets/textures/particles/candle_flame.tga",
			frameRate = 32,
			frameSize = 64,
			frameCount = 16,
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.1, 0.1},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
			randomInitialRotation = false,
		},

		-- flame 3 glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {-0.07, -0.1, 0.25},
			boxMax = {-0.07, -0.1, 0.25},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.18, 0.21, 0.33},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.25, 0.25},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},
		
		-- flame3
		{
			spawnBurst = true,
			maxParticles = 1,
			boxMin = {-0.06, -0.11, 0.24},
			boxMax = {-0.06, -0.11, 0.24},
			sprayAngle = {0,10},
			velocity = {0, 0},
			texture = "assets/textures/particles/candle_flame.tga",
			frameRate = 32,
			frameSize = 64,
			frameCount = 16,
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {1, 1, 1},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.1, 0.1},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
			randomInitialRotation = false,
		},
	}
}

defineObject{
	name = "castle_pillar_candle_holder_blue",
	components = {
		{
			class = "Model",
			model = "assets/models/env/castle_pillar_candle_holder.fbx",
			offset = vec(0, -0.1, 0),
			staticShadow = true,
		},
		
		{
			class = "Particle",
			particleSystem = "castle_pillar_candles_blue",
			offset = vec(0, 2.5, -0.6),
		},
		{
			class = "Light",
			range = 3.5,
			color = vec(0.35, 0.68, 1.1),
			brightness = 7,
			--castShadow = false,
			staticShadows = true,
			shadowMapSize = 256,
			fillLight = true,
			offset = vec(0, 2.6, -0.6),
			onUpdate = function(self)
				local noise = math.noise(Time.currentTime()*3 + 123) * 0.5 + 0.9
				self:setBrightness(noise * 10)
			end,
		},
	},
	placement = "pillar",
	editorIcon = 108,
}