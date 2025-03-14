pushblock_triggers = {["floor_trigger_22"] = {"pushable_block_floor_11", "pushable_block_floor_12"},
                      ["floor_trigger_23"] = {"pushable_block_floor_11", "pushable_block_floor_12", "pushable_block_floor_13"},
                      ["floor_trigger_24"] = {"pushable_block_floor_12", "pushable_block_floor_13", "pushable_block_floor_14"},
                      ["floor_trigger_25"] = {"pushable_block_floor_13", "pushable_block_floor_14", "pushable_block_floor_15"},
                      ["floor_trigger_26"] = {"pushable_block_floor_14", "pushable_block_floor_15"},
                      ["floor_trigger_27"] = {"pushable_block_floor_11", "pushable_block_floor_12"},
                      ["pushable_block_floor_trigger_1"] = {"pushable_block_floor_13"},
                      ["pushable_block_floor_trigger_2"] = {"pushable_block_floor_14"},
                      ["pushable_block_floor_trigger_3"] = {"pushable_block_floor_15"},
                      ["pushable_block_floor_trigger_4"] = {"pushable_block_floor_16"}}

pushblock_floor_triggered = {}

function finish_lite_up_pushblock_floor(time_delta, animation)
    local push_block_floor = findEntity(animation.push_block_floor)
    push_block_floor.controller:activate()
end

function lite_up_pushblock_floor(time_delta, animation)
    local brightness = (animation.elapsed / animation.duration) * animation.light_level    
    local push_block_floor = findEntity(animation.push_block_floor)
    push_block_floor.light:setBrightness(brightness)    
    if brightness >= animation.light_level / 2 then
        push_block_floor.particle:enable()
    end
end

function liteUpPushblockFloorAnimation(trigger)
    for _,pushable_block_floor_id in ipairs(pushblock_triggers[trigger.go.id]) do
        if pushblock_floor_triggered[pushable_block_floor_id] == nil then
            pushblock_floor_triggered[pushable_block_floor_id] = true
            local push_block_floor = findEntity(pushable_block_floor_id)
            trigger:disable()
            push_block_floor.light:setBrightness(0)
            push_block_floor.light:enable()
            local animation = {func=lite_up_pushblock_floor, on_finish=finish_lite_up_pushblock_floor, step=0.05, duration=2, elapsed=0, last_called=-1, push_block_floor=pushable_block_floor_id, light_level=35}
            global_scripts.script.add_animation(trigger.go.level, animation)
            global_scripts.script.playSoundAtObject("charge_up", push_block_floor)
        end
    end
end

function ladderFloorTrigger(trigger)
    print("triggered")
    party:setPosition(spawn_test.x, spawn_test.y, spawn_test.facing, spawn_test.elevation, spawn_test.level)
    party.party:move(party.facing)
    --local w_pos = spawn_test:getWorldPosition()
    --party:setWorldPosition(w_pos)
    --party:setWorldPositionY(w_pos.y)
end

function init()
    --spawn_test:spawn("forest_ground_01"):destroyDelayed()
   --spawn("mine_pit", spawn_test.levet, spawn_test.x, spawn_test.y, spawn_test.facing, spawn_test.elevation)    
end

morning = 0
noon = 0.5
evening = 1
midnight = 1.5
maxtime = 1.99 -- this then becomes morning
onehour = 0.0833333

time_of_day = GameMode.getTimeOfDay()--1.5
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
    global_scripts.script.add_animation(forest_script_entity.level, animation)
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
    global_scripts.script.add_animation(forest_script_entity.level, animation)
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
    global_scripts.script.add_animation(forest_script_entity.level, animation)
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
    global_scripts.script.add_animation(forest_script_entity.level, animation)
end