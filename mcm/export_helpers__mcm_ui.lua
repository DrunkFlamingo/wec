mcm = _G.mcm
local mod = mcm:register_mod("tests", "test mod", "toooool tip xd")
local mod2 = mcm:register_mod("secondtest", "second test", "tooooooooollllltiiiiiiipppppp")
local multiple_choice = mod:add_tweaker("test_tweaker", "test tweaker", "fuck you thats what")
local choice_1 = multiple_choice:add_option("key", "An option"):add_callback(function(context) end)
local choice_2 = multiple_choice:add_option("Key2", "Another option")
local var = mod:add_variable("var", 0, 10, 5, 1, "A var")

local MCMBASIC = "mcm_basic"
local UIPANELNAME = "MCM_PANEL"


--v function(tweaker: MCM_TWEAKER, parent: FRAME, list: LIST_VIEW)
local function CreateTweakerElement(tweaker, parent, list)
    local key = tweaker:name()
    local TweakerOptionHolder = Container.new(FlowLayout.HORIZONTAL)
        local TweakerText = Text.new(key.."_ui_title", parent, "HEADER", tweaker:ui_name())
        TweakerText:Resize(275, 40)
        TweakerText:GetContentComponent():SetTooltipText(tweaker:ui_tooltip(), true)
        TweakerOptionHolder:AddComponent(TweakerText)
        --for each tweaker option, add a button
        for option_name, option in pairs(tweaker._options) do
            local OptionButton = TextButton.new(key.."_ui_button_"..option_name, parent, "TEXT", option:ui_name())
            OptionButton:Resize(275, 40)
            OptionButton:GetContentComponent():SetTooltipText(option:ui_tooltip())
            --click registration
            OptionButton:RegisterForClick(function()
                local old_option = tweaker:selected_option():name()
                local old_option_button = Util.getComponentWithName(key.."_ui_button_"..old_option)
                if not not old_option_button then
                    --# assume old_option_button: TEXT_BUTTON
                    old_option_button:SetState("active")
                end
                OptionButton:SetState("selected")
            end)
            if tweaker:selected_option():name() == option_name then
                OptionButton:SetState("selected")
            end
            TweakerOptionHolder:AddComponent(OptionButton)
        end
        
    list:AddContainer(TweakerOptionHolder)
end

--v function(variable: MCM_VAR, parent: FRAME) --> CONTAINER
local function CreateVarELement(variable, parent)
    local VarContainer = Container.new(FlowLayout.VERTICAL)



    return VarContainer
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

    local ModOptionListHeader = Text.new(UIPANELNAME.."_MOD_OPTIONS_LIST_HEADER", MCMMainFrame, "HEADER", mod._UIName)
    ModOptionListHeader:Resize(400, 40)
    ModOptionListHeader:PositionRelativeTo(MCMMainFrame, fbX*0.04 + 350, fbY*0.04)
    local ModOptionListView = ListView.new(UIPANELNAME.."_MOD_OPTIONS_LISTVIEW", MCMMainFrame, "VERTICAL")
    ModOptionListView:Resize(800, 800)
    local ModOptionListBuffer = Container.new(FlowLayout.VERTICAL)
    ModOptionListBuffer:AddGap(10)
    ModOptionListView:AddContainer(ModOptionListBuffer)
    --if the mod has an enable, disable flag, then check that first!
    if not not mod._tweakers["ENABLE"] then
        CreateTweakerElement(mod._tweakers["ENABLE"], MCMMainFrame, ModOptionListView)
    end
    for key, tweaker in pairs(mod._tweakers) do
        if key ~= "ENABLE" then
            CreateTweakerElement(tweaker, MCMMainFrame, ModOptionListView)
        end
    end
    --[[
    for key, variable in pairs(mod._variables) do
        ModOptionListView:AddComponent(CreateVarELement(variable, MCMMainFrame))
    end
    --]]
    ModOptionListView:PositionRelativeTo(ModOptionListHeader, -20, 50)
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
        local mod = mcm._registeredMods[key]
        local uiName = mod._UIName 
        local uiToolTip = mod._UIToolTip
        local modTextButton = TextButton.new(UIPANELNAME.."_MOD_HEADER_BUTTON_"..key, MCMMainFrame, "TEXT", uiName)
        modTextButton:Resize(300, 40)
        modTextButton:GetContentComponent():SetTooltipText(uiToolTip, false)
        ModHeaderListView:AddComponent(modTextButton)   
        mcm:make_mod_with_key_selected(MCMBASIC)  
    end
    for key, mod in pairs(mcm._registeredMods) do
        if key ~= "mcm_basic" then
            local uiName = mod._UIName 
            local uiToolTip = mod._UIToolTip
            local modTextButton = TextButton.new(UIPANELNAME.."_MOD_HEADER_BUTTON_"..key, MCMMainFrame, "TEXT", uiName)
            modTextButton:Resize(300, 40)
            modTextButton:GetContentComponent():SetTooltipText(uiToolTip, false)
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
    --MCMMainFrame:MoveTo()
end;


core:add_listener(
    "MCMTrigger",
    "ComponentLClickUp",
    function(context)
        return not not find_uicomponent(core:get_ui_root(), "layout")
    end,
    function(context)
        CreatePanel();
    end,
    false
);