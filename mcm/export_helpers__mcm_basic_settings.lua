mcm = _G.mcm
--# assume io.remove: function(string)
if not not mcm then
    local BasicSettingsMod = mcm:register_mod("mcm_basic", "Basic Mod Settings", "Contains basic settings for using mods")
    local BasicSettingsWarnings = BasicSettingsMod:add_tweaker("basic_warning", "Warn on Lua Error", "Create an event popup warning the player if a lua runtime error is encountered in a mod file")
    BasicSettingsWarnings:add_option("false", "Don't warn me", "Disable this option")
    BasicSettingsWarnings:add_option("true", "Warn me", "Enable this option")


    mcm:add_post_process_callback(function()
        if cm:get_saved_value("mcm_tweaker_mcm_basic_basic_warning_value") == true then
            mcm:set_should_warn()
            mcm:error_checker()
        end
    end)
end