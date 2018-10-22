mcm = _G.mcm
--# assume io.remove: function(string)
local BasicSettingsMod = mcm:register_mod("mcm_basic", "Basic Mod Settings", "Contains basic settings for using mods")
local BasicSettingsWarnings = BasicSettingsMod:add_tweaker("basic_warning", "Warn on Lua Error", "Create an event popup warning the player if a lua runtime error is encountered in a mod file")
BasicSettingsWarnings:add_option("false", "Don't warn me", "Disable this option")
BasicSettingsWarnings:add_option("true", "Warn me", "Enable this option"):add_callback(function(context)
    context:set_should_warn()
    context:error_checker()
end)
