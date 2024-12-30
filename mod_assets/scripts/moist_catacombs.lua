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