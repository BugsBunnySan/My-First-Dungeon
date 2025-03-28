champion_condition_levels = {[1] = {}, [2] = {}, [3] = {}, [4] = {}}
           
function setConditionLevel(champion_ordinal, condition, level)
    champion_condition_levels[champion_ordinal][condition] = level
end

function getConditionLevel(champion_ordinal, condition)
    return champion_condition_levels[champion_ordinal][condition]
end

function clearConditionLevel(champion_ordinal, condition)
    champion_condition_levels[champion_ordinal][condition] = nil
end

-- paladin aura
paladin = {champion_ordinal = -1,
           shared_protection = 0,
           shared_evasion = 0}

-- cleric spells

function heal_champions(caster, target_champions, x, y, direction, elevation, divine_skill_level)
    for _, target_champion in ipairs(target_champions) do
        target_champion:playHealingIndicator()
        target_champion:regainHealth(10*divine_skill_level) 
    end
    
    return true
end

function keen_champions(caster, target_champions, x, y, direction, elevation, divine_skill_level)
    for _, target_champion in ipairs(target_champions) do
        local target_champion_ordinal = target_champion:getOrdinal()
        setConditionLevel(target_champion_ordinal, "added_damage", divine_skill_level)        
        target_champion:setConditionValue("added_damage", divine_skill_level*10)    
    end

    return true
end

function regen_champions(caster, target_champions, x, y, direction, elevation, divine_skill_level)
    for _, target_champion in ipairs(target_champions) do
        local target_champion_ordinal = target_champion:getOrdinal()
        setConditionLevel(target_champion_ordinal, "divine_regeneration", divine_skill_level)
        target_champion:setConditionValue("divine_regeneration", divine_skill_level*10)
    end
end

function reset_cooldowns(caster, target_champions, x, y, direction, elevation, divine_skill_level)
    for _, target_champion in ipairs(target_champions) do
        
    end
end

cleric_spells = {[125] = {target_champion_idxs = {1}, spell_func={cleric_shield = heal_champions, cleric_sword = keen_champions}},
                 [325] = {target_champion_idxs = {2}, spell_func={cleric_shield = heal_champions, cleric_sword = keen_champions}},
                 [587] = {target_champion_idxs = {3}, spell_func={cleric_shield = heal_champions, cleric_sword = keen_champions}},
                 [589] = {target_champion_idxs = {4}, spell_func={cleric_shield = heal_champions, cleric_sword = keen_champions}},
                 [5] = {target_champion_idxs = {1,2,3,4}, spell_func={cleric_shield = regen_champions, cleric_sword = reset_cooldowns}}
                 }



function castClericSpell(gesture, champion, x, y, direction, elevation, skillLevel)    
    if not (champion:hasTrait("cleric_shield") or champion:hasTrait("cleric_sword")) then
        return false
    end
    
    local divine_skill_level = champion:getSkillLevel("divine_magic")
    local target_champions = {}
    for _, target_champion_idx in ipairs(cleric_spells[gesture].target_champion_idxs) do
        local target_champion = party.party:getChampion(target_champion_idx)
        table.insert(target_champions, target_champion)
    end
    
    if champion:hasTrait("cleric_shield") then
        local spell = cleric_spells[gesture].spell_func["cleric_shield"]
        if spell ~= nil then
            return spell(champion, target_champions, x, y, direction, elevation, divine_skill_level)
        else
            return false
        end
    elseif champion:hasTrait("cleric_sword") then
        local spell = cleric_spells[gesture].spell_func["cleric_sword"]
        if spell ~= nil then
            return spell(champion, target_champions, x, y, direction, elevation, divine_skill_level)
        else
            return false
        end
    else
        return false
    end    
end