--Log script to text
--v function(text: string | number | boolean | CA_CQI)
local function out(text)
	if not __write_output_to_logfile then
		return;
	end

	local logText = tostring(text)
	local logTimeStamp = os.date("%d, %m %Y %X")
	local popLog = io.open("warhammer_expanded_log.txt","a")
	--# assume logTimeStamp: string
	popLog :write("EX :  [".. logTimeStamp .. "]:  "..logText .. "  \n")
	popLog :flush()
	popLog :close()
end

local Loyalty_trait = {
	wh2_dlc11_sc_cst_vampire_coast = "wh2_dlc11_trait_incentive",
	wh2_main_sc_skv_skaven = "wec_loyalty_trait_skv",
	wh2_main_sc_def_dark_elves = "wec_loyalty_trait_def"
	}
local Loyalty_counter_trait = {
	wh2_dlc11_sc_cst_vampire_coast = "wh2_dlc11_trait_incentive_counter",
	wh2_main_sc_skv_skaven = "wec_loyalty_trait_skv_counter",
	wh2_main_sc_def_dark_elves = "wec_loyalty_trait_def_counter"
	}
local Vampire_coast_subculture = {
	wh2_dlc11_sc_cst_vampire_coast = true,
	wh2_main_sc_skv_skaven = true,
	wh2_main_sc_def_dark_elves = true
	}
local Campaign_started = false;

local Psychological_disorder_index = {"murderer", "looter", "arsonist", "smuggler", "schemer", "ringleader", "tech_leader", "tech_vigour", "tech_seacraft", "tech_renown"};			

local Loyalty_rite_key = "wh2_dlc11_ritual_cst_eternal_service";
local Loyalty_skill_key = "wh2_dlc11_skill_cst_loyal_lord";

local Psychological_disorder = {
							[Psychological_disorder_index[1]] = {"wh2_dlc11_skill_innate_cst_murderer", "brute"},
							[Psychological_disorder_index[2]] = {"wh2_dlc11_skill_innate_cst_looter", "brute"},
							[Psychological_disorder_index[3]] = {"wh2_dlc11_skill_innate_cst_arsonist", "brute"},
							[Psychological_disorder_index[4]] = {"wh2_dlc11_skill_innate_cst_smuggler", "mastermind"},
							[Psychological_disorder_index[5]] = {"wh2_dlc11_skill_innate_cst_schemer", "mastermind"},
							[Psychological_disorder_index[6]] = {"wh2_dlc11_skill_innate_cst_ringleader", "mastermind"},
							[Psychological_disorder_index[7]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_01", "mastermind"},
							[Psychological_disorder_index[8]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_02", "brute"},
							[Psychological_disorder_index[9]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_03", "mastermind"},
							[Psychological_disorder_index[10]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_04", "mastermind"}
							};



local Vampire_coast_lord_type = {	
	wh2_dlc11_cst_admiral = true, 
	wh2_dlc11_cst_admiral_death = true, 
	wh2_dlc11_cst_admiral_deep = true, 
	wh2_dlc11_cst_admiral_fem = true, 
	wh2_dlc11_cst_admiral_fem_death = true, 
	wh2_dlc11_cst_admiral_fem_deep = true, 
	wh2_main_def_dreadlord = true, 
	wh2_main_def_dreadlord_fem = true, 
	wh2_dlc10_def_supreme_sorceress_beasts = true, 
	wh2_dlc10_def_supreme_sorceress_dark = true, 
	wh2_dlc10_def_supreme_sorceress_death = true, 
	wh2_dlc10_def_supreme_sorceress_fire = true, 
	wh2_dlc10_def_supreme_sorceress_shadow = true,

							} --:map<string, boolean>

local Vampire_coast_tech_lord_type = {	
							};

							
local Loyalty_decline_rate = {
						["brute"] = 20, 
						["mastermind"] = 10
						};		

local default_pos = 100;		

local Loyalty_thresholds = {
						["high"] = 10, 
						["mid_high"] = 8, 
						["mid"] = 6, 
						["mid_low"] = 4, 
						["low"] = 2
}		

--the change rate table, including DECLINE_RATE, WINNING_BATTLE, KILLING_GENERAL, FIGHTING_WITH_REINFORCEMENT, WINNING_SIEGE_BATTLE, RAZING_CITY, SACKING_CITY, BUILDING_COVES, RAID_STANCE, 
local Psychological_loyalty_change_rate_index = { "decline_rate", "win_battle", "kill_general", "raid_stance", "sack_city", "raze_city", "win_siege_battle", "build_coves", "ask_ransom", 
											"ambush", "lightening", "recruit", "fight_with_reinforcement"
											};

local Psychological_loyalty_change_rate = {
									["murderer"] = {
													["decline_rate"] = {Loyalty_decline_rate["brute"], -1}, 
													["win_battle"] = {100, 1}, 
													["kill_general"] = {100, 1}
													},
									["looter"] = {
													["decline_rate"] = {Loyalty_decline_rate["brute"], -1}, 
													["win_battle"] = {100, 1}, 
													["raid_stance"] = {50, 1}, 
													["sack_city"] = {100, 1}
													},
									["arsonist"] = {
													["decline_rate"] = {Loyalty_decline_rate["brute"], -1}, 
													["win_battle"] = {100, 1}, 
													["raze_city"] = {100, 1}, 
													["win_siege_battle"] = {100, 1}
													},
									["smuggler"] = {
													["decline_rate"] = {Loyalty_decline_rate["mastermind"], -1}, 
													["build_coves"] = {100, 2}, 
													["ask_ransom"] = {100, 1}
													},
									["schemer"] = {
													["decline_rate"] = {Loyalty_decline_rate["mastermind"], -1}, 
													["ambush"] = {100, 2}, 
													["lightening"] = {100, 2}
													},
									["ringleader"] = {
													["decline_rate"] = {Loyalty_decline_rate["mastermind"], -1}, 
													["recruit"] = {100, 1}, 
													["fight_with_reinforcement"] = {100, 1}
													},
									["tech_leader"] = {
													},
									["tech_vigour"] = {
													},
									["tech_seacraft"] = {
													},
									["tech_renown"] = {
													}													
									};
									
local Loyalty_change_rate = {
						["post_battle_share"] = {100, 1},
						["post_siege_battle_share"] = {100, 1},
						["loyalty_rite"] = {50, 1}
};

local Edict_key = "wh2_dlc11_edict_cst_share_the_spoils";

function Clear_and_set_trait(character, trait, counter_trait, num)
	local our_trait = Loyalty_trait[character:faction():subculture()]
	local our_antitrait = Loyalty_counter_trait[character:faction():subculture()]
	local current_loyalty = character:loyalty();
	out("trait_level"..character:trait_points(our_trait));
	out("anti_trait_level"..character:trait_points(our_antitrait));
	out("modifiying by "..num)
	if character:trait_points(counter_trait) ~= 0 then
		out("goes to the 1st if");
		cm:force_add_trait(cm:char_lookup_str(character), trait, false, character:trait_points(counter_trait), false);
	elseif character:trait_points(trait) ~= 0 then
		out("goes to the 2nd if");
		cm:force_add_trait(cm:char_lookup_str(character), counter_trait, false, character:trait_points(trait), false);
	end
	cm:force_add_trait(cm:char_lookup_str(character), trait, false, num, false);
end
							
function Update_trait(character)
	if Background_check_vampire_coast_player_lord(character) or Background_check_vampire_coast_player_techno_vikings(character) then 
		out("has loyalty trait? ".."yes");
		local our_trait = Loyalty_trait[character:faction():subculture()]
		local our_antitrait = Loyalty_counter_trait[character:faction():subculture()]
		local current_loyalty = character:loyalty();
		local current_trait = character:trait_points(our_trait);
		local current_counter_trait = character:trait_points(our_antitrait);
		out("trait_level"..character:trait_points(our_trait));
		out("anti_trait_level"..character:trait_points(our_antitrait));
		if current_loyalty <= Loyalty_thresholds["low"] then
			Clear_and_set_trait(character, our_antitrait, our_trait, 2);
		elseif current_loyalty <= Loyalty_thresholds["mid_low"] then
			Clear_and_set_trait(character, our_antitrait, our_trait, 1);	
		elseif current_loyalty <= Loyalty_thresholds["mid"]then
			Clear_and_set_trait(character, our_trait, our_antitrait, 1);
		elseif current_loyalty <= Loyalty_thresholds["mid_high"] then
			Clear_and_set_trait(character, our_trait, our_antitrait, 2);
		elseif current_loyalty <= Loyalty_thresholds["high"] then
			Clear_and_set_trait(character, our_trait, our_antitrait, 3);
		end
		cm:callback(function() out("trait_level"..character:trait_points(our_trait)) end, 1);
		cm:callback(function() out("anti_trait_level"..character:trait_points(our_antitrait)) end, 1);
	else
		out("has loyalty trait? ".."no");
	end
end

function Add_trait(character)
	local loyalty = character:loyalty();	
	--cm:force_add_trait(cm:char_lookup_str(character), our_trait, false, 1);
	out("adding trait to general!");
	Update_trait(character);
end

function Background_check_vampire_coast_player_lord(character)
	if character:is_null_interface() == false and character:faction():is_human() and (not not Vampire_coast_subculture[character:faction():subculture()]) and cm:char_is_general_with_army(character) and character:has_military_force() and character:military_force():is_armed_citizenry() == false then
		return not not Vampire_coast_lord_type[character:character_subtype_key()]
	else
		return false;
	end
end

function Background_check_vampire_coast_player_techno_vikings(character)
	if character:is_null_interface() == false and character:faction():is_human() and (not not Vampire_coast_subculture[character:faction():subculture()]) and cm:char_is_general_with_army(character) and character:has_military_force() and character:military_force():is_armed_citizenry() == false then
		local Antimemetic = false;
		for i=1, #Vampire_coast_lord_type do
			if character:character_subtype_key() == Vampire_coast_tech_lord_type[i] then
				return true;
			end
		end
		return false;
	else
		return false;
	end
end

function Modify_loyalty(character, points, possibility)
	-- increase character loyalty by points at possibility
	local roll = cm:random_number(100);
	local faction_name = character:faction():name();
	local previous_loyalty = character:loyalty();
	if possibility == nil then
		possibility = default_pos;
	end
	if roll <= possibility then
		-- increase loyalty by points
		out("modifying loyalty by "..points);
		cm:modify_character_personal_loyalty_factor(cm:char_lookup_str(character), points);
		Update_trait(character);
	end
	if previous_loyalty > Loyalty_thresholds["mid_low"] and character:loyalty() <= Loyalty_thresholds["mid_low"] then
	cm:show_message_event_located(
						faction_name,
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_title",
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_low_primary_detail",
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_low_secondary_detail",
						character:logical_position_x(),
						character:logical_position_y(),
						false,
						1117
						);	
	elseif character:loyalty() > Loyalty_thresholds["low"] and character:loyalty() <= Loyalty_thresholds["low"] then 
						cm:show_message_event_located(
						faction_name,
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_title",
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_critical_primary_detail",
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_critical_secondary_detail",
						character:logical_position_x(),
						character:logical_position_y(),
						false,
						1115
						);	
	elseif character:loyalty() <= Loyalty_thresholds["high"] and character:loyalty() > Loyalty_thresholds["high"] then
						cm:show_message_event_located(
						faction_name,
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_title",
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_office_ready_primary_detail",
						"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_office_ready_secondary_detail",
						character:logical_position_x(),
						character:logical_position_y(),
						false,
						1116
						);	
	end
end

function Return_psychological_disorder(character)
	for i=1, #Psychological_disorder_index do
		if character:has_skill(Psychological_disorder[Psychological_disorder_index[i]][1]) then
			local temp = Psychological_disorder[Psychological_disorder_index[i]];
			table.insert(temp, #temp+1, Psychological_disorder_index[i])
			return temp;
		end
	end
	return false;
end

function Modify_loyalty_on_event(character, event)
	local psychological_disorder = Return_psychological_disorder(character);
	if Psychological_loyalty_change_rate[psychological_disorder[3]][event] ~= nil then
		local ok, err = pcall( function()
			Modify_loyalty(character, Psychological_loyalty_change_rate[psychological_disorder[3]][event][2], Psychological_loyalty_change_rate[psychological_disorder[3]][event][1]);
		end)
		if not ok then
			out("Error!")
			out(err)
		end
	end
end

--everyone gains trait when created
events.CharacterCreated[#events.CharacterCreated+1] = 
function(context)
	local character = context:character();
	local ok, err = pcall( function()
		if Background_check_vampire_coast_player_lord(character) or Background_check_vampire_coast_player_techno_vikings(character) then
			Add_trait(character);
		end
	end)
	if not ok then
		out("Error!")
		out(err)
	end
end

--everyone loyalty decline
events.CharacterTurnStart[#events.CharacterTurnStart+1] = 
function(context)
	local ok, err = pcall(function()
		local character = context:character();
		-- loyalty decline
		if Background_check_vampire_coast_player_lord(character) then 
			if character:faction():has_effect_bundle(Loyalty_rite_key) then
				Modify_loyalty(character, Loyalty_change_rate["loyalty_rite"][2], Loyalty_change_rate["loyalty_rite"][1]);
				out("loyalty decline declined by decline declining rite");
			elseif character:region():is_null_interface() ~= true and character:region():get_active_edict_key() == Edict_key then
				out("loyalty decline declined by decline declining edict");
			elseif character:has_skill(Loyalty_skill_key) then 
				out("loyalty decline declined by decline declining skill");
			elseif Background_check_vampire_coast_player_techno_vikings(character) then
				out("loyalty decline declined by decline declining subtype");
			else
				local disorder = Return_psychological_disorder(character);
				Modify_loyalty_on_event(character, "decline_rate");
			end
		end
	end)
	if not ok then
		out("Error!")
		out(err)
	end
end

--check post siege option
events.CharacterPerformsSettlementOccupationDecision[#events.CharacterPerformsSettlementOccupationDecision+1] = 
function(context)
	local character = context:character();
	-- check the occupation options
	if Background_check_vampire_coast_player_lord(character) then
		if context:occupation_decision() == "1256143616" then
			--increase loyalty by chance
			Modify_loyalty_on_event(character, "raze_city");
		end
		if context:occupation_decision() == "615256079" then
			--increase loyalty by chance
			Modify_loyalty_on_event(character, "build_coves");
		end
		if context:occupation_decision() == "1262847535" then
			--increase loyalty by chance
			Modify_loyalty_on_event(character, "sack_city");
		end
		if context:occupation_decision() == "658757632" then
			Modify_loyalty(character, Loyalty_change_rate["post_siege_battle_share"][2], Loyalty_change_rate["post_siege_battle_share"][1]);
		end
	end
	--check techno vikings
	if Background_check_vampire_coast_player_techno_vikings(character) then
		if context:occupation_decision() == "658757632" then
			Modify_loyalty(character, Loyalty_change_rate["post_siege_battle_share"][2], Loyalty_change_rate["post_siege_battle_share"][1]);
		end
	end
end

--check post-battle loot option
events.CharacterPostBattleSlaughter[#events.CharacterPostBattleSlaughter+1] =
function(context)
	local character = context:character();
	if Background_check_vampire_coast_player_lord(character) then
		-- increase loyalty by chance
		Modify_loyalty(character, Loyalty_change_rate["post_battle_share"][2], Loyalty_change_rate["post_siege_battle_share"][1]);
	end
	if Background_check_vampire_coast_player_techno_vikings(character) then
		-- increase loyalty by chance
		Modify_loyalty(character, Loyalty_change_rate["post_battle_share"][2], Loyalty_change_rate["post_siege_battle_share"][1]);
	end
end

--check raiding stance and recruit
events.CharacterTurnEnd[#events.CharacterTurnEnd+1] =
function(context)
	local character = context:character();
	if character:has_military_force() and not character:military_force():is_null_interface() then
		local stance = character:military_force():active_stance();
		if Background_check_vampire_coast_player_lord(character) and character:has_skill(Psychological_disorder["looter"][1]) then
			if(stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING") then
			-- increase loyalty by chance
				Modify_loyalty_on_event(character, "raid_stance");
			end
		elseif Background_check_vampire_coast_player_lord(character) and character:has_skill(Psychological_disorder["ringleader"][1]) then
			out("checking the instigators");
			out(stance);
			if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MUSTER" then
				Modify_loyalty_on_event(character, "recruit");
			end
		end
	end
end

--recruit unit

-- events.CharacterSelected[#events.CharacterSelected+1] =
-- function(context)
	-- Campaign_started = true;
-- end

-- events.UnitCreated[#events.UnitCreated+1] =
-- function(context)
	-- local unit = context:unit();
	-- out("1");
	-- out(Campaign_started);
	-- out(unit:unit_key());
	--out(unit:military_force():has_general());
	-- if Campaign_started and unit:has_force_commander() then
	--if Campaign_started and unit:military_force():has_general() and Background_check_vampire_coast_player_lord(unit:military_force():general_character()) then
		-- output("2");
		--Modify_loyalty_on_event(unit:military_force():general_character(), "recruit");
	-- end
-- end

--post battle stuff check

events.BattleCompleted[#events.BattleCompleted+1] = 
function(context)
	local Vampire_coast_lord = {
								["attacker"] = {},
								["defender"] = {}
								};
	local Lord_wounded = {
								["attacker"] = false,
								["defender"] = false
								};
	
	if cm:pending_battle_cache_num_attackers() >= 1 then
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
			local character = cm:model():character_for_command_queue_index(this_char_cqi);
			if Background_check_vampire_coast_player_lord(character) then
				table.insert(Vampire_coast_lord["attacker"], this_char_cqi);
			end
			if character:is_null_interface() or character:is_wounded() then
				Lord_wounded["defender"] = true;
			end
		end
	end
	
	if cm:pending_battle_cache_num_defenders() >= 1 then
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
			local character = cm:model():character_for_command_queue_index(this_char_cqi);
			if Background_check_vampire_coast_player_lord(character) then
				table.insert(Vampire_coast_lord["defender"], this_char_cqi);
			end
			if character:is_null_interface() or character:is_wounded() then
				Lord_wounded["attacker"] = true;
			end
		end
	end
	
	-- check traits
	--out("checking traits");
	--out(cm:model():pending_battle():night_battle());
	Check_and_update_post_battle_traits(Vampire_coast_lord["attacker"], Lord_wounded["attacker"]);
	Check_and_update_post_battle_traits(Vampire_coast_lord["defender"], Lord_wounded["defender"]);
	
end

function Check_and_update_post_battle_traits(group, group_2)
		for i, cqi in ipairs(group) do
			local character = cm:model():character_for_command_queue_index(cqi);
			if character:won_battle() then
				if character:has_skill(Psychological_disorder["schemer"][1]) and cm:model():pending_battle():night_battle() then
					--increase loyalty by chance
					out("checking lightening strikes");
					Modify_loyalty_on_event(character, "lightening");
				end
				if character:has_skill(Psychological_disorder["schemer"][1]) and character:is_ambushing() then
					--increase loyalty by chance
					Modify_loyalty_on_event(character, "ambush");
				end
				if character:has_skill(Psychological_disorder["ringleader"][1]) and (#group > 1) then
					--increase loyalty by chance
					Modify_loyalty_on_event(character, "fight_with_reinforcement");
				end
				if character:has_skill(Psychological_disorder["murderer"][1]) and (group_2 == true) then
					--increase loyalty by chance
					Modify_loyalty_on_event(character, "kill_general");
				end
				if character:has_skill(Psychological_disorder["arsonist"][1]) and cm:model():pending_battle():seige_battle() then
					--increase loyalty by chance
					Modify_loyalty_on_event(character, "win_siege_battle");
					out("4");
				end
				if Return_psychological_disorder(character)[2] == "brute" then
					Modify_loyalty_on_event(character, "win_battle");
					out("5");
				end
			end
		end
end
