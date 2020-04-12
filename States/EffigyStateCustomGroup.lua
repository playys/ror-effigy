if not Effigy then Effigy = {} end

-- Make addon table ref local for performance
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

function Addon.RegisterStateInfoForCGroup()
	
	for i= 1, 6 do
		local grpCfhp = EffigyState:new("grpCF"..i.."hp")
		local grpChhp = EffigyState:new("grpCH"..i.."hp")
		grpCfhp:SetMax(100)
		grpChhp:SetMax(100)
	end

end

local isCFRegistered = false
function Addon.RegisterEventsForCFGroup()
	if not isCFRegistered then
		LibOtherTargets.RegisterEventHandler(LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED, "grpCF", Addon.UpdateCustomGroupMember)
		isCFRegistered = true
	end
end

function Addon.UnregisterEventsForCFGroup()
	if isCFRegistered then
		LibOtherTargets.UnregisterEventHandler(LibOtherTargets.Events.FRIENDLY_CUSTOM_GROUP_MEMBER_UPDATED, "grpCF", Addon.UpdateCustomGroupMember)
		isCFRegistered = false
	end
end

local isCHRegistered = false
function Addon.RegisterEventsForCHGroup()
	if not isCHRegistered then
		LibOtherTargets.RegisterEventHandler(LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED, "grpCH", Addon.UpdateCustomGroupMember)
		isCHRegistered = true
	end
end

function Addon.UnregisterEventsForCHGroup()
	if isCHRegistered then
		LibOtherTargets.UnregisterEventHandler(LibOtherTargets.Events.HOSTILE_CUSTOM_GROUP_MEMBER_UPDATED, "grpCH", Addon.UpdateCustomGroupMember)
		isCHRegistered = false
	end
end

function Addon.UpdateCustomGroupMember(arbObj, index, memberData)
	--d(arbObj, index, memberData)
	if arbObj == "grpCF" then
		-- friendly
	else
		-- hostile
	end
	if not memberData then
		-- invalidate
		Addon.CGroupMemberSetValid(arbObj, index, 0)
		return
	end
	local hp_state = EffigyState:GetState(arbObj..index.."hp")
	
	if memberData.name ~= hp_state:GetTitle() then
		if arbObj == "grpCF" then
			for _,v in ipairs(hp_state.bars) do
				--local bar = Addon.Bars[v]
				if (nil ~= v) then
					WindowSetGameActionData(v.name, GameData.PlayerActions.SET_TARGET, 0, memberData.name)
				end
			end
		end
		hp_state:SetRawTitle(memberData.name)
		hp_state:SetExtraInfo("career", memberData.careerLine)
	end
	
	--hp_state:SetExtraInfo("IsTargeted", memberData.isTargeted)
	
	hp_state:SetValue(memberData.healthPercent)
	--hp_state:SetLevel(memberData.level)
	hp_state:SetUnit(memberData)
	
	hp_state:SetValid(1)
	hp_state:render()
end

function Addon.CGroupMemberSetValid(arbObj, memberIndex, arg)
	if (arg ~= Addon.States[arbObj..memberIndex.."hp"].valid) then --just do if necessary
		-- clear old data
		local hp_state = EffigyState:GetState(arbObj..memberIndex.."hp")					
		hp_state:SetValid(arg)	
		--DEBUG(towstring(arbObj..memberIndex.."hp")..L": SetValid: "..towstring(arg))
		hp_state:render()
	end
end
