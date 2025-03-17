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