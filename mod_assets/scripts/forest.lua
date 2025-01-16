morning = 0
noon = 0.5
evening = 1
midnight = 1.5
maxtime = 1.99 -- this then becomes morning
onehour = 1/12

time_of_day = 0
keep_time_of_day = true

step = 0.05
tick = 0.1

time_control_levers = {"beach_lever_1", "beach_lever_2", "beach_lever_3", "beach_lever_4"}

function enable_buttons()
    for _, lever_id in ipairs(time_control_levers) do
        local lever = findEntity(lever_id)
        if lever.lever:isActivated() then
            lever.lever:setState("deactivated")
            global_scripts.script.playSoundAtObject("lever", lever)
        end
        lever.clickable:enable()
        lever.lever:enable()
    end
end

function disable_buttons()
    for _, lever_id in ipairs(time_control_levers) do
        local lever = findEntity(lever_id)
        lever.clickable:disable()
        lever.lever:disable()
    end
end

function keepTOD()
    if keep_time_of_day then
        GameMode.setTimeOfDay(time_of_day)
    end
end

function moveTOD(time_delta, animation)
    local now = GameMode.getTimeOfDay()
    local set_time = now + (tick * (time_delta))
    GameMode.setTimeOfDay(set_time)
end

function setTOD(time_delta, animation)
    GameMode.setTimeOfDay(animation.targetTime)
    time_of_day = GameMode.getTimeOfDay()
    keep_time_of_day = true
    enable_buttons()
end

forest_animation = {}

function forest_add_animation(animation)
    table.insert(forest_animation, animation)
end

last_tick = -1

function forestAnimateTick()
    local now = Time.systemTime()
    if last_tick == -1 then
        last_tick = now
    end
    local tick_delta = now - last_tick    
    for idx, animation in ipairs(forest_animation) do        
        if animation.last_called == -1 or animation.last_called > now then
            animation.last_called = now
        end                
        animation.elapsed = animation.elapsed + tick_delta        
        local time_delta = now - animation.last_called    
        if animation.elapsed >= animation.duration then
            if animation.on_finish ~= nil then
                animation.on_finish(time_delta, animation)
            end
            table.remove(forest_animation, idx)                          
        elseif time_delta >= animation.step then            
            animation.func(time_delta, animation)
            animation.last_called = now
        end                
    end
    last_tick = now
end

function goTilMorning()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now ~= morning then
        duration = (maxtime - now) / tick-- rollover is at morning
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=maxtime, tick=tick}
    forest_add_animation(animation)
end

function goTilNoon()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now >= noon then
        duration = ((maxtime - now) + noon) / tick
    elseif now <= noon then
        duration = (noon - now) / tick
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=noon, tick=tick}
    forest_add_animation(animation)
end

function goTilEvening()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now >= evening then
        duration = ((maxtime - now) + evening) / tick
    elseif now <= evening then
        duration = (evening - now) / tick
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=evening, tick=tick}
    forest_add_animation(animation)
end

function goTilMidnight()
    keep_time_of_day = false
    disable_buttons()
    local now = GameMode.getTimeOfDay()
    local duration  = 0
    if now >= midnight then
        duration = ((maxtime - now) + midnight) / tick
    elseif now <= midnight then
        duration = (midnight - now) / tick
    else
        keep_time_of_day = true
        enable_buttons()
        return
    end
    
    local animation = {func=moveTOD, on_finish=setTOD, step=step, duration=duration, elapsed=0, last_called=-1, targetTime=midnight, tick=tick}
    forest_add_animation(animation)
end