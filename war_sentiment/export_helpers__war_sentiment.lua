local wsm = _G.wsm

local sentiment_subcultures = {
    ["wh_main_sc_emp_empire"] = {591, 591}
} --:map<string, {number, number}>

for subculture, image_pair in pairs(sentiment_subcultures) do
    wsm:give_subculture_ws(subculture, image_pair[1], image_pair[2])
end

local sentiment_causes = {
    {   
        value = 1,
        event = "FactionLostSettlement",
        condition = function(context --:WHATEVER
        )
            return true
        end,
        faction = function(context --:WHATEVER
        )
            return context:faction()
        end,
        times_required = 3, --this is optional. If you want times required to be 1, just leave it out.
        subculture_specific = "wh_main_sc_emp_empire" --also optional. If you want an event to impact all factions, just leave it out.
    }
}--:vector<{value: number, event: string, condition: (function(context: WHATEVER) --> boolean), faction: (function(context: WHATEVER) --> CA_FACTION), times_required: number?, subculture_specific: string?}>

cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
    if not cm:get_saved_value("ws_init") then
        cm:set_saved_value("ws_init", true)
        local faction_list = cm:model():world():faction_list()
        wsm:set_default_values_for_startpos(faction_list)
    end
    wsm:listen_for_player_lost_regions()
    for i = 1, #sentiment_causes do
        value = sentiment_causes[i].value 
        event = sentiment_causes[i].event 
        condition = sentiment_causes[i].condition 
        faction = sentiment_causes[i].faction 
        times_required = sentiment_causes[i].times_required
        subculture_specific = sentiment_causes[i].subculture_specific
        wsm:add_event(value, event, condition, faction, times_required, subculture_specific)
    end

end









