local exile_manager = _G.exile_manager


--content
exile_manager:enable_culture_as_recipient("wh_main_sc_emp_empire")
exile_manager:enable_culture_as_recipient("wh_main_sc_brt_bretonnia")
exile_manager:enable_culture_as_recipient("wh2_main_sc_hef_high_elves")
exile_manager:enable_culture_as_recipient("wh_main_sc_dwf_dwarfs")
exile_manager:add_button_to_disable({"layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "rank", "skills", "skill_button"})
exile_manager:add_button_to_disable({"layout", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general"})
exile_manager:add_button_to_disable({"layout", "BL_parent", "land_stance_button_stack"})
exile_manager:add_button_to_disable({"layout", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_recruitment"})
exile_manager:add_button_to_disable({"layout", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_renown"})

--high elves
exile_manager:add_faction("wh2_main_hef_avelorn", "wec_exiles_dilemma_wh2_main_hef_avelorn", 
{
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_dlc10_hef_inf_sisters_of_avelorn_0",
    "wh2_dlc10_hef_inf_sisters_of_avelorn_0",
    "wh2_dlc10_hef_inf_sisters_of_avelorn_0",
    "wh2_dlc10_hef_mon_treekin_0",
    "wh2_dlc10_hef_mon_treekin_0"
}, "wh2_dlc10_hef_alarielle", "names_name_898828143", "")
exile_manager:add_faction("wh2_main_hef_eataine", "wec_exiles_dilemma_wh2_main_hef_eataine", 
{
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_white_lions_of_chrace_0",
    "wh2_main_hef_inf_white_lions_of_chrace_0"
}, "wh2_main_hef_tyrion", "names_name_2147360906", "names_name_2147360506")
exile_manager:add_faction("wh2_main_hef_order_of_loremasters", "wec_exiles_dilemma_wh2_main_hef_order_of_loremasters", 
{
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_inf_archers_0",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_inf_swordmasters_of_hoeth_0",
    "wh2_main_hef_inf_swordmasters_of_hoeth_0",
    "wh2_main_hef_inf_swordmasters_of_hoeth_0",
    "wh2_main_hef_mon_phoenix_frostheart",
    "wh2_main_hef_mon_phoenix_frostheart"
}, "wh2_main_hef_teclis", "names_name_2147359256", "names_name_2147360506")
--karl frunz
exile_manager:add_faction("wh_main_emp_empire", "wec_exiles_dilemma_wh_main_emp_empire", 
{
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_inf_handgunners",
    "wh_main_emp_inf_handgunners",
    "wh_main_emp_inf_handgunners",
    "wh_main_emp_cav_reiksguard",
    "wh_main_emp_cav_reiksguard",
    "wh_main_emp_cav_reiksguard",
    "wh_main_emp_inf_greatswords",
    "wh_main_emp_inf_greatswords",
    "wh_main_emp_inf_greatswords",
    "wh_main_emp_art_great_cannon",
    "wh_main_emp_art_great_cannon"
}, "emp_karl_franz", "names_name_2147343849", "names_name_2147343858")
exile_manager:add_faction("wh_main_brt_carcassonne", "wec_exiles_dilemma_wh_main_brt_carcassonne", 
{
    "wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_battle_pilgrims_0",
    "wh_dlc07_brt_inf_battle_pilgrims_0",
    "wh_dlc07_brt_inf_battle_pilgrims_0",
    "wh_main_brt_inf_peasant_bowmen",
    "wh_dlc07_brt_inf_peasant_bowmen_1",
    "wh_dlc07_brt_inf_peasant_bowmen_2",
    "wh_main_brt_cav_knights_of_the_realm",
    "wh_main_brt_cav_knights_of_the_realm",
    "wh_main_brt_cav_knights_of_the_realm",
    "wh_dlc07_brt_cav_grail_guardians_0",
    "wh_dlc07_brt_cav_grail_guardians_0",
    "wh_dlc07_brt_cav_grail_guardians_0",
    "wh_dlc07_brt_art_blessed_field_trebuchet_0",
    "wh_dlc07_brt_art_blessed_field_trebuchet_0"
}, "dlc07_brt_fay_enchantress", "names_name_2147358931", "names_name_2147359018")
exile_manager:add_faction("wh_main_brt_bretonnia", "wec_exiles_dilemma_wh_main_brt_bretonnia", 
{
    "wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_battle_pilgrims_0",
    "wh_dlc07_brt_inf_battle_pilgrims_0",
    "wh_dlc07_brt_inf_battle_pilgrims_0",
    "wh_main_brt_inf_peasant_bowmen",
    "wh_dlc07_brt_inf_peasant_bowmen_1",
    "wh_dlc07_brt_inf_peasant_bowmen_2",
    "wh_main_brt_cav_knights_of_the_realm",
    "wh_main_brt_cav_knights_of_the_realm",
    "wh_main_brt_cav_knights_of_the_realm",
    "wh_main_brt_cav_grail_knights",
    "wh_main_brt_cav_grail_knights",
    "wh_main_brt_cav_grail_knights",
    "wh_dlc07_brt_art_blessed_field_trebuchet_0",
    "wh_dlc07_brt_art_blessed_field_trebuchet_0"
}, "brt_louen_leoncouer", "names_name_2147343915", "names_name_2147343917")
exile_manager:add_faction("wh_main_dwf_dwarfs", "wec_exiles_dilemma_wh_main_dwf_dwarfs", 
{
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_inf_ironbreakers",
    "wh_main_dwf_inf_ironbreakers",
    "wh_main_dwf_inf_ironbreakers",
    "wh_main_dwf_veh_gyrocopter_0",
    "wh_main_dwf_veh_gyrocopter_0"
}, "dwf_thorgrim_grudgebearer", "names_name_2147343883", "names_name_2147343884")
exile_manager:add_faction("wh_main_dwf_karak_kadrin", "wec_exiles_dilemma_wh_main_dwf_karak_kadrin", 
{
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_inf_slayers",
    "wh_main_dwf_inf_slayers",
    "wh_main_dwf_inf_slayers",
    "wh2_dlc10_dwf_inf_giant_slayers",
    "wh2_dlc10_dwf_inf_giant_slayers",
    "wh_main_dwf_inf_irondrakes_0"
}, "dwf_ungrim_ironfist", "names_name_2147344414", "names_name_2147344423")
exile_manager:add_faction("wh_main_dwf_karak_izor", "wec_exiles_dilemma_wh_main_dwf_karak_izor", 
{
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_dlc06_dwf_inf_rangers_0",
    "wh_dlc06_dwf_inf_rangers_0",
    "wh_main_dwf_inf_hammerers",
    "wh_main_dwf_inf_hammerers",
    "wh_main_dwf_inf_hammerers"
}, "dlc06_dwf_belegar", "names_name_2147358029", "names_name_2147358036")



--ebs


core:add_listener(
    "ExilesFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() 
    end,
    function(context)
        exile_manager:check_active_exiles()
        exile_manager:exclude_wars(context:faction())
        exile_manager:trigger_valid_exiles(context:faction())
    end,
    true)

core:add_listener(
    "ExilesDilemmaDecision",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma():starts_with("wec_exiles_dilemma_")
    end,
    function(context)
        local faction = string.gsub(context:dilemma(), "wec_exiles_dilemma_", "")
        cm:set_saved_value("exiles_occured_"..faction, true)
        if context:choice() == 0 then
            exile_manager:create_exiled_army_for_faction(faction, context:faction():name())
        end
    end,
    true
)





core:add_listener(
    "ExilesWarEnds",
    "PositiveDiplomaticEvent",
    function(context)
        local proposer_human = context:proposer():is_human() --:boolean
        local recipient_human = context:recipient():is_human()--:boolean 
        return context:is_peace_treaty() and (proposer_human or recipient_human)
    end,
    function(context)
        local proposer_human = context:proposer():is_human() --:boolean
        local recipient_human = context:recipient():is_human()--:boolean 
        if proposer_human then
            local human_faction = context:proposer()
            local cur_faction = context:recipient():name()
            cm:set_saved_value("exiles_war_"..human_faction:name()..cur_faction, false)
        elseif recipient_human then
            local human_faction = context:recipient()
            local cur_faction = context:proposer():name()
            cm:set_saved_value("exiles_war_"..human_faction:name()..cur_faction, false)
        end
    end,
    true
)

core:add_listener(
    "ExilesGarrisonOccupation",
    "GarrisonOccupiedEvent",
    function(context)
        return exile_manager:army_is_exiles(context:character():cqi())
    end,
    function(context)
        exile_manager:revive_faction(context:character():cqi(), context:garrison_residence():region())
    end,
    true
)

core:add_listener(
    "ExilesCharacterSelected",
    "CharacterSelected",
    function(context)
        return context:character():faction():is_human()
    end,
    function(context)
        local cqi = context:character():cqi() --:CA_CQI
        if exile_manager:army_is_exiles(cqi) then
            exile_manager:disable_buttons()
        else
            exile_manager:enable_buttons()
        end
    end,
    true
)





--[[ testing code
events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1]  = function()
    local vlad_armies = cm:get_faction("wh_main_dwf_dwarfs"):character_list()
    for i = 0, vlad_armies:num_items() -1 do
        cm:callback(function()
            cm:kill_character(vlad_armies:item_at(i):cqi(), true, true)
        end, i+1/10)
    end

    local provinces_to_transfer_to_mannfred = {
        "wh_main_the_silver_road_karaz_a_karak"
    } --:vector<string>
    
    --give sylvania to mannfred
    
    for i = 1, #provinces_to_transfer_to_mannfred do
        cm:callback( function()
        cm:transfer_region_to_faction(provinces_to_transfer_to_mannfred[i], "wh_main_vmp_vampire_counts");
        end, (i/10));
    end
end

--]]