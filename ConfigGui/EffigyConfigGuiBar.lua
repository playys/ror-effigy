if not Effigy then Effigy = {} end
local CoreAddon = Effigy
if not EffigyConfigGui then EffigyConfigGui = {} end
local Addon = EffigyConfigGui
Addon.CurrentTab = ""

local LibGUI = LibStub("LibGUI")

if (nil == Addon.Name) then Addon.Name = "EffigyConfigGui" end

local SettingsWindow = Addon.Name.."BarWindowSettings"

--
--	EDIT Bar Panel ------------------------------------------------
--

Addon.EditBarPanel = {}
Addon.EditBarPanel.W = nil
Addon.EditBar = nil
--------------------------------------------------------------
-- function InitializeSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.EditBarPanel.InitializeSettingsWindow(ParentWindow)

	-- First step: create window from template
	CreateWindowFromTemplate(SettingsWindow, Addon.Name.."BarTemplate", "Root")
	LabelSetText(SettingsWindow.."TitleBarText", L"Bar Edit:")
	ButtonSetText(SettingsWindow.."ButtonOK", L"Close")

	-- Third step: set tab buttons
	ButtonSetText(SettingsWindow.."TabGeneral", L"General")
	ButtonSetText(SettingsWindow.."TabBar", L"Bar")
	ButtonSetText(SettingsWindow.."TabIcons", L"Icons")
	ButtonSetText(SettingsWindow.."TabLabels", L"Labels")
	ButtonSetText(SettingsWindow.."TabImages", L"Images")

	-- Final step: setup tabs visibility
	ButtonSetPressedFlag(SettingsWindow.."TabGeneral", true)
	ButtonSetPressedFlag(SettingsWindow.."TabBar", false)
	ButtonSetPressedFlag(SettingsWindow.."TabIcons", false)
	ButtonSetPressedFlag(SettingsWindow.."TabLabels", false)
	ButtonSetPressedFlag(SettingsWindow.."TabImages", false)
end

--------------------------------------------------------------
-- function ShowModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.EditBarPanel.ShowModuleSettings()

	-- First step: check for window
	if not DoesWindowExist(SettingsWindow) then
		Addon.EditBarPanel.InitializeSettingsWindow("root")--ModuleWindow)
	end
	
	LabelSetText(SettingsWindow.."TitleBarText", L"Bar Edit: "..towstring(Addon.EditBar))
	-- Final step: show everything
	WindowSetShowing(SettingsWindow, true)
end

--------------------------------------------------------------
-- function HideModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.EditBarPanel.HideModuleSettings()
	
	--Addon.DestroyEditBarSettings()
	-- Final step: hide window
	WindowSetShowing(SettingsWindow, false)
end

function Addon.EditBarPanel.Create(barname)
	Addon.EditBar = barname
	Addon.EditBarPanel.ShowModuleSettings()
	Addon.EditBarPanel.OnClickTabGeneral()
end

function Addon.EditBarPanel.Destroy()
	--Addon.DestroyEditSettings()
	if (nil ~= Addon.EditBarPanel.W) then
		Addon.EditBarPanel.W:Destroy()
	end
end

--
--	Main Bar Settings Panel -------------------------------------------------
--
Addon.B = nil
Addon.C = nil
Addon.E = nil


function Addon.CreateEditBarSettingsStart()
	local w = {}
	local barname = Addon.EditBar

	w = LibGUI("Blackframe")
	w:AnchorTo(SettingsWindow, "topleft", "topleft", 0, 70)
	w:AddAnchor(SettingsWindow, "bottomright", "bottomright", 0, -100)
	w:Parent(SettingsWindow)
	
	if (nil ~= Addon.B) then
		Addon.DestroyEditBarSettings()
	end

	if (nil == barname) then return w, nil end

	local bar = CoreAddon.Bars[barname]
	if (nil == bar) then return end

	return w, bar
end

function Addon.CreateEditBarSettingsChildStart()
	if (nil ~= Addon.C) then
		Addon.C:Destroy()
	end
	
	local w = {}
	w = LibGUI("Blackframe")
	w:AnchorTo(Addon.B, "topleft", "topleft", 0, 50)
	w:AddAnchor(Addon.B, "bottomright", "bottomright", 0, 0)
	w:Parent(Addon.B)

	local barname = Addon.EditBar
	if (nil == barname) then return w, nil end

	local bar = CoreAddon.Bars[barname]
	if (nil == bar) then return end

	return w, bar
end

function Addon.CreateEditBarSettingsEnd(w)
	Addon.B = w
	Addon.B:Show()
end

function Addon.CreateEditBarSettingsChildEnd(w)
	Addon.C = w
	Addon.C:Show()
end

function Addon.DestroyEditBarSettings()
	if (nil ~= Addon.C) then
		Addon.C:Destroy()
	end
	if (nil ~= Addon.B) then
		Addon.B:Destroy()
	end
end

--
-- Combobox Utility Functions
--

local function FillAnchorDropdown(obj)
	obj:Clear()
	obj:Add("topleft")
	obj:Add("top")
	obj:Add("topright")
	obj:Add("left")
	obj:Add("center")
	obj:Add("right")
	obj:Add("bottomleft")
	obj:Add("bottom")
	obj:Add("bottomright")
end

local function FillAlignDropdown(obj)
	obj:Clear()
	obj:Add("left")
	obj:Add("center")
	obj:Add("right")
end

function Addon.FillTextureDropdown(obj)
	obj:Clear()
	obj:Add("none")
	
	local tt = {}
	for k,_ in pairs(CoreAddon.texture_list) do table.insert (tt, k) end
	table.sort(tt)
	for k,v in pairs(tt) do obj:Add(v) end
	
	return obj
end

local function FillLabelImageDropdown(obj, settings)
	obj:Clear()
	local tt = {}		
	for k,_ in pairs(settings) do table.insert(tt,k) end
	table.sort(tt)
	for k,v in pairs(tt) do obj:Add(v) end
	
	return obj
end

local function FillAlterDropdown(obj)
	obj:Clear()
	obj:Add("no")
	obj:Add("inv")
	obj:Add("perc")
end

local function FillRuleSetDropdown(ruleType, obj)
	obj:Clear()
	obj:Add("none")
	for _,v in ipairs(Addon.Rules.GetNameTableForCombobox(ruleType, true)) do obj:Add(v) end	
	return obj
end

--
-- /Combobox Utility Functions
--
--
-- SubFrames
--
local function GetAnchorFrame(bar, anchorTable)
	local w = LibGUI("BlackFrame")
	w:Resize(325, 125)
	
	w.lAnchorTo = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lAnchorTo:Font(Addon.FontBold)
	w.lAnchorTo:SetText(L"Anchor 1:")
	w.lAnchorTo:Align("left")
	w.lAnchorTo:AnchorTo(w, "topleft", "topleft", 10, 10)
	
	w.lMy_Anchor = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lMy_Anchor:Resize(95)
	w.lMy_Anchor:Font(Addon.FontText)
	w.lMy_Anchor:AnchorTo(w.lAnchorTo, "bottomright", "bottomleft", 10, 0)
	w.lMy_Anchor:SetText(L"My Point:")
	w.lMy_Anchor:Align("left")
	w.lMy_Anchor.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lMy_Anchor, "A Point on the object to attach to",
				"Choices:", "topleft, top, topright", "left, center, right", "bottomleft, bottom, bottomright")
		end
	
	w.cMy_Anchor = w("smallcombobox")
	w.cMy_Anchor:AnchorTo(w.lMy_Anchor, "right", "left", 0, 0)
	FillAnchorDropdown(w.cMy_Anchor)

	w.lTo_Anchor = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lTo_Anchor:Font(Addon.FontText)
	w.lTo_Anchor:AnchorTo(w.lAnchorTo, "bottomleft", "topleft", 0, 15)
	w.lTo_Anchor:SetText(L"To:")
	w.lTo_Anchor:Align("left")
	w.lTo_Anchor.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lTo_Anchor, "A Point on the object to attach to",
				"Choices:", "topleft, top, topright", "left, center, right", "bottomleft, bottom, bottomright")
		end
		
	w.cTo_Anchor = w("smallcombobox")
	w.cTo_Anchor:AnchorTo(w.lTo_Anchor, "bottomleft", "topleft", 0, 15)
	FillAnchorDropdown(w.cTo_Anchor)
	
	w.cAnchorTo = w("combobox")
	w.cAnchorTo:AnchorTo(w.lTo_Anchor, "right", "left", 5, 0)
	w.cAnchorTo:Clear()
	w.cAnchorTo:Add("Root")
	w.cAnchorTo:Add("Bar")
	w.cAnchorTo:Add("Bar BG")
	w.cAnchorTo:Add("Bar Fill")
	local currentTab = Addon.GetCurrentTab()
	local selected
	if Addon.B and Addon.B.cBox then
		selected = Addon.B.cBox:Selected()
	end
	
	local tt={}
	for k,v in pairs(bar.images) do
		if not (currentTab == "Images" and selected == towstring(k)) then
			if (v.anchors[1].parent ~= selected) then
				if ((not v.anchors[2]) or (v.anchors[2] and v.anchors[1].parent ~= selected)) then
					table.insert (tt, "Image"..k)
				end
			end
		end
	end
--	table.sort(tt)
	for _,v in pairs(tt) do w.cAnchorTo:Add(v) end
	tt = {}
	for k,v in pairs(bar.labels) do
		if not (currentTab == "Labels" and selected == towstring(k)) then
			if (v.anchors[1].parent ~= selected) then
				if ((not v.anchors[2]) or (v.anchors[2] and v.anchors[1].parent ~= selected)) then
					table.insert (tt, "Label"..k)
				end
			end
		end
	end	
	table.sort(tt)
	for _,v in pairs(tt) do w.cAnchorTo:Add(v) end
	w.cAnchorTo:Add(L"---------------")
	tt = {}
	for k, v in pairs(CoreAddon.Bars) do
		if not ((v.name == bar.name) or (v.anchors[1].parent == bar.name) or (v.anchors[2] and v.anchors[2].parent == bar.name)) then
			local inl = {v.images, v.labels}
			local isAllowedToAnchor = true
			for _,iol in ipairs(inl) do
				for _, v2 in pairs(iol) do
					if ((v2.anchors[1].parent == bar.name) or (v2.anchors[2] and (v2.anchors[2].parent == bar.name))) then
						isAllowedToAnchor = false
						break
					end
				end
			end
			if isAllowedToAnchor then table.insert (tt, k) end
		end
	end
	table.sort(tt)
	for _,v in pairs(tt) do
		w.cAnchorTo:Add(v)
	end
	w.cAnchorTo:Add(L"---------------")
	tt = {}
	for k,_ in pairs(LayoutEditor.windowsList) do
		if not CoreAddon.Bars[k] then
			local isAllowedToAnchor = true
			for i = 1, WindowGetAnchorCount(k) do
				local _, _, parent, _, _ = WindowGetAnchor(k, i)
				if parent == bar.name then
					isAllowedToAnchor = false
					break
				end
			end
			if isAllowedToAnchor then table.insert (tt, k) end
		end
	end
	table.sort(tt)
	for _,v in pairs(tt) do
		w.cAnchorTo:Add(v)
	end
	w.bl8 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.bl8:Resize(30)
	w.bl8:Font(Addon.FontText)
	w.bl8:AnchorTo(w.cTo_Anchor, "right", "left", 5, 0)
	w.bl8:SetText(L"X:")
	w.bl8:Align("left")
	w.bl8.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.bl8, "X axis offset",
				"Alters the position of the image in the x axis relative to the anchor points",
				"Just a number",
				"")
		end

	w.bt8 = w("Textbox")
	w.bt8:Resize(60)
	w.bt8:AnchorTo(w.bl8, "right", "left", 5, 0)

	w.bl9 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.bl9:Resize(30)
	w.bl9:Font(Addon.FontText)
	w.bl9:AnchorTo(w.bt8, "right", "left", 10, 0)
	w.bl9:SetText(L"Y:")
	w.bl9:Align("left")
	w.bl9.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.bl9, "y axis offset",
				"Alters the position of the image in the y axis relative to the anchor points",
				"Just a number",
				"")
		end

	w.bt9 = w("Textbox")
	w.bt9:Resize(60)
	w.bt9:AnchorTo(w.bl9, "right", "left", 5, 0)

	-- set settings
	w.cMy_Anchor:Select(anchorTable.point)
	if anchorTable.parent == nil or anchorTable.parent == "" then
		w.cAnchorTo:SelectIndex(2)
	else
		w.cAnchorTo:Select(anchorTable.parent)
	end		
	w.cTo_Anchor:Select(anchorTable.parentpoint)	
	if (anchorTable.x == nil) then
		w.bt8:SetText(0)
	else
		w.bt8:SetText(anchorTable.x)
	end

	if (anchorTable.y == nil) then 
		w.bt9:SetText(0)
	else
		w.bt9:SetText(anchorTable.y)
	end

	return w
end

local function GetFrameSize(settings)
	local w = LibGUI("BlackFrame")
	w:Resize(290, 90)
	
	--Size
	--[[w.h0 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.h0:Resize(300)	
	w.h0:Font(Addon.FontBold)
	w.h0:SetText(L"Size:")
	w.h0:Align("left")
	w.h0:Position(10, 10)]]--

	w.lWidth = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lWidth:Resize(60)
	w.lWidth:Font(Addon.FontText)
	--w.lWidth:AnchorTo(w.h0, "bottomleft", "topleft", 5, 0)
	w.lWidth:Position(15, 15)
	w.lWidth:SetText(L"Width:")
	w.lWidth:Align("left")
	w.lWidth.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lWidth, "The width of the element",
				"Just a number equal or above 0",
				"Tip: Setting this to 0 on a label will make the width equal to the bar width",
				"Tip: Setting this to 0 on a texture will make it use the original texture width, which would almost always be the desired value"
				)
		end

	w.tWidth = w("Textbox")
	w.tWidth:Resize(60)
	w.tWidth:AnchorTo(w.lWidth, "right", "left", 5, 0)
	w.tWidth:SetText(settings.width)

	w.lHeight = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lHeight:Resize(70)
	w.lHeight:Font(Addon.FontText)
	w.lHeight:AnchorTo(w.tWidth, "right", "left", 5, 0)
	w.lHeight:SetText(L"Height:")
	w.lHeight:Align("left")
	w.lHeight.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lHeight, "The height of the element",
				"Just a number equal or above 0",
				"Label Default: 24",
				"Tip: Setting this to 0 on a texture will make it use the original texture height, which would almost always be the desired value"
				)
		end

	w.tHeight = w("Textbox")
	w.tHeight:Resize(60)
	w.tHeight:AnchorTo(w.lHeight, "right", "left", 5, 0)
	w.tHeight:SetText(settings.height)

	w.lScale = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lScale:Resize(60)
	w.lScale:AnchorTo(w.lWidth, "bottomleft", "topleft", 0, 20)
	w.lScale:Font(Addon.FontText)
	w.lScale:SetText(L"Scale:")
	w.lScale:Align("left")
	w.lScale.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lScale, "Scale",
				"Minimum: 0", "Maximum: 2",
				"")
		end
	--[[
	w.s5 = w("Slider")
	w.s5:AnchorTo(w.lScale, "bottomleft", "topleft", 0, -15)
	w.s5:SetRange(0, 2)
	if (settings.scale == nil) then 
		settings.scale = 1
		w.s5:SetValue(1) 
	else
		w.s5:SetValue(settings.scale)
	end
	w.s5.OnLButtonUp =
		function()
			settings.scale = w.s5:GetValue()
			w.tScale:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", settings.scale)))
			bar:setup()
			bar:render()
		end
	w.s5.OnMouseOverEnd =
		function()
			settings.scale = w.s5:GetValue()
			w.tScale:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", settings.scale)))
			bar:setup()
			bar:render()
			d()
		end
	]]--
	w.tScale = w("Textbox")
	w.tScale:Resize(60)
	w.tScale:AnchorTo(w.lScale, "right", "left", 5, 0)
	w.tScale:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", settings.scale)))	
	
	return w
end

local function GetFrameAnchorAndPosition(settings, bar)
	-- Anchor and Position
	local w = LibGUI("BlackFrame")
	w:Resize(350, 260)
		
	w.h1 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.h1:Resize(300)	
	w.h1:Font(Addon.FontHeadline)
	w.h1:SetText(L"Position")
	w.h1:Align("left")
	w.h1:Position(10, 10)

	w.h2 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.h2:Font(Addon.FontHeadline)
	w.h2:SetText(L"& Size:")
	w.h2:Align("left")
	w.h2:AnchorTo(w.h1, "bottomleft", "topleft", 0, 10)
	
	w.cParent = w("smallcombobox")
	w.cParent:AnchorTo(w, "topright", "topright", -10, 10)
	w.cParent:Clear()
	w.cParent:Add("Root")
	w.cParent:Add("Bar")
	w.cParent:Add("Bar Fill")
	local tt={}
	for k,_ in pairs(bar.images) do
		table.insert (tt, "Image"..k)
	end
	--table.sort(tt)
	for _,v in pairs(tt) do w.cParent:Add(v) end
	tt = {}
	for k,_ in pairs(bar.labels) do
		table.insert (tt, "Label"..k)
	end	
	table.sort(tt)
	for _,v in pairs(tt) do w.cParent:Add(v) end
	if settings.parent == nil or settings.parent == "" then
		w.cParent:SelectIndex(2)
	else
		w.cParent:Select(settings.parent)
	end
	
	w.lParent = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lParent:Resize(75)	
	w.lParent:Font(Addon.FontText)
	w.lParent:SetText(L"Parent:")
	w.lParent:Align("left")
	w.lParent:AnchorTo(w.cParent, "left", "right", 0, 0)

	w.cLayer = w("smallcombobox")
	w.cLayer:AnchorTo(w.cParent, "bottomright", "topright", 0, 5)
	w.cLayer:Clear()
	w.cLayer:Add("background")
	w.cLayer:Add("default")
	w.cLayer:Add("secondary")
	w.cLayer:Add("popup")
	w.cLayer:Add("overlay")
	w.cLayer:Select(settings.layer)
	
	w.lLayer = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lLayer:Resize(75)
	w.lLayer:Font(Addon.FontText)
	--w.lLayer:AnchorTo(w.lParent, "bottomleft", "topleft", 0, 10)
	w.lLayer:AnchorTo(w.cLayer, "left", "right", 0, 0)
	w.lLayer:SetText(L"Layer:")
	w.lLayer:Align("left")
	w.lLayer.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lLayer, "The Layer determines if the element is more to the front or to the back.",
				"All Layers are ´inside´ the parent.",
				"So, Layer ´Background´ with Parent ´Root´ is something else than Layer ´Background´ with Parent ´Bar´."
				)
		end


	
	--
	-- Anchor 1
	--
	w.Anchor1 = GetAnchorFrame(bar, settings.anchors[1])
	w.Anchor1:Parent(w)
	w.Anchor1:AnchorTo(w.h1, "bottomleft", "topleft", 0, 45)	
	

	--
	-- /Anchor 1
	--
	
	--w.cAnchorOrSize = w("smallcombobox")
	w.cAnchorOrSize = LibGUIComboboxer.NewCombobox("smallcombobox")
	w.cAnchorOrSize:Parent(w)
	w.cAnchorOrSize:AnchorTo(w.Anchor1, "bottomleft", "topleft", 0, 3)
	w.cAnchorOrSize:Clear()
	w.cAnchorOrSize:Add("Size")
	w.cAnchorOrSize:Add("Anchor 2")
	w.cAnchorOrSize.OnSelChanged = function()
		if w.cAnchorOrSize:Selected() == L"Size" then
			w.Anchor2:Hide()
			w.Size:Show()
		else
			w.Anchor2:Show()
			w.Size:Hide()
		end
	end
	
	w.Size = GetFrameSize(settings)
	w.Size:Parent(w)
	w.Size:AnchorTo(w.cAnchorOrSize, "bottomleft", "topleft", 0, 3)
	
	--
	-- Anchor 2
	--
	w.Anchor2 = GetAnchorFrame(bar, settings.anchors[2] or {parent = "Bar", point = "bottomright", parentpoint = "bottomright", x = 0, y = 0})
	w.Anchor2:Parent(w)
	w.Anchor2:AnchorTo(w.cAnchorOrSize, "bottomleft", "topleft", 0, 3)
	w.Anchor2.lAnchorTo:SetText(L"Anchor 2:")
	--w.Anchor2:Hide()
	
	if not settings.anchors[2] then
		w.cAnchorOrSize:Select("Size")
		w.Anchor2:Hide()
		w.Size:Show()
	else
		w.Anchor2:Show()
		w.Size:Hide()
		w.cAnchorOrSize:Select("Anchor 2")
	end
	
	return w
end

local function GetFrameColor(settings)
	local w = LibGUI("BlackFrame")
	w:Resize(280, 220)

	-- Workaround for LibGUI image not seeming to be able to deliver events for images and windows
	-- Color
	w.lColor = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lColor:Resize(95)	
	w.lColor:Font(Addon.FontHeadline)
	w.lColor:SetText(L"Color:")
	w.lColor:Align("left")
	w.lColor:Position(10, 10)
	w.lColor.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lColor, "Click to edit.",
				"If you have a Global Color Preset Enabled, it will directly edit said Preset",
				"If Global Color Preset is set to ´none´, you will edit your custom color.",
				"")
		end

	w.colorBoxBG = w("Image")
	w.colorBoxBG:Resize(30,30)
	w.colorBoxBG:Tint(64, 64, 64)
	w.colorBoxBG:AnchorTo(w.lColor, "right", "left", 5, 0)
	
	w.colorBox = w("Image")
	w.colorBox:Resize(26,26)
	w.colorBox:Tint(settings.color.r, settings.color.g, settings.color.b)
	w.colorBox:AnchorTo(w.colorBoxBG, "topleft", "topleft", 2, 2)

	-- windows and frames registercoreeventhandler does not work for lua as of 1.3.4
	w.colorBoxLabelForEvents = w("Label")
	w.colorBoxLabelForEvents:AnchorTo(w.colorBox, "topleft", "topleft", 0, 0)
	w.colorBoxLabelForEvents:AddAnchor(w.colorBox, "bottomright", "bottomright", 0, 0)
	w.colorBoxLabelForEvents.OnLButtonUp =
		function()
			local selection = WStringToString(w.cColorPresets:Selected())
			if RVMOD_GColorPresets ~= nil and selection ~= nil and selection ~= "" and selection ~= "none" then
				RVMOD_GColorPresets.EditColorPreset(selection)
			else
				local ColorDialogOwner, ColorDialogFunction = RVAPI_ColorDialog.API_GetLink()
				if ColorDialogOwner ~= Addon or ColorDialogFunction ~= Addon.EditBarPanel.OnColorDialogCallback then
					-- Third step: open color dialog
					RVAPI_ColorDialog.API_OpenDialog(Addon, Addon.EditBarPanel.OnColorDialogCallback, true, settings.color.r, settings.color.g, settings.color.b, 1, Window.Layers.SECONDARY, RVAPI_ColorDialog.ColorTypes.COLOR_TYPE_RGB)
				else
					-- Fourth step: close color dialog
					RVAPI_ColorDialog.API_CloseDialog(true)
				end
			end
		end
	
	if RVMOD_GColorPresets ~= nil then
		w.cColorPresets = w("combobox")
		w.cColorPresets:AnchorTo(w.lColor, "bottomleft", "topleft", 5, 15)
		--local colorPresets = RVMOD_GColorPresets.GetColorPresets()
		w.cColorPresets:Clear()
		w.cColorPresets:Add("none")
		for _,v in ipairs(RVMOD_GColorPresets.GetColorPresetList()) do
			w.cColorPresets:Add(v)
		end
		if settings.ColorPreset ~= nil and settings.ColorPreset ~= "" and settings.ColorPreset ~= "none" then
			w.cColorPresets:Select(settings.ColorPreset)
			local ColorPreset = RVMOD_GColorPresets.GetColorPreset(settings.ColorPreset)
			w.colorBox:Tint(ColorPreset.r, ColorPreset.g, ColorPreset.b)
		else
			w.cColorPresets:Select("none")
		end
	end
	
	w.lColorGroup = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lColorGroup:Resize(175)
	w.lColorGroup:AnchorTo(w.lColor, "bottomleft", "topleft", 5, 50)
	w.lColorGroup:Font(Addon.FontText)
	w.lColorGroup:SetText(L"Dynamic Color:")
	w.lColorGroup:Align("left")	
	w.lColorGroup.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lColorGroup, "Use this color ruleset for dynamic coloring",
				"If any rule in the color ruleset matches the color is used.",
				"Otherwise it will use the color set above.",
				"If you do not wish to use dynamic coloring for this element select the group none.")
		end
		
	w.cColorGroup = w("Combobox")
	w.cColorGroup:AnchorTo(w.lColorGroup, "bottomleft", "topleft", 0, 10)	
	FillRuleSetDropdown("Colors", w.cColorGroup)
		
	if (settings.color_group) then
		w.cColorGroup:Select(settings.color_group)
	else
		w.cColorGroup:Select("none")
	end
	
	w.lOverride = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lOverride:Resize(175)
	w.lOverride:AnchorTo(w.cColorGroup, "bottomleft", "topleft", 0, 5)
	w.lOverride:Font(Addon.FontText)
	w.lOverride:SetText(L"Use Color Override:")
	w.lOverride:Align("left")
	w.lOverride.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lOverride, "Some States provide color information, allow it?",
				"Example: FTHP State provides the Friendly Target In-Game Relationship Color.",
				"Example: HTCon provides the In-Game CON color.",
				"Example: PlayerCareer provides Shaman/Archmage colors.")
		end
		
	w.cOverride = w("Checkbox")
	w.cOverride:AnchorTo(w.lOverride, "right", "left", 5, 0)
	if (true == settings.allow_overrides) then
		w.cOverride:Check()
	end
	
	w.lAlter = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlter:Resize(65)
	w.lAlter:AnchorTo(w.lOverride, "bottomleft", "topleft", 0, 15)
	w.lAlter:Font(Addon.FontText)
	w.lAlter:SetText(L"Alter:")
	w.lAlter:Align("left")
	w.lAlter.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlter, "Changes the amount of a color in the bar based on:",
				"inv: Inverse of the bars value (lower value more of the color)",
				"perc: Percent of the bar (higher value more of the color)",
				"no: Don't change the color based on bar's value") 
		end
		
	w.lAlterRed = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlterRed:Resize(20)
	w.lAlterRed:AnchorTo(w.lAlter, "bottomleft", "topleft", 0, 15)
	w.lAlterRed:Font(Addon.FontText)
	w.lAlterRed:SetText(L"R:")
	w.lAlterRed:Align("left")
	
	w.cAlterRed = w("Tinycombobox")
	w.cAlterRed:AnchorTo(w.lAlterRed, "right", "left", 5, 0)
	FillAlterDropdown(w.cAlterRed)
	w.cAlterRed:Select(settings.alter.r)
	
	w.lAlterGreen = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlterGreen:Resize(20)
	w.lAlterGreen:AnchorTo(w.cAlterRed, "right", "left", 5, 0)
	w.lAlterGreen:Font(Addon.FontText)
	w.lAlterGreen:SetText(L"G:")
	w.lAlterGreen:Align("left")
	
	w.cAlterGreen = w("Tinycombobox")
	w.cAlterGreen:AnchorTo(w.lAlterGreen, "right", "left", 5, 0)
	FillAlterDropdown(w.cAlterGreen)
	w.cAlterGreen:Select(settings.alter.g)
	
	w.lAlterBlue = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlterBlue:Resize(20)
	w.lAlterBlue:AnchorTo(w.cAlterGreen, "right", "left", 5, 0)
	w.lAlterBlue:Font(Addon.FontText)
	w.lAlterBlue:SetText(L"B:")
	w.lAlterBlue:Align("left")
	
	w.cAlterBlue = w("Tinycombobox")
	w.cAlterBlue:AnchorTo(w.lAlterBlue, "right", "left", 5, 0)
	FillAlterDropdown(w.cAlterBlue)
	w.cAlterBlue:Select(settings.alter.b)

	return w
end

local function GetFrameVisibility(settings, bar)
	local w = LibGUI("BlackFrame")
	w:Resize(350, 105)
		
	w.lVisibility = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lVisibility:Resize(125)
	w.lVisibility:Position(10, 10)
	w.lVisibility:Font(Addon.FontHeadline)
	w.lVisibility:SetText(L"Visibility:")
	w.lVisibility:Align("left")
	w.lVisibility.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lVisibility, "General visibility options")
		end

	w.l1 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.l1:AnchorTo(w.lVisibility, "right", "left", 15, 0)
	--w.l1:Resize(60)
	w.l1:Font(Addon.FontText)
	w.l1:SetText(L"Show:")
	w.l1:Align("left")
	w.l1.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.l1, "If there is data, show it?")
		end

	w.c1 = w("Checkbox")
	w.c1:AnchorTo(w.l1, "right", "left", 5, 0)
	w.c1.OnLButtonUp =
		function()
			settings.show = w.c1:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == settings.show) then w.c1:Check() end

	w.lDynVisi = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lDynVisi:Resize(50)
	w.lDynVisi:AnchorTo(w.lVisibility, "bottomleft", "topleft", 5, 15)
	w.lDynVisi:Font(Addon.FontText)
	w.lDynVisi:SetText(L"Dyn.:")
	w.lDynVisi:Align("left")
	w.lDynVisi.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lDynVisi, "Select the visibility ruleset that this indicator should use. Set to none if this indicator should not use dynamic visibility")
		end
		
	w.cDynVisi = w("Combobox")
	w.cDynVisi:AnchorTo(w.lDynVisi, "right", "left", 5, 0)
	FillRuleSetDropdown("Visibility", w.cDynVisi)
	
	if ( settings.visibility_group ) then
		w.cDynVisi:Select(settings.visibility_group)	
	else
		w.cDynVisi:Select("none")	
	end

	if bar.state ~= "FTHP" and bar.state ~= "HTHP" and bar.state ~= "FTlvl" and bar.state ~= "HTlvl" then	-- prevent the user from doing stupid things
		w.lShowIfTarget = w("Label", nil, "EffigyAutoresizeLabelTemplate")
		w.lShowIfTarget:AnchorTo(w.lDynVisi, "bottomleft", "topleft", 0, 10)
		--w.lShowIfTarget:Resize(165)
		w.lShowIfTarget:Font(Addon.FontText)
		w.lShowIfTarget:SetText(L"Show if == target:")
		w.lShowIfTarget:Align("left")
		w.lShowIfTarget.OnMouseOver = 
			function() 
				Addon.SetToolTip(w.lShowIfTarget, "Shows the element if the entity behind this bar is also your target.", "Useful for Target Highlighting in Group Frames.", "Needless to say, this option is useless in your Friendly Target Frame.")
			end

		w.cShowIfTarget = w("Checkbox")
		w.cShowIfTarget:AnchorTo(w.lShowIfTarget, "right", "left", 5, 0)
		w.cShowIfTarget.OnLButtonUp =
			function()
				settings.show_if_target = w.cShowIfTarget:GetValue()
				bar:setup()
				bar:render()
			end
		if (true == settings.show_if_target) then w.cShowIfTarget:Check() end
	end
	return w
end

local function GetFrameAlpha(settings)
	local w = LibGUI("BlackFrame")
	w:Resize(350, 80)
	
	w.lAlpha = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lAlpha:Resize(70)	
	w.lAlpha:Font(Addon.FontHeadline)
	w.lAlpha:SetText(L"Alpha:")
	w.lAlpha:Align("left")
	w.lAlpha:Position(10,10)

	w.tAlpha = w("Textbox")
	w.tAlpha:Resize(60)
	w.tAlpha:AnchorTo(w.lAlpha, "right", "left", 5, 0)
	w.tAlpha:SetText(settings.alpha)
	
	w.lDynAlpha = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lDynAlpha:Resize(50)
	w.lDynAlpha:AnchorTo(w.lAlpha, "bottomleft", "topleft", 5, 15)
	w.lDynAlpha:Font(Addon.FontText)
	w.lDynAlpha:SetText(L"Dyn.:")
	w.lDynAlpha:Align("left")
	w.lDynAlpha.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lDynAlpha, "Select the alpha ruleset that this indicator should use. Set to none if this indicator should not use dynamic alpha")
		end
		
	w.cDynAlpha = w("Combobox")
	w.cDynAlpha:AnchorTo(w.lDynAlpha, "right", "left", 5, 0)
	FillRuleSetDropdown("Alpha", w.cDynAlpha)
	
	if ( settings.alpha_group ) then
		w.cDynAlpha:Select(settings.alpha_group)	
	else
		w.cDynAlpha:Select("none")
	end
	
	return w
end

local function GetFrameLabel(settings, bar)
	local w = LibGUI("BlackFrame")
	w:Resize(280, 240)

	w.lText = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lText:Resize(60)	
	w.lText:Font(Addon.FontHeadline)
	w.lText:SetText(L"Text:")
	w.lText:Align("left")
	w.lText:Position(10,10)

	w.lFormat = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lFormat:Resize(135)
	w.lFormat:AnchorTo(w.lText, "bottomleft", "topleft", 0, 15)
	w.lFormat:Font(Addon.FontText)
	w.lFormat:SetText(L"Format String:")
	w.lFormat:Align("left")
	w.lFormat.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lFormat, "Text",
				"Valid tags:",
				"$title $lvl $per $value $max $cr $career $valdetail $missing $rangemin $rangemax $quest $npcTitle",
				"Tip: You can also access other states. Use $tag.statename")
		end
	
	w.tFormat = w("Textbox")
	w.tFormat:Resize(300)
	w.tFormat:AnchorTo(w.lFormat, "bottomleft", "topleft", 0, 15)
	w.tFormat:SetText(settings.formattemplate)
	
	w.cFont = w("Combobox")
	w.cFont:AnchorTo(w.tFormat, "bottomleft", "topleft", 0, 15)
	for k,v in pairs(Addon.Fonts) do w.cFont:Add(v) end
	w.cFont:Select(settings.font.name)

	w.lNumChars = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lNumChars:Resize(165)
	w.lNumChars:AnchorTo(w.cFont, "bottomleft", "topleft", 0, 15)
	w.lNumChars:Font(Addon.FontText)
	w.lNumChars:SetText(L"Num of characters:")
	w.lNumChars:Align("left")
	w.lNumChars.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lNumChars, "Maximum number of characters",
				"If the info is longer than this number the exceeding letters are cut",
				"Default: 14")
		end
	
	w.bNumChars = w("Textbox")
	w.bNumChars:Resize(60)
	w.bNumChars:AnchorTo(w.lNumChars, "right", "left", 5, 0)
	if (settings.clip_after == nil) then 
		w.bNumChars:SetText(14)
	else
		w.bNumChars:SetText(settings.clip_after)
	end
	
	
	--[[
	w.lTemplate = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lTemplate:Resize(95)
	w.lTemplate:AnchorTo(w.lFormat, "bottomleft", "topleft", 0, 35)
	w.lTemplate:Font(Addon.FontText)
	w.lTemplate:SetText(L"Template:")
	w.lTemplate:Align("left")
	w.lTemplate.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lTemplate, "How should the label text look like?")
		end	
	
	w.cTemplate = w("Combobox")
	w.cTemplate:AnchorTo(w.lTemplate, "right", "left", 0, 0)
	w.cTemplate:Add("$per")
	w.cTemplate:Add("$per%")
	w.cTemplate:Add("$value/$max")
	w.cTemplate:Add("$valdetail")
	w.cTemplate:Add("$valdetail/$max")
	w.cTemplate:Add("$missing")
	]]--

	w.lAlign = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlign:Resize(95)
	w.lAlign:Font(Addon.FontText)
	w.lAlign:AnchorTo(w.lNumChars, "bottomleft", "topleft", 0, 15)
	w.lAlign:SetText(L"Text Align:")
	w.lAlign:Align("left")
	w.lAlign.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlign, "A Point on the info Text to attach to",
				"Examples: right, left, center")
		end

	w.cAlign = w("tinycombobox")
	w.cAlign:AnchorTo(w.lAlign,  "right", "left", 5, 0)
	FillAlignDropdown(w.cAlign)
	w.cAlign:Select(settings.font.align)

	--[[w.lFollowBar = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lFollowBar:AnchorTo(w.lAlign, "bottomleft", "topleft", 0, 0)
	w.lFollowBar:Resize(100)
	w.lFollowBar:Font(Addon.FontText)
	w.lFollowBar:SetText(L"Follow Bar:")
	w.lFollowBar:Align("left")
	w.lFollowBar.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lFollowBar, "Follow the colored bar part",
				"If this is set the Point and to_anchor are ignored and the percent value moves with the bar value")
		end

	w.cFollowBar = w("Checkbox")
	w.cFollowBar:AnchorTo(w.lFollowBar, "right", "left", 0, 0)
	w.cFollowBar.OnLButtonUp =
		function()
			if (true == w.cFollowBar:GetValue()) then
				settings.follow = "bar"
			else
				settings.follow = "no"
			end
			bar:setup()
			bar:render()
		end
	if ("bar" == settings.follow) then w.cFollowBar:Check() end
	]]--
--convert to HideWhenEmptyFull
	--[[w.lAlwaysShow = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lAlwaysShow:AnchorTo(w.lAlign, "bottomleft", "topleft", 0, 0)
	w.lAlwaysShow:Resize(120)
	w.lAlwaysShow:Font(Addon.FontText)
	w.lAlwaysShow:SetText(L"Always Show:")
	w.lAlwaysShow:Align("left")
	w.lAlwaysShow.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlwaysShow, "By default we hide the percent at full, this will always show it")
		end

	w.cAlwaysShow = w("Checkbox")
	w.cAlwaysShow:AnchorTo(w.lAlwaysShow, "right", "left", 0, 0)
	w.cAlwaysShow.OnLButtonUp =
		function()
			settings.always_show = w.cAlwaysShow:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == settings.always_show) then w.cAlwaysShow:Check() end
	]]--
	--[[
	w.lHideWhenMinMax = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lHideWhenMinMax:AnchorTo(w.lAlign, "bottomleft", "topleft", 0, 0)
	w.lHideWhenMinMax:Resize(120)
	w.lHideWhenMinMax:Font(Addon.FontText)
	w.lHideWhenMinMax:SetText(L"Hide when Min/Max:")
	w.lHideWhenMinMax:Align("left")
	w.lHideWhenMinMax.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lHideWhenMinMax, "By default the label will be always shown.", "This will hide it when percent is 0 or 100.")
		end

	w.cHideWhenMinMax = w("Checkbox")
	w.cHideWhenMinMax:AnchorTo(w.lHideWhenMinMax, "right", "left", 0, 0)
	w.cHideWhenMinMax.OnLButtonUp =
		function()
			settings.HideWhenMinMax = w.cHideWhenMinMax:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == settings.HideWhenMinMax) then w.cHideWhenMinMax:Check() end
	]]--

	w.lCase = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lCase:Resize(95)
	w.lCase:Font(Addon.FontText)
	w.lCase:AnchorTo(w.lAlign, "bottomleft", "topleft", 0, 15)
	w.lCase:SetText(L"Case:")
	w.lCase:Align("left")
	w.lCase.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lCase, "Manipulate the case of the string",
				"Choices: upper, lower, none")
		end

	w.cCase = w("tinycombobox")
	w.cCase:AnchorTo(w.lCase,  "right", "left", 5, 0)
	w.cCase:Clear()
	w.cCase:Add("none")
	w.cCase:Add("upper")
	w.cCase:Add("lower")
	if settings.font.case then
		w.cCase:Select(settings.font.case)
	else
		w.cCase:Select("none")
	end
	
	return w
end

local function GetFrameTexture(settings)
	local w = LibGUI("BlackFrame")
	w:Resize(280, 240)
	
	w.lTexture = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lTexture:Resize(95)
	w.lTexture:Position(10, 10)
	w.lTexture:Font(Addon.FontHeadline)
	w.lTexture:SetText(L"Texture:")
	w.lTexture:Align("left")
	w.lTexture.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lTexture, "Which texture should the bar use?")
		end

	-- does not seem to work sadly
	--[[w.lFlipped = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lFlipped:Resize(70)
	w.lFlipped:AnchorTo(w.lTexture, "right", "left", 0, 0)
	w.lFlipped:Font(Addon.FontText)
	w.lFlipped:SetText(L"Flipped:")
	w.lFlipped:Align("left")
	
	w.ckFlipped = w("Checkbox")
	w.ckFlipped:AnchorTo(w.lFlipped, "right", "left", 0, 0)
	w.ckFlipped:SetValue(settings.texture.flipped)
	]]--
	
	w.cTexture = w("Combobox")
	w.cTexture:AnchorTo(w.lTexture, "bottomleft", "topleft", 5, 0)
	Addon.FillTextureDropdown(w.cTexture)
	
	w.cTexture:Select(settings.texture.name)
	
	w.Size = GetFrameSize(settings.texture)
	w.Size:Parent(w)
	w.Size:AnchorTo(w.cTexture, "bottomleft", "topleft", 0, 0)
	
	w.lTextureDyn = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lTextureDyn:Resize(155)
	w.lTextureDyn:AnchorTo(w.Size, "bottomleft", "topleft", 0, 5)
	w.lTextureDyn:Font(Addon.FontText)
	w.lTextureDyn:SetText(L"Dynamic Texture:")
	w.lTextureDyn:Align("left")
	w.lTextureDyn.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lTextureDyn, "Which dynamic texture ruleset should the bar border use? Select none if you do not want dynamic texture switching.")
		end

	w.cTextureDyn = w("Combobox")
	w.cTextureDyn:AnchorTo(w.lTextureDyn, "bottomleft", "topleft", 0, 0)
	FillRuleSetDropdown("Textures", w.cTextureDyn)
	
	if (settings.texture.texture_group) then
		w.cTextureDyn:Select(settings.texture.texture_group)
	else
		w.cTextureDyn:Select("none")
	end
	
	return w
end

--
-- /SubFrames
--

--
--	General Settings Panel ---------------------------------------------------
--

Addon.GeneralBarSettings = {}
function Addon.GeneralBarSettings.Create()
	if not DoesWindowExist(SettingsWindow.."General") then
		CreateWindowFromTemplate(SettingsWindow.."General", Addon.Name.."BarTemplateGeneral", SettingsWindow)
	end
	-- Third step: set tab buttons
	ButtonSetText(SettingsWindow.."GeneralTabBehaviour", L"Behaviour")
	ButtonSetText(SettingsWindow.."GeneralTabVisibility", L"Visibility")
	ButtonSetText(SettingsWindow.."GeneralTabPositioning", L"Positioning")
	
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabBehaviour", true)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabPositioning", false)
	
	-- Final step: show everything
	WindowSetShowing(SettingsWindow.."General", true)
end

function Addon.GeneralBarSettings.CreateBehaviour()
	local w, bar = Addon.CreateEditBarSettingsStart()
	w:AnchorTo(SettingsWindow.."General", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."General")

	w.lBarState = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lBarState:Resize(175)
	w.lBarState:Position(25,20)
	w.lBarState:Font(Addon.FontText)
	w.lBarState:SetText(L"Bar State:")
	w.lBarState:Align("left")
	w.lBarState.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lBarState, "A Bar gets it's value from 1 State",
				"Connect a bar to a State to have it set it's value based on the States value",
				"The bar will redraw (update) when this State (or a watched state) changes")
		end

	w.cState = w("Combobox")
	w.cState:AnchorTo(w.lBarState, "right", "left", 5, 0)
	tt={}
	table.foreach(CoreAddon.States, 
		function (k,v) 
			if (nil == v.hidden)or(false == v.hidden) then table.insert (tt, k) end
		end)
	table.sort(tt)
	
	for k,v in pairs(tt) do w.cState:Add(v) end
	w.cState:Select(bar.state)

	w.lSetInteractive = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lSetInteractive:Resize(175)
	w.lSetInteractive:AnchorTo(w.lBarState, "bottomleft", "topleft", 0, 15)
	w.lSetInteractive:Font(Addon.FontText)
	w.lSetInteractive:SetText(L"Click Behaviour:")
	w.lSetInteractive:Align("left")
	w.lSetInteractive.OnMouseOver = 
		function()
			Addon.SetToolTip(w.lSetInteractive, "Is this bar Interactive?",
				"player: LClick = Target Player, RClick = Player Menu",
				"group: LClick = Target Group Member, RClick = Group Menu",
				"friendly: RClick = Friendly Menu",
				"state: Mouse-Over = State Information",
				"none: 'click through' bar") 
		end

	w.cInteractive = w("smallcombobox")
	w.cInteractive:AnchorTo(w.lSetInteractive, "right", "left", 5, 0)

	w.cInteractive:Add("none")
	w.cInteractive:Add("player")
	w.cInteractive:Add("friendly")
	w.cInteractive:Add("group")
	w.cInteractive:Add("formation")
	w.cInteractive:Add("state")
	if (not bar.interactive_type) then
		w.cInteractive:Select("none")
	else
		w.cInteractive:Select(bar.interactive_type)
	end
	
	--Watch State
	--[[w.lWatchState = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lWatchState:Resize(150)
	w.lWatchState:AnchorTo(w.lSetInteractive, "bottomleft", "topleft", 0, 5)
	w.lWatchState:Font(Addon.FontText)
	w.lWatchState:SetText(L"Watch State:")
	w.lWatchState:Align("left")
	w.lWatchState.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lWatchState, "A Bar redraws (updates it's values) when a watched State changes",
				"Ex: Have a bar Watch Combat State to have it redraw as soon as you enter and leave combat")
		end

	w.cWatchState = w("Combobox")
	w.cWatchState:AnchorTo(w.lWatchState, "bottomleft", "topleft", 20, 0)
	tt={}
	table.foreach(CoreAddon.States,
		function (k,v) 
			if (nil == v.hidden)or(false == v.hidden) then table.insert (tt, k) end
		end)
	table.sort(tt)
	for k,v in pairs(tt) do w.cWatchState:Add(v) end

	w.bWatchState = w("Button", nil, Addon.ButtonInherits)
	w.bWatchState:Resize(70)
	w.bWatchState:SetText(L"Watch")
	w.bWatchState:AnchorTo(w.cWatchState, "bottomleft", "topleft", 0, 10)
	w.bWatchState.OnLButtonUp = 
		function()
			bar:watchState(WStringToString(w.cWatchState:Selected()))
			bar:setup()
			bar:render()

			w.c3:Clear()
			for k,b in pairs(bar.watching_states) do w.c3:Add(b) end
		end

	w.l3 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.l3:Resize(250)
	w.l3:Position(25,260)
	w.l3:Font(Addon.FontText)
	w.l3:SetText(L"Stop Watching A State:")
	w.l3:Align("left")
	w.l3.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.l3, "A Bar updates when a watched State changes",
				"Ex: Have a bar Watch Combat State to have it redraw as soon as you enter and leave combat")
		end

	w.c3 = w("Combobox")
	w.c3:AnchorTo(w.l3, "bottomleft", "topleft", 20, 0)
	for k,b in pairs(bar.watching_states) do w.c3:Add(b) end

	w.b3 = w("Button", nil, Addon.ButtonInherits)
	w.b3:Resize(130)
	w.b3:SetText(L"Stop Watching")
	w.b3:AnchorTo(w.c3, "bottomleft", "topleft", 0, 10)
	w.b3.OnLButtonUp = 
		function()
			bar:stopWatchingState(WStringToString(w.c3:Selected()))
			bar:setup()
			bar:render()
			w.c3:Clear()
			for k,b in pairs(bar.watching_states) do w.c3:Add(b) end
		end
		
	]]--
	
	w.lSlowChange = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lSlowChange:Resize(175)
	w.lSlowChange:AnchorTo(w.lSetInteractive, "bottomleft", "topleft", 0, 15)
	w.lSlowChange:Font(Addon.FontText)
	w.lSlowChange:SetText(L"Slow Changing Value:")
	w.lSlowChange:Align("left")
	w.lSlowChange.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSlowChange, "Do not treat this bar as in-combat if it's value is < 100%",
				"Example: If you have a bar connected to Exp state, you might use this to ensure both your in combat and out of combat settings are used when you expect them to")
		end


	w.kSlowChange = w("Checkbox")
	w.kSlowChange:AnchorTo(w.lSlowChange, "right", "left", 5, 0)
	w.kSlowChange.OnLButtonUp =
		function()
			bar.slow_changing_value = w.kSlowChange:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == bar.slow_changing_value) then
		w.kSlowChange:Check()
	end
	
	
	w.lnoTip = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lnoTip:Resize(175)
	w.lnoTip:AnchorTo(w.lSlowChange, "bottomleft", "topleft", 0, 15)
	w.lnoTip:Font(Addon.FontText)
	w.lnoTip:SetText(L"No Tooltip:")
	w.lnoTip:Align("left")
	w.lnoTip.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lnoTip, "Do not show a tooltip for this bar.")
		end
		
	w.knoTip = w("Checkbox")
	w.knoTip:AnchorTo(w.lnoTip, "right", "left", 5, 0)
	w.knoTip.OnLButtonUp =
		function()
			bar.no_tooltip = w.knoTip:GetValue()

			bar:setup()
			bar:render()
		end
	if (true == bar.no_tooltip) then
		w.knoTip:Check()
	end

	w.lLayer = w("Label", w.name.."lLayer", "EffigyAutoresizeLabelTemplate")
	w.lLayer:Font(Addon.FontText)
	w.lLayer:AnchorTo(w, "left", "left", 25, 25)
	w.lLayer:SetText(L"Layer:")
	w.lLayer:Align("left")
	w.lLayer.OnMouseOver =
	function() 
		Addon.SetToolTip(w.lLayer, "The Layer determines if the element is more to the front or to the back.",
			"All Layers are ´inside´ the parent.",
			"So, Layer ´Background´ with Parent ´Root´ is something else than Layer ´Background´ with Parent ´Bar´."
			)
	end

	w.cLayer = w("smallcombobox")
	w.cLayer:AnchorTo(w.lLayer, "right", "left", 5, 0)
	w.cLayer:Clear()
	w.cLayer:Add("background")
	w.cLayer:Add("default")
	w.cLayer:Add("secondary")
	w.cLayer:Add("popup")
	w.cLayer:Add("overlay")
	w.cLayer:Select(bar.layer or "default")
	
	w.bl2 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.bl2:Resize(55)
	w.bl2:Font(Addon.FontText)
	w.bl2:AnchorTo(w, "bottomleft", "bottomleft", 25, -25)
	w.bl2:SetText(L"Scale:")
	w.bl2:Align("left")
	w.bl2.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.bl2, "Scale the Bar",
				"A number from 0.1 and up")
		end

	w.btscale2 = w("Textbox")
	w.btscale2:Resize(80)
	w.btscale2:AnchorTo(w.bl2, "right", "left", 5, 0)
	local text = string.format("%1.3f", bar.scale)
	w.btscale2:SetText(text)
	
	w.apply = w("Button", nil, Addon.ButtonInherits)
	w.apply:Resize(Addon.ButtonWidth)
	w.apply:AnchorTo(w, "bottomright", "bottomright", -17, -20)
	w.apply:SetText(L"Apply")
	w.apply.OnLButtonUp = 
		function()
			-- state
			bar:useState(WStringToString(w.cState:Selected()))
			bar.interactive_type = WStringToString(w.cInteractive:Selected())
			
			--[[if (bar.interactive_type == "none") then
				bar.interactive = false
			else
				bar.interactive = true
			end]]--
			
			local layer = WStringToString(w.cLayer:Selected())
			if layer ~= "default" then bar.layer = layer end
			
			local scale = WStringToString(w.btscale2:GetText())
			scale = tonumber(scale)
			if scale == nil then scale = 0.6 end
			bar.scale = scale
			
			bar:setup()
			bar:render()			
		end
	w.apply.OnMouseOver = function() Addon.SetToolTip(w.apply, "Save change to bar") end
	
	Addon.CreateEditBarSettingsEnd(w)
end

function Addon.GeneralBarSettings.CreateVisibility()
	local w, bar = Addon.CreateEditBarSettingsStart()
	w:AnchorTo(SettingsWindow.."General", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."General")

	w.lShow = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShow:Resize(175)
	w.lShow:Position(25,20)
	w.lShow:Font(Addon.FontText)
	w.lShow:SetText(L"Show Bar:")
	w.lShow:Align("left")
	w.lShow.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lShow, "Show / Hide the whole bar")
		end


	w.kShow = w("Checkbox")
	w.kShow:AnchorTo(w.lShow, "right", "left", 5, 0)
	w.kShow.OnLButtonUp =
		function()
			bar.show = w.kShow:GetValue()

			bar:setup()
			bar:render()
		end
	if (true == bar.show) then
		w.kShow:Check()
	end

	w.lShowWith = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShowWith:Resize(175)
	w.lShowWith:AnchorTo(w.lShow, "bottomleft", "topleft", 0, 15)
	w.lShowWith:Font(Addon.FontText)
	w.lShowWith:SetText(L"Show With Friendly Target:")
	w.lShowWith:Align("left")
	w.lShowWith.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lShowWith, "If the bar has a entitiy behind it, treat it as in-combat")
		end

	w.kShowWith = w("Checkbox")
	w.kShowWith:AnchorTo(w.lShowWith, "right", "left", 5, 0)
	w.kShowWith.OnLButtonUp =
		function()
			bar.show_with_target = w.kShowWith:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == bar.show_with_target) then
		w.kShowWith:Check()
	end

	w.lShowWith_HT = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShowWith_HT:Resize(175)
	w.lShowWith_HT:AnchorTo(w.lShowWith, "bottomleft", "topleft", 0, 15)
	w.lShowWith_HT:Font(Addon.FontText)
	w.lShowWith_HT:SetText(L"Show With Hostile Target:")
	w.lShowWith_HT:Align("left")
	w.lShowWith_HT.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lShowWith_HT, "If the bar has a entitiy behind it, treat it as in-combat")
		end

	w.kShowWith_HT = w("Checkbox")
	w.kShowWith_HT:AnchorTo(w.lShowWith_HT, "right", "left", 5, 0)
	w.kShowWith_HT.OnLButtonUp =
		function()
			bar.show_with_target_ht = w.kShowWith_HT:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == bar.show_with_target_ht) then
		w.kShowWith_HT:Check()
	end	
	
	w.lHideIfZero = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lHideIfZero:Resize(175)
	w.lHideIfZero:AnchorTo(w.lShowWith_HT, "bottomleft", "topleft", 0, 15)
	w.lHideIfZero:Font(Addon.FontText)
	w.lHideIfZero:SetText(L"Hide If Zero:")
	w.lHideIfZero:Align("left")
	w.lHideIfZero.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lHideIfZero, "If this bars value is 0, hide the bar")
		end


	w.kHideIfZero = w("Checkbox")
	w.kHideIfZero:AnchorTo(w.lHideIfZero, "right", "left", 5, 0)
	w.kHideIfZero.OnLButtonUp =
		function()
			bar.hide_if_zero = w.kHideIfZero:GetValue()

			bar:setup()
			bar:render()
		end
	if (true == bar.hide_if_zero) then
		w.kHideIfZero:Check()
	end


	w.lHideIfTarget = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lHideIfTarget:Resize(175)
	w.lHideIfTarget:AnchorTo(w.lHideIfZero, "bottomleft", "topleft", 0, 15)
	w.lHideIfTarget:Font(Addon.FontText)
	w.lHideIfTarget:SetText(L"Hide If target:")
	w.lHideIfTarget:Align("left")
	w.lHideIfTarget.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lHideIfTarget, "Hides this bar when you select the unit, usefull for world object attached bars")
		end


	w.kHideIfTarget = w("Checkbox")
	w.kHideIfTarget:AnchorTo(w.lHideIfTarget, "right", "left", 5, 0)
	w.kHideIfTarget.OnLButtonUp =
		function()
			bar.hide_if_target = w.kHideIfTarget:GetValue()

			bar:setup()
			bar:render()
		end
	if (true == bar.hide_if_target) then
		w.kHideIfTarget:Check()
	end
	
	if bar.state == "FTHP" or bar.state == "HTHP" or bar.state == "FTlvl" or bar.state == "HTlvl" then	-- prevent the user from doing stupid things
		w.lShowWith:Hide()
		w.kShowWith:Hide()
		w.lShowWith_HT:Hide()
		w.kShowWith_HT:Hide()
		w.lHideIfTarget:Hide()
		w.kHideIfTarget:Hide()
	end
	
	w.lDynVisi = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lDynVisi:Resize(175)
	w.lDynVisi:AnchorTo(w.lHideIfTarget, "bottomleft", "topleft", 0, 15)
	w.lDynVisi:Font(Addon.FontText)
	w.lDynVisi:SetText(L"Dynamic visibility:")
	w.lDynVisi:Align("left")
	w.lDynVisi.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lDynVisi, "Select the visibility ruleset that this bar should use. Set to none if this bar should not use dynamic visibility")
		end
		
	
	w.cDynVisi = w("Combobox")
	w.cDynVisi:AnchorTo(w.lDynVisi, "right", "left", 5, 0)
	FillRuleSetDropdown("Visibility", w.cDynVisi)
	
	if ( bar.visibility_group ) then
		w.cDynVisi:Select(bar.visibility_group)	
	else
		w.cDynVisi:Select("none")	
	end
	
	w.Alpha = GetFrameAlpha(bar.alphasettings)
	w.Alpha:Parent(w)
	w.Alpha:AnchorTo(w.lDynVisi, "bottomleft", "topleft", 0, 15)
	
	w.apply = w("Button", nil, Addon.ButtonInherits)
	w.apply:Resize(Addon.ButtonWidth)
	w.apply:AnchorTo(w, "bottomright", "bottomright", -17, -20)
	w.apply:SetText(L"Apply")
	w.apply.OnLButtonUp = 
		function()
            bar.visibility_group = WStringToString(w.cDynVisi:Selected())
			
			-- Alpha
			local alpha = WStringToString(w.Alpha.tAlpha:GetText())
			alpha = tonumber(alpha)
			if (nil == alpha) then alpha = 1 end
			bar.alphasettings.alpha = alpha
			
			local dynAlpha = WStringToString(w.Alpha.cDynAlpha:Selected())
			if ("" == dynAlpha) then dynAlpha = "none" end
			bar.alphasettings.alpha_group = dynAlpha
			-- /Alpha
			
			bar:setup()
			bar:render()			
		end
	Addon.CreateEditBarSettingsEnd(w)
end

function Addon.GetPositionWindowForBar(bar)
	local w = LibGUI("Blackframe")
	--local barname = bar.name
	w:Resize(700,110)
	
	w.lBarName = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lBarName:Resize(210)
	w.lBarName:Position(10,20)
	w.lBarName:Font(Addon.FontBold)
	w.lBarName:SetText(bar.name)
	w.lBarName:Align("left")
	w.lBarName.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lBarName, "The name of the bar.")
		end

	w.lLockFrom = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lLockFrom:AnchorTo(w.lBarName, "right", "left", 10, 0)
	w.lLockFrom:Resize(60)
	w.lLockFrom:Font(Addon.FontText)
	w.lLockFrom:SetText(L"Lock:")
	w.lLockFrom:Align("left")
	w.lLockFrom.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lLockFrom, "The Layout Editor can (and does) override these settings at will/randomly.",
				"I can't 'fix' that so if you have edited these options I suggest locking this bar from the LayoutEditor to prevent the LayoutEditor from doing stupid things to your bar")
		end

	w.cLockFrom = w("Checkbox")
	w.cLockFrom:AnchorTo(w.lLockFrom, "right", "left", 5, 0)
	w.cLockFrom.OnLButtonUp =
		function()
			bar.block_layout_editor = w.cLockFrom:GetValue()
		end
	if (true == bar.block_layout_editor) then
		w.cLockFrom:Check()
	end
	
	w.lMy_anchor = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lMy_anchor:Resize(70)
	w.lMy_anchor:Font(Addon.FontText)
	w.lMy_anchor:AnchorTo(w.lBarName, "bottomleft", "topleft", 0, 15)
	w.lMy_anchor:SetText(L"Anchor:")
	w.lMy_anchor:Align("left")
	w.lMy_anchor.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lMy_anchor, "A Point on the RelWin to attach to",
				"Examples: topleft, bottomleft, topright, bottomright, right, left")
		end


	w.cMy_anchor = w("smallcombobox")
	w.cMy_anchor:AnchorTo(w.lMy_anchor, "right", "left", 5, 0)
	FillAnchorDropdown(w.cMy_anchor)
	
	w.cMy_anchor:Select(bar.anchors[1].point)	
	
	w.tRelWin = w("Textbox")
	w.tRelWin:Resize(230)
	w.tRelWin:AnchorTo(w, "topright", "topright", -10, 5)
	w.tRelWin:SetText(bar.anchors[1].parent)
	
	w.lRelWin = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lRelWin:Resize(145)
	w.lRelWin:AnchorTo(w.tRelWin, "left", "right", -5, 0)
	w.lRelWin:Font(Addon.FontText)
	w.lRelWin:SetText(L"Target Window:")
	w.lRelWin:Align("left")
	w.lRelWin.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lRelWin, "Position this bar Relative to another Window (bar) on the screen",
				"Example: Use PlayerHP as a RelWin to attach another bar to the PlayerHP Bar",
				"Tip: Root is the main window")
		end

	w.lTo_anchor = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lTo_anchor:Resize(105)
	w.lTo_anchor:Font(Addon.FontText)
	w.lTo_anchor:AnchorTo(w.tRelWin, "bottomleft", "topleft", 0, 5)
	w.lTo_anchor:SetText(L"To Anchor:")
	w.lTo_anchor:Align("left")
	w.lTo_anchor.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lTo_anchor, "A Point on the Bar to attach to",
				"Examples: topleft, bottomleft, topright, bottomright, right, left")
		end

	w.cTo_anchor = w("smallcombobox")
	w.cTo_anchor:AnchorTo(w.lTo_anchor, "right", "left", 5, 0)
	FillAnchorDropdown(w.cTo_anchor)
	
	w.cTo_anchor:Select(bar.anchors[1].parentpoint)
	
	w.lOffset = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lOffset:Resize(60)
	w.lOffset:Font(Addon.FontText)
	w.lOffset:AnchorTo(w.lTo_anchor, "bottomleft", "topleft", 0, 15)
	w.lOffset:SetText(L"Offset:")
	w.lOffset:Align("left")
	w.lOffset.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lOffset, "The Position (relative to RelWin) to place the bar",
				"Just a number")
		end
		
	--[[w.lX = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lX:Resize(20)
	w.lX:Font(Addon.FontText)
	w.lX:AnchorTo(w.lOffset, "right", "left", 5, 0)
	w.lX:SetText(L"X")
	w.lX:Align("left")
	w.lX.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lX, "The X Position (relative to RelWin) to place the bar",
				"Just a number")
		end]]--

	w.tX = w("Textbox")
	w.tX:Resize(50)
	w.tX:AnchorTo(w.lOffset, "right", "left", 5, 0)
	w.tX:SetText(bar.anchors[1].x)

	--[[w.lY = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lY:Resize(15)
	w.lY:Font(Addon.FontText)
	w.lY:AnchorTo(w.tX, "right", "left", 5, 5)
	w.lY:SetText(L"Y")
	w.lY:Align("left")
	w.lY.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lY, "The Y Position (relative to RelWin) to place the bar"
				)
		end]]--

	w.tY = w("Textbox")
	w.tY:Resize(50)
	w.tY:AnchorTo(w.tX, "right", "left", 5, 0)
	w.tY:SetText(bar.anchors[1].y)
	
	w.lAttachTo = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lAttachTo:AnchorTo(w.lRelWin, "bottomright", "topright", -25, 15)
	w.lAttachTo:Resize(145)
	w.lAttachTo:Font(Addon.FontText)
	w.lAttachTo:SetText(L"Attach to WObj:")
	w.lAttachTo:Align("left")
	w.lAttachTo.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAttachTo, "Attach the Bar to a World Object",
				"If the Bars State has a World Object (like a Hostile Target or Group Member) then place this bar on that object",
				"Note: Use the Manual Positioning to position your bar relative to the target.  Imagine you are positioning it relative to the target's Name Plate",
				"Example: Point:top, to_anchor:bottom, X:0, Y:0")
		end

	local old_relwin = "Root"
	if (false == bar.pos_at_world_object) then
		old_relwin = bar.anchors[1].parent
	end
	w.klAttachTo = w("Checkbox")
	w.klAttachTo:AnchorTo(w.lAttachTo, "right", "left", 5, 0)
	w.klAttachTo.OnLButtonUp =
		function()
			bar.pos_at_world_object = w.klAttachTo:GetValue()
			if (false == w.klAttachTo:GetValue()) then
				bar.anchors[1].parent = old_relwin
			end
			bar:setup()
			bar:render()
		end
	if (true == bar.pos_at_world_object) then
		w.klAttachTo:Check()
	end
	
	w.apply = w("Button", nil, Addon.ButtonInherits)
	w.apply:Resize(Addon.ButtonWidth)
	w.apply:AnchorTo(w, "bottom", "bottom", -85, -10)
	w.apply:SetText(L"Apply")
	w.apply:Resize(90)
	w.apply.OnLButtonUp = 
		function()
			local point = WStringToString(w.cMy_anchor:Selected())
			if ("" == point) then point = "center" end
			
			local parentpoint = WStringToString(w.cTo_anchor:Selected())
			if ("" == parentpoint) then parentpoint = "center" end
	
			local x = WStringToString(w.tX:GetText())
			x = tonumber(x)
			if (nil == x) then x = 0 end
	
			local y = WStringToString(w.tY:GetText())
			y = tonumber(y)
			if (nil == y) then y = 0 end

			local name = WStringToString(w.tRelWin:GetText())
			if ("" == name) then name = "none" end			
			if (false == bar.pos_at_world_object) then
				local isAllowedToAnchor = true
				if DoesWindowExist(name) then
					if name ~= bar.name then
						local isAllowedToAnchor = true
						if name ~= "Root" then
							for i = 1, WindowGetAnchorCount(name) do
								local _, _, parent, _, _ = WindowGetAnchor(name, i)
								if parent == bar.name then
									isAllowedToAnchor = false
									break
								end
							end
						end
						if isAllowedToAnchor then
							bar.anchors[1].parent = name
						else
							-- circular reference detected error
							local dialogText = L"Circular Reference detected.<br>Anchor Target Window not applied!"
							DialogManager.MakeOneButtonDialog( dialogText, GetString( StringTables.Default.LABEL_YES ))
						end
					else
						-- self reference detected error
						local dialogText = L"Self Reference detected.<br>Anchor Target Window not applied!"
						DialogManager.MakeOneButtonDialog( dialogText, GetString( StringTables.Default.LABEL_YES ))						
					end
				else
					-- Anchor Parent does not exist error
					local dialogText = L"Anchor Target Window does not exist!<br>Anchor Target Window not applied!"
					DialogManager.MakeOneButtonDialog( dialogText, GetString( StringTables.Default.LABEL_YES ))
				end
			end
			
			
			bar.anchors[1].point = point
			bar.anchors[1].parentpoint = parentpoint
			bar.anchors[1].x = x
			bar.anchors[1].y = y			

			bar:setup()
			bar:render()			
		end
	w.apply.OnMouseOver = function() Addon.SetToolTip(w.apply, "Save change to bar") end
	
	return w

end

function Addon.GeneralBarSettings.CreatePositioning()
	local w, bar = Addon.CreateEditBarSettingsStart()
	w:AnchorTo(SettingsWindow.."General", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."General")
	
	local multi = {
		[1] = { "grp1hp", "grp2hp", "grp3hp", "grp4hp", "grp5hp", "grp6hp" },
		[2] = { "grp1ap", "grp2ap", "grp3ap", "grp4ap", "grp5ap", "grp6ap" },
		[3] = { "grp1morale", "grp2morale", "grp3morale", "grp4morale", "grp5morale", "grp6morale" },
		[4] = { "grpCF1hp", "grpCF2hp", "grpCF3hp", "grpCF4hp", "grpCF5hp", "grpCF6hp" },
		[5] = { "grpCH1hp", "grpCH2hp", "grpCH3hp", "grpCH4hp", "grpCH5hp", "grpCH6hp" },
		[6] = { "formation11hp", "formation12hp", "formation13hp", "formation14hp", "formation15hp", "formation16hp" },
		[7] = { "formation21hp", "formation22hp", "formation23hp", "formation24hp", "formation25hp", "formation26hp" },
		[8] = { "formation31hp", "formation32hp", "formation33hp", "formation34hp", "formation35hp", "formation36hp" },
		[9] = { "formation41hp", "formation42hp", "formation43hp", "formation44hp", "formation45hp", "formation46hp" },
		[10] = { "formation51hp", "formation52hp", "formation53hp", "formation54hp", "formation55hp", "formation56hp" },
		[11] = { "formation61hp", "formation62hp", "formation63hp", "formation64hp", "formation65hp", "formation66hp" },
		[12] = { "PlayerHP"}
	}
	local useMulti
	for k, v in ipairs(multi) do
		for _, stateName in pairs(v) do
			if bar.state == stateName then
				useMulti = k
				break
			end		
		end
		if useMulti ~= nil then break end
	end
	if useMulti ~= nil then
		local lastObj
		for _, stateName in ipairs(multi[useMulti]) do
			for k, stateBar in ipairs(EffigyState:GetState(stateName).bars) do
				if bar.pos_at_world_object ~= stateBar.pos_at_world_object then continue end
				local windowString = "Position"..stateName..stateBar.name
				w[windowString] = Addon.GetPositionWindowForBar(stateBar)
				if k == 2 then DEBUG(L"Multiple Bars per state are not supported for this state positioning atm, are they?") end
				if lastObj == nil then 
					w[windowString]:AnchorTo(w, "topleft", "topleft", 0, 0)
				else
					w[windowString]:AnchorTo(lastObj, "bottomleft", "topleft", 0, 0)
				end
				lastObj = w[windowString]
				w[windowString]:Parent(w)
				if bar.state == stateBar.state then w[windowString].lBarName:Color(200, 0, 0) end
			end
		end
	else
		w.Position = Addon.GetPositionWindowForBar(bar)
		w.Position:Parent(w)
		w.Position:AnchorTo(w, "topleft", "topleft", 0, 0)
	end

	Addon.CreateEditBarSettingsEnd(w)
end

--
--	State Settings Panel ---------------------------------------------------
--

Addon.StateBarSettings = {}
function Addon.StateBarSettings.Create()
	local w, bar = Addon.CreateEditBarSettingsStart()

	w.l2 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.l2:Resize(150)
	w.l2:Position(25,140)
	w.l2:Font(Addon.FontText)
	w.l2:SetText(L"Watch State:")
	w.l2:Align("left")
	w.l2.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.l2, "A Bar redraws (updates it's values) when a watched State changes",
				"Ex: Have a bar Watch Combat State to have it redraw as soon as you enter and leave combat")
		end

	w.c2 = w("Combobox")
	w.c2:AnchorTo(w.l2, "bottomleft", "topleft", 20, 0)
	tt={}
	for k,v in pairs(CoreAddon.States) do
		if not v.hidden then table.insert (tt, k) end
	end
	table.sort(tt)
	for k,v in pairs(tt) do w.c2:Add(v) end

	w.b2 = w("Button", nil, Addon.ButtonInherits)
	w.b2:Resize(70)
	w.b2:SetText(L"Watch")
	w.b2:AnchorTo(w.c2, "bottomleft", "topleft", 0, 10)
	w.b2.OnLButtonUp = 
		function()
			bar:watchState(WStringToString(w.c2:Selected()))
			bar:setup()
			bar:render()

			w.c3:Clear()
			for k,b in pairs(bar.watching_states) do w.c3:Add(b) end
		end

	w.l3 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.l3:Resize(250)
	w.l3:Position(25,260)
	w.l3:Font(Addon.FontText)
	w.l3:SetText(L"Stop Watching A State:")
	w.l3:Align("left")
	w.l3.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.l3, "A Bar updates when a watched State changes",
				"Ex: Have a bar Watch Combat State to have it redraw as soon as you enter and leave combat")
		end

	w.c3 = w("Combobox")
	w.c3:AnchorTo(w.l3, "bottomleft", "topleft", 20, 0)
	for k,b in pairs(bar.watching_states) do w.c3:Add(b) end

	w.b3 = w("Button", nil, Addon.ButtonInherits)
	w.b3:Resize(130)
	w.b3:SetText(L"Stop Watching")
	w.b3:AnchorTo(w.c3, "bottomleft", "topleft", 0, 10)
	w.b3.OnLButtonUp = 
		function()
			bar:stopWatchingState(WStringToString(w.c3:Selected()))
			bar:setup()
			bar:render()
			w.c3:Clear()
			for k,b in pairs(bar.watching_states) do w.c3:Add(b) end
		end


	Addon.CreateEditBarSettingsEnd(w)
end

--
--	Icon Settings Panel ---------------------------------------------------
--

Addon.IconBarSettings = {}
function Addon.IconBarSettings.Create()
	if not DoesWindowExist(SettingsWindow.."Icons") then
		CreateWindowFromTemplate(SettingsWindow.."Icons", Addon.Name.."BarTemplateIcons", SettingsWindow)
	end
	-- Third step: set tab buttons
	ButtonSetText(SettingsWindow.."IconsTabCareer", L"Career")
	ButtonSetText(SettingsWindow.."IconsTabRVR", L"RVR")
	ButtonSetText(SettingsWindow.."IconsTabStatus", L"Status")
	
	ButtonSetPressedFlag(SettingsWindow.."IconsTabCareer", true)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabRVR", false)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabStatus", false)
	
	-- Final step: show everything
	WindowSetShowing(SettingsWindow.."Icons", true)
end

function Addon.IconBarSettings.CreateIconWindow(iconname)
	local w, bar = Addon.CreateEditBarSettingsStart()
	local settings = bar[iconname]
	
	w:AnchorTo(SettingsWindow.."Icons", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."Icons")
	
	w.lType = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lType:Position(25,20)
	--w.lType:Resize(80)
	w.lType:Font(Addon.FontHeadline)
	
	iconname = towstring(iconname)
	if iconname == L"icon" then
		w.lType:SetText(L"Career")
	elseif iconname == L"rvr_icon" then
		w.lType:SetText(L"RVR")
	elseif iconname == L"status_icon" then
		w.lType:SetText(L"Status")
	end
	
	w.lType:Align("left")
	w.lType.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lType, "Type of the icon.")
		end
	
	w.lShow = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShow:AnchorTo(w.lType, "bottomleft", "topleft", 0, 15)
	--w.lShow:Resize(60)
	w.lShow:Font(Addon.FontText)
	w.lShow:SetText(L"Show:")
	w.lShow:Align("left")
	w.lShow.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lShow, "Enable or disable the Icon.")
		end
		
	w.ckShow = w("Checkbox")
	w.ckShow:AnchorTo(w.lShow, "right", "left", 5, 0)
	w.ckShow.OnLButtonUp =
		function()
			settings.show = w.ckShow:GetValue()
			bar:setup()
			bar:render()
		end
	if (true == settings.show) then w.ckShow:Check() end
	
	w.lScale = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lScale:Resize(60)
	w.lScale:Font(Addon.FontText)
	w.lScale:AnchorTo(w.ckShow, "right", "left", 10, 0)
	w.lScale:SetText(L"Scale:")
	w.lScale:Align("left")
	w.lScale.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lScale, "Scale the Icon relative to Bar Size",
				"A number from 0.1 and up")
		end

	w.tScale = w("Textbox")
	w.tScale:Resize(70)
	w.tScale:AnchorTo(w.lScale, "right", "left", 5, 0)
	local text = string.format("%1.3f", settings.scale)
	w.tScale:SetText(text)
	
	w.lAlphaFollow = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaFollow:Resize(165)
	w.lAlphaFollow:AnchorTo(w.lShow, "bottomleft", "topleft", 0, 15)
	w.lAlphaFollow:Font(Addon.FontText)
	w.lAlphaFollow:SetText(L"Alpha: Follow BG:")
	w.lAlphaFollow:Align("left")
	w.lAlphaFollow.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlphaFollow, "Border Alpha should follow Background Alpha?",
				"This must be disabled for the Alpha slider to work")
		end
	w.kAlphaFollow = w("Checkbox")
	w.kAlphaFollow:AnchorTo(w.lAlphaFollow, "right", "left", 5, 0)
	w.kAlphaFollow.OnLButtonUp =
		function()
			settings.follow_bg_alpha = w.kAlphaFollow:GetValue()
			bar:setup()
			bar:render()
		end
	if (settings.follow_bg_alpha and true == settings.follow_bg_alpha) then w.kAlphaFollow:Check() end
	
	w.lAlphaSet = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaSet:Resize(60)
	w.lAlphaSet:AnchorTo(w.kAlphaFollow, "right", "left", 10, 0)
	w.lAlphaSet:Font(Addon.FontText)
	w.lAlphaSet:SetText(L"Alpha:")
	w.lAlphaSet:Align("left")
	
	w.tAlpha = w("Textbox")
	w.tAlpha:Resize(60)
	w.tAlpha:AnchorTo(w.lAlphaSet, "right", "left", 5, 0)
	w.tAlpha:SetText(tonumber(string.format("%." .. (3 ) .. "f", settings.alpha)))
	
	w.AnchorOne = GetAnchorFrame(bar, settings.anchors[1])
	w.AnchorOne:Parent(w)
	w.AnchorOne:AnchorTo(w, "topright", "topright", -25, 20)

	w.apply = w("Button", nil, Addon.ButtonInherits)
	w.apply:Resize(Addon.ButtonWidth)
	w.apply:AnchorTo(w, "bottomright", "bottomright", -17, -20)
	w.apply:SetText(L"Apply")
	w.apply.OnLButtonUp = 
		function()
			local scale = tonumber(WStringToString(w.tScale:GetText()))
			if (nil == scale) then scale = 0 end
			
            local x = tonumber(WStringToString(w.AnchorOne.bt8:GetText()))
			if (nil == x) then x = 0 end
			local y = tonumber(WStringToString(w.AnchorOne.bt9:GetText()))
			if (nil == y) then y = 0 end
			local point = WStringToString(w.AnchorOne.cMy_Anchor:Selected())
			if ("" == point) then point = "center" end
			local parentpoint = WStringToString(w.AnchorOne.cTo_Anchor:Selected())
			if ("" == parentpoint) then parentpoint = "none" end
			local anchorparent = WStringToString(w.AnchorOne.cAnchorTo:Selected())
			if ("" == anchorparent) then anchorparent = "none" end
			
			local alpha = tonumber(WStringToString(w.tAlpha:GetText()))
            if (nil == alpha) then alpha = 1 end
            if (alpha >= 1) then alpha = 1 end
            w.tAlpha:SetText(alpha)
            
			settings.anchors[1].parent = anchorparent
			settings.anchors[1].parentpoint = parentpoint
			settings.anchors[1].point = point
			settings.anchors[1].x = x
			settings.anchors[1].y = y
			settings.alpha = alpha
			settings.scale = scale
			
			bar:setup()
			bar:render()			
		end
	w.apply.OnMouseOver = function() Addon.SetToolTip(w.apply, "Save change to bar") end
		
	Addon.CreateEditBarSettingsEnd(w)
end

--
--	Label and Image Settings Panel		--------------------------------
--

Addon.LabelImageBarSettings = {}
function Addon.LabelImageBarSettings.Create(n)
	local currentTab = Addon.GetCurrentTab()
	local settings = nil
	local bar =	CoreAddon.Bars[Addon.EditBar]
	if nil == bar then return end
	
	if currentTab == "Images" then
		settings = bar.images
	elseif currentTab == "Labels" then
		settings = bar.labels
	end
		
	if nil == n then
		local w,_ = Addon.CreateEditBarSettingsStart()
		w:AnchorTo(SettingsWindow, "topleft", "topleft", 0, 70)
		w:AddAnchor(SettingsWindow, "bottomright", "bottomright", 0, -70)
		
		-- Create new Frame
		w.l2 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
		w.l2:Resize(65)
		--w.l2:AnchorTo(w.l1, "right", "left", 0, 0)
		w.l2:AnchorTo(w, "topleft", "topleft", 10, 10)
		w.l2:Font(Addon.FontText)
		w.l2:SetText(L"Create:")
		w.l2:Align("left")
		w.l2:IgnoreInput()
		
		w.t1 = w("Textbox")
		w.t1:Resize(200)
		w.t1:AnchorTo(w.l2, "topright", "topleft", 10, 0)
		--w.t1:AddAnchor(w, "top", "topright", -10, 10)
		w.t1.OnKeyEnter =
			function()
				if (nil ~= w.t1:GetText()) and (L"" ~= w.t1:GetText()) then
					local newname = WStringToString(w.t1:GetText())
					if currentTab == "Images" then
						if nil == settings[newname] then
							settings[newname] = CoreAddon.GetDefaultImage()
							UF_RUNTIMECACHE[bar.name].Images[newname] = Effigy.Image.Create(bar, newname)
							UF_RUNTIMECACHE[bar.name].Images[newname]:Setup()
							UF_RUNTIMECACHE[bar.name].Images[newname]:Render()
							w.cBox:Add(newname)
							w.cBox:Select(newname)
							w.t1:Clear()
							Addon.OnSelChangedEditBarSettings()
						else
							EA_ChatWindow.Print(towstring(Addon.Name)..L": "..towstring(w.t1:GetText())..L" already exists!")
						end
					elseif currentTab == "Labels" then
						if nil == settings[newname] then
							settings[newname] = CoreAddon.GetDefaultLabel()
							UF_RUNTIMECACHE[bar.name].Labels[newname] = Effigy.Label.Create(bar, newname)
							UF_RUNTIMECACHE[bar.name].Labels[newname]:Setup()
							UF_RUNTIMECACHE[bar.name].Labels[newname]:Render()
							w.cBox:Add(newname)
							w.cBox:Select(newname)
							w.t1:Clear()
							Addon.OnSelChangedEditBarSettings()
						else
							EA_ChatWindow.Print(towstring(Addon.Name)..L": "..towstring(w.t1:GetText())..L" already exists!")
						end
					end
				end
			end
			--[[
		w.t1.OnKeyTab =
			function()
				if currentTab == "Images" then
					settings[WStringToString(w.t1:GetText())] = CoreAddon.GetDefaultImage()
					bar:AddImage(WStringToString(w.t1:GetText()))
				elseif currentTab == "Labels" then
					settings[WStringToString(w.t1:GetText())] = CoreAddon.GetDefaultLabel()
					bar:AddLabel(WStringToString(w.t1:GetText()))
				end
				w.cBox:Add(w.t1:GetText())
				w.cBox:Select(w.t1:GetText())
				Addon.OnSelChangedEditBarSettings()
			end
			]]--
		w.t1.OnKeyEscape =
			function()
				--EA_ChatWindow.Print(L"ESCAPE")
				w.t1:Clear()
			end
			
		w.cBox = w("Combobox", nil, Addon.Name.."BarEditBarSettingsComboBoxTemplate")
		w.cBox:AnchorTo(w.t1, "right", "left", 10, 0)
		w.cBox.OnRButtonUp = 
			function()
				if (nil ~= w.cBox:Selected()) and (L"" ~= w.cBox:Selected()) then
					local elementName = WStringToString(w.cBox:Selected())
					--Addon.LabelImageBarSettings.Create(selectedString)
				end				
				EA_ChatWindow.Print(L"This will become rename!")
			end
		FillLabelImageDropdown(w.cBox, settings)
		
		w.delButton = w("Button", nil, Addon.ButtonInherits)
		w.delButton:Resize(Addon.ButtonWidth)
		w.delButton:AnchorTo(w.cBox, "right", "left", 10, 0)
		w.delButton:SetText(L"Delete")
		w.delButton.OnLButtonUp = 
			function()
				if (nil ~= w.cBox:Selected()) and (L"" ~= w.cBox:Selected()) then
					local elementName = WStringToString(w.cBox:Selected())
					settings[elementName] = nil
					
					CoreAddon.DestroyBarElement(bar.name, currentTab, elementName)
					Addon.C:Destroy()
					FillLabelImageDropdown(w.cBox, settings)
				end					
			end
			
		Addon.CreateEditBarSettingsEnd(w)
	else
		local w,_ = Addon.CreateEditBarSettingsChildStart()
		
		w.Color = GetFrameColor(settings[n].colorsettings)
		w.Color:Parent(w)
		w.Color:AnchorTo(w, "topright", "topright", -5, 0)
		w.Color:AddAnchor(w, "center", "bottomleft", 0, -40)
		
		w.Visibility = GetFrameVisibility(settings[n], bar)
		w.Visibility:Parent(w)
		w.Visibility:AnchorTo(w, "topleft", "topleft", 5, 0)
		
		w.Alpha = GetFrameAlpha(settings[n])
		w.Alpha:Parent(w)
		w.Alpha:AnchorTo(w.Visibility, "bottomleft", "topleft", 0, 0)

		w.AnP = GetFrameAnchorAndPosition(settings[n], bar)
		w.AnP:Parent(w)
		w.AnP:AnchorTo(w.Alpha, "bottomleft", "topleft", 0, 0)
		--w.AnP:AddAnchor(w.Specific, "bottomleft", "bottomright", 0, 0)
		w.AnP:AddAnchor(w, "bottom", "bottomright", 0, 0)
		--[[w.Size = GetFrameSize(settings[n])
		w.Size:Parent(w)
		w.Size:AnchorTo(w.AnP, "bottomleft", "topleft", 0, 0)]]--
				
		if currentTab == "Images" then
			w.Specific = GetFrameTexture(settings[n])
		elseif currentTab == "Labels" then
			w.Specific = GetFrameLabel(settings[n], bar)
			w.AnP.cAnchorOrSize:Disable()
		end
		w.Specific:Parent(w)
		w.Specific:AnchorTo(w.Color, "bottomleft", "topleft", 0, 0)
		w.Specific:AddAnchor(w, "bottomright", "bottomright", -5, 0)

		-- Apply
		w.ab1 = w("Button", nil, Addon.ButtonInherits)
		w.ab1:Parent(w.Specific)
		w.ab1:Resize(Addon.ButtonWidth)
		w.ab1:AnchorTo(w, "bottomright", "bottomright", -17, -20)
		w.ab1:SetText(L"Apply")
		w.ab1.OnLButtonUp = 
			function()
				-- Visibility
				local dynvisi = WStringToString(w.Visibility.cDynVisi:Selected())
				if ("" == dynvisi) then dynvisi = "none" end
				

				
				--[[
				local  = WStringToString(w.k2:Selected())
				if ("" == color_group) then color_group = "none" end
				]]--
				
				-- Anchor And Position
				
				local parent = WStringToString(w.AnP.cParent:Selected())
				if ("" == parent) then parent = "Root" end
				
				local layer = WStringToString(w.AnP.cLayer:Selected())
				if ("" == layer) then layer = "overlay" end
				
				-- Size
				local width = WStringToString(w.AnP.Size.tWidth:GetText())
				width = tonumber(width)
				if (nil == width) then width = 0 end

				local height = WStringToString(w.AnP.Size.tHeight:GetText())
				height = tonumber(height)
				if (nil == height) then height = 0 end
				
				local scale = tonumber(w.AnP.Size.tScale:GetText())
				if scale == nil then scale = 1 end
				if scale > 2 then scale = 2 end
				--w.Size.bts:SetText(scale)
				--w.Size.s5:SetValue(scale)

				-- Anchor 1
				local anchor = WStringToString(w.AnP.Anchor1.cAnchorTo:Selected())
				if ("" == anchor) then anchor = "Root" end				
				local point = WStringToString(w.AnP.Anchor1.cMy_Anchor:Selected())
				if ("" == point) then point = "left" end
				local parentpoint = WStringToString(w.AnP.Anchor1.cTo_Anchor:Selected())
				if ("" == parentpoint) then parentpoint = "left" end				
				local x = tonumber(WStringToString(w.AnP.Anchor1.bt8:GetText()))
				if (nil == x) then x = 0 end
				local y = tonumber(WStringToString(w.AnP.Anchor1.bt9:GetText()))
				if (nil == y) then y = 0 end

				settings[n].anchors[1].parent = anchor
				settings[n].anchors[1].parentpoint = parentpoint
				settings[n].anchors[1].point = point
				settings[n].anchors[1].x = x
				settings[n].anchors[1].y = y
				
				if w.AnP.cAnchorOrSize:Selected() == L"Anchor 2" then
					local anchor2 = WStringToString(w.AnP.Anchor2.cAnchorTo:Selected())
					if ("" == anchor2) then anchor2 = "Root" end					
					local point2 = WStringToString(w.AnP.Anchor2.cMy_Anchor:Selected())
					if ("" == point2) then point2 = "left" end
					local parentpoint2 = WStringToString(w.AnP.Anchor2.cTo_Anchor:Selected())
					if ("" == parentpoint2) then parentpoint2 = "left" end
					local x2 = tonumber(WStringToString(w.AnP.Anchor2.bt8:GetText()))
					if (nil == x2) then x2 = 0 end
					local y2 = tonumber(WStringToString(w.AnP.Anchor2.bt9:GetText()))
					if (nil == y2) then y2 = 0 end

					settings[n].anchors[2] = {}
					settings[n].anchors[2].parent = anchor2
					settings[n].anchors[2].parentpoint = parentpoint2
					settings[n].anchors[2].point = point2
					settings[n].anchors[2].x = x2
					settings[n].anchors[2].y = y2
				else
					settings[n].anchors[2] = nil
				end
				
				-- Color
				if w.Color.cColorPresets ~= nil then
					if WStringToString(w.Color.cColorPresets:Selected()) ~= "none" then
						local ColorPreset = RVMOD_GColorPresets.GetColorPreset(WStringToString(w.Color.cColorPresets:Selected()))
						w.Color.colorBox:Tint(ColorPreset.r, ColorPreset.g, ColorPreset.b)
					else
						w.Color.colorBox:Tint(color_r, color_g, color_b)
					end
					settings[n].colorsettings.ColorPreset = WStringToString(w.Color.cColorPresets:Selected())
				end
				
				local colorGroup = WStringToString(w.Color.cColorGroup:Selected())
				if ("" == colorGroup) then colorGroup = "none" end
				settings[n].colorsettings.color_group = colorGroup
				
				local color_alter_r = WStringToString(w.Color.cAlterRed:Selected())
				if ("" == color_alter_r) then color_alter_r = "no" end
				settings[n].colorsettings.alter.r = color_alter_r
				
				local color_alter_g = WStringToString(w.Color.cAlterGreen:Selected())
				if ("" == color_alter_g) then color_alter_g = "no" end
				settings[n].colorsettings.alter.g = color_alter_g
				
				local color_alter_b = WStringToString(w.Color.cAlterBlue:Selected())
				if ("" == color_alter_b) then color_alter_b = "no" end
				settings[n].colorsettings.alter.b = color_alter_b
				
				settings[n].colorsettings.allow_overrides = w.Color.cOverride:GetValue()

				settings[n].colorsettings.color.r, settings[n].colorsettings.color.g, settings[n].colorsettings.color.b = WindowGetTintColor(w.Color.colorBox.name)
				-- /Color
				
				settings[n].visibility_group = dynvisi
				
				-- Alpha
				local alpha = WStringToString(w.Alpha.tAlpha:GetText())
				alpha = tonumber(alpha)
				if (nil == alpha) then alpha = 1 end
				settings[n].alpha = alpha
				
				local dynAlpha = WStringToString(w.Alpha.cDynAlpha:Selected())
				if ("" == dynAlpha) then dynAlpha = "none" end
				settings[n].alpha_group = dynAlpha
				-- /Alpha
				
				settings[n].parent = parent
				settings[n].layer = layer

				settings[n].width = width
				settings[n].height = height
				settings[n].scale = scale
				
				if currentTab == "Images" then
					-- Texture
					local textureName = WStringToString(w.Specific.cTexture:Selected())
					if ("" == textureName) then textureName = "tint_square" end
					settings[n].texture.name = textureName

					-- Size
					local textureWidth = WStringToString(w.Specific.Size.tWidth:GetText())
					textureWidth = tonumber(textureWidth)
					if (nil == textureWidth) then textureWidth = 0 end
					settings[n].texture.width = textureWidth
					
					local textureHeight = WStringToString(w.Specific.Size.tHeight:GetText())
					textureHeight = tonumber(textureHeight)
					if (nil == textureHeight) then textureHeight = 0 end
					settings[n].texture.height = textureHeight
					
					local textureScale = tonumber(w.Specific.Size.tScale:GetText())
					if textureScale == nil then textureScale = 1 end
					if textureScale > 2 then textureScale = 2 end
					settings[n].texture.scale = textureScale
					
					--settings[n].texture.flipped = w.Specific.ckFlipped:GetValue()
					
					local dynname = WStringToString(w.Specific.cTextureDyn:Selected())
					if ("" == dynname) then dynname = "none" end
					settings[n].texture.texture_group = dynname	

					--settings[n].texture.style = WStringToString(w.Specific.cStyle:Selected())
				
				elseif currentTab == "Labels" then
					-- Label specific Settings
					
					settings[n].formattemplate = WStringToString(w.Specific.tFormat:GetText()) or ""
					d(settings.formattemplate)
					
					local font = WStringToString(w.Specific.cFont:Selected())
					if ("" == font) then font = Addon.FontText end
					
					local clip_after = WStringToString(w.Specific.bNumChars:GetText())
					clip_after = tonumber(clip_after)
					if (nil == clip_after) then clip_after = 14 end
					
					local align = WStringToString(w.Specific.cAlign:Selected())
					if ("" == align) then align = "left" end
					
					local case = WStringToString(w.Specific.cCase:Selected())
					if ("" == case) then case = "none" end
					
					--[[
					if (w.cTemplate:Selected() and w.cTemplate:Selected() ~= L"") then
						d("template")
						d(bar.labels[n].formattemplate)
						bar.labels[n].formattemplate = WStringToString(w.cTemplate:Selected())
						w.tFormat:SetText(bar.labels[n].formattemplate)
						w.cTemplate:Select()
					end
					]]--
								
					settings[n].font.name = font
					settings[n].font.align = align
					settings[n].font.case = case
					settings[n].clip_after = clip_after
					
					
				end
				
				bar:setup()
				bar:render()
			end
		Addon.CreateEditBarSettingsChildEnd(w)
	end
end

--
--	Bar Settings Panel ---------------------------------------------------
--

Addon.BarSettings = {}
function Addon.BarSettings.Create()
	if not DoesWindowExist(SettingsWindow.."Bar") then
		CreateWindowFromTemplate(SettingsWindow.."Bar", Addon.Name.."BarTemplateBar", SettingsWindow)
	end
	-- Third step: set tab buttons
	ButtonSetText(SettingsWindow.."BarTabFill", L"Fill")
	ButtonSetText(SettingsWindow.."BarTabBorder", L"Border")
	ButtonSetText(SettingsWindow.."BarTabBackground", L"Background")
	
	ButtonSetPressedFlag(SettingsWindow.."BarTabFill", true)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBorder", false)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBackground", false)
	
	-- Final step: show everything
	WindowSetShowing(SettingsWindow.."Bar", true)
end

-- Bar Fill
Addon.FillBarSettings = {}
function Addon.FillBarSettings.Create()
	local w, bar = Addon.CreateEditBarSettingsStart()
	w:AnchorTo(SettingsWindow.."Bar", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."Bar")
	
	w.lDirection = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lDirection:Resize(95)
	w.lDirection:Position(25,20)
	w.lDirection:Font(Addon.FontBold)
	w.lDirection:SetText(L"Direction:")
	w.lDirection:Align("left")
	w.lDirection.OnMouseOver = 
		function()
			Addon.SetToolTip(w.lDirection, "In which direction should this bar grow?")
		end

	w.cGrow = w("tinycombobox")
	w.cGrow:AnchorTo(w.lDirection, "right", "left", 20, 0)
	w.cGrow:Add("left")
	w.cGrow:Add("right")
	w.cGrow:Add("up")
	w.cGrow:Add("down") 
	w.cGrow:Select(bar.grow)
	
	w.lInvValue = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lInvValue:Resize(185)
	w.lInvValue:AnchorTo(w.lDirection, "bottomleft", "topleft", 0, 15)
	w.lInvValue:Font(Addon.FontText)
	w.lInvValue:SetText(L"Inverse Bar Value:")
	w.lInvValue:Align("left")
	w.lInvValue.OnMouseOver = 
		function()
			Addon.SetToolTip(w.lDirection, "Inverse the Bar Value")
		end
		
	w.cInvValue = w("Checkbox")
	w.cInvValue:AnchorTo(w.lInvValue, "right", "left", 5, 0)
	w.cInvValue.OnLButtonUp =
		function()
			bar.invValue = w.cInvValue:GetValue()
			bar:setup()
			bar:render()
		end
	if (bar.invValue and true == bar.invValue) then w.cInvValue:Check() end
	
	w.lSize = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lSize:Resize(60)
	--w.lSize:AnchorTo(w.lInvValue, "bottomleft", "topleft", 0, 15)
	w.lSize:Position(25, 100)
	w.lSize:Font(Addon.FontBold)
	w.lSize:SetText(L"Size:")
	w.lSize:Align("left")
	w.lSize.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSize, "How big should the fill be? This settings influcences border size and vice versa.")
		end
		
	w.lSizeW = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lSizeW:Resize(60)
	w.lSizeW:AnchorTo(w.lSize, "right", "left", 5, 0)
	w.lSizeW:Font(Addon.FontText)
	w.lSizeW:SetText(L"Width:")
	w.lSizeW:Align("left")
	w.lSizeW.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSizeW, "The width of the bar.")
		end

	w.tSizeW =	w("Textbox")
	w.tSizeW:Resize(60)
	w.tSizeW:AnchorTo(w.lSizeW, "right", "left", 5, 0)
	w.tSizeW:SetText(bar.width - bar.border.padding.left - bar.border.padding.right)

	w.lSizeH = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lSizeH:Resize(70)
	w.lSizeH:AnchorTo(w.tSizeW, "right", "left", 5, 0)
	w.lSizeH:Font(Addon.FontText)
	w.lSizeH:SetText(L"Height:")
	w.lSizeH:Align("left")
	w.lSizeH.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSizeH, "The height of the bar.")
		end

	w.tSizeH =	w("Textbox")
	w.tSizeH:Resize(60)
	w.tSizeH:AnchorTo(w.lSizeH, "right", "left", 5, 0)
	w.tSizeH:SetText(bar.height - bar.border.padding.top - bar.border.padding.bottom)

	w.Color = GetFrameColor(bar.fg.colorsettings)
	w.Color:Parent(w)
	w.Color:AnchorTo(w, "topright", "topright", -5, 0)
	w.Color:AddAnchor(w, "center", "bottomleft", 0, -40)
	
	w.Specific = GetFrameTexture(bar.fg)
	w.Specific:Parent(w)
	w.Specific:AnchorTo(w, "bottom", "bottomleft", 0, 0)
	w.Specific:AddAnchor(w.Color, "bottomright", "topright", 0, 0)
	
	-- Only Fill has a Texture style
	w.Specific.lStyle = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.Specific.lStyle:Resize(55)
	w.Specific.lStyle:AnchorTo(w.Specific.cTextureDyn, "bottomleft", "topleft", 0, 10)
	w.Specific.lStyle:Font(Addon.FontText)
	w.Specific.lStyle:SetText(L"Style:")
	w.Specific.lStyle:Align("left")

	w.Specific.cStyle = w("tinycombobox")
	w.Specific.cStyle:AnchorTo(w.Specific.lStyle, "right", "left", 5, 0)
	w.Specific.cStyle:Clear()
	w.Specific.cStyle:Add("cut")
	w.Specific.cStyle:Add("grow")
		
	w.Specific.cStyle:Select(bar.fg.texture.style or "cut")
	
	-- Alpha
	w.lAlpha = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlpha:Resize(95)	
	w.lAlpha:Font(Addon.FontBold)
	w.lAlpha:SetText(L"Alpha:")
	w.lAlpha:Align("left")
	w.lAlpha:AnchorTo(w, "left", "topleft", 25, 20)

	w.lalpha1 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lalpha1:Resize(80)
	w.lalpha1:AnchorTo(w.lAlpha, "bottomleft", "topleft", 5, 15)
	w.lalpha1:Font(Addon.FontText)
	w.lalpha1:SetText(L"Combat:")
	w.lalpha1:Align("left")
	w.lalpha1.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lalpha1, "In-Combat Alpha") 
		end

	w.btac = w("Textbox")
	w.btac:Resize(60)
	w.btac:AnchorTo(w.lalpha1, "right", "left", 5, 0)
	w.btac:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", bar.fg.alpha.in_combat)) )


	w.lAlphaOOC = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaOOC:Resize(45)
	w.lAlphaOOC:AnchorTo(w.btac, "right", "left", 5, 0)
	w.lAlphaOOC:Font(Addon.FontText)
	w.lAlphaOOC:SetText(L"OoC:")
	w.lAlphaOOC:Align("left")
	w.lAlphaOOC.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlphaOOC, "Out Of Combat Alpha") 
		end


	w.btaooc = w("Textbox")
	w.btaooc:Resize(60)
	w.btaooc:AnchorTo(w.lAlphaOOC, "right", "left", 5, 0)
	w.btaooc:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", bar.fg.alpha.out_of_combat)) )
	
	
	w.lAlterAlpha = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlterAlpha:Resize(80)
	w.lAlterAlpha:AnchorTo(w.lalpha1, "bottomleft", "topleft", 0, 20)
	w.lAlterAlpha:Font(Addon.FontText)
	w.lAlterAlpha:SetText(L"Alter:")
	w.lAlterAlpha:Align("left")
	w.lAlterAlpha.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlterAlpha, "Changes the Alpha based on the value of the bar", 
				"inv: Inverse of the bars value (lower value more visible)",
				"perc: Percent of the bar (higher value more visible)",
				"no: Don't change Alpha based on bar's value") 
		end

	w.cAlterAlpha = w("Tinycombobox")
	w.cAlterAlpha:AnchorTo(w.lAlterAlpha, "right", "left", 5, 0)
	FillAlterDropdown(w.cAlterAlpha)
	w.cAlterAlpha:Select(bar.fg.alpha.alter)
	

	w.lAlphaClamp = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaClamp:Resize(65)
	w.lAlphaClamp:AnchorTo(w.cAlterAlpha, "right", "left", 5, 0)
	w.lAlphaClamp:Font(Addon.FontText)
	w.lAlphaClamp:SetText(L"Clamp:")
	w.lAlphaClamp:Align("left")
	w.lAlphaClamp.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlphaClamp, "Don't Allow the Alpha Alter to make the bar any more see-through than this", 
				"Example: At full health, with 'Inv' on, the HP bar would have 0 alpha (inverse of 100 is 0)")
		end

	w.btaclamp = w("Textbox")
	w.btaclamp:Resize(80)
	w.btaclamp:AnchorTo(w.lAlphaClamp, "right", "left", 5, 0)
	w.btaclamp:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", bar.fg.alpha.clamp)) )


	w.apply = w("Button", nil, Addon.ButtonInherits)
	w.apply:Parent(w.Specific)
	w.apply:Resize(Addon.ButtonWidth)
	w.apply:AnchorTo(w, "bottomright", "bottomright", -17, -20)
	w.apply:SetText(L"Apply")
	w.apply.OnLButtonUp = 
		function()
			-- state

			local alphacombat = tonumber(w.btac:GetText())
			if alphacombat == nil then alphacombat = 1 end
			if alphacombat > 1 then alphacombat = 1 end
			w.btac:SetText(alphacombat)
			
			local alphaocombat = tonumber(w.btaooc:GetText())
			if alphaocombat == nil then alphaocombat = 1 end
			if alphaocombat > 1 then alphaocombat = 1 end
			w.btaooc:SetText(alphaocombat)
			
			local alphaclamp = tonumber(w.btaclamp:GetText())
			if alphaclamp == nil then alphaclamp = 1 end
			if alphaclamp > 1 then alphaclamp = 1 end
			w.btaclamp:SetText(alphaclamp)
		
			bar.grow = WStringToString(w.cGrow:Selected())
			
			local x = WStringToString(w.tSizeW:GetText())
			x = tonumber(x)
			if (nil == x) then x = 0 end
	
			local y = WStringToString(w.tSizeH:GetText())
			y = tonumber(y)
			if (nil == y) then y = 0 end
	
			
			-- Alpha
			bar.fg.alpha.in_combat = alphacombat
			bar.fg.alpha.out_of_combat = alphaocombat		
			bar.fg.alpha.clamp = alphaclamp
			bar.fg.alpha.alter = WStringToString(w.cAlterAlpha:Selected())
			
			-- Color
			if w.Color.cColorPresets ~= nil then
				if WStringToString(w.Color.cColorPresets:Selected()) ~= "none" then
					local ColorPreset = RVMOD_GColorPresets.GetColorPreset(WStringToString(w.Color.cColorPresets:Selected()))
					w.Color.colorBox:Tint(ColorPreset.r, ColorPreset.g, ColorPreset.b)
				else
					w.Color.colorBox:Tint(color_r, color_g, color_b)
				end
				bar.fg.colorsettings.ColorPreset = WStringToString(w.Color.cColorPresets:Selected())
			end
			
			local colorGroup = WStringToString(w.Color.cColorGroup:Selected())
			if ("" == colorGroup) then colorGroup = "none" end
			bar.fg.colorsettings.color_group = colorGroup
			
			local color_alter_r = WStringToString(w.Color.cAlterRed:Selected())
			if ("" == color_alter_r) then color_alter_r = "no" end
			bar.fg.colorsettings.alter.r = color_alter_r
			
			local color_alter_g = WStringToString(w.Color.cAlterGreen:Selected())
			if ("" == color_alter_g) then color_alter_g = "no" end
			bar.fg.colorsettings.alter.g = color_alter_g
			
			local color_alter_b = WStringToString(w.Color.cAlterBlue:Selected())
			if ("" == color_alter_b) then color_alter_b = "no" end
			bar.fg.colorsettings.alter.b = color_alter_b
			
			bar.fg.colorsettings.allow_overrides = w.Color.cOverride:GetValue()			
			bar.fg.colorsettings.color.r, bar.fg.colorsettings.color.g, bar.fg.colorsettings.color.b = WindowGetTintColor(w.Color.colorBox.name)
			-- /Color
			
			-- Texture
			local textureName = WStringToString(w.Specific.cTexture:Selected())
			if ("" == textureName) then textureName = "tint_square" end
			bar.fg.texture.name = textureName

			local textureWidth = WStringToString(w.Specific.Size.tWidth:GetText())
			textureWidth = tonumber(textureWidth)
			if (nil == textureWidth) then textureWidth = 0 end
			bar.fg.texture.width = textureWidth
			
			local textureHeight = WStringToString(w.Specific.Size.tHeight:GetText())
			textureHeight = tonumber(textureHeight)
			if (nil == textureHeight) then textureHeight = 0 end
			bar.fg.texture.height = textureHeight
			
			local textureScale = tonumber(w.Specific.Size.tScale:GetText())
			if textureScale == nil then textureScale = 1 end
			if textureScale > 2 then textureScale = 2 end
			bar.fg.texture.scale = textureScale
			
			--bar.fg.texture.flipped = w.Specific.ckFlipped:GetValue()
			
			local dynname = WStringToString(w.Specific.cTextureDyn:Selected())
			if ("" == dynname) then dynname = "none" end
			bar.fg.texture.texture_group = dynname	

			bar.fg.texture.style = WStringToString(w.Specific.cStyle:Selected())
			-- /Texture
			
			bar.width = x + bar.border.padding.left + bar.border.padding.right
			bar.height = y + bar.border.padding.top + bar.border.padding.bottom		

			bar:setup()
			bar:render()			
		end
	w.apply.OnMouseOver = function() Addon.SetToolTip(w.apply, "Save change to bar") end


	Addon.CreateEditBarSettingsEnd(w)
	
end

-- Bar Border
Addon.BorderBarSettings = {}
function Addon.BorderBarSettings.Create()
	local w, bar = Addon.CreateEditBarSettingsStart()

	w:AnchorTo(SettingsWindow.."Bar", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."Bar")
	
	w.lSize = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lSize:Resize(65)
	w.lSize:Position(25, 100)
	w.lSize:Font(Addon.FontBold)
	w.lSize:SetText(L"Size:")
	w.lSize:Align("left")
	w.lSize.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSize, "How big should the border be?")
		end
		
	w.lSizeW = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lSizeW:Resize(60)
	w.lSizeW:AnchorTo(w.lSize, "right", "left", 5, 0)
	w.lSizeW:Font(Addon.FontText)
	w.lSizeW:SetText(L"Width:")
	w.lSizeW:Align("left")
	w.lSizeW.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSizeW, "The width of the border.")
		end

	w.tSizeW =	w("Textbox")
	w.tSizeW:Resize(60)
	w.tSizeW:AnchorTo(w.lSizeW, "right", "left", 5, 0)
	w.tSizeW:SetText(bar.width)

	w.lSizeH = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lSizeH:Resize(70)
	w.lSizeH:AnchorTo(w.tSizeW, "right", "left", 5, 0)
	w.lSizeH:Font(Addon.FontText)
	w.lSizeH:SetText(L"Height:")
	w.lSizeH:Align("left")
	w.lSizeH.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lSizeH, "The height of the border.")
		end

	w.tSizeH =	w("Textbox")
	w.tSizeH:Resize(60)
	w.tSizeH:AnchorTo(w.lSizeH, "right", "left", 5, 0)
	w.tSizeH:SetText(bar.height)
	
	-- Padding
	w.lPadding = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lPadding:Resize(95)
	w.lPadding:AnchorTo(w.lSize, "bottomleft", "topleft", 0, 15)
	w.lPadding:Font(Addon.FontBold)
	w.lPadding:SetText(L"Padding:")
	w.lPadding:Align("left")
	w.lPadding.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lPadding, "How much should be bar be padded")
		end

	w.tPadTop =	w("Textbox")
	w.tPadTop:Resize(60)
	w.tPadTop:AnchorTo(w.lPadding, "bottomright", "topleft", 0, 0)
	w.tPadTop:SetText(bar.border.padding.top)

	w.tPadBottom =	w("Textbox")
	w.tPadBottom:Resize(60)
	w.tPadBottom:AnchorTo(w.tPadTop, "bottom", "top", 0, 0)
	w.tPadBottom:SetText(bar.border.padding.bottom)

	w.tPadLeft =	w("Textbox")
	w.tPadLeft:Resize(60)
	w.tPadLeft:AnchorTo(w.tPadTop, "bottomleft", "right", 0, 0)
	w.tPadLeft:SetText(bar.border.padding.left)

	w.tPadRight =	w("Textbox")
	w.tPadRight:Resize(60)
	w.tPadRight:AnchorTo(w.tPadTop, "bottomright", "left", 0, 0)
	w.tPadRight:SetText(bar.border.padding.right)
	
	w.Color = GetFrameColor(bar.border.colorsettings)
	w.Color:Parent(w)
	w.Color:AnchorTo(w, "topright", "topright", -5, 0)
	w.Color:AddAnchor(w, "center", "bottomleft", 0, -40)
	
	w.Specific = GetFrameTexture(bar.border)
	w.Specific:Parent(w)
	w.Specific:AnchorTo(w, "bottom", "bottomleft", 0, 0)
	w.Specific:AddAnchor(w.Color, "bottomright", "topright", 0, 0)
	
	
	w.lAlpha = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlpha:Resize(95)	
	w.lAlpha:Font(Addon.FontBold)
	w.lAlpha:SetText(L"Alpha:")
	w.lAlpha:Align("left")
	w.lAlpha:AnchorTo(w, "left", "topleft", 25, 20)

	w.lAlphaSet = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaSet:Resize(80)
	w.lAlphaSet:AnchorTo(w.lAlpha, "bottomleft", "topleft", 5, 15)
	w.lAlphaSet:Font(Addon.FontText)
	w.lAlphaSet:SetText(L"Alpha:")
	w.lAlphaSet:Align("left")

	w.bta = w("Textbox")
	w.bta:Resize(60)
	w.bta:AnchorTo(w.lAlphaSet, "right", "left", 5, 0)
	w.bta:SetText(tonumber(string.format("%." .. (3 ) .. "f", bar.border.alpha)))

	w.lAlphaFollow = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaFollow:Resize(245)
	w.lAlphaFollow:AnchorTo(w.lAlphaSet, "bottomleft", "topleft", 0, 15)
	w.lAlphaFollow:Font(Addon.FontText)
	w.lAlphaFollow:SetText(L"Follow Background Alpha:")
	w.lAlphaFollow:Align("left")
	w.lAlphaFollow.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlphaFollow, "Border Alpha should follow Background Alpha?",
				"This must be disabled for the Alpha slider to work")
		end

	w.kAlphaFollow = w("Checkbox")
	w.kAlphaFollow:AnchorTo(w.lAlphaFollow, "right", "left", 5, 0)
	w.kAlphaFollow.OnLButtonUp =
		function()
			bar.border.follow_bg_alpha = w.kAlphaFollow:GetValue()
			bar:setup()
			bar:render()
		end
	if (bar.border.follow_bg_alpha and true == bar.border.follow_bg_alpha) then w.kAlphaFollow:Check() end
	
	w.ab1 = w("Button", nil, Addon.ButtonInherits)
	w.ab1:Parent(w.Specific)
	w.ab1:Resize(Addon.ButtonWidth)
	w.ab1:AnchorTo(w, "bottomright", "bottomright", -17, -20)
	w.ab1:SetText(L"Apply")

	w.ab1.OnLButtonUp = 
		function()
			local top = WStringToString(w.tPadTop:GetText())
			top = tonumber(top)
			if (nil == top) then top = 0 end

			local left = WStringToString(w.tPadLeft:GetText())
			left = tonumber(left)
			if (nil == left) then left = 0 end

			local right = WStringToString(w.tPadRight:GetText())
			right = tonumber(right)
			if (nil == right) then right = 0 end

			local bottom = WStringToString(w.tPadBottom:GetText())
			bottom = tonumber(bottom)
			if (nil == bottom) then bottom = 0 end

			local width = WStringToString(w.tSizeW:GetText())
			width = tonumber(width)
			if (nil == width) then width = 200 end
			
			local height = WStringToString(w.tSizeH:GetText())
			height = tonumber(height)
			if (nil == height) then height = 20 end
			
			local alpha = WStringToString(w.bta:GetText())
			alpha = tonumber(alpha)
			if (nil == alpha) then alpha = 1 end
			if (alpha >= 1) then alpha = 1 end
			w.bta:SetText(alpha)
			
			bar.border.alpha = alpha

			bar.width = width
			bar.height = height

			bar.border.padding.top = top
			bar.border.padding.bottom = bottom
			bar.border.padding.left = left
			bar.border.padding.right = right
			
			-- Color
			if w.Color.cColorPresets ~= nil then
				if WStringToString(w.Color.cColorPresets:Selected()) ~= "none" then
					local ColorPreset = RVMOD_GColorPresets.GetColorPreset(WStringToString(w.Color.cColorPresets:Selected()))
					w.Color.colorBox:Tint(ColorPreset.r, ColorPreset.g, ColorPreset.b)
				else
					w.Color.colorBox:Tint(color_r, color_g, color_b)
				end
				bar.border.colorsettings.ColorPreset = WStringToString(w.Color.cColorPresets:Selected())
			end
			
			local colorGroup = WStringToString(w.Color.cColorGroup:Selected())
			if ("" == colorGroup) then colorGroup = "none" end
			bar.border.colorsettings.color_group = colorGroup
			
			local color_alter_r = WStringToString(w.Color.cAlterRed:Selected())
			if ("" == color_alter_r) then color_alter_r = "no" end
			bar.border.colorsettings.alter.r = color_alter_r
			
			local color_alter_g = WStringToString(w.Color.cAlterGreen:Selected())
			if ("" == color_alter_g) then color_alter_g = "no" end
			bar.border.colorsettings.alter.g = color_alter_g
			
			local color_alter_b = WStringToString(w.Color.cAlterBlue:Selected())
			if ("" == color_alter_b) then color_alter_b = "no" end
			bar.border.colorsettings.alter.b = color_alter_b
			
			bar.border.colorsettings.allow_overrides = w.Color.cOverride:GetValue()			
			bar.border.colorsettings.color.r, bar.border.colorsettings.color.g, bar.border.colorsettings.color.b = WindowGetTintColor(w.Color.colorBox.name)
			-- /Color
			
			-- Texture
			local textureName = WStringToString(w.Specific.cTexture:Selected())
			if ("" == textureName) then textureName = "tint_square" end
			bar.border.texture.name = textureName

			local textureWidth = WStringToString(w.Specific.Size.tWidth:GetText())
			textureWidth = tonumber(textureWidth)
			if (nil == textureWidth) then textureWidth = 0 end
			bar.border.texture.width = textureWidth
			
			local textureHeight = WStringToString(w.Specific.Size.tHeight:GetText())
			textureHeight = tonumber(textureHeight)
			if (nil == textureHeight) then textureHeight = 0 end
			bar.border.texture.height = textureHeight
			
			local textureScale = tonumber(w.Specific.Size.tScale:GetText())
			if textureScale == nil then textureScale = 1 end
			if textureScale > 2 then textureScale = 2 end
			bar.border.texture.scale = textureScale
			
			--bar.border.texture.flipped = w.Specific.ckFlipped:GetValue()
			
			local dynname = WStringToString(w.Specific.cTextureDyn:Selected())
			if ("" == dynname) then dynname = "none" end
			bar.border.texture.texture_group = dynname	

			--bar.border.texture.style = WStringToString(w.Specific.cStyle:Selected())
			-- /Texture
			
			bar:setup()
			bar:render()
		end



	Addon.CreateEditBarSettingsEnd(w)
end

-- Bar Background
Addon.FillBGBarSettings = {}
function Addon.FillBGBarSettings.Create()
	local w, bar = Addon.CreateEditBarSettingsStart()
	
	w:AnchorTo(SettingsWindow.."Bar", "top", "top", 0, 35)
	w:Parent(SettingsWindow.."Bar")

	w.Color = GetFrameColor(bar.bg.colorsettings)
	w.Color:Parent(w)
	w.Color:AnchorTo(w, "topright", "topright", -5, 0)
	w.Color:AddAnchor(w, "center", "bottomleft", 0, -40)

	w.Specific = GetFrameTexture(bar.bg)
	w.Specific:Parent(w)
	w.Specific:AnchorTo(w, "bottom", "bottomleft", 0, 0)
	w.Specific:AddAnchor(w.Color, "bottomright", "topright", 0, 0)
	
	w.lAlpha = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlpha:Resize(95)	
	w.lAlpha:Font(Addon.FontBold)
	w.lAlpha:SetText(L"Alpha:")
	w.lAlpha:Align("left")
	w.lAlpha:AnchorTo(w, "left", "topleft", 25, 20)

	w.lalpha1 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lalpha1:Resize(80)
	w.lalpha1:AnchorTo(w.lAlpha, "bottomleft", "topleft", 5, 15)
	w.lalpha1:Font(Addon.FontText)
	w.lalpha1:SetText(L"Combat:")
	w.lalpha1:Align("left")
	w.lalpha1.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lalpha1, "In-Combat Alpha") 
		end

	w.btac = w("Textbox")
	w.btac:Resize(60)
	w.btac:AnchorTo(w.lalpha1, "right", "left", 5, 0)
	w.btac:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", bar.bg.alpha.in_combat)) )

	w.lAlphaOOC = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	--w.lAlphaOOC:Resize(80)
	w.lAlphaOOC:AnchorTo(w.btac, "right", "left", 5, 0)
	w.lAlphaOOC:Font(Addon.FontText)
	w.lAlphaOOC:SetText(L"OoC:")
	w.lAlphaOOC:Align("left")
	w.lAlphaOOC.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lAlphaOOC, "Out Of Combat Alpha") 
		end

	w.btaooc = w("Textbox")
	w.btaooc:Resize(60)
	w.btaooc:AnchorTo(w.lAlphaOOC, "right", "left", 5, 0)
	w.btaooc:SetText(tonumber(string.format("%." .. (3 or 0) .. "f", bar.bg.alpha.out_of_combat)) )



	w.apply = w("Button", nil, Addon.ButtonInherits)
	w.apply:Parent(w.Specific)
	w.apply:Resize(Addon.ButtonWidth)
	w.apply:AnchorTo(w, "bottomright", "bottomright", -17, -20)
	w.apply:SetText(L"Apply")
	w.apply.OnLButtonUp = 
		function()
			-- state
		
			local alphacombat = tonumber(w.btac:GetText())
			if alphacombat == nil then alphacombat = 1 end
			if alphacombat > 1 then alphacombat = 1 end
			w.btac:SetText(alphacombat)

			
			local alphaocombat = tonumber(w.btaooc:GetText())
			if alphaocombat == nil then alphaocombat = 1 end
			if alphaocombat > 1 then alphaocombat = 1 end
			w.btaooc:SetText(alphaocombat)

			bar.bg.alpha.in_combat = alphacombat
			bar.bg.alpha.out_of_combat = alphaocombat

			-- Color
			if w.Color.cColorPresets ~= nil then
				if WStringToString(w.Color.cColorPresets:Selected()) ~= "none" then
					local ColorPreset = RVMOD_GColorPresets.GetColorPreset(WStringToString(w.Color.cColorPresets:Selected()))
					w.Color.colorBox:Tint(ColorPreset.r, ColorPreset.g, ColorPreset.b)
				else
					w.Color.colorBox:Tint(color_r, color_g, color_b)
				end
				bar.bg.colorsettings.ColorPreset = WStringToString(w.Color.cColorPresets:Selected())
			end
			
			local colorGroup = WStringToString(w.Color.cColorGroup:Selected())
			if ("" == colorGroup) then colorGroup = "none" end
			bar.bg.colorsettings.color_group = colorGroup
			
			local color_alter_r = WStringToString(w.Color.cAlterRed:Selected())
			if ("" == color_alter_r) then color_alter_r = "no" end
			bar.bg.colorsettings.alter.r = color_alter_r
			
			local color_alter_g = WStringToString(w.Color.cAlterGreen:Selected())
			if ("" == color_alter_g) then color_alter_g = "no" end
			bar.bg.colorsettings.alter.g = color_alter_g
			
			local color_alter_b = WStringToString(w.Color.cAlterBlue:Selected())
			if ("" == color_alter_b) then color_alter_b = "no" end
			bar.bg.colorsettings.alter.b = color_alter_b
			
			bar.bg.colorsettings.allow_overrides = w.Color.cOverride:GetValue()			
			bar.bg.colorsettings.color.r, bar.bg.colorsettings.color.g, bar.bg.colorsettings.color.b = WindowGetTintColor(w.Color.colorBox.name)
			-- /Color
			
			-- Texture
			local textureName = WStringToString(w.Specific.cTexture:Selected())
			if ("" == textureName) then textureName = "tint_square" end
			bar.bg.texture.name = textureName

			local textureWidth = WStringToString(w.Specific.Size.tWidth:GetText())
			textureWidth = tonumber(textureWidth)
			if (nil == textureWidth) then textureWidth = 0 end
			bar.bg.texture.width = textureWidth
			
			local textureHeight = WStringToString(w.Specific.Size.tHeight:GetText())
			textureHeight = tonumber(textureHeight)
			if (nil == textureHeight) then textureHeight = 0 end
			bar.bg.texture.height = textureHeight
			
			local textureScale = tonumber(w.Specific.Size.tScale:GetText())
			if textureScale == nil then textureScale = 1 end
			if textureScale > 2 then textureScale = 2 end
			bar.bg.texture.scale = textureScale
			
			--bar.bg.texture.flipped = w.Specific.ckFlipped:GetValue()
			
			local dynname = WStringToString(w.Specific.cTextureDyn:Selected())
			if ("" == dynname) then dynname = "none" end
			bar.bg.texture.texture_group = dynname	

			--bar.bg.texture.style = WStringToString(w.Specific.cStyle:Selected())
			-- /Texture
			
			bar:setup()
			bar:render()			
		end
	w.apply.OnMouseOver = function() Addon.SetToolTip(w.apply, "Save change to bar") end


	Addon.CreateEditBarSettingsEnd(w)
	
end

--------------------------------------------------------------
-- Description:
-- 				OnClick Handlers
--------------------------------------------------------------
--only MainTabs atm
function Addon.GetCurrentTab()
	if true == ButtonGetPressedFlag(SettingsWindow.."TabGeneral") then
		return "General"
	elseif true == ButtonGetPressedFlag(SettingsWindow.."TabBar") then
		return "Bar"
	elseif true == ButtonGetPressedFlag(SettingsWindow.."TabIcons") then
		return "Icons"
	elseif true == ButtonGetPressedFlag(SettingsWindow.."TabImages") then
		return "Images"
	elseif true == ButtonGetPressedFlag(SettingsWindow.."TabLabels") then
		return "Labels"
	end
	return ""
end


function Addon.EditBarPanel.OnClickCloseSettings()
	Addon.EditBarPanel.HideModuleSettings()
	if DoesWindowExist(Addon.Name.."SettingsWindow") then Addon.UpdateSettingsWindow() end
end

-- Main Tabs	
function Addon.EditBarPanel.OnClickTabGeneral()
	ButtonSetPressedFlag(SettingsWindow.."TabGeneral", true)
	ButtonSetPressedFlag(SettingsWindow.."TabBar", false)
	ButtonSetPressedFlag(SettingsWindow.."TabIcons", false)
	ButtonSetPressedFlag(SettingsWindow.."TabLabels", false)
	ButtonSetPressedFlag(SettingsWindow.."TabImages", false)
	if DoesWindowExist(SettingsWindow.."Bar") then WindowSetShowing(SettingsWindow.."Bar", false) end
	if DoesWindowExist(SettingsWindow.."Icons") then WindowSetShowing(SettingsWindow.."Icons", false) end
	if DoesWindowExist(SettingsWindow.."Labels") then WindowSetShowing(SettingsWindow.."Labels", false) end
	if DoesWindowExist(SettingsWindow.."Images") then WindowSetShowing(SettingsWindow.."Images", false) end
	Addon.GeneralBarSettings.Create()
	Addon.EditBarPanel.OnClickTabBehaviour()
end

function Addon.EditBarPanel.OnClickTabBar()
	ButtonSetPressedFlag(SettingsWindow.."TabGeneral", false)
	ButtonSetPressedFlag(SettingsWindow.."TabBar", true)
	ButtonSetPressedFlag(SettingsWindow.."TabIcons", false)
	ButtonSetPressedFlag(SettingsWindow.."TabLabels", false)
	ButtonSetPressedFlag(SettingsWindow.."TabImages", false)
	if DoesWindowExist(SettingsWindow.."General") then WindowSetShowing(SettingsWindow.."General", false) end
	if DoesWindowExist(SettingsWindow.."Icons") then WindowSetShowing(SettingsWindow.."Icons", false) end
	if DoesWindowExist(SettingsWindow.."Labels") then WindowSetShowing(SettingsWindow.."Labels", false) end
	if DoesWindowExist(SettingsWindow.."Images") then WindowSetShowing(SettingsWindow.."Images", false) end
	Addon.BarSettings.Create()
	Addon.EditBarPanel.OnClickTabBarFill()
end

function Addon.EditBarPanel.OnClickTabIcons()
	ButtonSetPressedFlag(SettingsWindow.."TabGeneral", false)
	ButtonSetPressedFlag(SettingsWindow.."TabBar", false)
	ButtonSetPressedFlag(SettingsWindow.."TabIcons", true)
	ButtonSetPressedFlag(SettingsWindow.."TabLabels", false)
	ButtonSetPressedFlag(SettingsWindow.."TabImages", false)
	if DoesWindowExist(SettingsWindow.."General") then WindowSetShowing(SettingsWindow.."General", false) end
	if DoesWindowExist(SettingsWindow.."Bar") then WindowSetShowing(SettingsWindow.."Bar", false) end
	if DoesWindowExist(SettingsWindow.."Labels") then WindowSetShowing(SettingsWindow.."Labels", false) end
	if DoesWindowExist(SettingsWindow.."Images") then WindowSetShowing(SettingsWindow.."Images", false) end
	Addon.IconBarSettings.Create()
	Addon.EditBarPanel.OnClickTabIconCareer()
end

function Addon.EditBarPanel.OnClickTabLabels()
	ButtonSetPressedFlag(SettingsWindow.."TabGeneral", false)
	ButtonSetPressedFlag(SettingsWindow.."TabBar", false)
	ButtonSetPressedFlag(SettingsWindow.."TabIcons", false)
	ButtonSetPressedFlag(SettingsWindow.."TabLabels", true)
	ButtonSetPressedFlag(SettingsWindow.."TabImages", false)
	if DoesWindowExist(SettingsWindow.."General") then WindowSetShowing(SettingsWindow.."General", false) end
	if DoesWindowExist(SettingsWindow.."Bar") then WindowSetShowing(SettingsWindow.."Bar", false) end
	if DoesWindowExist(SettingsWindow.."Icons") then WindowSetShowing(SettingsWindow.."Icons", false) end
	if DoesWindowExist(SettingsWindow.."Images") then WindowSetShowing(SettingsWindow.."Images", false) end
	Addon.LabelImageBarSettings.Create()
	--Addon.EditBarPanel.OnClickTabLabel1()
end

function Addon.EditBarPanel.OnClickTabImages()
	ButtonSetPressedFlag(SettingsWindow.."TabGeneral", false)
	ButtonSetPressedFlag(SettingsWindow.."TabBar", false)
	ButtonSetPressedFlag(SettingsWindow.."TabIcons", false)
	ButtonSetPressedFlag(SettingsWindow.."TabLabels", false)
	ButtonSetPressedFlag(SettingsWindow.."TabImages", true)
	if DoesWindowExist(SettingsWindow.."General") then WindowSetShowing(SettingsWindow.."General", false) end
	if DoesWindowExist(SettingsWindow.."Bar") then WindowSetShowing(SettingsWindow.."Bar", false) end
	if DoesWindowExist(SettingsWindow.."Icons") then WindowSetShowing(SettingsWindow.."Icons", false) end
	if DoesWindowExist(SettingsWindow.."Labels") then WindowSetShowing(SettingsWindow.."Labels", false) end
	Addon.LabelImageBarSettings.Create()
	--Addon.EditBarPanel.OnClickTabImage1()
end

-- General Tabs
function Addon.EditBarPanel.OnClickTabBehaviour()
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabBehaviour", true)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabPositioning", false)
	Addon.GeneralBarSettings.CreateBehaviour()
end

function Addon.EditBarPanel.OnClickTabVisibility()
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabBehaviour", false)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabVisibility", true)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabPositioning", false)
	Addon.GeneralBarSettings.CreateVisibility()
end

function Addon.EditBarPanel.OnClickTabPositioning()
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabBehaviour", false)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabVisibility", false)
	ButtonSetPressedFlag(SettingsWindow.."GeneralTabPositioning", true)
	Addon.GeneralBarSettings.CreatePositioning()
end

-- Icon Tabs
function Addon.EditBarPanel.OnClickTabIconCareer()
	ButtonSetPressedFlag(SettingsWindow.."IconsTabCareer", true)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabRVR", false)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabStatus", false)
	Addon.IconBarSettings.CreateIconWindow("icon")
end

function Addon.EditBarPanel.OnClickTabIconRVR()
	ButtonSetPressedFlag(SettingsWindow.."IconsTabCareer", false)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabRVR", true)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabStatus", false)
	Addon.IconBarSettings.CreateIconWindow("rvr_icon")
end

function Addon.EditBarPanel.OnClickTabIconStatus()
	ButtonSetPressedFlag(SettingsWindow.."IconsTabCareer", false)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabRVR", false)
	ButtonSetPressedFlag(SettingsWindow.."IconsTabStatus", true)
	Addon.IconBarSettings.CreateIconWindow("status_icon")
end

-- Bar Tabs
function Addon.EditBarPanel.OnClickTabBarFill()
	ButtonSetPressedFlag(SettingsWindow.."BarTabFill", true)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBorder", false)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBackground", false)
	Addon.FillBarSettings.Create()
end

function Addon.EditBarPanel.OnClickTabBarBorder()
	ButtonSetPressedFlag(SettingsWindow.."BarTabFill", false)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBorder", true)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBackground", false)
	Addon.BorderBarSettings.Create()
end

function Addon.EditBarPanel.OnClickTabBarBackground()
	ButtonSetPressedFlag(SettingsWindow.."BarTabFill", false)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBorder", false)
	ButtonSetPressedFlag(SettingsWindow.."BarTabBackground", true)
	Addon.FillBGBarSettings.Create()
end


--------------------------------------------------------------
-- Description:
-- 				ColorDialog Callback Handlers
--------------------------------------------------------------
function Addon.EditBarPanel.OnColorDialogCallbackFill(Object, Event, EventData)

	-- Hint: COLOR_EVENT_UPDATED sends the old value again if cancel ist clicked
	-- First step: check for the right event
	if Event == RVAPI_ColorDialog.Events.COLOR_EVENT_UPDATED then
		Addon.B.Color.colorBox:Tint(math.floor(EventData.Red + 0.5), math.floor(EventData.Green + 0.5), math.floor(EventData.Blue + 0.5))
	end
end

function Addon.EditBarPanel.OnColorDialogCallback(Object, Event, EventData)
	-- Hint: COLOR_EVENT_UPDATED sends the old value again if cancel ist clicked
	-- First step: check for the right event
	if Event == RVAPI_ColorDialog.Events.COLOR_EVENT_UPDATED then
		local tab = Addon.GetCurrentTab()
		if tab == "Bar" then
			Addon.B.Color.colorBox:Tint(math.floor(EventData.Red + 0.5), math.floor(EventData.Green + 0.5), math.floor(EventData.Blue + 0.5))
		elseif tab == "Images" or tab == "Labels" then
			Addon.C.Color.colorBox:Tint(math.floor(EventData.Red + 0.5), math.floor(EventData.Green + 0.5), math.floor(EventData.Blue + 0.5))
		else
			if tab == nil then tab = "nil" end
			DEBUG(L"OnColorDialogCallback: Invalid tab: "..towstring(tab))
		end
	end
end

--------------------------------------------------------------
-- Description:
-- 				Combobox OnSelChanged Handler
--------------------------------------------------------------

function Addon.OnSelChangedEditBarSettings()	
	local w = Addon.B
	if (nil ~= w.cBox:Selected()) and (L"" ~= w.cBox:Selected()) then
		local selectedString = WStringToString(w.cBox:Selected())
		Addon.LabelImageBarSettings.Create(selectedString)
	end
end