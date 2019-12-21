
--# assume global class LLR
local legendary_lord_respec = {} --# assume legendary_lord_respec: LLR

local non_ll_subtypes = {
    "wh2_dlc09_tmb_necrotect_ritual",
    "wh2_dlc10_lzd_mon_carnosaur_boss",
    "wh2_dlc10_nor_phoenix_flamespyre_boss",
    "wh2_dlc12_lzd_lord_kroak_boss",
    "wh2_main_skv_plague_priest_ritual",
    "wh2_main_skv_warlock_engineer_ritual",
    "wh_dlc08_bst_cygor_boss",
    "wh_dlc08_chs_dragon_ogre_shaggoth_boss",
    "wh_dlc08_grn_giant_boss",
    "wh_dlc08_grn_venom_queen_boss",
    "wh_dlc08_nor_frost_wyrm_boss",
    "wh_dlc08_vmp_terrorgheist_boss",
    "wh_dlc08_wef_forest_dragon_boss",
    "brt_damsel",
    "brt_damsel_beasts",
    "brt_damsel_life",
    "brt_lord",
    "brt_paladin",
    "chs_chaos_sorcerer_death",
    "chs_chaos_sorcerer_fire",
    "chs_chaos_sorcerer_metal",
    "chs_exalted_hero",
    "chs_lord",
    "chs_sorcerer_lord_death",
    "chs_sorcerer_lord_fire",
    "chs_sorcerer_lord_metal",
    "default",
    "dlc03_bst_beastlord",
    "dlc03_bst_bray_shaman_beasts",
    "dlc03_bst_bray_shaman_death",
    "dlc03_bst_bray_shaman_shadows",
    "dlc03_bst_bray_shaman_wild",
    "dlc03_bst_gorebull",
    "dlc03_emp_amber_wizard",
    "dlc04_emp_arch_lector",
    "dlc04_vmp_strigoi_ghoul_king",
    "dlc05_emp_grey_wizard",
    "dlc05_emp_jade_wizard",
    "dlc05_wef_ancient_treeman",
    "dlc05_wef_glade_lord",
    "dlc05_wef_glade_lord_fem",
    "dlc05_wef_spellsinger_beasts",
    "dlc05_wef_spellsinger_life",
    "dlc05_wef_spellsinger_shadow",
    "dlc05_wef_waystalker",
    "dlc06_dwf_runelord",
    "dlc06_grn_night_goblin_warboss",
    "dlc07_brt_prophetess_beasts",
    "dlc07_brt_prophetess_heavens",
    "dlc07_brt_prophetess_life",
    "dlc07_chs_chaos_sorcerer_shadow",
    "dlc07_chs_sorcerer_lord_shadow",
    "dwf_lord",
    "dwf_master_engineer",
    "dwf_runesmith",
    "dwf_thane",
    "emp_bright_wizard",
    "emp_captain",
    "emp_celestial_wizard",
    "emp_light_wizard",
    "emp_lord",
    "emp_warrior_priest",
    "emp_witch_hunter",
    "grn_goblin_big_boss",
    "grn_goblin_great_shaman",
    "grn_night_goblin_shaman",
    "grn_orc_shaman",
    "grn_orc_warboss",
    "ksl_captain",
    "ksl_celestial_wizard",
    "ksl_lord",
    "nor_chaos_sorcerer_metal",
    "nor_marauder_chieftain",
    "nor_sorcerer_lord_metal",
    "teb_bright_wizard",
    "teb_captain",
    "teb_lord",
    "vmp_banshee",
    "vmp_lord",
    "vmp_master_necromancer",
    "vmp_necromancer",
    "vmp_vampire",
    "vmp_wight_king",
    "wh2_dlc09_tmb_liche_priest_death",
    "wh2_dlc09_tmb_liche_priest_light",
    "wh2_dlc09_tmb_liche_priest_nehekhara",
    "wh2_dlc09_tmb_liche_priest_shadow",
    "wh2_dlc09_tmb_necrotect",
    "wh2_dlc09_tmb_tomb_king",
    "wh2_dlc09_tmb_tomb_prince",
    "wh2_dlc10_def_mon_war_hydra_boss",
    "wh2_dlc10_def_sorceress_beasts",
    "wh2_dlc10_def_sorceress_death",
    "wh2_dlc10_def_supreme_sorceress_beasts",
    "wh2_dlc10_def_supreme_sorceress_dark",
    "wh2_dlc10_def_supreme_sorceress_death",
    "wh2_dlc10_def_supreme_sorceress_fire",
    "wh2_dlc10_def_supreme_sorceress_shadow",
    "wh2_dlc10_hef_handmaiden",
    "wh2_dlc10_hef_mage_heavens",
    "wh2_dlc10_hef_mage_shadows",
    "wh2_dlc10_hef_shadow_walker",
    "wh2_dlc10_skv_mon_hell_pit_abomination_boss",
    "wh2_dlc11_cst_admiral",
    "wh2_dlc11_cst_admiral_death",
    "wh2_dlc11_cst_admiral_deep",
    "wh2_dlc11_cst_admiral_fem",
    "wh2_dlc11_cst_admiral_fem_death",
    "wh2_dlc11_cst_admiral_fem_deep",
    "wh2_dlc11_cst_fleet_captain",
    "wh2_dlc11_cst_fleet_captain_death",
    "wh2_dlc11_cst_fleet_captain_deep",
    "wh2_dlc11_cst_ghost_paladin",
    "wh2_dlc11_cst_gunnery_wight",
    "wh2_dlc11_cst_mourngul",
    "wh2_dlc12_lzd_red_crested_skink_chief",
    "wh2_dlc12_lzd_tlaqua_skink_chief",
    "wh2_dlc12_lzd_tlaqua_skink_priest_beasts",
    "wh2_dlc12_lzd_tlaqua_skink_priest_heavens",
    "wh2_dlc12_skv_warlock_master",
    "wh2_dlc13_emp_cha_huntsmarshal_0",
    "wh2_dlc13_lzd_kroxigor_ancient",
    "wh2_dlc13_lzd_kroxigor_ancient_horde",
    "wh2_dlc13_lzd_red_crested_skink_chief_horde",
    "wh2_dlc13_lzd_saurus_old_blood_horde",
    "wh2_dlc13_lzd_skink_chief_horde",
    "wh2_dlc14_def_high_beastmaster",
    "wh2_dlc14_def_master",
    "wh2_dlc14_skv_eshin_sorcerer",
    "wh2_dlc14_skv_master_assassin",
    "wh2_main_def_death_hag",
    "wh2_main_def_dreadlord",
    "wh2_main_def_dreadlord_fem",
    "wh2_main_def_khainite_assassin",
    "wh2_main_def_sorceress_dark",
    "wh2_main_def_sorceress_fire",
    "wh2_main_def_sorceress_shadow",
    "wh2_main_hef_loremaster_of_hoeth",
    "wh2_main_hef_mage_high",
    "wh2_main_hef_mage_life",
    "wh2_main_hef_mage_light",
    "wh2_main_hef_noble",
    "wh2_main_hef_prince",
    "wh2_main_hef_princess",
    "wh2_main_lzd_saurus_old_blood",
    "wh2_main_lzd_saurus_scar_veteran",
    "wh2_main_lzd_skink_chief",
    "wh2_main_lzd_skink_priest_beasts",
    "wh2_main_lzd_skink_priest_heavens",
    "wh2_main_skv_assassin",
    "wh2_main_skv_grey_seer_plague",
    "wh2_main_skv_grey_seer_ruin",
    "wh2_main_skv_plague_priest",
    "wh2_main_skv_warlock_engineer",
    "wh2_main_skv_warlord",
    "wh2_pro07_emp_amethyst_wizard",
    "wh_dlc05_vmp_vampire_shadow",
    "wh_dlc05_wef_branchwraith",
    "wh_dlc08_nor_fimir_balefiend_fire",
    "wh_dlc08_nor_fimir_balefiend_shadow",
    "wh_dlc08_nor_shaman_sorcerer_death",
    "wh_dlc08_nor_shaman_sorcerer_fire",
    "wh_dlc08_nor_shaman_sorcerer_metal",
    "wh_dlc08_nor_skin_wolf_werekin"    
}--:vector<string>

--v function() --> LLR
function legendary_lord_respec.new()
    local self = {}
    setmetatable(self, {
        __index = legendary_lord_respec
    })--# assume self: LLR

    self._legendaryLords = {} --:map<string, string> 
    --maps subtypes to factions

    return self
end

--v method(text: any)
function legendary_lord_respec:log(text)
    if not __write_output_to_logfile then
        return; 
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("LLR:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

--v function(self: LLR, lord: CA_CHAR, new_faction: CA_FACTION)
function legendary_lord_respec.lord_confederated_into_faction(self, lord, new_faction)
    if new_faction:is_human() then
        cm:force_reset_skills(cm:char_lookup_str(lord))
    end
    self._legendaryLords[lord:character_subtype_key()] = new_faction:name()
end


--v function(self: LLR)
function legendary_lord_respec.build_lord_list(self)
    self:log("Building lord list")
    local exclusions = {} --:map<string, boolean>
    for i = 1, #non_ll_subtypes do
        exclusions[non_ll_subtypes[i]] = true
    end
    local players = cm:get_human_factions()
    local subtype_counts = {} --:map<string, number>
    for i = 1, #players do
        local current_player = cm:get_faction(players[i])
        local confederable_factions = current_player:factions_of_same_subculture()
        for j = 0, confederable_factions:num_items() - 1 do
            local current_faction = confederable_factions:item_at(j)
            local char_list = current_faction:character_list()
            for k = 0, char_list:num_items() - 1 do
                local current_subtype = char_list:item_at(k):character_subtype_key()
                subtype_counts[current_subtype] = (subtype_counts[current_subtype] or 0) + 1
                self._legendaryLords[current_subtype] = current_faction:name()
            end
        end
    end
    --trim any lords we found with more than 1 instance.
    for subtype, num_existing in pairs(subtype_counts) do
        if num_existing == 1 then
            self:log("Found legendary lord ["..subtype.."] in faction ["..self._legendaryLords[subtype].."] ")
            if exclusions[subtype] then
                self:log("Subtype was excluded")
                self._legendaryLords[subtype] = nil
            end
        else
            self._legendaryLords[subtype] = nil
        end
    end
    self:log("Lord list built")
end

--v function(self: LLR, confederation: CA_FACTION)
function legendary_lord_respec.confederation_occured(self, confederation)
    for i = 0, confederation:character_list():num_items() - 1 do
        local current_character = confederation:character_list():item_at(i)
        if self._legendaryLords[current_character:character_subtype_key()] and (self._legendaryLords[current_character:character_subtype_key()] ~= confederation:name()) then
            self:log(" Confederation ["..confederation:name().."] recieved character ["..current_character:character_subtype_key().."]")
            self:lord_confederated_into_faction(current_character, confederation)
        end
    end
end
--v function(self: LLR)
function legendary_lord_respec.activate(self)
    core:add_listener(
        "LegendaryLordRespecConfederation",
        "FactionJoinsConfederation",
        true,
        function(context)
            self:confederation_occured(context:confederation())
        end,
        true
    )
    self:log("Listeners added")
end

--implementation
function respec_on_confed()
    local llr = legendary_lord_respec.new()
    llr:build_lord_list()
    llr:activate()
end

--update --update --update --update --update --update --update --update --update --update --update --update --update --update --update --update