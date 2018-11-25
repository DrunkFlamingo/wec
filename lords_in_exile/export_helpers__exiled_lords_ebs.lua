local exile_manager = _G.exile_manager


--content
exile_manager:enable_culture_as_recipient("wh_main_sc_emp_empire")
exile_manager:enable_culture_as_recipient("wh_main_sc_brt_bretonnia")
exile_manager:enable_culture_as_recipient("wh2_main_sc_hef_high_elves")
exile_manager:enable_culture_as_recipient("wh_main_sc_dwf_dwarfs")
--exile_manager:add_button_to_disable({"layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "rank", "skills", "skill_button"})
--exile_manager:add_button_to_disable({"layout", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general"})
--exile_manager:add_button_to_disable({"layout", "BL_parent", "land_stance_button_stack"})
--exile_manager:add_button_to_disable({"layout", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_recruitment"})
--exile_manager:add_button_to_disable({"layout", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_renown"})

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
    }, "wh2_dlc10_hef_alarielle", {
        wh_main_sc_dwf_dwarfs = "names_name_32174022",
        wh_main_sc_emp_empire = "names_name_167674321",
        wh_main_sc_brt_bretonnia = "names_name_361064528",
        wh2_main_sc_hef_high_elves = "names_name_1478429232"
        },
        {
        wh_main_sc_dwf_dwarfs = "",
        wh_main_sc_emp_empire = "",
        wh_main_sc_brt_bretonnia = "",
        wh2_main_sc_hef_high_elves = ""
        }
    )
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
}, "wh2_main_hef_tyrion",{
    wh_main_sc_dwf_dwarfs = "names_name_202441981",
    wh_main_sc_emp_empire = "names_name_167674321",
    wh_main_sc_brt_bretonnia = "names_name_1050136400",
    wh2_main_sc_hef_high_elves = "names_name_1845118216"
    },
    {
    wh_main_sc_dwf_dwarfs = "",
    wh_main_sc_emp_empire = "",
    wh_main_sc_brt_bretonnia = "",
    wh2_main_sc_hef_high_elves = ""
    }
)
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
}, "wh2_main_hef_teclis", {
    wh_main_sc_brt_bretonnia = "names_name_436515028",
    wh_main_sc_dwf_dwarfs = "names_name_824231526",
    wh2_main_sc_hef_high_elves = "names_name_1453133800",
    wh_main_sc_emp_empire = "names_name_1578248859"    
    },
    {
    wh_main_sc_dwf_dwarfs = "",
    wh_main_sc_emp_empire = "",
    wh_main_sc_brt_bretonnia = "",
    wh2_main_sc_hef_high_elves = ""
    }
)
--karl frunz
exile_manager:add_faction("wh_main_emp_empire", "wec_exiles_dilemma_wh_main_emp_empire", 
{
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_inf_spearmen_1",
    "wh_main_emp_inf_handgunners",
    "wh_main_emp_inf_handgunners",
    "wh_main_emp_inf_swordsmen",
    "wh_main_emp_cav_reiksguard",
    "wh_main_emp_cav_reiksguard",
    "wh_main_emp_inf_greatswords",
    "wh_main_emp_inf_greatswords",
    "wh_main_emp_inf_greatswords",
    "wh_main_emp_art_great_cannon",
    "wh_main_emp_art_great_cannon"
}, "emp_karl_franz", {
    wh2_main_sc_hef_high_elves = "names_name_12481177",
    wh_main_sc_dwf_dwarfs = "names_name_1485513084",
    wh_main_sc_brt_bretonnia = "names_name_1530078133",
    wh_main_sc_emp_empire = "names_name_1542273247"    
    },
    {
        wh_main_sc_brt_bretonnia = "names_name_439921391",
        wh_main_sc_emp_empire = "names_name_460471875",
        wh2_main_sc_hef_high_elves = "names_name_638474139",
        wh_main_sc_dwf_dwarfs = "names_name_1920011342"        
    }
)
-- the bukkits
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
}, "dlc07_brt_fay_enchantress", {
    wh_main_sc_dwf_dwarfs = "names_name_332789182",
    wh2_main_sc_hef_high_elves = "names_name_530719269",
    wh_main_sc_emp_empire = "names_name_639265014",
    wh_main_sc_brt_bretonnia = "names_name_810950678"
    },
    {
    wh_main_sc_dwf_dwarfs = "",
    wh_main_sc_emp_empire = "",
    wh_main_sc_brt_bretonnia = "",
    wh2_main_sc_hef_high_elves = ""
    }
)
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
}, "brt_louen_leoncouer", {
        wh_main_sc_emp_empire = "names_name_13470887",
        wh_main_sc_brt_bretonnia = "names_name_89056585",
        wh_main_sc_dwf_dwarfs = "names_name_210366883",
        wh2_main_sc_hef_high_elves = "names_name_938560958"
    },
    {
        wh_main_sc_brt_bretonnia = "names_name_346719012",
        wh_main_sc_dwf_dwarfs = "names_name_1297431622",
        wh2_main_sc_hef_high_elves = "names_name_1333188909",
        wh_main_sc_emp_empire = "names_name_1887142773"
    }
)
-- vertically challenged people
exile_manager:add_faction("wh_main_dwf_dwarfs", "wec_exiles_dilemma_wh_main_dwf_dwarfs", 
{
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_inf_ironbreakers",
    "wh_main_dwf_inf_ironbreakers",
    "wh_main_dwf_inf_ironbreakers",
    "wh_main_dwf_veh_gyrocopter_0",
    "wh_main_dwf_veh_gyrocopter_0"
}, "dwf_thorgrim_grudgebearer", {
    wh_main_sc_emp_empire = "names_name_403254495",
    wh_main_sc_brt_bretonnia = "names_name_800319601",
    wh_main_sc_dwf_dwarfs = "names_name_1170610257",
    wh2_main_sc_hef_high_elves = "names_name_1934702858"
    },
    {
        wh_main_sc_emp_empire = "names_name_139741743",
        wh_main_sc_dwf_dwarfs = "names_name_1128587319",
        wh_main_sc_brt_bretonnia = "names_name_1328018081",
        wh2_main_sc_hef_high_elves = "names_name_1918049497"        
    }
)
exile_manager:add_faction("wh_main_dwf_karak_kadrin", "wec_exiles_dilemma_wh_main_dwf_karak_kadrin", 
{
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
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
}, "dwf_ungrim_ironfist", {
        wh_main_sc_emp_empire = "names_name_27370129",
        wh2_main_sc_hef_high_elves = "names_name_677405888",
        wh_main_sc_brt_bretonnia = "names_name_1448418685",
        wh_main_sc_dwf_dwarfs = "names_name_1884875597"    
    },
    {
        wh2_main_sc_hef_high_elves = "names_name_897354597",
        wh_main_sc_brt_bretonnia = "names_name_973980367",
        wh_main_sc_emp_empire = "names_name_1307045098",
        wh_main_sc_dwf_dwarfs = "names_name_1688526055"        
    }
)
exile_manager:add_faction("wh_main_dwf_karak_izor", "wec_exiles_dilemma_wh_main_dwf_karak_izor", 
{
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_longbeards",
    "wh_dlc06_dwf_inf_rangers_0",
    "wh_main_dwf_inf_longbeards",
    "wh_main_dwf_inf_thunderers_0",
    "wh_main_dwf_inf_dwarf_warrior_0",
    "wh_main_dwf_art_grudge_thrower",
    "wh_main_dwf_art_grudge_thrower",
    "wh_dlc06_dwf_inf_rangers_0",
    "wh_dlc06_dwf_inf_rangers_0",
    "wh_main_dwf_inf_hammerers",
    "wh_main_dwf_inf_hammerers",
    "wh_main_dwf_inf_hammerers"
}, "dlc06_dwf_belegar", {
        wh2_main_sc_hef_high_elves = "names_name_513508839",
        wh_main_sc_dwf_dwarfs = "names_name_927075448",
        wh_main_sc_emp_empire = "names_name_1638708374",
        wh_main_sc_brt_bretonnia = "names_name_2088835242"    
    },
    {
        wh2_main_sc_hef_high_elves = "names_name_297346204",
        wh_main_sc_emp_empire = "names_name_579314739",
        wh_main_sc_dwf_dwarfs = "names_name_1715607445",
        wh_main_sc_brt_bretonnia = "names_name_1991304257"        
    }
)



--event based scripting


core:add_listener(
    "ExilesFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() 
    end,
    function(context)
        --check if we have any valid exiles that need to be squished. On a small callback so it happens after the game processes bundle changes.
        cm:callback(function()
            exile_manager:check_active_exiles()
        end, 0.5)
        --exclude any wars we need to exclude
        exile_manager:exclude_wars(context:faction())
        --trigger the check for valid exiles.
        exile_manager:trigger_valid_exiles(context:faction())
    end,
    true)

core:add_listener(
    "ExilesDilemmaDecision",
    "DilemmaChoiceMadeEvent",
    function(context)
        --check for our prefix.
        return context:dilemma():starts_with("wec_exiles_dilemma_")
    end,
    function(context)
        --grab our faction by removing the prefix.
        local faction = string.gsub(context:dilemma(), "wec_exiles_dilemma_", "")
        --set the already occured value.
        cm:set_saved_value("exiles_occured_"..faction, true)
        --if they say yes, trigger the exile army. 
        if context:choice() == 0 then
            exile_manager:create_exiled_army_for_faction(faction, context:faction():name())
        end
    end,
    true
)




--check whenever the human makes a peace treaty and re-enable exiles for the peaced- out faction.
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
        --is the occupying faction an exile?
        return exile_manager:army_is_exiles(context:character():cqi())
    end,
    function(context)
        --revive them and gift them the settlement. 
        exile_manager:revive_faction(context:character():cqi(), context:garrison_residence():region())
    end,
    true
)

core:add_listener(
    "ExilesCharacterSelected",
    "CharacterSelected",
    function(context)
        --are we selecting a human character?
        return context:character():faction():is_human()
    end,
    function(context)
        --disable or enable their buttons, depending on whether they are an exile.
        local cqi = context:character():cqi() --:CA_CQI
        exile_manager._currentChar = cqi
        if exile_manager:army_is_exiles(cqi) then
            exile_manager:disable_buttons()
        else
            exile_manager:enable_buttons()
        end
    end,
    true
)

core:add_listener(
    "ExilesConfederation",
    "FactionJoinsConfederation",
    true,
    function(context)
        --lock the exile event for AI factions who get confederated. Otherwise our script will see them as dead!
        local confed_faction = context:faction():name()
        cm:set_saved_value("exiles_occured_"..confed_faction, true)
    end,
    true
)




--[[ testing code
events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1]  = function()
    if not cm:get_saved_value("exiles_test") then
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
        cm:set_saved_value("exiles_test", true)
    end
end

--]]


--disabling exchanges 
--function stolen from RM in weo lib
--v function() --> CA_CQI
local function find_second_army()

    --v function(ax: number, ay: number, bx: number, by: number) --> number
    local function distance_2D(ax, ay, bx, by)
        return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
    end;
    local first_char = cm:get_character_by_cqi(exile_manager._currentChar)
    local char_list = first_char:faction():character_list()
    local closest_char --:CA_CHAR
    local last_distance = 50 --:number
    local ax = first_char:logical_position_x()
    local ay = first_char:logical_position_y()
    for i = 0, char_list:num_items() - 1 do
        local char = char_list:item_at(i)
        if cm:char_is_mobile_general_with_army(char) then
            if char:cqi() == first_char:cqi() then

            else
                local dist = distance_2D(ax, ay, char:logical_position_x(), char:logical_position_y())
                if dist < last_distance then
                    last_distance = dist
                    closest_char = char
                end
            end
        end
    end
    if closest_char then
        return closest_char:cqi()
    else
        exile_manager:log("failed to find the other char!")
        return nil
    end
end
--v function()
local function LockExchangeButton()
    local ok_button = find_uicomponent(core:get_ui_root(), "unit_exchange", "hud_center_docker", "ok_cancel_buttongroup", "button_ok")
    if not not ok_button then
        ok_button:SetInteractive(false)
        ok_button:SetImage("ui/skins/default/icon_disband.png")
    else
        exile_manager:log("ERROR: could not find the exchange ok button!")
    end
end

--v function()
local function UnlockExchangeButton()
    local ok_button = find_uicomponent(core:get_ui_root(), "unit_exchange", "hud_center_docker", "ok_cancel_buttongroup", "button_ok")
    if not not ok_button then
        ok_button:SetInteractive(true)
        ok_button:SetImage("ui/skins/default/icon_check.png")
    else
        exile_manager:log("ERROR: could not find the exchange ok button!")
    end
end


core:add_listener(
    "ExilesPanelOpenedExchange",
    "PanelOpenedCampaign",
    function(context) 
        return context.string == "unit_exchange"; 
    end,
    function(context)
        cm:callback(function() --do this on a delay so the panel has time to fully open before the script tries to change it!
            local first = exile_manager._currentChar
            local second = find_second_army()
            --if either army is an exile army, disable the exchange!
            if exile_manager:army_is_exiles(first) or exile_manager:army_is_exiles(second) then
                LockExchangeButton()
            else
                UnlockExchangeButton()
            end
        end, 0.1)
    end,
    true
)
