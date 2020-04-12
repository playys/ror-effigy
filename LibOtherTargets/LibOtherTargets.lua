-- Targets

LibOtherTargets = {}
LibOtherTargets.VERSION = "0.75-beta"
LibOtherTargets.UPDATE_PERIOD = 1.6 --0.2

local LibUnits = LibUnits
local TargetObjectType = SystemData.TargetObjectType

local ipairs = ipairs

--------------------------------------------------------------------------------
--								Event System								  --
--------------------------------------------------------------------------------
local isFTEventRegistered = false
local isHTEventRegistered = false
local isMOEventRegistered = false

LibOtherTargets.Events =
{
	FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED	= 1,
	HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED		= 2,
}

local EventCallbacks = {}

local function BroadcastOtherTargetsEvent(Event, index, EventData)
	--DEBUG(L"Brodcasting Member"..towstring(index))
	-- First step: broadcast events to its handlers
	if EventCallbacks[Event] ~= nil then
		for _, callbck in ipairs(EventCallbacks[Event]) do
			callbck.Func(callbck.Owner, index, EventData)
		end
	end
end

--- Register for a LibOtherTargets event
-- @param Event 
-- @param CallbackOwner an arbitrary object actually
-- @param CallbackFunction the event handler to call
function LibOtherTargets.RegisterEventHandler(Event, CallbackOwner, CallbackFunction)

	-- First step: initialize event base if needed
	if EventCallbacks[Event] == nil then
		EventCallbacks[Event] = {}
		if LibUnits then
			if not isMOEventRegistered then
				LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_MOUSEOVER_TARGET_UPDATED, "mo", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
				isMOEventRegistered = true
			end
			if Event == LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED and not isFTEventRegistered then
				LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_FRIENDLY_TARGET_UPDATED, "ft", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
				isFTEventRegistered = true
			elseif Event == LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED and not isHTEventRegistered then
				LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_HOSTILE_TARGET_UPDATED, "ht", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
				isHTEventRegistered = true
			end
		else
			if not isMOEventRegistered then
				RegisterEventHandler(SystemData.Events.PLAYER_TARGET_UPDATED, "LibOtherTargets.on_target_updated")
				isMOEventRegistered = true
			end
		end
	end

	-- Second step: insert new event handler
	table.insert(EventCallbacks[Event], {Owner = CallbackOwner, Func = CallbackFunction})
end

--- Unregister a LibOtherTargets event
-- @param Event
-- @param CallbackOwner an arbitrary object actually
-- @param CallbackFunction the event handler to call
function LibOtherTargets.UnregisterEventHandler(Event, CallbackOwner, CallbackFunction)

	-- First step: find and remove event handler
	for k, callbck in ipairs(EventCallbacks[Event]) do
		if callbck.Owner == CallbackOwner and callbck.Func == CallbackFunction then
			table.remove(EventCallbacks[Event], k)
		end
	end
	
	if LibUnits and next(EventCallbacks[Event]) == nil then
		if Event == LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED then
			LibUnits.UnregisterEventHandler(LibUnits.Events.PLAYER_FRIENDLY_TARGET_UPDATED, "ft", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
			isFTEventRegistered = false
			if next(EventCallbacks[LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED]) == nil then
				LibUnits.UnregisterEventHandler(LibUnits.Events.PLAYER_MOUSEOVER_TARGET_UPDATED, "mo", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
				isMOEventRegistered = false
			end
		elseif Event == LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED and not isHTEventRegistered then
			LibUnits.UnregisterEventHandler(LibUnits.Events.PLAYER_HOSTILE_TARGET_UPDATED, "ht", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
			isHTEventRegistered = false
			if next(EventCallbacks[LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED]) == nil then
				LibUnits.UnregisterEventHandler(LibUnits.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED, "mo", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
				isMOEventRegistered = false
			end
		end
	end
end

--
-- Functions
--

function LibOtherTargets.Initialize()
	-- persistent data
	LibOtherTargets.saved = LibOtherTargets.saved or {}
	LibOtherTargets.saved.allies = LibOtherTargets.saved.allies or {}
	LibOtherTargets.saved.allies.filters = LibOtherTargets.saved.allies.filters or {}
	LibOtherTargets.saved.enemies = LibOtherTargets.saved.enemies or {}
	LibOtherTargets.saved.enemies.filters = LibOtherTargets.saved.enemies.filters or {}
	LibOtherTargets.saved.favorites = LibOtherTargets.saved.favorites or {}

	--LibUnits = LibUnits
	--[[if LibUnits then
		LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_FRIENDLY_TARGET_UPDATED, "ft", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
		LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_HOSTILE_TARGET_UPDATED, "ht", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
		LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_MOUSEOVER_TARGET_UPDATED, "mo", LibOtherTargets.OnLibUnitsPlayerTargetUpdated)
		DEBUG(L"Using LibUnits")
	else
		-- our main event
		RegisterEventHandler(SystemData.Events.PLAYER_TARGET_UPDATED, "LibOtherTargets.on_target_updated")
	end]]--
	
	LibOtherTargets.update_timeout = LibOtherTargets.UPDATE_PERIOD

	-- list of targets
	LibOtherTargets.targets = {}

	-- create friendly players
	LibOtherTargets.allies = LibOtherTargets.create_playerlist("Friendly", TargetObjectType.ALLY_PLAYER, LibOtherTargets.saved.allies.max_players)
	LibOtherTargets.allies.filters = {
		{ id = "keymod", desc = "Key modifier", f = LibOtherTargets.filter_key_modifier, enabled = false },
		{ id = "group", desc = "Group", f = LibOtherTargets.filter_group, enabled = true },
		{ id = "wb", desc = "Warband", f = LibOtherTargets.filter_warband, enabled = true },
		{ id = "sc", desc = "Scenario", f = LibOtherTargets.filter_scenario, enabled = true }
	}
	LibOtherTargets.allies.list.remove_full_hp = true
	LibOtherTargets.restore("allies")

	-- create enemy players
	LibOtherTargets.enemies = LibOtherTargets.create_playerlist("Enemy", TargetObjectType.ENEMY_PLAYER, LibOtherTargets.saved.enemies.max_players)
	LibOtherTargets.enemies.filters = {}
	LibOtherTargets.enemies.list.remove_dead = true
	LibOtherTargets.restore("enemies")
	
	d("LibOtherTargets." .. LibOtherTargets.VERSION .. " loaded")
end


function LibOtherTargets.playerlist_by_name(name)
	if ((name == "allies") or (name == "a")) then
		return LibOtherTargets.allies, LibOtherTargets.saved.allies
	elseif ((name == "enemies") or (name == "e")) then
		return LibOtherTargets.enemies, LibOtherTargets.saved.enemies
	end
	d("OtherTargetList not found " .. name)
	return nil
end


-- ugly as hell
function LibOtherTargets.restore(side)
	local plist, saved = LibOtherTargets.playerlist_by_name(side)
	if (saved.filters ~= nil) then
		for _, filter in ipairs(plist.filters) do
			if (saved.filters[filter.id] ~= nil) then
				filter.enabled = saved.filters[filter.id]
			end
		end
	end
	if (saved.visible ~= nil) then
		plist.visible = saved.visible
		for _, frame in ipairs(plist.frames) do
			frame.visible = plist.visible
		end
	end
	if (saved.sort_players ~= nil) then
		plist.list.sort_players = saved.sort_players
	end
	if (saved.remove_dead ~= nil) then
		plist.list.remove_dead = saved.remove_dead
	end
	if (saved.remove_full_hp ~= nil) then
		plist.list.remove_full_hp = saved.remove_full_hp
	end
	plist.list.max_players = saved.max_players or OtherTargetList.DEFAULT_MAXPLAYERS
end


function  LibOtherTargets.filter_scenario(_list, _name)
	if (GameData.Player.isInScenario) then
	
		if LibUnits then
			local player = LibUnits.GetFormationUnitByName(_name)
			return (player and player.groupIndex and player.groupIndex > 0)
		else
			local scdata = GameData.GetScenarioPlayerGroups()	-- get scenario wb
			for _, player in ipairs(scdata) do
				local scname = player.name:sub(1, player.name:len() - 2)	-- remove 2 extra chars from the end
				if ((scname == _name) and (player.sgroupindex > 0)) then
					return true	-- filter players in groups only
				end
			end
		end
	end
	return false
end


function LibOtherTargets.filter_warband(_list, _name)
	if (GameData.Player.isInScenario) or (not IsWarBandActive()) then
		return false
	end
	if LibUnits then
		return LibUnits.GetFormationUnitByName(_name) ~= nil
	else
		--local wb = GetBattlegroupMemberData()
		local wb = PartyUtils.GetWarbandData()
		for _, grp in ipairs(wb) do
			for _, player in ipairs(grp.players) do
				if (player.name == _name) then
					return true
				end
			end
		end
	end
	return false
end


function LibOtherTargets.filter_group(_list, _name)
	if (GameData.Player.isInScenario) then return false	end
	if LibUnits then
		local player = LibUnits.GetUnitByName(TargetObjectType.ALLY_PLAYER, _name)
		return (player and player.groupIndex == 1)
	else
		local group = PartyUtils.GetPartyData()
		if (not group) then return false end

		for _, player in ipairs(group) do
			if (player.name == _name) then
				return true
			end
		end
	end
	return false
end


function LibOtherTargets.filter_key_modifier(_list, _name)
--	if (_list.require_key) then
--		return  SystemData.ButtonFlags.SHIFT == ???
--	else
		return false
--	end
end


function LibOtherTargets.Broadcast(targetgroup)
	
	for i = 1, targetgroup.list.max_players do
		--DEBUG(L"Broadcasting "..towstring(i))
		-- tempfix create obj
		
		local player = targetgroup.list.players[i]
		
		if player == nil then
			if (targetgroup.ptype == TargetObjectType.ALLY_PLAYER) then
				for j = i, targetgroup.list.max_players do
					BroadcastOtherTargetsEvent(LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED, j, nil)
				end
			else
				for j = i, targetgroup.list.max_players do
					BroadcastOtherTargetsEvent(LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED, j, nil)
				end
			end
			return
		end
		
		local memberData
		if LibUnits then
			if (targetgroup.ptype == TargetObjectType.ALLY_PLAYER) then
				BroadcastOtherTargetsEvent(LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED, i, LibUnits.GetUnitByName(TargetObjectType.ALLY_PLAYER, player.name))
			else
				BroadcastOtherTargetsEvent(LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED, i, LibUnits.GetUnitByName(TargetObjectType.ENEMY_PLAYER, player.name))
			end
		else
			DEBUG(L"Lame old way...")
			memberData = {}
			memberData.name = player.name
			memberData.healthPercent = player.hp
			--memberData.career = player.career
			memberData.careerLine = player.career
			--memberData.level = player.rank
		
			if (targetgroup.ptype == TargetObjectType.ALLY_PLAYER) then
				BroadcastOtherTargetsEvent(LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED, i, memberData)
			else
				BroadcastOtherTargetsEvent(LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED, i, memberData)
			end
		end
		--[[if targetgroup.list.players[i] ~= nil and targetgroup.list.players[i].name ~= nil then
			DEBUG(towstring(targetgroup.list.players[i].name)..L": "..towstring(targetgroup.list.players[i].hp))
		end]]--
	end
end

local needsUpdate = false
function LibOtherTargets.update(_elapsed)
	LibOtherTargets.update_timeout = LibOtherTargets.update_timeout + _elapsed
	if (LibOtherTargets.update_timeout >= LibOtherTargets.UPDATE_PERIOD) or needsUpdate then
		--DEBUG(L"Updating")
		for _, targetgroup in ipairs(LibOtherTargets.targets) do
			targetgroup.list:update(LibOtherTargets.update_timeout) -- first organize current list
			--[[for i, frame in ipairs(targetgroup.frames) do
				frame:update(targetgroup.list.players[i])
			end]]--
			LibOtherTargets.Broadcast(targetgroup)
		end
		-- reset
		LibOtherTargets.update_timeout = 0
		needsUpdate = false
	end
end


function LibOtherTargets.on_target_updated(_unit, _id, _type)
	TargetInfo:UpdateFromClient()
	local name = TargetInfo:UnitName(_unit)
	local hp = TargetInfo:UnitHealth(_unit)
	local career = TargetInfo:UnitCareer(_unit)
	--local rank = TargetInfo:UnitLevel(_unit)

	name = name:sub(1, name:len() - 2)	-- remove 2 extra chars from the end

	for _, targetgroup in ipairs(LibOtherTargets.targets) do
		-- add/update this player
		if (targetgroup.ptype == _type) then
			local filtered = false
			for _, filter in ipairs(targetgroup.filters) do
				if (filter.enabled) then
					filtered = filter.f(targetgroup, name)
					if (filtered) then
						break
					end
				end
			end
			if (not filtered) then
				if (targetgroup.list:put_player(name, hp, career)) then
					needsUpdate = true
				end
			end			
		end
	end
	--DEBUG(L"Updated without LibTargets")
end

function LibOtherTargets.OnLibUnitsPlayerTargetUpdated(_, memberData)
	if memberData == nil then return end
	local name = memberData.name
	local hp = memberData.healthPercent
	local career = memberData.careerLine
	--local rank = memberData.level

	--name = name:sub(1, name:len() - 2)	-- remove 2 extra chars from the end
	
	for _, targetgroup in ipairs(LibOtherTargets.targets) do
		-- add/update this player
		if (targetgroup.ptype == memberData.type) then
			local filtered = false
			for _, filter in ipairs(targetgroup.filters) do
				if (filter.enabled) then
					filtered = filter.f(targetgroup, name)
					if (filtered) then
						break
					end
				end
			end
			if (not filtered) then
				if (targetgroup.list:put_player(name, hp, career)) then
					needsUpdate = true
				end
			end			
		end
	end
	--DEBUG(L"Updated via LibTargets")
end

function LibOtherTargets.alert(_text, _type)
	if (not _type) then
		_type = SystemData.AlertText.Types.DEFAULT
	end
	AlertTextWindow.AddLine(_type, towstring(_text))
	PlaySound(Sound.RVR_FLAG_OFF)
end


function LibOtherTargets.create_playerlist(_name, _player_type, _maxplayers)
	local tl = {}
	tl.list = OtherTargetList:new()
	tl.list.max_players = _maxplayers
	tl.ptype = _player_type
	tl.name = _name
	--tl.frames = {}
	tl.filters = {}
	--tl.visible = true

	--[[local anchor = { Point = "bottomleft", RelativeTo = "LibOtherTargets.Anchor", RelativePoint = "topleft", XOffset = (#LibOtherTargets.Targets* 110), YOffset = 0 }
	local frame
	for i = 1, OtherTargetList.MAX_PLAYERS do
		frame = LibOtherTargets.nitFrame:new(_name, i)
		frame:SetAnchor(anchor)
		anchor.RelativeTo = frame:GetName()
		anchor.XOffset = 0
		table.insert(tl.frames, frame)
	end]]--

	table.insert(LibOtherTargets.targets, tl)
	return tl
end

