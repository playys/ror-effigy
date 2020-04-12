if not Effigy then Effigy = {} end

-- Make addon table ref local for performance
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

local currentMode = LibFormationMode.FormationModes.Solo

local playersGroupIndex = -1
local playersName
local function GetPlayersName()
	if (playersName == nil) then
	    playersName = GameData.Player.name--:match(L"([^^]+)^?([^^]*)");
	end
	return playersName
end

function Addon.RegisterStateInfoForFormation()
	
	-- Fake Master State
	--[[Addon.States["Formation"] = EffigyState:new("Formation")
	Addon.States["Formation"].valid = 0]]--
	-- Child States
	for i= 1, 6 do
		for j = 1, 6 do
			local state = EffigyState:new("formation"..i..j.."hp")
			state:SetMax(100)
		end
	end
	LibUnits.RegisterEventHandler(LibUnits.Events.FORMATION_PLAYER_GROUP_INDEX_CHANGED, nil, Addon.UpdatePlayersGroupIndex)
end

local isRegistered = false
function Addon.RegisterEventsForFormation()
	if not isRegistered then
		LibUnits.RegisterEventHandler(LibUnits.Events.FORMATION_MODE_CHANGED, nil, Addon.OnFormationModeChanged)
		LibUnits.RegisterEventHandler(LibUnits.Events.FORMATION_MEMBER_UPDATED, nil, Addon.UpdateFormationMember)
		isRegistered = true
	end
end

function Addon.UnregisterEventsForFormation()
	if isRegistered then
		LibUnits.UnregisterEventHandler(LibUnits.Events.FORMATION_MODE_CHANGED, nil, Addon.OnFormationModeChanged)
		LibUnits.UnregisterEventHandler(LibUnits.Events.FORMATION_MEMBER_UPDATED, nil, Addon.UpdateFormationMember)
		isRegistered = false
	end
end

function Addon.OnFormationModeChanged(_, newMode)
	currentMode = newMode
	for i= 1,5 do
		for j= 1, 6 do
			Addon.FormationMemberSetValid(i,j,0)
			local rawname = EffigyState:GetState("formation"..i..j.."hp"):GetRawTitle()
			if LibRange and rawname and rawname ~= L"" then
				LibRange.UnregisterEventHandler("formation", Addon.OnRangeUpdated_FormationCallback, Addon.Name, rawname)
			end
		end
	end
end

function Addon.UpdateFormationMember(_, groupIndex, slot, memberData, unitLeftName)

	-- let´s try this..
	if groupIndex == 0 then return end
	
	if not memberData then
		-- invalidate
		EffigyState:GetState("formation"..groupIndex..slot.."hp"):SetRawTitle(L"")
		Addon.FormationMemberSetValid(groupIndex, slot, 0)
		--DEBUG(L"Received FormationMember: Invalidate GroupIndex "..towstring(groupIndex)..L", slot "..towstring(slot))
		if (unitLeftName and LibRange) then LibRange.UnregisterEventHandler("formation", Addon.OnRangeUpdated_FormationCallback, Addon.Name, unitLeftName) end
		return
	end
	--DEBUG(L"Received FormationMember "..memberData.name..L" at GroupIndex "..towstring(groupIndex)..L", slot "..towstring(slot))
	local hp_state = EffigyState:GetState("formation"..groupIndex..slot.."hp")
	
	if memberData.name ~= hp_state:GetRawTitle() then
		local rawname = memberData.name
		
		for _,v in ipairs(hp_state.bars) do
			if (nil ~= v) then
				WindowSetGameActionData(v.name, GameData.PlayerActions.SET_TARGET, 0, rawname)
			end
		end

		--hp_state.careerName = memberData.careerName		-- todo: recherche the career chaos, thanks mythic
		hp_state:SetExtraInfo("career", memberData.careerLine)
		hp_state:SetRawTitle(rawname)

		if rawname == GetPlayersName() then
			hp_state:SetExtraInfo("RangeMin", 0)
			hp_state:SetExtraInfo("RangeMax", 0)
		elseif LibRange then
			LibRange.RegisterEventHandler("formation", Addon.OnRangeUpdated_FormationCallback, Addon.Name, rawname)
		end
	end
	
	hp_state:SetValue(memberData.healthPercent)
	--hp_state:SetLevel(memberData.level)

	hp_state:SetUnit(memberData)
	
	hp_state:SetValid(1)
	hp_state:render()
end

function Addon.UpdatePlayersGroupIndex(_, newPlayersGroupIndex)
	playersGroupIndex = newPlayersGroupIndex
	--[[for slot = 1,6 do
		Addon.FormationMemberSetValid(LibUnits.Real2VirtualGroupIndex(groupIndex), slot, 0)
	end]]--
	--Addon.GroupSetValid(0)
	--DEBUG(L"New playersGroupIndex: "..towstring(playersGroupIndex))
end

function Addon.FormationMemberSetValid(groupIndex, slot, arg)
	local hp_state = EffigyState:GetState("formation"..groupIndex..slot.."hp")
	if (arg ~= hp_state:IsValid()) then --just do if necessary	
		hp_state:SetValid(arg)
		if (not arg) or arg == 0 then hp_state:SetRawTitle(L"") end
		--DEBUG(towstring("formation"..groupIndex..slot.."hp")..L": SetValid: "..towstring(arg))
		hp_state:render()
	end
end

--
-- Range related
--

local DISTANTRANGE = 250
local function updateDistance(state, distance)
	local range_max = LibRange.TargetRange.MAX_RANGE
	if distance > DISTANTRANGE then
		distance = range_max + 1
		-- need to change that when out of region comes someway?
		if state:GetExtraInfo("RangeMax") == distance then return end
	end
	--end
	--if state:GetExtraInfo("RangeMax") == distance then break end
	--DEBUG(towstring(state:GetTitle())..L": "..towstring(distance))
	state:SetExtraInfo("RangeMin", distance)
	state:SetExtraInfo("RangeMax", distance)
	
	state:render()	-- meh
end

function Addon.OnRangeUpdated_FormationCallback(_, rawname, distance)
	if playersGroupIndex == -1 then return end
	local unit = LibUnits.GetFormationUnitByName(rawname)
	if not unit then return end
	local groupIndex = unit.groupIndex
	
	if groupIndex == playersGroupIndex then
		local memberIndex = unit.memberIndex
		if (currentMode ~= LibFormationMode.FormationModes.Party and memberIndex < LibUnits.GetPlayersMemberIndex() )
		or (currentMode == LibFormationMode.FormationModes.Party) then
			memberIndex = memberIndex + 1
		end
		updateDistance(EffigyState:GetState("grp"..memberIndex.."hp"), distance)
		updateDistance(EffigyState:GetState("grp"..memberIndex.."ap"), distance)
		--updateDistance(EffigyState:GetState("grp"..memberIndex.."morale"), distance)
	else
		updateDistance(EffigyState:GetState("formation"..LibUnits.Real2VirtualGroupIndex(groupIndex)..unit.memberIndex.."hp"), distance)
	end
end