cm:set_saved_value("wec_ll_revival", true);
function LLRLOGRESET()
    if not __write_output_to_logfile then
        return;
    end
    
    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string
    
    local popLog = io.open("warhammer_expanded_log.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close()
end
LLRLOGRESET()
--v function(text: string)
function LLRLOG(text)
    if not __write_output_to_logfile then
      return; 
    end

  local logText = tostring(text)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("warhammer_expanded_log.txt","a")
  --# assume logTimeStamp: string
  popLog :write("LLR:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

--v [NO_CHECK] function() 
function LLR_ERROR_FINDER()
    --Vanish's PCaller
    --All credits to vanish
    --v function(func: function) --> any
        function safeCall(func)
            --output("safeCall start");
            local status, result = pcall(func)
            if not status then
                LLRLOG(tostring(result))
                LLRLOG(debug.traceback());
            end
            --output("safeCall end");
            return result;
        end
        
        --local oldTriggerEvent = core.trigger_event;
        
        --v [NO_CHECK] function(...: any)
        function pack2(...) return {n=select('#', ...), ...} end
        --v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
        function unpack2(t) return unpack(t, 1, t.n) end
        
        --v [NO_CHECK] function(f: function(), argProcessor: function()) --> function()
        function wrapFunction(f, argProcessor)
            return function(...)
                --output("start wrap ");
                local someArguments = pack2(...);
                if argProcessor then
                    safeCall(function() argProcessor(someArguments) end)
                end
                local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
                --for k, v in pairs(result) do
                --    output("Result: " .. tostring(k) .. " value: " .. tostring(v));
                --end
                --output("end wrap ");
                return unpack2(result);
                end
        end
        
        -- function myTriggerEvent(event, ...)
        --     local someArguments = { ... }
        --     safeCall(function() oldTriggerEvent(event, unpack( someArguments )) end);
        -- end
        
        --v [NO_CHECK] function(fileName: string)
        function tryRequire(fileName)
            local loaded_file = loadfile(fileName);
            if not loaded_file then
                LLRLOG("Failed to find mod file with name " .. fileName)
            else
                LLRLOG("Found mod file with name " .. fileName)
                LLRLOG("Load start")
                local local_env = getfenv(1);
                setfenv(loaded_file, local_env);
                loaded_file();
                LLRLOG("Load end")
            end
        end
        
        --v [NO_CHECK] function(f: function(), name: string)
        function logFunctionCall(f, name)
            return function(...)
                LLRLOG("function called: " .. name);
                return f(...);
            end
        end
        
        --v [NO_CHECK] function(object: any)
        function logAllObjectCalls(object)
            local metatable = getmetatable(object);
            for name,f in pairs(getmetatable(object)) do
                if is_function(f) then
                    LLRLOG("Found " .. name);
                    if name == "Id" or name == "Parent" or name == "Find" or name == "Position" or name == "CurrentState"  or name == "Visible"  or name == "Priority" or "Bounds" then
                        --Skip
                    else
                        metatable[name] = logFunctionCall(f, name);
                    end
                end
                if name == "__index" and not is_function(f) then
                    for indexname,indexf in pairs(f) do
                        LLRLOG("Found in index " .. indexname);
                        if is_function(indexf) then
                            f[indexname] = logFunctionCall(indexf, indexname);
                        end
                    end
                    LLRLOG("Index end");
                end
            end
        end
        
        -- logAllObjectCalls(core);
        -- logAllObjectCalls(cm);
        -- logAllObjectCalls(game_interface);
        
        core.trigger_event = wrapFunction(
            core.trigger_event,
            function(ab)
                --output("trigger_event")
                --for i, v in pairs(ab) do
                --    output("i: " .. tostring(i) .. " v: " .. tostring(v))
                --end
                --output("Trigger event: " .. ab[1])
            end
        );
        
        cm.check_callbacks = wrapFunction(
            cm.check_callbacks,
            function(ab)
                --output("check_callbacks")
                --for i, v in pairs(ab) do
                --    output("i: " .. tostring(i) .. " v: " .. tostring(v))
                --end
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
LLR_ERROR_FINDER()





local llr_manager = {} --# assume llr_manager: LLR_MANAGER
local llr_lord = {} --# assume llr_lord: LLR_LORD
--prototypes for our objects

--instantiate the manager
--v function()
function llr_manager.init()
    local self = {}
    setmetatable(self, {
        __index = llr_manager,
        __tostring = function() return "LLR_MANAGER" end
    }) --# assume self: LLR_MANAGER

    self._subculture = {} --:map<string, boolean>
    self._factions = {} --:map<string, boolean>
    self._lords = {} --:map<string, vector<LLR_LORD>>
    self._movedFactions = {} --:map<string, string>
    self._savedQuests = {} --:map<string, vector<{item: string, level: number, subtype: string}>>
    _G.llr = self
end

--tunnel to log
--v method(text: any)
function llr_manager:log(text)
    LLRLOG(tostring(text))
end

--v function(self: LLR_MANAGER, faction: string, quest_info: {item: string, level: number, subtype: string})
function llr_manager.save_quest(self, faction, quest_info)
    self:log("saving a quest for item ["..quest_info.item.."] at leve ["..quest_info.level.."] on subtype ["..quest_info.subtype.."]")
    if self._savedQuests == nil then
        self._savedQuests = {}
    end
    if self._savedQuests[faction] == nil then 
        self._savedQuests[faction] = {}
    end
    table.insert(self._savedQuests[faction], quest_info)
end


--v function(self: LLR_MANAGER, faction: string, quest_item: string)
function llr_manager.delete_saved_quest(self, faction, quest_item)
    if self._savedQuests[faction] == nil then 
        self._savedQuests[faction] = {}
    end
    local quests = self._savedQuests[faction]
    local index = nil --:integer
    for i = 1, #quests do
        local quest = quests[i]
        if quest.item == quest_item then
            table.remove(self._savedQuests[faction], i)
            return
        end
    end
    self:log("COULD NOT FIND QUEST ["..quest_item.."] TO REMOVE??!")
end



--v function(self: LLR_MANAGER) -->{_movedFactions: map<string, string>, _savedQuests: map<string, vector<{item: string, level: number, subtype: string}>>}
function llr_manager.save(self)
    local savetable = {}
    savetable._movedFactions = self._movedFactions
    savetable._savedQuests = self._savedQuests
    return savetable
end

--v function(self: LLR_MANAGER)
function llr_manager.set_up_loaded_listeners(self)
    for faction, quests in pairs(self._savedQuests) do
        for i = 1, #quests do
            local quest = quests[i]
            self:log("starting a listener for a saved quest for item ["..quest.item.."] at leve ["..quest.level.."] on subtype ["..quest.subtype.."]")
            core:remove_listener("llr_quest_"..quest.item)
            core:add_listener(
                "llr_quest_"..quest.item,
                "CharacterTurnStart",
                function(context)
                    local character = context:character() --:CA_CHAR
                    return character:character_subtype_key() == quest.subtype and character:rank() >= quest.level and character:faction():name() == faction
                end,
                function(context)
                    cm:force_add_and_equip_ancillary(cm:char_lookup_str(context:character():cqi()), quest.item)
                    self:delete_saved_quest(faction, quest.item)
                end,
                false)
        end
    end
end



--v function(self: LLR_MANAGER, loadinfo: {_movedFactions: map<string, string>, _savedQuests: map<string, vector<{item: string, level: number, subtype: string}>>})
function llr_manager.load(self, loadinfo)

    if loadinfo._savedQuests == nil then
        loadinfo._savedQuests = {}
    end
    if loadinfo._movedFactions == nil then
        loadinfo._movedFactions = {}
    end

    self._savedQuests = loadinfo._savedQuests
    self._movedFactions = loadinfo._movedFactions
    self:set_up_loaded_listeners()
end


-----------------------
-----------------------
-----------------------
-----------------------
--LLR_LORD SUB OBJECT--

--v [NO_CHECK] function() --> LLR_LORD
function llr_lord.null_interface()
    null_interface = {}
    null_interface.is_null_interface = function(self) return true end
    return null_interface
end

--v function(model: LLR_MANAGER, faction_key: string, subtype: string, forename: string, surname: string) --> LLR_LORD
function llr_lord.new(model, faction_key, subtype,forename,surname)
    local self = {}
    if not tostring(model) == "LLR_MANAGER" then
        LLRLOG("tried to create a lord but did not provide a valid manager!")
        return llr_lord.null_interface()
    end
    local self = {}
    setmetatable(self, {
        __index = llr_lord,
        __tostring = function() return "LLR_LORD" end
    }) --# assume self: LLR_LORD
    --access to model
    self._model = model
    --basic info
    self._factionKey = faction_key
    self._subtypeKey = subtype
    self._forenameKey = forename
    self._surnameKey = surname
    --traits and already completed quests
    self._questItemLevels = {} --:map<string, number>
    self._caQuestsSafevalues = {} --:vector<string>
    self._immortalityTraits = {} --:vector<string>
    -- value storage for respecs
    self._respawnX = nil --:number
    self._respawnY = nil --:number
    self._respawnRegion = nil --:string
    self._respawnRank = nil --:number
    self._respawnArmyString = nil --:string
    self._newCQI = nil --:CA_CQI
    return self
end

--return the linked model
--v function(self: LLR_LORD) --> LLR_MANAGER
function llr_lord.model(self)
    return self._model
end

--tunnel to log
--v function(self: LLR_LORD, text: any)
function llr_lord.log(self, text)
    self:model():log(text)
end


--return the faction name
--v function(self: LLR_LORD) --> string
function llr_lord.faction(self)
    return self._factionKey
end

--return the subtype
--v function(self: LLR_LORD) --> string
function llr_lord.subtype(self)
    return self._subtypeKey
end

--return the forename
--v function(self: LLR_LORD) --> string
function llr_lord.forename(self)
    return self._forenameKey
end

--return the surname
--v function(self: LLR_LORD) --> string
function llr_lord.surname(self)
    return self._surnameKey
end

--change the faction set on the lord
--warning, this won't change their faction in model. NOT FOR USE EXTERNAL TO MODEL
--v function(self: LLR_LORD, faction: string)
function llr_lord.set_faction(self, faction)
    self._factionKey = faction
end

--change the subtype key of the lord
--v function(self: LLR_LORD, subtype: string)
function llr_lord.set_subtype(self, subtype)
    self._subtypeKey = subtype
end

--change the forename key of the lord
--v function(self: LLR_LORD, forename: string)
function llr_lord.set_forename(self, forename)
    self._forenameKey = forename
end

--change the surname key of the lord
--v function(self: LLR_LORD, surname: string)
function llr_lord.set_surname(self, surname)
    self._surnameKey = surname
end

--get the table of quest items
--v function(self: LLR_LORD) --> map<string, number>
function llr_lord.quest_items(self)
    return self._questItemLevels
end

--add a quest at a level
--v function(self: LLR_LORD, item: string, level: number)
function llr_lord.add_quest(self, item, level)
    if not is_string(item) then
        self:log("ERROR: Tried to add a quest item, but the provided ancillary key is not a string!")
        return
    end
    if not is_number(level) then
        self:log("ERROR: Tried to add a quest item, but the required level is not a number!")
        return
    end

    self._questItemLevels[item] = level
end

--get quests from below or equal to a certain level
--v function(self: LLR_LORD, current_level: number) --> vector<string>
function llr_lord.get_completed_quests(self, current_level)
    if current_level == nil then
        return {}
    end
    local quests = {} --:vector<string>
    for item, level in pairs(self:quest_items()) do
        if level <= current_level then
            table.insert(quests, item)
        end
    end
    return quests
end


--get quests from below or equal to a certain level
--v function(self: LLR_LORD, current_level: number) --> vector<string>
function llr_lord.get_future_quests(self, current_level)
    local quests = {} --:vector<string>
    if current_level == nil then
        current_level = 0
    end
    for item, level in pairs(self:quest_items()) do
        if level > current_level then
            table.insert(quests, item)
        end
    end
    return quests
end


--v function(self: LLR_LORD, quest: string) --> number
function llr_lord.get_level_for_quest(self, quest)
    if self._questItemLevels[quest] == nil then
        return 999
    else
        return self._questItemLevels[quest]
    end
end




--get the table of quests to missions
--v function(self: LLR_LORD) --> vector<string>
function llr_lord.quest_save_values(self)
    return self._caQuestsSafevalues
end

--add a CA quest savevalue
--v function(self: LLR_LORD, save_value: string)
function llr_lord.add_ca_quest_save_value(self, save_value)
    table.insert(self._caQuestsSafevalues, save_value)
end


--v function(self: LLR_LORD) --> vector<string>
function llr_lord.traits(self)
    return self._immortalityTraits
end

--v function(self: LLR_LORD, trait: string)
function llr_lord.add_trait(self, trait)
    table.insert(self._immortalityTraits, trait)
end


--get coordinates
--v function(self: LLR_LORD) --> number
function llr_lord.x(self)
    return self._respawnX
end
--v function(self: LLR_LORD) --> number
function llr_lord.y(self)
    return self._respawnY
end

--set coordinates
--v function(self: LLR_LORD, x: number, y: number)
function llr_lord.set_coordinates(self, x, y)
    self._respawnX = x
    self._respawnY = y
end

--get the army string
--v function(self: LLR_LORD) --> string
function llr_lord.unit_list(self)
    return self._respawnArmyString
end

--assemble a spawn string from the lords force
--v function(self: LLR_LORD, force: CA_MILITARY_FORCE)
function llr_lord.set_unit_string_from_force(self, force)
    local spawn_string = ""--:string
    local army_list = {} --:vector<string>
    --first, convert CA object list into a vector of unit names
    for i = 0, force:unit_list():num_items() - 1 do
        local current_unit = force:unit_list():item_at(i):unit_key()
        table.insert(army_list, current_unit)
    end
    --now, assemble a spawn string
    for i = 2, #army_list do --start at 2, otherwise will capture the land unit of the lord himself

        --we want to check if the current unit is a character, and exclude them if they are
        if string.find(army_list[i], "_cha_") then
            self:log("Skipping "..army_list[i].." because it is a character!")
        elseif army_list[i] == "" then
            --fix for really strange error cases
            self:log("This entry is a blank string! Skipping it")
        else
            next_string = spawn_string..","..army_list[i]
            spawn_string = next_string
        end
    end


    self._respawnArmyString = spawn_string
end

--set the spawn string to a default
--v function(self: LLR_LORD, subculture: string) 
function llr_lord.set_spawn_string_to_subculture_default(self, subculture)
    local subculture_default_units = {
        ["wh_dlc03_sc_bst_beastmen"] = "wh_dlc03_bst_inf_gor_herd_0",
        ["wh_dlc05_sc_wef_wood_elves"] = "wh_dlc05_wef_inf_eternal_guard_1",
        ["wh_main_sc_brt_bretonnia"] = "wh_main_brt_cav_knights_of_the_realm",
        ["wh_main_sc_chs_chaos"] = "wh_main_chs_inf_chaos_warriors_0",
        ["wh_main_sc_dwf_dwarfs"] = "wh_main_dwf_inf_longbeards",
        ["wh_main_sc_emp_empire"] = "wh_main_emp_inf_swordsmen",
        ["wh_main_sc_grn_greenskins"] = "wh_main_grn_inf_orc_big_uns",
        ["wh_main_sc_grn_savage_orcs"] = "wh_main_grn_inf_savage_orc_big_uns",
        ["lololol wh_main_sc_ksl_kislev"] = "wh_main_emp_inf_halberdiers",
        ["wh_main_sc_nor_norsca"] = "wh_main_nor_inf_chaos_marauders_0",
        ["lololol wh_main_sc_teb_teb"] = "wh_main_emp_inf_halberdiers",
        ["wh_main_sc_vmp_vampire_counts"] = "wh_main_vmp_inf_crypt_ghouls",
        ["wh2_dlc09_sc_tmb_tomb_kings"] = "wh2_dlc09_tmb_inf_nehekhara_warriors_0",
        ["wh2_main_sc_def_dark_elves"] = "wh2_main_def_inf_black_ark_corsairs_0",
        ["wh2_main_sc_hef_high_elves"] = "wh2_main_hef_inf_spearmen_0",
        ["wh2_main_sc_lzd_lizardmen"] = "wh2_main_lzd_inf_saurus_warriors_1",
        ["wh2_main_sc_skv_skaven"]  = "wh2_main_skv_inf_stormvermin_0"
    }--:map<string, string>
    


    self._respawnArmyString = subculture_default_units[subculture]
end

--get the lord region
--v function(self: LLR_LORD) --> string
function llr_lord.region(self)
    return self._respawnRegion
end
--set the lord region
--v function(self: LLR_LORD, region: string)
function llr_lord.set_lord_region(self, region)
    self._respawnRegion = region
end

--get the lord rank
--v function(self: LLR_LORD) --> number
function llr_lord.rank(self)
    return self._respawnRank
end
--set the lord rank
--v function(self: LLR_LORD, rank: number)
function llr_lord.set_lord_rank(self, rank)
    self._respawnRank = rank
end


--END OF SUB OBJECT--
---------------------
---------------------
---------------------
---------------------

--set up the subculture tracking
--v function(self: LLR_MANAGER)
function llr_manager.activate(self)
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        self._subculture[cm:get_faction(humans[i]):subculture()] = true
    end
end




--are we tracking this subculture?
--v function(self: LLR_MANAGER, sub: string) --> boolean
function llr_manager.is_tracking_subculture(self, sub)
    if self._subculture[sub] == nil then
        self._subculture[sub] = false
    end
    return self._subculture[sub]
end

--are we tracking this faction?
--v function(self: LLR_MANAGER, faction: string) --> boolean
function llr_manager.is_tracking_faction(self, faction)
    if self._factions[faction] == nil then
        self._factions[faction] = false
    end
    return self._factions[faction]
end

--track a faction for confederations
--v function(self: LLR_MANAGER, faction: string)
function llr_manager.track_faction(self, faction)
    self._factions[faction] = true
end

--clear a faction's lords and stop tracking that faction
--v function(self: LLR_MANAGER, faction: string)
function llr_manager.clear_and_stop_tracking(self, faction)
    self._factions[faction] = false
    self._lords[faction] = {}
end

--get the list of lords for that faction
--v function(self: LLR_MANAGER, faction: string) --> vector<LLR_LORD>
function llr_manager.get_lords_for_faction(self, faction)
    if self._lords[faction] == nil then
        self._lords[faction] = {}
    end
    return self._lords[faction]
end

--add a lord to this faction
--v function(self: LLR_MANAGER, faction: string, lord: LLR_LORD)
function llr_manager.add_lord_to_faction(self, faction, lord)
    table.insert(self:get_lords_for_faction(faction), lord)
    self:track_faction(faction)
end

--remove a lord from this faction
--v function(self: LLR_MANAGER, faction: string, subtype: string)
function llr_manager.remove_lord_with_subtype_from_faction(self, faction, subtype)
    local lords = self:get_lords_for_faction(faction)
    local index = nil --:integer
    for i = 1, #lords do
        if lords[i]:subtype() == subtype then
            index = i
            break
        end
    end
    if not index == nil then
        table.remove(lords, index)
    end
end

--get all faction moves
--v function(self: LLR_MANAGER) --> map<string, string>
function llr_manager.moved_factions(self)
    return self._movedFactions
end


--check if the faction has a move registered
--v function(self: LLR_MANAGER, faction: string) --> boolean
function llr_manager.is_faction_moved(self, faction)
    if self._movedFactions[faction] == nil then
        return false
    else
        return true
    end
end

--get the registered move of a faction
--v function(self: LLR_MANAGER, faction:string) --> string
function llr_manager.get_faction_move(self, faction)
    if self._movedFactions[faction] == nil then
        self:log("WARNING: get faction move called for a faction that isn't moved!")
        --return the faction itself. It hasn't moved, so this works!
        return faction
    end
    return self._movedFactions[faction]
end

--moves a faction to another (when the AI confederates).
--moves all factions moved into this faction into the new one
--v function(self: LLR_MANAGER, moving_faction: string, confederation: string)
function llr_manager.move_faction(self, moving_faction, confederation)
    --set them moved. This will persist the move through saves.
    self._movedFactions[moving_faction] = confederation
    --dump their lords into the other faction
    local lords = self:get_lords_for_faction(moving_faction)
    for i = 1, #lords do
        self:add_lord_to_faction(confederation, lords[i])
        lords[i]:set_faction(confederation)
    end
    --clean up their lord table.
    self:clear_and_stop_tracking(moving_faction)
    --other factions might be moved to this faction, which could cause nil reference.
    --find any cases of this and move them too
    for faction, location in pairs(self:moved_factions()) do
        if location == moving_faction then
            self._movedFactions[faction] = confederation
        end
    end
    self:log("Moving faction ["..moving_faction.."] to ["..confederation.."] ")
end

--add a lord to the model
--public function
--v function(self: LLR_MANAGER, faction: string, subtype: string, forename: string, surname: string) --> LLR_LORD
function llr_manager.add_lord(self, faction, subtype, forename, surname)

    if not (is_string(faction) and is_string(subtype) and is_string(forename) and is_string(surname)) then
        self:log("ERROR CREATING LORD: the provided information must all be in string format!")
        return llr_lord.null_interface()
    end
    self:log("Adding a lord with subtype ["..subtype.."] to faction ["..faction.."] ")

    local true_faction = faction
    if self:is_faction_moved(faction) then
        true_faction = self:get_faction_move(faction)
        self:log("Lord was moved to ["..true_faction.."]")
    end
    local new_lord = llr_lord.new(self, faction, subtype, forename, surname)
    self:add_lord_to_faction(true_faction, new_lord)
    return new_lord
end

--v function (self: LLR_MANAGER, faction: string, subtype: string) --> LLR_LORD
function llr_manager.get_lord(self, faction, subtype)
    local lords = self._lords[faction]
    for i = 1, #lords do
        local lord = lords[i]
        if lord:subtype() == subtype then
            return lord
        end
    end
    self:log("COULD NOT FIND REQUESTED LORD!")
    return llr_lord.null_interface()
end








--initialize
llr_manager.init()
 --save necessary data from the model
cm:add_saving_game_callback(
    function(context)
        local llr_records = _G.llr:save()
        cm:save_named_value("llr_records", llr_records, context)
    end
)
--load necessary data back into the model
cm:add_loading_game_callback(
    function(context)
        llr_records = cm:load_named_value("llr_records", {}, context)
        _G.llr:load(llr_records)
    end
)
















