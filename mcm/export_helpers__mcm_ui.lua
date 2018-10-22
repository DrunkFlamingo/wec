mcm = _G.mcm
local mod = mcm:register_mod("tests", "Empire of Man", "toooool tip xd")
local mod2 = mcm:register_mod("secondtest", "Old World Rites", "tooooooooollllltiiiiiiipppppp")
local multiple_choice = mod:add_tweaker("test_tweaker", "test tweaker", "fuck you thats what")
local choice_1 = multiple_choice:add_option("key", "An option"):add_callback(function(context) end)
local choice_2 = multiple_choice:add_option("Key2", "Another option")
local var = mod:add_variable("var", 0, 10, 5, 1, "A var")

local MCMBASIC = "mcm_basic"
local UIPANELNAME = "MCM_PANEL"

--v function (MCMMainFrame: FRAME)
local function PopulateOption(MCMMainFrame)


end

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
    ModOptionListView:Resize(1000, 800)
    local ModOptionListBuffer = Container.new(FlowLayout.VERTICAL)
    ModOptionListBuffer:AddGap(10)
    ModOptionListView:AddContainer(ModOptionListBuffer)
    for key, tweaker in pairs(mod:tweakers()) do
       if not not tweaker:selected_option() then
            local TweakerContainer = Container.new(FlowLayout.HORIZONTAL)
            local TweakerText = Text.new(mod:name().."_"..key.."_tweaker_title", MCMMainFrame, "HEADER", tweaker:ui_name())
            TweakerText:Resize(180, 40)
            TweakerText:GetContentComponent():SetTooltipText(tweaker:ui_tooltip(), true)
            TweakerContainer:AddComponent(TweakerText)
            TweakerContainer:AddGap(10)
            for option_name, option in pairs(tweaker:options()) do
                local OptionButton = TextButton.new(mod:name().."_"..key.."_option_button_"..option_name, MCMMainFrame, "TEXT_TOGGLE", option:ui_name())
                OptionButton:Resize(200, 40)
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
                TweakerContainer:AddComponent(OptionButton)
            end
            ModOptionListView:AddContainer(TweakerContainer)
            TweakerContainer:Reposition()
        end
    end
    for key, variable in pairs(mod:variables()) do
        local VariableContainer = Container.new(FlowLayout.HORIZONTAL)
        local VariableText = Text.new(mod:name().."_"..key.."_variable_title", MCMMainFrame, "HEADER", variable:ui_name())
        VariableText:Resize(200, 40)
        local IncrementButton = Button.new(mod:name().."_"..key.."_variable_up", MCMMainFrame, "CIRCULAR", "ui/skins/default/icon_minimize.png");
        IncrementButton:Resize(40, 40);
        local ValueText = Text.new(mod:name().."_"..key.."_variable_value", MCMMainFrame, "HEADER", tostring(variable:current_value()))
        ValueText:Resize(40, 40)
        local DecrementButton = Button.new(mod:name().."_"..key.."_variable_down", MCMMainFrame, "CIRCULAR", "ui/skins/default/icon_maximize.png");
        DecrementButton:Resize(40, 40);
        IncrementButton:RegisterForClick(function()
            variable:increment_value()
            ValueText:SetText(tostring(variable:current_value()))
        end)
        DecrementButton:RegisterForClick(function()
            variable:decrement_value()
            ValueText:SetText(tostring(variable:current_value()))
        end)
        VariableContainer:AddComponent(VariableText)
        VariableContainer:AddComponent(IncrementButton)
        VariableContainer:AddGap(40)
        VariableContainer:AddComponent(ValueText)
        VariableContainer:AddGap(10)
        VariableContainer:AddComponent(DecrementButton)
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
        modTextButton:Resize(300, 40)
        modTextButton:GetContentComponent():SetTooltipText(mod:ui_tooltip(), false)
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
            modTextButton:Resize(300, 40)
            modTextButton:GetContentComponent():SetTooltipText(mod:ui_tooltip(), false)
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
    if cm:get_saved_value("mcm_finalized") == nil then
        local layout = find_uicomponent(core:get_ui_root(), "layout")
        layout:SetVisible(false)
        local MCMMainFrame = Frame.new(UIPANELNAME)



        local sX, sY = core:get_screen_resolution()
        MCMMainFrame:Resize(sX * 0.98, sY * 0.88)
        local frame = Util.getComponentWithName(UIPANELNAME)
        Util.centreComponentOnScreen(frame)        

        --set the title
        MCMMainFrame:SetTitle("Mod Configuration Tool")

        --create close button
        local CloseButton = Button.new(UIPANELNAME.."_CLOSE_BUTTON", MCMMainFrame, "CIRCULAR", "ui/skins/default/icon_check.png")
        CloseButton:Resize(56, 56)
        CloseButton:RegisterForClick(function() 
            MCMMainFrame:Delete() 
            layout:SetVisible(true) 
            mcm:process_all_mods()
        end)
        local frameWidth = MCMMainFrame:Width()
        local frameHeight = MCMMainFrame:Height()
        local buttonWidth = CloseButton:Width()
        local buttonHeight = CloseButton:Height()
        CloseButton:PositionRelativeTo(frame, frameWidth/2 - buttonWidth/2, frameHeight - buttonHeight*2)
        PopulateList(MCMMainFrame)
        PopulateModOptions(MCMMainFrame)
    else
        mcm:log("MCM already triggered on this save file!")
    end
end;


core:add_listener(
    "MCMTrigger",
    "ComponentLClickUp",
    function(context)
        return find_uicomponent(core:get_ui_root(), "layout"):Visible()
    end,
    function(context)
        CreatePanel();
    end,
    false
);