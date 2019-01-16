--# assume global class WAR_SENTIMENT_MANAGER
local war_sentiment_manager = {} --# assume war_sentiment_manager:WAR_SENTIMENT_MANAGER

--v function(min_level: number, max_level: number, default_value: number, bundle_prefix: string) --> WAR_SENTIMENT_MANAGER
function war_sentiment_manager.init(min_level, max_level, default_value, bundle_prefix)
    local self = {}
    setmetatable(self, {
        __index = war_sentiment_manager
    })--# assume self: WAR_SENTIMENT_MANAGER

    self._activeSubcults = {} --:map<string, {number, number}>
    self._factionSentiments = {} --:map<string, number>
    self._changeNotification = 0 --:number

    self._maxVal = max_level
    self._minVal = min_level
    self._bundlePrefix = bundle_prefix
    self._defaultVal = default_value
    
    --lost settlement event
    self._lostSettlements = {} --:map<string, map<string, boolean>>

    _G.wsm = self
    return self
end

--v function(self: WAR_SENTIMENT_MANAGER, faction_key: string, quantity: number)
function war_sentiment_manager.change_sentiment_for_faction(self, faction_key, quantity)
    local old_sentiment = self._factionSentiments[faction_key]
    if old_sentiment == nil then
        local svr_var = cm:get_saved_value("war_sentiment_faction_"..faction_key)
        if svr_var then
            old_sentiment = svr_var
        else
            old_sentiment = 0
        end
    end
    local new_sentiment = old_sentiment + math.floor(quantity+0.5)
    if new_sentiment > self._maxVal then
        new_sentiment = self._maxVal
    elseif new_sentiment < self._minVal then
        new_sentiment = self._minVal
    end
    local faction_obj = cm:get_faction(faction_key)
    if faction_obj:has_effect_bundle(self._bundlePrefix..old_sentiment) then
        cm:remove_effect_bundle(self._bundlePrefix..old_sentiment, faction_key)
    end
    cm:apply_effect_bundle(self._bundlePrefix..new_sentiment, faction_key, 0)

    self._factionSentiments[faction_key] = new_sentiment

    if not faction_obj:is_human() then
        return
    end

    local increase_image, decrease_image = self._activeSubcults[faction_obj:subculture()][1], self._activeSubcults[faction_obj:subculture()][2]


    if (self._changeNotification == 0) then
        self._changeNotification = math.floor(quantity+0.5)
    else
        core:remove_listener("WarSentimentNotification")
        local real_change_note = self._changeNotification + math.floor(quantity+0.5)
        self._changeNotification = real_change_note
    end
        
    if self._changeNotification > 0 then
        core:add_listener(
            "WarSentimentNotification",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == faction_key
            end,
            function(context)
                cm:show_message_event(                            
                faction_key,
                "event_feed_strings_text_"..self._bundlePrefix.."_increase_title",
                "event_feed_strings_text_"..self._bundlePrefix.."_increase_subtitle",
                "event_feed_strings_text_"..self._bundlePrefix.."_increase_paragraph_text",
                true,
                increase_image)
                self._changeNotification = 0
            end,
            false
        )
    elseif self._changeNotification < 0 then
        core:add_listener(
            "WarSentimentNotification",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == faction_key
            end,
            function(context)
                cm:show_message_event(                            
                faction_key,
                "event_feed_strings_text_"..self._bundlePrefix.."_decrease_title",
                "event_feed_strings_text_"..self._bundlePrefix.."_decrease_subtitle",
                "event_feed_strings_text_"..self._bundlePrefix.."_decrease_paragraph_text",
                true,
                decrease_image)
                self._changeNotification = 0
            end,
            false
        )
    end
end

--v function(self: WAR_SENTIMENT_MANAGER, faction_list: CA_FACTION_LIST)
function war_sentiment_manager.set_default_values_for_startpos(self, faction_list)
    for i = 0, faction_list:num_items() - 1 do
        local faction_key = faction_list:item_at(i):name()
        cm:apply_effect_bundle(self._bundlePrefix..self._defaultVal, faction_key, 0)
    self._factionSentiments[faction_key] = self._defaultVal
    end

end

--v function(self: WAR_SENTIMENT_MANAGER, change_val: number, event: string, conditional: (function(context: WHATEVER) --> boolean), faction_function: (function(context: WHATEVER) --> CA_FACTION), quantity_for_full_level: number?, subculture_specific: string?)
function war_sentiment_manager.add_event(self, change_val, event, conditional, faction_function, quantity_for_full_level, subculture_specific)
    if quantity_for_full_level then --make sure the value is valid if it exists
        --# assume quantity_for_full_level: number
        if quantity_for_full_level <= 1 then
            quantity_for_full_level = nil --otherwise set it not to exist
        end
    end

    local sub_conditional --:function(context: WHATEVER) --> boolean
    if subculture_specific then --if we have a specific sub for this event, we should use a bigger check!
        sub_conditional = function(context)
            return ((not not self._activeSubcults[faction_function(context):subculture()]) and (faction_function(context):subculture() == subculture_specific))
        end
    else --if not, just check the subculture has WS in general!
        sub_conditional = function(context)
            return (not not self._activeSubcults[faction_function(context):subculture()])
        end
    end

    core:add_listener(
        "WarSentiment"..event,
        event,
        function(context)
            return sub_conditional(context) -- checks subculture
        end,
        function(context)
            if (not quantity_for_full_level) then
                self:change_sentiment_for_faction(faction_function(context):name(), change_val) --sends the change
            else
                --# assume quantity_for_full_level: number
                local faction_name = faction_function(context):name()
                local svr_var = cm:get_saved_value("war_sentiment_vars_"..faction_name) or 0 --checks against a saved instance list.
                local new_var = svr_var + 1 
                if new_var >= quantity_for_full_level then
                    self:change_sentiment_for_faction(faction_name, change_val)
                    cm:set_saved_value("war_sentiment_vars_"..faction_name, 0)
                else
                    cm:set_saved_value("war_sentiment_vars_"..faction_name, new_var)
                end
            end
        end,
        true
    )

end


--v function(self: WAR_SENTIMENT_MANAGER, subculture: string, increase_image: number, decrease_image: number)
function war_sentiment_manager.give_subculture_ws(self, subculture, increase_image, decrease_image)
    self._activeSubcults[subculture] = {increase_image, decrease_image}
end

--v function(self: WAR_SENTIMENT_MANAGER)
function war_sentiment_manager.listen_for_player_lost_regions(self)
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local regions = {} --:map<string, boolean>
        local faction = cm:get_faction(humans[i])
        for j = 0, faction:region_list():num_items() - 1 do
            regions[faction:region_list():item_at(j):name()] = true
        end
        self._lostSettlements[humans[i]] = regions
        core:add_listener(
            "WSMCoreSettlementOccupied",
            "GarrisonOccupiedEvent",
            function(context)
                return true
            end,
            function(context)
                local region_name = context:garrison_residence():region():name()
                if context:character():faction():is_human() then
                    self._lostSettlements[context:faction():name()][region_name] = true
                else
                    for k = 1, #humans do
                        local list = self._lostSettlements[humans[i]]
                        if list[region_name] then
                            core:trigger_event("FactionLostSettlement", context:character():faction(), context:garrison_residence():region(), context:character())
                            list[region_name] = nil
                            break
                        end
                    end
                end
            end,
            true
        )

    end
end


war_sentiment_manager.init(1, 10, 6, "sr_warsentiment")