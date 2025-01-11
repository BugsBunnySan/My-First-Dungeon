sg_power_sequence = 1

function onAddItem(self, item)
    if item.go.name == "power_gem_item" then
        stargate_altar_forcefield.controller:activate()
        sg_power_timer.timer:setTimerInterval(1)
        sg_power_timer.timer:enable()
        sg_power_timer.timer:start()
    end
end



function powerUpStargate()    
    hudPrint(tostring(sg_power_sequence))
    if sg_power_sequence < 7 then        
        local sg_circuit = findEntity(string.format("sg_circuit_%d", tonumber(sg_power_sequence)))
        sg_circuit.controller:activate()
        global_scripts.script.playSoundAtObject("pushable_block_rise", sg_circuit)
    elseif sg_power_sequence == 7 then
        sg_portal_circuit.controller:activate()
        sg_gate.door:open()
        sg_crow.crowcontroller:enable()        
        global_scripts.script.playSoundAtObject("pushable_block_rise", sg_portal_circuit)
    elseif sg_power_sequence == 8 then
        for i=1,6 do
            local sg_lever = findEntity(string.format("sg_lever_%d", i))           
            sg_lever.clickable:enable()
            sg_lever.lever:enable()
        end
        sg_power_timer.timer:stop()
    end
    sg_power_sequence = sg_power_sequence + 1
end

function chevronToggle(self)
    local nr = self.go.id:match("%d$")
    local sg_circuit = findEntity(string.format("sg_circuit_%d", tonumber(nr)))
    local sg_circuit_lit = findEntity(string.format("sg_circuit_lit_%d", tonumber(nr)))
    if self:isActivated() then
        sg_circuit.controller:deactivate()
        sg_circuit_lit.controller:activate()
    end
    if self:isDeactivated() then
        sg_circuit.controller:activate()
        sg_circuit_lit.controller:deactivate()
    end
    check_address()
end

stargate_addresses = {["XOOOXO"] = {level = 1, x = 11, y = 25, elevation = 0, facing=1, destination_gate="portal_1", destination_teleporter="portal_teleporter"}, -- beach dungeon/former mines
                      ["XOXXOX"] = {level = 5, x = 14, y = 8, elevation = 0, facing=1, destination_gate="cloister_portal", destination_teleporter="cloister_teleporter"}, -- cloister
                      ["OXOOXX"] = {level = 4, x = 5, y = 28, elevation = 0, facing=1, destination_gate="moist_portal", destination_teleporter="moist_teleporter"}, -- moist catacombs
                      ["XXXXXX"] = {level = 3, x = 4, y = 21, elevation = 0, facing=0, destination_gate=nil, destination_teleporter=nil}} -- castle of water
stargate_last_coordinates = {}

function deactivate_coordinates(coordinates)
    sg_teleporter.controller:deactivate()
    global_scripts.script.deactivatePortal(sg_portal)       
    if coordinates.destination_gate ~= nil then
        global_scripts.script.deactivatePortal(findEntity(coordinates.destination_gate))
    end
    if coordinates.destination_teleporter ~= nil then
        findEntity(coordinates.destination_teleporter).controller:deactivate()    
    end    
end

function activate_coordinates(coordinates)
    sg_teleporter.teleporter:setTeleportTarget(coordinates.level, coordinates.x, coordinates.y, coordinates.elevation) 
    sg_teleporter.teleporter:setSpin(global_scripts.script.facing_names[coordinates.facing])
    sg_teleporter.controller:activate()                
    global_scripts.script.activatePortal(sg_portal)        
    sg_gate:spawn("frostburst")
            
    if coordinates.destination_teleporter ~= nil then        
        local teleporter = findEntity(coordinates.destination_teleporter)        
        teleporter.teleporter:setTeleportTarget(sg_exit.level, sg_exit.x, sg_exit.y, sg_exit.elevation)
        teleporter.teleporter:setSpin(global_scripts.script.facing_names[sg_exit.facing])
        teleporter.controller:activate()
    end
    if coordinates.destination_gate ~= nil then
        local gate = findEntity(coordinates.destination_gate)        
        global_scripts.script.activatePortal(gate)
    end
end

function check_address()
    local address = ""
    for i=1,6 do
        local lever = findEntity(string.format("sg_lever_%d", tonumber(i)))
        if lever.lever:isActivated() then
            address = address.."X"
        else
            address = address.."O"
        end
    end
    hudPrint(address)
    local coordinates = stargate_addresses[address]
    if coordinates ~= nil then
        deactivate_coordinates(stargate_last_coordinates)
        activate_coordinates(coordinates)
        stargate_last_coordinates = coordinates
    else 
        deactivate_coordinates(stargate_last_coordinates)
    end
end