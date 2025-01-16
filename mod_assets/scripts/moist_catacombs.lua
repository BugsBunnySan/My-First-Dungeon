moist_animation = {}

function moist_add_animation(animation)    
    table.insert(moist_animation, animation)
end

function startMoveLadder(ladder, lever, stop, delta_vec, delta_x, checkLadderStop)
    local animation = {func=moveLadder, on_finish=finishMoveLadder, step=0.005, duration=2, elapsed=0, last_called=-1, ladder=ladder.id, lever=lever.id, stop=stop.id}    
    local start_pos = ladder:getWorldPosition()
    local stop_pos = start_pos + delta_vec
    animation.start_pos = {x=start_pos.x, y=start_pos.y, z=start_pos.z}
    animation.stop_pos = {x=stop_pos.x ,y=stop_pos.y, z=stop_pos.z}
    if checkLadderStop(animation) then    
       global_scripts.script.playSoundAtObject("lever", lever)
       lever.lever:setState("deactivated")
       return
    end
    -- stop_pos is where the ladder should end up at the end of the animation (used for calculating how far to move it each animation frame)
    -- on_finish_pos is an in map integer position where the ladder is snapped to when the animation time is over, to ensure that no rounding errors or timing issues, etc...
    -- make the ladder end up in weird positions over the course of moving it lots      
    animation.on_finish_pos = {x=ladder.x+delta_x, y=ladder.y, facing=ladder.facing, elevation=ladder.elevation, level=ladder.level}
    lever.lever:disable()
    lever.clickable:disable()
    ladder.clickable:disable()
    ladder.ladder:disable()
    moist_add_animation(animation)
    global_scripts.script.playSoundAtObject("gate_iron_open", ladder)
end

function checkLadderStopWest(animation)
    local stop = findEntity(animation.stop)
    return animation.start_pos.x <= stop:getWorldPosition().x
end

function checkLadderStopEast(animation)
    local stop = findEntity(animation.stop)
    return animation.start_pos.x >= stop:getWorldPosition().x
end

function startMoveSouthLadderWest()
    startMoveLadder(moist_ladder_south, moist_lever_south_west, moist_south_ladder_stop_west, vec(-3, 0, 0), -1, checkLadderStopWest)   
end

function startMoveSouthLadderEast()
    startMoveLadder(moist_ladder_south, moist_lever_south_east, moist_south_ladder_stop_east, vec(3, 0, 0), 1, checkLadderStopEast) 
end

function startMoveNorthLadderWest()
    startMoveLadder(moist_ladder_north, moist_lever_north_west, moist_north_ladder_stop_west, vec(-3, 0, 0), -1, checkLadderStopWest)
end

function startMoveNorthLadderEast()
    startMoveLadder(moist_ladder_north, moist_lever_north_east, moist_north_ladder_stop_east, vec(3, 0, 0), 1, checkLadderStopEast)
end

function moveLadder(time_delta, animation)
    local ladder = findEntity(animation.ladder)
    local percentage = animation.duration / animation.elapsed
    local start_pos = vec(animation.start_pos.x, animation.start_pos.y, animation.start_pos.z)
    local stop_pos = vec(animation.stop_pos.x, animation.stop_pos.y, animation.stop_pos.z)
    local w_pos = ((stop_pos - start_pos) / percentage) + start_pos
    ladder:setWorldPosition(w_pos)
end

function finishMoveLadder(time_delta, animation)
    local ladder = findEntity(animation.ladder)
    local lever = findEntity(animation.lever)
    ladder:setPosition(animation.on_finish_pos.x, animation.on_finish_pos.y, animation.on_finish_pos.facing, animation.on_finish_pos.elevation, animation.on_finish_pos.level)
    global_scripts.script.playSoundAtObject("lever", lever)
    lever.lever:setState("deactivated")
    lever.lever:enable()
    lever.clickable:enable()
    ladder.clickable:enable()
    ladder.ladder:enable()
    global_scripts.script.playSoundAtObject("pressure_plate_pressed", ladder)    
end

last_tick = -1

function moistAnimateTick()
    local now = Time.systemTime()
    if last_tick == -1 then
        last_tick = now
    end
    local tick_delta = now - last_tick    
    for idx, animation in ipairs(moist_animation) do        
        if animation.last_called == -1 or animation.last_called > now then
            animation.last_called = now
        end                
        animation.elapsed = animation.elapsed + tick_delta        
        local time_delta = now - animation.last_called    
        if animation.elapsed >= animation.duration then
            if animation.on_finish ~= nil then
                animation.on_finish(time_delta, animation)
            end
            table.remove(moist_animation, idx)                          
        elseif time_delta >= animation.step then            
            animation.func(time_delta, animation)
            animation.last_called = now
        end                
    end
    last_tick = now
end

-- the purpo0se of the following quest is that each family has 5 really good people that got their
-- gifts stolen by someone or lost them... Giving them their gifts back angers the evil people from
-- the opposing side. So giving all the gifts back to one side summons the angry evil ghosts from
-- the opposing side. Upon defeating them, their evil influence on their families legacy and the world
-- and the field holding back the young lovers is removed

-- this tracks how many gifts need to still be given
red_gem_gifts = {
    sylar = { ll1 = { red_gem = 2},
              uu3 = { red_gem = 1},
              lu5 = { red_gem = 1},
              ul7 = { red_gem = 1},
              ul11 = { red_gem = 1}},
    carals = { uu2 = {red_gem = 1},
               uu5 = {red_gem = 1},
               uu7 = {red_gem = 1},
               uu9 = {red_gem = 1},
               uu12 = {red_gem = 1}}
}

ared_gem_gifts = {
    sylar = { ll1 = { red_gem = 1}},
    carals = { ll6 = {red_gem = 1}}
}

red_gem_sounds = {
    sylar = {},
    carals = {}
}

red_gem_gifts_given = {
    sylar = false,
    carals = false
}

spawns = {
    sylar = {  sylar_spawn_1  = "green_slime",
               sylar_spawn_2  = nil,
               sylar_spawn_3  = "giant_snake",
               sylar_spawn_4  = "spider_walker",
               sylar_spawn_5  = nil,
               sylar_spawn_6  = "giant_snake",
               sylar_spawn_7  = "dark_acolyte",
               sylar_spawn_8  = "giant_snake",
               sylar_spawn_9  = "green_slime",
               sylar_spawn_10 = "giant_snake",
               sylar_spawn_11 = "spider_walker",
               sylar_spawn_12 = nil, },
    carals = { carals_spawn_1  = "skeleton_trooper",
               carals_spawn_2  = "skeleton_trooper",
               carals_spawn_3  = "skeleton_trooper",
               carals_spawn_4  = "skeleton_archer",
               carals_spawn_5  = "skeleton_archer",
               carals_spawn_6  = "skeleton_commander",
               carals_spawn_7  = "skeleton_trooper",
               carals_spawn_8  = "skeleton_trooper",
               carals_spawn_9  = "skeleton_trooper",
               carals_spawn_10 = "skeleton_archer",
               carals_spawn_11 = "skeleton_archer",
               carals_spawn_12 = "skeleton_trooper",
    }
}

-- these count down the ghosts existing (synced to table above)
sylar_ghosts_destroyed = 9
carals_ghosts_destroyed = 12

function get_opposing_clan(clan)
    local opposing_clan = nil
    if clan == "sylar" then
        opposing_clan = "carals"
    elseif clan == "carals" then
        opposing_clan = "sylar"
    end
    return opposing_clan
end

function check_clan_gifts(clan)
    local all_gifts_given = true
    for alcove, gifts_needed in pairs(red_gem_gifts[clan]) do
        for gift, needed in pairs(gifts_needed) do
            all_gifts_given = all_gifts_given and (needed == 0)
            if not all_gifts_given then
                return false
            end
        end
    end
    return all_gifts_given
end

-- evil whispers stop
-- and their alcove callbacks are disconnected (this has to be done when there is no insert/remove item callback is running
-- so doing it here is probably the safest (there are flags stopping these callbacks also, removing these here
-- just means the callbacks aren't called as a small optimization)
function allClanGhostsDestroyed(clan, opposing_clan)
    for selector, sound_id in pairs(red_gem_sounds[clan]) do
        findEntity(sound_id).sound:fadeOut(2)
    end
    for selector, gifts in pairs(red_gem_gifts[opposing_clan]) do
        local alcove = findEntity(string.format("tomb_%s_%s", clan, selector))
        alcove.surface:removeConnector("onInsertItem", "moist_script_entity", "onInsertItemAlcove")
        alcove.surface:removeConnector("onRemoveItem", "moist_script_entity", "onRemoveItemAlcove")
    end
end

function caralsGhostDestroyed()
    carals_ghosts_destroyed = carals_ghosts_destroyed - 1
    if carals_ghosts_destroyed == 0 then
        allClanGhostsDestroyed("carals", "sylar")    
        hudPrint("Carals' evil ghosts are all destroyed. Their evil influence of jealosy, anger, bigotry and stuff like that has left their clan and the world.")
    end
end

function sylarGhostDestroyed()
    sylar_ghosts_destroyed = sylar_ghosts_destroyed - 1
    if sylar_ghosts_destroyed == 0 then
         allClanGhostsDestroyed("sylar", "carals")    
        hudPrint("Sylar's evil ghost is destroyed. Their evil influence of toxic bad stuff is gone from their clan and the world.")       
    end
end

function spawn_ghosts(clan)
    for i=1,12 do
        local spawn_name = string.format("%s_spawn_%d", clan, i)
        local spawner = findEntity(spawn_name)
        local spawn = spawns[clan][spawner.id]
        if spawn ~= nil then
            --hudPrint(spawner.id .. " going to spawn "..spawn)
            local entity = spawner:spawn(spawn)
            local func_name = string.format("%sGhostDestroyed", clan)
            entity.monster:addConnector("onDie", "moist_script_entity", func_name)
        end
    end
end

function lockGifts(clan)   
    for selector, gifts in pairs(red_gem_gifts[clan]) do
        local alcove = findEntity(string.format("tomb_%s_%s", clan, selector))
        for _, item in alcove.surface:contents() do
            if red_gem_gifts[clan][selector][item.go.name] ~= nil then
                item.go:destroyDelayed()
                red_gem_gifts[clan][selector][item.go.name] = nil
            end
        end
    end    
end

function allGiftsGiven(clan)
    hudPrint("Clan "..clan.." has all their gifts!")    
    if clan == "sylar" then
        red_gem_gifts_given["sylar"] = true
        lockGifts("sylar")
        spawn_ghosts("carals")        
        hudPrint("You Fools! You dare support our enemies?!?")
    elseif clan == "carals" then
        red_gem_gifts_given["carals"] = true
        lockGifts("carals")
        spawn_ghosts("sylar")        
        hudPrint("You Fools! You dare support my enemies?!?")
    end
end

function checkInsertItemAlcoveClan(alcove, clan, selector, item)
    if red_gem_gifts[clan][selector][item.go.name] == nil then
        return false
    end
    red_gem_gifts[clan][selector][item.go.name] = red_gem_gifts[clan][selector][item.go.name] - 1
    if red_gem_gifts[clan][selector][item.go.name] == 0 then       
        alcove.go.light:enable()
        local sound_clan = get_opposing_clan(clan)
        local sound = nil        
        if red_gem_sounds[sound_clan][selector] == nil then
            local sound_alcove = findEntity(string.format("tomb_%s_%s", sound_clan, selector))
            sound = sound_alcove:spawn("sound")            
            sound.sound:setSound("evil_whisper")                                       
            red_gem_sounds[sound_clan][selector] = sound.id
        else
            sound = findEntity(red_gem_sounds[sound_clan][selector])
        end
        sound.sound:fadeIn(2)
        return true
    end    
    return false
end

function onInsertItemAlcove(self, item)
    print(item.go.name .. " put into " .. tostring(self.go.id))        
    for clan, selector in (self.go.id):gmatch "tomb_(%a+)_(%a%a%d+)$" do
        if red_gem_gifts_given[clan] then
            return
        end
        checkInsertItemAlcoveClan(self, clan, selector, item)           
        if check_clan_gifts(clan) then
            allGiftsGiven(clan)
        end            
    end 
end

function checkRemoveItemAlcoveClan(alcove, clan, selector, item)
    if red_gem_gifts[clan][selector][item.go.name] == nil then
        return false
    end    
    red_gem_gifts[clan][selector][item.go.name] = red_gem_gifts[clan][selector][item.go.name] + 1
    if red_gem_gifts[clan][selector][item.go.name] > 0 then      
        alcove.go.light:disable()
        local sound_clan = get_opposing_clan(clan)
        findEntity(red_gem_sounds[sound_clan][selector]).sound:fadeOut(2)
        return true
    end    
    return false
end

function onRemoveItemAlcove(self, item)    
    print(item.go.name .. " removed from " .. tostring(self.go.id))     
    for clan, selector in (self.go.id):gmatch "tomb_(%a+)_(%a%a%d+)$" do        
        if red_gem_gifts_given[clan] then
            return
        end
        checkRemoveItemAlcoveClan(self, clan, selector, item)
    end
end

dungeon_dock_state = "inside" -- the party starts inside the dungeon
-- dungeonInSidePlate <-> dungeonSidePlate <-> dungeonOutSidePlate <-> dockInSidePlate <-> dockSidePlate <-> dockOutSidePlate

function dungeonInSidePlate()
    dungeon_dock_state = "dungeonInside"
end

function dungeonSidePlate()  
    dungeon_dock_state = "dungeonSide"
    forest_day_sky.ambient:disable()
end

function dungeonOutSidePlate()
    if dungeon_dock_state == "dockInside" then
        forest_day_sky.sky:disable()
        cemetery_sky.fogparticles:enable()
    end
    dungeon_dock_state = "dungeonOutside"
end

function dockInSidePlate()     
    if dungeon_dock_state == "dungeonOutside" then       
        forest_day_sky.ambient:enable()
        cemetery_sky.fogparticles:disable()
    else        
        cemetery_sky.sky:enable()
    end            
    forest_day_sky.light:disable()  
    dungeon_dock_state = "dockInside"    
end

function dockSidePlate()    
    if dungeon_dock_state == "dockOutside" then       
        cemetery_sky.sky:enable()
    end
    forest_day_sky.sky:enable()  
    forest_day_sky.light:enable()     
    dungeon_dock_state = "dockSide"  
end

function dockOutSidePlate()  
    cemetery_sky.sky:disable()   
    dungeon_dock_state = "dockOutside"
end

