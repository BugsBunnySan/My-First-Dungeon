function wakeupDisciples()
    for i=1,7 do
        local disciple = findEntity("water_disciple_"..i)  
        disciple.eyesModel:enable()
        disciple.leftEyeLight:enable()
        disciple.leftEyeLight:setBrightness(50)
        disciple.rightEyeLight:enable()
        disciple.rightEyeLight:setBrightness(50)
    end
    
end
    