if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

--local partyNames = {}

local ipairs = ipairs
local table_insert = table.insert
local table_remove = table.remove

local playersName
local function GetPlayersName()
	if (playersName == nil) then
	    playersName = GameData.Player.name--:match(L"([^^]+)^?([^^]*)");
	end
	return playersName
end

function Addon.RegisterStateInfoForGroup()
	
	for i=1,6 do
		local grphp = EffigyState:new("grp"..i.."hp")
		--grphp:updateFunction(Addon.UpdateGroupInfo)
		grphp:SetMax(100)
		--EffigyBuffs.RegisterStateForEffect(Addon.States["grp"..i.."hp"],"GRP"..i)
		local grpap = EffigyState:new("grp"..i.."ap")
		grpap:SetMax(100)
		local grpmoral = EffigyState:new("grp"..i.."morale")
		grpmoral:SetMax(4)
	end
	LibUnits.RegisterEventHandler(LibUnits.Events.PARTY_MEMBER_UPDATED, nil, Addon.UpdatePartyMember)
	LibUnits.RegisterEventHandler(LibUnits.Events.FORMATION_MODE_CHANGED, nil, Addon.UpdateFormationModeP)
	--LibUnits.RegisterEventHandler(LibUnits.Events.FORMATION_UPDATE_IN_PROGRESS, nil, Addon.OnFormationUpdateInProgressP)
	--DEBUG(L"Group State registerd")				
end

local currentMode = LibFormationMode.FormationModes.Solo
function Addon.UpdateFormationModeP(_, newMode)
	if newMode ~= currentMode then
		for i = 2,6 do
			local rawname = EffigyState:GetState("grp"..i.."hp"):GetRawTitle()
			if LibRange and rawname and rawname ~= L"" then
				LibRange.UnregisterEventHandler("formation", Addon.OnRangeUpdated_FormationCallback, Addon.Name, rawname)
			end
		end
		if newMode == LibFormationMode.FormationModes.Solo then

			EffigyState:GetState("PlayerHP"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("PlayerAP"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("PlayerCareer"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("PlayerLevel"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("PlayerRenown"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("PlayerRR"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("Name"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("Exp"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("RestedExp"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("Influence"):SetExtraInfo("isGroup", false)
			EffigyState:GetState("Title"):SetExtraInfo("isGroup", false)
		
			Addon.GroupSetValid(0)
		else
			if oldMode == LibFormationMode.FormationModes.Solo then
				EffigyState:GetState("PlayerHP"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("PlayerAP"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("PlayerCareer"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("PlayerLevel"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("PlayerRenown"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("PlayerRR"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("Name"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("Exp"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("RestedExp"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("Influence"):SetExtraInfo("isGroup", true)
				EffigyState:GetState("Title"):SetExtraInfo("isGroup", true)
				
			end
			--[[if newMode == LibFormationMode.FormationModes.Party then
				--Addon.GroupSetValid(1)
			elseif newMode == LibFormationMode.FormationModes.Warband then
				if (Addon.WindowSettings["WB"].showgroup ~= true) then
					Addon.GroupSetValid(0)
				else
					--Addon.GroupSetValid(1)
				end
			elseif newMode == LibFormationMode.FormationModes.Scenario then
				if (Addon.WindowSettings["SC"].showgroup ~= true) then
					Addon.GroupSetValid(0)
				else
					--Addon.GroupSetValid(1)
				end
			end]]--
		end
		currentMode = newMode
	end
end

-- Update a single members information
-- i = 1..5, the member index number
function Addon.UpdatePartyMember(_, i, unit, unitLeftName)
	if not unit then
		--DEBUG(L"UpdatePartyMember: nil on "..i)
		Addon.GroupMemberSetValid(i, 0)
		if LibRange and unitLeftName then LibRange.UnregisterEventHandler("formation", Addon.OnRangeUpdated_FormationCallback, Addon.Name, unitLeftName) end
		return
	end
	--DEBUG(L"UpdatePartyMember: "..i..L" "..unit.name)
	local hp_state = EffigyState:GetState("grp"..i.."hp")
	local ap_state = EffigyState:GetState("grp"..i.."ap")
	local moral_state = EffigyState:GetState("grp"..i.."morale")

	local full = false
	local states = {hp_state, ap_state, moral_state}
	if hp_state:GetRawTitle() ~= unit.name then --stuff that only changes on member change
		local rawname = unit.name
		if LibRange and rawname ~= GetPlayersName() then
			LibRange.RegisterEventHandler("formation", Addon.OnRangeUpdated_FormationCallback, Addon.Name, rawname)
		else
			hp_state:SetExtraInfo("RangeMin", 0)
			hp_state:SetExtraInfo("RangeMax", 0)
			-- technically we would need to add ap and moral states; maybe they should become "secondary" states somewhat...
		end
		
		if (((currentMode == LibFormationMode.FormationModes.Warband) and (Addon.WindowSettings["WB"].showgroup ~= true))
		or ((currentMode == LibFormationMode.FormationModes.Scenario) and (Addon.WindowSettings["SC"].showgroup ~= true))) then
			return
		end
		
		for _, state in ipairs(states) do
			--[[if (state.word ~= unit.name) then
				state.valid = 0 -- so we reset the ActionData
			end]]--
			state:SetRawTitle(rawname)
			
			--state.careerName = unit.careerName
			state:SetExtraInfo("career",unit.careerLine)
			--state:SetExtraInfo("isPlayer",true)
			--state:SetExtraInfo("isFriendly",true)
			state:SetExtraInfo("isGroup",true)

			for _,v in ipairs(state.bars) do
				--local bar = Addon.Bars[v]
				if (nil ~= v) then
					WindowSetGameActionData(v.name, GameData.PlayerActions.SET_TARGET, 0, rawname)
				end
			end

			state:SetValid(1)
		end
		full = true
	end
	
	-- let´s *assume* hp, ap and morale update often enough to not need a flag on these
	for _, state in ipairs(states) do -- stuff that often changes
		state:SetEntityID(unit.worldObjNum)
		--state:SetLevel(unit.level)
		state:SetExtraInfo("rvr_flagged",unit.isRVRFlagged)
		--state:SetExtraInfo("isInSameRegion",unit.isInSameRegion)
		--state:SetExtraInfo("isDistant", unit.isDistant)
		--[[if not unit.isInSameRegion then
			state:SetExtraInfo("RangeMax", LibRange.TargetRange.MAX_RANGE +2)
		elseif unit.isDistant then
			state:SetExtraInfo("RangeMax", LibRange.TargetRange.MAX_RANGE +1)
		end]]--
		
		state:SetUnit(unit)
	end
	
	--if full or (hp_state:GetValue() ~= unit.healthPercent) then
		hp_state:SetValue(unit.healthPercent)
	--end
	--if full or (ap_state:GetValue() ~= unit.actionPointPercent) then
		ap_state:SetValue(unit.actionPointPercent)
	--end
	if full or ((not Addon.InWarband) and (moral_state:GetValue() ~= unit.moraleLevel)) then -- hm, need to look at this InWarband thing..
		if (unit.moraleLevel) then
			moral_state:SetValue(unit.moraleLevel)
			moral_state:SetValid(1)
		else
			moral_state:SetValue(0)
			moral_state:SetValid(0)
		end
	end
	hp_state:render()
	ap_state:render()
	moral_state:render()
end

function Addon.GroupSetValid(arg)
	if (arg ~= Addon.States["grp1hp"].valid) then --just do if necessary
		for memberIndex = 1,6 do
			Addon.GroupMemberSetValid(memberIndex, arg)
		end
	end
end

function Addon.GroupMemberSetValid(memberIndex, arg)
	if (arg ~= Addon.States["grp"..memberIndex.."hp"].valid) then --just do if necessary
		-- clear old data
		local hp_state = EffigyState:GetState("grp"..memberIndex.."hp")
		local ap_state = EffigyState:GetState("grp"..memberIndex.."ap")
		local moral_state = EffigyState:GetState("grp"..memberIndex.."morale")
		
		if (not arg) or arg == 0 then hp_state:SetRawTitle(L"") end
		
		hp_state:SetValid(arg)
		ap_state:SetValid(arg)
		moral_state:SetValid(arg)
					
		hp_state:render()
		ap_state:render()
		moral_state:render()
	end
end
