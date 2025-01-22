defineObject{
    name = "pushblock_robin",
    baseObject = "pushable_block",
    components = {
        {
			class = "Model",
			model = "assets/models/monsters/skeleton_knight_commander.fbx",
			storeSourceData = true, -- must be enabled for mesh particles to work
        }
    }
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