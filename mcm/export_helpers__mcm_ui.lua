mcm = _G.mcm
--[[local mod = mcm:register_mod("tests", "Empire of Man", "toooool tip xd")
local mod2 = mcm:register_mod("secondtest", "Old World Rites", "tooooooooollllltiiiiiiipppppp")
local multiple_choice = mod:add_tweaker("test_tweaker", "test tweaker", "fuck you thats what")
local choice_1 = multiple_choice:add_option("key", "An option"):add_callback(function(context) end)
local choice_2 = multiple_choice:add_option("Key2", "Another option")
local var = mod:add_variable("var", 0, 10, 5, 1, "A var")]]

local MCMBASIC = "mcm_basic"
local UIPANELNAME = "MCM_PANEL"

--v function(hide: boolean)
local function show_mcm(hide)
    local panel = find_uicomponent(core:get_ui_root(), UIPANELNAME)
    local button = find_uicomponent(core:get_ui_root(), UIPANELNAME.."_CLOSE_BUTTON")
    if not not panel then
        panel:SetVisible(hide)
    end
    if not not button then
        button:SetVisible(hide)
    end
end


--called multiple times during runtime
--v function(MCMMainFrame: FRAME)
local function PopulateModOptions(MCMMainFrame)
    local fpX, fpY = MCMMainFrame:Position()
    local fbX, fbY = MCMMainFrame:Bounds()
    if not mcm:has_selected_mod() then
        return
    end

    --subfunction. This is kept here because it needs to be able to call this function.
    --v function(mod: MCM_MOD, setting: MCM_TWEAKER | MCM_VAR)
    local function reset_to_default_confirmation(mod, setting)
        show_mcm(false)
        local ConfirmFrame = Frame.new(UIPANELNAME.."_confirm")
        ConfirmFrame:Resize(600, 400)
        ConfirmFrame:SetTitle("Confirm")
        Util.centreComponentOnScreen(ConfirmFrame)
        local ConfirmText = Text.new(UIPANELNAME.."_confirm_info", ConfirmFrame, "HEADER", "Are you sure you would like to fully reset this value?")
        ConfirmText:Resize(420, 100)
        local ButtonYes = TextButton.new(UIPANELNAME.."_confirm_yes", ConfirmFrame, "TEXT", "Yes");
        ButtonYes:GetContentComponent():SetTooltipText("Reset this option to it's default value", true)
        ButtonYes:Resize(300, 45);
        local ButtonNo = TextButton.new(UIPANELNAME.."_confirm_no", ConfirmFrame, "TEXT", "No");
        ButtonNo:GetContentComponent():SetTooltipText("Cancel", true)
        ButtonNo:Resize(300, 45);
        --these aren't pretty but kailua doesn't support calling during definition.
        --v [NO_CHECK] function()
        local function onYes()
            show_mcm(true)
            ConfirmFrame:Delete()
            mod:reset_setting_to_default(setting)
            PopulateModOptions(MCMMainFrame)
        end
        ButtonYes:RegisterForClick( function()
            local ok, err = pcall(onYes)
            if not ok then
                mcm:log("Error in reset function!")
                mcm:log(tostring(err))
            end
        end)
        --v function()
        local function onNo()
            show_mcm(true)
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
    local existingList = Util.getComponentWithName(UIPANELNAME.."_MOD_OPTIONS_LISTVIEW")
    if not not existingList then
        --# assume existingList: LIST_VIEW
        existingList:Delete()
    end
    local mod = mcm:get_current_mod()
    MCMMainFrame:SetTitle("Mod Configuration Tool: "..mod:ui_name())
    local ModOptionListView = ListView.new(UIPANELNAME.."_MOD_OPTIONS_LISTVIEW", MCMMainFrame, "VERTICAL")
    ModOptionListView:Resize(1300, 600)
    local ModOptionListBuffer = Container.new(FlowLayout.VERTICAL)
    ModOptionListBuffer:AddGap(10)
    ModOptionListView:AddContainer(ModOptionListBuffer)
    for key, tweaker in pairs(mod:tweakers()) do
       if not not tweaker:selected_option() then
            local num_slots = tweaker:num_options()
            local TweakerContainer = Container.new(FlowLayout.HORIZONTAL)
            local TweakerRowTwo  --:CONTAINER
            local TweakerRowThree --: CONTAINER
            local has_row_two = (num_slots >= 1)
            local has_row_three = (num_slots >= 5)
            TweakerRowTwo = Container.new(FlowLayout.HORIZONTAL)
            if has_row_three then
                TweakerRowThree = Container.new(FlowLayout.HORIZONTAL)
            end
            local TweakerTextBuffer = Container.new(FlowLayout.VERTICAL)
            TweakerTextBuffer:AddGap(20)
            local TweakerText = Text.new(mod:name().."_"..key.."_tweaker_title", MCMMainFrame, "HEADER", tweaker:ui_name()..":")
            TweakerText:Resize(600, 35)
            TweakerText:GetContentComponent():SetTooltipText(tweaker:ui_tooltip(), true)
            TweakerTextBuffer:AddComponent(TweakerText)
            local ResetBuffer = Container.new(FlowLayout.VERTICAL)
            ResetBuffer:AddGap(15)
            local resetButton = Button.new(mod:name().."_"..key.."_tweaker_reset", MCMMainFrame, "CIRCULAR", "ui/skins/warhammer2/icon_home.png")
            resetButton:Resize(35, 35)
            resetButton:GetContentComponent():SetTooltipText("Reset this tweaker to it's default option", true)
            resetButton:RegisterForClick(function() 
                reset_to_default_confirmation(mod, tweaker)
            end)
            ResetBuffer:AddComponent(resetButton)
            TweakerContainer:AddComponent(TweakerTextBuffer)
            local gap = 10 --:number
            if num_slots > 2 then
                local i --:number
                if num_slots > 4 then
                    i = num_slots - 6
                else
                    i = num_slots - 2
                end
                gap = gap + (i * 310)
            end
            TweakerContainer:AddGap(gap)
            TweakerContainer:AddComponent(ResetBuffer)
            local processed = 0 
            for option_name, option in pairs(tweaker:options()) do
                local OptionButtonContainer
                local OptionButton = TextButton.new(mod:name().."_"..key.."_option_button_"..option_name, MCMMainFrame, "TEXT_TOGGLE", option:ui_name())
                OptionButton:Resize(300, 45)
                OptionButton:GetContentComponent():SetTooltipText(option:ui_tooltip(), true)
                if option_name == tweaker:selected_option():name() then
                    OptionButton:SetState("selected")
                end
                OptionButton:RegisterForClick(function()
                    if tweaker:selected_option() == option then
                        OptionButton:SetState("selected")
                    else
                        local old_option = tweaker:selected_option():name()
                        local OtherButton = Util.getComponentWithName(mod:name().."_"..key.."_option_button_"..old_option)
                        if not not OtherButton then
                            --# assume OtherButton:BUTTON
                            OtherButton:SetState("active")
                        end
                        tweaker:set_selected_option(option)
                        OptionButton:SetState("selected")
                    end
                end)
                if processed < 4 then
                    TweakerRowTwo:AddComponent(OptionButton)
                    TweakerRowTwo:AddGap(10)
                elseif processed < 8 then
                    TweakerRowThree:AddComponent(OptionButton)
                    TweakerRowThree:AddGap(10)
                else
                    mcm:log("UI: More than 8 options on tweaker ["..key.."], not showing the extras!")
                end
                processed = processed + 1 
            end
            ModOptionListView:AddContainer(TweakerContainer)
            if has_row_two then
                ModOptionListView:AddContainer(TweakerRowTwo)
                TweakerRowTwo:Reposition()
                if has_row_three then
                    ModOptionListView:AddContainer(TweakerRowThree)
                    TweakerRowTwo:Reposition()
                end
            end
            TweakerContainer:Reposition()
        end
    end
    for key, variable in pairs(mod:variables()) do
        local VariableTopContainer = Container.new(FlowLayout.HORIZONTAL)
        local VariableBotContainer = Container.new(FlowLayout.HORIZONTAL)
        local VariableTextBuffer = Container.new(FlowLayout.VERTICAL)
        VariableTextBuffer:AddGap(20)
        local VariableText = Text.new(mod:name().."_"..key.."_variable_title", MCMMainFrame, "HEADER", variable:ui_name())
        VariableText:GetContentComponent():SetTooltipText(variable:ui_tooltip(), true)
        VariableText:Resize(600, 35)
        VariableTextBuffer:AddComponent(VariableText)
        local ResetBuffer = Container.new(FlowLayout.VERTICAL)
        ResetBuffer:AddGap(15)
        local resetButton = Button.new(mod:name().."_"..key.."_tweaker_reset", MCMMainFrame, "CIRCULAR", "ui/skins/warhammer2/icon_home.png")
        resetButton:Resize(35, 35)
        resetButton:GetContentComponent():SetTooltipText("Reset this tweaker to it's default option", true)
        resetButton:RegisterForClick(function() 
            reset_to_default_confirmation(mod, variable)
        end)
        ResetBuffer:AddComponent(resetButton)
        local valueTextContainer = Container.new(FlowLayout.VERTICAL)
        local ValueText = Text.new(mod:name().."_"..key.."_variable_value", MCMMainFrame, "HEADER", tostring(variable:current_value()))
        ValueText:Resize(100, 45)
        ValueText:GetContentComponent():SetTooltipText("Current Value of this variable. \n This variable has a maximum of "..variable:maximum().." and a minimum of "..variable:minimum()..".", true)
        valueTextContainer:AddGap(10)
        valueTextContainer:AddComponent(ValueText)
        local IncrementButton = TextButton.new(mod:name().."_"..key.."_variable_up", MCMMainFrame, "TEXT", "+");
        IncrementButton:GetContentComponent():SetTooltipText("Increment this variable.", true)
        IncrementButton:Resize(140, 45);
        IncrementButton:RegisterForClick(function()
            variable:increment_value()
            ValueText:SetText(tostring(variable:current_value()))
        end)
        local DecrementButton = TextButton.new(mod:name().."_"..key.."_variable_down", MCMMainFrame, "TEXT", "-");
        DecrementButton:GetContentComponent():SetTooltipText("Decrement this variable.", true)
        DecrementButton:Resize(140, 45);
        DecrementButton:RegisterForClick(function()
            variable:decrement_value()
            ValueText:SetText(tostring(variable:current_value()))
        end)
        local MaxButton = TextButton.new(mod:name().."_"..key.."_variable_max", MCMMainFrame, "TEXT", "Max");
        MaxButton:GetContentComponent():SetTooltipText("Increase this variable to it's maximum value.", true)
        MaxButton:Resize(140, 45);
        MaxButton:RegisterForClick(function()
            variable:set_current_value(variable:maximum())
            ValueText:SetText(tostring(variable:maximum()))
        end)
        local MinButton = TextButton.new(mod:name().."_"..key.."_variable_min", MCMMainFrame, "TEXT", "Min");
        MinButton:GetContentComponent():SetTooltipText("Increase this variable to it's minimu, value.", true)
        MinButton:Resize(140, 45);
        MinButton:RegisterForClick(function()
            variable:set_current_value(variable:minimum())
            ValueText:SetText(tostring(variable:minimum()))
        end)

        -----assemble
        VariableTopContainer:AddComponent(VariableTextBuffer)
        VariableTopContainer:AddGap(10) 
        VariableTopContainer:AddComponent(ResetBuffer)
        VariableBotContainer:AddComponent(MinButton)
        VariableBotContainer:AddGap(10) 
        VariableBotContainer:AddComponent(DecrementButton) 
        VariableBotContainer:AddGap(40) 
        VariableBotContainer:AddComponent(valueTextContainer) 
        VariableBotContainer:AddGap(5)
        VariableBotContainer:AddComponent(IncrementButton) 
        VariableBotContainer:AddGap(10) 
        VariableBotContainer:AddComponent(MaxButton)
        ModOptionListView:AddContainer(VariableTopContainer)
        ModOptionListView:AddContainer(VariableBotContainer)
    end
    ModOptionListView:PositionRelativeTo(MCMMainFrame, fbX*0.04 + 350, fbY*0.04)
    local reX, reY = ModOptionListView:Position()
    ModOptionListView:MoveTo(reX, reY)
end



--v function(MCMMainFrame: FRAME)
local function PopulateList(MCMMainFrame)
    local fpX, fpY = MCMMainFrame:Position()
    local fbX, fbY = MCMMainFrame:Bounds()
    local sX, sY = core:get_screen_resolution()
    local ModHeaderListHolder = Container.new(FlowLayout.VERTICAL)
    local ModListHeader = Text.new(UIPANELNAME.."_MOD_LIST_HEADER_TEXT", MCMMainFrame, "HEADER", "Installed Mods")
    ModListHeader:Resize(200, 40)
    ModListHeader:PositionRelativeTo(MCMMainFrame, fbX*0.04, fbY*0.04)
    local ModHeaderListView = ListView.new(UIPANELNAME.."_MOD_HEADER_LISTVIEW", MCMMainFrame, "VERTICAL")
    ModHeaderListView:Resize(310, fbX*0.8)
        local ModHeaderListBufferContainer = Container.new(FlowLayout.VERTICAL)
        ModHeaderListBufferContainer:AddGap(10)
    ModHeaderListView:AddContainer(ModHeaderListBufferContainer)
    local mods = mcm._registeredMods
    --load up the MCM default first
    do 
        local key = MCMBASIC
        local mod = mcm:get_mod(key)
        local modTextButton = TextButton.new(UIPANELNAME.."_MOD_HEADER_BUTTON_"..key, MCMMainFrame, "TEXT_TOGGLE", mod:ui_name())
        modTextButton:Resize(300, 45)
        modTextButton:GetContentComponent():SetTooltipText(mod:ui_tooltip(), true)
        modTextButton:SetState("selected")
        modTextButton:RegisterForClick(function()
            local old_selected = mcm:get_current_mod():name()
            if old_selected ~= key then
                local OtherButton = Util.getComponentWithName(UIPANELNAME.."_MOD_HEADER_BUTTON_"..old_selected)
                if not not OtherButton then
                    --# assume OtherButton: BUTTON
                    OtherButton:SetState("active")
                end
                mcm:make_mod_with_key_selected(key)
                PopulateModOptions(MCMMainFrame)
                modTextButton:SetState("selected")
            end
        end)
        ModHeaderListView:AddComponent(modTextButton)   
        mcm:make_mod_with_key_selected(MCMBASIC)  
    end
    for key, mod in pairs(mcm:get_mods()) do
        if key ~= "mcm_basic" then
            local modTextButton = TextButton.new(UIPANELNAME.."_MOD_HEADER_BUTTON_"..key, MCMMainFrame, "TEXT_TOGGLE", mod:ui_name())
            modTextButton:Resize(300, 45)
            modTextButton:GetContentComponent():SetTooltipText(mod:ui_tooltip(), true)
            modTextButton:SetState("active")
            modTextButton:RegisterForClick(function()
                local old_selected = mcm:get_current_mod():name()
                if old_selected ~= key then
                    local OtherButton = Util.getComponentWithName(UIPANELNAME.."_MOD_HEADER_BUTTON_"..old_selected)
                    if not not OtherButton then
                        --# assume OtherButton: BUTTON
                        OtherButton:SetState("active")
                    end
                    mcm:make_mod_with_key_selected(key)
                    PopulateModOptions(MCMMainFrame)
                    modTextButton:SetState("selected")
                end
            end)
            ModHeaderListView:AddComponent(modTextButton)       
        end 
    end
    
    ModHeaderListHolder:AddComponent(ModHeaderListView)
    ModHeaderListHolder:PositionRelativeTo(ModListHeader, -20, 50)
end


local function CreatePanel()
    local existingFrame = Util.getComponentWithName(UIPANELNAME)
    if not not existingFrame then
        --# assume existingFrame: FRAME
        existingFrame:Delete()
    end
    local buttonsDocker = find_uicomponent(core:get_ui_root(), "layout", "faction_buttons_docker")
    core:add_listener(
        "MCMHider",
        "PanelOpenedCampaign",
        function(context)
            if UIComponent(context.component):Id() ~= "MCM_PANEL" then 
                return true 
            else 
                return false 
            end
        end,
        function(context)
            local uic = UIComponent(context.component)
            mcm:cache_UIC(uic)
            uic:SetVisible(false)
        end,
        true
        );
    cm:callback(function()
        local layout = find_uicomponent(core:get_ui_root(), "layout")
        layout:SetVisible(false)
        CampaignUI.ClearSelection()
        local MCMMainFrame = Frame.new(UIPANELNAME)

        local advice_exists = false
        local advisor = find_uicomponent(core:get_ui_root(), "advice_interface")
        if not not advisor then
            advice_exists = true
            advisor:SetVisible(false)
        end

        local sX, sY = core:get_screen_resolution()
        MCMMainFrame:Resize(sX * 0.98, sY * 0.88)
        local frame = Util.getComponentWithName(UIPANELNAME)
        --# assume frame: FRAME
        Util.centreComponentOnScreen(frame)        
        local parchment = find_uicomponent(frame.uic, "parchment")
        local fX, fY = frame.uic:Position()
        local fW, fH = frame.uic:Bounds()
        local pX, pY = parchment:Bounds()
        local gapX, gapY = fW - pX, fH - pY
        parchment:MoveTo(fX + gapX/2, fY + gapY/2)
        --set the title
        MCMMainFrame:SetTitle("Mod Configuration Tool")
        --create MP sync listener
        if cm:is_multiplayer() == true then
            core:add_listener(
                "MCMSync",
                "UITriggerScriptEvent",
                function(context)
                    return context:trigger():starts_with("mcm|sync|") and context:faction_cqi() ~= cm:get_faction(cm:get_local_faction(true)):command_queue_index()
                end,
                function(context)
                    --restore UI
                    if advice_exists then 
                        advisor:SetVisible(true) 
                    end
                    MCMMainFrame:Delete() 
                    local closebutton = Util.getComponentWithName(UIPANELNAME.."_CLOSE_BUTTON")
                    if not not closebutton then
                        --# assume closebutton: BUTTON
                        closebutton:Delete()
                    end
                    mcm:clear_UIC()
                    core:remove_listener("MCMHider")
                    layout:SetVisible(true)
                    --sync choices
                    local sync_string = string.gsub(context:trigger(), "mcm|sync|", "")
                    local sync_data 
                    if sync_string:len() > 1 then
                        local tab_func = loadstring("return {"..sync_string.."}")
                        if is_function(tab_func) then
                            --# assume tab_func: function() --> map<string, map<string, string>>
                            sync_data = tab_func()
                        end
                    end
                    if sync_data == nil then
                        mcm:log("ERROR: Data Could not be synced for MP Game!")
                        return
                    end
                    for mixed_key, data_pairs in pairs(sync_data) do
                        if string.find(mixed_key, "_T!") then
                            local true_key = string.gsub(mixed_key, "_T!", "")
                            if mcm:has_mod(true_key) then
                                local mod = mcm:get_mod(true_key)
                                for tweaker_key, tweaker_option in pairs(data_pairs) do
                                    if mod:has_tweaker(tweaker_key) and mod:get_tweaker_with_key(tweaker_key):has_option(tweaker_option) then
                                        mod:get_tweaker_with_key(tweaker_key):set_selected_option_with_key(tweaker_option)
                                    else
                                        mcm:log("Syncing Error! Could not sync the tweaker with key ["..tweaker_key.."] and option ["..tweaker_option.."]")
                                    end
                                end
                            else
                                mcm:log("Snycing Error! Could not sync the data set ["..mixed_key.."] because the mod key ["..true_key.."] could not be found!")
                            end
                        elseif string.find(mixed_key, "_V!") then
                            local true_key = string.gsub(mixed_key, "_V!", "")
                            if mcm:has_mod(true_key) then
                                local mod = mcm:get_mod(true_key)
                                for variable_key, value in pairs(data_pairs) do
                                    local true_val = tonumber(value)
                                    if mod:has_variable(variable_key) and mod:get_variable_with_key(variable_key):is_value_valid(true_val) then
                                        mod:get_variable_with_key(variable_key):set_current_value(true_val)
                                    else
                                        mcm:log("Syncing Error! Could not sync the var with key ["..variable_key.."] and value ["..value.."]")
                                    end
                                end
                            else
                                mcm:log("Snycing Error! Could not sync the data set ["..mixed_key.."] because the mod key ["..true_key.."] could not be found!")
                            end
                        end
                    end
                    --apply choices
                    mcm:process_all_mods()
                end,
                false
            )
        end
            --create close button
            local CloseButton = TextButton.new(UIPANELNAME.."_CLOSE_BUTTON", core:get_ui_root(), "TEXT", "Finalize")
            CloseButton:Resize(300, 45)
            CloseButton:RegisterForClick(function()
            CloseButton:SetVisible(false)
            local existingMods = Util.getComponentWithName(UIPANELNAME.."_MOD_LIST_HEADER_TEXT")
            local existingList = Util.getComponentWithName(UIPANELNAME.."_MOD_OPTIONS_LISTVIEW")
            if (not not existingMods) and (not not existingList) then
                --# assume existingMods: LIST_VIEW
                --# assume existingList: LIST_VIEW
                existingMods:Delete()
                existingList:Delete()
                local loading = Text.new(UIPANELNAME.."_CLOSEDOWN_LOAD", MCMMainFrame, "HEADER", "Loading!")
                loading:Resize(500, 200)
                Util.centreComponentOnComponent(loading, MCMMainFrame)
            end
            if advice_exists then 
                advisor:SetVisible(true) 
            end
            mcm:clear_UIC()
            core:remove_listener("MCMHider")
            layout:SetVisible(true)
            mcm:sync_for_mp()
            mcm:process_all_mods()
            MCMMainFrame:Delete() 
            CloseButton:Delete()
        end)
        local bX, bY = CloseButton:Bounds()
        CloseButton:MoveTo(sX/2 - bX/2, (sY*0.90))
        PopulateList(MCMMainFrame)
        PopulateModOptions(MCMMainFrame)
    end, 1.0)
end;

if cm:get_saved_value("mcm_finalized") == nil then
    core:add_listener(
        "MCMTrigger",
        "ScriptEventCampaignCutsceneCompleted",
        function(context)
            return cm:model():turn_number() <= 1 and not cm:is_multiplayer()
        end,
        function(context)
            CreatePanel();
        end,
        false
    );
    cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function()
        if cm:is_multiplayer() then
            CreatePanel()
        end
    end
else
    mcm:log("MCM already triggered on this save file!")
    cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function()
        mcm:process_all_mods()
    end
end