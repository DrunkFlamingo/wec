--v function(faction: CA_FACTION, ritual_key: string)
local function OWR_ai_rite_performed_event(faction, ritual_key)
    if faction:has_home_region() then
        local capital = faction:home_region():settlement();
        local factions_known = faction:factions_met();
        local culture = faction:culture();
        local id = 820;
        
        
        for i = 0, factions_known:num_items() - 1 do
            local current_faction = factions_known:item_at(i);
            
            if current_faction:is_human() then
                local current_faction_name = current_faction:name();
                local primary_detail = "event_feed_strings_text_wh2_event_feed_string_scripted_event_ai_rite_performed_primary_detail_" .. ritual_key;
                local ai_faction_name = "factions_screen_name_" .. faction:name()
                local secondary_detail = "event_feed_strings_text_wh2_event_feed_string_scripted_event_ai_rite_performed_secondary_detail_" .. ritual_key;
                
                cm:show_message_event_located(
                    current_faction_name,
                    primary_detail,
                    ai_faction_name,
                    secondary_detail,
                    capital:logical_position_x(),
                    capital:logical_position_y(),
                    true,
                    id
                );
                
            end;
        end;
        
    elseif wh_faction_is_horde(faction) then
        local factions_known = faction:factions_met();
        local culture = faction:culture();
        local id = 820;
        
        
        for i = 0, factions_known:num_items() - 1 do
            local current_faction = factions_known:item_at(i);
            
            if current_faction:is_human() then
                local current_faction_name = current_faction:name();
                local primary_detail = "event_feed_strings_text_wh2_event_feed_string_scripted_event_ai_rite_performed_primary_detail_" .. ritual_key;
                local ai_faction_name = "factions_screen_name_" .. faction:name()
                local secondary_detail = "event_feed_strings_text_wh2_event_feed_string_scripted_event_ai_rite_performed_secondary_detail_" .. ritual_key;
                
                cm:show_message_event(
                    current_faction_name,
                    primary_detail,
                    ai_faction_name,
                    secondary_detail,
                    true,
                    id
                );
                
            end;
        end;
    end;
end;


core:add_listener(
	"OWR_external_functions",
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "STANDARD_RITUAL";
	end,
	function(context)
		local ritual = context:ritual();
		local ritual_key = ritual:ritual_key();
		local faction = context:performing_faction();
		local is_human = faction:is_human();
		
		if not is_human and (ritual_key == "wh_main_ritual_chs_cults" or ritual_key == "wh_main_ritual_ksl_winter" or ritual_key == "wh_main_ritual_vmp_intrigue" or ritual_key == "wh_main_ritual_brt_errantry") then
			OWR_ai_rite_performed_event(faction, ritual_key);
		end; 

	end,
	true);
		