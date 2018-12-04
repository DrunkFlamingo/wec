--Log script to text
--v function(text: string | number | boolean | CA_CQI)
local function LOG(text)
    if not __write_output_to_logfile then
        return;
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("MOD_SETTINGS_LOG.txt","a")
    --# assume logTimeStamp: string
    popLog :write("MCM:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

--v function()
local function GPSESSIONLOG()
    if not __write_output_to_logfile then
        return;
    end
    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string

    local popLog = io.open("MOD_SETTINGS_LOG.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close() 
end
GPSESSIONLOG()




local mod_configuration_manager = {} --# assume mod_configuration_manager: MOD_CONFIGURATION_MANAGER

--v function() --> MOD_CONFIGURATION_MANAGER
function mod_configuration_manager.init()
    local self = {} 
    setmetatable(self, {
        __index = mod_configuration_manager,
        __tostring = function() return "MOD_CONFIGURATION_MANAGER" end
    })--# assume self: MOD_CONFIGURATION_MANAGER

    self._registeredMods = {} --:map<string, MCM_MOD>
    self._selectedMod = nil --:MCM_MOD
    self._postProcessCallbacks = {} --:vector<function()>
    self._preProcessCallbacks  = {} --:vector<function()>
    self._newGameOnlyCallbacks = {} --:vector<function()>
    self._warnLuaErrors = false --:boolean
    self._cachedUIC = {} --:vector<CA_UIC>

    _G.mcm = self
    return self
end

--v function(self: MOD_CONFIGURATION_MANAGER, text: any)
function mod_configuration_manager.log(self, text)
    LOG(tostring(text))
end

--v function (self: MOD_CONFIGURATION_MANAGER) --> boolean
function mod_configuration_manager.has_selected_mod(self)
    return not not self._selectedMod
end

--v function(self: MOD_CONFIGURATION_MANAGER, mod_key: string)
function mod_configuration_manager.make_mod_with_key_selected(self, mod_key)
    self._selectedMod = self._registeredMods[mod_key]
end

--v function(self: MOD_CONFIGURATION_MANAGER) --> MCM_MOD
function mod_configuration_manager.get_current_mod(self)
    if self._selectedMod == nil then
        self:log("ERROR: called get_current_mod() with no mod selected!")
        local null_responce = {} --# assume null_responce: MCM_MOD
        null_responce.is_null_interface = function() return true end
        return null_responce
    end
    return self._selectedMod
end

--v function(self: MOD_CONFIGURATION_MANAGER, uic: CA_UIC)
function mod_configuration_manager.cache_UIC(self, uic)
    if not is_uicomponent(uic) then
        self:log("ERROR: callec cache_UIC() but the UIC sent isn't a UIC?")
        return
    else
        table.insert(self._cachedUIC, uic)
    end
end

--v function(self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.clear_UIC(self)
    local cachedUIC = self._cachedUIC
    for i = 1, #cachedUIC do
        local uic = cachedUIC[i]
        uic:SetVisible(true)
    end
end

--v function(self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.warn_of_error(self)
    if self._warnLuaErrors then


    end
end

--v function(self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.set_should_warn(self)
    self._warnLuaErrors = true
end

--v function(obj: any) --> boolean
function mod_configuration_manager.is_mod(obj)
    return tostring(obj) == "MCM_MOD"
end

--v function(obj: any) --> boolean
function mod_configuration_manager.is_tweaker(obj)
    return tostring(obj) == "MCM_TWEAKER"
end

--v function(obj: any) --> boolean
function mod_configuration_manager.is_variable(obj)
    return tostring(obj) == "MCM_VAR"
end

--v function(obj: any) --> boolean
function mod_configuration_manager.is_tweaker_option(obj)
    return tostring(obj) == "MCM_OPTION"
end

--logs lua errors to a file after this is called.
--v [NO_CHECK] 
--v function (self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.error_checker(self)
    --Vanish's PCaller
    --All credits to vanish
    --v function(func: function) --> any
    function safeCall(func)
        local status, result = pcall(func)
        if not status then
            LOG("ERROR")
            LOG(tostring(result))
            LOG(debug.traceback());
            self:warn_of_error()
        end
        return result;
    end
    
    
    --v [NO_CHECK] function(...: any)
    function pack2(...) return {n=select('#', ...), ...} end
    --v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
    function unpack2(t) return unpack(t, 1, t.n) end
    
    --v [NO_CHECK] function(f: function(), argProcessor: function()) --> function()
    function wrapFunction(f, argProcessor)
        return function(...)
            local someArguments = pack2(...);
            if argProcessor then
                safeCall(function() argProcessor(someArguments) end)
            end
            local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
            return unpack2(result);
            end
    end
    
    core.trigger_event = wrapFunction(
        core.trigger_event,
        function(ab)
        end
    );
    
    cm.check_callbacks = wrapFunction(
        cm.check_callbacks,
        function(ab)
        end
    )
    
    local currentAddListener = core.add_listener;
    --v [NO_CHECK] function(core: any, listenerName: any, eventName: any, conditionFunc: any, listenerFunc: any, persistent: any)
    function myAddListener(core, listenerName, eventName, conditionFunc, listenerFunc, persistent)
        local wrappedCondition = nil;
        if is_function(conditionFunc) then
            --wrappedCondition =  wrapFunction(conditionFunc, function(arg) output("Callback condition called: " .. listenerName .. ", for event: " .. eventName); end);
            wrappedCondition =  wrapFunction(conditionFunc);
        else
            wrappedCondition = conditionFunc;
        end
        currentAddListener(
            core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
            --core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc, function(arg) output("Callback called: " .. listenerName .. ", for event: " .. eventName); end), persistent
        )
    end
    core.add_listener = myAddListener;
end





local mcm_mod = {} --# assume mcm_mod: MCM_MOD





--v function(model: MOD_CONFIGURATION_MANAGER, name: string, ui_name: string, ui_tooltip: string) --> MCM_MOD
function mcm_mod.new(model, name, ui_name, ui_tooltip)
    local self = {}
    setmetatable(self, {
        __index = mcm_mod,
        __tostring = function() return "MCM_MOD" end
    }) --# assume self: MCM_MOD

    self._name = name
    self._model = model
    self._tweakers = {} --:map<string, MCM_TWEAKER>
    self._variables = {} --:map<string, MCM_VAR> 

    self._UIName = ui_name or "unnamed mod"
    self._UIToolTip = ui_tooltip or " "

    return self
end

--v function (model: MOD_CONFIGURATION_MANAGER) --> MCM_MOD
function mcm_mod.null(model)
    local self = {}
    setmetatable(self, {
        __index = mcm_mod,
        __tostring = function() return "NULL_SCRIPT_INTERFACE" end
    }) --# assume self: MCM_MOD
    self._name = ""
    self._model = model
    self._tweakers = {}
    self._variables = {}
    self._UIName = "NULL INTERFACE"
    self._UIToolTip = "NULL_INTERFACE"
    return self
end



--v function(self: MCM_MOD) --> string
function mcm_mod.name(self) 
    return self._name
end

--v function(self: MCM_MOD) --> MOD_CONFIGURATION_MANAGER
function mcm_mod.model(self)
    return self._model
end

--v function(self: MCM_MOD, text: any)
function mcm_mod.log(self, text)
    self:model():log(text)
end


local mcm_var = {}--# assume mcm_var: MCM_VAR

--v function(mod: MCM_MOD, name: string, min: number, max: number, default: number, step: number, ui_name: string, ui_tooltip: string) --> MCM_VAR
function mcm_var.new(mod, name, min, max, default, step, ui_name, ui_tooltip)
    local self = {}
    setmetatable(self, {
        __index = mcm_var,
        __tostring = function() return "MCM_VAR" end
    }) --# assume self: MCM_VAR

    self._mod = mod
    self._name = name
    self._minValue = min
    self._maxValue = max
    self._stepValue = step
    self._defaultValue = default
    self._UIName = ui_name or "Unnamed Variable"
    self._UIToolTip = ui_tooltip or " "

    self._currentValue = default
    

    return self
end

--v function(mod: MCM_MOD) --> MCM_VAR
function mcm_var.null(mod)
    local self = {}
    setmetatable(self, {
        __index = mcm_var,
        __tostring = function() return "NULL_SCRIPT_INTERFACE" end
    }) --# assume self: MCM_VAR

    self._mod = mod
    self._name = ""
    self._minValue = 0
    self._maxValue = 0
    self._currentValue = 0
    self._stepValue = 0
    self._UIName = ""
    self._UIToolTip = ""
    self._callback = nil --:function(context: MOD_CONFIGURATION_MANAGER)
    return self
end


--v function(self: MCM_VAR) --> boolean
function mcm_var.is_null_interface(self)
    return tostring(self) == "NULL_SCRIPT_INTERFACE"
end

--v function(self: MCM_VAR) --> string
function mcm_var.name(self)
    return self._name
end

--v function(self: MCM_VAR) --> MCM_MOD
function mcm_var.mod(self)
    return self._mod
end

--v function(self: MCM_VAR, text: any)
function mcm_var.log(self, text)
    self:mod():log(text)
end
    
--v function(self: MCM_VAR) --> number
function mcm_var.default_value(self)
    return self._defaultValue
end

--v function(self: MCM_VAR) --> number
function mcm_var.current_value(self)
    return self._currentValue
end

--v function(self: MCM_VAR) --> number
function mcm_var.maximum(self)
    return self._maxValue
end

--v function(self: MCM_VAR) --> number
function mcm_var.minimum(self)
    return self._minValue
end

--v function(self: MCM_VAR) --> boolean
function mcm_var.at_max(self)
    return self._currentValue == self:maximum()
end

--v function(self: MCM_VAR) --> boolean
function mcm_var.at_min(self)
    return self._currentValue == self:minimum()
end

--v function(self: MCM_VAR, value: number) --> boolean
function mcm_var.is_value_valid(self, value)
    if value > self:maximum() then
        return false
    elseif value < self:minimum() then
        return false
    else
        return true
    end
end

--v function(self: MCM_VAR, value: number)
function mcm_var.set_current_value(self, value)
    self:log("Set the value of var ["..self:name().."] in mod ["..self:mod():name().."] to ["..value.."]")
    if value > self:maximum() then
        value = self:maximum()
        self:log("value was over the maximum, lowered it!")
    elseif value < self:minimum() then
        value = self:minimum()
        self:log("value was under the minimum, raised it!")
    end
    self._currentValue = value
end

--v function(self: MCM_VAR) --> number
function mcm_var.step(self)
    return self._stepValue
end

--v function(self: MCM_VAR)
function mcm_var.increment_value(self)
    self:set_current_value(self:current_value() + self:step())
end

--v function(self: MCM_VAR)
function mcm_var.decrement_value(self)
    self:set_current_value(self:current_value() - self:step())
end

--v function(self: MCM_VAR)
function mcm_var.callback(self)
    self._callback(self:mod():model())
end

--v function(self: MCM_VAR) --> boolean
function mcm_var.has_callback(self)
    return not not self._callback
end

--v function(self: MCM_VAR, callback: function(context: MOD_CONFIGURATION_MANAGER))
function mcm_var.add_callback(self, callback)
    self:log("added callback to variable ["..self:name().."] ")
    self._callback = callback
end

--v function(self: MCM_VAR, text: string)
function mcm_var.set_ui_name(self, text)
    self._UIName = text
end

--v function(self: MCM_VAR, text: string)
function mcm_var.set_ui_tooltip(self, text)
    self._UIToolTip = text
end

--v function(self: MCM_VAR) --> string
function mcm_var.ui_name(self)
    return self._UIName
end

--v function (self: MCM_VAR) --> string
function mcm_var.ui_tooltip(self)
    return self._UIToolTip
end

local mcm_tweaker = {} --# assume mcm_tweaker: MCM_TWEAKER

--v function(mod: MCM_MOD, name: string, ui_title: string, ui_tooltip: string) --> MCM_TWEAKER
function mcm_tweaker.new(mod, name, ui_title, ui_tooltip)
    local self = {}
    setmetatable(self, {
        __index = mcm_tweaker,
        __tostring =  function() return "MCM_TWEAKER" end
    })--# assume self: MCM_TWEAKER
    self._mod = mod
    self._name = name
    self._UIName = ui_title or "Un-named tweaker"
    self._UIToolTip = ui_tooltip or " "

    self._options = {} --:map<string, MCM_OPTION>
    self._numOptions = 0 --:number
    self._selectedOption = nil --:MCM_OPTION

    return self
end

--v function(mod: MCM_MOD) --> MCM_TWEAKER
function mcm_tweaker.null(mod)
    local self = {}
    setmetatable(self, {
        __index = mcm_tweaker,
        __tostring =  function() return "NULL_SCRIPT_INTERFACE" end
    })--# assume self: MCM_TWEAKER
    self._mod = mod
    self._name = " "
    self._UITitle = " "
    self._UIToolTip = " "

    self._options = {} 
    self._selectedOption = nil 
    self._numOptions = 0

    return self
end

--v function(self: MCM_TWEAKER) --> boolean
function mcm_tweaker.is_null_interface(self)
    return tostring(self) == "NULL_SCRIPT_INTERFACE"
end

--v function(self: MCM_TWEAKER) --> MCM_MOD
function mcm_tweaker.mod(self)
    return self._mod
end

--v function(self: MCM_TWEAKER) --> string
function mcm_tweaker.name(self)
    return self._name
end

--v function(self: MCM_TWEAKER, text: any)
function mcm_tweaker.log(self, text)
    self:mod():log(text)
end
--OPTIONS
----------------------------------------
------------------------------------------------------------------------------------------------------------------------
local mcm_option = {} --# assume mcm_option: MCM_OPTION

--v function(tweaker: MCM_TWEAKER, key: string, ui_name: string, ui_tooltip: string) --> MCM_OPTION
function mcm_option.new(tweaker, key, ui_name, ui_tooltip)
    local self = {}
    setmetatable(self, {
        __index = mcm_option,
        __tostring = function() return "MCM_OPTION" end
    }) --# assume self: MCM_OPTION
    self._tweaker = tweaker
    self._wasDefault = false --:boolean
    self._name = key
    self._UIName = ui_name or "Unnamed Option"
    self._UIToolTip = ui_tooltip or " "
    self._callback = nil --: function(context: MOD_CONFIGURATION_MANAGER)
    return self
end

--v function(tweaker: MCM_TWEAKER) --> MCM_OPTION
function mcm_option.null(tweaker)
    local self = {}
    setmetatable(self, {
        __index = mcm_option,
        __tostring = function() return "NULL_SCRIPT_INTERFACE" end
    }) --# assume self: MCM_OPTION
    self._tweaker = tweaker
    self._name = "NULL_OPTION"
    self._UIName = ""
    self._UIToolTip = ""
    self._callback = nil 
    self._wasDefault = false
    return self
end

--v function(self: MCM_OPTION) --> boolean
function mcm_option.is_null_interface(self)
    return tostring(self) == "NULL_SCRIPT_INTERFACE"
end

--v function(self: MCM_OPTION) --> string
function mcm_option.name(self)
    return self._name
end

--v function(self: MCM_OPTION) --> MCM_TWEAKER
function mcm_option.tweaker(self)
    return self._tweaker
end

--v function(self: MCM_OPTION, text: any)
function mcm_option.log(self, text)
    self:tweaker():log(text)
end

--v function(self: MCM_OPTION)
function mcm_option.callback(self)
    self._callback(self:tweaker():mod():model())
end


--v function(self: MCM_OPTION) --> boolean
function mcm_option.has_callback(self)
    return not not self._callback
end

--v function(self: MCM_OPTION)
function mcm_option.flag_default(self)
    self._wasDefault = true
end

--v function(self: MCM_OPTION) --> boolean
function mcm_option.is_default(self)
    return self._wasDefault
end

--v function(self: MCM_OPTION) 
function mcm_option.no_longer_default(self)
    self._wasDefault = false
end

--v function(self: MCM_OPTION, callback: function(context: MOD_CONFIGURATION_MANAGER))
function mcm_option.add_callback(self, callback)
    self:log("added callback to option ["..self:name().."] ")
    self._callback = callback
end


--v function(self: MCM_OPTION, text: string)
function mcm_option.set_ui_name(self, text)
    self._UIName = text
end

--v function(self: MCM_OPTION, text: string)
function mcm_option.set_ui_tooltip(self, text)
    self._UIToolTip = text
end

--v function(self: MCM_OPTION) --> string
function mcm_option.ui_name(self)
    return self._UIName
end

--v function (self: MCM_OPTION) --> string
function mcm_option.ui_tooltip(self)
    return self._UIToolTip
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--v function(self: MCM_TWEAKER, option: MCM_OPTION)
function mcm_tweaker.set_selected_option(self, option)
    self._selectedOption = option
end

--v function(self: MCM_TWEAKER, option_key: string)
function mcm_tweaker.set_selected_option_with_key(self, option_key)
    if self._options[option_key] == nil then
        return
    end
    self._selectedOption = self._options[option_key]
end


--v function(self: MCM_TWEAKER) --> MCM_OPTION
function mcm_tweaker.selected_option(self)
    return self._selectedOption
end


--v function(self: MCM_TWEAKER) --> map<string, MCM_OPTION>
function mcm_tweaker.options(self)
    return self._options
end

--v function(self: MCM_TWEAKER, key: string) --> MCM_OPTION
function mcm_tweaker.get_option_with_key(self, key)
    if self:options()[key] == nil then
        self:log("ERROR: Asked for option ["..key.."] which does not exist for the tweaker ["..self:name().."] in the mod ["..self:mod():name().."] ")
        return mcm_option.null(self)
    end
    return self:options()[key]
end

--v function(self: MCM_TWEAKER, option_key: string) --> boolean
function mcm_tweaker.has_option(self, option_key)
    return not not self._options[option_key]
end

--v function(self: MCM_TWEAKER) --> number
function mcm_tweaker.num_options(self)
    return self._numOptions
end


--v function(self: MCM_TWEAKER, key: string, ui_name: string, ui_tooltip: string) --> MCM_OPTION
function mcm_tweaker.add_option(self, key, ui_name, ui_tooltip)
    if not (is_string(key) and  (is_string(ui_name) or not ui_name) and (is_string(ui_tooltip) or not ui_tooltip)) then
        self:log("ERROR: attempted to create a new option for tweaker ["..self:name().."] in mod ["..self:mod():name().."], but a provided key, ui_name or ui_tooltip was not a string!")
        return mcm_option.null(self)
    end
    if not not self:options()[key] then
        self:log("WARNING: attempted to create an option with key ["..key.."] for tweaker ["..self:name().."] in mod ["..self:mod():name().."], but an option with that key already exists! Returning the existing option instead")
        return self:options()[key]
    end
    if self._numOptions == 8 then
        self:log("ERROR: attempted to create a new option for tweaker ["..self:name().."] in mod ["..self:mod():name().."] but that tweaker already has 9 options!")
        return mcm_option.null(self)
    end
    local new_option = mcm_option.new(self, key, ui_name, ui_tooltip)
    self:options()[key] = new_option
    self._numOptions = self._numOptions + 1
    self:log("Created Option with key ["..key.."] for tweaker ["..self:name().."] in mod ["..self:mod():name().."]")
    if self:selected_option() == nil then
        self:set_selected_option(new_option)
        new_option:flag_default()
        self:log("Created Option is the first option for this tweaker, setting it to be the default!")
    end
    return self:options()[key]
end

--v function(self: MCM_TWEAKER, key: string)
function mcm_tweaker.make_option_default(self, key)
    if not self:has_option(key) then
        self:log("Failed to make option ["..key.."] default, it was not found on this tweaker!")
        return
    end
    local opt = self:get_option_with_key(key)
    opt:flag_default()
    local old = self:selected_option()
    old:no_longer_default()
    self:set_selected_option(opt)
end

--v function(self: MCM_TWEAKER, text: string)
function mcm_tweaker.set_ui_name(self, text)
    self._UIName = text
end

--v function(self: MCM_TWEAKER, text: string)
function mcm_tweaker.set_ui_tooltip(self, text)
    self._UIToolTip = text
end

--v function(self: MCM_TWEAKER) --> string
function mcm_tweaker.ui_name(self)
    return self._UIName
end

--v function (self: MCM_TWEAKER) --> string
function mcm_tweaker.ui_tooltip(self)
    return self._UIToolTip
end
    
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--v function(self: MCM_MOD) --> map<string, MCM_TWEAKER>
function mcm_mod.tweakers(self)
    return self._tweakers
end

--v function(self: MCM_MOD)--> map<string, MCM_VAR>
function mcm_mod.variables(self)
    return self._variables
end

--v function(self: MCM_MOD) --> string
function mcm_mod.ui_name(self)
    return self._UIName
end

--v function(self: MCM_MOD) --> string
function mcm_mod.ui_tooltip(self)
    return self._UIToolTip
end

--v function(self: MCM_MOD, key: string) --> boolean
function mcm_mod.has_tweaker(self, key)
    return not not self:tweakers()[key]
end

--v function(self: MCM_MOD, key: string) --> boolean
function mcm_mod.has_variable(self, key)
    return not not self:variables()[key]
end

--v function(self: MCM_MOD, key: string) --> MCM_TWEAKER
function mcm_mod.get_tweaker_with_key(self, key)
    if self:tweakers()[key] == nil then
        self:log("ERROR: Asked for tweaker ["..key.."] which does not exist for the mod ["..self:name().."]")
        return mcm_tweaker.null(self)
    end
    return self:tweakers()[key]
end

--v function(self: MCM_MOD, key: string) --> MCM_VAR
function mcm_mod.get_variable_with_key(self, key)
    if self:variables()[key] == nil then
        self:log("ERROR: Asked for tweaker ["..key.."] which does not exist for the mod ["..self:name().."]")
        return mcm_var.null(self)
    end
    return self:variables()[key]
end



--v function(self: MCM_MOD, key: string, ui_name: string, ui_tooltip: string) --> MCM_TWEAKER
function mcm_mod.add_tweaker(self, key, ui_name, ui_tooltip)
    if not (is_string(key) and  (is_string(ui_name) or not ui_name) and (is_string(ui_tooltip) or not ui_tooltip)) then
        self:log("ERROR: attempted to create a new tweaker for mod ["..self:name().."], but a provided key, ui_name or ui_tooltip was not a string!")
        return mcm_tweaker.null(self)
    end
    if not not self:tweakers()[key] then
        self:log("WARNING: attempted to create a tweaker with key ["..key.."] for mod ["..self:name().."], but a tweaker with that key already exists! Returning the existing tweaker instead")
        return self:tweakers()[key]
    end

    local new_tweaker = mcm_tweaker.new(self, key, ui_name, ui_tooltip)
    self:tweakers()[key] = new_tweaker
    self:log("created tweaker ["..key.."] for mod ["..self:name().."]")
    return self:tweakers()[key]
end

--v function(self: MCM_MOD, key: string, min: number, max: number, default: number, step: number, ui_name: string, ui_tooltip: string) --> MCM_VAR
function mcm_mod.add_variable(self, key, min, max, default, step, ui_name, ui_tooltip)
    if (ui_name and not is_string(ui_name)) or (ui_tooltip and not is_string(ui_tooltip)) or (not is_string(key)) then
        self:log("ERROR: attempted to create a new variable for mod ["..self:name().."], but a provided key, ui_name or ui_tooltip was not a string!")
        return mcm_var.null(self)
    end
    if not (is_number(min) and is_number(max) and is_number(default) and is_number(step)) then
        self:log("ERROR: attempted to create a new variable for mod ["..self:name().."], but a provided min, max, default, or step was not a number!")
        return mcm_var.null(self)
    end
    if not not self:variables()[key] then
        self:log("WARNING: attempted to create a variable with key ["..key.."] for mod ["..self:name().."], but a variable with that key already exists! Returning the existing variable instead")
        return self:variables()[key]
    end
    local new_variable = mcm_var.new(self, key, min, max, default, step, ui_name, ui_tooltip)
    self:variables()[key] = new_variable
    self:log("created variable ["..key.."] for mod ["..self:name().."]")
    return self:variables()[key]
end


--v function(self: MCM_MOD, setting: MCM_TWEAKER | MCM_VAR) --> boolean 
function mcm_mod.reset_setting_to_default(self, setting)
    if self:model().is_tweaker(setting) then
        --# assume setting: MCM_TWEAKER
        self:log("Resetting a tweaker with name ["..setting:name().."] to default")
        for key, option in pairs(setting:options()) do
            if option:is_default() then
                setting:set_selected_option(option)
                return true
            end
        end
        self:log("Warning! Asked for a reset to default but could not find an option which has a default flag!")
        return false
    elseif self:model().is_variable(setting) then
        --# assume setting: MCM_VAR
        self:log("Resetting a variable with name ["..setting:name().."] to default")
        setting:set_current_value(setting:default_value())
        return true
    else
        self:log("Error! Asked to reset a setting to default by the given object of type ["..type(setting).."], which tostrings to ["..tostring(setting).."], could not be recognized")
        return false
    end
end

--v function(self: MOD_CONFIGURATION_MANAGER) --> map<string, MCM_MOD>
function mod_configuration_manager.get_mods(self)
    return self._registeredMods
end



--v function(self: MOD_CONFIGURATION_MANAGER, key: string, ui_name: string, ui_tooltip: string) --> MCM_MOD
function mod_configuration_manager.register_mod(self, key, ui_name, ui_tooltip)
    if not (is_string(key) and (is_string(ui_name) or not ui_name) and (is_string(ui_tooltip) or not ui_tooltip))then 
        self:log("ERROR: attempted to create a new mod, but a provided key, ui_text, or ui_tooltip is not a string!")
        return mcm_mod.null(self)
    end
    if not not self:get_mods()[key] then
        self:log("WARNING: attempted to create a new mod, but a mod already exists with the provided key!; returning that instead")
        return self:get_mods()[key]
    end
    local new_mod = mcm_mod.new(self, key, ui_name, ui_tooltip)
    self:get_mods()[key] = new_mod
    self:log("registered mod ["..key.."]")
    return self:get_mods()[key]
end

--v function(self: MOD_CONFIGURATION_MANAGER, key: string) --> MCM_MOD
function mod_configuration_manager.get_mod(self, key) 
    if not self:get_mods()[key] then
        self:log("ERROR: Called get mod for key ["..key.."] but no mod exists with this key!")
        return mcm_mod.null(self)
    end
    return self:get_mods()[key]
end

--v function(self: MOD_CONFIGURATION_MANAGER, key: string) --> boolean
function mod_configuration_manager.has_mod(self, key)
    return not not self._registeredMods[key]
end


--v function(self: MOD_CONFIGURATION_MANAGER, variable: MCM_VAR) 
function mod_configuration_manager.handle_variable(self, variable)
    self:log("handling variable ["..variable:name().."] with key [mcm_variable_"..variable:mod():name().."_"..variable:name().."_value] at value ["..tostring(variable:current_value()).."]")
    cm:set_saved_value("mcm_variable_"..variable:mod():name().."_"..variable:name().."_value", variable:current_value())
    if variable:has_callback() then
        variable:callback()
    end
    core:trigger_event("mcm_variable_"..variable:mod():name().."_"..variable:name().."_event", tostring(variable:current_value()))
end
        
--v function(self: MOD_CONFIGURATION_MANAGER, tweaker: MCM_TWEAKER)
function mod_configuration_manager.handle_tweaker(self, tweaker)
    self:log("handling tweaker ["..tweaker:name().."] with key [mcm_tweaker_"..tweaker:mod():name().."_"..tweaker:name().."_value] with option ["..tostring(tweaker:selected_option():name()).."]")
    cm:set_saved_value("mcm_tweaker_"..tweaker:mod():name().."_"..tweaker:name().."_value", tweaker:selected_option():name())
    if tweaker:selected_option():has_callback() then
        tweaker:selected_option():callback()
    end
    core:trigger_event("mcm_tweaker_"..tweaker:mod():name().."_"..tweaker:name().."_event", tostring(tweaker:selected_option():name()))
    self:log("Triggering event [mcm_tweaker_"..tweaker:mod():name().."_"..tweaker:name().."_event] with value ["..tostring(tweaker:selected_option():name()).."]")
end

--v function(self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.restore_save_state(self)
    self:log("Restoring the Saved State!")
    for name, mod in pairs(self:get_mods()) do
        for tweaker_key, tweaker in pairs(mod:tweakers()) do
            local sv = cm:get_saved_value("mcm_tweaker_"..mod:name().."_"..tweaker:name().."_value")
            if not not sv then
                --# assume sv: string
                tweaker:set_selected_option(tweaker:get_option_with_key(sv))
            end
        end
        for variable_key, variable in pairs(mod:variables()) do
            local sv = cm:get_saved_value("mcm_variable_"..mod:name().."_"..variable:name().."_value")
            if not not sv then
                --# assume sv: number
                variable:set_current_value(sv)
            end
        end
    end
end

--v function(self: MOD_CONFIGURATION_MANAGER, name: string) --> boolean
function mod_configuration_manager.started_with_mod(self, name)
    local val = cm:get_saved_value("mcm_started_with_mod_"..name)
    return not not val
end


--v function(self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.process_all_mods(self)
    local mcm_finalized = cm:get_saved_value("mcm_finalized") or false
    for i = 1, #self._preProcessCallbacks do
        self:log("Running pre process callbacks")
        self._preProcessCallbacks[i]()
    end
    if mcm_finalized then
        self:restore_save_state()
    end
    self:log("Processing Settings")
    for name, mod in pairs(self:get_mods()) do
        if not mcm_finalized then
            cm:set_saved_value("mcm_started_with_mod_"..name, true)
        end
        for tweaker_key, tweaker in pairs(mod:tweakers()) do
            self:handle_tweaker(tweaker)
        end
        for variable_key, variable in pairs(mod:variables()) do
            self:handle_variable(variable)
        end
    end
    if not mcm_finalized then
        self:log("Running new game callbacks")
        for i = 1, #self._newGameOnlyCallbacks do
            self._newGameOnlyCallbacks[i]()
        end
    end
    self:log("Running post process callbacks")
    for i = 1, #self._postProcessCallbacks do
        self._postProcessCallbacks[i]()
    end
    self:log("MCM Completed")
    cm:set_saved_value("mcm_finalized", true)
end

--v function(self: MOD_CONFIGURATION_MANAGER)
function mod_configuration_manager.sync_for_mp(self)
    local mcm_finalized = cm:get_saved_value("mcm_finalized") or false
    if cm:is_multiplayer() and not mcm_finalized then
        self:log("Beginning MP Settings Snychronization!")
        local sync_data = {} --:map<string, map<string, WHATEVER>>
        for name, mod in pairs(self:get_mods()) do
            self:log("\tPrparing mod with key ["..name.."] for export")
            sync_data[name.."_T!"] = {}
            sync_data[name.."_V!"] = {}
            for tweaker_key, tweaker in pairs(mod:tweakers()) do
                local value = tweaker:selected_option():name()
                if value then
                    self:log("\t\tExporting Tweaker ["..tweaker_key.."] with value ["..value.."]")
                    sync_data[name.."_T!"][tweaker_key] = value
                else
                    self:log("\t\tWARNING: Exporting Tweaker ["..tweaker_key.."] failed. No value is found for this tweaker.")
                end
            end
            for variable_key, variable in pairs(mod:variables()) do
                self:log("\t\tExporting Variable ["..variable_key.."] with value ["..variable:current_value().."]")
                sync_data[name.."_V!"][variable_key] = variable:current_value()
            end
        end
        local snyc_string = cm:process_table_save(sync_data)
        CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "mcm|sync|"..snyc_string)
        self:log("Sync data sent!")
    else
        self:log("MCM already finalized, or it is a singleplayer game: No MP Sync is being preformed")
    end
end

--v function(self: MOD_CONFIGURATION_MANAGER, callback: function())
function mod_configuration_manager.add_post_process_callback(self, callback)
    table.insert(self._postProcessCallbacks, callback)
end

--v function(self: MOD_CONFIGURATION_MANAGER, callback: function())
function mod_configuration_manager.add_pre_process_callback(self, callback)
    table.insert(self._preProcessCallbacks, callback)
end

--v function(self: MOD_CONFIGURATION_MANAGER, callback: function())
function mod_configuration_manager.add_new_game_only_callback(self, callback)
    table.insert(self._newGameOnlyCallbacks, callback)
end



mod_configuration_manager.init():error_checker()
core:add_static_object("mod_configuration_manager", _G.mcm, true)