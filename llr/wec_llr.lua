--[[


I'm gonna comment the shit out of this one in the hopes it can help some people trying to learn lua.
]]




--We're using CMF (and ever if we weren't, it's polite) so we set our identifer.
cm:set_saved_value("wec_ll_revival", true);

--these two things define the classes. We use a blank template style because it agrees with the type checker.
--if you aren't familiar with programming terms, a class is a type of object. Since we can have many lords we define the methods that can be applied to lords as a class.

llr_lord = {} --# assume llr_lord: LLR_LORD
llr_manager = {} --# assume llr_manager: LLR_MANAGER

--toggle this to turn logging on or off.
isLogAllowed = true --:boolean

--v function(text: string)
function LLRLOG(text)
    ftext = "LLR" 
    --sometimes I use ftext as an arg of this function, but for simple mods like this one I don't need it.

    if not isLogAllowed then
      return; --if our bool isn't set true, we don't want to spam the end user with logs. 
    end

  local logText = tostring(text)
  local logContext = tostring(ftext)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("WEC_LOG.txt","a")
  --# assume logTimeStamp: string
  popLog :write("WEC:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
  popLog :flush()
  popLog :close()
end

function LLR_REFRESH_LOG()
    if not isLogAllowed then
        return;
    end

    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string

    local popLog = io.open("WEC_LOG.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close()
end
LLR_REFRESH_LOG()

--v function(msg: string)
function WEC_ERROR(msg)
	local ast_line = "********************";
	
	-- do output
	print(ast_line);
	print("SCRIPT ERROR, timestamp " .. get_timestamp());
	print(msg);
	print("");
	print(debug.traceback("", 2));
	print(ast_line);
	-- assert(false, msg .. "\n" .. debug.traceback());
	
	-- logfile output
		local file = io.open("WEC_ERROR.txt", "a");
		
		if file then
			file:write(ast_line .. "\n");
			file:write("SCRIPT ERROR, timestamp " .. get_timestamp() .. "\n");
			file:write(msg .. "\n");
			file:write("\n");
			file:write(debug.traceback("", 2) .. "\n");
			file:write(ast_line .. "\n");
			file:close();
		end;
end;


--v function(subtype: string, forename: string, surname: string, originating_faction: string) --> LLR_LORD
function llr_lord.new(subtype, forename, surname, originating_faction)

    --error checking
    if not is_string(subtype) then
        WEC_ERROR("method #llr_lord.new(subtype, forename, surname, originating_faction)# called but the supplied subtype is not a string!");
        return nil
    end
    if not is_string(forename) then
        WEC_ERROR("method #llr_lord.new(subtype, forename, surname, originating_faction)# called but the supplied forename is not a string!");
        return nil
    end
    if not is_string(surname) then
        WEC_ERROR("method #llr_lord.new(subtype, forename, surname, originating_faction)# called but the supplied surname is not a string!");
        return nil
    end
    if not is_string(originating_faction) then
        WEC_ERROR("method #llr_lord.new(subtype, forename, surname, originating_faction)# called but the supplied originating_faction is not a string!");
        return nil
    end
    --function
    LLRLOG("Adding lord with subtype ["..subtype.."], forename ["..forename.."], surname ["..surname.."] and originating faction ["..originating_faction.."] ")
    local self = {} --once again, we are defining the object as a blank because the type checker prefers this style of doing it.
    setmetatable(self, {
        __index = llr_lord,
        __tostring = function() return "llr_lord" end
    }) 
    -- this basically tells the table we just created to take on the properties of that object type. 
    -- now, any function we define as llr_lord.something can be applied to this object.
    --# assume self: LLR_LORD
    --these are kailua language. Its the type checker I use. This basically is telling the type checker to treat this new object instance as a LLR_LORD class.
    
    self.subtype = subtype
    self.forename = forename
    self.surname = surname
    self.faction = originating_faction


 
    --these add the args we gave as the fields/properties of the object. 
    self.has_quest_set = false --:boolean
    self.quest_ancilaries = {} --:vector<{string, number}>
    self.has_immortal_trait_set = false --: boolean
    self.immortal_trait = nil --:string
    self.no_check = false --: boolean
    --quests won't re-trigger if the AI has already completed them, so we're going to have to reset them manually.

    self.exp_level = nil --:integer

    self.safety_abort = false

    --we now return our brand new object.
    return self
end

--v function() --> LLR_LORD
function llr_lord.null_lord() 
    local self = {}
    setmetatable(self, {
        __index = llr_lord,
        __tostring = "NULL_INTERFACE"
    }) --# assume self: LLR_LORD
    return self
end




--this is a method of the llr_lord class. This means any object we create with llr_lord.new can use this method.
--this particular method is usually called an accessor or a getter, because it accesses or gets information about the object.

--v function(self: LLR_LORD) --> string
function llr_lord.get_faction(self)
    return self.faction;
end


--v function(self: LLR_LORD, subtype: string)
function llr_lord.set_subtype(self, subtype)
    self.subtype = subtype
end

--v function(self: LLR_LORD, name: string)
function llr_lord.set_forename(self, name)
    self.forename = name
end

--v function(self: LLR_LORD, name: string)
function llr_lord.set_surname(self, name)
    self.surname = name
end









--another one. This one checks if a lord has a given originating faction.
--v function(self: LLR_LORD, faction: string) --> boolean
function llr_lord.is_lord_involved(self, faction)
    LLRLOG("IsLordInvolved Returning ["..tostring(faction == self.faction).."] ")
    return faction == self.faction
end

--v function(self: LLR_LORD)
function llr_lord.force(self)
    self.no_check = true
end

--another simple one, this time ill take the space to go over what the Kailua function notation means
--the below translates to a function of the object the function is being applied to must be applied to an object of class LLR_LORD and returns a boolean value.
--in lua, you can call a function on an object manually with object.function(object) or using the shorthand method of object:function()
--v function(self: LLR_LORD) --> boolean
function llr_lord.has_quests(self)
    LLRLOG("Has Quests returning ["..tostring(self.has_quest_set).."] ")
    return self.has_quest_set
end

--v function(self: LLR_LORD) --> boolean
function llr_lord.has_immortal_trait(self)
    LLRLOG("Has immortal traits returning ["..tostring(self.has_immortal_trait_set).."]")
    return self.has_immortal_trait_set
end

--v function(self: LLR_LORD) --> boolean
function llr_lord.forced(self)
    return self.no_check
end

--this method is a mutator, or a setter. 
--it adds data to the model
--v function(self: LLR_LORD, quest_table: vector<{string, number}>)
function llr_lord.add_quest(self, quest_table)
    if not tostring(self) == "llr_lord" then
        WEC_ERROR("method #llr_lord.add_quest(self, quest_table)# not applied to a correct object!")
        return
    elseif not is_table(quest_table) then
        WEC_ERROR("method #llr_lord.add_quest(self, quest_table)# called with a non table quest record!")
        return
    end
    LLRLOG("Adding quests for ["..self.subtype.."] ")
    self.quest_ancilaries = quest_table
    self.has_quest_set = true
end

--v function(self: LLR_LORD, trait_key: string)
function llr_lord.add_immortal_trait(self, trait_key)
    if not tostring(self) == "llr_lord" then
        WEC_ERROR("method #llr_lord.add_immortal_trait(self, trait_key)# not applied to a correct object!")
        return
    elseif not is_string(trait_key) then
        WEC_ERROR("method #llr_lord.add_immortal_trait(self, trait_key)# called with a non-string trait key!")
        return
    end
    LLRLOG("Added immortal trait ["..trait_key.."] to lord with subtype ["..self.subtype.."]")
    self.has_immortal_trait_set = true
    self.immortal_trait = trait_key
end


--this one is a little more complicated. It checks if a lord is on the map after confederation has happened.
--v function(self: LLR_LORD, faction: string) --> CA_CHAR
function llr_lord.survived_confederation(self, faction)

    --we are trying to find something, so we set a variable to say whether we found it.
    local character_faction = cm:get_faction(faction);
    local character_list = character_faction:character_list();
    --CA objects are imported from the game engine, which is written in another languages. 
    --the engine language treats 0, not 1, as the start of a list, so our loop looks different here.
    --Furthermore, we can't apply standard Lua opperators, like # and [i] to a CA object, so we use methods.
    for i = 0, character_list:num_items() - 1 do --num items is equivalent to #
        local character = character_list:item_at(i); --item_at(i) is equivalent to [i]

        if character:character_subtype(self.subtype)  then --since we are only looking for legendary lords, we only need to check for the subtype. 
            LLRLOG("survived_confederation Returning [true]")
            return character
        end
    end
    LLRLOG("survived_confederation Returning [false]")
    return nil
end


--v function(self: LLR_LORD, faction: string)
function llr_lord.transfer_ownership(self, faction)
    LLRLOG("Transfering Ownership of lord with subtype ["..self.subtype.."] to ["..faction.."]")
    self.faction = faction
    cm:set_saved_value("llr_lord"..self.subtype.."_"..self.forename.."_faction_override", faction)
end




--v function(self: LLR_LORD, human_faction_name: string)
function llr_lord.respawn_to_pool(self, human_faction_name)

    LLRLOG("Respawning lord with subtype ["..self.subtype.."] to pool!")
    --a simple one, I just need to respawn a lord to the pool with one command. 
    cm:spawn_character_to_pool(human_faction_name, self.forename, self.surname, "", "", 18, true, "general", self.subtype, true, "");
    --notice how the information I need for the lord is all taken from the object, 
    --but I use human_faction dynamically because there could potential be a situation where players could both confederate a lord. (bret)

    LLRLOG("Lord with subtype ["..self.subtype.."] confederated but not currently on the map!")
end

--v function(self: LLR_LORD, cqi: CA_CQI)
function llr_lord.grant_quest_items(self, cqi)
    LLRLOG("Granting quest items!")
    --run through our list of quest saved values
    if self:has_quests() then
        for i = 1, #self.quest_ancilaries do
            if self.exp_level >= self.quest_ancilaries[i][2] then
                cm:force_add_and_equip_ancillary(cm:char_lookup_str(cqi), self.quest_ancilaries[i][1])
            else
                LLRLOG("Legendary lord is not sufficiently high level to aquire the current quest item!")
            end
        end
    end

end


--v function(self: LLR_LORD, faction: string, character: CA_CHAR)
function llr_lord.respec_wounded_lord(self, faction, character)
    local exp_to_levels_table = {
        0, 900,  1900,  3000, 4200,  5500,6870, 8370, 9940,
        11510,13080,14660, 16240,17820,19400, 20990,22580,24170,25770,27370,28980,30590,32210,
        33830,35460,37100,38740, 40390,42050,43710,45380,47060,48740,50430,52130, 53830, 55540,57260,58990,
        60730, 60730, 60730, 60730,  60730, 60730, 60730, 60730, 60730,  60730, 60730, 60730,
        60730 }--:vector<number>

    --this long ass list is just a list of exp quantities to level.
    --we add a bunch of extras on the end to compat with extra level mods. 

    --first, we need to note some information about the old character.
    self.exp_level = character:rank() 
    --we are going to use the home settlement for our x and y. 
    self.x = cm:get_faction(faction):home_region():settlement():logical_position_x() + 1;
    self.y = cm:get_faction(faction):home_region():settlement():logical_position_y() - 1;
    self.region = cm:get_faction(faction):home_region():name()
    --now we need to kill the old, wounded lord.
    --we need to prevent the message from showing up in the event feed.
    cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
    --now, we need to strip immortality from the character
    cm:set_character_immortality(cm:char_lookup_str(character:command_queue_index()), false);

    if self:has_immortal_trait() == true then
        cm:force_remove_trait(cm:char_lookup_str(character:command_queue_index()), self.immortal_trait)
    end

    --finally, we kill him.
    cm:kill_character(character:command_queue_index(), false, true)
    --turn message back on on a callback.
    cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);

    local army_list = cm:get_faction(faction):military_force_list()
    local army = army_list:item_at(0):unit_list()

    self.army_list = {} --:vector<string>

    for j = 0, army:num_items() - 1 do
        local current_unit = army:item_at(j):unit_key()

        table.insert(self.army_list, current_unit)

    end

    self.spawn_string = ""

    for k = 2, #self.army_list do

        next_string = self.spawn_string..","..self.army_list[k]

        self.spawn_string = next_string
    end
    cm:create_force_with_general(
        faction,
        self.spawn_string,
        self.region,
        self.x,
        self.y,
        "general",
        self.subtype,
        self.forename,
        "",
        self.surname,
        "",
        false,
        function(cqi) 
            LLRLOG("Levelling up the respec'd lord!")
            cm:set_character_immortality(cm:char_lookup_str(cqi), true);
            self:grant_quest_items(cqi)
            self.cqi = cqi
            --this makes sure our shiny new lord is immortal.
            cm:add_agent_experience(cm:char_lookup_str(cqi), exp_to_levels_table[self.exp_level])
            --this references our exp table at the top of this function.
            
            --we want this lord to be wounded, however, he also has a random ass army
            --[[

            ]]--
        end)
        cm:callback(function()
            LLRLOG(tostring(self.cqi))
            cm:kill_character(self.cqi, true, true)
        end, 2);
end

--v function(self: LLR_LORD, faction: string, character: CA_CHAR)
function llr_lord.respec_char_with_army(self, faction, character)
    local exp_to_levels_table = {
        0, 900,  1900,  3000, 4200,  5500,6870, 8370, 9940,
      11510,13080,14660, 16240,17820,19400, 20990,22580,24170,25770,27370,28980,30590,32210,
      33830,35460,37100,38740, 40390,42050,43710,45380,47060,48740,50430,52130, 53830, 55540,57260,58990,
      60730, 60730, 60730, 60730,  60730, 60730, 60730, 60730, 60730,  60730, 60730, 60730,
      60730 }--:vector<number>

    --this long ass list is just a list of exp quantities to level.
    --we add a bunch of extras on the end to compat with extra level mods. 


    LLRLOG("Respecing lord with subtype ["..self.subtype.."] ")

    --this will catch any mishandle of the respec
    local character_faction = cm:get_faction(faction)
    if cm:get_faction(self.faction):is_human() then
        WEC_ERROR("llr_lord.respec_char_with_army(self, faction, character) tried to act on a human faction? ABORTING ")
        return
    end

        

        --first, we need to store the army list.
        self.army_list = {}
        --first we define an empty table to store it in.
        --notice we use j in this loop because i is already taken.
        for j = 0, character:military_force():unit_list():num_items() - 1 do
            local current_unit = character:military_force():unit_list():item_at(j):unit_key()
            --now we get each unit object in the army and convert it into it's unit key string.
            table.insert(self.army_list, current_unit)
            --finally, we add that string to the list we declared.
        end
        --there are problems with adding tons of units to an army, so we're going to have to assembly the string.
        --first, we need a blank string to start adding stuff to.
        self.spawn_string = ""
        --the first "unit" in every army is the general himself. 
        --so we're going to start this loop at #2 because otherwise we might end up with two lords!

        --failsafe for heroes

        for k = 2, #self.army_list do
            --we define the next string as a variable.
            --we insert the comma to conform to the unit_spawn_list_string format that CA uses.
            if string.find(self.army_list[k], "_cha_") then
                LLRLOG("Skipping ["..self.army_list[k].."] because it is a character")
            else
                --now, we set the self.spawn_string to the string we assembled.
                --we cannot do this directly in the way that you would increment a variable a = a + 1 because in lua strings are immutable.
                next_string = self.spawn_string..","..self.army_list[k]     
                self.spawn_string = next_string
            end
        end
        LLRLOG("Assembled spawn string as ["..self.spawn_string.."] ")
        if self.spawn_string == "" then
            self:respec_wounded_lord(faction, character)
            return
        end

        --now, get the exp level of the character
        self.exp_level = character:rank() 
        LLRLOG("noted the ranked of the lord as ["..tostring(self.exp_level).."] ")
        --get the positioning of the army.
        self.x = character:logical_position_x()
        self.y = character:logical_position_y()
        if not character:region():is_null_interface() then --catch the lord being at sea!
            self.region = character:region():name()
        else
            self.region = cm:get_faction(faction):home_region():name()
        end
        --this one is actually risky, so we need to do a check!
        --if the lord happens to be in the chaos wastes then the spawn command will fail.
        --a quirk of the spawn command is that the spawn region has to have a settlement.
        --as a backup, we make the spawn region the capital of the faction.
        if cm:get_region(self.region):settlement():is_null_interface() then
            self.region = cm:get_faction(faction):home_region():name()
        end

        LLRLOG("found positioning data as x = ["..tostring(self.x).."], y = ["..tostring(self.y).."], region = ["..self.region.."]")

        LLRLOG("Killing the inherited lord!")
        --we need to prevent the message from showing up in the event feed.
        cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
        --now, we need to strip immortality from the character
        cm:set_character_immortality(cm:char_lookup_str(character:command_queue_index()), false);

        if self:has_immortal_trait() == true then
            cm:force_remove_trait(cm:char_lookup_str(character:command_queue_index()), self.immortal_trait)
        end

        --finally, we kill him and his army.
        cm:kill_character(character:command_queue_index(), true, true)
        --turn message back on on a callback.
        cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
        --now, spawn the lord
        --we do this on a callback for safety. 
        cm:callback( function()
            LLRLOG("spawning lord for respec!")
            cm:create_force_with_general(
            faction,
            self.spawn_string,
            self.region,
            self.x,
            self.y,
            "general",
            self.subtype,
            self.forename,
            "",
            self.surname,
            "",
            false,
            function(cqi) 
                LLRLOG("Levelling up the respec'd lord!")
                cm:set_character_immortality(cm:char_lookup_str(cqi), true);
                self:grant_quest_items(cqi)
                --this makes sure our shiny new lord is immortal.
                cm:add_agent_experience(cm:char_lookup_str(cqi), exp_to_levels_table[self.exp_level])
                --this references our exp table at the top of this function.

                
                LLRLOG("Levelling up the respec'd lord finished.")
            end)
        end,
        0.1
    );

end








--we are creating another object now, this one to handle all those little objects we made. 
--v function() --> LLR_MANAGER
function llr_manager.new()
  LLRLOG("Creating the manager!");
    local self = {}
    setmetatable(self, {
        __index = llr_manager,
        __tostring = function() return "llr_lord" end
    })
    --# assume self: LLR_MANAGER
    local cm = get_cm() --this isn't 100% necessary, but its safe.
    self.humans = cm:get_human_factions()
    --this one actually returns a vector of strings (the faction names) so we handle it like a normal lua list.
    
    --we only want to listen for confederations for human subcultures. Doing it for the rest is a waste of resources.
    --first we initialise the table.
    self.subcultures = {} --:map<string, bool>
    --now we start cycling through our humans list.
    for i, v in pairs(self.humans) do
        --we get a subculture for each human
        local sc = cm:get_faction(v):subculture()
        --we set the value of that subculture key in the table to true.
        self.subcultures[sc] = true
    end
    --now we initialise the same for factions, but we don't know what factions we want to listen for yet, so we leave this alone.
    self.factions = {} --:map<string, bool>
    --finally, we have to initialise our storage table for the lord objects themselves. They go in here!
    self.lords = {} --:map<string, vector<LLR_LORD>>

    return self
end


--v function(self: LLR_MANAGER, text: string)
function llr_manager.log(self, text)
LLRLOG(tostring(text))
end








--unlike the other methods we've looked at, which were basically functional or accessors, this one is a "mutator", or a "setter"
--it adds or edits information in the model.
--v function(self: LLR_MANAGER, lord: LLR_LORD)
function llr_manager.add_lord(self, lord) 
    --error checking
    if not tostring(self) == "llr_manager" then
        WEC_ERROR("method #llr_manager.add_lord(self, lord)# called but is not being applied to a correct object!")
        return
    end
    if not tostring(lord) == "llr_lord" then
        WEC_ERROR("method #llr_manager.add_lord(self, lord)# called but the supplied lord is not a LLR_LORD object!")
    end

    if is_string(cm:get_saved_value("llr_lord"..lord.subtype.."_"..lord.forename.."_faction_override")) then
        lord.faction = cm:get_saved_value("llr_lord"..lord.subtype.."_"..lord.forename.."_faction_override")
        LLRLOG("Faction override for new lord found, overriding faction is ["..lord.faction.."] ")
    end


    
    --first of all, we want to get the faction associated with the lord object we've been given. 
    local faction = lord:get_faction()
    

    --next, we want to prevent duplicate custom lords being added.
    LLRLOG("Adding a lord to manager! Lord forced ["..tostring(lord:forced()).."]; New faction ["..tostring(self.lords[faction] == nil).."] ");
    if tostring(lord:forced()) == "false" and tostring(self.lords[faction] == nil) == "false" then
        LLRLOG("Checking this lord!")
        for i = 1, #self.lords[faction] do
            local cl = self.lords[faction][i]
            if lord.subtype == cl.subtype and lord.forename == cl.forename then
                LLRLOG("Lord with subtype ["..lord.subtype.."] was being added to the model but is a duplicate!")
                return
            end
        end
    end
        


    --if we haven't stored any lords for this faction yet, then the index for them isn't going to be initialised.
    --trying to table.insert into soemthing that isn't yet a table would crash the script, not good!
    if self.lords[faction] == nil then
         self.lords[faction] = {} 
    end --this will handle that problem.

    


  
   
    local t = self.lords[faction] --get a handle on the index of lords for that faction
    table.insert(t, lord) --insert our new lord
    self.factions[faction] = true --tell the script to check for this faction when listening for confederations. 
    --we can do the above multiple times because as long as it is true, it works.
end


--v function(self: LLR_MANAGER, subtype: string, faction: string) --> LLR_LORD
function llr_manager.find_lord_with_subtype(self, subtype, faction)

    --error checks

    if not tostring(self) == "llr_manager" then
        WEC_ERROR("method #llr_manager.find_lord_with_subtype(self, subtype, faction)# called but is not being applied to a correct object!")
        return llr_lord.null_lord()
    end
    if not is_string(subtype) then
        WEC_ERROR("method #llr_manager.find_lord_with_subtype(self, subtype, faction)# called but the supplied subtype is not a string! ")
        return llr_lord.null_lord()
    elseif not is_string(faction) then
        WEC_ERROR("method #llr_manager.find_lord_with_subtype(self, subtype, faction)# called but the supplied faction is not a string! ")
        return llr_lord.null_lord()
    end
    --function

    LLRLOG("Find Lord with Subtype called for subtype ["..subtype.."] and faction ["..faction.."] ")
    if self.lords[faction] == nil then
        self.lords[faction] = {}
        WEC_ERROR("method #llr_manager.find_lord_with_subtype(self, subtype, faction)# called but no lord could be found!")
        return llr_lord.null_lord()
    else
        for i = 1, #self.lords[faction] do
            if self.lords[faction][i].subtype == subtype then
                LLRLOG("Retrieved lord with subtype ["..subtype.."] and faction ["..faction.."] from the model ")
                return self.lords[faction][i]
            end
        end
        WEC_ERROR("method #llr_manager.find_lord_with_subtype(self, subtype, faction)# called but no lord could be found!")
        return llr_lord.null_lord()
    end
end
    




--v function(self: LLR_MANAGER, subtype: string, faction: string)
function llr_manager.remove_lord(self, subtype, faction)
    if not tostring(self) == "llr_manager" then
        WEC_ERROR("method #llr_manager.remove_lord(self, subtype, faction)# called but is not being applied to a correct object!")
        return 
    end
    if not is_string(subtype) then
        WEC_ERROR("method #llr_manager.remove_lord(self, subtype, faction)# called but the supplied subtype is not a string! ")
        return 
    elseif not is_string(faction) then
        WEC_ERROR("method #llr_manager.remove_lord(self, subtype, faction)# called but the supplied faction is not a string! ")
        return
    end

    LLRLOG("Remove Lord called for subtype ["..subtype.."] and faction ["..faction.."] ")
    if self.lords[faction] == nil then
        self.lords[faction] = {}
        WEC_ERROR("method #llr_manager.remove_lord(self, subtype, faction)# called but no lord could be found!")
        return
    else
        for i = 1, #self.lords[faction] do
            if self.lords[faction][i].subtype == subtype then
                LLRLOG("Removed lord with subtype ["..subtype.."] and faction ["..faction.."] from the model ")
                table.remove(self.lords[faction], i)
                return 
            end
        end
        WEC_ERROR("method #llr_manager.remove_lord(self, subtype, faction)# called but no lord could be found!")
        return
    end
end



--v function(self: LLR_MANAGER, lord: LLR_LORD, faction: string)
function llr_manager.transfer_lord_ownership(self, lord, faction)

    local cached_faction = lord.faction
    local subtype = lord.subtype
    LLRLOG("Transfering ownership of ["..subtype.."] from ["..cached_faction.."] to ["..faction.."] ")
    if self.lords[faction] == nil then
        self.lords[faction] = {} 
    end


    lord:transfer_ownership(faction)
    local faction_index = self.lords[faction]
    table.insert(self.lords[faction], lord)

    self:remove_lord(subtype, cached_faction)
end
    




--v function(self: LLR_MANAGER)
function llr_manager.activate(self)
    --time to tell our manager to actually do stuff!
    LLRLOG("Activating the Manager!");
    core:trigger_event("LegendaryLordModelActivated")
    --this event is listened for by other mods, to know when to add their lords into the system!
    

    --this listener is the key part of the map.
    core:add_listener(
        "llr_manager",
        "FactionJoinsConfederation",
        function(context)
            local sc = context:faction():subculture()
            local faction = context:faction():name()
            --check if we are listening for that subculture, and if any lords are registered for it.
            return self.subcultures[sc] and self.factions[faction]
        end,
        function(context)
            local faction_name = context:faction():name(); --the faction getting eaten up.
            local confederation_name = context:confederation():name(); --the (player?) faction doing the eating.

            for k, v in pairs(self.lords) do
                if k == faction_name then --we only want lords who are from the faction being confederated
                    if cm:get_faction(confederation_name):is_human() then
                        for i = 1, #v do
                            local character = v[i]:survived_confederation(confederation_name)
                            if character then --if they have survived the confederation (IE they are alive on the map)
                                if not character:is_wounded() then
                                    v[i]:respec_char_with_army(confederation_name, character) --we use the respec method we defined earlier.
                                else
                                    LLRLOG("Char is wounded!")
                                    v[i]:respec_wounded_lord(confederation_name, character)
                                end
                            else --otherwise, if we can't find them on the map
                                v[i]:respawn_to_pool(confederation_name) -- we give them to our confederator.
                            end
                        end
                    else --if the confederator isn't human they don't need to respec!
                        for i = 1, #v do
                            self:transfer_lord_ownership(v[i], confederation_name) --but we will transfer their ownership.
                        end
                    end
                end
            end

        end,
        true); --we want this listener to trigger as many times as necessary.

end



--for other mods to use these functions, we need to add them to the game space, making them public.
_G.llr_manager = llr_manager; 
_G.llr_lord = llr_lord --this will let other people create new llr_lord objects
LLRLOG("Init Finished")
out("WEC: LEGENDARY LORD REVIVES ACTIVE") --we want to leave some trace of our mod in the general log.

function wec_llr() --this is the function that the CA script loader calls.

LLRLOG("Checkpoint [1]")
llr = llr_manager.new() --create our manager
_G.llr = llr --add our new manager to the gamespace, other mods will need this to add any lords to it!

llr:activate() --activate our manager.

--lord template
--[[

  {
    ["subtype"] = "",
    ["forename"] = "",
    ["surname"] = "",
    ["faction"] = ""
  },

]]

--these are all quest tables, copied from CA. 
local karl_franz_quests = {
    {"wh_main_anc_weapon_the_reikland_runefang", 8},
    {"wh_main_anc_weapon_ghal_maraz", 13},
    {"wh_main_anc_talisman_the_silver_seal", 18}
}--: vector<{string, number}>

local balthasar_gelt_quests = {
    {"wh_main_anc_enchanted_item_cloak_of_molten_metal", 8},
    {"wh_main_anc_talisman_amulet_of_sea_gold", 13},
    {"wh_main_anc_arcane_item_staff_of_volans", 18}
}--: vector<{string, number}>

local volkmar_the_grim_quests = {
    {"wh_dlc04_anc_talisman_jade_griffon", 8},
    {"wh_dlc04_anc_weapon_staff_of_command", 13}
}--: vector<{string, number}>

local thorgrim_grudgebearer_quests = {
    {"wh_main_anc_weapon_the_axe_of_grimnir", 8}, 
    {"wh_main_anc_armour_the_armour_of_skaldour", 13}, 
    {"wh_main_anc_talisman_the_dragon_crown_of_karaz", 18},
    {"wh_main_anc_enchanted_item_the_great_book_of_grudges", 23}}--: vector<{string, number}>

local ungrim_ironfist_quests = {
    {"wh_main_anc_armour_the_slayer_crown", 8},
    {"wh_main_anc_talisman_dragon_cloak_of_fyrskar", 13}, 
    {"wh_main_anc_weapon_axe_of_dargo", 18}
}--: vector<{string, number}>

local grombrindal_quests = {
{"wh_pro01_dwf_grombrindal_amour_of_glimril_scales", 8}, 
{"wh_pro01_dwf_grombrindal_rune_axe_of_grombrindal", 13},
{"wh_pro01_dwf_grombrindal_rune_cloak_of_valaya", 18},
{"wh_pro01_dwf_grombrindal_rune_helm_of_zhufbar", 23}
}--: vector<{string, number}>

local grimgor_ironhide_quests = {
    {"wh_main_anc_weapon_gitsnik", 8}, 
    {"wh_main_anc_armour_blood-forged_armour", 13}
}--: vector<{string, number}>

local azhag_the_slaughterer_quests = {
    {"wh_main_anc_enchanted_item_the_crown_of_sorcery", 8},
    {"wh_main_anc_armour_azhags_ard_armour", 13},
    {"wh_main_anc_weapon_slaggas_slashas", 18}}--: vector<{string, number}>

local mannfred_von_carstein_quests = {
    {"wh_main_anc_weapon_sword_of_unholy_power", 8},
    {"wh_main_anc_armour_armour_of_templehof", 13}
}--: vector<{string, number}>

local heinrich_kemmler_quests = {
    {"wh_main_anc_weapon_chaos_tomb_blade", 8},
    {"wh_main_anc_enchanted_item_cloak_of_mists_and_shadows", 13}, 
    {"wh_main_anc_arcane_item_skull_staff", 18}
}--: vector<{string, number}>

local vlad_von_carstein_quests = {
    {"wh_dlc04_anc_weapon_blood_drinker", 8}, 
    {"wh_dlc04_anc_talisman_the_carstein_ring", 13}
}--: vector<{string, number}>

local helman_ghorst_quests = {
    {"wh_dlc04_anc_arcane_item_the_liber_noctus", 8}
}--: vector<{string, number}>


local belegar_quests = {
    {"wh_dlc06_anc_armour_shield_of_defiance", 8},
    {"wh_dlc06_anc_weapon_the_hammer_of_angrund", 13}
}--: vector<{string, number}>

local skarsnik_quests = {
    {"wh_dlc06_anc_weapon_skarsniks_prodder", 8}
}--: vector<{string, number}>

local wurrzag_quests = {
    {"wh_dlc06_anc_enchanted_item_baleful_mask", 8},
    {"wh_dlc06_anc_arcane_item_squiggly_beast", 13}, 
    {"wh_dlc06_anc_weapon_bonewood_staff", 18}
}--: vector<{string, number}>

local orion_quests = {
    {"wh_dlc05_anc_enchanted_item_horn_of_the_wild_hunt", 8},
    {"wh_dlc05_anc_talisman_cloak_of_isha", 13}, 
    {"wh_dlc05_anc_weapon_spear_of_kurnous", 18}
}--: vector<{string, number}>

local durthu_quests = {
    {"wh_dlc05_anc_weapon_daiths_sword", 8}
}--: vector<{string, number}>

local fay_enchantress_quests = {
    {"wh_dlc07_anc_arcane_item_the_chalice_of_potions", 9}
}--: vector<{string, number}>

local alberic_quests = {
{"wh_dlc07_anc_weapon_trident_of_manann", 3}
}--: vector<{string, number}>

local louen_quests = {
{"wh_main_anc_weapon_the_sword_of_couronne", 9}
}--: vector<{string, number}>

local isabella_quests = {
    {"wh_pro02_anc_enchanted_item_blood_chalice_of_bathori", 8}
}--: vector<{string, number}>

local tyrion_quests = {
    {"wh2_main_anc_weapon_sunfang", 10},
    {"wh2_main_anc_armour_dragon_armour_of_aenarion", 6},
    {"wh2_main_anc_enchanted_item_heart_of_avelorn", 0}
}--: vector<{string, number}>

local teclis_quests = {
    {"wh2_main_anc_weapon_sword_of_teclis", 10},
    {"wh2_main_anc_arcane_item_war_crown_of_saphery", 6},
    {"wh2_main_anc_arcane_item_moon_staff_of_lileath", 0},
    {"wh2_main_anc_arcane_item_scroll_of_hoeth", 0}
}--: vector<{string, number}>

local malekith_quests = {
    {"wh2_main_anc_weapon_destroyer", 10}, 
    {"wh2_main_anc_arcane_item_circlet_of_iron", 6},
    {"wh2_main_anc_armour_supreme_spellshield", 14},
    {"wh2_main_anc_armour_armour_of_midnight", 0}
} --: vector<{string, number}>

local morathi_quests = {
    {"wh2_main_anc_weapon_heartrender_and_the_darksword", 6},
    {"wh2_main_anc_arcane_item_wand_of_the_kharaidon", 0},
    {"wh2_main_anc_talisman_amber_amulet", 0}
}--: vector<{string, number}>

local mazdamundi_quests = {
    {"wh2_main_anc_weapon_cobra_mace_of_mazdamundi", 10},
    {"wh2_main_anc_magic_standard_sunburst_standard_of_hexoatl", 6}
}--: vector<{string, number}>

local kroq_gar_quests = {
    {"wh2_main_anc_enchanted_item_hand_of_gods", 10},
    {"wh2_main_anc_weapon_revered_spear_of_tlanxla", 6}
}--: vector<{string, number}>

local skrolk_quests = {
    {"wh2_main_anc_weapon_rod_of_corruption", 10},
    {"wh2_main_anc_arcane_item_the_liber_bubonicus", 6}
}--: vector<{string, number}>	

local queek_headtaker_quests = {
    {"wh2_main_anc_armour_warp_shard_armour", 6},
    {"wh2_main_anc_weapon_dwarf_gouger", 10}
}--: vector<{string, number}>

local tretch_craventail_quests = {
    {"wh2_dlc09_anc_enchanted_item_lucky_skullhelm", 8}
}--: vector<{string, number}>

local wulfrik_quests = {
    {"wh_dlc08_anc_weapon_sword_of_torgald", 9}
}--: vector<{string, number}>

local throgg_quests = {
    {"wh_dlc08_anc_talisman_wintertooth_crown", 9}
}--: vector<{string, number}>

local alith_anar_quests = {
    {"wh2_dlc10_anc_talisman_stone_of_midnight", 0},
    {"wh2_dlc10_anc_weapon_moonbow", 5}
}--: vector<{string, number}>
local alarielle_quests = {
    {"wh2_dlc10_anc_talisman_shieldstone_of_isha", 2},
    {"wh2_dlc10_anc_enchanted_item_star_of_avelorn", 15}
}--: vector<{string, number}>

local hellebron_quests = {
    {"wh2_dlc10_anc_weapon_deathsword_and_the_cursed_blade", 8},
    {"wh2_dlc10_anc_talisman_amulet_of_dark_fire", 15}
}--: vector<{string, number}>



local vanilla_lords = {
    {faction = "wh2_main_skv_clan_mors",forename = "names_name_2147359300",surname = "names_name_2147360908",subtype ="wh2_main_skv_queek_headtaker", quests = queek_headtaker_quests },
    {faction = "wh2_main_skv_clan_pestilens",forename = "names_name_2147359289",surname = "names_name_2147359296",subtype ="wh2_main_skv_lord_skrolk", quests = skrolk_quests },
    {faction = "wh2_main_lzd_hexoatl",forename = "names_name_2147359221",surname = "names_name_2147359230",subtype ="wh2_main_lzd_lord_mazdamundi", quests = mazdamundi_quests },
    {faction = "wh2_main_lzd_last_defenders",forename = "names_name_2147359240",surname = "names_name_2147360514",subtype ="wh2_main_lzd_kroq_gar", quests = kroq_gar_quests },
    {faction = "wh2_main_hef_eataine",forename = "names_name_2147360906",surname = "names_name_2147360506",subtype ="wh2_main_hef_tyrion", quests = tyrion_quests },
    {faction = "wh2_main_hef_order_of_loremasters",forename = "names_name_2147359256",surname = "names_name_2147360506",subtype ="wh2_main_hef_teclis", quests = teclis_quests },
    {faction = "wh2_main_def_cult_of_pleasure",forename = "names_name_2147359274",surname = "names_name_2147360508",subtype ="wh2_main_def_morathi", quests = morathi_quests },
    {faction = "wh2_main_def_naggarond",forename = "names_name_2147359265",surname = "names_name_2147360508",subtype ="wh2_main_def_malekith", quests = malekith_quests },
    {faction = "wh_main_vmp_vampire_counts",forename = "names_name_2147343886",surname = "names_name_2147343895",subtype ="vmp_mannfred_von_carstein", quests = mannfred_von_carstein_quests },
    {faction = "wh_main_vmp_vampire_counts",forename = "names_name_2147345320",surname = "names_name_2147345313",subtype ="vmp_heinrich_kemmler", quests = heinrich_kemmler_quests },
    {faction = "wh_main_vmp_schwartzhafen",forename = "names_name_2147345124",surname = "names_name_2147343895",subtype ="pro02_vmp_isabella_von_carstein", quests = isabella_quests },
    {faction = "wh_main_dwf_dwarfs",forename = "names_name_2147358917",surname = "names_name_2147358935",subtype ="pro01_dwf_grombrindal", quests = grombrindal_quests },
    {faction = "wh_main_grn_greenskins",forename = "names_name_2147343863",surname = "names_name_2147343867",subtype ="grn_grimgor_ironhide", quests = grimgor_ironhide_quests },
    {faction = "wh_main_grn_greenskins",forename = "names_name_2147345906",surname = "names_name_2147357356",subtype ="grn_azhag_the_slaughterer", quests = azhag_the_slaughterer_quests },
    {faction = "wh_main_emp_empire",forename = "names_name_2147343849",surname = "names_name_2147343858",subtype ="emp_karl_franz", quests = karl_franz_quests },
    {faction = "wh_main_emp_empire",forename = "names_name_2147343922",surname = "names_name_2147343928",subtype ="emp_balthasar_gelt", quests = balthasar_gelt_quests },
    {faction = "wh_main_dwf_karak_kadrin",forename = "names_name_2147344414",surname = "names_name_2147344423",subtype ="dwf_ungrim_ironfist", quests = ungrim_ironfist_quests },
    {faction = "wh_main_dwf_dwarfs",forename = "names_name_2147343883",surname = "names_name_2147343884",subtype ="dwf_thorgrim_grudgebearer", quests = thorgrim_grudgebearer_quests },
    {faction = "wh_main_brt_carcassonne",forename = "names_name_2147358931",surname = "names_name_2147359018",subtype ="dlc07_brt_fay_enchantress", quests = fay_enchantress_quests },
    {faction = "wh_main_brt_bordeleaux",forename = "names_name_2147345888",surname = "names_name_1529663917",subtype ="dlc07_brt_alberic", quests = alberic_quests },
    {faction = "wh_main_grn_orcs_of_the_bloody_hand",forename = "names_name_2147358023",surname = "names_name_2147358027",subtype ="dlc06_grn_wurrzag_da_great_prophet", quests = wurrzag_quests },
    {faction = "wh_main_grn_crooked_moon",forename = "names_name_2147358016",surname = "names_name_2147358924",subtype ="dlc06_grn_skarsnik", quests = skarsnik_quests },
    {faction = "wh_main_dwf_karak_izor",forename = "names_name_2147358029",surname = "names_name_2147358036",subtype ="dlc06_dwf_belegar", quests = belegar_quests },
    {faction = "wh_dlc05_wef_wood_elves",forename = "names_name_2147352809",surname = "names_name_2147359013",subtype ="dlc05_wef_orion", quests = orion_quests },
    {faction = "wh_dlc05_wef_argwylon",forename = "names_name_2147352813",surname = "names_name_2147359013",subtype ="dlc05_wef_durthu", quests = durthu_quests },
    {faction = "wh_main_vmp_schwartzhafen",forename = "names_name_2147345130",surname = "names_name_2147343895",subtype ="dlc04_vmp_vlad_con_carstein", quests = vlad_von_carstein_quests },
    {faction = "wh_main_vmp_vampire_counts",forename = "names_name_2147358044",surname = "names_name_2147345294",subtype ="dlc04_vmp_helman_ghorst", quests = helman_ghorst_quests },
    {faction = "wh_main_emp_empire",forename = "names_name_2147358013",surname = "names_name_2147358014",subtype ="dlc04_emp_volkmar", quests = volkmar_the_grim_quests },
    {faction = "wh_main_emp_middenland",forename = "names_name_2147343937",surname = "names_name_2147343940",subtype ="dlc03_emp_boris_todbringer", quests = nil },
    {faction = "wh_main_brt_bretonnia",forename = "names_name_2147343915",surname = "names_name_2147343917",subtype ="brt_louen_leoncouer", quests = louen_quests },
    {faction = "wh2_dlc09_skv_clan_rictus",forename = "names_name_2147343915",surname = "names_name_2147343917",subtype ="wh2_dlc09_skv_tretch_craventail", quests = tretch_craventail_quests },
    {faction = "wh2_main_hef_avelorn", forename = "names_name_898828143", surname = "", subtype = "wh2_dlc10_hef_alarielle", quests = alarielle_quests},
    {faction = "wh_dlc08_nor_wintertooth", forename = "names_name_346878492", subtype = "wh_dlc08_nor_throgg", surname = "",quests = throgg_quests },
    {faction = "wh_dlc08_nor_norsca", forename = "names_name_981430255", surname = "names_name_791685155", subtype = "wh_dlc08_nor_wulfrik", quests = wulfrik_quests },
    {subtype = "wh2_dlc10_def_crone_hellebron", forename = "names_name_608740515", surname = "", faction = "wh2_main_def_har_ganeth", quests = hellebron_quests},
    {faction = "wh2_main_hef_nagarythe", subtype = "wh2_dlc10_hef_alith_anar", forename = "names_name_1829581114", surname = "", quests = alith_anar_quests},
    {faction = "wh_main_vmp_mousillon",forename = "names_name_2147359236",surname = "",subtype ="wh_dlc05_vmp_red_duke", quests = nil }

}--:vector<{faction: string, forename: string, surname: string, subtype: string, quests: vector<{string, number}>}>


for i = 1, #vanilla_lords do --start looping through the information we just defined.
    local clord = vanilla_lords[i] --makes the rest shorter and easier to type.
    local fact = clord.faction 
    local fname = clord.forename
    local sname = clord.surname
    local subtype = clord.subtype
    local lord = llr_lord.new(subtype, fname, sname, fact) --create the new lord object.
    --if we have a quest table for this lord, we need to add it.
    if clord.quests then
        lord:add_quest(clord.quests)
    end
        lord:force()
        llr:add_lord(lord) --add the new lord to our model.
    end
    LLRLOG("Triggering the Vanilla Lords Added Event")
    core:trigger_event("LegendaryLordVanillaLordsAdded")
end

--THE FUCKING END

--if you have any questions feel free to hop on C&C discord and ask me!
