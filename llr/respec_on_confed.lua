
--# assume global class LLR
local legendary_lord_respec = {} --# assume legendary_lord_respec: LLR


--v function() --> LLR
function legendary_lord_respec.new()
    local self = {}
    setmetatable(self, {
        __index = legendary_lord_respec
    })--# assume self: LLR

    self._legendaryLords = {} --:map<string, string> 
    --maps subtypes to factions

    return self
end

--v method(text: any)
function legendary_lord_respec:log(text)
    if not __write_output_to_logfile then
        return; 
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("LLR:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

--v function(self: LLR, lord: CA_CHAR, new_faction: CA_FACTION)
function legendary_lord_respec.lord_confederated_into_faction(self, lord, new_faction)
    if new_faction:is_human() then
        cm:force_reset_skills(cm:char_lookup_str(lord))
    end
    self._legendaryLords[lord:character_subtype_key()] = new_faction:name()
end


--v function(self: LLR)
function legendary_lord_respec.build_lord_list(self)
    self:log("Building lord list")
    local players = cm:get_human_factions()
    local subtype_counts = {} --:map<string, number>
    for i = 1, #players do
        local current_player = cm:get_faction(players[i])
        local confederable_factions = current_player:factions_of_same_subculture()
        for j = 0, confederable_factions:num_items() - 1 do
            local current_faction = confederable_factions:item_at(j)
            local char_list = current_faction:character_list()
            for k = 0, char_list:num_items() - 1 do
                local current_subtype = char_list:item_at(k):character_subtype_key()
                subtype_counts[current_subtype] = (subtype_counts[current_subtype] or 0) + 1
                self._legendaryLords[current_subtype] = current_faction:name()
            end
        end
    end
    --trim any lords we found with more than 1 instance.
    for subtype, num_existing in pairs(subtype_counts) do
        if num_existing == 1 then
            self:log("Found legendary lord ["..subtype.."] in faction ["..self._legendaryLords[subtype].."] ")
        else
            self._legendaryLords[subtype] = nil
        end
    end
    self:log("Lord list built")
end

--v function(self: LLR, confederation: CA_FACTION)
function legendary_lord_respec.confederation_occured(self, confederation)
    for i = 0, confederation:character_list():num_items() - 1 do
        local current_character = confederation:character_list():item_at(i)
        if self._legendaryLords[current_character:character_subtype_key()] ~= confederation:name() then
            self:log(" Confederation ["..confederation:name().."] recieved character ["..current_character:character_subtype_key().."]")
            self:lord_confederated_into_faction(current_character, confederation)
        end
    end
end
--v function(self: LLR)
function legendary_lord_respec.activate(self)
    core:add_listener(
        "LegendaryLordRespecConfederation",
        "FactionJoinsConfederation",
        true,
        function(context)
            self:confederation_occured(context:confederation())
        end,
        true
    )
    self:log("Listeners added")
end

--implementation
cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
    local llr = legendary_lord_respec.new()
    llr:build_lord_list()
    llr:activate()
end

