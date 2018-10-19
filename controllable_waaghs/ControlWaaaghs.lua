--# assume global class COMPANION_CONTROLLER
local companion_controller = {} --# assume companion_controller:COMPANION_CONTROLLER


--Log script to text
--v function(text: string | number | boolean | CA_CQI)
local function CCLOG(text)
    if not __write_output_to_logfile then
        return;
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("CC :  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

--v function() --> COMPANION_CONTROLLER
function companion_controller.init() 
    local self = {}
    setmetatable(self, {
        __index = companion_controller
    }) --# assume self: COMPANION_CONTROLLER

    self._companions = {} --:map<CA_CQI, boolean>
    self._armyLinks = {} --:map<CA_CQI, CA_CQI>
    self._linkedArmies = {} --:map<CA_CQI, boolean>
    self._currentChar = nil --:CA_CQI

    _G.companion_control = self
    return self
end

--v [NO_CHECK] function(self: COMPANION_CONTROLLER)
function companion_controller.error_checker(self)
--Vanish's PCaller
--All credits to vanish
--v function(func: function) --> any
    function safeCall(func)
        local status, result = pcall(func)
        if not status then
            CCLOG("ERROR")
            CCLOG(tostring(result))
            CCLOG(debug.traceback());
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




--v function(self: COMPANION_CONTROLLER, cqi: CA_CQI) --> boolean
function companion_controller.is_army_companion(self, cqi)
    return not not self._companions[cqi]
end

--v function(self: COMPANION_CONTROLLER, cqi: CA_CQI) --> boolean
function companion_controller.is_army_linked(self, cqi)
    return not not self._linkedArmies[cqi]
end




--v function(self: COMPANION_CONTROLLER)
function companion_controller.disable_buttons(self)
    local uim = cm:get_campaign_ui_manager();
    --this CA function is much cleaner than anything I could code.
    uim:override("disband_unit"):set_allowed(false); 
    uim:override("character_details"):set_allowed(false); 
    uim:override("recruit_units"):set_allowed(false);
    uim:override("recruit_mercenaries"):set_allowed(false);
    uim:override("regiments_of_renown"):set_allowed(false);
    self._buttonsDisabled = true
end
    
--v function(self: COMPANION_CONTROLLER)
function companion_controller.enable_buttons(self)
    --ignore command if flag isn't set.
    if self._buttonsDisabled == true then
        local uim = cm:get_campaign_ui_manager();
        uim:override("disband_unit"):set_allowed(true);
        uim:override("character_details"):set_allowed(true); 
        uim:override("recruit_units"):set_allowed(true);
        uim:override("recruit_mercenaries"):set_allowed(true);
        uim:override("regiments_of_renown"):set_allowed(true);
    end
    self._buttonsDisabled = false
end

--v function(self: COMPANION_CONTROLLER, cqi: CA_CQI)
function companion_controller.switch_out_waaagh(self, cqi)
    
    --CA isn't sure
    local char = cm:get_character_by_cqi(cqi)
    local faction_1 = char:faction():name()
    local culture = char:faction():culture()
    CCLOG("Switching out a waaagh from faction ["..faction_1.."]")
    local culture_to_suffix = {
        ["wh_dlc03_bst_beastmen"] = "_brayherd",
        ["wh_main_grn_greenskins"]= "_waaagh"
    } --:map<string, string>
    local real_faction --:string
    local comp_faction --:string
    local char_was_comp --:boolean
    if faction_1:find("_waaagh") then
        comp_faction = faction_1
        real_faction = faction_1:gsub("_waaagh", "")
        char_was_comp = true
    elseif faction_1:find("_brayherd") then
        comp_faction = faction_1
        real_faction = faction_1:gsub("_brayherd", "")
        char_was_comp = true
    else
        comp_faction = faction_1..culture_to_suffix[culture]
        real_faction = faction_1
        char_was_comp = false
    end

    local army_to_link --:CA_CHAR
    local comp_army --:CA_CHAR
    local army_string --:string
    local army_location = {} --:{x: number?, y: number?}
    local army_region --:string

    if char_was_comp then
        comp_army = char
        for i = 0, cm:get_faction(real_faction):character_list():num_items() - 1 do
            local char = cm:get_faction(real_faction):character_list():item_at(i)
            if cm:char_is_mobile_general_with_army(char) then
                if char:military_force():morale() > 99 then
                    if not self:is_army_linked(char:cqi()) then
                        army_to_link = char
                    end
                end
            end
        end
        if not comp_army:has_military_force() then
            return 
        end
        army_string = comp_army:military_force():unit_list():item_at(1):unit_key()
        for i = 2, comp_army:military_force():unit_list():num_items() - 1 do
            local next_unit = comp_army:military_force():unit_list():item_at(i):unit_key()
            if not next_unit:find("_cha_)") then
                army_string = army_string..","..next_unit
            end
        end
        army_location.x, army_location.y = comp_army:logical_position_x(), comp_army:logical_position_y()
        army_region = comp_army:region():name()
    else
        army_to_link = char
        for i = 0, cm:get_faction(comp_faction):character_list():num_items() - 1 do
            local char = cm:get_faction(comp_faction):character_list():item_at(i)
            if cm:char_is_mobile_general_with_army(char) then
                comp_army = char
            end
        end
        army_string = comp_army:military_force():unit_list():item_at(1):unit_key()
        for i = 2, comp_army:military_force():unit_list():num_items() - 1 do
            local next_unit = comp_army:military_force():unit_list():item_at(i):unit_key()
            if not next_unit:find("_cha_)") then
                army_string = army_string..","..next_unit
            end
        end
        army_location.x, army_location.y = comp_army:logical_position_x(), comp_army:logical_position_y()
        army_region = comp_army:region():name()
    end

    self._linkedArmies[army_to_link:cqi()] = true

    cm:kill_character(comp_army:cqi(), true, true)
    CCLOG("Replacing the army belonging to ["..comp_faction.."] with an army for ["..real_faction.."]")
    CCLOG("\t Spawning at:  ["..tostring(army_location.x).."], ["..tostring(army_location.y).."], in region ["..army_region.."]")
    CCLOG("\t with force: ["..army_string.."]")
    cm:create_force(
        real_faction,
        army_string,
        army_region,
        army_location.x,
        army_location.y,
        true, 
        true,
        function(cqi)
            self._armyLinks[army_to_link:cqi()] = cqi
            self._companions[cqi] = true
            cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true)
            cm:apply_effect_bundle_to_characters_force("wec_controlled_companion", cqi, 0, true)
        end
    )

end


--v function(self: COMPANION_CONTROLLER, linked_army: CA_CQI)
function companion_controller.kill_linked_force(self, linked_army)
    CCLOG("Destroying linked force for ["..tostring(linked_army).."] which is force ["..tostring(self._armyLinks[linked_army]).."] ")
    if not self:is_army_linked(linked_army) then
        return 
    end
    self._linkedArmies[linked_army] = nil
    cm:kill_character(self._armyLinks[linked_army], true, true)
    self._armyLinks[linked_army] = nil
end

companion_controller.init():error_checker()
CCLOG("Init")