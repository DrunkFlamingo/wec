--utils and constants

local CONST_EXILE_ARMY_BUNDLE = "wec_exiled_army"
local CONST_EXILE_BUNDLE_DURATION = 25

local CONST_SPAWN_LOCATIONS = {
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



--Log script to text
--v function(text: string | number | boolean | CA_CQI)
local function EXLOG(text)
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
--v function(x: number, y: number) --> boolean
local function IsValidSpawnPoint(x, y)
    local faction_list = cm:model():world():faction_list();
    
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i);
        local char_list = current_faction:character_list();
        
        for i = 0, char_list:num_items() - 1 do
            local current_char = char_list:item_at(i);
            if current_char:logical_position_x() == x and current_char:logical_position_y() == y then
                EXLOG("Is valid spawn point returning false")
                return false;
            end;
        end;
    end;
    EXLOG("is valid spawn point returning true")
    return true;
end;

--class: EXILES

--# assume global class EXILES
local exiles = {} --# assume exiles: EXILES


--v function() --> EXILES
function exiles.init()
    local self = {}
    setmetatable(self, {
        __index = exiles
    }) --# assume self: EXILES

    self._activeExiles = {} --:map<CA_CQI, string> -- <CA_CQI> CQI of the exiles army, <string> name of the faction who is exiled
    self._exiledArmyLists = {} --:map<string, vector<string>> -- <string> name of the faction who is exiled, <vector<string>> list of unit keys for use in create force.
    self._exiledLeaders = {} --:map<string, {surname: string, forename: string, subtype: string}> -- <string> faction_key of exile, {surname: string, forename: string, subtype: string} leader info
    self._enabledCultures = {} --:map<string, boolean> -- <string> subculture key of the faction who may recieve, <boolean> flag to recieve.
    self._exileDilemmas = {} --:map<string, string> -- <string> faction who can be an exile, <string> dilemma to trigger
    self._disabledButtonPaths = {} --:vector<vector<string>> -- <vector<vector<string>>> vector of file paths to use in find_by_table.
    self._tooltips = {} --:map<string, string>
    self._buttonsDisabled = false --:boolean
    _G.exile_manager = self
    return self
end

--v method(text: any)
function exiles:log(text)
    EXLOG(tostring(text))
end


--logs lua errors to a file after this is called.
--v [NO_CHECK] 
--v function (self: EXILES)
function exiles.error_checker(self)
    --Vanish's PCaller
    --All credits to vanish
    --v function(func: function) --> any
    function safeCall(func)
        local status, result = pcall(func)
        if not status then
            EXLOG("ERROR")
            EXLOG(tostring(result))
            EXLOG(debug.traceback());
        end
        return result;
    end
    
    
    --v [NO_CHECK] function(...: any)
    function pack2(...) return {n=select('#', ...), ...} end
    --v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
    function unpack2(t) return unpack(t, 1, t.n) end
    
    --v [NO_CHECK] function(f: function(), argProcessor: function()) --> function()
    function wrapFunction(f, argProcessor)
        return function(...)
            local someArguments = pack2(...);
            if argProcessor then
                safeCall(function() argProcessor(someArguments) end)
            end
            local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
            return unpack2(result);
            end
    end
    
    core.trigger_event = wrapFunction(
        core.trigger_event,
        function(ab)
        end
    );
    
    cm.check_callbacks = wrapFunction(
        cm.check_callbacks,
        function(ab)
        end
    )
    
    local currentAddListener = core.add_listener;
    --v [NO_CHECK] function(core: any, listenerName: any, eventName: any, conditionFunc: any, listenerFunc: any, persistent: any)
    function myAddListener(core, listenerName, eventName, conditionFunc, listenerFunc, persistent)
        local wrappedCondition = nil;
        if is_function(conditionFunc) then
            --wrappedCondition =  wrapFunction(conditionFunc, function(arg) output("Callback condition called: " .. listenerName .. ", for event: " .. eventName); end);
            wrappedCondition =  wrapFunction(conditionFunc);
        else
            wrappedCondition = conditionFunc;
        end
        currentAddListener(
            core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
            --core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc, function(arg) output("Callback called: " .. listenerName .. ", for event: " .. eventName); end), persistent
        )
    end
    core.add_listener = myAddListener;

end

--v function(self: EXILES, cqi: CA_CQI) --> boolean
function exiles.army_is_exiles(self, cqi)
    return not not self._activeExiles[cqi]
end



--v function(self: EXILES, faction_key: string, accepting_faction: string)
function exiles.create_exiled_army_for_faction(self, faction_key, accepting_faction)
    
    local army_size = 15 - cm:random_number(5)
    local army_list = self._exiledArmyLists[faction_key]
    local army = army_list[cm:random_number(#army_list)]
    for i = 1, army_size - 1 do
        local next_unit = army_list[cm:random_number(#army_list)]
        army = army..","..next_unit
    end
    local region = cm:get_faction(accepting_faction):home_region()
    local x = region:settlement():logical_position_x() - 1
    local y = region:settlement():logical_position_y() - 1
    local leader_info = self._exiledLeaders[faction_key]

    cm:create_force_with_general(
        accepting_faction,
        army,
        region:name(),
        x,
        y,
        "general",
        leader_info.subtype,
        leader_info.forename,
        "",
        leader_info.surname,
        "",
        false,
        function(cqi)
            self._activeExiles[cqi] = faction_key
            cm:apply_effect_bundle_to_characters_force(CONST_EXILE_ARMY_BUNDLE, cqi, CONST_EXILE_BUNDLE_DURATION, true)
        end)

end


--v function(self: EXILES, conquesting_army: CA_CQI, region: CA_REGION)
function exiles.revive_faction(self, conquesting_army, region)
    local faction_to_revive = self._activeExiles[conquesting_army]

    --first, kill off the exiled army
    cm:kill_character(conquesting_army, true, true)
    self._activeExiles[conquesting_army] = nil

    --next, spawn a new army for the faction.
    local army_size = 15 - cm:random_number(5)
    local army_list = self._exiledArmyLists[faction_to_revive]
    local army = army_list[cm:random_number(#army_list)]
    for i = 1, army_size - 1 do
        local next_unit = army_list[cm:random_number(#army_list)]
        army = army..","..next_unit
    end
    local x = region:settlement():logical_position_x() - 1
    local y = region:settlement():logical_position_y() - 1
    local leader_info = self._exiledLeaders[faction_to_revive]

    cm:create_force_with_general(
        faction_to_revive,
        army,
        region:name(),
        x,
        y,
        "general",
        leader_info.subtype,
        leader_info.forename,
        "",
        leader_info.surname,
        "",
        false,
        function(cqi)
        end)
        cm:callback(function()
        --finally, transfer the region
        cm:transfer_region_to_faction(region:name(), faction_to_revive)
        end, 0.5);

end



--v function(self: EXILES)
function exiles.disable_buttons(self)
    local button_paths = self._disabledButtonPaths
    for i = 1, #button_paths do
        local uic = find_uicomponent_from_table(core:get_ui_root(), button_paths[i])
        if not not uic then
            uic:SetVisible(false)
            uic:SetInteractive(false)
            self._tooltips[uic:Id()] = uic:GetTooltipText()
            uic:SetTooltipText("You cannot access this function on an exiled army!", true)
        end
    end
    self._buttonsDisabled = true
end

--v function(self: EXILES)
function exiles.enable_buttons(self)
    if self._buttonsDisabled == true then
        local button_paths = self._disabledButtonPaths
        for i = 1, #button_paths do
            local uic = find_uicomponent_from_table(core:get_ui_root(), button_paths[i])
            if not not uic then
                uic:SetVisible(true)
                uic:SetInteractive(true)
                if not not self._tooltips[uic:Id()] then
                    uic:SetTooltipText(self._tooltips[uic:Id()], true)
                end
            end
        end
    end
    self._buttonsDisabled = false
end


--v function(self: EXILES, human_faction: CA_FACTION)
function exiles.trigger_valid_exiles(self, human_faction)
    local factions = self._exileDilemmas
    if human_faction:treasury() < 6000 then
        return 
    end
    if self._enabledCultures[human_faction:subculture()] then
        for faction, dilemma in pairs(factions) do
            local faction_obj = cm:get_faction(faction)
            if faction_obj:is_dead() then
                if not cm:get_saved_value("exiles_occured_"..faction) then
                    if not cm:get_saved_value("exiles_war_"..human_faction:name()..faction) then
                        if (human_faction:subculture() == faction_obj:subculture()) then

                        else
                            self:log("triggering exile dilemma for faction ["..faction.."]")
                            cm:trigger_dilemma(human_faction:name(), dilemma, true)
                            return
                        end
                    end
                end
            end
        end
    end
end

--v function(self: EXILES, human_faction: CA_FACTION)
function exiles.exclude_wars(self, human_faction)
    if human_faction:at_war() then
        local at_war_list = human_faction:factions_at_war_with()
        for i = 1, at_war_list:num_items() - 1 do
            local cur_faction = at_war_list:item_at(i):name()
            if self._exileDilemmas[cur_faction] then
                cm:set_saved_value("exiles_war_"..human_faction:name()..cur_faction, true)
            end
        end
    end
end

--v function(self: EXILES)
function exiles.check_active_exiles(self)
    for CQI, faction in pairs(self._activeExiles) do
        local mf = cm:get_character_by_cqi(CQI):military_force()
        if not mf:has_effect_bundle(CONST_EXILE_ARMY_BUNDLE) then
            self:log("An exiles timer has run out! Killing them!")
            cm:kill_character(CQI, true, true)
            self._activeExiles[CQI] = nil
        elseif not cm:get_faction(faction):is_dead() then
            cm:kill_character(CQI, true, true)
            self:log("An exiles ")
            self._activeExiles[CQI] = nil
        end
    end
end


--EXTERNAL API

--v function(self: EXILES, faction_key: string, dilemma_key: string, army_list: vector<string>, leader_subtype: string, leader_forename: string, leader_surname: string)
function exiles.add_faction(self, faction_key, dilemma_key, army_list, leader_subtype, leader_forename, leader_surname)
    self:log("Adding faction: ["..faction_key.."] as an exilable!")
    self._exileDilemmas[faction_key] = dilemma_key
    self._exiledArmyLists[faction_key] = army_list
    local leader_info = {}
    leader_info.subtype = leader_subtype
    leader_info.forename = leader_forename
    leader_info.surname = leader_surname
    self._exiledLeaders[faction_key] = leader_info
end


--v function(self: EXILES, subculture: string)
function exiles.enable_culture_as_recipient(self, subculture)
    self:log("enabling sc ["..subculture.."] to recieve exiles!")
    self._enabledCultures[subculture] = true
end

--v function(self: EXILES, button_path: vector<string>)
function exiles.add_button_to_disable(self, button_path)
    table.insert(self._disabledButtonPaths, button_path)
end



exiles.init():error_checker()

cm:add_saving_game_callback(function(context)
    cm:save_named_value("wec_exiles_core", _G.exile_manager._activeExiles, context)
end)

cm:add_loading_game_callback(function(context)
    _G.exile_manager._activeExiles = cm:load_named_value("wec_exiles_core", {}, context)
end)