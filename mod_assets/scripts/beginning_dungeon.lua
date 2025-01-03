function leverBreaks()
    global_scripts.script.playSoundAtObject("cage_rattle", blob_door_lever.model)
    blob_door_lever.lever:disable()
    blob_door_lever.clickable:disable()
    spawn("gear_necklace", blob_door_lever.model.go.level, blob_door_lever.model.go.x, blob_door_lever.model.go.y, 3, -1)
end

function safetyGateLeverBreaks()
    global_scripts.script.playSoundAtObject("cage_rattle", safety_gate_lever.model)
    safety_gate_lever.lever:disable()
    safety_gate_lever.clickable:disable()
    spawn("neck_chain", safety_gate_lever.model.go.level, safety_gate_lever.model.go.x, safety_gate_lever.model.go.y, 0, -1)
end

function activateSafetyGateLever()
    safety_gate_lever.lever:enable()
    safety_gate_lever.clickable:enable()
end

function closeSafetyGate()
    safety_gate.door:close()
    safety_gate_2.door:close()
end

function maybeActivateFloor()
    local active_time = math.random(5)   
    timer_1.timer:setTimerInterval(active_time)
    pushable_block_floor_1.controller:activate()
    timer_1.timer:start()
end

function deactivateFloor()
    pushable_block_floor_1.controller:deactivate()
    global_scripts.script.playSoundAtObject("lightning_bolt_hit_small", pushable_block_floor_1.model)
end

function shootProjectile()
    if pushable_block_floor_1.light:isEnabled() and safety_gate.door:isClosed() then
        global_scripts.script.shootProjectile("lightning_bolt", mine_spell_launcher_support_1, 2)
    end
end

function activateReceptorFloor()
    local active_time = math.random(5)   
    timer_2.timer:setTimerInterval(active_time)
    pushable_block_floor_2.controller:activate() 
    pushable_block_floor_3.controller:activate()    
    pushable_block_floor_4.controller:activate()
    timer_2.timer:start()    
end

function deactivateReceptorFloor()
    pushable_block_floor_2.controller:deactivate() 
    pushable_block_floor_3.controller:deactivate()    
    pushable_block_floor_4.controller:deactivate()
    global_scripts.script.playSoundAtObject("lightning_bolt_hit_small", pushable_block_floor_2.model)
end

function activatePortal()
    local active_time = math.random(5)   
    timer_3.timer:setTimerInterval(active_time)
    portal_1.light:enable()
    portal_1.particle:enable()
    portal_1.particle2:enable()
    portal_1.portalBeam:enable()
    portal_1.planeModel:enable()
    pushable_block_floor_5.controller:activate()
    portal_teleporter.controller:activate()
    timer_3.timer:start()    
end

function deactivatePortal()
    portal_1.light:disable()
    portal_1.particle:disable()
    portal_1.particle2:disable()
    portal_1.portalBeam:disable()
    portal_1.planeModel:disable()
    pushable_block_floor_5.controller:deactivate()
    portal_teleporter.controller:deactivate()    
    global_scripts.script.playSoundAtObject("lightning_bolt_hit_small", pushable_block_floor_2.model)
end