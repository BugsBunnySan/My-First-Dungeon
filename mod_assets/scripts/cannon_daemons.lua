
function initLevel()
    GameMode.setTimeOfDay(0.5)
    armCannon1(nil, true)
end

function armCannon1(self, initial)    
    cannon_daemon_1_light.light:enable()
    cannon_daemon_1_light.sound:enable()
    cannon_daemon_1_light.particle:enable()
    cannon_daemon_1_light.socket:enable()
    local torchCount = cannon_daemon_1_light.socket:count()            
    if torchCount == 0 then
        local torch = spawn("torch").item
        cannon_daemon_1_light.socket:addItem(torch)
    end
    cannon_daemon_1_light.controller:setHasTorch(true)
    cannon_daemon_1_pilot_light.controller:activate()
    if initial == nil then
        cannon_daemon_1.brain:performAction("manualAlert")     
        hudPrint("Security System Activated")  
    end
end

function disableCannon1(self)
    cannon_daemon_1_light.light:disable()
    cannon_daemon_1_light.sound:disable()
    cannon_daemon_1_light.particle:disable()
    local torchCount = cannon_daemon_1_light.socket:count()            
    if torchCount > 0 then
        local torch = cannon_daemon_1_light.socket:getItem()
        torch.go:destroyDelayed()
    end
    cannon_daemon_1_light.controller:setHasTorch(false)
    cannon_daemon_1_pilot_light.controller:deactivate()
    hudPrint("Security System Deactivated")
end

