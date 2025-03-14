-- This file has been generated by Dungeon Editor 2.2.4

-- import standard assets
import "assets/scripts/standard_assets.lua"

-- import custom assets
import "mod_assets/scripts/items.lua"
import "mod_assets/scripts/monsters.lua"
import "mod_assets/scripts/objects.lua"
import "mod_assets/scripts/tiles.lua"
import "mod_assets/scripts/recipes.lua"
import "mod_assets/scripts/spells.lua"
import "mod_assets/scripts/materials.lua"
import "mod_assets/scripts/sounds.lua"

defineObject{
    name = "party",
    baseObject = "party",

    components = {
        {
            class = "Party",
            name = "party",
            onCastSpell = function(self, champion, spell)
                local script_entity = findEntity("global_scripts")
                return script_entity.script.partyOnCastSpell(self, champion, spell)
            end,
            onWakeUp = function(self)
                local script_entity = findEntity("global_scripts")
                return script_entity.script.partyOnWakeUp(self)
            end
        }
    }
}

