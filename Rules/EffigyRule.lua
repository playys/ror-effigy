if not Effigy then Effigy = {} end
local Addon = Effigy
if not Addon.Rule then Addon.Rule = {} end
if not Addon.Rules then Addon.Rules = {} end

local string_sub = string.sub
local string_len = string.len
local tostring = tostring
local tonumber = tonumber
local type = type
local string_find = string.find
local string_gsub = string.gsub

local playersName = nil
local function GetPlayersName()	-- formated
	if (playersName == nil) then
	    playersName = (GameData.Player.name):match(L"([^^]+)^?([^^]*)")
	end
	return playersName
end

local function stringStartsWith(String, Start)
	return string_sub(String, 1, string_len(Start))==Start
end

local function stringEndsWith(String, End)
	return End=='' or string_sub(String, -string_len(End))==End
end

Addon.Rule.Rule = {}
Addon.Rule.Rule.__index = Addon.Rule.Rule
Addon.Rule.DefaultRule = {
	name = "new rule",
	scope = "any",
	filter = "isClass",
	filterParam = "",
	payload = "",
	priority = 1,
	enabled = true
	}

Addon.Rule.RuleSet = {}
Addon.Rule.RuleSet.__index = Addon.Rule.RuleSet
Addon.Rule.DefaultRuleSet = {rules = {}, name = "new set"}									
									
function Addon.Rule.Rule:new (ruleName, ruleType)
	return Addon.Rule.Rule:newFromRule (ruleName, Addon.Rule.DefaultRule, ruleType)
end

function Addon.Rule.Rule:newFromRule (ruleName, rule, ruleType)
	if (ruleType == nil) then
		d("no ruletype for rule")
		d("rule")
		return
	end
	if (nil ~= Addon.Rules[ruleType].Rules[ruleName]) then
		EA_ChatWindow.Print(L"Cannot create a new rule for one that exists")
		return nil 
	end
	
	if (not Addon.Rules[ruleType]) then Addon.Rules[ruleType] = {} end
	if (not Addon.Rules[ruleType].Rules[ruleName]) then 
		Addon.Rules[ruleType].Rules[ruleName] = {} 
	end
	
	local self = {}

	setmetatable(self, Addon.Rule.Rule) -- setup prototye

	self.name = ruleName
	--[[
	self.scope = "any"
	self.filter = "isClass"
	self.filterParam = ""
	self.priority = 1
	self.enabled = false]]--
	self.scope = rule.scope
	self.filter = rule.filter
	self.filterParam = rule.filterParam
	self.priority = rule.priority
	self.enabled = rule.enabled
	self.payload = rule.payload
	Addon.Rules[ruleType].Rules[ruleName] = self
	return self
end

function Addon.Rule.Rule:getRuleFromStored (ruleName, rule)
	
	self = Addon.Rule.deepcopy(rule)
	setmetatable(self, Addon.Rule.Rule) -- setup prototype
	return self
end


local function compareNumberWithFilterParam(aNumber, filterParam, anotherNumber)	-- optional: anotherNumber
	if anotherNumber ~= nil then
		if stringStartsWith(filterParam, ">") then
			return aNumber > anotherNumber
		elseif stringStartsWith(filterParam, "<") then
			return aNumber < anotherNumber
		elseif stringStartsWith(filterParam, "<=") then
			return aNumber <= anotherNumber
		elseif stringStartsWith(filterParam, ">=") then
			return aNumber >= anotherNumber
		elseif stringStartsWith(filterParam, "not") then
			return aNumber ~= anotherNumber
		elseif stringStartsWith(filterParam, "!=") then
			return aNumber ~= anotherNumber
		elseif stringStartsWith(filterParam, "~=") then
			return aNumber ~= anotherNumber
		else
			return aNumber == anotherNumber
		end
	end

	if stringStartsWith(filterParam, "<=") then
		return aNumber <= tonumber(string_sub(filterParam, 3))
	elseif stringStartsWith(filterParam, ">=") then
		return aNumber >= tonumber(string_sub(filterParam, 3))
	elseif stringStartsWith(filterParam, ">") then
		return aNumber > tonumber(string_sub(filterParam, 2))
	elseif stringStartsWith(filterParam, "<") then
		return aNumber < tonumber(string_sub(filterParam, 2))
	elseif stringStartsWith(filterParam, "not") then
		return aNumber ~= tonumber(string_sub(filterParam, 4))
	elseif stringStartsWith(filterParam, "!=") then
		return aNumber ~= tonumber(string_sub(filterParam, 3))
	elseif stringStartsWith(filterParam, "~=") then
		return aNumber ~= tonumber(string_sub(filterParam, 3))
	elseif stringStartsWith(filterParam, "==") then
		return aNumber == tonumber(string_sub(filterParam, 3))	
	elseif stringStartsWith(filterParam, "=") then
		return aNumber == tonumber(string_sub(filterParam, 2))
	else
		return aNumber == tonumber(filterParam)
	end
end

function Addon.Rule.Rule:Evaluate (source)
	if (not source) then return nil end
							
	if (
		self.scope and (
		(self.scope == "any") or 
		((self.scope == "friendly") and (source.extra_info.isFriendly)) or
		((self.scope == "group") and (source.extra_info.isGroup)) or
		((self.scope == "enemy") and (source.extra_info.isEnemy))
		)) then
		
		-- note to myself: negator == true means NOT to negate, negator == false negate
		local negator = not (self.filterParam == "false" or self.filterParam == "not" or self.filterParam == "-")
		--[[local negator = true
		self.filterParam, negator = string_gsub(self.filterParam, "not", "")
		if negator > 0 then
			negator = false
		else
			self.filterParam, negatorcount = string_gsub(self.filterParam, "false", "")
			if negator > 0 then
				negator = false
			else
				self.filterParam, negatorcount = string_gsub(self.filterParam, "-", "")
				if negator > 0 then
					negator = false
				else
					negator = true
				end
			end
		end
		self.filterParam,_ = string_gsub(self.filterParam, " ", "")]]--
		
		-- warning: the following statement may harm your mental health
		if (
			(self.filter == "isClass") and 
			(source.extra_info.career ~= nil) and 
			(source.extra_info.career ~= 0) and 
			(string_find(tostring(Addon.CareerNames[source.extra_info.career][2]), self.filterParam))
			) then
			return self.payload	
		elseif (
				(self.filter == "isArchetype") and 
				(source.extra_info.career ~= nil) and 
				(source.extra_info.career ~= 0) and 
				(string_find(tostring(Addon.CareerResourceSettings[source.extra_info.career].ctype), self.filterParam))
				) then
			return self.payload	
		elseif ( (self.filter == "isCurrentValue") and (source.curr ~= nil) ) then
			if stringEndsWith(self.filterParam, "max") then
				if true == compareNumberWithFilterParam(source.curr, self.filterParam, source.max) then
					return self.payload
				end
			elseif true == compareNumberWithFilterParam(source.curr, self.filterParam) then
				return self.payload
			end
		elseif ( (self.filter == "statePercent") and (source.curr ~= nil) and (source.max ~= nil)) then
			if true == compareNumberWithFilterParam((100 * source.curr / source.max), self.filterParam) then
				return self.payload
			end
		elseif ( (self.filter == "relativeLevel") and (source.relative_level ~= nil) ) then
			if true == compareNumberWithFilterParam(source.relative_level, self.filterParam) then
				return self.payload
			end
		--[[elseif (self.filter == "isTargeted") then
			if (source.entity_id ~= nil) and (source.entity_id ~= 0)
			and (source.entity_id == TargetInfo:UnitEntityId("selffriendlytarget")) == negator then
				return self.payload
			end]]--
		elseif (self.filter == "isSelf") then
			if (source.word == GetPlayersName()) == negator then
			--if source.entity_id == GameData.Player.worldObjNum then
				return self.payload
			end
		elseif ( self.filter == "isInCombat" and Addon.States["Combat"] ) then 
			if (1 == Addon.States["Combat"].curr) == negator then
				return self.payload
			end
		elseif ( self.filter == "partySize") then
			local partySize = 0
			for i = 5,1,-1 do
				if PartyUtils.IsPartyMemberValid( i ) then
					partySize = i
					break
				end
			end
			if true == compareNumberWithFilterParam(partySize, self.filterParam) then
				return self.payload
			end
		--[[elseif ( self.filter == "isStateValid" and Addon.States[self.filterParam] ) then 
			if (1 == Addon.States[self.filterParam].valid) == negator then
				return self.payload
			end]]--
		end

		-- sanity style
		if source.extra_info[self.filter] ~= nil then
			if type(source.extra_info[self.filter]) == "boolean" then
				if source.extra_info[self.filter] == negator then
					return self.payload
				end
			elseif type(source.extra_info[self.filter]) == "number" then
				if true == compareNumberWithFilterParam(source.extra_info[self.filter], self.filterParam) then
					return self.payload
				end
			elseif type(source.extra_info[self.filter]) == "string" then
				if source.extra_info[self.filter] == self.filterParam then
					return self.payload
				end
			end
		end

------------------------------------------
-- Delivered from UFBUFFS...
------------------------------------------		
		--[[if source.effectsummary then
			if (source.effectsummary[self.filter] == true) then
				return self.payload
			end
		end]]--
		
------------------------------------------
-- Delivered from Entities API
------------------------------------------
		--[[if (	
				(source.entity_id ~= nil) and 
				(source.entity_id ~= 0) and  
				(source.EntityData ~= nil)
			) then
			if source.EntityData[self.filter] ~= nil then
				-- the filter string exists as key in the EntityData table
				if type(source.EntityData[self.filter]) == "boolean" then
					if source.EntityData[self.filter] == negator then
						return self.payload
					end
				elseif type(source.EntityData[self.filter]) == "number" then
					if true == compareNumberWithFilterParam(source.EntityData[self.filter], self.filterParam) then
						return self.payload
					end
				elseif type(source.EntityData[self.filter]) == "string" then
					if source.EntityData[self.filter] == self.filterParam then
						return self.payload
					end		
				end
			end

		end]]--
		
	end
	return nil
end

function Addon.Rule.RuleSet:new (ruleSetName, ruleType)
	return Addon.Rule.RuleSet:newFromRuleSet (ruleSetName, Addon.Rule.DefaultRuleSet, ruleType)
end

function Addon.Rule.RuleSet:newFromRuleSet (ruleSetName, rule, ruleType)

	--d(ruleSetName)
	--d(rule)
	--d(ruleType)
	if (not Addon.Rules[ruleType]) then Addon.Rules[ruleType] = {} end
	--d(Addon.Rules[ruleType].RuleSets[ruleSetName])
	
	if (nil ~= Addon.Rules[ruleType].RuleSets[ruleSetName]) then
		EA_ChatWindow.Print(L"Cannot create a new rule set for one that exists")
		return nil 
	end
	local self = {}

	if (not Addon.Rules[ruleType].RuleSets[ruleSetName]) then 
		Addon.Rules[ruleType].RuleSets[ruleSetName] = {} 
	end
	
	setmetatable(self, Addon.Rules.RuleSet) -- setup prototye

	self.rules = {}
	self.name = ruleSetName

	Addon.Rules[ruleType].RuleSets[ruleSetName] = self
	
	return self
end

-- From the lua wiki: http://lua-users.org/wiki/CopyTable
function Addon.Rule.deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy( getmetatable(object)))
    end
    return _copy(object)
end