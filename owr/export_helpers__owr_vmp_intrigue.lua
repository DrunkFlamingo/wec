--function (re)applies region effect bundle to all capitals of given faction.
--expects faction():name() and a string for the effect bundle name.
--v function(faction: string, effect_bundle: string)
local function tp_apply_effect_to_regions(faction, effect_bundle)
	local effectBundle = effect_bundle
	local thisFaction = cm:model():world():faction_by_key(faction);
	local regionList = thisFaction:region_list();
	OWRLOG("TP: effect function called");
	
	for i = 0, regionList:num_items() - 1 do
		local current_region = regionList:item_at(i);
		OWRLOG("TP: checking regions with trade");
			
		if current_region:is_province_capital() then
			OWRLOG("TP: applying bundle to capital.");
			cm:remove_effect_bundle_from_region(effectBundle, current_region:name());
			cm:apply_effect_bundle_to_region(effectBundle, current_region:name(), 10);
		end;
	end;
end;

	
core:add_listener(
		"OWR_Intrigue_Rite",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "STANDARD_RITUAL";
		end,
		function(context)
			local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			local faction = context:performing_faction();
			local factions_trading_with = faction:factions_trading_with();
			OWRLOG("TP: Standard ritual completed. Checking for Intrigue rite");
			
			if ritual_key == "wh_main_ritual_vmp_intrigue" then
			OWRLOG("TP: Intrigue Rite detected");
			
				if factions_trading_with:num_items() > 0 then
				OWRLOG("TP: Rite 'owner' has trading partners");
				
					for i = 0, factions_trading_with:num_items() - 1 do
						local current_faction = factions_trading_with:item_at(i);
						
						tp_apply_effect_to_regions(current_faction:name(),"tp_trade_corr_bundle_region_vamp")
						OWRLOG("TP: Effect being added.");
					end;
				end;
			end;
		end,
		true
	);	
	
