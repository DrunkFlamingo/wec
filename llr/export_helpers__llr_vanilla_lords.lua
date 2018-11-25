cm = get_cm(); events = get_events(); llr = _G.llr;



local karl_franz_quests = {
    { "wh_main_anc_weapon_the_reikland_runefang", "wh_main_emp_karl_franz_reikland_runefang_stage_1", 8},
    { "wh_main_anc_weapon_ghal_maraz","wh_main_emp_karl_franz_ghal_maraz_stage_1", 13},
    { "wh_main_anc_talisman_the_silver_seal", "wh_main_emp_karl_franz_silver_seal_stage_1", 18}
}--: vector<{string, string, number, string?}>

local balthasar_gelt_quests = {
    { "wh_main_anc_enchanted_item_cloak_of_molten_metal","wh_main_emp_balthasar_gelt_cloak_of_molten_metal_stage_1", 8},
    { "wh_main_anc_talisman_amulet_of_sea_gold", "wh_main_emp_balthasar_gelt_amulet_of_sea_gold_stage_1.1", 13},
    { "wh_main_anc_arcane_item_staff_of_volans", "wh_main_emp_balthasar_gelt_staff_of_volans_stage_1", 18}
}--: vector<{string, string, number, string?}>

local volkmar_the_grim_quests = {
    { "wh_dlc04_anc_talisman_jade_griffon", "wh_dlc04_emp_volkmar_the_grim_jade_griffon_stage_1", 8},
    { "wh_dlc04_anc_talisman_jade_griffon", "wh_dlc04_emp_volkmar_the_grim_staff_of_command_stage_1", 13}
}--: vector<{string, string, number, string?}>

local thorgrim_grudgebearer_quests = {
    { "wh_main_anc_weapon_the_axe_of_grimnir", "wh_main_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_1", 8},
    { "wh_main_anc_armour_the_armour_of_skaldour", "wh_main_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_1", 13},
    { "wh_main_anc_talisman_the_dragon_crown_of_karaz", "wh_main_dwf_thorgrim_grudgebearer_dragon_crown_of_karaz_stage_1", 18},
    { "wh_main_anc_enchanted_item_the_great_book_of_grudges", "wh_main_dwf_thorgrim_grudgebearer_book_of_grudges_stage_1", 23}
}--: vector<{string, string, number, string?}>

local ungrim_ironfist_quests = {
    { "wh_main_anc_armour_the_slayer_crown", "wh_main_dwf_ungrim_ironfist_slayer_crown_stage_1", 8},
    { "wh_main_anc_talisman_dragon_cloak_of_fyrskar", "wh_main_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_1", 13},
    { "wh_main_anc_weapon_axe_of_dargo", "wh_main_dwf_ungrim_ironfist_axe_of_dargo_stage_1", 18}
}--: vector<{string, string, number, string?}>

local grombrindal_quests = {
    { "wh_pro01_dwf_grombrindal_amour_of_glimril_scales", "wh_pro01_dwf_grombrindal_amour_of_glimril_scales_stage_1", 8},
    { "wh_pro01_dwf_grombrindal_rune_axe_of_grombrindal", "wh_pro01_dwf_grombrindal_rune_axe_of_grombrindal_stage_1", 13},
    { "wh_pro01_dwf_grombrindal_rune_cloak_of_valaya", "wh_pro01_dwf_grombrindal_rune_cloak_of_valaya_stage_1", 18},
    { "wh_pro01_dwf_grombrindal_rune_helm_of_zhufbar", "wh_pro01_dwf_grombrindal_rune_helm_of_zhufbar_stage_1", 23}
}--: vector<{string, string, number, string?}>

local grimgor_ironhide_quests = {
    { "wh_main_anc_weapon_gitsnik", "wh_main_grn_grimgor_ironhide_gitsnik_stage_1", 8},
    { "wh_main_anc_armour_blood-forged_armour", "wh_main_grn_grimgor_ironhide_blood_forged_armour_stage_1.1", 13}
}--: vector<{string, string, number, string?}>

local azhag_the_slaughterer_quests = {
    { "wh_main_anc_enchanted_item_the_crown_of_sorcery", "wh_main_grn_azhag_the_slaughterer_crown_of_sorcery_stage_1", 8},
    {"wh_main_anc_armour_azhags_ard_armour", "wh_main_azhag_the_slaughterer_azhags_ard_armour_stage_1", 13},
    { "wh_main_anc_weapon_slaggas_slashas", "wh_main_grn_azhag_the_slaughterer_slaggas_slashas_stage_1", 18}
}--: vector<{string, string, number, string?}>

local mannfred_von_carstein_quests = {
    { "wh_main_anc_weapon_sword_of_unholy_power", "wh_main_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_1", 8},
    { "wh_main_anc_armour_armour_of_templehof", "wh_main_vmp_mannfred_von_carstein_armour_of_templehof_stage_1", 13}
}--: vector<{string, string, number, string?}>

local heinrich_kemmler_quests = {
    { "wh_main_anc_weapon_chaos_tomb_blade", "wh_main_vmp_heinrich_kemmler_chaos_tomb_blade_stage_1", 8},
    { "wh_main_anc_enchanted_item_cloak_of_mists_and_shadows", "wh_main_vmp_heinrich_kemmler_cloak_of_mists_stage_1", 13},
    { "wh_main_anc_arcane_item_skull_staff", "wh_main_vmp_heinrich_kemmler_skull_staff_stage_1.1", 18}
}--: vector<{string, string, number, string?}>

local vlad_von_carstein_quests = {
    { "wh_dlc04_anc_weapon_blood_drinker", "wh_dlc04_vmp_vlad_von_carstein_blood_drinker_stage_1", 8},
    { "wh_dlc04_anc_talisman_the_carstein_ring", "wh_dlc04_vmp_vlad_von_carstein_the_carstein_ring_stage_1", 13}
}--: vector<{string, string, number, string?}>

local helman_ghorst_quests = {
    { "wh_dlc04_anc_arcane_item_the_liber_noctus", "wh_dlc04_vmp_helman_ghorst_liber_noctus_stage_1", 8}
}--: vector<{string, string, number, string?}>

local archaon_the_everchosen_quests = {
    { "wh_main_anc_weapon_the_slayer_of_kings", "wh_dlc01_chs_archaon_slayer_of_kings_stage_1", 8,"wh_dlc01_chs_archaon_slayer_of_kings_stage_3a_mpc"},
    { "wh_main_anc_armour_the_armour_of_morkar", "wh_dlc01_chs_archaon_armour_of_morkar_stage_1", 13,"wh_dlc01_chs_archaon_armour_of_morkar_stage_3a_mpc"},
    { "wh_main_anc_talisman_the_eye_of_sheerian", "wh_dlc01_chs_archaon_eye_of_sheerian_stage_1", 18,"wh_dlc01_chs_archaon_eye_of_sheerian_stage_2_mpc"},
    { "wh_main_anc_enchanted_item_the_crown_of_domination", "wh_dlc01_chs_archaon_crown_of_domination_stage_1", 23,"wh_dlc01_chs_archaon_crown_of_domination_stage_2a_mpc"}
}--: vector<{string, string, number, string?}>

local prince_sigvald_quests = {
    { "wh_main_anc_weapon_sliverslash", "wh_dlc01_chs_prince_sigvald_sliverslash_stage_1", 8,"wh_dlc01_chs_prince_sigvald_sliverslash_stage_4a_mpc"},
    { "wh_main_anc_armour_auric_armour", "wh_dlc01_chs_prince_sigvald_auric_armour_stage_1", 13,"wh_dlc01_chs_prince_sigvald_auric_armour_stage_3a_mpc"}
}--: vector<{string, string, number, string?}>

local kholek_suneater_quests = {
    { "wh_main_anc_weapon_starcrusher", "wh_dlc01_chs_kholek_suneater_starcrusher_stage_1", 8,"wh_dlc01_chs_kholek_suneater_starcrusher_stage_2_mpc"}
}--: vector<{string, string, number, string?}>

local khazrak_quests = {
    { "wh_dlc03_anc_weapon_scourge", "wh_dlc03_bst_khazrak_one_eye_scourge_stage_1_grandcampaign", 8,"wh_dlc03_bst_khazrak_one_eye_scourge_stage_4a_grandcampaign_mpc"},
    { "wh_dlc03_anc_armour_the_dark_mail", "wh_dlc03_bst_khazrak_one_eye_the_dark_mail_stage_1_grandcampaign", 13,"wh_dlc03_bst_khazrak_one_eye_the_dark_mail_stage_4_grandcampaign_mpc"}
}--: vector<{string, string, number, string?}>

local malagor_quests = {
    { "wh_dlc03_anc_talisman_icon_of_vilification", "wh_dlc03_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_1_grandcampaign", 8,"wh_dlc03_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6a_grandcampaign_mpc"}
}--: vector<{string, string, number, string?}>

local morghur_quests = {
    { "wh_main_anc_weapon_stave_of_ruinous_corruption", "wh_dlc05_qb_bst_morghur_stave_of_ruinous_corruption_stage_1", 8,"wh_dlc05_qb_bst_morghur_stave_of_ruinous_corruption_stage_4a_mpc"}
}--: vector<{string, string, number, string?}>

local belegar_quests = {
    { "wh_dlc06_anc_armour_shield_of_defiance", "wh_dlc06_dwf_belegar_ironhammer_shield_of_defiance_stage_1", 8,"wh_dlc06_dwf_belegar_ironhammer_shield_of_defiance_stage_2a_mpc"},
    { "wh_dlc06_anc_weapon_the_hammer_of_angrund", "wh_dlc06_dwf_belegar_ironhammer_hammer_of_angrund_stage_1", 13,"wh_dlc06_dwf_belegar_ironhammer_hammer_of_angrund_stage_3a_mpc"}
}--: vector<{string, string, number, string?}>

local skarsnik_quests = {
    { "wh_dlc06_anc_weapon_skarsniks_prodder", "wh_dlc06_grn_skarsnik_skarsniks_prodder_stage_1", 8,"wh_dlc06_grn_skarsnik_skarsniks_prodder_stage_4a_mpc"}
}--: vector<{string, string, number, string?}>

local wurrzag_quests = {
    { "wh_dlc06_anc_enchanted_item_baleful_mask", "wh_dlc06_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_1", 8,"wh_dlc06_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4a_mpc"},
    { "wh_dlc06_anc_arcane_item_squiggly_beast", "wh_dlc06_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_1", 13,"wh_dlc06_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_3_mpc"},
    { "wh_dlc06_anc_weapon_bonewood_staff", "wh_dlc06_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_1", 18,"wh_dlc06_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_3a_mpc"}
}--: vector<{string, string, number, string?}>

local orion_quests = {
    { "wh_dlc05_anc_enchanted_item_horn_of_the_wild_hunt", "wh_dlc05_wef_orion_horn_of_the_wild_stage_1", 8,"wh_dlc05_wef_orion_horn_of_the_wild_stage_3a_mpc"},
    { "wh_dlc05_anc_talisman_cloak_of_isha", "wh_dlc05_wef_orion_cloak_of_isha_stage_1", 13,"wh_dlc05_wef_orion_cloak_of_isha_stage_3a_mpc"},
    { "wh_dlc05_anc_weapon_spear_of_kurnous", "wh_dlc05_wef_orion_spear_of_kurnous_stage_1", 18,"wh_dlc05_wef_orion_spear_of_kurnous_stage_3a_mpc"}
}--: vector<{string, string, number, string?}>

local durthu_quests = {
    { "wh_dlc05_anc_weapon_daiths_sword", "wh_dlc05_wef_durthu_sword_of_daith_stage_1", 8,"wh_dlc05_wef_durthu_sword_of_daith_stage_4a_mpc"}
}--: vector<{string, string, number, string?}>

local fay_enchantress_quests = {
    { "wh_dlc07_anc_arcane_item_the_chalice_of_potions", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_stage_1", 9}
}--: vector<{string, string, number, string?}>

local alberic_quests = {
    {"wh_dlc07_anc_weapon_trident_of_manann", "wh_dlc07_qb_brt_alberic_trident_of_bordeleaux_stage_1", 3}
}--: vector<{string, string, number, string?}>

local louen_quests = {
    {"wh_main_anc_weapon_the_sword_of_couronne", "wh_dlc07_qb_brt_louen_sword_of_couronne_stage_0", 9}
}--: vector<{string, string, number, string?}>

local isabella_quests = {
    { "wh_pro02_anc_enchanted_item_blood_chalice_of_bathori", "wh_pro02_qb_vmp_isabella_von_carstein_blood_chalice_of_bathori_stage_1", 9}
}--: vector<{string, string, number, string?}>

local tyrion_quests = {
    { "wh2_main_anc_weapon_sunfang", "wh2_main_hef_tyrion_sunfang_stage_1", 10},
    { "wh2_main_anc_armour_dragon_armour_of_aenarion", "wh2_main_hef_tyrion_dragon_armour_of_aenarion_stage_1", 6},
        {"wh2_main_anc_enchanted_item_heart_of_avelorn","nothingess", 0}
}--: vector<{string, string, number, string?}>

local teclis_quests = {
    { "wh2_main_anc_weapon_sword_of_teclis", "wh2_main_hef_teclis_sword_of_teclis_stage_1", 10},
    { "wh2_main_anc_arcane_item_war_crown_of_saphery", "wh2_main_hef_teclis_war_crown_of_saphery_stage_1", 6},
    {"wh2_main_anc_arcane_item_moon_staff_of_lileath", "nothingess", 0},
    {"wh2_main_anc_arcane_item_scroll_of_hoeth","nothingess", 0}
}--: vector<{string, string, number, string?}>

local alarielle_quests = {
    { "wh2_dlc10_anc_talisman_shieldstone_of_isha", "wh2_dlc10_alarielle_shieldstone_of_isha_1", 2},
    { "wh2_dlc10_anc_enchanted_item_star_of_avelorn", "wh2_dlc10_hef_alarielle_star_of_avelorn_stage_1", 15}
}--: vector<{string, string, number, string?}>

local alith_anar_quests = {
    {"wh2_dlc10_anc_talisman_stone_of_midnight","nothingess", 0},
    { "wh2_dlc10_anc_weapon_moonbow", "wh2_dlc10_hef_alith_anar_the_moonbow_stage_1", 5}
}--: vector<{string, string, number, string?}>

local malekith_quests = {
    { "wh2_main_anc_weapon_destroyer", "wh2_main_def_malekith_destroyer_stage_1", 10},
    { "wh2_main_anc_arcane_item_circlet_of_iron", "wh2_main_def_malekith_circlet_of_iron_stage_1", 6},
    { "wh2_main_anc_armour_supreme_spellshield", "wh2_main_def_malekith_supreme_spellshield_stage_1", 14},
    {"wh2_main_anc_armour_armour_of_midnight","nothingess", 0}
}--: vector<{string, string, number, string?}>

local morathi_quests = {
    { "wh2_main_anc_weapon_heartrender_and_the_darksword", "wh2_main_def_morathi_heartrender_and_the_darksword_stage_1", 6},
    {"wh2_main_anc_talisman_amber_amulet","nothingess", 0}
}--: vector<{string, string, number, string?}>
local hellebron_quests = {
    { "wh2_dlc10_anc_weapon_deathsword_and_the_cursed_blade", "wh2_dlc10_def_hellebron_deathsword_and_the_cursed_blade_stage_1", 8},
    { "wh2_dlc10_anc_talisman_amulet_of_dark_fire", "wh2_dlc10_def_hellebron_amulet_of_dark_fire_stage_1", 15}
}--: vector<{string, string, number, string?}>

local mazdamundi_quests = {
    { "wh2_main_anc_weapon_cobra_mace_of_mazdamundi", "wh2_main_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_1", 10},
    { "wh2_main_anc_magic_standard_sunburst_standard_of_hexoatl", "wh2_main_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_1", 6}
}--: vector<{string, string, number, string?}>

local kroq_gar_quests = {
    { "wh2_main_anc_enchanted_item_hand_of_gods", "wh2_main_liz_kroq_gar_hand_of_gods_stage_1", 10},
    { "wh2_main_anc_weapon_revered_spear_of_tlanxla", "wh2_main_liz_kroq_gar_revered_spear_of_tlanxla_stage_1", 6}
}--: vector<{string, string, number, string?}>

local skrolk_quests = {
    { "wh2_main_anc_weapon_rod_of_corruption", "wh2_main_skv_skrolk_rod_of_corruption_stage_1", 10},
    { "wh2_main_anc_arcane_item_the_liber_bubonicus", "wh2_main_skv_skrolk_liber_bubonicus_stage_1", 6}
}--: vector<{string, string, number, string?}>	

local queek_headtaker_quests = {
    { "wh2_main_anc_armour_warp_shard_armour", "wh2_main_skv_queek_headtaker_warp_shard_armour_stage_1", 6},
    { "wh2_main_anc_weapon_dwarf_gouger", "wh2_main_skv_queek_headtaker_dwarfgouger_stage_1", 10}
}--: vector<{string, string, number, string?}>

local tretch_craventail_quests = {
    { "wh2_dlc09_anc_enchanted_item_lucky_skullhelm", "wh2_dlc09_skv_tretch_lucky_skullhelm_stage_1", 8}
}--: vector<{string, string, number, string?}>

local settra_quests = {
    { "wh2_dlc09_anc_enchanted_item_the_crown_of_nehekhara", "wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_1", 6},
    { "wh2_dlc09_anc_weapon_the_blessed_blade_of_ptra", "wh2_dlc09_tmb_settra_the_blessed_blade_of_ptra_stage_1", 13}
}--: vector<{string, string, number, string?}>

local arkhan_quests = {
    { "wh2_dlc09_anc_weapon_the_tomb_blade_of_arkhan", "wh2_dlc09_tmb_arkhan_the_tomb_blade_of_arkhan_stage_1", 6},
    { "wh2_dlc09_anc_arcane_item_staff_of_nagash", "wh2_dlc09_tmb_arkhan_the_staff_of_nagash_stage_1", 10}
}--: vector<{string, string, number, string?}>

local khatep_quests = {
    { "wh2_dlc09_anc_arcane_item_the_liche_staff", "wh2_dlc09_mortal_empires_tmb_khatep_the_liche_staff_1", 6}
}--: vector<{string, string, number, string?}>

local khalida_quests = {
    { "wh2_dlc09_anc_weapon_the_venom_staff", "wh2_dlc09_mortal_empires_tmb_khalida_venom_staff_stage_1", 12}
}--: vector<{string, string, number, string?}>

local wulfrik_quests = {
    { "wh_dlc08_anc_weapon_sword_of_torgald", "wh_dlc08_qb_nor_wulfrik_the_wanderer_sword_of_torgald_stage_1", 9}
}--: vector<{string, string, number, string?}>

local throgg_quests = {
    { "wh_dlc08_anc_talisman_wintertooth_crown", "wh_dlc08_qb_nor_throgg_wintertooth_crown_stage_1", 9}
}--: vector<{string, string, number, string?}>

local harkon_quests = {
    {"wh2_dlc11_anc_enchanted_item_slann_gold", "wh2_dlc11_cst_harkon_quest_for_slann_gold_stage_1", 15}
}--: vector<{string, string, number, string?}>

local noctilus_quests = {
    {"wh2_dlc11_anc_enchanted_item_captain_roths_moondial", "wh2_dlc11_cst_noctilus_captain_roths_moondial_stage_1", 15}
}--: vector<{string, string, number, string?}>

local aranessa_quests = {
    {"wh2_dlc11_anc_weapon_krakens_bane", "wh2_dlc11_cst_aranessa_krakens_bane_stage_1", 15}
}--: vector<{string, string, number, string?}>

local cylostra_quests = {
    {"wh2_dlc11_anc_arcane_item_the_bordeleaux_flabellum", "wh2_dlc11_cst_cylostra_the_bordeleaux_flabellum_stage_1", 9}
}--: vector<{string, string, number, string?}>

local lokhir_quests = {
    {"wh2_main_anc_armour_helm_of_the_kraken", "wh2_dlc11_lokhir_helm_of_the_kraken_stage_1", 11},
    {"wh2_dlc11_anc_weapon_red_blades", "wh2_dlc11_def_lokhir_red_blades_stage_1", 15}
}--: vector<{string, string, number, string?}>

local vanilla_lords = {
    {faction = "wh2_main_skv_clan_mors",forename = "names_name_2147359300",surname = "names_name_2147360908",subtype ="wh2_main_skv_queek_headtaker", quests = queek_headtaker_quests },
    {faction = "wh2_main_skv_clan_pestilens",forename = "names_name_2147359289",surname = "names_name_2147359296",subtype ="wh2_main_skv_lord_skrolk", quests = skrolk_quests },
    {faction = "wh2_main_lzd_hexoatl",forename = "names_name_2147359221",surname = "names_name_2147359230",subtype ="wh2_main_lzd_lord_mazdamundi", quests = mazdamundi_quests },
    {faction = "wh2_main_lzd_last_defenders",forename = "names_name_2147359240",surname = "names_name_2147360514",subtype ="wh2_main_lzd_kroq_gar", quests = kroq_gar_quests },
    {faction = "wh2_main_hef_eataine",forename = "names_name_2147360906",surname = "names_name_2147360506",subtype ="wh2_main_hef_tyrion", quests = tyrion_quests },
    {faction = "wh2_main_hef_order_of_loremasters",forename = "names_name_2147359256",surname = "names_name_2147360506",subtype ="wh2_main_hef_teclis", quests = teclis_quests },
    {faction = "wh2_main_def_cult_of_pleasure",forename = "names_name_2147359274",surname = "names_name_2147360508",subtype ="wh2_main_def_morathi", quests = morathi_quests },
    {faction = "wh2_main_def_naggarond",forename = "names_name_2147359265",surname = "names_name_2147360508",subtype ="wh2_main_def_malekith", quests = malekith_quests },
    {faction = "wh_main_vmp_vampire_counts",forename = "names_name_2147343886",surname = "names_name_2147343895",subtype ="vmp_mannfred_von_carstein", quests = mannfred_von_carstein_quests },
    {faction = "wh2_dlc11_vmp_the_barrow_legion",forename = "names_name_2147345320",surname = "names_name_2147345313",subtype ="vmp_heinrich_kemmler", quests = heinrich_kemmler_quests },
    {faction = "wh_main_vmp_schwartzhafen",forename = "names_name_2147345124",surname = "names_name_2147343895",subtype ="pro02_vmp_isabella_von_carstein", quests = isabella_quests },
    {faction = "wh_main_dwf_dwarfs",forename = "names_name_2147358917",surname = "names_name_2147358935",subtype ="pro01_dwf_grombrindal", quests = grombrindal_quests },
    {faction = "wh_main_grn_greenskins",forename = "names_name_2147343863",surname = "names_name_2147343867",subtype ="grn_grimgor_ironhide", quests = grimgor_ironhide_quests },
    {faction = "wh_main_grn_greenskins",forename = "names_name_2147345906",surname = "names_name_2147357356",subtype ="grn_azhag_the_slaughterer", quests = azhag_the_slaughterer_quests },
    {faction = "wh_main_emp_empire",forename = "names_name_2147343849",surname = "names_name_2147343858",subtype ="emp_karl_franz", quests = karl_franz_quests },
    {faction = "wh_main_emp_empire",forename = "names_name_2147343922",surname = "names_name_2147343928",subtype ="emp_balthasar_gelt", quests = balthasar_gelt_quests },
    {faction = "wh_main_dwf_karak_kadrin",forename = "names_name_2147344414",surname = "names_name_2147344423",subtype ="dwf_ungrim_ironfist", quests = ungrim_ironfist_quests },
    {faction = "wh_main_dwf_dwarfs",forename = "names_name_2147343883",surname = "names_name_2147343884",subtype ="dwf_thorgrim_grudgebearer", quests = thorgrim_grudgebearer_quests },
    {faction = "wh_main_brt_carcassonne",forename = "names_name_2147358931",surname = "names_name_2147359018",subtype ="dlc07_brt_fay_enchantress", quests = fay_enchantress_quests },
    {faction = "wh_main_brt_bordeleaux",forename = "names_name_2147345888",surname = "names_name_1529663917",subtype ="dlc07_brt_alberic", quests = alberic_quests },
    {faction = "wh_main_grn_orcs_of_the_bloody_hand",forename = "names_name_2147358023",surname = "names_name_2147358027",subtype ="dlc06_grn_wurrzag_da_great_prophet", quests = wurrzag_quests },
    {faction = "wh_main_grn_crooked_moon",forename = "names_name_2147358016",surname = "names_name_2147358924",subtype ="dlc06_grn_skarsnik", quests = skarsnik_quests },
    {faction = "wh_main_dwf_karak_izor",forename = "names_name_2147358029",surname = "names_name_2147358036",subtype ="dlc06_dwf_belegar", quests = belegar_quests },
    {faction = "wh_dlc05_wef_wood_elves",forename = "names_name_2147352809",surname = "names_name_2147359013",subtype ="dlc05_wef_orion", quests = orion_quests },
    {faction = "wh_dlc05_wef_argwylon",forename = "names_name_2147352813",surname = "names_name_2147359013",subtype ="dlc05_wef_durthu", quests = durthu_quests },
    {faction = "wh_main_vmp_schwartzhafen",forename = "names_name_2147345130",surname = "names_name_2147343895",subtype ="dlc04_vmp_vlad_con_carstein", quests = vlad_von_carstein_quests },
    {faction = "wh_main_vmp_vampire_counts",forename = "names_name_2147358044",surname = "names_name_2147345294",subtype ="dlc04_vmp_helman_ghorst", quests = helman_ghorst_quests },
    {faction = "wh_main_emp_empire",forename = "names_name_2147358013",surname = "names_name_2147358014",subtype ="dlc04_emp_volkmar", quests = volkmar_the_grim_quests },
    {faction = "wh_main_emp_middenland",forename = "names_name_2147343937",surname = "names_name_2147343940",subtype ="dlc03_emp_boris_todbringer", quests = nil },
    {faction = "wh_main_brt_bretonnia",forename = "names_name_2147343915",surname = "names_name_2147343917",subtype ="brt_louen_leoncouer", quests = louen_quests },
    {faction = "wh2_dlc09_skv_clan_rictus",forename = "names_name_2147343915",surname = "names_name_2147343917",subtype ="wh2_dlc09_skv_tretch_craventail", quests = tretch_craventail_quests },
    {faction = "wh2_main_hef_avelorn", forename = "names_name_898828143", surname = "", subtype = "wh2_dlc10_hef_alarielle", quests = alarielle_quests},
    {faction = "wh_dlc08_nor_wintertooth", forename = "names_name_346878492", subtype = "wh_dlc08_nor_throgg", surname = "",quests = throgg_quests },
    {faction = "wh_dlc08_nor_norsca", forename = "names_name_981430255", surname = "names_name_791685155", subtype = "wh_dlc08_nor_wulfrik", quests = wulfrik_quests },
    {subtype = "wh2_dlc10_def_crone_hellebron", forename = "names_name_608740515", surname = "", faction = "wh2_main_def_har_ganeth", quests = hellebron_quests},
    {faction = "wh2_main_hef_nagarythe", subtype = "wh2_dlc10_hef_alith_anar", forename = "names_name_1829581114", surname = "", quests = alith_anar_quests},
    {faction = "wh_main_vmp_mousillon",forename = "names_name_2147359236",surname = "",subtype ="wh_dlc05_vmp_red_duke", quests = nil },
    {faction = "wh2_dlc11_cst_noctilus", subtype = "wh2_dlc11_cst_noctilus", forename = "names_name_227765640", surname = "", quests = noctilus_quests},
    {faction = "wh2_dlc11_cst_pirates_of_sartosa", subtype = "wh2_dlc11_cst_aranessa", forename = "names_name_1340289195", surname = "names_name_250811476", quests = aranessa_quests},
    {faction = "wh2_dlc11_cst_vampire_coast", subtype = "wh2_dlc11_cst_harkon", forename = "names_name_242277685", surname = "names_name_1053168049", quests = harkon_quests},
    {faction = "wh2_dlc11_cst_the_drowned", subtype = "wh2_dlc11_cst_cylostra", forename = "names_name_143098456", surname = "names_name_758220496", quests = cylostra_quests},
    {faction = "wh2_dlc11_def_the_blessed_dread", subtype = "wh2_dlc11_def_lokhir", forename = "names_name_1748721115", surname = "names_name_830390907", quests = lokhir_quests}

}--:vector<{faction: string, forename: string, surname: string, subtype: string, quests: vector<{string, string, number, string?}>}>


for i = 1, #vanilla_lords do --start looping through the information we just defined.
    local clord = vanilla_lords[i] --makes the rest shorter and easier to type.
    local fact = clord.faction 
    local fname = clord.forename
    local sname = clord.surname
    local subtype = clord.subtype
    local lord = llr:add_lord(clord.faction, clord.subtype, clord.forename, clord.surname) --create the new lord object.
    --if we have a quest table for this lord, we need to add it.
    if clord.quests then
        for i = 1, #clord.quests do
            lord:add_quest(clord.quests[i][1], clord.quests[i][3])
            lord:add_ca_quest_save_value(clord.quests[i][2].."_issued")
        end
    end
end


cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
    LLRLOG("Triggering the Vanilla Lords Added Event")
    core:trigger_event("LegendaryLordVanillaLordsAdded")
end



