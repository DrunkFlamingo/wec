mcm = _G.mcm
local mod = mcm:register_mod("tests", "test mod", "toooool tip xd")
local multiple_choice = mod:add_tweaker("test_tweaker", "test tweaker", "fuck you thats what")
local choice_1 = multiple_choice:add_option("key", "An option"):add_callback(function(context) end)
local choice_2 = multiple_choice:add_option("Key2", "Another option")
local var = mod:add_variable("var", 0, 10, 5, 1, "A var")


local UIPANELNAME = "MCM_PANEL"



local function MCMTrigger()
    local buttonsDocker = find_uicomponent(core:get_ui_root(), "layout", "faction_buttons_docker")
    if cm:get_saved_value("mcm_finalized") == nil then
        local MCMMainFrame = Frame.new(UIPANELNAME)
        MCMMainFrame:SetTitle("Test Frame")
    end;
    
    --MCMMainFrame:MoveTo()

end;


core:add_listener(
    "MCMTrigger",
    "ComponentLClickUp",
    true,
    function(context)
        MCMTrigger();
    end,
    true
);