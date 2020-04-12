-- forked of HudUnitFrames: http://war.curseforge.com/addons/huduf/
-- Credits @Metaphaze & Tannecurse

if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

if not Addon.States then Addon.States = {} end
if not Addon.StateUpdateHandlers then Addon.StateUpdateHandlers = {} end

EffigyState = {}
EffigyState.__index = EffigyState

local handler_cnt = 0

function EffigyState:new(name)
	if not name then
		d("EffigyState: Cannot create a unnamed state")
		return nil
	end

	local self =  {}
	setmetatable(self, EffigyState)

	self.curr =  0
	self.max =  0
	self.bars =  { }
	self.updateFunc =  nil
	self.word =  L""
	self.rawword = L""
	self.name = name
	self.valid = 0
	self.entity_id = 0
	--self.level = nil
	
	self.extra_info = {}
	--self.extra_info.isFriendly = false
	--self.extra_info.isEnemy = false
	--self.extra_info.isPlayer = false
	self.extra_info.isGroup = false
	--self.extra_info.is_self = false
	--self.extra_info.isGroupLeader = false
	self.extra_info.is_offline = false
	--self.extra_info.is_warband_assistant = false
	self.extra_info.career = nil
	self.extra_info.rvr_flagged = nil
	
	--self.extra_info.isInSameRegion = nil
	--self.extra_info.isDistant = nil
	
	self.EntityData = nil

	self.event_handlers = {}
	
	Addon.States[name] = self
	
	return self
end

function EffigyState:GetState(name)
	if not name or not Addon.States[name] then
		d("EffigyState: Cannot find state. This state does not exist:" ..name)
		return nil
	end
	return Addon.States[name]
end

function EffigyState:DoesStateExist(name) return (name and Addon.States[name]) end

function EffigyState:GetTitle() return self.word end
function EffigyState:SetTitle(s) self.word = s end

function EffigyState:GetRawTitle() return self.rawword end
function EffigyState:SetRawTitle(s)
	self.rawword = s
	self.word = s:match(L"([^^]+)^?([^^]*)")
end

function EffigyState:GetMax() return self.max end
function EffigyState:SetMax(m) self.max = m end

--[[function EffigyState:GetLevel() return self.level end
function EffigyState:SetLevel(m) self.level = m end]]--

function EffigyState:GetValue() return self.curr end
function EffigyState:SetValue(v,m)
	self.curr = v
	if m then
		self.max = m
	end
end

function EffigyState:GetEntityID() return self.entity_id end
function EffigyState:SetEntityID(v) self.entity_id = v end

-- LibUnits
function EffigyState:GetUnit() return self.EntityData end
function EffigyState:SetUnit(v) self.EntityData = v end

--[[function EffigyState:GetEntityData(k)
	if (nil ~= self.entity_id) then
		if k ~= nil then 
			return self.EntityData[k]
		end
		--return RVAPI_Entities.API_GetEntityData(self.entity_id)
		return self.EntityData
	end
	return nil
end
]]--

function EffigyState:GetRelativeLevel() return self.relative_level end
function EffigyState:SetRelativeLevel(v) self.relative_level = v end

function EffigyState:GetExtraInfo(k)
	if self.extra_info[k] then
		return self.extra_info[k]
	elseif self.EntityData and self.EntityData[k] then
		return self.EntityData[k]
	end
	return nil
end
function EffigyState:SetExtraInfo(k,v) self.extra_info[k] = v end

function EffigyState:SetValid(v) self.valid = v end
function EffigyState:IsValid() return self.valid end

function EffigyState:update()
	if (nil ~= self.updateFunc) then 
		self.updateFunc() 
	end

	return self
end

function EffigyState:updateFunction(func)
	self.updateFunc = func
	self:update()
	return self
end

function EffigyState:updateEvent(event)
	if self.event_handlers[event] then
		d("This event is already registered")
		return
	end
	-- Mythic Events
	if type(event) ~= "table" then
		self.event_handlers[event] = 1
		-- dear ea mythic devs, if you ever read this and ask yourself why this 
		-- crap is required find the one that is responsible for registereventhandler
		-- and hit him/her with a club. if he/she askes why repeatly hit him/her again until
		-- registereventhandler can take a function ref. thanks.
		handler_cnt = handler_cnt + 1
		Addon.StateUpdateHandlers["Handler"..handler_cnt] = self.updateFunc
	--	d(self.updateFunc)
		--d(event, Addon.Name..".StateUpdateHandlers.Handler"..handler_cnt)
		RegisterEventHandler(event, Addon.Name..".StateUpdateHandlers.Handler"..handler_cnt)
	else

	end
	--return self
end

function EffigyState:renderElements()
	
	if (not self.bars) then
		DEBUG(L"no bars")
		return nil 
	end
	
	for _,v in ipairs(self.bars) do
		if (nil ~= v) then
			v:render()
		end
	end
end
function EffigyState:render() return self:renderElements() end

function EffigyState:updateMyBarColours(r, g, b)
	self.color_override = {}
	self.color_override.r = r
	self.color_override.g = g
	self.color_override.b = b
end

--[[function EffigyState:registerBar2(bar)

	table.insert(self.bars, bar.name)

	return self
end]]--

function EffigyState.registerBars(o,bar)
	return EffigyState.registerElement(o,bar)
end

function EffigyState.registerElement(name,element)
	
	local o
	if (nil == Addon.States[name]) then
		-- states created by external addons may not be initialized yet
        o = EffigyState:new(name)
    else
		o = Addon.States[name]
	end
	
	if not (o.bars and next(o.bars) ~= nil) then
		if name == "formation11hp" then
			Addon.RegisterEventsForFormation()
		elseif name == "grpCF1hp" then
			Addon.RegisterEventsForCFGroup()
		elseif name == "grpCH1hp" then
			Addon.RegisterEventsForCHGroup()
		elseif name == "MOHP" then
			WindowSetShowing( "MouseOverTargetWindow", false )
			WindowSetShowing( "DefaultTooltip", false )
		end
	end
	
	table.insert(o.bars, element)
	return o
end

function EffigyState:unregisterBar(bar)
	for k,v in ipairs(self.bars) do
		if (v.name == bar.name) then
			table.remove(self.bars, k)
		end
	end
	if next(self.bars) == nil then
		if name == "formation11hp" then
			Addon.UnregisterEventsForFormation()
		elseif name == "grpCF1hp" then
			Addon.UnregisterEventsForCFGroup()
		elseif name == "grpCH1hp" then
			Addon.UnregisterEventsForCHGroup()
		elseif name == "MOHP" then
			WindowSetShowing( "MouseOverTargetWindow", true )
			WindowSetShowing( "DefaultTooltip", true )
		end
	end
end

--[[local floor = math.floor
local function round(x) return floor(x + 0.5) end

function EffigyState:GetPercentageAsWString()
	if self.curr and self.max then 
		return towstring(round(self.curr/self.max*100))
	else 
		return L"" 
	end
end]]--

--[[function EffigyState:GetLevelAsWString()
	if self.level then 
		return towstring(self.level) 
	else 
		return L"" 
	end
end]]--

--[[function EffigyState:GetCurrAsWString()
	if self.curr then 
		return towstring(self.curr) 
	else 
		return L"" 
	end
end]]--

--[[function EffigyState:GetTitleAsWString()
	if self.word then 
		return towstring(self.word) 
	else 
		return L" " 
	end
end]]--

--[[function EffigyState:GetCurrFormartedAsWString()
	if self.curr then 
		return towstring(string.format("%.1f",self.curr))
	else 
		return L"" 
	end
end]]--

--[[function EffigyState:GetMaxAsWString()
	if self.max then 
		return towstring(self.max) 
	else 
		return L"" 
	end
end]]--

--[[function EffigyState:GetMissingAsWString()
	if self.max and self.curr then 
		return towstring(self.max - self.curr) 
	else 
		return L"" 
	end
end]]--

--[[local MAX_RANGE
function EffigyState:GetExtraInfoEntryAsWString(type)
	if not type then return L"" end
	-- to this moment we have to use self.extra info since there´s no data to get if a party member has no EntityID / worldobj
	if self.extra_info then
		if type == "cr" then
			if Addon.CareerNames[self.extra_info.career] then
				return towstring(Addon.CareerNames[self.extra_info.career][2]) 
			else 
				return L""
			end
		elseif type == "career" then
			if Addon.CareerNames[self.extra_info.career] then
				return towstring(Addon.CareerNames[self.extra_info.career][1]) 
			else 
				return L""
			end
		elseif type == "RangeMax" then
			local lLibRange = LibRange
			if not lLibRange then return L"" end
			if not MAX_RANGE then MAX_RANGE = lLibRange.TargetRange.MAX_RANGE end
			if self.extra_info[type] == MAX_RANGE then
				return L"OORS"
			elseif self.extra_info[type] == MAX_RANGE + 1 then
				return L"DIST"
			elseif self.extra_info[type] == MAX_RANGE + 2 then
				return L"OOZ"
			elseif self.extra_info[type] == 0 then
				return L""
			else
				return towstring(self.extra_info[type])
			end
		elseif self.extra_info[type] then
			return towstring(self.extra_info[type])
		end
	end
	-- if the entry isn´t found in extra_info we get here...
	-- try EntityData (for example type == "range") for information
	if self.EntityData and self.EntityData[type] then
		--if (type == "RangeMax" and (self.EntityData[type] == RVAPI_Range.MAX_RANGE)) then
		--	return L"OORS"
		--else
			return towstring(self.EntityData[type])
		--end
	end
	-- still nothing found
	return L""
end]]--
