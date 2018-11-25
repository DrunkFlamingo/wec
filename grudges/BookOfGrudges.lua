
--v function(text: any)
function GRULOG(text)
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


--# type global BOG_MISSION_REC = {mission: string, objective: CA_MISSION_OBJECTIVE, target: string, reward: string, victories: number?}


grudge_objective_list_faction = {

	---Thorgrim---
	["wh_main_dwf_dwarfs"] = {
		{mission = "df_grudge_01", objective = "CAPTURE_REGIONS", target = "wh_main_rib_peaks_mount_gunbad", reward = "df_rewards_01"},
		{mission = "df_grudge_02", objective = "CAPTURE_REGIONS", target = "wh_main_northern_worlds_edge_mountains_karak_ungor", reward = "df_rewards_02"},
		{mission = "df_grudge_03", objective = "CAPTURE_REGIONS", target = "wh_main_death_pass_karak_drazh", reward = "df_rewards_03"},
		{mission = "df_grudge_04", objective = "CAPTURE_REGIONS", target = "wh_main_eastern_badlands_karak_eight_peaks", reward = "df_rewards_04"},
		{mission = "df_grudge_05", objective = "CAPTURE_REGIONS", target = "wh_main_western_badlands_ekrund", reward = "df_rewards_05"},
		{mission = "df_grudge_06", objective = "CAPTURE_REGIONS", target = "wh_main_blightwater_karak_azgal", reward = "df_rewards_06"},
		{mission = "df_grudge_07", objective = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING", target = "wh2_main_skavenblight_skavenblight", reward = "df_rewards_07"},
		{mission = "df_grudge_08", objective = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING", target = "wh2_main_hell_pit_hell_pit", reward = "df_rewards_08"},
		{mission = "df_grudge_09", objective = "ELIMINATE_CHARACTER_IN_BATTLE", target = "wh2_main_def_naggarond", reward = "df_rewards_09"},
		{mission = "df_grudge_13", objective = "ELIMINATE_CHARACTER_IN_BATTLE", target = "wh_main_grn_greenskins", reward = "df_rewards_13"},
		{mission = "df_grudge_12", objective = "MOVE_TO_REGION", target = "wh2_main_southlands_worlds_edge_mountains_karak_zorn", reward = "df_rewards_12"}
	},

	--belegar
	["wh_main_dwf_karak_izor"] = {
	{mission = "df_grudge_10", objective = "ELIMINATE_CHARACTER_IN_BATTLE", target = "wh_main_grn_crooked_moon", reward = "df_rewards_10"},
	{mission = "df_grudge_11", objective = "ELIMINATE_CHARACTER_IN_BATTLE", target = "wh2_main_skv_clan_mors", reward = "df_rewards_11"}
	},
	
	--Cataph's Norse Dwarves.
	
	["wh_main_dwf_kraka_drak"] = {
	{mission = "df_grudge_14", objective = "DEFEAT_N_ARMIES_OF_FACTION", target = "wh_main_sc_nor_norsca", reward = "df_rewards_14", victories = 15},
	{mission = "df_grudge_15", objective = "DEFEAT_N_ARMIES_OF_FACTION", target = "wh_main_sc_chs_chaos", reward = "df_rewards_15", victories = 5},
	{mission = "df_grudge_16", objective = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING", target = "wh2_main_aghol_wastelands_fortress_of_the_damned", reward = "df_rewards_16"},
	{mission = "df_grudge_17", objective = "CAPTURE_REGIONS", target = "wh_main_mountains_of_hel_aeslings_conclave", reward = "df_rewards_17"},
	{mission = "df_grudge_18", objective = "CAPTURE_REGIONS", target = "wh_main_mountains_of_hel_altar_of_spawns", reward = "df_rewards_18"},
	{mission = "df_grudge_19", objective = "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING", target = "wh2_main_hell_pit_hell_pit", reward = "df_rewards_19"}
	},
} --:map<string, vector<BOG_MISSION_REC>>

GRULOG("we made it past these questionable ass lists");



--v function(faction_key: string)
local function grudge_issuer(faction_key)

	--disable all events before triggering grudges.
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
	GRULOG("The issuer function is running");

	grudge_objective_list = nil --:vector<BOG_MISSION_REC>
	if grudge_objective_list_faction[faction_key] ~= nil then
		grudge_objective_list = grudge_objective_list_faction[faction_key];
		GRULOG("found a list for your faction, proceeding");
	else
		GRULOG("can't find a list for your faction");
		cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
	end

	local grudge_list_count = #grudge_objective_list;
	
	for i = 1, grudge_list_count do
		
		grudge_objective_number = i;
		
		local grudge_objective = grudge_objective_list[grudge_objective_number];
		
		local mm = mission_manager:new(faction_key, grudge_objective.mission);
		
		mm:add_new_objective(grudge_objective.objective);
		mm:set_mission_issuer("BOOK_NAGASH");
		
		if grudge_objective.objective == "CAPTURE_REGIONS" then
			mm:add_condition("region "..grudge_objective.target);
		elseif grudge_objective.objective == "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING" then
			mm:add_condition("region "..grudge_objective.target);
			mm:add_condition("total 1");
		elseif grudge_objective.objective == "ELIMINATE_CHARACTER_IN_BATTLE" then
			mm:add_condition("faction "..grudge_objective.target);
		elseif grudge_objective.objective == "MOVE_TO_REGION" then
			mm:add_condition("region "..grudge_objective.target);
        elseif grudge_objective.objective == "DEFEAT_N_ARMIES_OF_FACTION" then
            --# assume grudge_objective.victories: number
			mm:add_condition("subculture "..grudge_objective.target);
			mm:add_condition("total "..grudge_objective.victories);
		end
		
		mm:add_payload("effect_bundle{bundle_key "..grudge_objective.reward..";turns 0;}");
		mm:set_should_cancel_before_issuing(false);
		mm:trigger();
	end

	GRULOG("missions should have all triggered, turning the event feed back on!");
	cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
	
	GRULOG("if you've gotten here, the dwarf missions function reached the end of its commands");	
end;


--v function()
local function df_diplomacy_setup()
	cm:force_diplomacy("culture:wh_main_dwf_dwarfs", "culture:wh_main_dwf_dwarfs", "form confederation", false, false, true);
	cm:apply_effect_bundle("df_hidden_agrund_buff", "wh_main_dwf_karak_izor", 0);
	GRULOG("df_grudges diplomacy set: dwarves shouldn't be able to confederate anymore!");
	cm:set_saved_value("saved_grudge_completed", 0);
end;




--v function(context: WHATEVER)
local function grudge_rewards(context)

	local faction_key = context:faction():name() --:string
	local mission_key = context:mission():mission_record_key() 
	if cm:get_saved_value("saved_grudge_completed") == nil then
		cm:set_saved_value("saved_grudge_completed", 0);
	end
	local grudge_completed_old = cm:get_saved_value("saved_grudge_completed");

	if mission_key:starts_with("df_grudge_") then
		grudge_completed_new = grudge_completed_old + 1;
		cm:set_saved_value("saved_grudge_completed", grudge_completed_new);
		if mission_key:starts_with("df_grudge_02") then
			cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh_main_dwf_karak_kadrin", "form confederation", true, true, true);
		elseif mission_key:starts_with("df_grudge_03") then
			cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh_main_dwf_karak_azul", "form confederation", true, true, true);
		elseif mission_key:starts_with("df_grudge_04") then
			cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh_main_dwf_karak_izor", "form confederation", true, true, true);
		elseif mission_key:starts_with("df_grudge_13") then
			cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh_main_dwf_barak_varr", "form confederation", true, true, true);
		elseif mission_key:starts_with("df_grudge_12") then
			cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh2_main_dwf_karak_zorn", "form confederation", true, true, true);
		end	
	elseif mission_key:starts_with("wh_dlc06_grudge_belegar_eight_peaks") then
		cm:force_diplomacy("faction:wh_main_dwf_karak_izor", "culture:wh_main_dwf_dwarfs", "form confederation", true, true, true);
		cm:remove_effect_bundle("df_hidden_agrund_buff", "wh_main_dwf_karak_izor");
	end
	
	if grudge_completed_new >= 6 and faction_key == "wh_main_dwf_dwarfs" then
		cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh2_main_dwf_karak_hirn", "form confederation", true, true, true);
		cm:force_diplomacy("faction:wh_main_dwf_dwarfs", "faction:wh2_main_dwf_zhufbar", "form confederation", true, true, true);
		cm:apply_effect_bundle("df_rewards_age_of_reckoning", faction_key, 0);
	end
end;
core:add_listener(
	"Grudge_Succeeded",
	"MissionSucceeded",
	true,
	function(context)
		GRULOG("Grudge_Succeeded listener fired")
		grudge_rewards(context);
	end,
	true);






cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
	GRULOG("the grudges custom script launched");
	cm:set_saved_value("df_grudges_dwf", true);
	

	if cm:is_new_game() == true then
		if cm:get_faction("wh_main_dwf_dwarfs"):is_human() then 
			grudge_issuer("wh_main_dwf_dwarfs");
			df_diplomacy_setup();
		elseif cm:get_faction ("wh_main_dwf_karak_izor"):is_human() then 
			grudge_issuer("wh_main_dwf_karak_izor");
			df_diplomacy_setup();
		elseif cm:get_saved_value("Cataph_Kraka_Drak") == true and cm:get_faction ("wh_main_dwf_kraka_drak"):is_human() then
			grudge_issuer("wh_main_dwf_kraka_drak");
		end
	end
end
