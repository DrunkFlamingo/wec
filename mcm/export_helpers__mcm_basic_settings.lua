mcm = _G.mcm

local BasicSettingsMod = mcm:register_mod("mcm_basic", "Basic Mod Settings", "Contains basic settings for using mods")
local BasicSettingsLogger = BasicSettingsMod:add_tweaker("basic_logging", "Log Script To Text", "Allow scripts to log to a .txt file found in the Warhammer II directory")
BasicSettingsLogger:add_option("false", "No Logs")
BasicSettingsLogger:add_option("true", "Enable Logs")
local BasicSettingsWarnings = BasicSettingsMod:add_tweaker("basic_warning", "Warn on Lua Error", "Create an event popup warning the player if a lua runtime error is encountered in a mod file")
BasicSettingsWarnings:add_option("false", "Don't warn me", "Disable this option")
BasicSettingsWarnings:add_option("true", "Warn me", "Enable this option")
