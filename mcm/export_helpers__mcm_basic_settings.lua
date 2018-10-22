mcm = _G.mcm

local BasicSettingsMod = mcm:register_mod("mcm_basic", "Basic Mod Settings", "Contains basic settings for using mods")
local BasicSettingsLogger = BasicSettingsMod:add_tweaker("basic_logging", "Log Script To Text", "Allow scripts to log to a .txt file found in the Warhammer II directory")
BasicSettingsLogger:add_option("false", "No Logs"):add_callback(function(context)
    __write_output_to_logfile = false
end)
BasicSettingsLogger:add_option("true", "Enable Logs"):add_callback(function(context)
    if __write_output_to_logfile == false then
        __write_output_to_logfile = true

        local filename = "script_log_" .. tostring(os.date("%d".."".."%m".."".."%y".."_".."%H".."".."%M")) .. ".txt"
        _G.logfile_path = filename;
        
        local file, err_str = io.open(filename, "w");
        if not file then
            __write_output_to_logfile = false;
            script_error("ERROR: tried to create logfile with filename " .. filename .. " but operation failed with error: " .. tostring(err_str));
        else
            file:write("\n");
            file:write("creating logfile " .. filename .. "\n");
            file:write("\n");
            file:close();
            __logfile_path = _G.logfile_path;
        end
    end
end)
local BasicSettingsWarnings = BasicSettingsMod:add_tweaker("basic_warning", "Warn on Lua Error", "Create an event popup warning the player if a lua runtime error is encountered in a mod file")
BasicSettingsWarnings:add_option("false", "Don't warn me", "Disable this option")
BasicSettingsWarnings:add_option("true", "Warn me", "Enable this option"):add_callback(function(context)
    context:set_should_warn()
    context:error_checker()
end)
