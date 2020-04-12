if not Effigy then Effigy = {} end

-- Make addon table ref local for performance
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

-- PLAYER_TARGET_UPDATED
-- PLAYER_TARGET_HIT_POINTS_UPDATED
-- PLAYER_TARGET_STATE_UPDATED

local playersName = nil
local function GetPlayersName()
	if (playersName == nil) then
	    playersName = (GameData.Player.name)--:match(L"([^^]+)^?([^^]*)");
	end
	return playersName
end

local WindowSetGameActionData = WindowSetGameActionData
local WindowSetGameActionTrigger = WindowSetGameActionTrigger

--
-- Quest Tracking (MO only! ?)
--
local function ProcessQuestTracking( unit )

	local unitName = unit:GetFormatedName()
	local questComplete, questName, questObjectiveName, questCurrentCounter, questMaxCounter
	
	for _, quest in ipairs( DataUtils.GetQuests() ) do
	
		for _, objective in ipairs( quest.conditions ) do
		
			if wstring.find( objective.name, unitName, 1, true ) or wstring.find( quest.journalDesc, unitName, 1, true ) then
			
				questComplete 		= quest.complete
				questName			= quest.name
				questObjectiveName	= objective.name
				questCurrentCounter	= objective.curCounter
				questMaxCounter		= objective.maxCounter
				
				if questMaxCounter == 0 then
					questMaxCounter = 1
				end
				
				if not questComplete then
					return questName..L": "..L""..questCurrentCounter..L"/"..questMaxCounter
				end
			end
		end
	end
	return L""
end

function Addon.RegisterStateInfoForTargets()
	local hthp = EffigyState:new("HTHP")
	local htlvl = EffigyState:new("HTlvl")
	local htcon = EffigyState:new("HTCon")
	
	local fthp = EffigyState:new("FTHP")
	local ftlvl = EffigyState:new("FTlvl")
	
	local mohp = EffigyState:new("MOHP")
	local molvl = EffigyState:new("MOlvl")
	
	local fmot = EffigyState:new("FMOT")
	
	hthp:SetMax(100)
	fthp:SetMax(100)
	mohp:SetMax(100)
	fmot:SetMax(100)
	htlvl:SetMax(40)
	ftlvl:SetMax(40)
	molvl:SetMax(40)
		
	-- Final step: register event handlers
	if (nil ~= LibUnits) then
		--hthp:updateFunction(Addon.UpdateHT)
		--htlvl:updateFunction(Addon.UpdateHT)
		--htcon:updateFunction(Addon.UpdateHT)
		--EffigyBuffs.RegisterStateForEffect(Addon.States["HTHP"],"HT")

		--fthp:updateFunction(Addon.UpdateFT)
		--ftlvl:updateFunction(Addon.UpdateFT)
		--EffigyBuffs.RegisterStateForEffect(Addon.States["FTHP"],"FT")
		
		--mohp:updateFunction(Addon.UpdateMO)	
		--molvl:updateFunction(Addon.UpdateMO)
		
		LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_FRIENDLY_TARGET_UPDATED, "selffriendlytarget", Addon.UpdateTarget)
		LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_HOSTILE_TARGET_UPDATED, "selfhostiletarget", Addon.UpdateTarget)
		LibUnits.RegisterEventHandler(LibUnits.Events.PLAYER_MOUSEOVER_TARGET_UPDATED, "mouseovertarget", Addon.UpdateTarget)
		--DEBUG(L"Using LibUnits for Targets")
	else
		--[[
		hthp:updateFunction(Addon.UpdateHostileTarget)
		htlvl:updateFunction(Addon.UpdateHostileTarget)
		htcon:updateFunction(Addon.UpdateHostileTarget)
		--EffigyBuffs.RegisterStateForEffect(Addon.States["HTHP"],"HT")

		fthp:updateFunction(Addon.UpdateFriendlyTarget)
		ftlvl:updateFunction(Addon.UpdateFriendlyTarget)
		--EffigyBuffs.RegisterStateForEffect(Addon.States["FTHP"],"FT")
		
		mohp:updateFunction(Addon.UpdateMouseOverTarget)	
		molvl:updateFunction(Addon.UpdateMouseOverTarget)

		
		hthp:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)
		htlvl:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)
		htcon:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)
	
		fthp:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)
		ftlvl:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)
	
		mohp:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)
		molvl:updateEvent(SystemData.Events.PLAYER_TARGET_UPDATED)]]--
		--EA_ChatWindow.Print(L"Unitframes (RV): RVAPI_Entities NOT found. Entering standalone mode.")
		ERROR(L"LibUnits not found")
	end
	
	CreateWindowFromTemplate("EffigyTLMO", "EffigyActionProxy", "Root")
	RegisterEventHandler(SystemData.Events.LOADING_END, "Effigy.ResetFMOT")
	
	if not LibRange then return end
	LibRange.RegisterEventHandler("selffriendlytarget", Addon.OnRangeUpdated_TargetsCallback, "FTHP")
	LibRange.RegisterEventHandler("selfhostiletarget", Addon.OnRangeUpdated_TargetsCallback, "HTHP")
end															

--
-- Standalone (old HUDUF) Style
--
--[[function Addon.UpdateHostileTarget()
	local hp_state = EffigyState:GetState("HTHP")
	local lvl_state = EffigyState:GetState("HTlvl")
	local con_state = EffigyState:GetState("HTCon")
	if nil == hp_state or nil == lvl_state or nil == con_state then return end
	TargetInfo:UpdateFromClient()

	local lvl = TargetInfo:UnitLevel("selfhostiletarget")
	local lvltext = lvl
	for i=1,TargetInfo:UnitTier("selfhostiletarget") do lvltext = lvltext..L"+" end

	local unittype = TargetInfo:UnitType("selfhostiletarget")
	hp_state:SetLevel(lvltext)
	
	hp_state:SetValue(TargetInfo:UnitHealth("selfhostiletarget"))
	hp_state:SetRawTitle( L""..TargetInfo:UnitName("selfhostiletarget"))
	
	lvl_state:SetRawTitle( L""..TargetInfo:UnitName("selfhostiletarget"))
	lvl_state:SetValue(TargetInfo:UnitLevel("selfhostiletarget"))
	-- TODO: hard coded
	lvl_state:SetMax(40)
	--lvl_state:SetRelativeLevel(lvl - GameData.Player.level)
	
	con_state:SetValue(TargetInfo:UnitConType("selfhostiletarget"))
	con_state:SetMax(8)
	
	hp_state:SetRelativeLevel(lvl - GameData.Player.level)
	hp_state:SetExtraInfo("unittype", unittype )
	hp_state:SetExtraInfo("isFriendly", false)	
	hp_state:SetExtraInfo("isEnemy", true)	
	hp_state:SetExtraInfo("career", nil)
	hp_state:SetExtraInfo("career", TargetInfo:UnitCareer("selfhostiletarget"))
	hp_state:SetExtraInfo("rvr_flagged", TargetInfo:UnitIsPvPFlagged("selfhostiletarget"))

	-- Used for Attach To World Object
	hp_state:SetEntityID(TargetInfo:UnitEntityId("selfhostiletarget"))
	lvl_state:SetEntityID(TargetInfo:UnitEntityId("selfhostiletarget"))
	
	hp_state:SetRelativeLevel(lvl - GameData.Player.level)
	lvl_state:SetRelativeLevel(lvl - GameData.Player.level)
	
	local colour = TargetInfo:UnitRelationshipColor("selfhostiletarget")
	local override_colour = DataUtils.GetTargetConColor(con_state.curr) 

	hp_state:SetValid(1)
	lvl_state:SetValid(1)
	con_state:SetValid(1)

	
	hp_state:render()
	lvl_state:render()
	con_state:updateMyBarColours(override_colour.r, override_colour.g, override_colour.b)
	con_state:render()
end

function Addon.UpdateFriendlyTarget()
	local hp_state = EffigyState:GetState("FTHP")
	local lvl_state = EffigyState:GetState("FTlvl")
	if (not hp_state) or (not lvl_state) then return end
	TargetInfo:UpdateFromClient()

	local oldId
	if hp_state:GetEntityID() then
		oldId = hp_state:GetEntityID()
	end
	
	local lvl = TargetInfo:UnitLevel("selffriendlytarget")
	local lvltext = lvl
	for i=1,TargetInfo:UnitTier("selffriendlytarget") do lvltext = lvltext..L"+" end

	local unittype = TargetInfo:UnitType("selffriendlytarget")

	hp_state:SetLevel(lvltext)
	
	hp_state:SetValue(TargetInfo:UnitHealth("selffriendlytarget"))
	hp_state:SetMax(100)
	hp_state:SetRawTitle( L""..TargetInfo:UnitName("selffriendlytarget"))
	
	lvl_state:SetRawTitle( L""..TargetInfo:UnitName("selffriendlytarget"))
	lvl_state:SetValue(TargetInfo:UnitLevel("selffriendlytarget"))
	-- TODO: hard coded
	lvl_state:SetMax(40)
	lvl_state:SetRelativeLevel(lvl - GameData.Player.level)
	
	hp_state:SetRelativeLevel(lvl - GameData.Player.level)
	hp_state:SetExtraInfo("unittype", unittype )
	hp_state:SetExtraInfo("isFriendly", true)
	hp_state:SetExtraInfo("isEnemy", false)
	hp_state:SetExtraInfo("career", nil)
	hp_state:SetExtraInfo("career", TargetInfo:UnitCareer("selffriendlytarget"))
	hp_state:SetExtraInfo("rvr_flagged", TargetInfo:UnitIsPvPFlagged("selffriendlytarget"))

	-- Used for Attach To World Object
	hp_state:SetEntityID(TargetInfo:UnitEntityId("selffriendlytarget"))
	lvl_state:SetEntityID(TargetInfo:UnitEntityId("selffriendlytarget"))
	
	local colour = TargetInfo:UnitRelationshipColor("selffriendlytarget")

	if colour ~= nil
	then
		hp_state:updateMyBarColours(colour.r, colour.g, colour.b)
	end

	hp_state:SetValid(1)
	lvl_state:SetValid(1)
	
	hp_state:render()
	lvl_state:render()
		
	if oldId ~= hp_state.entity_id then
		EffigyBar.reRenderAfterFTChange(oldId,hp_state.entity_id) -- TODO: update me
	end
end

function Addon.UpdateMouseOverTarget()
	local hp_state = EffigyState:GetState("MOHP")
	local lvl_state = EffigyState:GetState("MOlvl")
	if not hp_state or not lvl_state then return end
	TargetInfo:UpdateFromClient()

	local lvl = TargetInfo:UnitLevel("mouseovertarget")
	local lvltext = lvl
	for i=1,TargetInfo:UnitTier("mouseovertarget") do lvltext = lvltext..L"+" end

	local unittype = TargetInfo:UnitType("mouseovertarget")
	if unittype > 0 and unittype <= 4
	then 
		hp_state:SetExtraInfo("isFriendly", true)
		hp_state:SetExtraInfo("isEnemy", false)
	else
		hp_state:SetExtraInfo("isFriendly", false)	
		hp_state:SetExtraInfo("isEnemy", true)
	end

	hp_state:SetLevel(lvltext)
	
	hp_state:SetValue(TargetInfo:UnitHealth("mouseovertarget"))
	hp_state:SetMax(100)
	hp_state:SetRawTitle( L""..TargetInfo:UnitName("mouseovertarget"))
	
	lvl_state:SetRawTitle( L""..TargetInfo:UnitName("mouseovertarget"))
	lvl_state:SetValue(TargetInfo:UnitLevel("mouseovertarget"))
	-- TODO: hard coded
	lvl_state:SetMax(40)
	
	hp_state:SetExtraInfo("unittype", unittype )
	hp_state:SetExtraInfo("isFriendly", true)
	hp_state:SetExtraInfo("isEnemy", false)
	hp_state:SetExtraInfo("career", nil)
	hp_state:SetExtraInfo("career", TargetInfo:UnitCareer("mouseovertarget"))
	hp_state:SetExtraInfo("rvr_flagged", TargetInfo:UnitIsPvPFlagged("mouseovertarget"))

	-- Used for Attach To World Object
	hp_state:SetEntityID(TargetInfo:UnitEntityId("mouseovertarget"))
	lvl_state:SetEntityID(TargetInfo:UnitEntityId("mouseovertarget"))
	
	hp_state:SetRelativeLevel(lvl - GameData.Player.level)
	lvl_state:SetRelativeLevel(lvl - GameData.Player.level)
	
	local colour = TargetInfo:UnitRelationshipColor("mouseovertarget")
	if colour ~= nil then
		hp_state:updateMyBarColours(colour.r, colour.g, colour.b)
	end

	hp_state:SetValid(1)
	lvl_state:SetValid(1)
	
	hp_state:render()
	lvl_state:render()
end]]--

--
-- LibUnits Style
--
function Addon.UpdateTargetProxy(whichOne, unit)
	Addon.UpdateTarget(whichOne, unit)
end

function Addon.UpdateFT()
	Addon.UpdateTarget("selffriendlytarget", nil, true)
end

function Addon.UpdateHT()
	Addon.UpdateTarget("selfhostiletarget", nil, true)
end

function Addon.UpdateMO()
	Addon.UpdateTarget("mouseovertarget", nil, true)
end

local oldTargetGroupIndex = 0
local oldTargetMemberIndex = 0
function Addon.UpdateTarget(targetClassification, unit, force)
	-- |targetClassification: selfhostiletarget,selffriendlytarget,mouseovertarget | --

	-- : set local variables
	local hp_state
	local lvl_state
	local con_state
	
	--[[if force then
		unit = LibUnits.GetUnitByName(LibUnits.Units[targetClassification])
	end]]--
	local newTargetId = 0
	if unit then
		newTargetId  = unit.worldObjNum
	end
	
	if (targetClassification == "selffriendlytarget") then
		hp_state = EffigyState:GetState("FTHP")
		lvl_state = EffigyState:GetState("FTlvl")
		if (nil == hp_state) or (nil == lvl_state) then return end
		--DEBUG(L"oldTargetMemberIndex: "..oldTargetMemberIndex)
		if oldTargetMemberIndex ~= 0 and hp_state:GetEntityID() ~= newTargetId then
			--DEBUG(L"DONG")
			if oldTargetGroupIndex ~= 0 then
				-- formation
				local unTargetedState = EffigyState:GetState("formation"..oldTargetGroupIndex..oldTargetMemberIndex.."hp")
				unTargetedState:SetExtraInfo("isTargeted", false)
				unTargetedState:render()
			else
				local unTargetedState = EffigyState:GetState("grp"..oldTargetMemberIndex.."hp")
				unTargetedState:SetExtraInfo("isTargeted", false)
				unTargetedState:render()
				if oldTargetMemberIndex == 1 then
					unTargetedState = EffigyState:GetState("PlayerHP")
					unTargetedState:SetExtraInfo("isTargeted", false)
					unTargetedState:render()
					unTargetedState = EffigyState:GetState("PlayerAP")
					unTargetedState:SetExtraInfo("isTargeted", false)
					unTargetedState:render()
				end
			end
		end

	elseif (targetClassification == "selfhostiletarget") then
		hp_state = EffigyState:GetState("HTHP")
		lvl_state = EffigyState:GetState("HTlvl")
		con_state = EffigyState:GetState("HTCon")
		if (nil == hp_state) or (nil == lvl_state) or (nil == con_state) then return end
	elseif (targetClassification == "mouseovertarget") then	
		hp_state = EffigyState:GetState("MOHP")
		lvl_state = EffigyState:GetState("MOlvl")
		if not hp_state or not lvl_state then return end
	else
		return
	end
	local oldTargetId = hp_state:GetEntityID()
	--hp_state:SetExtraInfo("career", nil) -- ??????????
	
	if newTargetId  > 0 then
		if newTargetId  ~= oldTargetId then
			local unitName = unit.name
			local unitType = unit.type
			hp_state:SetRawTitle(unitName)
			hp_state:SetExtraInfo("unittype", unitType)
			hp_state:SetExtraInfo("career", unit.careerLine)
			if (targetClassification == "mouseovertarget") then
				hp_state:SetExtraInfo("quest", ProcessQuestTracking( unit ))
				if unitType == SystemData.TargetObjectType.ALLY_PLAYER then
					WindowSetGameActionData("EffigyTLMOAction", GameData.PlayerActions.SET_TARGET, 0, unitName)
					WindowSetGameActionTrigger("EffigyTLMOAction", GetActionIdFromName("ACTION_BAR_120"))
					local fmot = EffigyState:GetState("FMOT")
					for _,v in ipairs(fmot.bars) do
						if (nil ~= v) then
							WindowSetGameActionData(v.name, GameData.PlayerActions.SET_TARGET, 0, unitName)
						end
					end
					fmot:SetUnit(unit)
					fmot:SetRawTitle(unitName)
					fmot:SetValue(unit.healthPercent)
					fmot:SetEntityID(newTargetId)
					fmot:SetExtraInfo("unittype", unitType)
					fmot:SetExtraInfo("career", unit.careerLine)					
					fmot:SetValid(1)
					fmot:render()
				end
			end
			if unit.isNPC then
				if unit.title == L"" then
					hp_state:SetExtraInfo("npcTitle", GetStringFromTable("MapPointTypes", unit.mapPinType))
				end
			end
			lvl_state:SetRawTitle( L""..unitName)
		end

		if unit.isFriendly then 	-- NPCs might change their friendly state with some Quests
			hp_state:SetExtraInfo("isEnemy", false)
		else
			hp_state:SetExtraInfo("isEnemy", true)
		end
			
		local lvl = unit.level
		lvl_state:SetValue(lvl)
		local lvltext = lvl
		for i=1, unit.tier do
			lvltext = lvltext..L"+"
		end
		--hp_state:SetLevel(lvltext)
		hp_state:SetExtraInfo("level", lvltext)
		
		hp_state:SetValue(unit.healthPercent)
		
		lvl_state:SetRelativeLevel(lvl - GameData.Player.level)		
		hp_state:SetRelativeLevel(lvl - GameData.Player.level)
		
		hp_state:SetExtraInfo("rvr_flagged", unit.isRVRFlagged)
		
		local color = unit.relationshipColor
		hp_state:updateMyBarColours(color.r, color.g, color.b)
		
		hp_state:SetUnit(unit)
		hp_state:SetValid(1)
		lvl_state:SetValid(1)
		if (nil ~= con_state) then
			local conType = unit.conType
			con_state:SetValue(conType)
			local color = DataUtils.GetTargetConColor(conType)
			con_state:updateMyBarColours(color.r, color.g, color.b)
			con_state:SetTitle(DataUtils.GetTargetConDesc(conType))
			--DataUtils.GetTargetTierDesc( tier )
			con_state:SetValid(1)
			con_state:render()
		end
	else
		hp_state:SetUnit(nil)	
		hp_state:SetValid(0)
		lvl_state:SetValid(0)
		if (nil ~= con_state) then
			con_state:SetValid(0)
			con_state:render()
		end
	end
	
	-- Used for Attach To World Object
	hp_state:SetEntityID(newTargetId)
	lvl_state:SetEntityID(newTargetId)
	
	if (targetClassification == "selffriendlytarget") and (oldTargetId ~= newTargetId) then
		if newTargetId  > 0 then
			if unit.isNPC then
				oldTargetGroupIndex = 0
				oldTargetMemberIndex = 0
			else
				if unit.type == SystemData.TargetObjectType.SELF then -- unit.name == GetPlayersName()
					--DEBUG(L"Self Targeted")
					hp_state:SetExtraInfo( "RangeMin", 0 )
					hp_state:SetExtraInfo( "RangeMax", 0 )
					
					oldTargetGroupIndex = 0
					oldTargetMemberIndex = 1
					local targetedState = EffigyState:GetState("PlayerHP")
					targetedState:SetExtraInfo("isTargeted", true)
					targetedState:render()
					targetedState = EffigyState:GetState("PlayerAP")
					targetedState:SetExtraInfo("isTargeted", true)
					targetedState:render()
					targetedState = EffigyState:GetState("grp1hp")
					targetedState:SetExtraInfo("isTargeted", true)
					targetedState:render()	
				else
					local formationunit
					if unit.memberIndex ~= -1 then
						formationunit = unit
						--DEBUG(L"DING")
					else
						formationunit = LibUnits.GetFormationUnitByName(unit.name) or LibUnits.GetFormationUnitByName(unit:GetFormatedName())
						--DEBUG(L"DONG")
					end
					if formationunit ~= nil then
						local formationUnitGroupIndex = formationunit.groupIndex
						if formationunit.groupIndex == LibUnits.GetPlayersGroupIndex() then
							oldTargetGroupIndex = 0							
							if LibUnits.GetCurrentMode() == LibFormationMode.FormationModes.Party or formationunit.memberIndex < LibUnits.GetPlayersMemberIndex() then
								oldTargetMemberIndex = formationunit.memberIndex + 1
							else
								oldTargetMemberIndex = formationunit.memberIndex
							end
							local targetedState = EffigyState:GetState("grp"..oldTargetMemberIndex.."hp")
							targetedState:SetExtraInfo("isTargeted", true)
							targetedState:render()
						else
							oldTargetGroupIndex = formationUnitGroupIndex
							oldTargetMemberIndex = formationunit.memberIndex
							local targetedState = EffigyState:GetState("formation"..oldTargetGroupIndex..oldTargetMemberIndex.."hp")
							targetedState:SetExtraInfo("isTargeted", true)
							targetedState:render()
						end						
					else
						oldTargetGroupIndex = 0
						oldTargetMemberIndex = 0
					end
				end
			end
		else
			oldTargetGroupIndex = 0
			oldTargetMemberIndex = 0
		end
		EffigyBar.reRenderAfterTargetChange(oldTargetId, newTargetId, "show_with_target")
		--return
		
		--DEBUG(L"New oldTargetMemberIndex: "..oldTargetMemberIndex)
	elseif (targetClassification == "selfhostiletarget") and (oldTargetId ~= newTargetId) then
		EffigyBar.reRenderAfterTargetChange(oldTargetId, newTargetId, "show_with_target_ht")
	end
	hp_state:render()
	lvl_state:render()
end

function Addon.ResetFMOT()
	local fmot = EffigyState:GetState("FMOT")
	fmot:SetUnit(nil)
	fmot:SetRawTitle(L"")
	fmot:SetValue(0)
	fmot:SetEntityID(-1)					
	fmot:SetValid(0)
	fmot:render()
end

--
-- Range Updates from LibRange
--
function Addon.OnRangeUpdated_TargetsCallback(object, name, rangemax, rangemin) -- when registering, use state as oject/callback owner
	local hp_state = EffigyState:GetState(object)
	if (nil == hp_state --[[or nil == hp_state.valid or 0 == hp_state.valid]] ) then return end
	
	if ( hp_state:GetExtraInfo("RangeMax") ~= rangemax ) or (rangemin and ( hp_state:GetExtraInfo("RangeMin") ~= rangemin )) then -- Range has changed
		hp_state:SetExtraInfo("RangeMin", rangemin)
		hp_state:SetExtraInfo("RangeMax", rangemax)
		
		-- ToDo: Ressource optimization; check if rendering occured in this frame already?
		if (nil ~= hp_state.valid and 0 ~= hp_state.valid) then hp_state:render() end
	end
	
end
