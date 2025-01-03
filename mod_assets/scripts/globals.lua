
rubble_pedestals = {["rubble_pedestal_2"] = {["rubble"] = {"rubble_2"},
                                            ["kin"] = {"rubble_pedestal_1"},
                                            ["food"] = 250,
                                            ["xp"] = 100},
                    ["rubble_pedestal_1"] = {["rubble"] = {"rubble_1"},
                                            ["kin"] = {"rubble_pedestal_2"},
                                            ["food"] = 250,
                                            ["xp"] = 100}
                   }

function clearRubble(pedestal, item)
    if item ~= nil and item.go.name ~= "pickaxe" then
        return
    end
    if pedestal.go ~= nil then
        pedestal = pedestal.go
    end
    for _, rubble_n in ipairs(rubble_pedestals[pedestal.id]["rubble"]) do
        local rubble = findEntity(rubble_n)
        playSound("mining")
        rubble:destroyDelayed()
    end
    if item ~= nil then
        spawn(item.go.name, item.go.level, item.go.x, item.go.y, item.go.facing, item.go.elevation)
        item.go:destroyDelayed()        
        for _, kin_n in ipairs(rubble_pedestals[pedestal.id]["kin"]) do            
            local kin = findEntity(kin_n)            
            clearRubble(kin, nil)
        end
    end
    party_consume_food({1, 2, 3, 4}, rubble_pedestals[pedestal.id]["food"])
    party_gain_xp({1, 2, 3, 4}, rubble_pedestals[pedestal.id]["xp"])    
    pedestal:destroyDelayed()
end

function party_consume_food(champions, amount)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:consumeFood(amount)
        end
    end
end

function party_gain_xp(champions, amount)
    for _, i in ipairs(champions) do
        local champion = party.party:getChampion(i)
        if champion ~= nil then
            champion:gainExp(amount)
        end
    end
end

function shootProjectile(projectile, ref_object, facing, offset_x, offset_y, offset_elevation)
    if ref_object.go ~= nil then
        ref_object = ref_object.go
    end
    if facing == nil then
        facing = ref_object.facing
    end
    local x = ref_object.x
    local y = ref_object.y
    local elevation = ref_object.elevation
    if offset_x ~= nil then
        x = x + offset_x
    end
    if offset_y ~= nil then
        y = y + offset_y
    end
    if offset_elevation ~= nil then
        elevation = elevation + offset_elevation
    end
    spawn(projectile, ref_object.level, x, y, facing, elevation)
end

function playSoundAtObject(sound, ref_object)
     if ref_object.go ~= nil then
        ref_object = ref_object.go
    end
    playSoundAt(sound, ref_object.level, ref_object.x, ref_object.y)
end