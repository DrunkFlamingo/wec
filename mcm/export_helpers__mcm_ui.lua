mcm = _G.mcm
local mod = mcm:register_mod("tests", "test mod", "toooool tip xd")
local mod2 = mcm:register_mod("secondtest", "second test", "tooooooooollllltiiiiiiipppppp")
local multiple_choice = mod:add_tweaker("test_tweaker", "test tweaker", "fuck you thats what")
local choice_1 = multiple_choice:add_option("key", "An option"):add_callback(function(context) end)
local choice_2 = multiple_choice:add_option("Key2", "Another option")
local var = mod:add_variable("var", 0, 10, 5, 1, "A var")


local UIPANELNAME = "MCM_PANEL"

--v function(MCMMainFrame: FRAME)
local function PopulatePanel(MCMMainFrame)
    local fpX, fpY = MCMMainFrame:Position()
    local fbX, fbY = MCMMainFrame:Bounds()
    local sX, sY = core:get_screen_resolution()

    local ModHeaderListHolder = Container.new(FlowLayout.HORIZONTAL)
    local ModHeaderListView = ListView.new(UIPANELNAME.."_MOD_HEADER_LISTVIEW", MCMMainFrame, "HORIZONTAL")
    ModHeaderListView:Scale(1)
    ModHeaderListView:Resize(200, 100)
        local ModHeaderListBufferContainer = Container.new(FlowLayout.HORIZONTAL)
        ModHeaderListBufferContainer:AddGap(10)

    ModHeaderListView:AddContainer(ModHeaderListBufferContainer)
    local mods = mcm._registeredMods


    for key, mod in pairs(mcm._registeredMods) do
        local uiName = mod._uiName
        local uiToolTip = mod._uiToolTip
        local modTextButton = TextButton.new(UIPANELNAME.."_MOD_HEADER_BUTTON_"..key, MCMMainFrame, "TEXT", uiName)
        modTextButton:Resize(200, 40)
        modTextButton:GetContentComponent():SetTooltipText(uiToolTip, false)

        ModHeaderListView:AddComponent(modTextButton)        
    end;
    
    ModHeaderListHolder:AddComponent(ModHeaderListView)
    ModHeaderListHolder:MoveTo(500,500)


end;


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

        local frame = Util.getComponentWithName(UIPANELNAME)
        Util.centreComponentOnScreen(frame)

        local sX, sY = core:get_screen_resolution()
        MCMMainFrame:Resize(sX * 0.98, sY * 0.95)

        --set the title
        MCMMainFrame:SetTitle("Mod Configuration Tool")

        --create close button
        local CloseButton = Button.new(UIPANELNAME.."_CLOSE_BUTTON", MCMMainFrame, "CIRCULAR", "ui/skins/default/icon_check.png")
        CloseButton:Resize(56, 56)
        CloseButton:RegisterForClick(
            function() MCMMainFrame:Delete() layout:SetVisible(true) end
        )
        MCMMainFrame:AddComponent(CloseButton)
        local frameWidth = MCMMainFrame:Width()
        local frameHeight = MCMMainFrame:Height()
        local buttonWidth = CloseButton:Width()
        CloseButton:PositionRelativeTo(frame, 0, 0)
        CloseButton:PositionRelativeTo(frame, frameWidth/2 - buttonWidth/2, frameHeight * 0.95)
        PopulatePanel(MCMMainFrame)

        
    end;
    
    --MCMMainFrame:MoveTo()

end;


core:add_listener(
    "MCMTrigger",
    "ComponentLClickUp",
    true,
    function(context)
        CreatePanel();
    end,
    false
);