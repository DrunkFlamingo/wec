RECRUITMENT_CONTROLS_LOG = true --:boolean

--v function(text: string, ftext: string)
function RCLOG(text, ftext)
    --sometimes I use ftext as an arg of this function, but for simple mods like this one I don't need it.

    if not RECRUITMENT_CONTROLS_LOG then
      return; --if our bool isn't set true, we don't want to spam the end user with logs. 
    end

  local logText = tostring(text)
  local logContext = tostring(ftext)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("RCLOG.txt","a")
  --# assume logTimeStamp: string
  popLog :write("WEC:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
  popLog :flush()
  popLog :close()
end

function RCREFRESHLOG()
    if not RECRUITMENT_CONTROLS_LOG then
        return;
    end

    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string

    local popLog = io.open("RCLOG.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close()
end
RCREFRESHLOG()

--v function(msg: string)
function RCERROR(msg)
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
		local file = io.open("RCLOG.txt", "a");
		
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


local rc = require("recruitment_controls/recruiter_character")

local RecruiterManager = {} --# assume rm: RECRUITER_MANAGER

--v function() --> RECRUITER_MANAGER
function RecruiterManager.Init()
    local self = {}
    setmetatable(self, {
        __index = RecruiterManager,
        __tostring = function() return "RECRUITER_MANAGER" end
    })
    --# assume self: RECRUITER_MANAGER

    self.Characters = {} --:map<CA_CQI, RECRUITER_CHARACTER>
    self.CurrentlySelectedCharacter = nil --:RECRUITER_CHARACTER
    self.RegionRestrictions = {} --:map<string, map<string, boolean>>
    self.UnitQuantityRestrictions = {} --:map<string, number>


    RCLOG("Init Complete, adding the manager to the Gamespace!", "RecruiterManager.Init()")
    _G.rm = self
    return self
end

--v function(self: RECRUITER_MANAGER, cqi: CA_CQI)
function RecruiterManager.CreateCharacter(self, cqi)
    if not cm:get_character_by_cqi(cqi):has_military_force() then
        RCLOG("Selected  ["..tostring(cqi).."] does not have a military force, aborting ", "RecruiterManager.CreateCharacter(self, cqi)")
        return
    end
    RCLOG("Model calling for a new character with CQI ["..tostring(cqi).."]", "RecruiterManager.CreateCharacter(self, cqi)")
    local character = rc.Create(cqi)
    self.Characters[cqi] = character
    character:SetManager(self)
end

--v function(self: RECRUITER_MANAGER) --> map<CA_CQI, vector<string>>
function RecruiterManager.Save(self)
    local save_table = {} --:map<CA_CQI, vector<string>>
    for k, v in pairs(self.Characters) do
        if v:IsQueueEmpty() == false then
            cqi, queuetable = v:Save()
            save_table[cqi] = queuetable
        end
    end

    return save_table
end

--v function(self: RECRUITER_MANAGER, save_table: map<CA_CQI, vector<string>>)
function RecruiterManager.Load(self, save_table)
    for k, v in pairs(save_table) do
        local character = rc.Load(k, v)
        self.Characters[cqi] = character
        character:SetManager(self)
    end
end

--v function(self: RECRUITER_MANAGER, unit_key: string, region_key: string)
function RecruiterManager.AddRegionRestrictionToUnit(self, unit_key, region_key)
    self.RegionRestrictions[region_key][unit_key] = true
end

--v function(self: RECRUITER_MANAGER, unit_key: string, region_key: string)
function RecruiterManager.RemoveRegionRestriction(self, unit_key, region_key)
    self.RegionRestrictions[region_key][unit_key] = false
end

--v function(self: RECRUITER_MANAGER, unit_key: string, region_key: string) --> boolean
function RecruiterManager.GetIsRegionRestricted(self, unit_key, region_key)
    return self.RegionRestrictions[region_key][unit_key]
end

--v function(self: RECRUITER_MANAGER, unit_key: string, count: number) 
function RecruiterManager.SetUnitQuantityRestriction(self, unit_key, count)
    self.UnitQuantityRestrictions[unit_key] = count
end

--v function(self: RECRUITER_MANAGER, unit_key: string)
function RecruiterManager.RemoveUnitQuantityRestriction(self, unit_key)
    self.UnitQuantityRestrictions[unit_key] = nil
end

--v function(self: RECRUITER_MANAGER, unit_key: string) --> number
function RecruiterManager.GetUnitQuantityRestriction(self, unit_key)
    return self.UnitQuantityRestrictions[unit_key]
end

--v function(self: RECRUITER_MANAGER, cqi: CA_CQI)
function RecruiterManager.SetCurrentlySelectedCharacter(self, cqi)
    self.CurrentlySelectedCharacter = self.Characters[cqi]
end

--v function(self: RECRUITER_MANAGER) --> RECRUITER_CHARACTER
function RecruiterManager.GetCurrentlySelectedCharacter(self)
    return self.CurrentlySelectedCharacter
end

--v function(self: RECRUITER_MANAGER)
function RecruiterManager.EvaluateAllRestrictions(self)


end

--v function(self: RECRUITER_MANAGER, unit_component_ID: string)
function RecruiterManager.EvaluateSingleUnitRestriction(self, unit_component_ID)


end


---Events


--v function(self: RECRUITER_MANAGER, cqi: CA_CQI)
function RecruiterManager.OnCharacterFinishedMoving(self, cqi)

end

--v function(self: RECRUITER_MANAGER, cqi: CA_CQI)
function RecruiterManager.OnCharacterSelected(self, cqi)

end

--v function(self: RECRUITER_MANAGER)
function RecruiterManager.OnRecruitmentPanelOpened(self)


end

--v function(self: RECRUITER_MANAGER, context: CA_UIContext)
function RecruiterManager.OnQueuedUnitClicked(self, context)

end

--v function(self: RECRUITER_MANAGER, context: CA_UIContext)
function RecruiterManager.OnRecruitableUnitClicked(self, context)

end



--listeners.

--v function(self: RECRUITER_MANAGER)
function RecruiterManager.Listen(self)







end





