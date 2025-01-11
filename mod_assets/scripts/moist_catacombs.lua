moist_animation = {}

function moist_add_animation(animation)
    table.insert(moist_animation, animation)
end

function startMoveLadder(ladder, lever, stop, delta_vec, delta_x, checkLadderStop)
    local animation = {func=moveLadder, on_finish=finishMoveLadder, step=0.1, duration=2, elapsed=0, last_called=-1, ladder=ladder.id, lever=lever.id, stop=stop.id}    
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

function moistAnimateTick()
    local now = Time.systemTime()
    for idx, animation in ipairs(moist_animation) do        
        if animation.last_called == -1 or animation.last_called > now then
            animation.last_called = now
        end        
        local time_delta = now - animation.last_called        
        animation.elapsed = animation.elapsed + time_delta
        if animation.last_called + animation.step >= now then
            animation.func(time_delta, animation)
        end        
        if animation.elapsed >= animation.duration then
            if animation.on_finish ~= nil then
                animation.on_finish(time_delta, animation)
            end
            table.remove(moist_animation, idx)
        else 
            animation.last_called = now                      
        end
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

