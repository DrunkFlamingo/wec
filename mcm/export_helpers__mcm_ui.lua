mcm = _G.mcm
--[[local mod = mcm:register_mod("tests", "Empire of Man", "toooool tip xd")
local mod2 = mcm:register_mod("secondtest", "Old World Rites", "tooooooooollllltiiiiiiipppppp")
local multiple_choice = mod:add_tweaker("test_tweaker", "test tweaker", "fuck you thats what")
local choice_1 = multiple_choice:add_option("key", "An option"):add_callback(function(context) end)
local choice_2 = multiple_choice:add_option("Key2", "Another option")
local var = mod:add_variable("var", 0, 10, 5, 1, "A var")]]

local MCMBASIC = "mcm_basic"
local UIPANELNAME = "MCM_PANEL"


--called multiple times during runtime
--v function(MCMMainFrame: FRAME)
local function PopulateModOptions(MCMMainFrame)
    local fpX, fpY = MCMMainFrame:Position()
    local fbX, fbY = MCMMainFrame:Bounds()
    if not mcm:has_selected_mod() then
        return
    end
    local existingList = Util.getComponentWithName(UIPANELNAME.."_MOD_OPTIONS_LISTVIEW")
    local existingHeader = Util.getComponentWithName(UIPANELNAME.."_MOD_OPTIONS_LIST_HEADER")
    if not not existingList then
        --# assume existingList: LIST_VIEW
        --# assume existingHeader: TEXT
        existingList:Delete()
        existingHeader:Delete()
    end
    local mod = mcm:get_current_mod()

    local ModOptionListHeader = Text.new(UIPANELNAME.."_MOD_OPTIONS_LIST_HEADER", MCMMainFrame, "HEADER", mod:ui_name())
    ModOptionListHeader:Resize(400, 40)
    ModOptionListHeader:PositionRelativeTo(MCMMainFrame, fbX*0.04 + 350, fbY*0.04)
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
            local has_row_two = (num_slots >= 4 or num_slots)
            local has_row_three = (num_slots >= 7)
            if has_row_two then
                TweakerRowTwo = Container.new(FlowLayout.HORIZONTAL)
                TweakerRowTwo:AddGap(260)
                if has_row_three then
                    TweakerRowThree = Container.new(FlowLayout.HORIZONTAL)
                    TweakerRowThree:AddGap(260)
                end
            end
    
            local TweakerText = Text.new(mod:name().."_"..key.."_tweaker_title", MCMMainFrame, "HEADER", tweaker:ui_name())
            TweakerText:Resize(250, 45)
            TweakerText:GetContentComponent():SetTooltipText(tweaker:ui_tooltip(), true)
            TweakerContainer:AddComponent(TweakerText)
            TweakerContainer:AddGap(10)
            local processed = 0 
            if num_slots == 4 then
                processed = 1
            end
            for option_name, option in pairs(tweaker:options()) do
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
                if processed < 3 then
                    TweakerContainer:AddComponent(OptionButton)
                    TweakerContainer:AddGap(10)
                elseif processed < 6 then
                    TweakerRowTwo:AddComponent(OptionButton)
                    TweakerRowTwo:AddGap(10)
                elseif processed < 9 then
                    TweakerRowThree:AddComponent(OptionButton)
                    TweakerRowThree:AddGap(10)
                else
                    mcm:log("UI: More than 9 options on tweaker ["..key.."], not showing the extras!")
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
        local VariableContainer = Container.new(FlowLayout.HORIZONTAL)
        local VariableText = Text.new(mod:name().."_"..key.."_variable_title", MCMMainFrame, "HEADER", variable:ui_name())
        VariableText:GetContentComponent():SetTooltipText(variable:ui_tooltip(), true)
        VariableText:Resize(250, 45)
        local IncrementButton = TextButton.new(mod:name().."_"..key.."_variable_up", MCMMainFrame, "TEXT", "+");
        IncrementButton:GetContentComponent():SetTooltipText("Increment this variable.", true)
        IncrementButton:Resize(230, 45);
        local valueTextContainer = Container.new(FlowLayout.VERTICAL)
        local ValueText = Text.new(mod:name().."_"..key.."_variable_value", MCMMainFrame, "HEADER", tostring(variable:current_value()))
        ValueText:Resize(100, 45)
        ValueText:GetContentComponent():SetTooltipText("Current Value", true)
        valueTextContainer:AddGap(10)
        valueTextContainer:AddComponent(ValueText)
        local DecrementButton = TextButton.new(mod:name().."_"..key.."_variable_down", MCMMainFrame, "TEXT", "-");
        DecrementButton:GetContentComponent():SetTooltipText("Decrement this variable.", true)
        DecrementButton:Resize(230, 45);
        IncrementButton:RegisterForClick(function()
            variable:increment_value()
            ValueText:SetText(tostring(variable:current_value()))
        end)
        DecrementButton:RegisterForClick(function()
            variable:decrement_value()
            ValueText:SetText(tostring(variable:current_value()))
        end)
        VariableContainer:AddComponent(VariableText)
        VariableContainer:AddGap(10) 
        VariableContainer:AddComponent(DecrementButton) --230
        VariableContainer:AddGap(45) --275
        VariableContainer:AddComponent(valueTextContainer) --375
        VariableContainer:AddGap(5) --380
        VariableContainer:AddComponent(IncrementButton) --610
        ModOptionListView:AddContainer(VariableContainer)
        VariableContainer:Reposition()
    end
    ModOptionListView:PositionRelativeTo(ModOptionListHeader, -20, 50)
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
        Util.centreComponentOnScreen(frame)        

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
            local CloseButton = Button.new(UIPANELNAME.."_CLOSE_BUTTON", MCMMainFrame, "CIRCULAR", "ui/skins/default/icon_check.png")
            CloseButton:Resize(56, 56)
            CloseButton:RegisterForClick(function()
            if advice_exists then 
                advisor:SetVisible(true) 
            end
            MCMMainFrame:Delete() 
            mcm:clear_UIC()
            core:remove_listener("MCMHider")
            layout:SetVisible(true)
            mcm:sync_for_mp()
            mcm:process_all_mods()
        end)

        local frameWidth = MCMMainFrame:Width()
        local frameHeight = MCMMainFrame:Height()
        local buttonWidth = CloseButton:Width()
        local buttonHeight = CloseButton:Height()
        CloseButton:PositionRelativeTo(frame, frameWidth/2 - buttonWidth/2, frameHeight - buttonHeight*2)
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