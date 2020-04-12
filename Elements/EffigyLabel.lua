if not Effigy then Effigy = {} end
-- Make addon table ref local for performance
local Addon = Effigy
Addon.Label = {}

local LibGUI = LibStub("LibGUI")

local ipairs = ipairs
local type = type
local wstring_sub = wstring.sub
local wstring_upper = wstring.upper
local wstring_lower = wstring.lower
local string_format = string.format
local math_floor = math.floor

local function WStringSplitInclDelimiter (inString, delimiter)
    local list = {}
    local pos = 1
  
    -- If delimiter is empty, use space as a default...
    if (delimiter == nil or delimiter == L"") then 
       delimiter = L" ";
    end
    
    while 1 do
        local first, last = wstring.find (inString, delimiter, pos, true);
    
        if first then -- found?
            table.insert (list, wstring.sub (inString, pos-1, first - 1));
            pos = last + 1;
        else
            table.insert (list, wstring.sub (inString, pos-1));
            break
        end
    end
  
    return list;
end

local function wstringStartsWith(WString, Start)
	return wstring.sub(WString, 1, wstring.len(Start))==Start
end

local MAX_RANGE
local replaceMap = {

	--[L"$title"] = function(state) return state:GetTitleAsWString() end,
	[L"$title"] = function(state) return (state:GetTitle() or L" ") end,
	--[L"$lvl"] = function(state) return state:GetLevelAsWString() end,
	--[L"$lvl"] = function(state) return state:GetExtraInfoEntryAsWString("level") end,
	[L"$lvl"] = function(state) return state:GetExtraInfo("level") or L" " end,
	--[L"$per"] = function(state) return state:GetPercentageAsWString() end,
	[L"$per"] = function(state) return math_floor(((state:GetValue() or 0)/(state:GetMax() or 0.000000000000000001)*100) + 0.5) end,
    --[L"$value"] = function(state) return state:GetCurrAsWString() end,
	[L"$value"] = function(state) return (state:GetValue() or L" ") end,
    --[L"$max"] = function(state) return state:GetMaxAsWString() end,
	[L"$max"] = function(state) return (state:GetMax() or L" ") end,
    --[L"$missing"] = function(state) return state:GetMissingAsWString() end,
	[L"$missing"] = function(state) return ((state:GetMax() or 0) - (state:GetValue() or 0)) end,
    --[L"$valdetail"] = function(state) return state:GetCurrFormartedAsWString() end,
	[L"$valdetail"] = function(state) return string_format("%.1f", (state:GetValue() or 0)) end,
    --[L"$cr"] = function(state) return state:GetExtraInfoEntryAsWString("cr") end,
	[L"$cr"] = function(state)
			if Addon.CareerNames[state.extra_info.career] then
				return Addon.CareerNames[state.extra_info.career][2]
			else 
				return L""
			end
		end,
    --[L"$career"] = function(state) return state:GetExtraInfoEntryAsWString("career") end,
	[L"$career"] = function(state)
			if Addon.CareerNames[state.extra_info.career] then
				return Addon.CareerNames[state.extra_info.career][1] 
			else 
				return L""
			end
		end,
	-- Range values
    --[L"$rangemin"] = function(state) return state:GetExtraInfoEntryAsWString("RangeMin") end,
	[L"$rangemin"] = function(state) return state:GetExtraInfo("RangeMin") or L" " end,
    --[L"$rangemax"] = function(state) return state:GetExtraInfoEntryAsWString("RangeMax") end,
	[L"$rangemax"] = function(state)
			local lLibRange = LibRange
			if not lLibRange then return L"" end
			if not MAX_RANGE then MAX_RANGE = lLibRange.TargetRange.MAX_RANGE end
			if state.extra_info["RangeMax"] == MAX_RANGE then
				return L"OORS"
			elseif state.extra_info["RangeMax"] == MAX_RANGE + 1 then
				return L"DIST"
			elseif state.extra_info["RangeMax"] == MAX_RANGE + 2 then
				return L"OOZ"
			elseif state.extra_info["RangeMax"] == 0 then
				return L""
			else
				return state.extra_info["RangeMax"] or L" "
			end
		end,
    --[L"$latency"] = function(state) return state:GetExtraInfoEntryAsWString("latency") end,
	[L"$latency"] = function(state) return state:GetExtraInfo("latency") or L" " end,
	--[L"$quest"] = function(state) return state:GetExtraInfoEntryAsWString("quest") end,
	[L"$quest"] = function(state) return state:GetExtraInfo("quest") or L" " end,
	--[L"$npcTitle"] = function(state) return state:GetExtraInfoEntryAsWString("npcTitle") end,
	[L"$npcTitle"] = function(state) return state:GetExtraInfo("npcTitle") or L" " end,
}

-- this is so waffle
local function ParseLabel(barState,s)
	--s = towstring(s)
	local tt = WStringSplitInclDelimiter(s, L"$")
	for k,v in ipairs(tt) do
		if v == L"" then table.remove(tt, k) end
	end
	for k,v in ipairs(tt) do
		for k2,_ in pairs(replaceMap) do
			local tt2 = WStringSplit (v, k2)
			if #tt2 == 2 then
				--tt2[1] = k2
				tt[k] = k2
				if tt2[2] ~= L"" then
					table.insert(tt, k+1, tt2[2])
				end
				--d(tt2)
			end
		end
	end
	for k,v in ipairs(tt) do
		if wstringStartsWith(v, L".") and wstringStartsWith(tt[k-1], L"$") then
			for stateName, state in pairs(Addon.States) do
				local tt2 = WStringSplit (v, L"."..towstring(stateName))
				if #tt2 == 2 then
					if tt2[2] ~= L"" then
						table.insert(tt, k+1, tt2[2])
					end
					--tt[k] = state
					--tt[k] = function() replaceMap[tt[k-1] ](state) end
					
					if tt[k-1] == L"$title" then
						--tt[k] = function() return state:GetTitleAsWString() end
						tt[k] = function() return (state:GetTitle() or L" ") end
					elseif tt[k-1] == L"$lvl" then
						--tt[k] = function() return state:GetLevelAsWString() end
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("level") end
						tt[k] = function() return state:GetExtraInfo("level") or L" " end
					elseif tt[k-1] == L"$per" then
						--tt[k] = function() return state:GetPercentageAsWString() end
						tt[k] = function() return math_floor(((state:GetValue() or 0)/(state:GetMax() or 0.000000000000000001)*100) + 0.5) end
					elseif tt[k-1] == L"$value" then
						--tt[k] = function() return state:GetCurrAsWString() end
						tt[k] = function() return (state:GetValue() or L" ") end
					elseif tt[k-1] == L"$max" then
						--tt[k] = function() return state:GetMaxAsWString() end
						tt[k] = function() return (state:GetMax() or L" ") end
					elseif tt[k-1] == L"$missing" then
						--tt[k] = function() return state:GetMissingAsWString() end
						tt[k] = function() return ((state:GetMax() or 0) - (state:GetValue() or 0)) end
					elseif tt[k-1] == L"$valdetail" then
						--tt[k] = function() return state:GetCurrFormartedAsWString() end
						tt[k] = function() return string_format("%.1f", (state:GetValue() or 0)) end
					elseif tt[k-1] == L"$cr" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("cr") end
						tt[k] = function()
								if Addon.CareerNames[state.extra_info.career] then
									return (Addon.CareerNames[state.extra_info.career][2]) 
								else 
									return L""
								end
							end
					elseif tt[k-1] == L"$career" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("career") end
						tt[k] = function()
							if Addon.CareerNames[state.extra_info.career] then
								return Addon.CareerNames[state.extra_info.career][1] 
							else 
								return L""
							end
						end
					elseif tt[k-1] == L"$rangemin" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("RangeMin") end
						tt[k] = function() return state:GetExtraInfo("RangeMin") or L" " end
					elseif tt[k-1] == L"$rangemax" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("RangeMax") end
						tt[k] = function()
							local lLibRange = LibRange
							if not lLibRange then return L"" end
							if not MAX_RANGE then MAX_RANGE = lLibRange.TargetRange.MAX_RANGE end
							if state.extra_info["RangeMax"] == MAX_RANGE then
								return L"OORS"
							elseif state.extra_info["RangeMax"] == MAX_RANGE + 1 then
								return L"DIST"
							elseif state.extra_info["RangeMax"] == MAX_RANGE + 2 then
								return L"OOZ"
							elseif state.extra_info["RangeMax"] == 0 then
								return L""
							else
								return state.extra_info["RangeMax"] or L" "
							end
						end
					elseif tt[k-1] == L"$latency" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("latency") end
						tt[k] = function() return state:GetExtraInfo("latency") or L" " end
					elseif tt[k-1] == L"$quest" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("quest") end
						tt[k] = function() return state:GetExtraInfo("quest") or L" " end
					elseif tt[k-1] == L"$npcTitle" then
						--tt[k] = function() return state:GetExtraInfoEntryAsWString("npcTitle") end
						tt[k] = function() return state:GetExtraInfo("npcTitle") or L" " end
					end
					
					--table.remove(tt, k-1)	-- can I do that in the iter?
					tt[k-1] = L""
				end
			end
		end
	end
	for k,v in ipairs(tt) do
		if v == L"" then
			table.remove(tt, k)
		end
	end
	local state = EffigyState:GetState(barState)
	for k,v in ipairs(tt) do
		--tt[k] = function() replaceMap[tt[k-1] ](state) end
		if v == L"$title" then
			--tt[k] = function() return state:GetTitleAsWString() end
			tt[k] = function() return (state:GetTitle() or L" ") end
		elseif v == L"$lvl" then
			--tt[k] = function() return state:GetLevelAsWString() end
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("level") end
			tt[k] = function() return state:GetExtraInfo("level") or L" " end
		elseif v == L"$per" then
			--tt[k] = function() return state:GetPercentageAsWString() end
			tt[k] = function() return math_floor(((state:GetValue() or 0)/(state:GetMax() or 0.000000000000000001)*100) + 0.5) end
		elseif v == L"$value" then
			--tt[k] = function() return state:GetCurrAsWString() end
			tt[k] = function() return (state:GetValue() or L" ") end
		elseif v == L"$max" then
			--tt[k] = function() return state:GetMaxAsWString() end
			tt[k] = function() return (state:GetMax() or L" ") end
		elseif v == L"$missing" then
			--tt[k] = function() return state:GetMissingAsWString() end
			tt[k] = function() return ((state:GetMax() or 0) - (state:GetValue() or 0)) end
		elseif v == L"$valdetail" then
			--tt[k] = function() return state:GetCurrFormartedAsWString() end
			tt[k] = function() return string_format("%.1f", (state:GetValue() or 0)) end
		elseif v == L"$cr" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("cr") end
			tt[k] = function()
					if Addon.CareerNames[state.extra_info.career] then
						return (Addon.CareerNames[state.extra_info.career][2]) 
					else 
						return L""
					end
				end
		elseif v == L"$career" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("career") end
			tt[k] = function()
					if Addon.CareerNames[state.extra_info.career] then
						return Addon.CareerNames[state.extra_info.career][1] 
					else 
						return L""
					end
				end
		elseif v == L"$rangemin" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("RangeMin") end
			tt[k] = function() return state:GetExtraInfo("RangeMin") or L" " end
		elseif v == L"$rangemax" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("RangeMax") end
			tt[k] = function()
					local lLibRange = LibRange
					if not lLibRange then return L"" end
					if not MAX_RANGE then MAX_RANGE = lLibRange.TargetRange.MAX_RANGE end
					if state.extra_info["RangeMax"] == MAX_RANGE then
						return L"OORS"
					elseif state.extra_info["RangeMax"] == MAX_RANGE + 1 then
						return L"DIST"
					elseif state.extra_info["RangeMax"] == MAX_RANGE + 2 then
						return L"OOZ"
					elseif state.extra_info["RangeMax"] == 0 then
						return L""
					else
						return state.extra_info["RangeMax"] or L" "
					end
				end
		elseif v == L"$latency" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("latency") end
			tt[k] = function() return state:GetExtraInfo("latency") or L" " end
		elseif v == L"$quest" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("quest") end
			tt[k] = function() return state:GetExtraInfo("quest") or L" " end
		elseif v == L"$npcTitle" then
			--tt[k] = function() return state:GetExtraInfoEntryAsWString("npcTitle") end
			tt[k] = function() return state:GetExtraInfo("npcTitle") or L" " end
		end
	end
	
	-- debug
	--[[DEBUG(L"SOURCE: "..s)
	d(tt)
	local result = L""
	for _,v in ipairs(tt) do
		if type(v) == "wstring" then
			result = result..v
		elseif type(v) == "function" then
			result = result..(v() or L"")
		end
	end
	DEBUG(L"RESULT: "..result)
	d("------------------------------------")]]--
	-- Wer das liest erklärt mich für verrückt
	return tt
end

local function Setup(self)
	local settings = self.Settings
	local container = self.Container
	local containerName = container.name
	self.labelContentTable = ParseLabel(container.state, towstring(settings.formattemplate))
	
	--
	-- WINDOW attributes
	--
	if settings.parent == nil or settings.parent == "" then
		self:Parent(containerName) -- this will stay unconfigurable for a while
	else
		self:Parent(container:GetFrameNameFromCBoxString(settings.parent))			
	end

	local anchor1settings = settings.anchors[1]
	if ((anchor1settings.x ~= nil) and (anchor1settings.y ~= nil)) then
		self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, anchor1settings.x, anchor1settings.y)
	else
		self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, 0, 0)
	end
	
	self:Layer(settings.layer)
	--self:Popable(settings.Popable)
	self:Alpha(settings.alpha)
	self:Scale(WindowGetScale(containerName) * settings.scale)	-- DONOTTOUCH
	
	local l_width = settings.width
	if (0 == l_width) then l_width = container.width end
	self:Resize(l_width, settings.height)
	
	--
	-- LABEL attributes
	--
	self.Label:Clear()
	self.Label:Font(settings.font.name)
	--self:WordWrap(settings.font.WordWrap)
	self.Label:Align(settings.font.align)
	
	if settings.colorsettings.ColorPreset ~= nil and settings.colorsettings.ColorPreset ~= "" and settings.colorsettings.ColorPreset ~= "none" then
		local ColorPreset = RVMOD_GColorPresets.GetColorPreset(settings.colorsettings.ColorPreset)
		self.Label:Color(ColorPreset.r, ColorPreset.g, ColorPreset.b)
	else
		self.Label:Color(settings.colorsettings.color.r, settings.colorsettings.color.g, settings.colorsettings.color.b)
	end

	--
	-- Window attributes reprise
	--
	if (true == settings.show) then self:Show() else self:Hide() end
end

local function Render(self)
	--
	-- LABEL attributes
	--	
	local text = L""
	local settings = self.Settings
	local container = self.Container
	local state = Addon.States[container.state]
	local l = self.Label
	for _,v in ipairs(self.labelContentTable) do
		local theType = type(v)
		if theType == "wstring" then
			text = text..v
		elseif theType == "function" then
			text = text..(towstring(v()) or L"")
		end
	end
	text = wstring.sub(text, 1, settings.clip_after or 14)
	
	if settings.font.case == "upper" then
		text = wstring.upper(text)
	elseif settings.font.case == "lower" then
		text = wstring.lower(text)
	end

	l:SetText(text)
	l:Color(container:getRenderColor(settings.colorsettings, state))
	local dynamicAlpha = container:getRenderAlpha(settings, state)
	if dynamicAlpha ~= nil then	self:Alpha(dynamicAlpha) end
	local dynamicVisibility = container:getRenderVisibility(settings, state)
	if dynamicVisibility ~= nil then
		if dynamicVisibility == true then	
			self:Show()
		else
			self:Hide()
		end
	end
end
		
function Addon.Label.Create(bar, name)
	if not UF_RUNTIMECACHE[bar.name].Labels then UF_RUNTIMECACHE[bar.name].Labels = {} end
	local w = UF_RUNTIMECACHE[bar.name].Labels[name]
	if w then return w end	-- label already exists
	
	-- we need to encapsulate the label in a window for proper scaling
	w = LibGUI("window", bar.name.."Label"..name, "EffigyEmpty")
	w.Label = LibGUI("Label", w.name.."Label")
	w.Label:Parent(w)
	w.Label:AnchorTo(w, "topleft", "topleft", 0, 0)
	w.Label:AddAnchor(w, "bottomright", "bottomright", 0, 0)
	
	w:IgnoreInput()
	w.Label:IgnoreInput()
	
	w.Container = bar
	w.Settings = bar.labels[name] --or Addon.GetDefaultLabel()
	
	w.Setup = Setup
	w.Render = Render
	
	return w
end