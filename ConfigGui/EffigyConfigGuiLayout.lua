if not Effigy then Effigy = {} end
local CoreAddon = Effigy
if not EffigyConfigGui then EffigyConfigGui = {} end
local Addon = EffigyConfigGui
if (nil == Addon.Name) then Addon.Name = "EffigyConfigGui" end

local LibGUI = LibStub("LibGUI")

function Addon.ConditionalDeleteLayout(name)
	if (nil ~= name and nil ~= CoreAddon.SavedLayouts[name]) then
		local text = GetStringFormat (StringTables.Default.LABEL_TEXT_DESTROY_ITEM_CONFIRM, { name } )
		DialogManager.MakeTwoButtonDialog(
		text,
		GetString( StringTables.Default.LABEL_YES ),
		function()
			CoreAddon.SavedLayouts[name] = nil
			local w = Addon.LayoutPanel.W
			if w and w.name then
				w.LayoutCombo:Clear()
				local tt={}
				for k,_ in pairs(UFTemplates.Layouts) do table.insert (tt, k) end
				for k,_ in pairs(CoreAddon.SavedLayouts) do table.insert (tt, k) end
				table.sort(tt)
				for _,v in ipairs(tt) do w.LayoutCombo:Add(v) end
			end
			Addon.UpdateLibAddonButton()
			if DoesWindowExist(Addon.Name.."SettingsWindow") then Addon.UpdateSettingsWindow() end
		end, 
		GetString( StringTables.Default.LABEL_NO ))
	else
		EA_ChatWindow.Print(L"Error with Selected Item")
	end
end

--[[
--	Layout Panel ------------------------------------------------
--]]
local SettingsWindow = Addon.Name.."SettingsWindowLayoutPanel"

Addon.LayoutPanel = {}
Addon.LayoutPanel.W = nil

--------------------------------------------------------------
-- function InitializeSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.LayoutPanel.InitializeSettingsWindow(ParentWindow)
	local frameSizeW = 630
	local frameSizeH = 200
	--
	-- XML Part
	--
	-- First step: create window from template
	CreateWindowFromTemplate(SettingsWindow, Addon.Name.."PopupWindowTemplate","Root")
	WindowRegisterCoreEventHandler(SettingsWindow.."ButtonOK", "OnLButtonUp", Addon.Name..".LayoutPanel.OnClickCloseSettings")
	WindowRegisterCoreEventHandler(SettingsWindow.."ButtonClose", "OnLButtonUp", Addon.Name..".LayoutPanel.OnClickCloseSettings")
	WindowSetDimensions(SettingsWindow, frameSizeW, frameSizeH)
	LabelSetText(SettingsWindow.."TitleBarText", L"Layout")
	ButtonSetText(SettingsWindow.."ButtonOK", L"Close")

	--
	-- LibGUI Part
	--	

	local w = {}

	if (nil ~= Addon.LayoutPanel.W) then
		Addon.LayoutPanel.Destroy()
	end

	w = LibGUI("window")
	--w:Resize(frameSizeW - 160, frameSizeH - 40)
	w:AnchorTo(SettingsWindow, "topleft", "topleft", 0, 30)
	w:AddAnchor(SettingsWindow, "bottomright", "bottomright", 0, -60)
	w:Parent(SettingsWindow)

	-- layout combo
	w.LayoutCombo = w("Combobox")
	w.LayoutCombo:AnchorTo(w, "topleft", "topleft", 25, 20)
	local tt={}
	for k,_ in pairs(UFTemplates.Layouts) do table.insert (tt, k) end
	for k,_ in pairs(CoreAddon.SavedLayouts) do table.insert (tt, k) end
	table.sort(tt)
	for _,v in ipairs(tt) do w.LayoutCombo:Add(v) end

	-- layout button
	w.LayoutLoadButton = w("Button", nil, Addon.ButtonInherits)
	w.LayoutLoadButton:Resize(Addon.ButtonWidth)
	w.LayoutLoadButton:SetText(L"Load")
	w.LayoutLoadButton:AnchorTo(w.LayoutCombo, "right", "left", 20, 0)
	w.LayoutLoadButton.OnMouseOver = 
		function()
			Addon.SetToolTip(w.LayoutLoadButton, "WARNING: Current settings will be lost.",
				"Don't forget to save!")
		end
	w.LayoutLoadButton.OnLButtonUp = 
		function()
			CoreAddon.LoadLayout(WStringToString(w.LayoutCombo:Selected()))
			--Addon.BarPanel.Create() -- Reload selectable bars for this new layout
			Addon.UpdateSettingsWindow()
		end
	
	-- layout delete button
	w.LayoutDeleteButton = w("Button", nil, Addon.ButtonInherits)
	w.LayoutDeleteButton:Resize(Addon.ButtonWidth)
	w.LayoutDeleteButton:SetText(L"Delete")
	w.LayoutDeleteButton:AnchorTo(w.LayoutLoadButton, "right", "left", 20, 0)
	w.LayoutDeleteButton.OnMouseOver = 
		function()
			Addon.SetToolTip(w.LayoutDeleteButton, "WARNING: Layout will be lost. NO UNDO.")
		end
	w.LayoutDeleteButton.OnLButtonUp = 
		function()
			local selectedLayout = WStringToString(w.LayoutCombo:Selected())
			if UFTemplates.Layouts[selectedLayout] then
				EA_ChatWindow.Print(L"You can not delete a factory preset")
				return
			end
			Addon.ConditionalDeleteLayout(selectedLayout)
			Addon.UpdateSettingsWindow()
		end
	
	-- layout save textbox
	w.LayoutSaveName = w("Textbox")
	w.LayoutSaveName:Resize(250)
	w.LayoutSaveName:AnchorTo(w.LayoutCombo, "bottomleft", "topleft", 0, 20)

	-- layout button
	w.LayoutSaveButton = w("Button", nil, Addon.ButtonInherits)
	w.LayoutSaveButton:Resize(Addon.ButtonWidth)
	w.LayoutSaveButton:SetText(L"Save")
	w.LayoutSaveButton:AnchorTo(w.LayoutSaveName, "right", "left", 20, 0)
	w.LayoutSaveButton.OnLButtonUp = 
		function()
			local saveLayoutName = w.LayoutSaveName:GetText()
			if (nil ~= saveLayoutName) and (L"" ~= saveLayoutName) then
				saveLayoutName = WStringToString(saveLayoutName)
				if UFTemplates.Layouts[saveLayoutName] then
					EA_ChatWindow.Print(L"You cannot overwrite a factory preset. Please chose another name.")
					return
				end
				CoreAddon.SaveLayout(WStringToString(w.LayoutSaveName:GetText()))
				w.LayoutCombo:Add(w.LayoutSaveName:GetText())
			end
		end

	Addon.LayoutPanel.W = w

	Addon.LayoutPanel.W:Show()
	
end

--------------------------------------------------------------
-- function ShowModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.LayoutPanel.ShowModuleSettings()--ModuleWindow)

	-- First step: check for window
	if not DoesWindowExist(SettingsWindow) then
		Addon.LayoutPanel.InitializeSettingsWindow("root")--ModuleWindow)
	end

	-- Second step: update fields with the current configuration 
	Addon.LayoutPanel.UpdateSettingsWindow()

	-- Final step: show everything
	WindowSetShowing(SettingsWindow, true)
end

--------------------------------------------------------------
-- function HideModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.LayoutPanel.HideModuleSettings()
	--Addon.LayoutPanel.Destroy()
	-- Final step: hide window
	WindowSetShowing(SettingsWindow, false)
end

function Addon.LayoutPanel.Destroy()
	Addon.LayoutPanel.W:Destroy()
end
--------------------------------------------------------------
-- function UpdateSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.LayoutPanel.UpdateSettingsWindow()
end

--------------------------------------------------------------
-- CLICK HANDLERS
--------------------------------------------------------------

function Addon.LayoutPanel.OnClickCloseSettings()
	Addon.LayoutPanel.HideModuleSettings()
end


--[[function Addon.LayoutPanel.OnClickLoadLayoutButton()
	CoreAddon.LoadLayout(WStringToString(Addon.LayoutPanel.W.LayoutCombo:Selected()))
	--Addon.BarPanel.Create() -- Reload selectable bars for this new layout
	Addon.UpdateSettingsWindow()
	Addon.UpdateLibAddonButton()
	Addon.LayoutPanel.W.LayoutSaveName:SetText(Addon.LayoutPanel.W.LayoutCombo:Selected())
	--Addon.LayoutPanel.UpdateSettingsWindow()
end

function Addon.LayoutPanel.OnMouseOver()
	
	if SystemData.ActiveWindow.name == Addon.Name.."SettingsWindowLayoutPanelLoadLayoutButton" then
		Addon.SetToolTip(SystemData.ActiveWindow, "WARNING: Current settings will be lost.",
				"Don't forget to save!")
	end
	
end

function Addon.LayoutPanel.OnClickSaveLayoutButton()
	if (nil ~= Addon.LayoutPanel.W.LayoutSaveName:GetText()) and (L"" ~= Addon.LayoutPanel.W.LayoutSaveName:GetText()) then
		CoreAddon.SaveLayout(WStringToString(Addon.LayoutPanel.W.LayoutSaveName:GetText()))
		Addon.LayoutPanel.W.LayoutCombo:Add(w.LayoutSaveName:GetText())
	end
end]]--