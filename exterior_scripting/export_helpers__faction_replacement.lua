events = get_events()
--v function(exemptions: vector<CA_CQI>, cqi: CA_CQI)
local function kill_if_allowed(exemptions, cqi)

for i = 1, #exemptions do
    if exemptions[i] == cqi then
        return
    end
end
cm:set_character_immortality(cm:char_lookup_str(cqi), false)
cm:kill_character(cqi, true, true)
end


--v function(faction: string, army_index: vector<SPAWN_INFO>)
local function replace_faction(faction, army_index)
    local faction_replacer_cqi_list = {} --:vector<CA_CQI>
    for i = 1, # army_index do 
        local current_spawn = army_index[i]
        cm:create_force_with_general(
            faction, 
            current_spawn.army,
            current_spawn.region,
            current_spawn.x,
            current_spawn.y,
            "general",
            current_spawn.subtype,
            current_spawn.forename,
            "",
            current_spawn.surname,
            "",
            current_spawn.is_faction_leader,
            function(cqi)
                table.insert(faction_replacer_cqi_list, cqi)
            end
        )
    end

    local force_list = cm:get_faction(faction):character_list()
    for i = 0, force_list:num_items() - 1 do
        local cqi = force_list:item_at(i):cqi()
        kill_if_allowed(faction_replacer_cqi_list, cqi)
    end
end

local function replace_kislev()
local army_index = {
    {
        region = "a fucking region key",
        x = 1,
        y = 2,
        subtype = "lordsubtypekey",
        forename = "names_name_######",
        surname = "names_name_######",
        is_faction_leader = true,
        army = "aunit,anotherunit,athirdunit,yougettheidea"
    },
    {
        region = "a fucking region key",
        x = 1,
        y = 2,
        subtype = "lordsubtypekey",
        forename = "names_name_######",
        surname = "names_name_######",
        is_faction_leader = true,
        army = "aunit,anotherunit,athirdunit,yougettheidea"
    }
}--:vector<SPAWN_INFO>

if cm:is_new_game() then
    replace_faction("wh_main_ksl_kislev", army_index)
end



end





events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() replace_kislev() end;