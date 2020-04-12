if not Effigy then Effigy = {} end
local CoreAddon = Effigy
if not EffigyConfigGui then EffigyConfigGui = {} end
local Addon = EffigyConfigGui
if (nil == Addon.Name) then Addon.Name = "EffigyConfigGui" end
local LibGUI = LibStub("LibGUI")

Addon.Rules = {}
Addon.Rules.W = nil

local SettingsWindow = Addon.Name.."RulesWindowSettings"

--------------------------------------------------------------
-- function InitializeSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.Rules.InitializeSettingsWindow(ParentWindow)

	-- First step: create window from template
	CreateWindowFromTemplate(SettingsWindow, Addon.Name.."RulesTemplate", "Root")
	LabelSetText(SettingsWindow.."TitleBarText", L"Rules & Rulesets")
	ButtonSetText(SettingsWindow.."ButtonOK", L"OK")

	-- Third step: set tab buttons

	ButtonSetText(SettingsWindow.."TabColor", L"Color")
	ButtonSetText(SettingsWindow.."TabTexture", L"Texture")
	ButtonSetText(SettingsWindow.."TabVisibility", L"Visibility")
	ButtonSetText(SettingsWindow.."TabAlpha", L"Alpha")

	ButtonSetPressedFlag(SettingsWindow.."TabColor", true)
	ButtonSetPressedFlag(SettingsWindow.."TabTexture", false)
	ButtonSetPressedFlag(SettingsWindow.."TabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."TabAlpha", false)
end

--------------------------------------------------------------
-- function ShowModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.Rules.ShowModuleSettings()

	-- First step: check for window
	if not DoesWindowExist(SettingsWindow) then
		Addon.Rules.InitializeSettingsWindow("root")--ModuleWindow)
	end

	-- Second step: update fields with the current configuration 
	--Addon.Rules.UpdateSettingsWindow()

	-- Final step: show everything
	WindowSetShowing(SettingsWindow, true)
	Addon.Rules.OnClickTabColor()
end

--------------------------------------------------------------
-- function HideModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.Rules.HideModuleSettings()

	-- Final step: hide window
	WindowSetShowing(SettingsWindow, false)
end


--------------------------------------------------------------
-- Description:
-- 				OnClick Handlers
--------------------------------------------------------------

function Addon.Rules.OnClickCloseSettings()
	Addon.Rules.HideModuleSettings()
end

function Addon.Rules.OnClickTabColor()
	ButtonSetPressedFlag(SettingsWindow.."TabColor", true)
	ButtonSetPressedFlag(SettingsWindow.."TabTexture", false)
	ButtonSetPressedFlag(SettingsWindow.."TabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."TabAlpha", false)
	--Addon.Rules.ColourSettings.Create()
	Addon.Rules.Settings.Create("Colors")
end

function Addon.Rules.OnClickTabTexture()
	ButtonSetPressedFlag(SettingsWindow.."TabColor", false)
	ButtonSetPressedFlag(SettingsWindow.."TabTexture", true)
	ButtonSetPressedFlag(SettingsWindow.."TabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."TabAlpha", false)
	--Addon.Rules.TexturesSettings.Create()
	Addon.Rules.Settings.Create("Textures")
end

function Addon.Rules.OnClickTabVisibility()
	ButtonSetPressedFlag(SettingsWindow.."TabColor", false)
	ButtonSetPressedFlag(SettingsWindow.."TabTexture", false)
	ButtonSetPressedFlag(SettingsWindow.."TabVisibility", true)
	ButtonSetPressedFlag(SettingsWindow.."TabAlpha", false)
	--Addon.Rules.VisibilitySettings.Create()
	Addon.Rules.Settings.Create("Visibility")
end

function Addon.Rules.OnClickTabAlpha()
	ButtonSetPressedFlag(SettingsWindow.."TabColor", false)
	ButtonSetPressedFlag(SettingsWindow.."TabTexture", false)
	ButtonSetPressedFlag(SettingsWindow.."TabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."TabAlpha", true)
	Addon.Rules.Settings.Create("Alpha")
end

--
-- Window functions
--
local function CreateEditSettingsRuleEnd(w)
	Addon.Rules.R = w
	Addon.Rules.R:Show()
end

local function CreateEditSettingsRulesEnd(w)
	Addon.Rules.Rs = w
	Addon.Rules.Rs:Show()
end

local function DestroyEditRuleSettings()
	if (nil ~= Addon.Rules.R) then
		Addon.Rules.R:Destroy()
	end
	if DoesWindowExist(SettingsWindow.."RulePopUp") then
		WindowUnregisterCoreEventHandler(SettingsWindow.."RulePopUpButtonOK", "OnLButtonUp")
		WindowUnregisterCoreEventHandler(SettingsWindow.."RulePopUpButtonClose", "OnLButtonUp")
		DestroyWindow(SettingsWindow.."RulePopUp")
	end
end

local function DestroyEditRulesSettings()
	if (nil ~= Addon.Rules.Rs) then
		Addon.Rules.Rs:Destroy()
	end
	if (nil ~= Addon.R) then
		Addon.Rules.R:Destroy()
	end
end

local function CreateEditRulesSettingsStart()
	local w = {}
	w = LibGUI("window")
	--w:MakeMovable()
	--w:Resize(695, 440)
	--w:AnchorTo(SettingsWindow, "top", "top", 0, 70)
	w:AnchorTo(SettingsWindow.."Tab", "bottomleft", "topleft", 0, 0)
	w:AddAnchor(SettingsWindow.."ButtonBackground", "topright", "bottomright", 0, 0)
	w:Parent(SettingsWindow)
	
	if (nil ~= Addon.Rules.Settings.W) then
		Addon.Rules.Settings.W:Destroy()
	end
	
	if (nil ~= Addon.Rules.Rs) then
		DestroyEditRulesSettings()
	end

	if (nil ~= Addon.Rules.R) then
		DestroyEditRuleSettings()
	end
	--[[
	w.bCloseButton = w("Closebutton")
	w.bCloseButton.OnLButtonUp =
	function()
		
		Addon.Rules.DestroyEditRulesSettings()
	end
	]]--
	
	-- Create Common Labels
	-- Rules
	w.lRules = w("Label", SettingsWindow.."LabelRules")
	w.lRules:Resize(130)
	w.lRules:Position(25,10)
	w.lRules:Font(Addon.FontHeadline)
	w.lRules:SetText(L"Rules:")
	w.lRules:IgnoreInput()
	w.lRules:Align("left")

	-- Create new rule
	w.lCreateRule = w("Label", SettingsWindow.."LabelRulesCreate", "EffigyAutoresizeLabelTemplate")
	--w.lCreateRule:Resize(140)
	w.lCreateRule:AnchorTo(w.lRules, "right", "left", 0, 0)
	w.lCreateRule:Font(Addon.FontText)
	w.lCreateRule:SetText(L"Create:")
	w.lCreateRule:IgnoreInput()
	w.lCreateRule:Align("left")
	
	-- Edit Rule
	w.lEditRule = w("Label", SettingsWindow.."LabelRulesEdit", "EffigyAutoresizeLabelTemplate")
	--w.lEditRule:Resize(140)
	w.lEditRule:AnchorTo(w.lCreateRule, "bottomleft", "topleft", 0, 50)
	w.lEditRule:Font(Addon.FontText)
	w.lEditRule:SetText(L"Edit:")
	w.lEditRule:IgnoreInput()
	w.lEditRule:Align("left")

	-- RuleSets
	w.lRuleSet = w("Label", SettingsWindow.."LabelRuleSets")
	w.lRuleSet:Resize(130)
	w.lRuleSet:AnchorTo(w.lRules, "bottomleft", "topleft", 0, 120)
	w.lRuleSet:Font(Addon.FontHeadline)
	w.lRuleSet:SetText(L"Rule Sets:")
	w.lRuleSet:IgnoreInput()
	w.lRuleSet:Align("left")
	
	-- Create new RuleSet
	w.lCreateRuleSet = w("Label", SettingsWindow.."LabelRuleSetsCreate", "EffigyAutoresizeLabelTemplate")
	--w.lCreateRuleSet:Resize(140)
	w.lCreateRuleSet:AnchorTo(w.lRuleSet, "right", "left", 0, 0)
	w.lCreateRuleSet:Font(Addon.FontText)
	w.lCreateRuleSet:SetText(L"Create:")
	w.lCreateRuleSet:IgnoreInput()
	w.lCreateRuleSet:Align("left")
	
	-- Edit RuleSet
	w.lEditRuleSet = w("Label", SettingsWindow.."LabelRuleSetsEdit", "EffigyAutoresizeLabelTemplate")
	--w.lEditRuleSet:Resize(140)
	w.lEditRuleSet:AnchorTo(w.lCreateRuleSet, "bottomleft", "topleft", 0, 50)
	w.lEditRuleSet:Font(Addon.FontText)
	w.lEditRuleSet:SetText(L"Edit:")
	w.lEditRuleSet:IgnoreInput()
	w.lEditRuleSet:Align("left")
	
	return w
end

-- Generic
Addon.Rules.Settings = {}

function Addon.Rules.Settings.ConditionalDeleteRule(ruleType, isRuleSet, name)
	local target
	if isRuleSet then
		target = CoreAddon.Rules[ruleType].RuleSets[name]
	else
		target = CoreAddon.Rules[ruleType].Rules[name]
	end
	if target then				
		local text = GetStringFormat (StringTables.Default.LABEL_TEXT_DESTROY_ITEM_CONFIRM, { name } )
		DialogManager.MakeTwoButtonDialog(
		text,
		GetString( StringTables.Default.LABEL_YES ),
		function()
			CoreAddon.DeleteRule(ruleType, isRuleSet, name)
			local w = Addon.Rules.Settings.W
			if w and w.name then
				-- refresh rules combobox
				w.cEdit:Clear()
				local tt={}
				for k,_ in pairs(CoreAddon.Rules[ruleType].Rules) do table.insert(tt, k) end
				table.sort(tt)
				for _,v in ipairs(tt) do w.cEdit:Add(v) end
				-- refresh rulesets comobobox
				w.cEditRs:Clear()
				tt={}
				for k,_ in pairs(CoreAddon.Rules[ruleType].RuleSets) do table.insert(tt, k) end
				table.sort(tt)
				for _,v in ipairs(tt) do w.cEditRs:Add(v) end
			end
			--Addon.UpdateLibAddonButton()
			--if DoesWindowExist(Addon.Name.."SettingsWindow") then Addon.UpdateSettingsWindow() end
		end, 
		GetString( StringTables.Default.LABEL_NO ))
	else
		EA_ChatWindow.Print(L"Error with Selected Item")
	end
end

function Addon.Rules.Settings.Create(ruleType)
	local w = CreateEditRulesSettingsStart()
	
	-- Create Rule
	w.tCreate = w("Textbox")
	w.tCreate:Resize(250)
	w.tCreate:AnchorTo(w.lCreateRule, "bottomleft", "topleft", 0, 10)

	w.btCreate = w("Button", nil, Addon.ButtonInherits)
	w.btCreate:Resize(Addon.ButtonWidth)
	w.btCreate:SetText(L"Create")
	w.btCreate:AnchorTo(w.tCreate, "right", "left", 10, 0)
	w.btCreate.OnLButtonUp = 
		function()
			if (nil ~= w.tCreate:GetText()) and (L"" ~= w.tCreate:GetText()) then
				local ruleName = WStringToString(w.tCreate:GetText())
			    if CoreAddon.Rule.Rule:new(ruleName, ruleType) ~= nil then
					w.cEdit:Add(w.tCreate:GetText())
				end
			end
		end


	-- Edit Rule
	w.cEdit = w("Combobox")
	w.cEdit:AnchorTo(w.lEditRule, "bottomleft", "topleft", 0, 10)
	--[[local tt={}
	for k,_ in pairs(CoreAddon.Rules[ruleType].Rules) do table.insert(tt, k) end
	table.sort(tt)]]--
	for _,v in ipairs(Addon.Rules.GetNameTableForCombobox(ruleType, false)) do w.cEdit:Add(v) end
	

	w.btEdit = w("Button", nil, Addon.ButtonInherits)
	w.btEdit:Resize(Addon.ButtonWidth)
	w.btEdit:SetText(L"Edit")
	w.btEdit:AnchorTo(w.cEdit, "right", "left", 10, 0)
	w.btEdit.OnLButtonUp = 
		function()
			if (nil ~= w.cEdit:Selected()) and (L"" ~= w.cEdit:Selected()) then
				Addon.Rules.EditRule.Create(ruleType, WStringToString(w.cEdit:Selected()))
			end
		end
	
	w.btDelete = w("Button", nil, Addon.ButtonInherits)
	w.btDelete:Resize(Addon.ButtonWidth)
	w.btDelete:SetText(L"Delete")
	w.btDelete:AnchorTo(w.btEdit, "right", "left", 10, 0)
	w.btDelete.OnLButtonUp = 
		function()
			local selected = w.cEdit:Selected()
			if (nil ~= selected) and (L"" ~= selected) then
				Addon.Rules.Settings.ConditionalDeleteRule(ruleType, false, WStringToString(selected))
			end
		end
		
	-- Create RuleSet
	w.tCreateRs = w("Textbox")
	w.tCreateRs:Resize(250)
	w.tCreateRs:AnchorTo(w.lCreateRuleSet, "bottomleft", "topleft", 0, 10)


	w.btCreateRs = w("Button", nil, Addon.ButtonInherits)
	w.btCreateRs:Resize(Addon.ButtonWidth)
	w.btCreateRs:SetText(L"Create")
	w.btCreateRs:AnchorTo(w.tCreateRs, "right", "left", 10, 0)
	w.btCreateRs.OnLButtonUp = 
		function()
			if (nil ~= w.tCreateRs:GetText()) and (L"" ~= w.tCreateRs:GetText()) then
				local ruleName = WStringToString(w.tCreateRs:GetText())
			    CoreAddon.Rule.RuleSet:new (ruleName, ruleType)
				w.cEditRs:Add(w.tCreateRs:GetText())
			end
		end


	-- Edit RuleSet
	w.cEditRs = w("Combobox")
	w.cEditRs:AnchorTo(w.lEditRuleSet, "bottomleft", "topleft", 0, 10)
	--[[tt={}
	for k,_ in pairs(CoreAddon.Rules[ruleType].RuleSets) do table.insert(tt, k) end
	table.sort(tt)]]--
	for _,v in ipairs(Addon.Rules.GetNameTableForCombobox(ruleType, true)) do w.cEditRs:Add(v) end

	w.btEditRs = w("Button", nil, Addon.ButtonInherits)
	w.btEditRs:Resize(Addon.ButtonWidth)
	w.btEditRs:SetText(L"Edit")
	w.btEditRs:AnchorTo(w.cEditRs, "right", "left", 10, 0)
	w.btEditRs.OnLButtonUp = 
		function()
			if (nil ~= w.cEditRs:Selected()) and (L"" ~= w.cEditRs:Selected()) then
				--Addon.Rules.AlphaSettings.EditAlphaRuleSet.Create(WStringToString(w.cEditRs:Selected()),w)
				Addon.Rules.EditRuleSet.Create(ruleType, WStringToString(w.cEditRs:Selected()))
			end
		end

	w.btDeleteRs = w("Button", nil, Addon.ButtonInherits)
	w.btDeleteRs:Resize(Addon.ButtonWidth)
	w.btDeleteRs:SetText(L"Delete")
	w.btDeleteRs:AnchorTo(w.btEditRs, "right", "left", 10, 0)
	w.btDeleteRs.OnLButtonUp = 
		function()
			local selected = w.cEditRs:Selected()
			if (nil ~= selected) and (L"" ~= selected) then
				Addon.Rules.Settings.ConditionalDeleteRule(ruleType, true, WStringToString(selected))
			end
		end		
	
	Addon.Rules.Settings.W = w
	Addon.Rules.Settings.W :Show()
	--CreateEditSettingsRulesEnd(w)
end

function Addon.Rules.Settings.Destroy()
	--Addon.Rules.DestroyEditRulesSettings()
	if (nil ~= Addon.Rules.Settings.W) then
		Addon.Rules.Settings.W:Destroy()
	end
end

-- Generic

Addon.Rules.EditRule = {}
function Addon.Rules.EditRule.Create(ruleType, ruleName)
	local w, bar = Addon.Rules.CreateEditRuleSettingsStart()
	local ruleSet = CoreAddon.Rules[ruleType].Rules[ruleName] or CoreAddon.GetRuleFactoryPreset(ruleType, false, ruleName)
	
	LabelSetText(SettingsWindow.."RulePopUpTitleBarText", towstring(ruleSet.name))
	
	w.lEnable = w("Label")
	w.lEnable:Resize(175)
	w.lEnable:Position(10,5)
	w.lEnable:Font(Addon.FontText)
	w.lEnable:SetText(L"Enable:")
	w.lEnable:Align("left")
	w.lEnable.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lEnable, "Enables or disables this rule")
		end

	w.cEnable = w("Checkbox")
	w.cEnable:AnchorTo(w.lEnable, "right", "left", 20, 0)
	if (nil ~= ruleSet.enabled) and (true == ruleSet.enabled) then
		w.cEnable:Check()
	end


	w.lScope = w("Label")
	w.lScope:Resize(175)
	w.lScope:AnchorTo(w.lEnable, "bottomleft", "topleft", 0, 5)
	w.lScope:Font(Addon.FontText)
	w.lScope:SetText(L"Scope:")
	w.lScope:Align("left")
	w.lScope.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lScope, "Only apply this rule to the selected type")
		end
	
	w.cScope = w("Combobox")
	w.cScope:AnchorTo(w.lScope, "right", "left", 20, 0)
	w.cScope:Add("any")
	w.cScope:Add("friendly")
	--w.cScope:Add("friendlytarget")
	w.cScope:Add("group")
	w.cScope:Add("enemy")
	--w.cScope:Add("enemytarget")
	--w.cScope:Add("self")
	w.cScope:Select(ruleSet.scope)
	
	w.lFilter = w("Label")
	w.lFilter:Resize(175)
	w.lFilter:AnchorTo(w.lScope, "bottomleft", "topleft", 0, 5)
	w.lFilter:Font(Addon.FontText)
	w.lFilter:SetText(L"Filter:")
	w.lFilter:Align("left")
	w.lFilter.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lFilter, "Only apply this rule to the selected filter matches")
		end
	
	w.cFilter = w("Combobox")
	w.cFilter:AnchorTo(w.lFilter, "right", "left", 20, 0)
	Addon.FillRulesDropdown(w.cFilter)
	w.cFilter:Select(ruleSet.filter)

	w.lFilterParam = w("Label")
	w.lFilterParam:Resize(175)
	w.lFilterParam:AnchorTo(w.lFilter, "bottomleft", "topleft", 0, 5)
	w.lFilterParam:Font(Addon.FontText)
	w.lFilterParam:SetText(L"Filter Param:")
	w.lFilterParam:Align("left")
	w.lFilterParam.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lFilterParam, "Some filters require a parameter")
		end
		
	w.tFilterParam = w("Textbox")
	w.tFilterParam:Resize(180)
	w.tFilterParam:AnchorTo(w.lFilterParam, "right", "left", 20, 0)
	w.tFilterParam:SetText(ruleSet.filterParam)
	
	w.lPayload = w("Label")
	w.lPayload:Resize(175)
	w.lPayload:AnchorTo(w.lFilterParam, "bottomleft", "topleft", 0, 5)
	w.lPayload:Font(Addon.FontText)
	w.lPayload:Align("left")
	w.lPayload.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lPayload, "Select the", "alpha/color/visibility/texture", "that this rule should apply.")
		end

	if (ruleSet.payload == nil or ruleSet.payload == "" or ruleSet.payload == L"" or ruleSet.payload == "none") then
		if ruleType == "Alpha" then
			ruleSet.payload = 1
		elseif ruleType == "Visibility" then
			ruleSet.payload = true
		elseif ruleType == "Textures" then
			ruleSet.payload = "none"
		elseif ruleType == "Colors" then
			ruleSet.payload = "default"	
		end
	end
	
	if ruleType == "Alpha" then
		w.lPayload:SetText(L"Alpha:")
		w.payload = w("Textbox")
		w.payload:Resize(60)
		w.payload:SetText(ruleSet.payload)
	elseif ruleType == "Visibility" then
		w.lPayload:SetText(L"Visibility:")
		w.payload = w("tinycombobox")
		w.payload:Clear()
		w.payload:Add("show")
		w.payload:Add("hide")
		if (ruleSet.payload) then
			w.payload:Select("show")
		else
			w.payload:Select("hide")
		end
	elseif ruleType == "Textures" then
		w.lPayload:SetText(L"Texture:")
		w.payload = w("Combobox")
		Addon.FillTextureDropdown(w.payload)
		w.payload:Select(ruleSet.payload)
	elseif ruleType == "Colors" then
		w.lPayload:SetText(L"Color:")
		w.payload = w("Combobox")
		w.payload:Clear()
		for _,v in ipairs(RVMOD_GColorPresets.GetColorPresetList()) do
			w.payload:Add(v)
		end
		w.payload:Select(ruleSet.payload)
	end	
	w.payload:AnchorTo(w.lPayload, "right", "left", 20, 0)
	
	
	w.lPrio = w("Label")
	w.lPrio:Resize(175)
	w.lPrio:AnchorTo(w.lPayload, "bottomleft", "topleft", 0, 5)
	w.lPrio:Font(Addon.FontText)
	w.lPrio:SetText(L"Priority:")
	w.lPrio:Align("left")
	w.lPrio.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lPrio, "Priority for this rule. Lower is more important. Range 1..10")
		end
		
	w.tPrio = w("Textbox")
	w.tPrio:Resize(50)
	w.tPrio:AnchorTo(w.lPrio, "right", "left", 20, 0)
	w.tPrio:SetText(ruleSet.priority)
	
	w.ab1 = w("Button", nil, Addon.ButtonInherits)
	w.ab1:Resize(Addon.ButtonWidth)
	w.ab1:SetText(L"Apply")
	w.ab1:AnchorTo(w.lPrio, "bottomleft", "topleft", 20, 20)
	w.ab1.OnLButtonUp = 
		function()
			local prio = tonumber(WStringToString(w.tPrio:GetText()))
			if (prio == nil) then prio = 1 end
						
			local payload
			if ruleType == "Alpha" then
				payload = tonumber(WStringToString(w.payload:GetText()))
				if (payload == nil) then payload = 1 end
			elseif ruleType == "Visibility" then
				if (  WStringToString(w.payload:Selected()) == "hide") then
					payload = false
				else
					payload = true
				end
			elseif ruleType == "Textures" or ruleType == "Colors" then
				payload = WStringToString(w.payload:Selected())
			end
			
			local tt = {}
			tt.enabled = w.cEnable:GetValue()
			tt.scope =  WStringToString(w.cScope:Selected())
			tt.filter =  WStringToString(w.cFilter:Selected())
			tt.filterParam = WStringToString(w.tFilterParam:GetText())
			tt.priority = prio
			tt.payload = payload
			
			local factoryPreset = CoreAddon.GetRuleFactoryPreset(ruleType, false, ruleName)			
			if factoryPreset then
				local isIdentical = true
				for k,v in pairs(factoryPreset) do
					if tt[k] ~= v then
						isIdentical = false
						break
					end
				end
				if isIdentical then
					if CoreAddon.Rules[ruleType].Rules[ruleName] then
						CoreAddon.Rules[ruleType].Rules[ruleName] = nil
					end
				else
					CoreAddon.Rules[ruleType].Rules[ruleName] = tt
				end
			else
				CoreAddon.Rules[ruleType].Rules[ruleName] = tt
			end
			
			CoreAddon.UpdateRuleCache(ruleType)
		end		
	Addon.Rules.CreateEditSettingsRuleEnd(w)
end

Addon.Rules.EditRuleSet = {}
function Addon.Rules.EditRuleSet.Create(ruleType, setName)
	local w = Addon.Rules.CreateEditRuleSettingsStart()
	local ruleSet = CoreAddon.Rules[ruleType].RuleSets[setName] or CoreAddon.GetRuleFactoryPreset(ruleType, true, setName)
	
	LabelSetText(SettingsWindow.."RulePopUpTitleBarText", towstring(ruleSet.name))

	w.lRules = w("Label")
	w.lRules:Resize(250)
	w.lRules:Position(20,10)
	w.lRules:Font(Addon.FontText)
	w.lRules:SetText(L"Rules in this ruleset:")
	w.lRules:Align("left")
	
	w.cRules = w("Combobox")
	w.cRules:AnchorTo(w.lRules, "bottomleft", "topleft", 0, 5)
	--[[tt={}
	table.foreach(CoreAddon.Rules[ruleType].RuleSets[setName].rules,
		function (k,b)		
				table.insert (tt, k) 
		end)
	table.sort(tt)]]--
	for k,_ in pairs(ruleSet.rules) do w.cRules:Add(k) end
	--w.cRules:Select(setName)

	w.bRemove = w("Button", nil, Addon.ButtonInherits)
	w.bRemove:Resize(Addon.ButtonWidth)
	w.bRemove:SetText(L"Remove")
	w.bRemove:AnchorTo(w.cRules, "right", "left", 10, 0)
	w.bRemove.OnLButtonUp = 
		function()
			if (nil ~= w.cRules:Selected()) and (L"" ~= w.cRules:Selected()) then
				if not CoreAddon.Rules[ruleType].RuleSets[setName] then	-- it´s a factory preset being modified
					CoreAddon.Rules[ruleType].RuleSets[setName] = CoreAddon.deepcopy(CoreAddon.GetRuleFactoryPreset(ruleType, true, setName)) -- deepcopy necessary?
				end
				CoreAddon.Rules[ruleType].RuleSets[setName].rules[WStringToString(w.cRules:Selected())] = nil
				w.cRules:Clear()
				--[[local	tt={}
				table.foreach(CoreAddon.Rules[ruleType].RuleSets[setName].rules,
					function (k,b)		
						table.insert (tt, k) 
					end)
				table.sort(tt)]]--
				for k,_ in pairs(CoreAddon.Rules[ruleType].RuleSets[setName].rules) do w.cRules:Add(k) end
			end
			CoreAddon[ruleType].UpdateRuleCache()
		end
		
	w.lAdd = w("Label")
	w.lAdd:Resize(300)
	w.lAdd:AnchorTo(w.cRules, "bottomleft", "topleft", 0, 25)
	w.lAdd:Font(Addon.FontText)
	w.lAdd:SetText(L"Add a rule to this ruleset:")
	w.lAdd:Align("left")
	
	w.cAdd = w("Combobox")
	w.cAdd:AnchorTo(w.lAdd, "bottomleft", "topleft", 0, 5)
	--[[local tt={}
	table.foreach(CoreAddon.Rules[ruleType].Rules,
		function (k,b)
				if nil == CoreAddon.Rules[ruleType].RuleSets[setName].rules[k] then
					table.insert (tt, k)
				end
		end)
	table.sort(tt)]]--
	for _,v in ipairs(Addon.Rules.GetNameTableForCombobox(ruleType, false)) do
		if nil == ruleSet.rules[v] then w.cAdd:Add(v) end
	end
	
	w.bAdd = w("Button", nil, Addon.ButtonInherits)
	w.bAdd:Resize(Addon.ButtonWidth)
	w.bAdd:SetText(L"Add")
	w.bAdd:AnchorTo(w.cAdd, "right", "left", 10, 0)
	w.bAdd.OnLButtonUp = 
		function()
			if (nil ~= w.cAdd:Selected()) and (L"" ~= w.cAdd:Selected()) then
				if not CoreAddon.Rules[ruleType].RuleSets[setName] then	-- it´s a factory preset being modified
					CoreAddon.Rules[ruleType].RuleSets[setName] = CoreAddon.deepcopy(CoreAddon.GetRuleFactoryPreset(ruleType, true, setName)) -- deepcopy necessary?
				end
				CoreAddon.Rules[ruleType].RuleSets[setName].rules[WStringToString(w.cAdd:Selected())] = WStringToString(w.cAdd:Selected())
				w.cRules:Add(w.cAdd:Selected())
				w.cAdd:Clear()
				--[[local	tt={}
				table.foreach(CoreAddon.Rules[ruleType].RuleSets[setName].rules,
					function (k,b)
						if nil == CoreAddon.Rules[ruleType].RuleSets[setName].rules[k] then
							table.insert (tt, k)
						end
					end)
				table.sort(tt)
				for k,v in pairs(tt) do w.cAdd:Add(v) end]]--
				for _,v in ipairs(Addon.Rules.GetNameTableForCombobox(ruleType, false)) do
					if nil == CoreAddon.Rules[ruleType].RuleSets[setName].rules[v] then w.cAdd:Add(v) end
				end
				CoreAddon.UpdateRuleCache(ruleType)
			end
		end

	Addon.Rules.R = w
	Addon.Rules.R:Show()

end

--
-- Util functions
--

--[[function Addon.FillColorGroups(obj)
	obj:Clear()
	obj:Add("none")
	
	if (not CoreAddon.Rules.Colors) then return obj end
	local tt = {}
	table.foreach(CoreAddon.Rules.Colors.RuleSets,
		function (k,b)		
				table.insert (tt, k) 
		end)
	table.sort(tt)
	for k,v in pairs(tt) do obj:Add(v) end
	
	return obj
end]]--

--[[function Addon.FillTextureGroups(obj)
	obj:Clear()
	obj:Add("none")
	
	if (not CoreAddon.Rules.Textures) then return obj end
	local tt = {}
	table.foreach(CoreAddon.Rules.Textures.RuleSets,
		function (k,b)		
				table.insert (tt, k) 
		end)
	table.sort(tt)
	for k,v in pairs(tt) do obj:Add(v) end
	
	return obj
end]]--

function Addon.FillRulesDropdown(obj)
	obj:Clear()

    obj:Add("statePercent")
	--obj:Add("isStateValid")
	obj:Add("isArchetype")
	obj:Add("isClass")
--w.objdd("isNamed")
--w.objdd("isGuild")
--w.objdd("isDead")
	
	obj:Add("isEnemy")
	obj:Add("isFriendly")
	obj:Add("isGroup")
	--obj:Add("isPlayer")
	
	obj:Add("isCurrentValue")
	--obj:Add("isCurrentValueAbove")
	obj:Add("relativeLevel")
	
	--obj:Add("isFriendlyTarget")
	obj:Add("isInCombat")
	obj:Add("isSpellChannel")
	obj:Add("isSpellInteract")
	
	--[[obj:Add("isBuffed")
	obj:Add("isBuffedByMe")
	obj:Add("isBlessed")
	obj:Add("isBlessedByMe")
	obj:Add("isHealing")
	obj:Add("isHealingByMe")
	obj:Add("isCureableByMe")
	obj:Add("isAilmented")
	obj:Add("isAilmentedByMe")
	obj:Add("isCursed")
	obj:Add("isCursedByMe")
	obj:Add("isHexed")
	obj:Add("isHexedByMe")
	]]--

	obj:Add("partySize")
	
	-- Extra Info
	obj:Add("RangeMin")
	obj:Add("RangeMax")
	
	-- LibUnits Booleans
	obj:Add("isNPC")
	obj:Add("isSelfPet")
	obj:Add("isRVRFlagged")
	obj:Add("isDistant")
	obj:Add("isInSameRegion")
	obj:Add("isGroupLeader")
	obj:Add("isAssistant")
	obj:Add("isMainAssist")
	obj:Add("isMasterLooter")
	obj:Add("isSelf")
	--obj:Add("IsGroupMember")
	--obj:Add("IsScenarioGroupMember")
	--obj:Add("IsWarbandMember")
	obj:Add("isTargeted")
	obj:Add("isMouseOvered")
	
	-- LibUnits numbers
	obj:Add("type")
	obj:Add("careerLine")
	obj:Add("level")
	obj:Add("tier")
	obj:Add("difficultyMask")
	obj:Add("healthPercent")
	obj:Add("actionPointPercent")
	obj:Add("moraleLevel")
	obj:Add("zoneNum")
	obj:Add("conType")
	obj:Add("mapPinType")
	obj:Add("sigilEntryId")
	obj:Add("groupIndex")
	obj:Add("memberIndex")	
	
	-- LibUnits strings
	obj:Add("name")
	obj:Add("title")
	obj:Add("careerName")
	--[[
	--RVAPI_Entities booleans
	obj:Add("IsNPC")
	obj:Add("IsPet")
	obj:Add("IsPVP")
	obj:Add("IsDistant")
	obj:Add("IsInSameRegion")
	obj:Add("IsGroupLeader")
	obj:Add("IsAssistant")
	obj:Add("IsMainAssist")
	obj:Add("IsMasterLooter")
	obj:Add("IsSelf")
	obj:Add("IsGroupMember")
	obj:Add("IsScenarioGroupMember")
	obj:Add("IsWarbandMember")
	obj:Add("IsTargeted")
	obj:Add("IsMouseOvered")
	--ShowHealthBar
	--Online
	
	--RVAPI_Entities numbers
	--obj:Add("EntityId")
	obj:Add("EntityType")
	obj:Add("CareerLine")
	obj:Add("Level")
	obj:Add("Tier")
	obj:Add("DifficultyMask")
	obj:Add("HitPointPercent")
	obj:Add("ActionPointPercent")
	obj:Add("MoraleLevel")
	obj:Add("ZoneNumber")
	obj:Add("ConType")
	obj:Add("MapPinType")
	obj:Add("SigilEntryId")
	obj:Add("GroupIndex")
	obj:Add("MemberIndex")
	
	--RVAPI_Entities strings
	obj:Add("Name")
	obj:Add("Title")
	obj:Add("CareerName")]]--
	
    return obj
end

function Addon.Rules.GetNameTableForCombobox(ruleType, isRuleSet)
	local tt={}
	
	for k,_ in pairs(CoreAddon.GetRuleFactoryPresetsFor(ruleType, isRuleSet)) do
		table.insert(tt, k)
	end
	
	local userTable = {}
	if isRuleSet then
		userTable = CoreAddon.Rules[ruleType].RuleSets
	else
		userTable = CoreAddon.Rules[ruleType].Rules
	end
	
	for k,_ in pairs(userTable) do
		if not CoreAddon.GetRuleFactoryPreset(ruleType, isRuleSet, k) then
			table.insert(tt, k)
		end
	end
	
	table.sort(tt)
	return tt
end

--
-- Window functions
--
function Addon.Rules.CreateEditSettingsRuleEnd(w)
	Addon.Rules.R = w
	Addon.Rules.R:Show()
end

function Addon.Rules.CreateEditSettingsRulesEnd(w)
	Addon.Rules.Rs = w
	Addon.Rules.Rs:Show()
end

function Addon.Rules.DestroyEditRuleSettings()
	if (nil ~= Addon.Rules.R) then
		Addon.Rules.R:Destroy()
	end
	WindowUnregisterCoreEventHandler(SettingsWindow.."RulePopUpButtonOK", "OnLButtonUp")
	WindowUnregisterCoreEventHandler(SettingsWindow.."RulePopUpButtonClose", "OnLButtonUp")
	DestroyWindow(SettingsWindow.."RulePopUp")
end

function Addon.Rules.DestroyEditRulesSettings()
	if (nil ~= Addon.Rules.Rs) then
		Addon.Rules.Rs:Destroy()
	end
	if (nil ~= Addon.R) then
		Addon.Rules.R:Destroy()
	end
end

function Addon.Rules.CreateEditRuleSettingsStart()

	if (nil ~= Addon.R) then
		Addon.DestroyEditRuleSettings()
	end

	
	-- First step: create window from template
	CreateWindowFromTemplate(SettingsWindow.."RulePopUp", Addon.Name.."PopupWindowTemplate", "Root")
	ButtonSetText(SettingsWindow.."RulePopUpButtonOK", L"Close")
	WindowRegisterCoreEventHandler(SettingsWindow.."RulePopUpButtonOK", "OnLButtonUp", Addon.Name..".Rules.DestroyEditRuleSettings")
	WindowRegisterCoreEventHandler(SettingsWindow.."RulePopUpButtonClose", "OnLButtonUp", Addon.Name..".Rules.DestroyEditRuleSettings")
	LabelSetTextColor(SettingsWindow.."RulePopUpTitleBarText", 255, 255, 255)
	local w = {}
	w = LibGUI("Window")
	--w:MakeMovable()
	w:Resize(630, 300)
	--w:AnchorTo(Addon.Rs, "bottomleft", "topleft", 0, 0)
	w:AnchorTo(SettingsWindow.."RulePopUp", "top", "top", 0, 40)
	w:Parent(SettingsWindow.."RulePopUp")
	--[[	
	w.bCloseButton = w("Closebutton")
	w.bCloseButton.OnLButtonUp =
	function()
		Addon.Rules.DestroyEditRuleSettings()
	end
	]]--
	
	return w
end

--
-- ColorDialog CallbackHandler
--
--[[function Addon.Rules.OnColorDialogCallback(Object, Event, EventData)
	-- Hint: COLOR_EVENT_UPDATED sends the old value again if cancel ist clicked
	-- First step: check for the right event
	
	if Event == RVAPI_ColorDialog.Events.COLOR_EVENT_UPDATED then
		local colorName = WStringToString(Addon.Rules.Rs.cColor:Selected())
		CoreAddon.Colors[colorName].r = math.floor(EventData.Red + 0.5)
		CoreAddon.Colors[colorName].g = math.floor(EventData.Green + 0.5)
		CoreAddon.Colors[colorName].b = math.floor(EventData.Blue + 0.5)
	end
end]]--