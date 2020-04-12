-- Small LibSnippet for Formation Mode changes
if not LibFormationMode then LibFormationMode = {} end
local Addon = LibFormationMode

local PartyUtils = PartyUtils
local Player = GameData.Player
local ipairs = ipairs

Addon.FormationModes = {
	["Solo"] = 0,
	["Party"] = 1,
	["Warband"] = 2,
	["Scenario"] = 3
}

local currentMode = 0
function Addon.GetFormationMode()
	return currentMode
end

--------------------------------------------------------------------------------
--								Event System								  --
--------------------------------------------------------------------------------
Addon.Events = 
{
	FORMATION_MODE_CHANGED = 1,
	SCENARIO_MODE_CHANGED = 2,
}

local EventCallbacks = {}
local function BroadcastLibFormationEvent(Event, arg)
	--DEBUG(L"Brodcasting Member"..towstring(index))
	-- First step: broadcast events to its handlers
	if EventCallbacks[Event] == nil then return end
	
	for _, callbck in ipairs(EventCallbacks[Event]) do
		callbck.Func(callbck.Owner, arg)
	end
end

--- Register for a LibFormationMode event
-- @param Event 
-- @param CallbackOwner an arbitrary object actually
-- @param CallbackFunction the event handler to call
function Addon.RegisterEventHandler(Event, CallbackOwner, CallbackFunction)
	Addon.Initialize()
	
	-- First step: initialize event base if needed
	if EventCallbacks[Event] == nil then
		EventCallbacks[Event] = {}
	end

	-- Second step: insert new event handler
	table.insert(EventCallbacks[Event], {Owner = CallbackOwner, Func = CallbackFunction})
end

--- Unregister a LibFormationMode event
-- @param Event
-- @param CallbackOwner an arbitrary object actually
-- @param CallbackFunction the event handler to call
function Addon.UnregisterEventHandler(Event, CallbackOwner, CallbackFunction)

	-- First step: find and remove event handler
	for k, callbck in ipairs(EventCallbacks[Event]) do
		if callbck.Owner == CallbackOwner and callbck.Func == CallbackFunction then
			table.remove(EventCallbacks[Event], k)
		end
	end
end

--------------------------------------------------------------------------------
--								Addon Code									  --
--------------------------------------------------------------------------------
--Addon.IsInitialized = false
function Addon.Initialize()
	
	--if Addon.IsInitialized then return end
	currentMode = Addon.FormationModes.Solo
	RegisterEventHandler(SystemData.Events.LOADING_END, "LibFormationMode.OnLoadingEnd")
	RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, "LibFormationMode.ChangeMode")
	
	RegisterEventHandler(SystemData.Events.GROUP_UPDATED, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.SCENARIO_BEGIN, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.SCENARIO_END, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.CITY_SCENARIO_BEGIN, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.CITY_SCENARIO_END, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.SCENARIO_GROUP_JOIN, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.SCENARIO_GROUP_LEAVE, "LibFormationMode.ChangeMode")
	RegisterEventHandler(SystemData.Events.BATTLEGROUP_UPDATED, "LibFormationMode.ChangeMode")
	
	RegisterEventHandler(SystemData.Events.SCENARIO_POST_MODE, "LibFormationMode.OnScenarioPostMode")

	--Addon.IsInitialized = true
end

--[[(Effigy):  UpdatePartyMember: 2 Crepe
(Effigy):  Party WorldObjUpdate for Crayzi
(Effigy):  UpdatePartyMember: 4 Crayzi
(Effigy):  Party WorldObjUpdate for Doobysnacks
(Effigy):  UpdatePartyMember: 3 Doobysnacks
(Effigy):  UpdatePartyMember: nil on 1
(Effigy):  UpdatePartyMember: nil on 4
(Effigy):  UpdatePartyMember: nil on 2
(Effigy):  UpdatePartyMember: nil on 3
(Effigy):  Formation Mode Changed: 1
(Effigy):  UpdatePartyMember: 2 Crepe
(Effigy):  UpdatePartyMember: 2 Crepe
(Effigy):  UpdatePartyMember: 3 Crayzi
(Effigy):  UpdatePartyMember: 2 Crepe
(Effigy):  UpdatePartyMember: 3 Crayzi
(Effigy):  UpdatePartyMember: 2 Crayzi
(Effigy):  UpdatePartyMember: nil on 2
(Effigy):  UpdatePartyMember: nil on 1
(Effigy):  Formation Mode Changed: 0
(Effigy):  Formation Mode Changed: 1
(Effigy):  UpdatePartyMember: 2 Crayzi
(Effigy):  UpdatePartyMember: 2 Crayzi
(EA_ZoneControlWindow):  Error in function call 'GetCampaignZoneData': Zone 31 is not a valid campaign zone.
(Effigy):  UpdatePartyMember: nil on 1
(Effigy):  Formation Mode Changed: 0
(Effigy):  OnLoad...]]--
local fixScenario = false
function LibFormationMode.OnLoadingEnd()
	fixScenario = false
	Addon.ChangeMode()
end

function Addon.ChangeMode()
	-- as it happens... it´s possible to have GameData.Player.isInScenario == false and IsPartyActive == true at the end of scenarios -.- therefor
	if fixScenario then return end 
	if Player.isInSiege or Player.isInScenario then
		if currentMode ~= Addon.FormationModes.Scenario then
			currentMode = Addon.FormationModes.Scenario
			BroadcastLibFormationEvent(Addon.Events.FORMATION_MODE_CHANGED, currentMode)
			if GameData.ScenarioData.mode == GameData.ScenarioMode.PRE_MODE then
				BroadcastLibFormationEvent(Addon.Events.SCENARIO_MODE_CHANGED, GameData.ScenarioMode.PRE_MODE)
			elseif GameData.ScenarioData.mode == GameData.ScenarioMode.RUNNING then
				BroadcastLibFormationEvent(Addon.Events.SCENARIO_MODE_CHANGED, GameData.ScenarioMode.RUNNING)
			elseif GameData.ScenarioData.mode == GameData.ScenarioMode.POST_MODE then
				BroadcastLibFormationEvent(Addon.Events.SCENARIO_MODE_CHANGED, GameData.ScenarioMode.POST_MODE)
			elseif GameData.ScenarioData.mode == GameData.ScenarioMode.ENDED then
				BroadcastLibFormationEvent(Addon.Events.SCENARIO_MODE_CHANGED, GameData.ScenarioMode.ENDED)
				DEBUG(L"ENDED")
			end
		end
	elseif IsWarBandActive() then
		if currentMode ~= Addon.FormationModes.Warband then
			currentMode = Addon.FormationModes.Warband
			BroadcastLibFormationEvent(Addon.Events.FORMATION_MODE_CHANGED, currentMode)
		end
	elseif PartyUtils.IsPartyActive() then
		if currentMode ~= Addon.FormationModes.Party then
			currentMode = Addon.FormationModes.Party
			BroadcastLibFormationEvent(Addon.Events.FORMATION_MODE_CHANGED, currentMode)
		end
	else
		if currentMode ~= Addon.FormationModes.Solo then
			currentMode = Addon.FormationModes.Solo
			BroadcastLibFormationEvent(Addon.Events.FORMATION_MODE_CHANGED, currentMode)
		end
	end
end

function Addon.OnScenarioPostMode()
	fixScenario = true
	BroadcastLibFormationEvent(Addon.Events.SCENARIO_MODE_CHANGED, GameData.ScenarioMode.POST_MODE)
	--DEBUG(L"POST_MODE")
end
