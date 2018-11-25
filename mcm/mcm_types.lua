
--# assume global class MCM
--# assume global class MCM_MOD
--# assume global class MCM_VAR
--# assume global class MCM_TWEAKER
--# assume global class MCM_OPTION

--MOD CONFIGURATION MANAGER
--# assume MCM.register_mod: method(key: string, ui_name: string, ui_tooltip: string) --> MCM_MOD
--# assume MCM.get_mod: method(key: string) --> MCM_MOD
--# assume MCM.started_with_mod: method(key: string) --> boolean
--# assume MCM.add_pre_process_callback: method(callback: function())
    --// happens before any MCM value callbacks. Happens regardless of whether the game is new or loaded. 
--# assume MCM.add_post_process_callback: method(callback: function())
    --// happens after any MCM value callbacks. Happens regardless of whether the game is new or loaded. 
    --// This is the recommended method for using your settings.
--# assume MCM.add_new_game_only_callback: method(callback: function())
    --// happens after any MCM value callbacks only in new saves.
    --// this is the recommended method for using settings only applicable to game start. 

--MOD OBJECT
--# assume MCM_MOD.name: method() --> string
--# assume MCM_MOD.add_tweaker: method(key: string, ui_name: string, tooltip: string) --> MCM_TWEAKER
    --// All tweakers set a save value "mcm_tweaker_<mod_key>_<tweaker_key>_value" 
    --// This value equals the option key of the selected option
    --// Tweakers additionally trigger an event called "mcm_tweaker_<mod_key>_<tweaker_key>_event".
    --// The value is easily accessible within this event through context.string
--# assume MCM_MOD.add_variable: method(key: string,
--# minimum: number, maximum: number, default: number, step_value: number,
--# ui_name: string, ui_tooltip: string) --> MCM_VAR
    --// All variables set a save value "mcm_variable_<mod_key>_<variable_key>_value" 
    --// This value equals the option key of the selected option
    --// variables additionally trigger an event called "mcm_variable_<mod_key>_<variable_key>_event".
    --// The value is easily accessible within this event through tonumber(context.string)

--TWEAKER OBJECT
--# assume MCM_TWEAKER.name: method() -->string
--# assume MCM_TWEAKER.selected_option: method() --> MCM_OPTION
--# assume MCM_TWEAKER.get_option_with_key: method(key: string) --> MCM_OPTION
--# assume MCM_TWEAKER.add_option: method(key: string, ui_name: string, ui_tooltip: string) --> MCM_OPTION
    --// the first option added to any tweaker is the default value.

--OPTION OBJECT
--# assume MCM_OPTION.name: method() -->string
--# assume MCM_OPTION.has_callback: method() --> boolean
--# assume MCM_OPTION.add_callback: method(callback: function(context: MCM)) 
    --// The added callback will happen both in new and saved games.
    --// The callback will occur when the MCM panel closes.
    --// These callbacks are best used to load values into another defined data structure or object; 
    --// general purpose uses are better off using the methods of MCM for callbacks.

--VAR OBJECT
--# assume MCM_VAR.name: method() --> string
--# assume MCM_VAR.current_value: method() --> number
--# assume MCM_VAR.has_callback: method() --> boolean
--# assume MCM_VAR.add_callback: method(callback: function(context: MCM)) 
    --// The added callback will happen both in new and saved games.
    --// The callback will occur when the MCM panel closes.
    --// These callbacks are best used to load values into another defined data structure or object; 
    --// general purpose uses are better off using the methods of MCM for callbacks.

--GLOBAL ACCESS
--# assume mcm:MCM
_G.mcm = mcm

--EXAMPLE CODE SERVED THREE WAYS

--METHOD 1: Using a general callback
-- I have something that has a default, which should happen without MCM,
-- but want to allow MCM to change it without writing too much duplicate code

--get MCM
local mcm = _G.mcm
--set some default values: these will help you avoid writing script twice!
cm:set_saved_value("mcm_tweaker_mymod_mysetting_value", "default_value")
--if MCM is installed, register our mod!
if not not mcm then
    local mymod = mcm:register_mod("mymod", "My MCM mod!", "An example mod")
    local mysetting = mymod:add_tweaker("mysetting", "My MCM Setting", "An example setting!")
    mysetting:add_option("default_value", "My default option", "The one they don't have to click")
    mysetting:add_option("other_value", "My other option", "An option they do have to click")
end
--define what we want to happen on game start.
local my_callback = function()
    local value = cm:get_saved_value("mcm_tweaker_mymod_mysetting_value")
    if value == "default_value" then
        --do something
    elseif value == "other_value" then
        --do something else
    end
end
--if we don't have MCM, just throw it on a CA event, since we set a default value, this code will work without MCM active!
if not mcm then 
    cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function()
        if cm:is_new_game() then
            my_callback()
        end
    end
else --if we do have MCM, add our callback!
    mcm:add_new_game_only_callback(my_callback)
    --if you want this to happen every time the game launches, and not just when it starts the first time, then change this command to
    -- mcm:add_post_process_callback(my_callback)
end

--METHOD 2: Using a listener for a single setting
-- I have something which is an optional feature, so it only happens when MCM is enabled and a setting is picked.

--get MCM
local mcm = _G.mcm
--if MCM is installed, register our mod!
if not not mcm then
    local mymod = mcm:register_mod("mymod", "My MCM mod!", "An example mod")
    local mysetting = mymod:add_tweaker("myfeatureoption", "My Optional Feature", "An example setting!")
    mysetting:add_option("optional_feature_disabled", "Disable Optional Feature", "The one they don't have to click")
    mysetting:add_option("optional_feature_enabled", "Enable Optional Feature", "An option they do have to click")
end
--add a listener for the mod setting being processed
core:add_listener(
    "MyListener",
    "mcm_tweaker_mymod_myfeatureoption_event",
    function(context)
        return context.string == "optional_feature_enabled"
    end,
    function(context)
        --code to enable my feature
    end,
    false)
    --if you want this to happen only the first time the game launches, wrap this in a save value check.

--this code is 100% safe because without MCM, the listener will just do nothing!

