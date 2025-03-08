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