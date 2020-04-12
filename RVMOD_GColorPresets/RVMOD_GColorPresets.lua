--------------------------------------------------------------------------------
-- File:      RVMOD_GColorPresets.lua
-- Date:      2010-02-16
-- Author:    Philosound
-- Credits:   MrAngel, Reivan
-- Version:   v1.0
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

if not RVMOD_GColorPresets then RVMOD_GColorPresets = {} end
local Addon	= RVMOD_GColorPresets
if (nil == Addon.Name) then Addon.Name = "RVMOD_GColorPresets" end

local isLibAddonButtonRegistered = false
local isRVMOD_ManagerRegistered = false
local isLibSlashRegistered = false

local RVName				= "_GColorPresets"
local RVCredits				= "MrAngel, silverq, rozbuska"
local RVLicense				= "MIT License"
local RVProjectURL			= "none yet"
local RVRecentUpdates		= 
"24.02.2010 - v0.9 Release\n"..
"\t- Code clearance\n"..
"\t- Adapted to work with the RV Mods Manager v0.99"

local LibGUI = LibStub("LibGUI")

Addon.ButtonWidth = 130
Addon.ButtonInherits = "EA_Button_DefaultResizeable"
Addon.FontHeadline = "font_default_war_heading" 
Addon.FontBold = "font_default_medium_heading" --"font_clear_medium_bold"
Addon.FontText = "font_default_text" -- "font_clear_medium"

--------------------------------------------------------------
-- var RVMOD
-- Description: module information/system configuration
--------------------------------------------------------------
Addon.RVMOD =
{
	--[[--------------------------------------------------------
	--	@type: (optional) 
	--	@description: put your full name here.
	--
	--	ATTENTION: UiMod name="RVMOD_YourModName" in the RVMOD_YourModName.mod should 
	--	be the same as your mod table name - i.e. RVMOD_YourModName
	--------------------------------------------------------]]--
	Name = "GColorPresets",

	--[[--------------------------------------------------------
	--	@type: (optional) 
	--	@description: put your description here.
	--------------------------------------------------------]]--
	Description	= "Global Color Preset Storage",
}

local LastComboBoxName		= "" -- : hack, but no other way to do that at the moment
local WindowSettings		= Addon.Name.."SettingsWindow"
local WindowFrame			= Addon.Name.."Frame"
local Templates				= {}
local LastFrameId			= 1
local Frames				= {}


function Addon.Print(str)
	EA_ChatWindow.Print(towstring(Addon.Name)..L": "..towstring( str ) )
end
--------------------------------------------------------------
-- Create a color
--------------------------------------------------------------
Addon.Color = {}
Addon.Color.__index = Addon.Color
Addon.DefaultColor = {name = "new color", r = 255, g = 255, b = 255}

function Addon.Color:new (colorName)
	return Addon.Color:newFromColor (colorName, Addon.DefaultColor)
end

function Addon.Color:newFromColor (colorName, color)
	if (nil ~= Addon.CurrentConfiguration[colorName]) then
		EA_ChatWindow.Print(L"Cannot create a new color for one that exists")
		return nil 
	end
	local self = {}

	setmetatable(self, Addon.Color) -- setup prototye

	self.name = colorName
	self.r = 255
	self.g = 255
	self.b = 255

	Addon.CurrentConfiguration[colorName] = self

	return self
end

--------------------------------------------------------------
-- var DefaultConfiguration
-- Description: default module configuration
--------------------------------------------------------------
Addon.DefaultConfiguration	= RVMOD_GColorPresets.GetFactoryPresets()


--------------------------------------------------------------
-- var CurrentConfiguration
-- Description: current module configuration
--------------------------------------------------------------
Addon.CurrentConfiguration =
{
	-- should stay empty, will load in the InitializeConfiguration() function
}

--------------------------------------------------------------
-- function Initialize()
-- Description:
--------------------------------------------------------------
function Addon.Initialize()

	-- First step: load configuration
	Addon.InitializeConfiguration()

	-- Second step: define event handlers
	--RegisterEventHandler(SystemData.Events.ALL_MODULES_INITIALIZED, Addon.Name..".OnAllModulesInitialized")
	RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, Addon.Name..".OnLoadingEnd")
	RegisterEventHandler(SystemData.Events.LOADING_END, Addon.Name..".OnLoadingEnd")
end

function Addon.OnLoadingEnd()
	if (LibAddonButton and (not isLibAddonButtonRegistered)) then
		LibAddonButton.AddMenuItem("fx", "Global Color Presets", Addon.OnStandaloneShowSettingsWindow)
		isLibAddonButtonRegistered = true
	end
	if (RVMOD_Manager and (not isRVMOD_ManagerRegistered)) then
		RVMOD_Manager.API_RegisterAddon(Addon.Name, Addon, Addon.OnRVManagerCallback)
		isRVMOD_ManagerRegistered = true
	end
	if LibSlash and (not isLibSlashRegistered) then
		LibSlash.RegisterSlashCmd("gcp", function(input) Addon.SlashHandler(input) end)
		isLibSlashRegistered = true
	end
end
--------------------------------------------------------------
-- function OnRVManagerCallback
-- Description:
--------------------------------------------------------------
function Addon.OnRVManagerCallback(Self, Event, EventData)

	if		Event == RVMOD_Manager.Events.NAME_REQUESTED then

		return RVName

	elseif	Event == RVMOD_Manager.Events.CREDITS_REQUESTED then

		return RVCredits

	elseif	Event == RVMOD_Manager.Events.LICENSE_REQUESTED then

		return RVLicense

	elseif	Event == RVMOD_Manager.Events.PROJECT_URL_REQUESTED then

		return RVProjectURL

	elseif	Event == RVMOD_Manager.Events.RECENT_UPDATES_REQUESTED then

		return RVRecentUpdates

	elseif	Event == RVMOD_Manager.Events.PARENT_WINDOW_UPDATED then

		if not DoesWindowExist(WindowSettings) then
			Addon.InitializeSettingsWindow()
		end

		WindowSetParent(WindowSettings, EventData.ParentWindow)
		WindowClearAnchors(WindowSettings)
		WindowAddAnchor(WindowSettings, "topleft", EventData.ParentWindow, "topleft", 0, 0)
		WindowAddAnchor(WindowSettings, "bottomright", EventData.ParentWindow, "bottomright", 0, 0)

		Addon.UpdateSettingsWindow()

		return true

	end
end

function Addon.OnStandaloneShowSettingsWindow()

	local w = LibGUI("Blackframe", "Standalone"..WindowSettings)
	w:Resize(510, 210)
	w:MakeMovable()
	w:AnchorTo("Root", "center", "center", 0, 0)
	--w.Background = LibGUI("Window", "Standalone"..WindowSettings.."Background", "EA_Window_DefaultBackgroundFrame")
	w.TitleBar = w:Add("Window", "Standalone"..WindowSettings.."TitleBar", "EA_TitleBar_Default")
	LabelSetText("Standalone"..WindowSettings.."TitleBarText", L"Global Color Presets")
	w.TitleBar:IgnoreInput()
	w.ButtonClose = w:Add(LibGUI("closebutton"))
	w.ButtonClose.OnLButtonUp = 
		function()
			w:Destroy()
		end
	Addon.SW = w
	if not DoesWindowExist(WindowSettings) then
		Addon.InitializeSettingsWindow()
	end
	WindowSetParent(WindowSettings, w.name)
	WindowClearAnchors(WindowSettings)
	WindowAddAnchor(WindowSettings, "topleft", w.name, "topleft", 0, 20)
	WindowAddAnchor(WindowSettings, "bottomright", w.name, "bottomright", 0, 0)
end
--------------------------------------------------------------
-- function OnAllModulesInitialized()
-- Description: event ALL_MODULES_INITIALIZED
-- We can start working with the RVAPI just then we sure they are all initialized
-- and ready to provide their services
--------------------------------------------------------------
function Addon.OnAllModulesInitialized()

		-- Final step: register in the RV Mods Manager
	-- Please note the folowing:
	-- 1. always do this ON SystemData.Events.ALL_MODULES_INITIALIZED event
	-- 2. you don't need to add RVMOD_Manager to the dependency list
	-- 3. the registration code should be same as below, with your own function parameters
	-- 4. for more information please follow by http://war.curse.com/downloads/war-addons/details/rv_mods.aspx
	if RVMOD_Manager then
		RVMOD_Manager.API_RegisterAddon(Addon.Name, Addon, Addon.OnRVManagerCallback)
	end
end

--------------------------------------------------------------
-- function Shutdown()
-- Description:
--------------------------------------------------------------
function Addon.Shutdown()
	-- First step: destroy settings window
	if DoesWindowExist(WindowSettings) then
		DestroyWindow(WindowSettings)
	end

	-- Second step: unregister events
	UnregisterEventHandler(SystemData.Events.ALL_MODULES_INITIALIZED, Addon.Name..".OnAllModulesInitialized")
end

--------------------------------------------------------------
-- function InitializeConfiguration()
-- Description: loads current configuration
--------------------------------------------------------------
function Addon.InitializeConfiguration()

	-- First step: move default value to the CurrentConfiguration variable
	for k,v in pairs(Addon.DefaultConfiguration) do
		if(Addon.CurrentConfiguration[k]==nil) then
			Addon.CurrentConfiguration[k]=v
		end
	end
end

--------------------------------------------------------------
-- function InitializeSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.InitializeSettingsWindow(ParentWindow)
	-- First step: create main window
	--CreateWindow(WindowSettings, true)
	local w = {}
	--w = LibGUI("Blackframe", WindowSettings)
	w = LibGUI("Window", WindowSettings)

	-- Create new color
	w.l2 = w("Label")
	w.l2:Resize(140)
	--w.l2:AnchorTo(w.l1, "right", "left", 0, 0)
	w.l2:AnchorTo(w, "topleft", "topleft", 25, 25)
	w.l2:Font(Addon.FontText)
	w.l2:SetText(L"Create Color:")
	w.l2:Align("left")
	w.l2:IgnoreInput()
	

	w.t1 = w("Textbox")
	w.t1:Resize(250)
	w.t1:AnchorTo(w.l2, "bottomleft", "topleft", 0, 0)
	w.t1.OnKeyEnter =
		function()
			if (nil ~= w.t1:GetText()) and (L"" ~= w.t1:GetText()) then
				Addon.Color:new(WStringToString(w.t1:GetText()))
				w.cColor:Add(w.t1:GetText())
				w.cColor:Select(w.t1:GetText())
				w.t1:Clear()
				Addon.OnSelChangedEditColorComboBox()
			end
		end
    w.t1.OnKeyTab =
		function()
			--EA_ChatWindow.Print(L"Tab")
			Addon.Color:new(WStringToString(w.t1:GetText()))
			w.cColor:Add(w.t1:GetText())
			w.cColor:Select(w.t1:GetText())
			Addon.OnSelChangedEditColorComboBox()
		end
    w.t1.OnKeyEscape =
		function()
			--EA_ChatWindow.Print(L"ESCAPE")
			w.t1:Clear()
		end

	
	w.b1 = w("Button", nil, Addon.ButtonInherits)
	w.b1:Resize(Addon.ButtonWidth)
	w.b1:SetText(L"Create")
	w.b1:AnchorTo(w.t1, "right", "left", 10, 0)
	w.b1.OnLButtonUp = 
		function()
			if (nil ~= w.t1:GetText()) and (L"" ~= w.t1:GetText()) then
				Addon.Color:new(WStringToString(w.t1:GetText()))
				w.cColor:Add(w.t1:GetText())
			end
		end
	

	-- edit color
	w.lEditColor = w("Label", WindowSettings.."lEditColor")
	w.lEditColor:Resize(140)
	--w.lEditColor:Position(25,125)
	w.lEditColor:AnchorTo(w.t1, "bottomleft", "topleft", 0, 10)
	w.lEditColor:Font(Addon.FontText)
	w.lEditColor:SetText(L"Edit Color:")
	w.lEditColor:Align("left")
	w.lEditColor:IgnoreInput()
	
	w.cColor = w("Combobox", nil, Addon.Name.."ComboBoxTemplate")
	w.cColor:AnchorTo(w.lEditColor, "bottomleft", "topleft", 0, 0)
	

	CreateWindowFromTemplate( WindowSettings.."EditColorBox", Addon.Name.."SettingsColorBoxTemplate", w.name)
	WindowAddAnchor( WindowSettings.."EditColorBox", "right", w.cColor.name, "left", 10, 0 )
	WindowSetTintColor(WindowSettings.."EditColorBoxBorderForeground", 0, 0, 0) -- *255 or not?
	WindowRegisterCoreEventHandler( WindowSettings.."EditColorBox", "OnLButtonUp", Addon.Name..".OnClickEditColorBox")
	WindowRegisterCoreEventHandler( WindowSettings.."EditColorBox", "OnMouseOver", Addon.Name..".OnMouseOverEditColorBox")
	
	w.buttonDelete = w("Button", nil, Addon.ButtonInherits)
	w.buttonDelete:Resize(Addon.ButtonWidth)
	w.buttonDelete:SetText(L"Delete")
	w.buttonDelete:AnchorTo(WindowSettings.."EditColorBox", "right", "left", 10, 0)
	w.buttonDelete.OnLButtonUp = 
		function()
			if (nil ~= w.cColor:Selected()) and (L"" ~= w.cColor:Selected()) then
				local colorName = WStringToString(w.cColor:Selected())
				if Addon.DefaultConfiguration[colorName] ~= nil then
					Addon.ResetFactoryPreset(colorName)
					Addon.OnSelChangedEditColorComboBox()
					Addon.Print("Resetted Factory Preset "..colorName.." to default values.")
					return
				end
				Addon.CurrentConfiguration[colorName] = nil
				Addon.PopulateEditColorCombobox()
				w.cColor:Select("default")
				Addon.OnSelChangedEditColorComboBox("default")
				Addon.Print("Deleted Global Color Preset: "..colorName)
			end
		end
		
	Addon.W = w
	Addon.PopulateEditColorCombobox()
	Addon.W:Show()
end

function Addon.PopulateEditColorCombobox()
	local w = Addon.W
	w.cColor:Clear()
	local tt={}
	for k,v in pairs(Addon.CurrentConfiguration) do
		table.insert (tt, k)
	end
	table.sort(tt)
	for k,v in pairs(tt) do w.cColor:Add(v) end
end
--------------------------------------------------------------
-- function ShowModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.ShowModuleSettings(ModuleWindow)

	-- First step: check for window
	if not DoesWindowExist(WindowSettings) then
		Addon.InitializeSettingsWindow(ModuleWindow)
	end

	-- Second step: update fields with the current configuration 
	Addon.UpdateSettingsWindow()

	-- Final step: show everything
	WindowSetShowing(WindowSettings, true)
end

--------------------------------------------------------------
-- function HideModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.HideModuleSettings()

	-- Final step: hide window
	WindowSetShowing(WindowSettings, false)
end

--------------------------------------------------------------
-- function GetModuleStatus()
-- Description: returns module status: RV_System.Status
--------------------------------------------------------------
function Addon.GetModuleStatus()

	-- Final step: return status
	-- TODO: (MrAngel) place a status calculation code in here
	return RV_System.Status.MODULE_STATUS_ENABLED
end

--------------------------------------------------------------
-- function UpdateSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.UpdateSettingsWindow()

end


--
-- ColorDialog CallbackHandler
--
function Addon.OnColorDialogCallback(Object, Event, EventData)
	-- Hint: COLOR_EVENT_UPDATED sends the old value again if cancel ist clicked
	-- First step: check for the right event

	if Event == RVAPI_ColorDialog.Events.COLOR_EVENT_UPDATED then
		-- : set color box value
		WindowSetTintColor(WindowSettings.."EditColorBoxBorderForeground", EventData.Red, EventData.Green, EventData.Blue)
		--EA_ChatWindow.Print(towstring(Object))
		--local colorName = WStringToString(Addon.W.cColor:Selected())
		Addon.CurrentConfiguration[Object].r = math.floor(EventData.Red + 0.5)
		Addon.CurrentConfiguration[Object].g = math.floor(EventData.Green + 0.5)
		Addon.CurrentConfiguration[Object].b = math.floor(EventData.Blue + 0.5)
	end
end

function Addon.OnClickEditColorBox()
	local w = Addon.W
	if (nil ~= w.cColor:Selected()) and (L"" ~= w.cColor:Selected()) then
		local colorName = WStringToString(w.cColor:Selected())
		Addon.EditColorPreset(colorName)
	end
end

function Addon.OnMouseOverEditColorBox()
end

function Addon.OnSelChangedEditColorComboBox()
	local w = Addon.W
	if (nil ~= w.cColor:Selected()) and (L"" ~= w.cColor:Selected()) then
		local colorName = WStringToString(w.cColor:Selected())
		-- : set color box value
		WindowSetTintColor(WindowSettings.."EditColorBoxBorderForeground", Addon.CurrentConfiguration[colorName].r, Addon.CurrentConfiguration[colorName].g, Addon.CurrentConfiguration[colorName].b)
		if Addon.DefaultConfiguration[colorName] ~= nil then w.buttonDelete:SetText(L"Reset") else w.buttonDelete:SetText(L"Delete") end
	end
end

--
-- Finally, the Getters
function Addon.GetColorPresetList()
	local tt={}
	for k,v in pairs(Addon.CurrentConfiguration) do
		table.insert (tt, k)
	end
	table.sort(tt)
	return tt
end

function Addon.GetColorPresets()
	return Addon.CurrentConfiguration
end

function Addon.GetColorPreset(presetName)
	return Addon.CurrentConfiguration[presetName]
end

function Addon.EditColorPreset(colorName)
	local ColorDialogOwner, ColorDialogFunction = RVAPI_ColorDialog.API_GetLink()
	-- Second step: check for the current color dialog link
	if ColorDialogOwner ~= Addon or ColorDialogFunction ~= Addon.OnColorDialogCallback then
		-- Third step: open color dialog
		RVAPI_ColorDialog.API_OpenDialog(colorName, Addon.OnColorDialogCallback, true, Addon.CurrentConfiguration[colorName].r, Addon.CurrentConfiguration[colorName].g, Addon.CurrentConfiguration[colorName].b, Addon.CurrentConfiguration[a], Window.Layers.SECONDARY)
	else
		-- Fourth step: close color dialog
		RVAPI_ColorDialog.API_CloseDialog(true)
	end
end

function Addon.SlashHandler(cmd)
	if RVMOD_Manager then
		RVMOD_Manager.API_ToggleAddon(Addon.Name, 2)
	else
		Addon.OnStandaloneShowSettingsWindow()
	end
end