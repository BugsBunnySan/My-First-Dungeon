function openGroundLevelTeleporter()
    gate_tp_ground_level.door:open()
end

function tick()
    -- seems like an oofline tick is roughly between 41 and 44 seconds
    hudPrint(tostring(Time.systemTime()))
end