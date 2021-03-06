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

--instantiation function
--v function() --> EXILES
function exiles.init()
    local self = {}
    setmetatable(self, {
        __index = exiles
    }) --# assume self: EXILES

    self._activeExiles = {} --:map<CA_CQI, string> -- <CA_CQI> CQI of the exiles army, <string> name of the faction who is exiled
    self._exiledArmyLists = {} --:map<string, vector<string>> -- <string> name of the faction who is exiled, <vector<string>> list of unit keys for use in create force.
    self._exiledLeaders = {} --:map<string, {surname: map<string, string>, forename: map<string, string>, subtype: string}> -- <string> faction_key of exile, 
                                                                                                                            --{surname: map<string, string>, forename: map<string, string>, subtype: string} leader info
                                                                                                                            -- the maps are culture to name key to get around the restrictions.
    self._enabledCultures = {} --:map<string, boolean> -- <string> subculture key of the faction who may recieve, <boolean> flag to recieve.
    self._exileDilemmas = {} --:map<string, string> -- <string> faction who can be an exile, <string> dilemma to trigger
    self._disabledButtonPaths = {} --:vector<vector<string>> -- <vector<vector<string>>> vector of file paths to use in find_by_table.
    self._tooltips = {} --:map<string, string> -- <string> component ID, <string> former tooltip
    self._buttonsDisabled = false --:boolean --flag if UI is modified currently.
    self._currentChar = nil --:CA_CQI --currently selected character, used for tracking exchanges.
    _G.exile_manager = self
    return self
end

--tunnel to log
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

--create a table of necessary save data
--v function(self: EXILES) --> map<string, string>
function exiles.save(self)
    self:log("Saving exiles data: ")
    local savedata = {} --:map<string, string>
    for cqi, faction in pairs(self._activeExiles) do
        self:log("Active exile army with cqi ["..tostring(cqi).."] for faction ["..faction.."] ")
        --convert CQI's to string, overwise when the table is loaded the numbers will be reset to 1, 2, 3 etc. due to serialisation.
        savedata[tostring(cqi)] = faction
    end
    return savedata
end

--load values from a save table. NO CHECK because Kailua doesn't aprove of flexible typing. 
--v [NO_CHECK] function(self: EXILES, savedata: map<string, string>)
function exiles.load(self, savedata)
    self:log("Loading exiles data: ")
    for cqi, faction in pairs(savedata) do
        self:log("Active exile army with cqi ["..cqi.."] for faction ["..faction.."] ")
        --we saved numbers as strings, return them to number
        self._activeExiles[tonumber(cqi)] = faction
    end
end


--is the given CQI an exiled army?
--v function(self: EXILES, cqi: CA_CQI) --> boolean
function exiles.army_is_exiles(self, cqi)
    return not not self._activeExiles[cqi]
end


--create an exiled army, store it, and apply the correct bundles.
--v function(self: EXILES, faction_key: string, accepting_faction: string)
function exiles.create_exiled_army_for_faction(self, faction_key, accepting_faction)
    
    -- vary army size randomly.
    local army_size = 15 - cm:random_number(5)
    local army_list = self._exiledArmyLists[faction_key] 
    local army = army_list[cm:random_number(#army_list)] --start with a random unit
    for i = 1, army_size - 1 do
        --add more units until size is reached.
        local next_unit = army_list[cm:random_number(#army_list)]
        army = army..","..next_unit
    end

    local region = cm:get_faction(accepting_faction):home_region()
    --should be sufficient for now. 
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
        leader_info.forename[sc], --sc used to get a name which will display properly. 
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

        --the create force command autoselects generals, but the UI events don't trigger and the bundle doesn't appear. 
        --Clear selection to prevent this. 
        cm:callback(function() 
            CampaignUI.ClearSelection();
        end, 0.4)
        
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
    --re using the spawn logic from above. Should be a minor detail.
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
        --finally, transfer the region; must be done on a delay to get around the bug with transfer and dead factions.
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
    local uim = cm:get_campaign_ui_manager();
    --this CA function is much cleaner than anything I could code.
    uim:override("disband_unit"):set_allowed(false); 
    uim:override("character_details"):set_allowed(false); 
    uim:override("recruit_units"):set_allowed(false);
    uim:override("recruit_mercenaries"):set_allowed(false);
    uim:override("regiments_of_renown"):set_allowed(false);
    self._buttonsDisabled = true
end

--v function(self: EXILES)
function exiles.enable_buttons(self)
    --ignore command if flag isn't set.
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
        local uim = cm:get_campaign_ui_manager();
        uim:override("disband_unit"):set_allowed(true);
        uim:override("character_details"):set_allowed(true); 
        uim:override("recruit_units"):set_allowed(true);
        uim:override("recruit_mercenaries"):set_allowed(true);
        uim:override("regiments_of_renown"):set_allowed(true);
    end
    self._buttonsDisabled = false
end


--v function(self: EXILES, human_faction: CA_FACTION)
function exiles.trigger_valid_exiles(self, human_faction)
    local factions = self._exileDilemmas
    --check if we have enough money
    if human_faction:treasury() < 6000 then
        return 
    end
    --if we do, check if we are the correct culture
    if self._enabledCultures[human_faction:subculture()] then
        for faction, dilemma in pairs(factions) do
            local faction_obj = cm:get_faction(faction)
            --if the exilable faction is dead
            if faction_obj:is_dead() then
                --if the exile hasn't occured yet.
                if not cm:get_saved_value("exiles_occured_"..faction) then
                    --if the exiled faction was not at war with us before they died
                    if not cm:get_saved_value("exiles_war_"..human_faction:name()..faction) then
                        --if the exiled faction doesn't belong to our culture
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
    --find the wars the human faction is involved in and set a save value to prevent exiles from that faction,
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
        --check if they still have their bundle
        if not mf:has_effect_bundle(CONST_EXILE_ARMY_BUNDLE) then
            self:log("An exiles timer has run out! Killing them!")
            cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
            cm:kill_character(CQI, true, true)
            self._activeExiles[CQI] = nil
            cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
        --check if they have been revived through other means.
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

--adds an exilable faction to the model.
--requires a full DB setup including: Name keys for each culture, culture animation permissions for all units, a dilemma, and a reward bundle. 
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

--enables culture as a recpient of these events. 
--v function(self: EXILES, subculture: string)
function exiles.enable_culture_as_recipient(self, subculture)
    self:log("enabling sc ["..subculture.."] to recieve exiles!")
    self._enabledCultures[subculture] = true
end

--add a button that needs to be disabled. Should not be necessary except for many on UI mods. 
--v function(self: EXILES, button_path: vector<string>)
function exiles.add_button_to_disable(self, button_path)
    table.insert(self._disabledButtonPaths, button_path)
end


--instantiate the manager with the error checker on.
exiles.init():error_checker()

--register save and load callbacks.

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