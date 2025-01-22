function openGroundLevelTeleporter()
    gate_tp_ground_level.door:open()
end

function tick()
    -- seems like an oofline tick is roughly between 41 and 44 seconds
    hudPrint(tostring(Time.systemTime()) .. " - " .. tostring(Time.currentTime()))
end

function cloudVision()
    cloister_sky.sky:setFogMode("dense")
    cloister_sky.sky:setFogRange({1,2})
    --cloister_sky.fogparticles:setOpacity(255)
    --cloister_sky.fogparticles:setParticleSize(100)
end