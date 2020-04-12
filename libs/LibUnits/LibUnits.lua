local MAJOR, MINOR = "LibUnits", 1

-- Party Member name is clean, scenario member name is raw; what. the. waffle.

if (LibUnits) and (LibUnits.Version and LibUnits.Version >= MINOR) then return end
LibUnits = {}
LibUnits.Version = MINOR
local Addon = LibUnits

local PartyUtils = PartyUtils
local Player = GameData.Player
local ScenarioData = GameData.ScenarioData
local ScenarioMode = GameData.ScenarioMode

local LibFormationMode = LibFormationMode

local next = next
local type = type
local pairs = pairs
local ipairs = ipairs
local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
local TargetInfo = TargetInfo
local TargetObjectType = SystemData.TargetObjectType

--
-- Event System
--
Addon.Events = 
{
	LIBUNITS_INITIALIZED  = 1,
	
	FORMATION_MODE_CHANGED = 2,
	FORMATION_PLAYER_GROUP_INDEX_CHANGED = 3,
	PARTY_MEMBER_UPDATED = 4,
	FORMATION_MEMBER_UPDATED = 5,
	FORMATION_UPDATE_IN_PROGRESS = 6,
	
	PLAYER_FRIENDLY_TARGET_UPDATED = 7,
	PLAYER_HOSTILE_TARGET_UPDATED = 8,
	PLAYER_MOUSEOVER_TARGET_UPDATED = 9,
}

local EventCallbacks = {}

local function BroadcastFinalEvent(Event,...)
	--DEBUG(L"Brodcasting Member"..towstring(index))
	-- First step: broadcast events to its handlers
	local events = EventCallbacks[Event]
	if events == nil then return end
	for _, callbck in ipairs(events) do
		callbck.Func(callbck.Owner,...)
	end
end

--- Register for a LibUnits event
-- @param Event 
-- @param CallbackOwner an arbitrary object actually
-- @param CallbackFunction the event handler to call
function Addon.RegisterEventHandler(Event, CallbackOwner, CallbackFunction)
	Addon.Initialize()
	--if Event == Addon.Events.LIBRANGE_PROXY and not LibRange then return nil end
	
	-- First step: initialize event base if needed
	if EventCallbacks[Event] == nil then
		EventCallbacks[Event] = {}
	end

	-- Second step: insert new event handler
	table_insert(EventCallbacks[Event], {Owner = CallbackOwner, Func = CallbackFunction})
end

--- Unregister a LibUnits event
-- @param Event
-- @param CallbackOwner an arbitrary object actually
-- @param CallbackFunction the event handler to call
function Addon.UnregisterEventHandler(Event, CallbackOwner, CallbackFunction)

	-- First step: find and remove event handler
	for k, callbck in ipairs(EventCallbacks[Event]) do
		if callbck.Owner == CallbackOwner and callbck.Func == CallbackFunction then
			table_remove(EventCallbacks[Event], k)
		end
	end
end



--
-- Util System
--

-- we can´t rely on group updates alone since they don´t get triggered by AP and Moral changes
--local PARTY_UPDATE_FREQ = 0.4
--local DISTANCE_UPDATE_FREQ = 0.3

local playersName = nil
local function GetPlayersName()
	if (playersName == nil) then
	    playersName = (GameData.Player.name)--:match(L"([^^]+)^?([^^]*)")
	end
	return playersName
end

local function isNameValid(name)
	return (name ~= nil and name ~= L"")
end


LibUnits.Units = {
	--["FT"] = L"",
	["selffriendlytarget"] = L"",
	--["HT"] = L"",
	["selfhostiletarget"] = L"",
	--["MO"] = L"",
	["mouseovertarget"] = L"",
	["Formation"] = {
		[1] = {[1] = L"", [2] = L"", [3] = L"", [4] = L"", [5] = L"", [6] = L""}, 
		[2] = {[1] = L"", [2] = L"", [3] = L"", [4] = L"", [5] = L"", [6] = L""},
		[3] = {[1] = L"", [2] = L"", [3] = L"", [4] = L"", [5] = L"", [6] = L""}, 
		[4] = {[1] = L"", [2] = L"", [3] = L"", [4] = L"", [5] = L"", [6] = L""},
		[5] = {[1] = L"", [2] = L"", [3] = L"", [4] = L"", [5] = L"", [6] = L""}, 
		[6] = {[1] = L"", [2] = L"", [3] = L"", [4] = L"", [5] = L"", [6] = L""},
	}
}
local unitNames = LibUnits.Units
local position2Name = unitNames.Formation

local playersGroupIndex = -1
local playersMemberIndex = -1
function Addon.GetPlayersGroupIndex() return playersGroupIndex end
function Addon.GetPlayersMemberIndex() return playersMemberIndex end

--[[Addon.FormationModes = {
	["Solo"] = 0,
	["Party"] = 1,
	["Warband"] = 2,
	["Scenario"] = 3
}
Addon.FormationMode = Addon.FormationModes.Solo]]--
local currentMode = LibFormationMode.FormationModes.Solo
function Addon.GetCurrentMode()
	return currentMode
end

local units = {}
units.formationCache = {}
local formationCache = units.formationCache
LibUnits.formationCache = units.formationCache
units.hostilePlayers = {}
units.friendlyPlayers = {}
local friendlyPlayerCache = units.friendlyPlayers
units.hostileNPCs = {}
units.friendlyNPCs = {}

function Addon.GetUnitByName(targetType, name)
	if targetType == TargetObjectType.ALLY_NON_PLAYER or targetType == TargetObjectType.STATIC then		-- investigate STATIC
		return units.friendlyNPCs[name]
	elseif targetType == TargetObjectType.ENEMY_NON_PLAYER or targetType == TargetObjectType.STATIC_ATTACKABLE then
		return units.hostileNPCs[name]
	elseif targetType == TargetObjectType.SELF or targetType == TargetObjectType.ALLY_PLAYER then
		return units.friendlyPlayers[name]
	elseif targetType == TargetObjectType.ENEMY_PLAYER then
		return units.hostilePlayers[name]
	end
end
function Addon.GetFormationUnitByName(name)
	return formationCache[name]
end

local groupMap = {[1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6}
local lastgroupMap = {[1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6}

function Addon.Real2VirtualGroupIndex(groupIndex) return groupMap[groupIndex] end
local function BroadcastMemberEvent(groupIndex, memberIndex, unit, playerLeftRawName)
	if groupIndex == playersGroupIndex then
		if memberIndex == playersMemberIndex then
			BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, 1, unit, playerLeftRawName)
		elseif memberIndex < playersMemberIndex then
			BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, memberIndex + 1, unit, playerLeftRawName)
		else
			BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, memberIndex, unit, playerLeftRawName)
		end
	else
		BroadcastFinalEvent(Addon.Events.FORMATION_MEMBER_UPDATED, groupMap[groupIndex], memberIndex, unit, playerLeftRawName)
	end
end

local function GetFormatedName(unit)
	local name=unit._formatedname
	if(not name)
	then
		name=unit.name:match(L"([^^]+)^?([^^]*)")
		unit._formatedname=name
	end
	return name
end

local function GetNewUnit()
	return {
		name = L"",
		careerName = L"",
		careerLine = 0,
		healthPercent = -1,
		actionPointPercent = -1,
		moraleLevel = -1,
		level = -1,
		battleLevel = -1,
		Pet = {healthPercent = -1},
		isRVRFlagged = false,
		zoneNum = -1,
		online = true,
		isDistant = false,
		worldObjNum = -1,
		isInSameRegion = true,
		isGroupLeader = false,
		isAssistant = false,
		isMainAssist = false,
		isMasterLooter = false,
		isSelf = false,
		--title = L"",	-- npcTitle
		npcTitle = L"",	-- npcTitle
		tier = -1,
		isNPC = false,
		isFriendly = true,
		mapPinType = -1,
		sigilEntryId = -1,
		conType = -1,
		relationshipColor = {},
		difficultyMask = -1,
		groupIndex = -1,
		memberIndex = -1,
		isSelfPet = false,	-- addition
		GetFormatedName = GetFormatedName,
	}
end


--
-- Targets
--
--[[ SystemData.TargetObjectType:
O.NONE = 0
O.STATIC_ATTACKABLE = 8
O.STATIC = 7
O.ENEMY_NON_PLAYER = 6
O.SELF = 1
O.ENEMY_PLAYER = 5
O.ALLY_PLAYER = 3
O.ALLY_NON_PLAYER = 4
]]--
-- the missing 2 is (Players?) Pet. 
local targetClassificationMap={	["selffriendlytarget"]=Addon.Events.PLAYER_FRIENDLY_TARGET_UPDATED,
								["selfhostiletarget"]=Addon.Events.PLAYER_HOSTILE_TARGET_UPDATED,
								["mouseovertarget"]=Addon.Events.PLAYER_MOUSEOVER_TARGET_UPDATED}

function Addon.OnPlayerTargetUpdated( targetClassification, newTargetWorldObjNum, targetType )
	
	-- get the old target first
	local oldTarget
	local oldTargetIdent = unitNames[targetClassification]
	local oldTargetIsPlayer = (type(oldTargetIdent) ~= "number")
	if ((oldTargetIsPlayer and oldTargetIdent ~= L"") or ((not oldTargetIsPlayer) and oldTargetIdent > 0)) then
		if targetClassification == "selffriendlytarget" then
			if oldTargetIsPlayer then
				oldTarget = friendlyPlayerCache[oldTargetIdent]
			else
				oldTarget = units.friendlyNPCs[oldTargetIdent]
			end	
		elseif targetClassification == "selfhostiletarget" then
			if oldTargetIsPlayer then
				oldTarget = units.hostilePlayers[oldTargetIdent]
			else
				oldTarget = units.hostileNPCs[oldTargetIdent]
			end	
		elseif targetClassification == "mouseovertarget" then
			if oldTargetIsPlayer then
				oldTarget = units.hostilePlayers[oldTargetIdent] or friendlyPlayerCache[oldTargetIdent]
			else
				oldTarget = units.hostileNPCs[oldTargetIdent] or units.friendlyNPCs[oldTargetIdent]
			end
		end
	end
	-- /get the old target first
	
	-- new Target is deselect
	if targetType == TargetObjectType.NONE then
		unitNames[targetClassification] = L""
		BroadcastFinalEvent(targetClassificationMap[targetClassification], nil)
		return
	end
	-- /new Target is deselect
	
	--
	-- /Old Target
	-- New Target
	--
	TargetInfo:UpdateFromClient()
	
	-- get the new Target off cache if possible
	local target
	local newTargetName
	-- NPCs
	if targetType == TargetObjectType.ALLY_NON_PLAYER or targetType == TargetObjectType.STATIC or targetType == 2 then		-- investigate STATIC
		target = units.friendlyNPCs[newTargetWorldObjNum]
		if not target then
			target = GetNewUnit()
			target.mapPinType = TargetInfo:UnitMapPinType(targetClassification)
			target.isFriendly = true
			target.isNPC = true
			target.isSelfPet = targetType == 2
			target.npcTitle = TargetInfo:UnitNPCTitle(targetClassification)
			units.friendlyNPCs[newTargetWorldObjNum] = target
		end
		unitNames[targetClassification] = newTargetWorldObjNum
	elseif targetType == TargetObjectType.ENEMY_NON_PLAYER or targetType == TargetObjectType.STATIC_ATTACKABLE then
		target = units.hostileNPCs[newTargetWorldObjNum]
		if not target then
			target = GetNewUnit()
			target.isFriendly = false
			target.mapPinType = TargetInfo:UnitMapPinType(targetClassification)
			target.sigilEntryId = TargetInfo:UnitSigilEntryId(targetClassification)
			target.isNPC = true
			target.npcTitle = TargetInfo:UnitNPCTitle(targetClassification)
			units.hostileNPCs[newTargetWorldObjNum] = target
		end
		unitNames[targetClassification] = newTargetWorldObjNum
	-- Players
	elseif targetType == TargetObjectType.SELF or targetType == TargetObjectType.ALLY_PLAYER then
		newTargetName = TargetInfo:UnitName(targetClassification)
		target = formationCache[newTargetName] or formationCache[newTargetName:match(L"([^^]+)^?([^^]*)")] or friendlyPlayerCache[newTargetName]
		if not target then
			target = GetNewUnit()
			target.isFriendly = true
			target.isNPC = false
			target.careerLine = TargetInfo:UnitCareer(targetClassification)
			target.careerName = TargetInfo:UnitCareerName(targetClassification)
			--target.isSelf = (targetType == TargetObjectType.SELF)
			friendlyPlayerCache[newTargetName] = target
		end
		target.battleLevel = TargetInfo:UnitBattleLevel(targetClassification)
		unitNames[targetClassification] = newTargetName
	elseif targetType == TargetObjectType.ENEMY_PLAYER then
		newTargetName = TargetInfo:UnitName(targetClassification)
		target = units.hostilePlayers[newTargetName]
		if not target then
			target = GetNewUnit()
			target.isFriendly = false
			target.sigilEntryId = TargetInfo:UnitSigilEntryId(targetClassification) -- don´t remember if it makes a difference somewhere
			target.isNPC = false
			target.careerLine = TargetInfo:UnitCareer(targetClassification)
			target.careerName = TargetInfo:UnitCareerName(targetClassification)
			
			units.hostilePlayers[newTargetName] = target
		end
		target.battleLevel = TargetInfo:UnitBattleLevel(targetClassification)
		unitNames[targetClassification] = newTargetName
	end
	-- /get the new Target off cache if possible

	-- non-cached target
	if target.name == L"" then
		-- fill it up		
		target.name = newTargetName or TargetInfo:UnitName(targetClassification)
	end
	target.tier = TargetInfo:UnitTier(targetClassification)
	target.type = targetType
	-- /non-cached target
	target.healthPercent = TargetInfo:UnitHealth (targetClassification)		-- Crestor: do we need to call this much ?, could we use TargetInfo.m_Units directly for some of it ?
	target.level = TargetInfo:UnitLevel (targetClassification)	
	target.conType = TargetInfo:UnitConType (targetClassification)
	target.isRVRFlagged = TargetInfo:UnitIsPvPFlagged (targetClassification)
	target.relationshipColor = TargetInfo:UnitRelationshipColor (targetClassification)
	target.difficultyMask = TargetInfo:UnitDifficultyMask (targetClassification)
	
	if targetClassification == "mouseovertarget" then
		if target.worldObjNum ~= newTargetWorldObjNum then
			target.worldObjNum = newTargetWorldObjNum
			if playersGroupIndex > 0 and target.groupIndex == playersGroupIndex and targetType == TargetObjectType.ALLY_PLAYER then
				if currentMode == LibFormationMode.FormationModes.Party then
					BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, (target.memberIndex +1), target)
				else
					BroadcastMemberEvent(playersGroupIndex, target.memberIndex, target)
				end
			end
		end
	elseif targetClassification == "selffriendlytarget" then
		if target.worldObjNum ~= newTargetWorldObjNum then
			target.worldObjNum = newTargetWorldObjNum
			if playersGroupIndex > 0 and target.groupIndex == playersGroupIndex and targetType == TargetObjectType.ALLY_PLAYER then
				if currentMode == LibFormationMode.FormationModes.Party then
					BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, (target.memberIndex +1), target)
				else
					BroadcastMemberEvent(playersGroupIndex, target.memberIndex, target)
				end
			end
		end
	else
		target.worldObjNum = newTargetWorldObjNum
	end

	BroadcastFinalEvent(targetClassificationMap[targetClassification],target)
end

function Addon.GetTargetName(targetClassification)
	return LibUnits.Units[targetClassification]
end

--
-- Party
--
local function UpdatePartyMember(memberIndex, memberData, isGroupUpdate)	
	if playersGroupIndex == -1 then return end
	local name = memberData.name
	
	-- Update..
	if currentMode == LibFormationMode.FormationModes.Party then
		local unit = formationCache[name]
		if not unit then
			unit = GetNewUnit() -- new member
			unit.name = name
			unit.careerName = memberData.careerName
			unit.careerLine = memberData.careerLine
			formationCache[name] = unit
		end
		
		-- updated in both single and party updates
		unit.healthPercent = memberData.healthPercent
		unit.actionPointPercent = memberData.actionPointPercent
		unit.moraleLevel = memberData.moraleLevel
		unit.level = memberData.level
		unit.battleLevel = memberData.battleLevel
		if memberData.Pet and not unit.Pet then unit.Pet = {} end
		unit.Pet.healthPercent = memberData.Pet.healthPercent	
		unit.isRVRFlagged = memberData.isRVRFlagged
		unit.zoneNum = memberData.zoneNum
		unit.online = memberData.online
		unit.isDistant = memberData.isDistant
		unit.worldObjNum = memberData.worldObjNum
		if isGroupUpdate then	-- single party member updates do not update those in PartyUtils
			unit.isInSameRegion = memberData.isInSameRegion -- not part of partyutils anymore?
			unit.isGroupLeader = memberData.isGroupLeader
			unit.isAssistant = memberData.isAssistant
			unit.isMainAssist = memberData.isMainAssist
			unit.isMasterLooter = memberData.isMasterLooter
			-- assuming we are good here
			unit.groupIndex = playersGroupIndex
			unit.memberIndex = memberIndex
		end
		position2Name[playersGroupIndex][memberIndex + 1] = name
		BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, memberIndex + 1, unit)
	elseif (currentMode == LibFormationMode.FormationModes.Scenario) then--and (unit) then--and (unit.memberIndex > 0) then --and (unit.worldObjNum ~= memberData.worldObjNum) then
		--d(L"Party Update for "..name)
		local unit
		if memberIndex < playersMemberIndex then
			unit = friendlyPlayerCache[position2Name[playersGroupIndex][memberIndex] ]
		else
			unit = friendlyPlayerCache[position2Name[playersGroupIndex][memberIndex + 1] ]
		end
		if not unit then return end
		-- safety net
		if unit:GetFormatedName() ~= name then		
			--DEBUG(L"Houston, we have a problem with: "..unit:GetFormatedName()..L" and "..name)
			for formationname, formationunit in pairs(formationCache) do
				if formationname:match(L"([^^]+)^?([^^]*)") == name then
					unit = formationunit
					--DEBUG(L"Formationname is raw, memberData name is clean")
					break
				end
			end
		end
		-- /safety net
		
		if (unit.worldObjNum ~= memberData.worldObjNum) then
			unit.worldObjNum = memberData.worldObjNum
			--EA_ChatWindow.Print(L"Party WorldObjUpdate for "..name)
			BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, memberIndex + 1, unit)
		end
	end
end

local partySize = 0		-- max:5
function Addon.UpdateParty()
	--if not PartyUtils.IsPartyActive() then return end -- we want party data in party, warband and sc
	if currentMode == LibFormationMode.FormationModes.Solo or currentMode == LibFormationMode.FormationModes.Warband then return end
	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, true)	-- we´ll see if this works fine with updates inside scs
	local groupData = PartyUtils.GetPartyData()	-- GetGroupData()
	local partyPosition2Name = position2Name[playersGroupIndex]
	
	for index = 1,5 do		
		if PartyUtils.IsPartyMemberValid(index) then
			UpdatePartyMember(index, groupData[index], true)
		else
			if currentMode == LibFormationMode.FormationModes.Party and partyPosition2Name[index + 1] ~= L"" then -- player just left
				local name = partyPosition2Name[index + 1]
				DEBUG(L"UpdateParty: "..name..L" left.")
				
				position2Name[playersGroupIndex][index + 1] = L""
				local stillInGroup = false
				for i = index, 2, -1 do
					if position2Name[playersGroupIndex][i] == name then
						stillInGroup = true
						break
					end
				end
				if stillInGroup then
					BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, index + 1, nil)
				else
					formationCache[name] = nil
					BroadcastFinalEvent(Addon.Events.PARTY_MEMBER_UPDATED, index + 1, nil, name)
				end
			end			
		end
	end
	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, false)
	--DEBUG(L"-------/UpdateParty")
end

function Addon.OnGroupStatusUpdated(index)
	--DEBUG(L"OnGroupStatusUpdated: "..towstring(index))
	UpdatePartyMember(index, PartyUtils.GetPartyMember(index), false)
end


--
-- WB & SC Shared Utility Functions
--
local function processFormationCache()
	for name, unit in pairs(formationCache) do
		if unit.needsUpdate == true then	-- send units that need updating
			--unit.isActive = nil
			unit.needsUpdate = nil
			local groupIndex = unit.groupIndex
			local memberIndex = unit.memberIndex
			if memberIndex == nil then DEBUG(L"memberIndex == nil in Units Updating") end
			if position2Name[groupIndex][memberIndex] ~= name then
				-- unit was created or moved there
				position2Name[groupIndex][memberIndex] = name
			end			
			--if name == GetPlayersName() then d(GetPlayersName(), groupIndex, memberIndex) end
			BroadcastMemberEvent(groupIndex, memberIndex, unit)
		elseif not unit.isActive then		-- clean inactive units
			-- kill unit and send nil
			local groupIndex = unit.groupIndex
			local memberIndex = unit.memberIndex
			if memberIndex == nil then
				DEBUG(L"memberIndex == nil in Clean Inactive Units for "..name)
			end			
			position2Name[groupIndex][memberIndex] = L""
			--unit.isActive = nil
			unit.groupIndex = -1
			unit.memberIndex = -1
			formationCache[name] = nil
			BroadcastMemberEvent(groupIndex, memberIndex, nil, name)
		else
			unit.isActive = nil
		end
	end
	
	-- clean leftovers
	for i = 1, 6 do
		local position2NameGroup = position2Name[i]
		for j = 1, 6 do
			local position2NamePlayerName = position2NameGroup[j]
			if position2NamePlayerName ~= L"" then
				local unit = formationCache[position2NamePlayerName]
				if i ~= unit.groupIndex or j ~= unit.memberIndex then
					position2Name[i][j] = L""
					BroadcastMemberEvent(i, j, nil)	-- no name since this cleans up only moved units
				end
			end
		end
	end

	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, false)
end

--
-- Warband
--
local function copySingleUpdateWarbandMemberTable(unit, memberData)
	-- those are updated within GetWarbandMember
	unit.healthPercent = memberData.healthPercent
	unit.actionPointPercent = memberData.actionPointPercent
	unit.moraleLevel = memberData.moraleLevel
	unit.level = memberData.level
	unit.battleLevel = memberData.battleLevel
	unit.isRVRFlagged = memberData.isRVRFlagged
	unit.zoneNum = memberData.zoneNum
	unit.online = memberData.online
	unit.isDistant = memberData.isDistant
	unit.worldObjNum = memberData.worldObjNum
end

local function copyWarbandMemberTable(unit, memberData)	
	copySingleUpdateWarbandMemberTable(unit, memberData)
	-- ToDo check if all those variables are actually present in warband tables
	--if memberData.Pet and not unit.Pet then unit.Pet = {} end
	--unit.Pet.healthPercent = memberData.Pet.healthPercent	
	unit.isInSameRegion = memberData.isInSameRegion -- not part of partyutils anymore?
	unit.isGroupLeader = memberData.isGroupLeader
	unit.isAssistant = memberData.isAssistant
	unit.isMainAssist = memberData.isMainAssist
	unit.isMasterLooter = memberData.isMasterLooter
end

function Addon.UpdateWarbandMember(groupIndex, memberIndex)
	if updateFlag or playersGroupIndex == -1 then return end
	local memberData = PartyUtils.GetWarbandMember(groupIndex, memberIndex)
	if not memberData then return end
	local name = memberData.name
	local unit = formationCache[name]
	if not unit then
		unit = friendlyPlayerCache[name]
		if not unit then
			unit = GetNewUnit()
			unit.name = name
			unit.type = TargetObjectType.ALLY_PLAYER
			unit.careerName = memberData.careerName
			unit.careerLine = memberData.careerLine
			friendlyPlayerCache[name] = unit
		end
		copyWarbandMemberTable(unit, memberData)
		unit.groupIndex = groupIndex
		unit.memberIndex = memberIndex
		position2Name[groupIndex][memberIndex] = name
		formationCache[name] = unit
	else
		if unit.groupIndex ~= groupIndex or unit.memberIndex ~= memberIndex then
			BroadcastMemberEvent(unit.groupIndex, unit.memberIndex, nil)
			unit.groupIndex = groupIndex
			unit.memberIndex = memberIndex
			position2Name[groupIndex][memberIndex] = name
		end
		copySingleUpdateWarbandMemberTable(unit, memberData)
	end
	
	BroadcastMemberEvent(groupIndex, memberIndex, unit)
end

function Addon.UpdateWarband()
	--DEBUG(L"DING")
	if not IsWarBandActive() then return end
	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, true)
	local warbandData = PartyUtils.GetWarbandData()
	
	-- set inactive
	--[[for _,unit in pairs(formationCache) do
		unit.isActive = false
	end]]--
	
	-- we need to know the playerGroup first
	-- thankfully, there´s a useful PartyUtils function for once :) although it´s named anti-standard
	local newPlayersGroupIndex = 0
	newPlayersGroupIndex, playersMemberIndex = PartyUtils.IsPlayerInWarband(GetPlayersName())
	if playersGroupIndex ~= newPlayersGroupIndex then
		playersGroupIndex = newPlayersGroupIndex
		BroadcastFinalEvent(Addon.Events.FORMATION_PLAYER_GROUP_INDEX_CHANGED, newPlayersGroupIndex)
	end
	
	-- we can create the map before the memberupdates
	--[[local moddedGroupIndex = 1
	for groupIndex = 4,1,-1 do
		if next(warbandData[groupIndex].players) ~= nil then -- or #?
			groupMap[groupIndex] = moddedGroupIndex
			moddedGroupIndex = moddedGroupIndex + 1
		else
			groupMap[groupIndex] = groupIndex
		end
	end]]--
	
	for groupIndex, groupData in ipairs( warbandData ) do
		for memberIndex, memberData in ipairs( groupData.players ) do
			if memberIndex == 1 then	-- alternative for next the table, hopefully the same
				
			end
			local name = memberData.name
			local unit = formationCache[name] or friendlyPlayerCache[name]
			if not unit then
				unit = GetNewUnit()
				unit.name = name
				unit.type = TargetObjectType.ALLY_PLAYER
				unit.careerName = memberData.careerName
				unit.careerLine = memberData.careerLine
				
				copyWarbandMemberTable(unit, memberData)
				unit.groupIndex = groupIndex
				unit.memberIndex = memberIndex
				position2Name[groupIndex][memberIndex] = name
				--unit.isActive = true
				unit.needsUpdate = true
				friendlyPlayerCache[name] = unit
				--formationCache[name] = unit
				if not formationCache[name] then
					formationCache[name] = unit
				end
				BroadcastMemberEvent(groupIndex, memberIndex, unit)
			elseif unit.healthPercent ~= memberData.healthPercent
					or unit.actionPointPercent ~= memberData.actionPointPercent
					or unit.moraleLevel ~= memberData.moraleLevel
					or unit.level ~= memberData.level
					or unit.battleLevel ~= memberData.battleLevel
					--unit.Pet.healthPercent = memberData.Pet.healthPercent	
					or unit.isRVRFlagged ~= memberData.isRVRFlagged
					or unit.zoneNum ~= memberData.zoneNum
					or unit.online ~= memberData.online
					or unit.isDistant ~= memberData.isDistant
					or unit.worldObjNum ~= memberData.worldObjNum
					or unit.isInSameRegion ~= memberData.isInSameRegion -- not part of partyutils anymore?
					or unit.isGroupLeader ~= memberData.isGroupLeader
					or unit.isAssistant ~= memberData.isAssistant
					or unit.isMainAssist ~= memberData.isMainAssist
					or unit.isMasterLooter ~= memberData.isMasterLooter 
					or unit.groupIndex ~= groupIndex
					or unit.memberIndex ~= memberIndex then
			
				copyWarbandMemberTable(unit, memberData)
				unit.groupIndex = groupIndex
				unit.memberIndex = memberIndex
				position2Name[groupIndex][memberIndex] = name
				--unit.isActive = true
				unit.needsUpdate = true
				if not formationCache[name] then
					formationCache[name] = unit
				end
				--BroadcastMemberEvent(groupIndex, memberIndex, unit)
			else
				unit.isActive = true
			end
		end
	end
	
	processFormationCache()
end

--[[function Addon.OnGroupLeave()
	if not IsWarBandActive() then return end -- unsure about the sequence of events...
	for groupIndex = 4, 1, -1 do
		for memberIndex = 1, 6 do
			if next(WarbandGroups[groupIndex].players[memberIndex]) ~= nil then
				WarbandGroups[groupIndex].players[memberIndex] = {}
				BroadcastFinalEvent(Addon.Events.FORMATION_MEMBER_UPDATED, groupIndex, memberIndex, nil)
			end
		end
	end
end]]--

--
-- Scenario
--
-- scenarios use different career ids
local ConvertCareerIDToLine = {
	[20] = GameData.CareerLine.IRON_BREAKER,
	[100] = GameData.CareerLine.SWORDMASTER,
	[64] = GameData.CareerLine.CHOSEN,
	[24] = GameData.CareerLine.BLACK_ORC,
	[60] = GameData.CareerLine.WITCH_HUNTER,
	[102] = GameData.CareerLine.WHITE_LION,
	[65] = GameData.CareerLine.MARAUDER,
	[105] = GameData.CareerLine.WITCH_ELF,
	[62] = GameData.CareerLine.BRIGHT_WIZARD,
	[67] = GameData.CareerLine.MAGUS,
	[107] = GameData.CareerLine.SORCERER,
	[23] = GameData.CareerLine.ENGINEER,
	[101] = GameData.CareerLine.SHADOW_WARRIOR,
	[27] = GameData.CareerLine.SQUIG_HERDER,
	[63] = GameData.CareerLine.WARRIOR_PRIEST,
	[106] = GameData.CareerLine.DISCIPLE,
	[103] = GameData.CareerLine.ARCHMAGE,
	[26] = GameData.CareerLine.SHAMAN,
	[22] = GameData.CareerLine.RUNE_PRIEST,
	[66] = GameData.CareerLine.ZEALOT,
	[104] = GameData.CareerLine.BLACKGUARD,
	[61] = GameData.CareerLine.KNIGHT,
	[21] = GameData.CareerLine.SLAYER,
	[25] = GameData.CareerLine.CHOPPA,
}

function Addon.OnScenarioGroupJoin( groupIndex )	-- seems to be always before the scenario group update where the change happens. except at the beginning, before autojoining a group
	--DEBUG(L"OnScenarioGroupJoin: "..groupIndex)

	-- kill the whole fragging thing atm for the effigy beta to be bearable
	for i = 1, 6 do
		local partyPosition2Name = position2Name[i]
		for j = 1, 6 do
			local rawname = partyPosition2Name[j]
			if rawname ~= L"" then				
				local unit = formationCache[rawname]
				unit.groupIndex = -1
				unit.memberIndex = -1
				partyPosition2Name[j] = L""
				formationCache[rawname] = nil
				BroadcastMemberEvent(i, j, nil)
			end
		end
	end
	
	-- kill formation group we´re joining to
	--[[local partyPosition2Name = position2Name[groupIndex]
	for i = 1, 6 do
		local rawname = partyPosition2Name[i]
		if rawname ~= L"" then
			formationCache[rawname] = nil
			local unit = friendlyPlayerCache[rawname]
			unit.groupIndex = -1
			unit.memberIndex = -1
			partyPosition2Name[i] = L""
			BroadcastMemberEvent(groupIndex, i, nil)
		end
	end]]--

	--playersGroupIndex = groupIndex
	--BroadcastFinalEvent(Addon.Events.FORMATION_PLAYER_GROUP_INDEX_CHANGED, groupIndex)
	Addon.FlagUpdate()
end

function Addon.OnScenarioGroupLeave()
	--DEBUG(L"OnScenarioGroupLeave")
	-- kill the whole fragging thing atm for the effigy beta to be bearable
	for i = 1, 6 do
		local partyPosition2Name = position2Name[i]
		for j = 1, 6 do
			local rawname = partyPosition2Name[j]
			if rawname ~= L"" then				
				local unit = formationCache[rawname]
				unit.groupIndex = -1
				unit.memberIndex = -1
				partyPosition2Name[j] = L""
				formationCache[rawname] = nil
				BroadcastMemberEvent(i, j, nil)
			end
		end
	end
	-- kill party; assuming this is called before UpdateScenarioGroups has new position TODO: check this
	--[[local partyPosition2Name = position2Name[playersGroupIndex]
	for i = 1, 6 do
		local rawname = partyPosition2Name[i]
		if rawname ~= L"" then
			formationCache[rawname] = nil
			local unit = friendlyPlayerCache[rawname]
			unit.groupIndex = -1
			unit.memberIndex = -1
			partyPosition2Name[i] = L""
			BroadcastMemberEvent(playersGroupIndex, i, nil)
		end
	end]]--
	--playersGroupIndex = 0
	--playersMemberIndex = 0
	--BroadcastFinalEvent(Addon.Events.FORMATION_PLAYER_GROUP_INDEX_CHANGED, 0)
	--Addon.UpdateMainAssist( nil, nil )
	Addon.FlagUpdate()
end

function Addon.UpdateScenarioGroups()
	--DEBUG(L"UpdateScenarioGroups")
	-- Sometimes the update message gets processed once more after a scenario ends
    if( not (Player.isInScenario or Player.isInSiege)) --[[or playersGroupIndex == -1]] then return end
	
	local scenarioData = GameData.GetScenarioPlayerGroups()
	if not scenarioData then return end
	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, true)

	-- set inactive
	--[[for _,unit in pairs(formationCache) do
		unit.isActive = false
	end]]--

	local isGroupActive = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false}
	for _, player in ipairs(scenarioData) do	
		
		local groupIndex = player.sgroupindex
		if groupIndex and groupIndex ~= 0 then
			local playerName = player.name
			if isNameValid(playerName) then
				isGroupActive[groupIndex] = true
				local groupSlotNum = player.sgroupslotnum
				--if groupSlotNum == nil then DEBUG(L"groupSlotNum == nil") end	-- shouldn´t happen since groupIndex == 0 is filtered already
				-- find player
				if playerName == GetPlayersName() then
					if playersGroupIndex ~= groupIndex then
						playersGroupIndex = groupIndex
						BroadcastFinalEvent(Addon.Events.FORMATION_PLAYER_GROUP_INDEX_CHANGED, groupIndex)
						--DEBUG(L"UpdateScenarioGroups playergroup changed: "..playersGroupIndex)
					end
					playersMemberIndex = groupSlotNum
				end
						
				if not friendlyPlayerCache[playerName] then --formationCache[playerName] then
					-- player joined
					local unit = GetNewUnit()
					unit.name = playerName
					unit.careerLine = ConvertCareerIDToLine[player.careerId]
					unit.careerName = player.career

					unit.actionPointPercent = player.ap
					unit.healthPercent = player.health
					unit.moraleLevel = player.morale
					unit.groupIndex = groupIndex
					unit.memberIndex = groupSlotNum
					--if unit.memberIndex == nil then DEBUG(L"newUnit memberIndex == nil") end
					--unit.isInPlayerGroup = (groupIndex == playersGroupIndex)
					unit.level = player.rank
					unit.isMainAssist = player.isMainAssist			

					--unit.isActive = true
					unit.needsUpdate = true
					
					friendlyPlayerCache[playerName] = unit
					formationCache[playerName] = unit	--formationCache[playerName] = friendlyPlayerCache[playerName]
				else
					-- is active
					if not formationCache[playerName] then formationCache[playerName] = friendlyPlayerCache[playerName] end
					local unit = formationCache[playerName]
					--unit.isActive = true
					
					if unit.actionPointPercent ~= player.ap or
							unit.healthPercent ~= player.health or
							unit.moraleLevel ~= player.morale or
							unit.groupIndex ~= groupIndex or
							unit.memberIndex ~= groupSlotNum or
							--unit.isInPlayerGroup ~= (groupIndex == playersGroupIndex) or
							unit.level ~= player.rank or
							unit.isMainAssist ~= player.isMainAssist then
						-- has changed
						unit.needsUpdate = true
						
						unit.actionPointPercent = player.ap
						unit.healthPercent = player.health
						unit.moraleLevel = player.morale				
						unit.groupIndex = groupIndex
						unit.memberIndex = groupSlotNum
						--if unit.memberIndex == nil then DEBUG(L"existing Unit memberIndex == nil") end
						--unit.isInPlayerGroup = (groupIndex == playersGroupIndex)
						unit.level = player.rank
						unit.isMainAssist = player.isMainAssist
					else
						unit.isActive = true
					end
				end
			end
		end
	end
	
	if playersGroupIndex == -1 then return end
	
	-- update groupMap
	--[[for i = 1,6 do
		lastgroupMap[i] = groupMap[i]
	end
	
	local moddedGroupIndex = 1
	for i = 1, 6 do
		if isGroupActive[i] and i ~= playersGroupIndex then
			groupMap[i] = moddedGroupIndex
			moddedGroupIndex = moddedGroupIndex + 1
		else
			groupMap[i] = i
		end
	end]]--

	processFormationCache()
end

function Addon.OnUpdatePlayerHits( groupIndex, groupSlotNum, hits )
	if updateFlag or groupIndex == 0 or playersGroupIndex == -1 then return end
	local unit = formationCache[position2Name[groupIndex][groupSlotNum] ]
	if unit == nil then
		DEBUG(L"OnUpdatePlayerHits unit == nil")
		return
	end	
	unit.healthPercent = hits
	
	BroadcastMemberEvent(groupIndex, groupSlotNum, unit)
end


---------------------------------------
-- Addon functions
---------------------------------------
Addon.IsInitialized = false
function Addon.Initialize()
	if Addon.IsInitialized then return end
	LibFormationMode.RegisterEventHandler(LibFormationMode.Events.FORMATION_MODE_CHANGED, nil, Addon.OnFormationModeChanged)
	
	RegisterEventHandler(SystemData.Events.PLAYER_TARGET_UPDATED, "LibUnits.OnPlayerTargetUpdated")
	RegisterEventHandler(SystemData.Events.LOADING_END, "LibUnits.OnLoad")
    --RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, "LibUnits.OnLoad")

	Addon.IsInitialized = true
end

function Addon.OnLoad()
	units.hostileNPCs = {}
	units.friendlyNPCs = {}
end

function Addon.Shutdown()
	if not Addon.IsInitialized then return end
	--LibFormationMode.UnregisterEventHandler(LibFormationMode.Events.FORMATION_MODE_CHANGED, nil, Addon.OnFormationModeChanged)
	UnregisterEventHandler(SystemData.Events.PLAYER_TARGET_UPDATED, "LibUnits.OnPlayerTargetUpdated")
	Addon.IsInitialized = false
end

local updateFlag = false
function Addon.FlagUpdate()
	updateFlag = true
	if LibRange then LibRange.PauseNextFrame() end
end

function Addon.OnUpdate()
	if updateFlag then
		if currentMode == LibFormationMode.FormationModes.Party then
			Addon.UpdateParty()
		elseif currentMode == LibFormationMode.FormationModes.Warband then
			Addon.UpdateWarband()
		elseif currentMode == LibFormationMode.FormationModes.Scenario then
			Addon.UpdateScenarioGroups()
		end		
		updateFlag = false
	end
end

function Addon.OnFormationModeChanged(_, newMode)
	DEBUG(L"Formation Mode Changed")
	-- reset Formation Map
	--[[for k, v in ipairs(position2Name) do
		for k2,_ in ipairs(v) do
			position2Name[k][k2] = L""
		end
	end]]--

	-- reset formation cache
	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, true)
	for _,unit in pairs(formationCache) do -- because units are in friendlyPlayerCache too
		--local unit = friendlyPlayerCache[rawname]
		--BroadcastMemberEvent(unit.groupIndex, unit.memberIndex, nil, unit.name)
		unit.groupIndex = -1
		unit.memberIndex = -1
	end
	formationCache = {}
	for i = 1, 6 do
		for j = 1, 6 do
			local name = LibUnits.Units.Formation[i][j]
			if name ~= L"" then
				LibUnits.Units.Formation[i][j] = L""
				--d(i,j,name)
				BroadcastMemberEvent(i, j, nil, name)
			else
				BroadcastMemberEvent(i, j, nil)
			end
		end
	end
	
	-- reset Group Map
	for k,_ in ipairs(groupMap) do
		groupMap[k] = k
	end
	playersGroupIndex = -1
	playersMemberIndex = -1
	
	BroadcastFinalEvent(Addon.Events.FORMATION_UPDATE_IN_PROGRESS, false)
	
	if (currentMode == LibFormationMode.FormationModes.Party or currentMode == LibFormationMode.FormationModes.Scenario)
	and (newMode == LibFormationMode.FormationModes.Warband or newMode == LibFormationMode.FormationModes.Solo) then
		UnregisterEventHandler(SystemData.Events.GROUP_UPDATED, "LibUnits.UpdateParty")
		UnregisterEventHandler(SystemData.Events.GROUP_STATUS_UPDATED, "LibUnits.OnGroupStatusUpdated")
		--UnregisterEventHandler(SystemData.Events.GROUP_PLAYER_ADDED, "LibUnits.UpdateParty")	-- TODO: recherche this further
	elseif (currentMode == LibFormationMode.FormationModes.Warband or currentMode == LibFormationMode.FormationModes.Solo)
	and (newMode == LibFormationMode.FormationModes.Party or newMode == LibFormationMode.FormationModes.Scenario) then
		RegisterEventHandler(SystemData.Events.GROUP_UPDATED, "LibUnits.UpdateParty")
		RegisterEventHandler(SystemData.Events.GROUP_STATUS_UPDATED, "LibUnits.OnGroupStatusUpdated")
		--RegisterEventHandler(SystemData.Events.GROUP_PLAYER_ADDED, "LibUnits.UpdateParty")	-- TODO: recherche this further
	end
	
	if currentMode == LibFormationMode.FormationModes.Warband then
		UnregisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "LibUnits.FlagUpdate")
		UnregisterEventHandler(SystemData.Events.BATTLEGROUP_MEMBER_UPDATED, "LibUnits.UpdateWarbandMember")
		--UnregisterEventHandler(SystemData.Events.GROUP_LEAVE, "LibUnits.OnGroupLeave")
	elseif currentMode == LibFormationMode.FormationModes.Scenario then
		-- Unregister Scenario Events
		UnregisterEventHandler(SystemData.Events.SCENARIO_PLAYERS_LIST_GROUPS_UPDATED, "LibUnits.FlagUpdate")
		UnregisterEventHandler(SystemData.Events.SCENARIO_PLAYERS_LIST_RESERVATIONS_UPDATED, "LibUnits.FlagUpdate")
		--UnregisterEventHandler(SystemData.Events.SCENARIO_BEGIN, "LibUnits.OnScenarioBegin")	-- unused
		--UnregisterEventHandler(SystemData.Events.CITY_SCENARIO_BEGIN, "LibUnits.OnScenarioBegin")
		--UnregisterEventHandler(SystemData.Events.SCENARIO_END, "LibUnits.OnScenarioEnd")
		--UnregisterEventHandler(SystemData.Events.CITY_SCENARIO_END, "LibUnits.OnScenarioEnd")
		
		UnregisterEventHandler(SystemData.Events.SCENARIO_GROUP_JOIN, "LibUnits.OnScenarioGroupJoin")	
		UnregisterEventHandler(SystemData.Events.SCENARIO_GROUP_LEAVE, "LibUnits.OnScenarioGroupLeave")
		--RegisterEventHandler(SystemData.Events.PLAYER_MAIN_ASSIST_UPDATED, "LibUnits.UpdateMainAssist")
		UnregisterEventHandler(SystemData.Events.SCENARIO_PLAYER_HITS_UPDATED, "LibUnits.OnUpdatePlayerHits")
	end
	
	if newMode == LibFormationMode.FormationModes.Party then
		playersGroupIndex = 1
		playersMemberIndex = 1
		--Addon.UpdateParty()
		Addon.FlagUpdate()
	elseif newMode == LibFormationMode.FormationModes.Warband then
		RegisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "LibUnits.FlagUpdate")
		RegisterEventHandler(SystemData.Events.BATTLEGROUP_MEMBER_UPDATED, "LibUnits.UpdateWarbandMember")
		--RegisterEventHandler(SystemData.Events.GROUP_LEAVE, "LibUnits.OnGroupLeave")
		Addon.FlagUpdate()
	elseif newMode == LibFormationMode.FormationModes.Scenario then
		-- Register Scenario Events
		RegisterEventHandler(SystemData.Events.SCENARIO_PLAYERS_LIST_GROUPS_UPDATED, "LibUnits.FlagUpdate")
		RegisterEventHandler(SystemData.Events.SCENARIO_PLAYERS_LIST_RESERVATIONS_UPDATED, "LibUnits.FlagUpdate")
		--RegisterEventHandler(SystemData.Events.SCENARIO_GROUP_UPDATED, "LibUnits.OnScenarioGroupUpdated")
		--RegisterEventHandler(SystemData.Events.SCENARIO_BEGIN, "LibUnits.OnScenarioBegin")	-- unused
		--RegisterEventHandler(SystemData.Events.CITY_SCENARIO_BEGIN, "LibUnits.OnScenarioBegin")
		--RegisterEventHandler(SystemData.Events.SCENARIO_END, "LibUnits.OnScenarioEnd")
		--RegisterEventHandler(SystemData.Events.CITY_SCENARIO_END, "LibUnits.OnScenarioEnd")
		
		RegisterEventHandler(SystemData.Events.SCENARIO_GROUP_JOIN, "LibUnits.OnScenarioGroupJoin")	
		RegisterEventHandler(SystemData.Events.SCENARIO_GROUP_LEAVE, "LibUnits.OnScenarioGroupLeave")
		--RegisterEventHandler(SystemData.Events.PLAYER_MAIN_ASSIST_UPDATED, "LibUnits.UpdateMainAssist")
		RegisterEventHandler(SystemData.Events.SCENARIO_PLAYER_HITS_UPDATED, "LibUnits.OnUpdatePlayerHits")
		
		Addon.FlagUpdate()
	end
	currentMode = newMode
	--DEBUG(L"Formation Mode Changed: "..newMode)
	BroadcastFinalEvent(Addon.Events.FORMATION_MODE_CHANGED, newMode)
end
