--utils and constants

local CONST_EXILE_ARMY_BUNDLE = "wec_exiled_army"
local CONST_EXILE_BUNDLE_DURATION = 25

--v function(x: number, y: number) --> boolean
local function IsValidSpawnPoint(x, y)
    local faction_list = cm:model():world():faction_list();
    
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i);
        local char_list = current_faction:character_list();
        
        for i = 0, char_list:num_items() - 1 do
            local current_char = char_list:item_at(i);
            if current_char:logical_position_x() == x and current_char:logical_position_y() == y then
                GOCLOG("Is valid spawn point returning false")
                return false;
            end;
        end;
    end;
    GOCLOG("is valid spawn point returning true")
    return true;
end;


--class: EXILES

--# assume global class EXILES
local exiles = {} --# assume exiles: EXILES


--v function()
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
    self._buttonsDisabled = false --:boolean
    _G.exile_manager = self
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
    local x = region:settlement():logical_position_x() + 1
    local y = region:settlement():logical_position_y() + 1
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
    local x = region:settlement():logical_position_x() + 1
    local y = region:settlement():logical_position_y() + 1
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

        --finally, transfer the region
        cm:transfer_region_to_faction(region:name(), faction_to_revive)


end



--v function(self: EXILES)
function exiles.disable_buttons(self)
    local button_paths = self._disabledButtonPaths
    for i = 1, #button_paths do
        local uic = find_uicomponent_from_table(core:get_ui_root(), button_paths[i])
        if not not uic then
            uic:SetInteractive(false)
            uic:SetTooltipText("You cannot access this function on an exiled army!", true)
        end
    end
    self._buttonsDisabled = true
end

--v function(self: EXILES)
function exiles.enable_buttons(self)
    local button_paths = self._disabledButtonPaths
    for i = 1, #button_paths do
        local uic = find_uicomponent_from_table(core:get_ui_root(), button_paths[i])
        if not not uic then
            uic:SetInteractive(true)
            uic:SetTooltipText("", false)
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
            cm:kill_character(CQI, true, true)
            self._activeExiles[CQI] = nil
        elseif not cm:get_faction(faction):is_dead() then
            cm:kill_character(CQI, true, true)
            self._activeExiles[CQI] = nil
        end
    end
end


--EXTERNAL API

--v function(self: EXILES, faction_key: string, dilemma_key: string, army_list: vector<string>, leader_subtype: string, leader_forename: string, leader_surname: string)
function exiles.add_faction(self, faction_key, dilemma_key, army_list, leader_subtype, leader_forename, leader_surname)
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
    self._enabledCultures[subculture] = true
end


exiles.init()