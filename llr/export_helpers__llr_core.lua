local llr = {}

--v function(text: string)
function llr.log(text)
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

--v function(cqi: CA_CQI)
local function are_you_sure(cqi)
    local UIPANELNAME = "llr_confirm"
    local ConfirmFrame = Frame.new(UIPANELNAME.."_confirm")
    ConfirmFrame:Resize(600, 400)
    ConfirmFrame:SetTitle("Respec?")
    Util.centreComponentOnScreen(ConfirmFrame)
    local ConfirmText = Text.new(UIPANELNAME.."_confirm_info", ConfirmFrame, "HEADER", "Would you like to fully respec this lord?")
    ConfirmText:Resize(420, 100)
    local ButtonYes = TextButton.new(UIPANELNAME.."_confirm_yes", ConfirmFrame, "TEXT", "Yes");
    ButtonYes:GetContentComponent():SetTooltipText("This can only be done once!", true)
    ButtonYes:Resize(300, 45);
    local ButtonNo = TextButton.new(UIPANELNAME.."_confirm_no", ConfirmFrame, "TEXT", "No");
    ButtonNo:GetContentComponent():SetTooltipText("Cancel", true)
    ButtonNo:Resize(300, 45);
    --v function()
    local function onYes()
        ConfirmFrame:Delete()
        --this is meant to be used to send a CQI, but it can take any integer!
        CampaignUI.TriggerCampaignScriptEvent(cqi, "LegendaryLordRespec")
    end
    
    ButtonYes:RegisterForClick( function()
        local ok, err = pcall(onYes)
        if not ok then
            llr.log("Error in reset function!")
            llr.log(tostring(err))
        end
    end)
    --v function()
    local function onNo()
        ConfirmFrame:Delete()
    end
    ButtonNo:RegisterForClick(function()
        onNo()
    end)

    Util.centreComponentOnComponent(ConfirmText, ConfirmFrame)
    local nudgeX, nudgeY = ConfirmText:Position()
    ConfirmText:MoveTo(nudgeX, nudgeY - 100)
    local offset = ConfirmText:Width()/2
    local fY = ConfirmFrame:Height()
    ButtonYes:PositionRelativeTo(ConfirmText, offset - 150, 60)
    ButtonNo:PositionRelativeTo(ButtonYes, 0, 60)
end





--v function(cqi: CA_CQI)
function llr.create_button(cqi)
    local uic = find_uicomponent(core:get_ui_root(), "character_details_panel")
    if (not not uic) and (find_uicomponent(uic, "skills_subpanel"):Visible()) then
        local RespecButton = Util.getComponentWithName("RespecButtonLLR")
        if RespecButton then 
            --# assume RespecButton: BUTTON
            RespecButton:Delete()
        end
        local parent = find_uicomponent(uic, "background", "skills_subpanel", "stats_reset_holder")
        local RespecButton = Button.new("RespecButtonLLR", parent, "CIRCULAR", "ui/skins/default/icon_home.png")
        --local posrel = find_uicomponent(uic, "rank")
        --RespecButton:MoveTo(110, 33)
        RespecButton:Resize(38, 38)
        if cm:get_saved_value("llr_respec_"..tostring(cqi)) then
            RespecButton:SetDisabled(true)
            RespecButton:GetContentComponent():SetTooltipText("[[col:red]]You have already respec'd this lord. This cannot be done twice! [[/col]]")
        else
            RespecButton:RegisterForClick(
                function(context)
                    local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "button_ok")
                    if not not uic then
                        uic:SimulateLClick()
                    end
                    are_you_sure(cqi)
                end
            )
        end
    end
end

core:add_listener(
    "LLRCharacterSelected",
    "CharacterSelected",
    function(context)
        return context:character():faction():is_human()
    end,
    function(context)
        llr.current_lord = context:character():cqi()
    end,
    true
)

core:add_listener(
    "PanelLLR",
    "PanelOpenedCampaign",
    function(context)
        return context.string == "character_details_panel"
    end,
    function(context)
        if llr.current_lord then
            local ok, err = pcall(function()
            llr.create_button(llr.current_lord)
            end) if not ok then llr.log(tostring(err)) end
        end
    end,
    true
)

core:add_listener(
    "SkiltabClick",
    "ComponentLClickUp",
    function(context)
        return context.string == "skills"
    end,
    function(context)
        cm:callback(function()
            if llr.current_lord then
                local ok, err = pcall(function()
                llr.create_button(llr.current_lord)
                end) if not ok then llr.log(tostring(err)) end
            end
        end, 0.1)
    end,
    true
)

core:add_listener(
    "Respec",
    "UITriggerScriptEvent",
    function(context)
        return context:trigger() == "LegendaryLordRespec"
    end,
    function(context)
        local cqi = context:faction_cqi() --: CA_CQI
        cm:set_saved_value("llr_respec_"..tostring(cqi), true)
        cm:force_reset_skills(cm:char_lookup_str(cqi))
    end,
    true)