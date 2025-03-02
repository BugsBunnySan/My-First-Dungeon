function checkEntrance()
    local wearing_champions = global_scripts.script.party_wears_item({1, 2, 3, 4}, ItemSlot.Necklace, "runestone_necklace")    
    if wearing_champions.count > 0 then
        grantEntrance()
    else
        denyEntrance()
    end
end

function grantEntrance()
    medusa_left.brain:disable()
    medusa_right.brain:disable()
    main_gate.door:open()
end

function denyEntrance()
    medusa_left.brain:enable()
    medusa_right.brain:enable()
    main_gate.door:close()    
    back_gate.door:close()
    back_gate_timer.timer:start()
end

function openBackGate()   
    back_gate.door:open()
    back_gate_timer.timer:stop()    
    medusa_left.brain:disable()
    medusa_right.brain:disable()
end

function raiseObject(object, amount)
    local w_pos = object:getWorldPosition()
    w_pos = w_pos + amount
    object:setWorldPosition(w_pos)
    return w_pos
end

function raisePlants()
    local w_pos
    for i=1,8 do
        local plant = findEntity(string.format("forest_plant_cluster_01_%d", i))
        w_pos = raiseObject(plant, vec(0, math.random()*global_scripts.script.herbs_raise_step, 0))        
    end
    if w_pos.y >= global_scripts.script.herbs_to_raise then
        herb_raiser_timer.timer:disable()
        forest_statue_pillar_03_1.model.go:spawn("blob")
        forest_statue_pillar_02_1.model.go:spawn("blob")
    end
end

function activateEarthAltar(altar, item)
    if item.go.name == "essence_earth" then
        herb_raiser_timer.timer:start()
        herb_timer.timer:start()
        spawnHerb()
        last_herb_spawn = Time.systemTime()
    end
end

last_herb_spawn = 0
herb_spawn_interval = 59
herb_spawn_timer_onsite = 30
herb_spawn_timer_offsite = 0.5-- timers run approximately 41-45 or even more times slower on levels the party is not on, depending on factors unknown

function onExitLevel()
    local interval = herb_timer.timer:getTimerInterval(0)    
    if interval > herb_spawn_timer_offsite then
        herb_timer.timer:setTimerInterval(herb_spawn_timer_offsite)
    end
end

function onEnterLevel()
    local interval = herb_timer.timer:getTimerInterval(0)
    if interval < herb_spawn_timer_onsite then
        herb_timer.timer:setTimerInterval(herb_spawn_timer_onsite)
    end
end

function maybeSpawnHerb()
    local now = Time.systemTime()
    if now - last_herb_spawn > herb_spawn_interval then
        hudPrint("Spawn Herb after "..tostring(now - last_herb_spawn).." seconds")
        spawnHerb()
        last_herb_spawn = now
    end
end

function spawnHerb()
    local herb_garden = {herb_garden_1, herb_garden_2, herb_garden_3, herb_garden_4, 
                         herb_garden_5, herb_garden_6, herb_garden_7, herb_garden_8}                      
    local herbs = {"blackmoss", "blooddrop_cap", "etherweed", "falconskyre", "mudwort"}
    local herbs_max_spawn = {["blackmoss"] = 6,
                            ["blooddrop_cap"] = 6,
                            ["etherweed"] = 6,
                            ["falconskyre"] = 6,
                            ["mudwort"] = 6}                           
                            
    local herb_index = math.random(#herbs)
    local herb = herbs[herb_index]    
    local existing_herbs = global_scripts.script.findEntities(herb.name, herb_spawn_ref.level)
    if #existing_herbs < herbs_max_spawn[herb] then
        herb_garden = global_scripts.script.shuffle(herb_garden)
        local garden_tile = global_scripts.script.findEmptySpot(herb_garden, herbs_max_spawn, true)
        if garden_tile.x ~= nil then
            spawn(herb, garden_tile.level, garden_tile.x, garden_tile.y, garden_tile.facing, garden_tile.elevation)
        end
    end
end

function init()
    herb_timer.timer:disable()
    herb_raiser_timer.timer:disable()
    --main_gate.door:setOpenVelocity(0.1)
end