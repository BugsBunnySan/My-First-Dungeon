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