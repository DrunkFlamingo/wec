
--v function(faction_name: string)
local function df_spawn_cultists(faction_name)

    OWRLOG("OWR: spawning cultists")

    local army = cm:get_highest_ranked_general_for_faction(faction_name);
    OWRLOG("1")
    local spawnx = army:logical_position_x() + 3;
    OWRLOG("2")
    local spawny = army:logical_position_y() - 3;
    OWRLOG("3")
    local spawnregion = "wh_main_goromandy_mountains_baersonlings_camp"
    OWRLOG("4")
    local unit_list = "wh_dlc01_chs_inf_forsaken_0,wh_dlc01_chs_inf_forsaken_0,wh_main_chs_inf_chosen_0,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_marauders_0,wh_main_chs_inf_chaos_warriors_1,wh_main_chs_inf_chaos_warriors_1,wh_main_chs_inf_chaos_warriors_1,wh_main_chs_mon_chaos_spawn,wh_main_chs_mon_chaos_spawn,wh_main_chs_mon_chaos_warhounds_0"
    OWRLOG("5")
    local turn = cm:model():turn_number();


    OWRLOG("spawning army");
    cm:create_force(
    "wh2_main_chs_chaos_incursion_def",
    unit_list,
    spawnregion,
    spawnx,
    spawny,
    true);
    
    cm:callback( function()
        cm:force_diplomacy("faction:wh2_main_chs_chaos_incursion_def", "faction:"..faction_name, "war,break vassal,break alliance,break client state", false, false, false);	
        cm:force_make_vassal(faction_name, "wh2_main_chs_chaos_incursion_def");
    
    end, 0.5);


end;

--v function()
local function OWR_chs_cults()
    
    local majorcities_list = {
        "wh_main_reikland_altdorf",
        "wh_main_middenland_middenheim",
        "wh_main_southern_oblast_kislev",
        "wh_main_couronne_et_languille_couronne",
        "wh_main_bordeleaux_et_aquitaine_bordeleaux",
        "wh_main_estalia_magritta",
        "wh2_main_nagarythe_tor_anlec",
        "wh2_main_yvresse_tor_yvresse",
        "wh2_main_eataine_lothern",
        "wh2_main_the_chill_road_ghrond",
        "wh2_main_iron_mountains_naggarond",
        "wh2_main_titan_peaks_ancient_city_of_quintex",
        "wh2_main_the_road_of_skulls_har_ganeth",
        "wh_main_tilea_miragliano",
        "wh_main_eastern_border_princes_akendorf",
        "wh_main_western_border_princes_myrmidens"
    }--: vector<string>
        
    
    for i = 1, #majorcities_list do
        cm:apply_effect_bundle_to_region("wh_main_ritual_chs_cults_corruption", majorcities_list[i], 10)
    end;

end;
    
    
	
core:add_listener(
	"OWR_chs_cults",
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "STANDARD_RITUAL";
	end,
	function(context)
		local ritual = context:ritual();
		local ritual_key = ritual:ritual_key();
		local faction = context:performing_faction();
		
		if ritual_key == "wh_main_ritual_chs_cults" then
            OWR_chs_cults();
            df_spawn_cultists(faction:name());
		end;
	end,
	true);