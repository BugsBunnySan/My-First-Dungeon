
state = "initial"
states = {["initial"] = {["blooddrop_cap"] = {func = count_farming, next_state = "rat_plague", count = 5}},
          ["rat_plague"] = {["burrow_rat_shank"] = {func = rats_defeated, next_state = "bandits"}},
          ["bandits"] = {["spiked_club"] = {func = start_journey, next_state = "init_journey"}}}

function start_journey(state_data)
    return state_data.next_state
end

function rats_defeated(state_data)
    return state_data.next_state
end

function count_farming(state_data)
    state_data.count = state_data.count - 1
    if state_data.count == 0 then
        return state_data.next_state
    else
        return state
    end
end

function onPutItem(surface, item)
    hudPrint(item.go.name)
    hudPrint(tostring(surface:count()))
    local state_data = states[state][item.go.name]
    next_state = state_data.func(state_data)
end