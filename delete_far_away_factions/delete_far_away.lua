--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
	return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;



local leave_alive = {
	--bretonnians
	"wh_main_brt_bretonnia",
	"wh_main_brt_carcassonne",
	--dwarfs
	"wh_main_dwf_dwarfs",
	"wh_main_dwf_karak_izor",
	--empire
	"wh_main_emp_empire",
	"wh_main_emp_middenland",
	--greenskins
	"wh_main_grn_crooked_moon",
	"wh_main_grn_greenskins",
	"wh_main_grn_orcs_of_the_bloody_hand",
	-- vampire counts
	"wh_main_vmp_schwartzhafen",
	"wh_main_vmp_vampire_counts",
	--skaven
	"wh2_dlc09_skv_clan_rictus",
	"wh2_main_skv_clan_mors",
	"wh2_main_skv_clan_pestilens",
	--tomb kings
	"wh2_dlc09_tmb_exiles_of_nehek",
	"wh2_dlc09_tmb_followers_of_nagash",
	"wh2_dlc09_tmb_khemri",
	"wh2_dlc09_tmb_lybaras",
	--dark elves
	"wh2_main_def_naggarond",
	"wh2_main_def_har_ganeth",
	"wh2_main_def_cult_of_pleasure",
	--high elves
	"wh2_main_hef_order_of_loremasters",
	"wh2_main_hef_eataine",
	"wh2_main_hef_nagarythe",
	"wh2_main_hef_avelorn",
	--lizardmen
	"wh2_main_lzd_last_defenders",
	"wh2_main_lzd_hexoatl",
	"wh2_main_lzd_itza",
	--norsca
	"wh_dlc08_nor_wintertooth",
	--kislev
	"wh_main_ksl_kislev",
	--dwarves
	"wh_main_dwf_karak_kadrin",
	"wh2_main_dwf_karak_zorn",
	"wh_main_dwf_kraka_drak",
	"wh_main_dwf_barak_varr",
	"wh_main_dwf_karak_azul",
	--empire
	"wh_main_emp_averland",
	"wh_main_emp_marienburg",
	"wh_main_emp_cult_of_ulric",
	"wh_main_emp_cult_of_sigmar",
	--greenskins
	"wh_main_grn_red_eye",
	"wh_main_grn_red_fangs",
	"wh_main_grn_necksnappers_waaagh",
	"wh_main_grn_orcs_of_the_bloody_hand_waaagh",
	"wh_main_grn_red_eye_waaagh",
	"wh_main_grn_red_fangs_waaagh",
	"wh_main_grn_greenskins_waaagh",
	"wh_main_grn_skullsmasherz_waaagh",
	"wh_main_grn_scabby_eye_waaagh",
	"wh_main_grn_teef_snatchaz_waaagh",
	"wh_main_grn_crooked_moon_waaagh",
	"wh_main_grn_broken_nose_waaagh",
	"wh_main_grn_black_venom_waaagh",
	"wh_main_grn_bloody_spearz_waaagh",
	--teb
	"wh_main_teb_border_princes",
	"wh_main_teb_estalia",
	"wh_main_teb_tilea",
	"wh2_main_emp_new_world_colonies",
	"wh2_main_emp_pirates_of_sartosa",
	"wh2_main_emp_sudenburg",
	"wh_main_teb_bilbali",
	"wh_main_teb_lichtenburg_confederacy",
	"wh_main_teb_magritta",
	"wh_main_teb_tobaro",
	--dark elves
	"wh2_main_def_scourge_of_khaine",
	"wh2_main_def_hag_graef",
	"wh2_main_def_karond_kar",
	--wood elves
	"wh_dlc05_wef_torgovann",
	"wh_dlc05_wef_wood_elves",
	"wh_dlc05_wef_wydrioth",
	"wh_dlc05_wef_argwylon",
	--high elves
	
	"wh2_main_hef_caledor",
	"wh2_main_hef_chrace",
	"wh2_main_hef_saphery",
	"wh2_main_hef_tiranoc",
	"wh2_main_hef_cothique",
	"wh2_main_hef_ellyrion",
	"wh2_main_hef_yvresse",
	--lizardmen
	"wh2_main_lzd_xlanhuapec",
	--norsca
	"wh2_main_nor_skeggi",
	"wh_dlc08_nor_norsca",
	--skaven
	"wh2_main_skv_clan_eshin",
	"wh2_main_skv_clan_skyre",
	"wh2_main_skv_clan_moulder",
	-- vampire counts
	"wh2_main_vmp_vampire_coast",
	"wh_main_vmp_mousillon",
	--chaos
	"wh_main_chs_chaos"
} --:vector<string>





function delete_far_away()
    if cm:is_multiplayer() then
        return
    end
	local whitelist = {} --:map<string, boolean>
	for i = 1, #leave_alive do
		whitelist[leave_alive[i]] = true
	end

	local region_list = cm:model():world():region_manager():region_list()
	local home_faction = cm:get_faction(cm:get_local_faction(true)):home_region():settlement()
	local x, y = home_faction:logical_position_x(), home_faction:logical_position_y()
	local factions = {} --:map<string, boolean>
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if not (region:owning_faction():is_null_interface() or region:settlement():is_null_interface()) then
			local distance = distance_2D(x, y, region:settlement():logical_position_x(), region:settlement():logical_position_y())
			local faction = region:owning_faction():name()
			if distance > 275 then
				if factions[faction] == nil then
					factions[faction] = true
				end
			else
				factions[faction] = false
			end
		end
	end

	for faction_name, kill in pairs(factions) do
		if kill and (not whitelist[faction_name]) then
			local faction = cm:get_faction(faction_name)
			local regions = faction:region_list()
			for i = 0, regions:num_items() - 1 do
				cm:callback(function()
					cm:set_region_abandoned(regions:item_at(i):name())
				end, (i+1)/10)
			end
			local characters = faction:character_list()
			for i = 0, characters:num_items() - 1 do
				if cm:char_is_mobile_general_with_army(characters:item_at(i)) then
					cm:callback(function()
						cm:kill_character(characters:item_at(i):cqi(), true, true)
					end, (i+1)/10)
				end
			end
		end
	end
end