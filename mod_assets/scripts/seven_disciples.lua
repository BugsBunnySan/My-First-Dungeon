function wakeupDisciples()
    for i=1,7 do
        local disciple = findEntity("water_disciple_"..i)
        if disciple ~= nil then -- the party might have already destroyed the fake disciple
            disciple.eyesModel:enable()
            disciple.leftEyeLight:enable()
            disciple.leftEyeLight:setBrightness(50)
            disciple.rightEyeLight:enable()
            disciple.rightEyeLight:setBrightness(50)
        end
    end
end

function set_state(state)
    sage_of_water_quest.state = state
end

function set_auto_inserting(state)
    sage_of_water_quest.auto_inserting = state
end

sage_of_water_messages = {["give_task"] = "One of my disciples has lost their way, no longer does he reflect as is proper\nDeal with them and be rewarded.\nRemember what one of the elders said:\n",
                          ["foolish"]   = "To the foolish, a single word of wisdom is like a trsunami",
                          ["wise"]      = "To the very wise, words of wisdom are like drops of water in the ocean",
                          ["essence"]   = "Water is fluid, soft, and yielding.\nBut water will wear away rock, whih is rigid and cannot yield.\nAs a rule, whatever is fluid, soft, and yielding\n will overcome whatever  is rigid and hard."}

sage_of_water_quest = {
    state = "initial",
    auto_inserting = false,
    words_of_wisdom = {"Be like water making its way through cracks. Do not be assertive, but adjust to the object, and you shall find a way around or through it.", sage_of_water_messages["essence"], "Be water, my friend."},
    state_table = {
        ["initial"] = {
            ["flask"] = {
                ["action"] = function(self, item)
                                 item.go:destroyDelayed()
                                 local water_flask = spawn("water_flask").item
                                 self.auto_inserting = true
                                 self:addItem(water_flask)                                              
                                 water_disciple_5.walltrigger:enable()    
                                 sage_of_water_1_text.walltext:setWallText(sage_of_water_messages["give_task"] .. sage_of_water_messages["foolish"])
                            end,
                ["new_state"] = "given_task",
                ["message"] = sage_of_water_messages["give_task"] .. sage_of_water_messages["foolish"]
            },
            ["water_flask"] = {
                ["action"] = nil,
                ["new_state"] = "initial",
                ["message"] = sage_of_water_messages["wise"]
            }
        },
        ["given_task"] = {
            ["flask"] = {
                ["action"] = function(self, item)
                                 item.go:destroyDelayed()
                                 local water_flask = spawn("water_flask").item
                                 self.auto_inserting = true
                                 self:addItem(water_flask) 
                            end,
                ["new_state"] = "given_task",
                ["message"] = "Remember:\n" .. sage_of_water_messages["foolish"]
            },
            ["water_flask"] = {
                ["action"] = nil,
                ["new_state"] = "given_task",
                ["message"] = sage_of_water_messages["wise"]
            },
            ["essence_water"] = {
                ["action"] = function(self, item)
                    sage_of_water_1_text.walltext:setWallText(sage_of_water_messages["essence"])
                end,
                ["new_state"] = "task_complete",
                ["message"] = nil
            }
        },
        ["task_complete"] = {
            ["flask"] = {
                ["action"] = function(self, item)
                                 item.go:destroyDelayed()
                                 local water_flask = spawn("water_flask").item
                                 self.auto_inserting = true
                                 self:addItem(water_flask)
                                 local i = math.random(#sage_of_water_quest.words_of_wisdom)
                                 local message = sage_of_water_quest.words_of_wisdom[i]
                                 sage_of_water_1_text.walltext:setWallText(message)
                                 hudPrint(message)
                            end,
                ["new_state"] = "task_complete",
                ["message"] = nil
            },
            ["water_flask"] = {
                ["action"] = nil,
                ["new_state"] = "task_complete",
                ["message"] = "To the very wise, words of wisdom are like drops of water in the ocean"
            }                        
        }
    }
}