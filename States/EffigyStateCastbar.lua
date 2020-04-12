if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

local GetAbilityData = GetAbilityData
local GetAbilityName = GetAbilityName
local string_format = string.format


local itemIcons = {}	-- courtesy of Obsidian, Amethyst or whatever stone involved
local function CacheItemIcons(abilityId)
	local itemData = DataUtils.GetItems()	
	for index, item in ipairs(itemData) do
		if (item.bonus ~= nil and item.bonus[1] ~= nil and type(item.bonus[1].reference) == "number") then
			local id = item.bonus[1].reference
			itemIcons[id] = item.iconNum or 0

			if (id == abilityId) then
				return true
			end
		end
	end
	itemIcons[abilityId] = 0 -- not found, and will not be searched for again
	return false
end

function Addon.RegisterStateInfoForCastbar()

	if DoesWindowExist("UFLayerTimerWindow") then return end
	
	CreateWindowFromTemplate("UFLayerTimerWindow", "EffigyEmpty", "Root")
	WindowSetShowing("UFLayerTimerWindow", true)
	WindowRegisterCoreEventHandler("UFLayerTimerWindow", "OnUpdate", Addon.Name..".CastbarUpdate")
				
	local castbar = EffigyState:new("Castbar")
	castbar:SetExtraInfo("latency", 0)
	
	RegisterEventHandler(SystemData.Events.PLAYER_START_INTERACT_TIMER, Addon.Name..".StartInteract")
	RegisterEventHandler(SystemData.Events.PLAYER_BEGIN_CAST, Addon.Name..".StartCast")
	RegisterEventHandler(SystemData.Events.INTERACT_DONE, Addon.Name..".EndCast")
	RegisterEventHandler(SystemData.Events.PLAYER_END_CAST, Addon.Name..".EndCast")
	RegisterEventHandler(SystemData.Events.PLAYER_CAST_TIMER_SETBACK, Addon.Name..".SetbackCast")

	RegisterEventHandler(SystemData.Events.LOADING_END, Addon.Name..".OnLoadCastbar")
	
	RegisterEventHandler(SystemData.Events.PLAYER_ABILITIES_LIST_UPDATED, Addon.Name..".UpdateCurrentAbilities")
	RegisterEventHandler(SystemData.Events.WORLD_OBJ_COMBAT_EVENT, Addon.Name..".OnWorldObjCombatEvent")
	Addon.InitializeCastbarRespawn()
end

function Addon.OnLoadCastbar()
	UnregisterEventHandler(SystemData.Events.LOADING_END, Addon.Name..".OnLoadCastbar")
	Addon.UpdateCurrentAbilities()
end

local CurrentAbilities = {}
--Effigy.Abilities = CurrentAbilities
function Addon.UpdateCurrentAbilities()
	--DEBUG(L"Current Abilities Updated")
	for i = GameData.AbilityType.FIRST, GameData.AbilityType.NUM_TYPES do -- ToDo: Do we need Pet abilities?
		for id, ability in pairs(GetAbilityTable(i)) do
			if ability.id ~= 0 then
				CurrentAbilities[id] = ability	-- no need for deepcopy, is there?
			end
		end
	end
end

local latency = 0
local currentAbilityId = -1
function Addon.CastbarUpdate(timeElapsed)
	local state = Addon.States["Castbar"] --EffigyState:GetState("Castbar")
	if (nil == state) or (0 == #(state.bars)) then return end
	latency = latency + timeElapsed 

	if (0 == state:IsValid()) then return end

	local curr = state:GetValue()
	local isChannel = state:GetExtraInfo("isSpellChannel")
	
	if (true == isChannel) then
		curr = curr - timeElapsed
		if curr <= 0 then
			state:SetValid(0)
		else
			--state:SetLevel(tonumber(string_format("%.1f", curr )))
			state:SetExtraInfo("level", tonumber(string_format("%.1f", curr )))
			state:SetValue(curr)
		end
	else
		curr =  curr + timeElapsed
		if curr >= state:GetMax() then
			state:SetValid(0)
		else
			--state:SetLevel(tonumber(string_format("%.1f", curr )))
			state:SetExtraInfo("level", tonumber(string_format("%.1f", curr )))
			state:SetValue(curr)
		end		
	end
	state:render()
end

function Addon.StartInteract()
	local state = EffigyState:GetState("Castbar")
	if (nil == state) then return end

	state:SetRawTitle(GameData.InteractTimer.objectName)
	state:SetValue(GameData.InteractTimer.time)
	state:SetMax(GameData.InteractTimer.time)

	state:SetExtraInfo("isSpellChannel", true )
	state:SetExtraInfo("isSpellInteract", true )
	state:SetExtraInfo("ability", 0 )
	
	state:SetValid(1)
	
	--[[function LayerTimerWindow.StartInteractTimer()
		castTimer.current               = GameData.InteractTimer.time
		castTimer.maximum               = GameData.InteractTimer.time
		castTimer.desired               = GameData.InteractTimer.time
		castTimer.action                = 0
		castTimer.hideSelfWhenComplete  = true
		
		ResetCastBarState (castTimer.desired)
		SetCastBarName (nil, GameData.InteractTimer.objectName)
	end]]--
	
	state:render()
end

function Addon.StartCast(abilityId, isChannel, desiredCastTime, holdCastBar)
	currentAbilityId = abilityId
	if desiredCastTime == 0 then latency = 0 end
	local state = Addon.States["Castbar"]	--EffigyState:GetState("Castbar")
	if (nil == state) then return end
	--d(abilityId)

	local curr = 0
	local showGCD = Addon.ProfileSettings.CastbarShowGCD
	if (desiredCastTime == 0 and showGCD) then
		desiredCastTime = 1.4
		curr = 1.4
		isChannel = true
	elseif (true == isChannel) then
		desiredCastTime = tonumber(string_format("%.1f", desiredCastTime ))
		curr = desiredCastTime
	elseif desiredCastTime ~= 0 then
		desiredCastTime = tonumber(string_format("%.1f", desiredCastTime ))
	end
	
	if desiredCastTime <= 0 then
		state:SetValid(0)
	else
		state:SetMax(desiredCastTime)
		state:SetValue(curr)
		state:SetExtraInfo("isSpellChannel", isChannel )
		--state:SetExtraInfo("cast_time", desiredCastTime )
		state:SetExtraInfo("isSpellChannel", isChannel )
		state:SetExtraInfo("isSpellInteract", false )
		
		local abilityData = CurrentAbilities[abilityId] or GetAbilityData(abilityId)
		--d(abilityData)

		if (abilityData.id == 0) then			
			-- is an item
			if (itemIcons[abilityId] == nil) then
				CacheItemIcons(abilityId)
			end
			state:SetExtraInfo("ability", itemIcons[abilityId] )
			state:SetRawTitle(GetAbilityName(abilityId) or L"")
		elseif abilityData.iconNum then 
			state:SetExtraInfo("ability", abilityData.iconNum )
			state:SetRawTitle(abilityData.name or GetAbilityName(abilityId) or L"")
		else
			state:SetExtraInfo("ability", 0 )
			state:SetTitle(L"")
		end		
		state:SetValid(1)
	end
	state:render()
end

function Addon.EndCast(isCancel, fromQueuedCall)
	local state = EffigyState:GetState("Castbar")
	if (nil == state) then return end
	latency = 0
	if (not(Addon.ProfileSettings.CastbarShowGCD and state:GetMax() == 1.4)) then
		state:SetValid(0)
		state:render()
	end
end

function Addon.SetbackCast(newCastTime)
	local state = EffigyState:GetState("Castbar")
	if (nil == state) then return end
	
	--[[local curr
	
	-- setback amount is newCastTime - state.curr at this point
	if (false == state:GetExtraInfo("isSpellChannel")) then
		state:SetMax(state:GetExtraInfo("cast_time")) --latency adjustments mess up when setback occurs
		curr = state:GetMax() - newCastTime
		if (curr < 0) then curr = 0 end
		
	end
	curr = tonumber(string.format("%.f", curr ))
	]]--

	--assert (state:GetValue() > 0)
    -- If setback amount is deisred here's how to get it: newCastTime - castTimer.current
	
	--state:SetValue(curr)
	state:SetValue(tonumber(string_format("%.1f", newCastTime )))
	state:render()
end

function Addon.OnWorldObjCombatEvent(objectID, amount, combatEvent, abilityId)
	if abilityId == currentAbilityId then
		--DEBUG(L"DING")
		local state = EffigyState:GetState("Castbar")
		state:SetExtraInfo("latency", latency)
		latency = 0
		currentAbilityId = -1
	end
end