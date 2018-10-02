--utils and constants

local CONST_EXILE_ARMY_BUNDLE = "wec_exiled_army"
local CONST_EXILE_BUNDLE_DURATION = 25


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
    self._exiledLeaders = {} --:map<string, {surname: map<string, string>, forename: map<string, string>, subtype: string}> -- <string> faction_key of exile, {surname: string, forename: string, subtype: string} leader info
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


--v function(self: EXILES) --> map<string, string>
function exiles.save(self)
    self:log("Saving exiles data: ")
    local savedata = {} --:map<string, string>
    for cqi, faction in pairs(self._activeExiles) do
        self:log("Active exile army with cqi ["..tostring(cqi).."] for faction ["..faction.."] ")
        savedata[tostring(cqi)] = faction
    end
    return savedata
end

--v [NO_CHECK] function(self: EXILES, savedata: map<string, string>)
function exiles.load(self, savedata)
    self:log("Loading exiles data: ")
    for cqi, faction in pairs(savedata) do
        self:log("Active exile army with cqi ["..cqi.."] for faction ["..faction.."] ")
        self._activeExiles[tonumber(cqi)] = faction
    end
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
    local sc = cm:get_faction(accepting_faction):subculture()

    cm:create_force_with_general(
        accepting_faction,
        army,
        region:name(),
        x,
        y,
        "general",
        leader_info.subtype,
        leader_info.forename[sc],
        "",
        leader_info.surname[sc],
        "",
        false,
        function(cqi)
            self._activeExiles[cqi] = faction_key
            cm:apply_effect_bundle_to_characters_force(CONST_EXILE_ARMY_BUNDLE, cqi, CONST_EXILE_BUNDLE_DURATION, true)
            local character = cm:get_character_by_cqi(cqi)
            cm:scroll_camera_from_current(1, false, {character:display_position_x(), character:display_position_y(), 14.7, 0.0, 12.0});
        end)
        
end


--v function(self: EXILES, conquesting_army: CA_CQI, region: CA_REGION)
function exiles.revive_faction(self, conquesting_army, region)
    local faction_to_revive = self._activeExiles[conquesting_army]

    --grant a reward
    cm:apply_effect_bundle("wec_exiles_reward_"..faction_to_revive, cm:get_character_by_cqi(conquesting_army):faction():name(), 30)

    --first, kill off the exiled army
    cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
    cm:set_character_immortality(cm:char_lookup_str(conquesting_army), false);
    cm:kill_character(conquesting_army, true, true)
    self._activeExiles[conquesting_army] = nil
    cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
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
    local sc = cm:get_faction(faction_to_revive):subculture()
    cm:create_force_with_general(
        faction_to_revive,
        army,
        region:name(),
        x,
        y,
        "general",
        leader_info.subtype,
        leader_info.forename[sc],
        "",
        leader_info.surname[sc],
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
            cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
            cm:kill_character(CQI, true, true)
            self._activeExiles[CQI] = nil
            cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
        elseif not cm:get_faction(faction):is_dead() then
            cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
            cm:kill_character(CQI, true, true)
            self:log("An exiles faction is revived! killing the duplicate!")
            self._activeExiles[CQI] = nil
            cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
        end
    end
end


--EXTERNAL API

--v function(self: EXILES, faction_key: string, dilemma_key: string, army_list: vector<string>, leader_subtype: string, leader_forename: map<string, string>, leader_surname: map<string,string>)
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
    local em = _G.exile_manager
    local savedata = em:save()
    cm:save_named_value("wec_exiles_save", savedata, context)
end)

cm:add_loading_game_callback(function(context)
    local em = _G.exile_manager
    local savedata = cm:load_named_value("wec_exiles_save", {}, context)
    em:load(savedata)
end)