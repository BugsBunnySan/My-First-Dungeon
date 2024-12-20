function resurectDoctor()
    med_station_light.light:enable()
   local ref = med_station_altar.model.go
    spawn("lightning_bolt_greater_blast", ref.level,ref.x, ref.y, 0, ref.elevation+1)
    spawn("lightning_bolt", ref.level,ref.x, ref.y, 0, ref.elevation+1)
    spawn("lightning_bolt_blast", ref.level,ref.x, ref.y, 0, ref.elevation)
    local res_items_needed = {["figure_skeleton"] = 1, ["potion_greater_healing"] = 1, ["lightning_rod"] = 1, ["embalmers_robe"] = 1}
    local res_items_count = 4
    local res_items = {}
    local med_station_altar = findEntity("med_station_altar")
    for _, i in med_station_altar.surface:contents() do
        hudPrint(tostring(i.go.name)..":"..tostring(res_items_needed[i.go.name] ))
        if res_items_needed[i.go.name] ~= nil then
            res_items_needed[i.go.name] = nil
            res_items_count = res_items_count - 1
            table.insert(res_items, i)
        end
    end
    if res_items_count == 0 then
        for _, i in ipairs(res_items) do
            i.go:destroyDelayed()
        end
        spawn("mummy", ref.level, ref.x, ref.y, 0, ref.elevation)
    end
end