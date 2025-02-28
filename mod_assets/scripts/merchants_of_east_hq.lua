function enterLevel()
    init_dungeon.script.initParty()
    global_scripts.script.party_gain_health({1,2,3,4}, 500)
end