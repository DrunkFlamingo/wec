DF_CHAOS_PORTAL_BUILDING = {
    "wh_main_dwf_grn_settlement_major_chaosruin",
    "wh_main_dwf_grn_settlement_major_chaosruin_coast",
    "wh_main_dwf_grn_settlement_minor_chaosruin",
    "wh_main_dwf_grn_settlement_minor_chaosruin_coast",
    "wh_main_HUMAN_settlement_major_chaosruin",
    "wh_main_HUMAN_settlement_major_chaosruin_coast",
    "wh_main_HUMAN_settlement_minor_chaosruin",
    "wh_main_HUMAN_settlement_minor_chaosruin_coast",
    "wh_main_HUMAN_outpostnorsca_major_chaosruin",
    "wh_main_HUMAN_outpostnorsca_major_chaosruin_coast",
    "wh_main_HUMAN_outpostnorsca_minor_chaosruin",
    "wh_main_HUMAN_outpostnorsca_minor_chaosruin_coast",
    "wh_main_special_settlement_altdorf_chaosruin",
    "wh_main_special_settlement_black_crag_chaosruin",
    "wh_main_special_settlement_castle_drakenhof_chaosruin",
    "wh_main_special_settlement_eight_peaks_chaosruin",
    "wh_main_special_settlement_karaz_a_karak_chaosruin",
    "wh_main_special_settlement_kislev_chaosruin",
    "wh_main_special_settlement_miragliano_chaosruin",
    "wh2_main_special_fortress_gate_eagle_chaos_ruins",
    "wh2_main_special_fortress_gate_griffon_chaos_ruins",
    "wh2_main_special_fortress_gate_phoenix_chaos_ruins",
    "wh2_main_special_fortress_gate_unicorn_chaos_ruins"
    }--:vector<string>

DF_HERDSTONE_BUILDINGS = {
    "wh_dlc03_GRN-DWF_settlement_major_beastmenruin_coast",
    "wh_dlc03_GRN-DWF_settlement_major_beastmenruin_coast",
    "wh_dlc03_GRN-DWF_settlement_major_beastmenruin",
    "wh_dlc03_GRN-DWF_settlement_major_beastmenruin",
    "wh_dlc03_GRN-DWF_settlement_minor_beastmenruin_coast",
    "wh_dlc03_GRN-DWF_settlement_minor_beastmenruin_coast",
    "wh_dlc03_GRN-DWF_settlement_minor_beastmenruin",
    "wh_dlc03_GRN-DWF_settlement_minor_beastmenruin",
    "wh_dlc03_HUMAN_settlement_major_beastmenruin_coast",
    "wh_dlc03_HUMAN_settlement_major_beastmenruin_coast",
    "wh_dlc03_HUMAN_settlement_major_beastmenruin",
    "wh_dlc03_HUMAN_settlement_major_beastmenruin",
    "wh_dlc03_HUMAN_settlement_minor_beastmenruin_coast",
    "wh_dlc03_HUMAN_settlement_minor_beastmenruin_coast",
    "wh_dlc03_HUMAN_settlement_minor_beastmenruin",
    "wh_dlc03_HUMAN_settlement_minor_beastmenruin",
    "wh_dlc03_HUMAN_outpostnorsca_major_beastmenruin",
    "wh_dlc03_HUMAN_outpostnorsca_major_beastmenruin",
    "wh_dlc03_HUMAN_outpostnorsca_major_beastmenruin_coast",
    "wh_dlc03_HUMAN_outpostnorsca_major_beastmenruin_coast",
    "wh_dlc03_HUMAN_outpostnorsca_minor_beastmenruin",
    "wh_dlc03_HUMAN_outpostnorsca_minor_beastmenruin",
    "wh_dlc03_HUMAN_outpostnorsca_minor_beastmenruin_coast",
    "wh_dlc03_HUMAN_outpostnorsca_minor_beastmenruin_coast"
    }--:vector<string>


local goc_settings = {} 
goc_settings.DF_CHAOS_PORTAL_BUILDING = DF_CHAOS_PORTAL_BUILDING
goc_settings.DF_CHAOS_SPAWN_CHANCE = 10 --:number
goc_settings.DF_BASE_COOLDOWN = 4 --:number
goc_settings.DF_CHAOS_ARMY_SIZES = {9, 11, 13} --:vector<number>
goc_settings.BEASTMEN = false --:boolean

DF_CHAOS_ARMY_LIST =  {"wh_dlc01_chs_inf_forsaken_0", "wh_main_chs_mon_chaos_warhounds_0", "wh_main_chs_mon_chaos_spawn", "wh_main_chs_mon_chaos_spawn",
"wh_dlc06_chs_feral_manticore", "wh_dlc01_chs_inf_chaos_warriors_2", "wh_dlc01_chs_inf_chaos_warriors_2", "wh_main_chs_mon_chaos_spawn", "wh_main_chs_mon_chaos_spawn",
"wh_dlc01_chs_inf_forsaken_0", "wh_main_chs_mon_chaos_warhounds_0", "wh_main_chs_mon_chaos_spawn", "wh_main_chs_mon_chaos_spawn"
} --:vector<string>

DF_HERD_ARMY_LIST = {"wh_dlc03_bst_inf_centigors_0", "wh_dlc03_bst_inf_minotaurs_0", "wh_dlc03_bst_mon_chaos_spawn_0", "wh_dlc03_bst_inf_gor_herd_0", "wh_dlc03_bst_inf_gor_herd_0",
"wh_dlc03_bst_inf_bestigor_herd_0", "wh_dlc03_bst_inf_ungor_spearmen_0", "wh_dlc03_bst_inf_gor_herd_1", "wh_dlc03_bst_inf_gor_herd_1", "wh_dlc03_bst_inf_ungor_raiders_0", "wh_dlc03_bst_inf_ungor_raiders_0"} --:vector<string>

DF_HERD_ARMY_FACTION = {"wh_dlc03_bst_beastmen",
"wh_dlc03_bst_redhorn",
"wh_dlc03_bst_jagged_horn",
"wh2_main_bst_blooded_axe",
"wh2_main_bst_manblight",
"wh2_main_bst_ripper_horn",
"wh2_main_bst_shadowgor"} --:vector<string>
DF_CHAOS_ARMY_FACTION = "wh2_main_chs_chaos_incursion_lzd" --:string

DF_SPAWN_LOCATIONS = {
    ["wh_main_goromandy_mountains_baersonlings_camp"] = {762,594}, 
    ["wh_main_eastern_oblast_volksgrad"] = {724,584}, 
    ["wh_main_eastern_oblast_praag"] = {699,585}, 
    ["wh_main_goromandy_mountains_frozen_landing"] = {734,624}, 
    ["wh_main_gianthome_mountains_sjoktraken"] = {691,637}, 
    ["wh_main_gianthome_mountains_khazid_bordkarag"] = {657,640}, 
    ["wh_main_gianthome_mountains_kraka_drak"] = {685,656}, 
    ["wh2_main_hell_pit_hell_pit"] = {675,611}, 
    ["wh_main_northern_oblast_fort_ostrosk"] = {658,595}, 
    ["wh_main_northern_oblast_fort_straghov"] = {636,622}, 
    ["wh_main_trollheim_mountains_the_tower_of_khrakk"] = {601,625}, 
    ["wh_main_trollheim_mountains_bay_of_blades"] = {545,625}, 
    ["wh_main_trollheim_mountains_sarl_encampment"] = {550,651}, 
    ["wh_main_mountains_of_hel_aeslings_conclave"] = {597,662}, 
    ["wh_main_mountains_of_hel_altar_of_spawns"] = {575,699}, 
    ["wh_main_mountains_of_hel_winter_pyre"] = {637,674}, 
    ["wh_main_mountains_of_naglfari_varg_camp"] = {488,686}, 
    ["wh_main_mountains_of_naglfari_naglfari_plain"] = {495,647}, 
    ["wh_main_helspire_mountains_graeling_moot"] = {477,641}, 
    ["wh_main_helspire_mountains_the_monolith_of_katam"] = {428,673}, 
    ["wh_main_helspire_mountains_serpent_jetty"] = {394,660}, 
    ["wh_main_vanaheim_mountains_troll_fjord"] = {361,609}, 
    ["wh_main_vanaheim_mountains_bjornlings_gathering"] = {427,616}, 
    ["wh_main_vanaheim_mountains_pack_ice_bay"] = {426,575}, 
    ["wh_main_ice_tooth_mountains_icedrake_fjord"] = {467,591}, 
    ["wh_main_ice_tooth_mountains_longship_graveyard"] = {504,597}, 
    ["wh_main_ice_tooth_mountains_doomkeep"] = {517,649}, 
    ["wh_main_troll_country_zoishenk"] = {612,599}, 
    ["wh_main_troll_country_erengrad"] = {609,584}, 
    ["wh_main_southern_oblast_zavastra"] = {649,551}, 
    ["wh_main_southern_oblast_kislev"] = {684,544}, 
    ["wh_main_southern_oblast_fort_jakova"] = {704,508}, 
    ["wh_main_ostermark_bechafen"] = {655,525}, 
    ["wh_main_ostermark_essen"] = {658,476}, 
    ["wh_main_ostland_castle_von_rauken"] = {620,548}, 
    ["wh_main_ostland_wolfenburg"] = {602,538}, 
    ["wh_main_ostland_norden"] = {571,576}, 
    ["wh_main_nordland_salzenmund"] = {536,569}, 
    ["wh_main_nordland_dietershafen"] = {495,562}, 
    ["wh_main_middenland_middenheim"] = {521,531}, 
    ["wh_main_middenland_weismund"] = {498,500}, 
    ["wh_main_middenland_carroburg"] = {487,466}, 
    ["wh_main_hochland_brass_keep"] = {565,538}, 
    ["wh_main_hochland_hergig"] = {580,516}, 
    ["wh_main_talabecland_kemperbad"] = {534,454}, 
    ["wh_main_talabecland_talabheim"] = {569,497}, 
    ["wh_main_stirland_wurtbad"] = {584,441}, 
    ["wh_main_stirland_the_moot"] = {611,409}, 
    ["wh_main_averland_grenzstadt"] = {612,387}, 
    ["wh_main_eastern_sylvania_castle_drakenhof"] = {680,420}, 
    ["wh_main_eastern_sylvania_eschen"] = {678,445}, 
    ["wh_main_eastern_sylvania_waldenhof"] = {684,458}, 
    ["wh_main_western_sylvania_castle_templehof"] = {652,443}, 
    ["wh_main_western_sylvania_fort_oberstyre"] = {634,436}, 
    ["wh_main_western_sylvania_schwartzhafen"] = {641,394},
    ["wh_main_wissenland_wissenburg"] = {531,394}, 
    ["wh_main_wissenland_nuln"] = {524,410}, 
    ["wh_main_wissenland_pfeildorf"] = {563,379}, 
    ["wh_main_reikland_grunburg"] = {514,427}, 
    ["wh_main_reikland_altdorf"] = {496,450}, 
    ["wh_main_reikland_helmgart"] = {466,428}, 
    ["wh_main_reikland_eilhart"] = {445,450}, 
    ["wh_main_the_wasteland_marienburg"] = {428,462}, 
    ["wh_main_the_wasteland_gorssel"] = {432,485}, 
    ["wh_main_forest_of_arden_gisoreux"] = {413,442}, 
    ["wh_main_forest_of_arden_castle_artois"] = {389,451}, 
    ["wh_main_couronne_et_languille_languille"] = {363,470}, 
    ["wh_main_couronne_et_languille_couronne"] = {384,491}, 
    ["wh_main_lyonesse_lyonesse"] = {340,440}, 
    ["wh_main_lyonesse_mousillon"] = {356,420}, 
    ["wh_main_bordeleaux_et_aquitaine_bordeleaux"] = {367,396}, 
    ["wh_main_bordeleaux_et_aquitaine_aquitaine"] = {384,380}, 
    ["wh_main_bastonne_et_montfort_castle_bastonne"] = {404,407}, 
    ["wh_main_bastonne_et_montfort_montfort"] = {438,401}, 
    ["wh_main_northern_grey_mountains_karak_ziflin"] = {441,413}, 
    ["wh_main_northern_grey_mountains_grung_zint"] = {407,466}, 
    ["wh_main_northern_grey_mountains_blackstone_post"] = {422,428}, 
    ["wh_main_parravon_et_quenelles_parravon"] = {450,379}, 
    ["wh_main_parravon_et_quenelles_quenelles"] = {444,349}, 
    ["wh_main_carcassone_et_brionne_castle_carcassonne"] = {431,318}, 
    ["wh_main_carcassone_et_brionne_brionne"] = {399,339}, 
    ["wh2_main_yvresse_elessaeli"] = {270,292}, 
    ["wh2_main_yvresse_tor_yvresse"] = {288,347}, 
    ["wh2_main_cothique_tor_koruali"] = {284,394}, 
    ["wh2_main_cothique_mistnar"] = {290,417}, 
    ["wh2_main_chrace_elisia"] = {261,417}, 
    ["wh2_main_chrace_tor_achare"] = {247,412}, 
    ["wh2_main_nagarythe_shrine_of_khaine"] = {214,447}, 
    ["wh2_main_nagarythe_tor_anlec"] = {197,423}, 
    ["wh2_main_nagarythe_tor_dranil"] = {166,401}, 
    ["wh2_main_unicorn_gate"] = {177,395}, 
    ["wh2_main_phoenix_gate"] = {208,406}, 
    ["wh2_main_griffon_gate"] = {154,371}, 
    ["wh2_main_eagle_gate"] = {148,343}, 
    ["wh2_main_tiranoc_tor_anroc"] = {145,341}, 
    ["wh2_main_tiranoc_whitepeak"] = {147,319}, 
    ["wh2_main_caledor_tor_sethai"] = {162,298}, 
    ["wh2_main_caledor_vauls_anvil"] = {174,274}, 
    ["wh2_main_eataine_tower_of_lysean"] = {198,291}, 
    ["wh2_main_eataine_lothern"] = {211,279}, 
    ["wh2_main_eataine_angerrial"] = {237,289}, 
    ["wh2_main_eataine_shrine_of_asuryan"] = {226,306}, 
    ["wh2_main_saphery_port_elistor"] = {253,305}, 
    ["wh2_main_saphery_tower_of_hoeth"] = {258,327}, 
    ["wh2_main_saphery_tor_finu"] = {261,352}, 
    ["wh2_main_avelorn_tor_saroir"] = {238,370}, 
    ["wh2_main_avelorn_evershale"] = {207,377}, 
    ["wh2_main_avelorn_gaean_vale"] = {226,361},
    ["wh2_main_ellyrion_whitefire_tor"] = {175,358}, 
    ["wh2_main_ellyrion_tor_elyr"] = {171,334}, 
    ["wh2_main_aghol_wastelands_palace_of_princes"] = {373,696}, 
    ["wh2_main_aghol_wastelands_fortress_of_the_damned"] = {337,687},
    ["wh2_main_aghol_wastelands_the_palace_of_ruin"] = {252,697},  
    ["wh2_main_deadwood_shagrath"] = {291,670}, 
    ["wh2_main_deadwood_the_frozen_city"] = {261,684}, 
    ["wh2_main_deadwood_dargoth"] = {224,659}, 
    ["wh2_main_deadwood_nagrar"] = {231,648}, 
    ["wh2_main_the_road_of_skulls_the_black_pillar"] = {187,647}, 
    ["wh2_main_the_road_of_skulls_kauark"] = {177,666}, 
    ["wh2_main_the_road_of_skulls_spite_reach"] = {155,653}, 
    ["wh2_main_the_road_of_skulls_har_ganeth"] = {143,632}, 
    ["wh2_main_the_chill_road_ghrond"] = {130,647}, 
    ["wh2_main_the_chill_road_ashrak"] = {104,668}, 
    ["wh2_main_the_chill_road_the_great_arena"] = {96,640}, 
    ["wh2_main_iron_mountains_naggarond"] = {84,630}, 
    ["wh2_main_iron_mountains_har_kaldra"] = {57,652}, 
    ["wh2_main_iron_mountains_altar_of_ultimate_darkness"] = {21,646}, 
    ["wh2_main_iron_mountains_rackdo_gorge"] = {28,629}, 
    ["wh2_main_the_black_flood_temple_of_khaine"] = {57,605}, 
    ["wh2_main_the_black_flood_cragroth_deep"] = {81,577}, 
    ["wh2_main_the_black_flood_hag_graef"] = {104,593}, 
    ["wh2_main_the_black_flood_shroktak_mount"] = {29,585}, 
    ["wh2_main_obsidian_peaks_circle_of_destruction"] = {122,560}, 
    ["wh2_main_obsidian_peaks_clar_karond"] = {95,534}, 
    ["wh2_main_obsidian_peaks_venom_glade"] = {119,522}, 
    ["wh2_main_obsidian_peaks_storag_kor"] = {50,538}, 
    ["wh2_main_the_clawed_coast_hoteks_column"] = {143,535}, 
    ["wh2_main_the_clawed_coast_the_monoliths"] = {175,543}, 
    ["wh2_main_the_clawed_coast_the_twisted_glade"] = {177,509}, 
    ["wh2_main_the_broken_land_blacklight_tower"] = {177,592}, 
    ["wh2_main_the_broken_land_slavers_point"] = {212,570}, 
    ["wh2_main_the_broken_land_karond_kar"] = {242,605}, 
    ["wh2_main_doom_glades_vauls_anvil"] = {90,483}, 
    ["wh2_main_doom_glades_hag_hall"] = {73,460}, 
    ["wh2_main_doom_glades_ice_rock_gorge"] = {50,453}, 
    ["wh2_main_doom_glades_temple_of_addaioth"] = {54,497}, 
    ["wh2_main_blackspine_mountains_red_desert"] = {11,560}, 
    ["wh2_main_blackspine_mountains_plain_of_spiders"] = {16,508}, 
    ["wh2_main_blackspine_mountains_plain_of_dogs"] = {11,437}, 
    ["wh2_main_the_black_coast_bleak_hold_fortress"] = {87,415}, 
    ["wh2_main_the_black_coast_arnheim"] = {98,379}, 
    ["wh2_main_titan_peaks_ancient_city_of_quintex"] = {47,388}, 
    ["wh2_main_titan_peaks_the_moon_shard"] = {71,357}, 
    ["wh2_main_titan_peaks_ssildra_tor"] = {36,354}, 
    ["wh2_main_titan_peaks_ironspike"] = {21,356}, 
    ["wh2_main_isthmus_of_lustria_ziggurat_of_dawn"] = {70,325}, 
    ["wh2_main_isthmus_of_lustria_skeggi"] = {90,327}, 
    ["wh2_main_isthmus_of_lustria_hexoatl"] = {48,293}, 
    ["wh2_main_isthmus_of_lustria_fallen_gates"] = {21,317}
} --:map<string, {number, number}>




--v function(text: string)
function GOCLOG(text)
    if not __write_output_to_logfile then
        return; 
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("GOC:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end



if not not _G.sfo then
    GOCLOG("Startup: SFO is active!")
    DF_CHAOS_ARMY_LIST =  {"wh_dlc01_chs_inf_forsaken_0", "wh_main_chs_mon_chaos_warhounds_0", "wh_main_chs_mon_chaos_spawn", "wh_main_chs_mon_chaos_spawn",
    "chs_zelot", "chs_zelot", "chs_nurgle_sons", "chs_slaanesh_bless", "chs_khorne_berserk", "chs_chaos_dragon", "wh_main_chs_mon_chaos_spawn", "wh_main_chs_mon_chaos_spawn"}
else
    GOCLOG("Startup: SFO not active!")
end

if cm:get_saved_value("whenever catap gets around to adding this ctt shit I guess man") == true then
    GOCLOG("Startup: CTT is active!")

else
    GOCLOG("Startup: CTT not active!")
end




--v function() --> vector<CA_FACTION>
local function GetPlayerFactions()
    local player_factions = {};
    local faction_list = cm:model():world():faction_list();
    for i = 0, faction_list:num_items() - 1 do
        local curr_faction = faction_list:item_at(i);
        if (curr_faction:is_human() == true) then
            table.insert(player_factions, curr_faction);
        end
    end
    return player_factions;
end;

--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
    return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;

--v function(players: vector<CA_FACTION>, region: CA_REGION) --> boolean
local function CheckIfPlayerIsNearFaction(players, region)
    local result = false;
    local settlement = region:settlement()
    local radius = 20;
    for i,value in ipairs(players) do
        local player_force_list = value:military_force_list();
        local j = 0;
        while (result == false) and (j < player_force_list:num_items()) do
            local player_character = player_force_list:item_at(j):general_character();
            local distance = distance_2D(settlement:logical_position_x(), settlement:logical_position_y(), player_character:logical_position_x(), player_character:logical_position_y());
            result = (distance < radius);
            j = j + 1;
        end
        local player_region_list = value:region_list();
        local j = 0;
        while (result == false) and (j < player_region_list:num_items()) do
            local player_character = player_region_list:item_at(j):settlement();
            local distance = distance_2D(settlement:logical_position_x(), settlement:logical_position_y(), player_character:logical_position_x(), player_character:logical_position_y());
            result = (distance < radius);
            j = j + 1;
        end
    end
    GOCLOG("is player near settlement returning ["..tostring(result).."] ")
    return result;
end

--v function(x: number, y: number) --> boolean
local function IsValidSpawnPoint(x, y)
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		local char_list = current_faction:character_list();
		
		for i = 0, char_list:num_items() - 1 do
			local current_char = char_list:item_at(i);
            if current_char:logical_position_x() == x and current_char:logical_position_y() == y then
                GOCLOG("Is valid spawn point returning false")
				return false;
			end;
		end;
    end;
    GOCLOG("is valid spawn point returning true")
	return true;
end;


--v function(region: CA_REGION) --> boolean
function region_has_portal(region)
    for i = 1, #goc_settings.DF_CHAOS_PORTAL_BUILDING do
        if region:building_exists(goc_settings.DF_CHAOS_PORTAL_BUILDING[i]) then
            if DF_SPAWN_LOCATIONS[region:name()] == nil then
                GOCLOG("Region with portal ["..region:name().."] doesn't have a set up spawn location!")
                return false
            end
            GOCLOG("Region has portal returning true for region ["..region:name().."] ")
            return true
        end
    end
    return false
end

--v function(region: CA_REGION) --> boolean
function region_has_herdstone(region)
    for i = 1, #DF_HERDSTONE_BUILDINGS do
        if region:building_exists(DF_HERDSTONE_BUILDINGS[i]) then
            if DF_SPAWN_LOCATIONS[region:name()] == nil then
                GOCLOG("Region with herdstone ["..region:name().."] doesn't have a set up spawn location!")
                return false
            end
            GOCLOG("Region has herdstone returning true for region ["..region:name().."] ")
            return true
        end
    end
    return false
end


--v function(region: CA_REGION)
local function spawn_beastmen(region)

    local unit_string = DF_HERD_ARMY_LIST[cm:random_number(#DF_HERD_ARMY_LIST)]
    for i = 1, goc_settings.DF_CHAOS_ARMY_SIZES[cm:random_number(#goc_settings.DF_CHAOS_ARMY_SIZES)] do
        local new_string = unit_string..","..DF_HERD_ARMY_LIST[cm:random_number(#DF_HERD_ARMY_LIST)]
        unit_string = new_string
    end
    GOCLOG("Assembled the spawn string as ["..unit_string.."] ")
    cm:create_force(
        DF_HERD_ARMY_FACTION[cm:random_number(#DF_HERD_ARMY_FACTION)],
        unit_string,
        region:name(),
        DF_SPAWN_LOCATIONS[region:name()][1],
        DF_SPAWN_LOCATIONS[region:name()][2],
        true,
        function(cqi)
            GOCLOG("Spawned a beastmen army at ["..region:name().."] sucessfully with cqi ["..tostring(cqi).."]")
            cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true);
        end)
    
        cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), 18)
        if cm:is_multiplayer() then --in multiplayer games we tick twice every single round. Double the cooldown
            cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), 36)
        end
end


--v function (region: CA_REGION)
local function beastmen_herds(region)
    if cm:get_saved_value("chaos_gates_cooldown_"..region:province_name()) == nil then
        cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), goc_settings.DF_BASE_COOLDOWN)
    end
    local cooldown = cm:get_saved_value("chaos_gates_cooldown_"..region:province_name())
    if cooldown > 1 then
        GOCLOG("region ["..region:name().."] is not off cooldown! It has ["..cooldown.."] turns remaining!")
        cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), cooldown - 1)
        return
    end

    if cm:is_multiplayer() then
        if CheckIfPlayerIsNearFaction(GetPlayerFactions(), region) == false and IsValidSpawnPoint(region:settlement():logical_position_x() + 2, region:settlement():logical_position_y() + 2) then
            if cm:random_number(100) <= goc_settings.DF_CHAOS_SPAWN_CHANCE/2 then
                GOCLOG("Chance check passed, spawning beastmen")
                spawn_beastmen(region)
            else
                GOCLOG("Chance check failed, maybe next time!")
            end
        end
        return
    end



    if cm:random_number(100) <= goc_settings.DF_CHAOS_SPAWN_CHANCE then
        GOCLOG("Chance check passed, spawning beastmen")
        if CheckIfPlayerIsNearFaction(GetPlayerFactions(), region) == false and IsValidSpawnPoint(region:settlement():logical_position_x() + 1, region:settlement():logical_position_y() + 1) then
            spawn_beastmen(region)
        end
    else
        GOCLOG("Chance check failed, maybe next time!")
    end

end

--v function(region: CA_REGION)
local function spawn_chaos(region)

    local unit_string = DF_CHAOS_ARMY_LIST[cm:random_number(#DF_CHAOS_ARMY_LIST)]
    for i = 1, goc_settings.DF_CHAOS_ARMY_SIZES[cm:random_number(#goc_settings.DF_CHAOS_ARMY_SIZES)] do
        local new_string = unit_string..","..DF_CHAOS_ARMY_LIST[cm:random_number(#DF_CHAOS_ARMY_LIST)]
        unit_string = new_string
    end
    GOCLOG("Assembled the spawn string as ["..unit_string.."] ")
    cm:create_force(
        DF_CHAOS_ARMY_FACTION,
        unit_string,
        region:name(),
        DF_SPAWN_LOCATIONS[region:name()][1],
        DF_SPAWN_LOCATIONS[region:name()][2],
        true,
        function(cqi)
            GOCLOG("Spawned a chaos army at ["..region:name().."] sucessfully with cqi ["..tostring(cqi).."]")
            cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true);
            cm:force_diplomacy("faction:"..DF_CHAOS_ARMY_FACTION, "faction:wh_main_chs_chaos", "war", false, false, false)
            if cm:get_faction("wh_main_chs_chaos"):is_dead() == false and cm:get_faction(DF_CHAOS_ARMY_FACTION):is_vassal_of(cm:get_faction("wh_main_chs_chaos")) == false then
                GOCLOG("Making the spawned faction a vassal!")
                cm:force_make_vassal("wh_main_chs_chaos", DF_CHAOS_ARMY_FACTION)
            end
        end)
    
        cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), 18)
        if cm:is_multiplayer() then --in multiplayer games we tick twice every single round. Double the cooldown
            cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), 36)
        end
end


--v function (region: CA_REGION)
local function chaos_gates(region)
    if cm:get_saved_value("chaos_gates_cooldown_"..region:province_name()) == nil then
        cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), goc_settings.DF_BASE_COOLDOWN)
    end
    local cooldown = cm:get_saved_value("chaos_gates_cooldown_"..region:province_name())
    if cooldown > 1 then
        GOCLOG("region ["..region:name().."] is not off cooldown! It has ["..cooldown.."] turns remaining!")
        cm:set_saved_value("chaos_gates_cooldown_"..region:province_name(), cooldown - 1)
        return
    end

    if cm:is_multiplayer() then
        if CheckIfPlayerIsNearFaction(GetPlayerFactions(), region) == false and IsValidSpawnPoint(region:settlement():logical_position_x() + 2, region:settlement():logical_position_y() + 2) then
            if cm:random_number(100) <= goc_settings.DF_CHAOS_SPAWN_CHANCE/2 then
                GOCLOG("Chance check passed, spawning chaos")
                spawn_chaos(region)
            else
                GOCLOG("Chance check failed, maybe next time!")
            end
        end
        return
    end



    if cm:random_number(100) <= goc_settings.DF_CHAOS_SPAWN_CHANCE then
        GOCLOG("Chance check passed, spawning chaos")
        if CheckIfPlayerIsNearFaction(GetPlayerFactions(), region) == false and IsValidSpawnPoint(region:settlement():logical_position_x() + 1, region:settlement():logical_position_y() + 1) then
            spawn_chaos(region)
        end
    else
        GOCLOG("Chance check failed, maybe next time!")
    end

end



core:add_listener(
    "ChaosGatesTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human()
    end,
    function(context)
        local region_list = cm:model():world():region_manager():region_list()
        for i = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(i)
            if not region:settlement():is_null_interface() then
                if region_has_portal(region) then
                    chaos_gates(region)
                end
            end
        end
    end,
    true)


--[[ testing code
--v function(text: string)
function WRITE(text)
    if not __write_output_to_logfile then
        return; 
    end

    local logText = tostring(text)
    local popLog = io.open("coordinates.txt","a")
    popLog :write(logText)
    popLog :flush()
    popLog :close()
end


core:add_listener(
    "WritingDownShit",
    "ShortcutTriggered",
    function(context) return context.string == "camera_bookmark_view0"; end, --default F9
    function(context)
        if not cm:get_saved_value("wars_declared_testing") then
            for i = 0, cm:model():world():faction_list():num_items() - 1 do
                if not cm:model():world():faction_list():item_at(i):is_dead() or cm:model():world():faction_list():item_at(i):name() == "wh_main_chs_chaos" then
                    cm:force_declare_war(cm:model():world():faction_list():item_at(i):name(), "wh_main_chs_chaos", false, false)
                    cm:set_saved_value("wars_declared_testing", true)
                end
            end
        end

        local character = cm:get_faction("wh_main_chs_chaos"):faction_leader()
        WRITE("[\""..character:region():name().." \"] = {"..character:logical_position_x()..","..character:logical_position_y().."}, \n")
    end,
    true
)
--]]

local mcm = _G.mcm
if not not mcm then
    local cog = mcm:register_mod("gates_of_chaos", "Gates of Chaos", "Spawns Chaos armies from settlements razed by the Warriors of Chaos")
    local beastmen = cog:add_tweaker("beastmen", "Beastmen Herdstones", "Allow Beastmen Tribes to spawn from herdstones.")
    beastmen:add_option("disabled", "Disabled", "Do not spawn beastmen armies from Herdstones")
    beastmen:add_option("enabled", "Enabled", "Spawn Beastmen armies from herdstones"):add_callback(function(context)
        core:add_listener(
            "ChaosGatesBeastmenTurnStart",
            "FactionTurnStart",
            function(context)
                return context:faction():is_human()
            end,
            function(context)
                local region_list = cm:model():world():region_manager():region_list()
                for i = 0, region_list:num_items() - 1 do
                    local region = region_list:item_at(i)
                    if not region:settlement():is_null_interface() then
                        if region_has_herdstone(region) then
                            beastmen_herds(region)
                        end
                    end
                end
            end,
            true)
            GOCLOG("MCM Added beastmen ruin spawns!")
    end)
    local norscaruins = cog:add_tweaker("norscaruins", "Norscan Ruins", "Allow Chaos Warriors to spawn from Norscan Ruins that have been dedicated to the ruinous powers.")
    norscaruins:add_option("disabled", "Disabled", "Do not spawn armies from Chaos God Monoliths")
    norscaruins:add_option("enabled", "Enabled", "Spawn armies from Chaos God Monoliths"):add_callback(function(context)
        local new_buildings = {
                "wh_main_NORSCA_settlement_major_coast_norscaruin_khorne",
                "wh_main_NORSCA_settlement_major_coast_norscaruin_nurgle",
                "wh_main_NORSCA_settlement_major_coast_norscaruin_slaanesh",
                "wh_main_NORSCA_settlement_major_coast_norscaruin_tzeentch",
                "wh_main_NORSCA_settlement_major_norscaruin_khorne",
                "wh_main_NORSCA_settlement_major_norscaruin_nurgle",
                "wh_main_NORSCA_settlement_major_norscaruin_slaanesh",
                "wh_main_NORSCA_settlement_major_norscaruin_tzeentch",
                "wh_main_NORSCA_settlement_minor_coast_norscaruin_khorne",
                "wh_main_NORSCA_settlement_minor_coast_norscaruin_nurgle",
                "wh_main_NORSCA_settlement_minor_coast_norscaruin_slaanesh",
                "wh_main_NORSCA_settlement_minor_coast_norscaruin_tzeentch",
                "wh_main_NORSCA_settlement_minor_norscaruin_khorne",
                "wh_main_NORSCA_settlement_minor_norscaruin_nurgle",
                "wh_main_NORSCA_settlement_minor_norscaruin_slaanesh",
                "wh_main_NORSCA_settlement_minor_norscaruin_tzeentch",
                "wh_main_oak_of_ages_norscaruin_khorne",
                "wh_main_oak_of_ages_norscaruin_nurgle",
                "wh_main_oak_of_ages_norscaruin_slaanesh",
                "wh_main_oak_of_ages_norscaruin_tzeentch",
                "wh_main_sch_settlement_major_coast_norscaruin_khorne",
                "wh_main_sch_settlement_major_coast_norscaruin_nurgle",
                "wh_main_sch_settlement_major_coast_norscaruin_slaanesh",
                "wh_main_sch_settlement_major_coast_norscaruin_tzeentch",
                "wh_main_sch_settlement_major_norscaruin_khorne",
                "wh_main_sch_settlement_major_norscaruin_nurgle",
                "wh_main_sch_settlement_major_norscaruin_slaanesh",
                "wh_main_sch_settlement_major_norscaruin_tzeentch",
                "wh_main_sch_settlement_minor_coast_norscaruin_khorne",
                "wh_main_sch_settlement_minor_coast_norscaruin_nurgle",
                "wh_main_sch_settlement_minor_coast_norscaruin_slaanesh",
                "wh_main_sch_settlement_minor_coast_norscaruin_tzeentch",
                "wh_main_sch_settlement_minor_norscaruin_khorne",
                "wh_main_sch_settlement_minor_norscaruin_nurgle",
                "wh_main_sch_settlement_minor_norscaruin_slaanesh",
                "wh_main_sch_settlement_minor_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_altdorf_norscaruin_khorne",
                "wh_main_sch_special_settlement_altdorf_norscaruin_nurgle",
                "wh_main_sch_special_settlement_altdorf_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_altdorf_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_black_crag_norscaruin_khorne",
                "wh_main_sch_special_settlement_black_crag_norscaruin_nurgle",
                "wh_main_sch_special_settlement_black_crag_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_black_crag_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_castle_drakenhof_norscaruin_khorne",
                "wh_main_sch_special_settlement_castle_drakenhof_norscaruin_nurgle",
                "wh_main_sch_special_settlement_castle_drakenhof_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_castle_drakenhof_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_couronne_norscaruin_khorne",
                "wh_main_sch_special_settlement_couronne_norscaruin_nurgle",
                "wh_main_sch_special_settlement_couronne_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_couronne_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_eight_peaks_norscaruin_khorne",
                "wh_main_sch_special_settlement_eight_peaks_norscaruin_nurgle",
                "wh_main_sch_special_settlement_eight_peaks_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_eight_peaks_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_karaz_a_karak_norscaruin_khorne",
                "wh_main_sch_special_settlement_karaz_a_karak_norscaruin_nurgle",
                "wh_main_sch_special_settlement_karaz_a_karak_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_karaz_a_karak_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_kislev_norscaruin_khorne",
                "wh_main_sch_special_settlement_kislev_norscaruin_nurgle",
                "wh_main_sch_special_settlement_kislev_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_kislev_norscaruin_tzeentch",
                "wh_main_sch_special_settlement_miragliano_norscaruin_khorne",
                "wh_main_sch_special_settlement_miragliano_norscaruin_nurgle",
                "wh_main_sch_special_settlement_miragliano_norscaruin_slaanesh",
                "wh_main_sch_special_settlement_miragliano_norscaruin_tzeentch"
        } --:vector<string>
        for i = 1, #new_buildings do
            table.insert(goc_settings.DF_CHAOS_PORTAL_BUILDING, new_buildings[i])
        end
        GOCLOG("MCM Added norscan ruin spawns!")
    end)
    cog:add_variable("spawn_rate", 2, 90, 10, 4, "Spawn Chance", "Chance to spawn an army"):add_callback(function(context)
        goc_settings.DF_CHAOS_SPAWN_CHANCE = context:get_mod("gates_of_chaos"):get_variable_with_key("spawn_rate"):current_value()
        GOCLOG("MCM Modified Spawn Rate to ["..goc_settings.DF_CHAOS_SPAWN_CHANCE.."]!")
    end)
    cog:add_variable("max_army_size", 5, 20, 14, 1, "Army Maximum Size", "Maximum potential size of a spawned army"):add_callback(function(context)
        local max = context:get_mod("gates_of_chaos"):get_variable_with_key("max_army_size"):current_value() - 1
        local mid = max - 2 
        local low = mid - 2
        goc_settings.DF_CHAOS_ARMY_SIZES = {low, mid, max}
        GOCLOG("MCM Modified Army Size to ["..max.."],["..mid.."],["..low.."]!")
    end)
end