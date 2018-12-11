--this is an object oriented script and kailua tutorial. It is a simple mod that implements a UIMF UI to select the spawn location of rite heroes. 
--I will try to comment it well and keep it short. 

--# assume global class SL
-- this is our kailua class notation.
-- this tells Kailua we are creating a new static type, called SL.

local spawn_locations = {} --# assume spawn_locations: SL
-- this tells kualua to treat this table as your prototype for the class. 
-- all the methods of this class will be stored in here.

-- this is an instantiation function in kailua
-- it takes no args and adds itself to _G. By convention we name these constructors "init"
--v function() --> SL
function spawn_locations.init()
    local self = {}
    setmetatable(self, {
        __index = spawn_locations
    }) --# assume self: SL

    self._trigger = nil --:function(character: CA_CHAR, default_is_char: boolean)
    self._isMP = false
    local events = get_events()
    events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function()
        if cm:is_multiplayer() then
            self._isMP = true
        end
    end

    --  why does this work? Because when you pass on a function as a variable in lua you aren't
    --  just passing the function, you're also passing all the information that function needs to succesfully execute.
    -- self here works as a perfectly valid pointer when this is eventually called. 
    _G.spawn_loc = self
    return self
end

--it makey the word come out of the game
--v method(text: any)
function spawn_locations:log(text)
    if not __write_output_to_logfile then --if you don't recognize or understand this, it means abort if logging is off. 
        return;
    end

    local logText = tostring(text) -- if someone passes a non string value we probably want to tostring it.
    local logTimeStamp = os.date("%d, %m %Y %X") -- no clue what this does either
    local popLog = io.open("warhammer_expanded_log.txt","a") -- 
    --# assume logTimeStamp: string
    popLog :write("LOC:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end
    


--this is our first real method, and it has several conventions. 
-- first of all, remember that table.function(table) and table:function() are equivalent in lua provided that the two tables are the same class. 
--v function(self: SL, event_name: string, conditional: (function(context: WHATEVER) --> boolean), path_to_faction: (function(context: WHATEVER) --> CA_FACTION),
--v  target_subtype: string, default_is_char: boolean?)
function spawn_locations.add_event(self, event_name, conditional, path_to_faction, target_subtype, default_is_char)

--if the moron is missing UIMF, return an error message :eye_roll:
if not Util then 
    self:log("ERROR: UIMF missing or otherwise inaccessible from the mod library script env.")
    return
end

-- remember that core:add_listener() is just a method, and that you can pass functions as variables in lua!
--[[
core:add_listener(
    ...
    function(context)
        return (1 + 1 == 2)
    end,
    ...)

is exactly the same as writing

--v function(context: WHATEVER) --> boolean
function my_condition(context)
    return (1 + 1 == 2)
end

core:add_listener(
    ...
    my_condition
    ...)
-- ]]

core:add_listener(
    "sl_"..event_name.."_"..target_subtype,
    event_name,
    conditional,
    function(context)
        if not not self._trigger then
            local faction = path_to_faction(context)
            for i = 0, faction:character_list():num_items() - 1 do
                local char = faction:character_list():item_at(i)
                if char:character_subtype_key() == target_subtype then
                    self._trigger(char, default_is_char)
                    break
                end
            end
        end
    end,
    true
)

--this architecture (an object that does nothing more than handle an event) is quite common, and it is used in Recruitment Events, Rite Unlocks (OWR) and Greentide.

end

--v function(self: SL, trigger: function(char: CA_CHAR, default_is_char: boolean))
function spawn_locations.add_trigger_function(self, trigger)
    self._trigger = trigger
end





--v function(char: CA_CHAR, default_loc_is_char: boolean)
local function ui_trigger(char, default_loc_is_char)
    local choice_window = Frame.new("telespawn_frame")
    choice_window:Resize(600, 800)
    Util.centreComponentOnScreen(choice_window)
    choice_window:SetTitle("Select Agent Spawn Location:")
    local option_list = ListView.new("telespawn_list", choice_window, "VERTICAL")
    option_list:Resize(500, 700)
    Util.centreComponentOnComponent(option_list, choice_window)
    local first_choice_button = TextButton.new("default_choice_button", choice_window, "TEXT", "Home Region")
    first_choice_button:Resize(300, 45)
    if default_loc_is_char then
        first_choice_button:SetButtonText("Faction Leader")
    end
    first_choice_button:RegisterForClick(
        function()
            choice_window:Delete()
        end
    )
    option_list:AddComponent(first_choice_button)
    local faction = char:faction()
    local char_list = faction:character_list()
    for i = 0, char_list:num_items() - 1 do
        local current_char = char_list:item_at(i)
        if (not current_char:region():is_null_interface()) and current_char:region():owning_faction():name() == current_char:faction():name() then
            --char is a valid spawn point
            local char_name = effect.get_localised_string(current_char:get_forename())
            if char_name == nil then
                char_name = "name_error"
            end
            local choice_button = TextButton.new("spawn_choice_button_"..i, choice_window, "TEXT", char_name)
            choice_button:Resize(300, 45)
            choice_button:RegisterForClick(
                function()
                    cm:teleport_to(cm:char_lookup_str(char), current_char:logical_position_x() - 1, current_char:logical_position_y() - 1, true)
                    choice_window:Delete()
                end
            )
            option_list:AddComponent(choice_button)
        end
    end
end
    

    spawn_locations.init():add_trigger_function(ui_trigger)
