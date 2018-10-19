local cc = _G.companion_control

--UI
core:add_listener(
    "CharacterSelectedCompControl",
    "CharacterSelected",
    function(context)
        return context:character():faction():is_human()
    end,
    function(context)
        if cc:is_army_companion(context:character():cqi()) then
            cc:disable_buttons()
        else
            cc:enable_buttons()
        end
    end,
    true
)

--actually removing the waaagh
core:add_listener(
    "CharacterWaaaghOccurredCompControl",
    "CharacterWaaaghOccurred",
    function(context)
        return context:character():faction():is_human() or context:character():faction():name():find("_waaagh") or context:character():faction():name():find("_brayherd")
    end,
    function(context)
        cc:switch_out_waaagh(context:character():cqi())
    end,
    true
)

--checking if the waaagh is still valid #1
core:add_listener(
    "CompControlUnitEventChecks",
    "UnitEvent",
    function(context)
        return cc:is_army_linked(context:unit():force_commander():cqi())
    end,
    function(context)
        local char = context:unit():force_commander() --:CA_CHAR
        if char:military_force():unit_list():num_items() < 17 or char:military_force():morale() < 80 then
            cc:kill_linked_force(char:cqi())
        end
    end,
    true
)
--checking if the waaagh is still valid #2
core:add_listener(
    "CompControlCharacterEventChecks",
    "CharacterEvent",
    function(context)
        return cc:is_army_linked(context:character():cqi())
    end,
    function(context)
        local char = context:character()--:CA_CHAR
        cc._currentChar = char:cqi()
        if (not cm:char_is_mobile_general_with_army(char)) or char:military_force():unit_list():num_items() < 17 or char:military_force():morale() < 80 then
            cc:kill_linked_force(char:cqi())
        end
    end,
    true
)

--checking if the waaagh is still valid #3
core:add_listener(
    "CharactersLostBattle",
    "CharacterCompletedBattle",
    function(context)
        return context:character():won_battle()
    end,
    function(context)
        local pb = context:pending_battle() --:CA_PENDING_BATTLE
        local character = context:character() --:CA_CHAR
        local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
        for i = 1, #enemies do
            local enemy = enemies[i]
            if cc:is_army_linked(enemy:cqi()) then
                if (not cm:char_is_mobile_general_with_army(enemy)) or enemy:military_force():unit_list():num_items() < 17 or enemy:military_force():morale() < 80 then
                    cc:kill_linked_force(enemy:cqi())
                end
            end
        end
    end,
    true
)




--disabling exchanges 
--function stolen from RM in weo lib
--v function() --> CA_CQI
local function find_second_army()

    --v function(ax: number, ay: number, bx: number, by: number) --> number
    local function distance_2D(ax, ay, bx, by)
        return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
    end;
    local first_char = cm:get_character_by_cqi(cc._currentChar)
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
        return nil
    end
end
--v function()
local function LockExchangeButton()
    local ok_button = find_uicomponent(core:get_ui_root(), "unit_exchange", "hud_center_docker", "ok_cancel_buttongroup", "button_ok")
    if not not ok_button then
        ok_button:SetInteractive(false)
        ok_button:SetImage("ui/skins/default/icon_disband.png")
    end
end

--v function()
local function UnlockExchangeButton()
    local ok_button = find_uicomponent(core:get_ui_root(), "unit_exchange", "hud_center_docker", "ok_cancel_buttongroup", "button_ok")
    if not not ok_button then
        ok_button:SetInteractive(true)
        ok_button:SetImage("ui/skins/default/icon_check.png")
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
            local first = cc._currentChar
            local second = find_second_army()
            --if either army is an companion army, disable the exchange!
            if cc:is_army_companion(first) or cc:is_army_companion(second) then
                LockExchangeButton()
            else
                UnlockExchangeButton()
            end
        end, 0.1)
    end,
    true
)