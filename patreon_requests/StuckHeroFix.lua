--Log script to text
--v function(text: string | number | boolean | CA_CQI)
local function LOG(text)
    if not __write_output_to_logfile then
        return;
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("FIX:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end



cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function()
    local fact_list = cm:model():world():faction_list()

    for i = 0, fact_list:num_items()  - 1 do 
        local faction = fact_list:item_at(i)
        local char_list = faction:character_list()
        for j = 0, char_list:num_items() - 1 do
            local char = char_list:item_at(j)
            if char:character_type("general") or char:character_type("colonel") then

                has_mf = char:has_military_force()
                is_pol = char:is_politician()
                has_gar_res = char:has_garrison_residence()
                if faction:is_human() then
                    LOG("Found a human character with type general or colonel")
                    LOG("\t has mf: " .. tostring(has_mf))
                    LOG("\t is politican: " .. tostring(is_pol))
                    LOG("\t is in gar: " .. tostring(has_gar_res))
                    LOG("\t subtype : " .. tostring(char:character_subtype_key()))
                end
                if not (has_mf or is_pol or has_gar_res) then
                    cm:kill_character(char:cqi(), true, true)
                end
            end
        end
    end
end