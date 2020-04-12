--------------------------------------------------------------------------------
-- File:      EffigyConfigGui.lua
-- Date:      2010-02-16
-- Author:    Philosound
-- Credits:   MrAngel, Reivan
-- Version:   v1.0
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
if not Effigy then Effigy = {} end
local CoreAddon = Effigy
if not EffigyConfigGui then EffigyConfigGui = {} end
local Addon	= EffigyConfigGui
if (nil == Addon.Name) then Addon.Name = "EffigyConfigGui" end

local LibGUI = LibStub("LibGUI")
local isLibAddonButtonRegistered = false

local function GetSortedBarNames()
	local tt = {}
	table.foreach(CoreAddon.Bars, 
		function (k,b)
			if (nil == b.hidden)or(false == b.hidden) then
				table.insert (tt, k) 
			end
		end)
	table.sort(tt)
	return tt
end

local RVName				= "EffigyConfigGui"
local RVCredits				= "Metaphaze, tannecurse, MrAngel, silverq, rozbuska"
local RVLicense				= "MIT License"
local RVProjectURL			= "none yet"
local RVRecentUpdates		= 
"19.09.2010 - v2.6 Release\n"..
"\t- Code clearance\n"..
"\t- Adapted to work with the RV Mods Manager v0.99"..
"\t- Uses LibRange"..
"\t- Includes Global Color Presers"..
"19.05.2010 - v1.0 Release\n"..
"\t- Code clearance\n"..
"\t- Adapted to work with the RV Mods Manager v0.99"..
"\t- Uses RVAPI_Range"..
"\t- Includes Global Color Presers, BuffIndicators, LibBuffEvents"..
"\t- started as Fork of HUD Unit Frames by tannecurse/Metaphaze"

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
	Name = "EffigyConfigGui",

	--[[--------------------------------------------------------
	--	@type: (optional) 
	--	@description: put your description here.
	--------------------------------------------------------]]--
	Description	= "Configuration Graphical User Interface for Effigy",
}

local LastComboBoxName		= "" -- : hack, but no other way to do that at the moment
local WindowSettings		= Addon.Name.."SettingsWindow"
local WindowFrame			= Addon.Name.."Frame"
local Templates				= {}
local LastFrameId			= 1
local Frames				= {}

Addon.FontList = {
font_chat_text= 1, font_clear_tiny= 1, font_clear_small= 1, font_clear_medium= 1, font_clear_large= 1, font_clear_small_bold= 1, font_clear_medium_bold= 1, font_clear_large_bold= 1, font_default_text_small= 1, font_default_text= 1, font_default_text_large= 1, font_default_text_huge= 1, font_heading_large= 1, font_heading_huge= 1, font_journal_text_small= 1, font_journal_text= 1, font_alert_outline_giant= 1, font_alert_outline_gigantic= 1, font_alert_outline_half_giant= 1, font_alert_outline_half_gigantic= 1, font_alert_outline_half_huge= 1, font_alert_outline_half_large= 1, font_alert_outline_half_medium= 1, font_alert_outline_half_small= 1, font_alert_outline_half_tiny= 1, font_alert_outline_huge= 1, font_alert_outline_large= 1, font_alert_outline_medium= 1, font_alert_outline_small= 1, font_alert_outline_tiny= 1, font_chat_text= 1, font_chat_text_bold= 1, font_chat_text_no_outline= 1, font_clear_default= 1, font_clear_large= 1, font_clear_large_bold= 1, font_clear_medium= 1, font_clear_medium_bold= 1, font_clear_small= 1, font_clear_small_bold= 1, font_clear_tiny= 1, font_default_heading= 1, font_default_medium_heading= 1, font_default_sub_heading= 1, font_default_sub_heading_no_outline= 1, font_default_text= 1, font_default_text_giant= 1, font_default_text_gigantic= 1, font_default_text_huge= 1, font_default_text_large= 1, font_default_text_no_outline= 1, font_default_text_small= 1, font_default_war_heading= 1, font_guild_MP_R_17= 1, font_guild_MP_R_19= 1, font_guild_MP_R_23= 1, font_heading_20pt_no_shadow= 1, font_heading_22pt_no_shadow= 1, font_heading_big_noshadow= 1, font_heading_default= 1, font_heading_default_no_shadow= 1, font_heading_huge= 1, font_heading_huge_no_shadow= 1, font_heading_huge_noshadow= 1, font_heading_large= 1, font_heading_large_noshadow= 1, font_heading_medium= 1, font_heading_medium_noshadow= 1, font_heading_rank= 1, font_heading_small_no_shadow= 1, font_heading_target_mouseover_name= 1, font_heading_tiny_no_shadow= 1, font_heading_unitframe_con= 1, font_heading_unitframe_large_name= 1, font_heading_zone_name_no_shadow= 1, font_journal_body= 1, font_journal_body_large= 1, font_journal_heading= 1, font_journal_heading_smaller= 1, font_journal_small_heading= 1, font_journal_sub_heading= 1, font_journal_text= 1, font_journal_text_huge= 1, font_journal_text_italic= 1, font_journal_text_large = 1
}

function Addon.SetToolTip(item, str, str2, str3, str4, str5, str6)
	Tooltips.CreateTextOnlyTooltip(item.name)
	if (nil ~= str) then
		Tooltips.SetTooltipText(1, 1, towstring(str))
	end
	if (nil ~= str2) then
		Tooltips.SetTooltipText(2, 1, towstring(str2))
	end
	if (nil ~= str3) then
		Tooltips.SetTooltipText(3, 1, towstring(str3))
	end
	if (nil ~= str4) then
		Tooltips.SetTooltipText(4, 1, towstring(str4))
	end
	if (nil ~= str5) then
		Tooltips.SetTooltipText(5, 1, towstring(str5))
	end
	if (nil ~= str6) then
		Tooltips.SetTooltipText(6, 1, towstring(str6))
	end

	Tooltips.Finalize()
	local anchor = { 
					Point = "topleft",  
					RelativeTo = item.name, 
					RelativePoint = "topright",   
					XOffset = -5, YOffset = -5 }

	Tooltips.AnchorTooltip(anchor)
end

--[[
--------------------------------------------------------------
-- var DefaultConfiguration
-- Description: default module configuration
--------------------------------------------------------------
Addon.DefaultConfiguration	=
{
	Bars						= {
			{
			Classification		= CLASS_MOUSEOVERTARGET,
			TemplateName		= "RVF_Classic",									-- optional
			Conditions			= {},
			Settings			= {},												-- required as {} by default
		},
	}
}

--------------------------------------------------------------
-- var CurrentConfiguration
-- Description: current module configuration
--------------------------------------------------------------
Addon.CurrentConfiguration =
{
	-- should stay empty, will load in the InitializeConfiguration() function
}]]--

--------------------------------------------------------------
-- function Initialize()
-- Description:
--------------------------------------------------------------
function Addon.Initialize()

	--CoreAddon.States["test"].valid = 1
	--CoreAddon.States["test"]:renderElements()
	--CoreAddon.States["test"].curr = math.random(1, 100)

	-- First step: load configuration
	--Addon.InitializeConfiguration()

	Addon.Fonts = {}
	table.foreach(Addon.FontList, function (k) table.insert (Addon.Fonts, k) end )
	table.sort(Addon.Fonts)
	
	-- Second step: define event handlers
	RegisterEventHandler(SystemData.Events.ALL_MODULES_INITIALIZED, Addon.Name..".OnAllModulesInitialized")
	RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, Addon.Name..".OnLoadingEnd")
	RegisterEventHandler(SystemData.Events.LOADING_END, Addon.Name..".OnLoadingEnd")
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
		--d(WindowGetDimensions(WindowSettings))
		Addon.UpdateSettingsWindow()

		return true

	end
end

--/script EffigyConfigGui.CreateStandaloneSettingsWindow()
function Addon.CreateStandaloneSettingsWindow()
	-- (688, 753) Window Size in RV_ModManager x +12 for borders of blackframe
	local w = LibGUI("blackframe", "Standalone"..WindowSettings)
	w:Resize(700, 700)
	w:MakeMovable()
	w:AnchorTo("Root", "center", "center", 0,0)
	
	w.TitleBar = w:Add("Window", "Standalone"..WindowSettings.."TitleBar", "EA_TitleBar_Default")
	LabelSetText("Standalone"..WindowSettings.."TitleBarText", L"Effigy")
	w.TitleBar:IgnoreInput()
	w.ButtonClose = w:Add(LibGUI("closebutton"))
	w.ButtonClose.OnLButtonUp = 
		function()
			w:Destroy()
		end
	
	Addon.MW = w
	--688 *753 RV_Mod Size
	if not DoesWindowExist(WindowSettings) then
		Addon.InitializeSettingsWindow()
	end
	WindowSetParent(WindowSettings, w.name)
	WindowClearAnchors(WindowSettings)
	WindowAddAnchor(WindowSettings, "topleft", w.name, "topleft", 6, 32)
	WindowAddAnchor(WindowSettings, "bottomright", w.name, "bottomright", -6, 0)
	--WindowSetDimensions(WindowSettings, 688, 753)
	Addon.UpdateSettingsWindow()
	WindowSetShowing(WindowSettings, true)
end

--------------------------------------------------------------
-- function OnAllModulesInitialized()
-- Description: event ALL_MODULES_INITIALIZED
-- We can start working with the RVAPI just then we sure they are all initialized
-- and ready to provide their services
--------------------------------------------------------------
function Addon.OnAllModulesInitialized()
	-- First step: enable rules
	--[[for BarIndex, Bar in ipairs(Addon.CurrentConfiguration.Bars) do

		-- Second step: create a frames table in the Frames list
		table.insert(Frames, {})

		-- Third step: enable rule
		--RVMOD_Targets.EnableRule(BarIndex)

		-- Fourth step: update rule
		-- TODO (MrAngel) do we need that at all?
--		RVMOD_Targets.UpdateByRuleIndex(RuleIndex)
	end]]--
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



function Addon.UpdateLibAddonButton()
	--[[
	if not LibAddonButton then return end

	local foundbuttonname
	local foundmenunumber
	for buttonname,button in pairs(LibAddonButton.RegisteredButtons) do
		for k, v in ipairs(button.Menu.Subitems) do
			if v.Text == L"Effigy" then
				local subitems = LibAddonButton.RegisteredButtons[buttonname].Menu.Subitems
				subitems[k] = nil
				isLibAddonButtonRegistered = false
				Addon.OnLoadingEnd()
				subitems[k] = subitems[#subitems]
				table.remove(subitems, #subitems)
			end
		end
	end]]--
	
end

function Addon.OnLoadingEnd()
	if (LibAddonButton and (not isLibAddonButtonRegistered)) then
		--LibAddonButton.Register("Effigy")
		--LibAddonButton.AddMenuItem("fx", "Effigy", function () RVMOD_Manager.API_ToggleAddon("EffigyConfigGui", 2) end)
		local menu = LibAddonButton.AddCascadingMenuItem("fx", L"Effigy")
		if RVMOD_Manager then
			LibAddonButton.AddMenuSubitem(menu, L"Main Menu", function () RVMOD_Manager.API_ToggleAddon("EffigyConfigGui", 2) end)
		else
			LibAddonButton.AddMenuSubitem(menu, L"Main Menu", Addon.CreateStandaloneSettingsWindow)
		end
		LibAddonButton.AddMenuSubitem(menu, L"Layouts", Addon.LayoutPanel.ShowModuleSettings)
		LibAddonButton.AddMenuSubitem(menu, L"Misc", Addon.Misc.ShowModuleSettings)
		--LibAddonButton.AddMenuSubitem(menu, L"States", Addon.Settings.ShowModuleSettings)
		LibAddonButton.AddMenuSubitem(menu, L"Rules", Addon.Rules.ShowModuleSettings)
		LibAddonButton.AddMenuSubitem(menu, L"Manage Bars", Addon.BarPanel.Create)
		--[[local barmenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar")
		local grphpmenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar: Group")
		local grpapmenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar: Group AP")
		local grpmoralemenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar: Group Morale")
		local formationmenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar: Formation")
		local grpcfmenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar: Custom Friendly Group")
		local grpchmenu = LibAddonButton.AddCascadingMenuSubitem(menu, L"Edit Bar: Custom Hostile Group")
		
		local bars = GetSortedBarNames()
		for _, barname in ipairs(bars) do
			local barstate = CoreAddon.Bars[barname].state
			if string.startsWith(barstate, "fo") then
				LibAddonButton.AddMenuSubitem(formationmenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
			elseif string.startsWith(barstate, "grpCF") then
				LibAddonButton.AddMenuSubitem(grpcfmenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
			elseif string.startsWith(barstate, "grpCH") then
				LibAddonButton.AddMenuSubitem(grpchmenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
			elseif string.startsWith(barstate, "grp") then			
				if string.endsWith(barstate, "hp") then
					LibAddonButton.AddMenuSubitem(grphpmenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
				elseif string.endsWith(barstate, "ap") then
					LibAddonButton.AddMenuSubitem(grpapmenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
				else
					-- morale
					LibAddonButton.AddMenuSubitem(grpmoralemenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
				end
			else
				LibAddonButton.AddMenuSubitem(barmenu, towstring(barname), function() Addon.EditBarPanel.Create(barname) end)
			end
		end]]--
		isLibAddonButtonRegistered = true
	end
end

--------------------------------------------------------------
-- function Shutdown()
-- Description:
--------------------------------------------------------------
function Addon.Shutdown()
	CoreAddon.FakeParty = false
	CoreAddon.States["test"].valid = 0
	CoreAddon.States["test"]:renderElements()
	
	-- First step: destroy settings window
	if DoesWindowExist(WindowSettings) then
		DestroyWindow(WindowSettings)
	end

	-- Second step: unregister events
	UnregisterEventHandler(SystemData.Events.ALL_MODULES_INITIALIZED, Addon.Name..".OnAllModulesInitialized")
end


--[[--------------------------------------------------------------
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
end]]--

--------------------------------------------------------------
-- function InitializeSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.InitializeSettingsWindow(ParentWindow)

	-- First step: create main window
	CreateWindow(WindowSettings, true)
	--WindowSetParent(WindowSettings, ParentWindow.name)
	--WindowClearAnchors(WindowSettings)
	--WindowAddAnchor(WindowSettings, "topleft", ParentWindow.name, "topleft", 0, 0)
	--WindowAddAnchor(WindowSettings, "bottomright", ParentWindow.name, "bottomright", 0, 0)

	LabelSetText(WindowSettings.."TCLayoutsTitle", L"Layouts")
	LabelSetTextColor(WindowSettings.."TCLayoutsTitle", 255, 255, 255)
	ButtonSetText(WindowSettings.."TCLayoutsButton", L"Open")
	WindowRegisterCoreEventHandler(WindowSettings.."TCLayoutsButton", "OnLButtonUp", Addon.Name..".OnClickLayouts")

	LabelSetText(WindowSettings.."TCMiscTitle", L"Misc")
	LabelSetTextColor(WindowSettings.."TCMiscTitle", 255, 255, 255)
	ButtonSetText(WindowSettings.."TCMiscButton", L"Open")
	WindowRegisterCoreEventHandler(WindowSettings.."TCMiscButton", "OnLButtonUp", Addon.Name..".OnClickMisc")

	LabelSetText(WindowSettings.."TCStatesTitle", L"Mysterious")
	LabelSetTextColor(WindowSettings.."TCStatesTitle", 125, 125, 125)
	ButtonSetText(WindowSettings.."TCStatesButton", L"Empty Button")
	ButtonSetDisabledFlag(WindowSettings.."TCStatesButton", true)
	WindowRegisterCoreEventHandler(WindowSettings.."TCStatesButton", "OnLButtonUp", Addon.Name..".OnClickStates")

	LabelSetText(WindowSettings.."TCRulesTitle", L"Rules")
	LabelSetTextColor(WindowSettings.."TCRulesTitle", 255, 255, 255)
	ButtonSetText(WindowSettings.."TCRulesButton", L"Open")
	WindowRegisterCoreEventHandler(WindowSettings.."TCRulesButton", "OnLButtonUp", Addon.Name..".OnClickRules")

	LabelSetText(WindowSettings.."TCBarsTitle", L"Bars")
	LabelSetTextColor(WindowSettings.."TCBarsTitle", 255, 255, 255)
	ButtonSetText(WindowSettings.."TCBarsButton", L"Manage")
	WindowRegisterCoreEventHandler(WindowSettings.."TCBarsButton", "OnLButtonUp", Addon.Name..".OnClickBars")
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

	local theWindowSettings = WindowSettings
	if not DoesWindowExist(theWindowSettings) then
		if DoesWindowExist("Standalone"..WindowSettings) then
			theWindowSettings = "Standalone"..WindowSettings
		else
			return
		end
	end
	
	Addon.Bars = GetSortedBarNames()--[[{}
	table.foreach(CoreAddon.Bars, 
		function (k,b)
			if (nil == b.hidden)or(false == b.hidden) then
				table.insert (Addon.Bars, k) 
			end
		end)
	table.sort(Addon.Bars)]]--
	--for k,v in pairs(tt) do w.EditBar:Add(v) end 
	
	-- Third step: destroy frame rows, we will create them again
	local Index = 1
	while DoesWindowExist(theWindowSettings.."FramesScrollChild"..Index) do
		DestroyWindow(theWindowSettings.."FramesScrollChild"..Index)
		Index = Index + 1
	end
	
	-- Fourth step: loop through all Bars
	for BarIndex, Bar in pairs(Addon.Bars) do --or ipairs?

		-- : calculate frame and parent window names
		local frameWindow = theWindowSettings.."FramesScrollChild"..BarIndex
		local parentWindow = theWindowSettings.."FramesScrollChild"
	
		-- : create new row
		CreateWindowFromTemplate( frameWindow, Addon.Name.."FrameRowTemplate", parentWindow )
		if( BarIndex == 1 )
		then
		    WindowAddAnchor( frameWindow, "topleft", parentWindow, "topleft", 0, 0 )
		    WindowAddAnchor( frameWindow, "topright", parentWindow, "topright", 0, 0 )
		else
		    WindowAddAnchor( frameWindow, "bottomleft", parentWindow..(BarIndex-1), "topleft", 0, 0 )
		    WindowAddAnchor( frameWindow, "bottomright", parentWindow..(BarIndex-1), "topright", 0, 0 )
		end
		WindowSetId( frameWindow, BarIndex )

		if string.sub(CoreAddon.Bars[Bar].state,1,string.len("FT")) == "FT"  then
			DynamicImageSetTexture( frameWindow.."Background", "TextureTypeFriendly", 0, 0 )
		elseif string.sub(CoreAddon.Bars[Bar].state,1,string.len("HT")) == "HT"  then
			DynamicImageSetTexture( frameWindow.."Background", "TextureTypeHostile", 0, 0 )
		elseif string.sub(CoreAddon.Bars[Bar].state,1,string.len("grp")) == "grp"  then
			DynamicImageSetTexture( frameWindow.."Background", "TextureTypeFormation", 0, 0 )
		elseif string.sub(CoreAddon.Bars[Bar].state,1,string.len("MO")) == "MO"  then
			DynamicImageSetTexture( frameWindow.."Background", "TextureTypeMouseOver", 0, 0 )
		elseif string.sub(CoreAddon.Bars[Bar].state,1,string.len("PlayerPet")) == "PlayerPet"  then
			DynamicImageSetTexture( frameWindow.."Background", "TextureTypePet", 0, 0 )
		end

		-- : set labels
		LabelSetText(frameWindow.."LabelName", towstring(Bar))
		-- : set buttons
		ButtonSetText(frameWindow.."Templates", L"Templates")
		ButtonSetText(frameWindow.."Edit", L"Edit")
		ButtonSetText(frameWindow.."Delete", L"Delete")
		
		-- Final step: update its contents
		ScrollWindowUpdateScrollRect(theWindowSettings.."Frames")
	end
end


--------------------------------------------------------------
-- function 
-- Description: 
--------------------------------------------------------------

-- : hack, but no other way to do that at the moment
function Addon.ReopenComboBox()
	ComboBoxExternalOpenMenu(LastComboBoxName)
	WindowUnregisterEventHandler(LastComboBoxName, SystemData.Events.L_BUTTON_UP_PROCESSED)
end

function Addon.OnTemplateRow()
	Addon.EditBar = Addon.Bars[WindowGetId(WindowGetParent(SystemData.ActiveWindow.name))]
	Addon.TemplateBarSettings.Create()
end

function Addon.OnToggleRowSettings()
	Addon.EditBarPanel.Create(Addon.Bars[WindowGetId(WindowGetParent(SystemData.ActiveWindow.name))])
end

function Addon.OnDeleteRow()

	-- Second step: get Bar index
	local BarIndex = WindowGetId(WindowGetParent(SystemData.ActiveWindow.name))
	
	--CoreAddon.DestroyBar(Addon.Bars[BarIndex])
	Addon.ConditionalDeleteBar(Addon.Bars[BarIndex])
	
	Addon.EditBarPanel.Destroy()
	Addon.UpdateSettingsWindow()
end



--------------------------------------------------------------
-- function Main Config Buttons OnClick Handlers 
-- Description: 
--------------------------------------------------------------

function Addon.OnClickLayouts()
	if DoesWindowExist(Addon.Name.."SettingsWindowMisc") then
		Addon.Misc.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowSettings") then
		Addon.Settings.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."RulesWindowSettings") then
		Addon.Rules.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowCreateBarPopUp") then
		Addon.BarPanel.Destroy()
	end
	Addon.LayoutPanel.ShowModuleSettings()
end

function Addon.OnClickMisc()
	if DoesWindowExist(Addon.Name.."SettingsWindowLayoutPanel") then
		Addon.LayoutPanel.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowSettings") then
		Addon.Settings.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."RulesWindowSettings") then
		Addon.Rules.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowCreateBarPopUp") then
		Addon.BarPanel.Destroy()
	end
	Addon.Misc.ShowModuleSettings()
end

function Addon.OnClickStates()
	if DoesWindowExist(Addon.Name.."SettingsWindowLayoutPanel") then
		Addon.LayoutPanel.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowMisc") then
		Addon.Misc.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."RulesWindowSettings") then
		Addon.Rules.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowCreateBarPopUp") then
		Addon.BarPanel.Destroy()
	end
	Addon.Settings.ShowModuleSettings()
end

function Addon.OnClickRules()
	if DoesWindowExist(Addon.Name.."SettingsWindowLayoutPanel") then
		Addon.LayoutPanel.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowMisc") then
		Addon.Misc.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowSettings") then
		Addon.Settings.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowCreateBarPopUp") then
		Addon.BarPanel.Destroy()
	end
	--Addon.EditRulesPanel.Create()
	Addon.Rules.ShowModuleSettings()
end

function Addon.OnClickBars()
	if DoesWindowExist(Addon.Name.."SettingsWindowLayoutPanel") then
		Addon.LayoutPanel.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowMisc") then
		Addon.Misc.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowSettings") then
		Addon.Settings.HideModuleSettings()
	end
	if DoesWindowExist(Addon.Name.."RulesWindowSettings") then
		Addon.Rules.HideModuleSettings()
	end	
	Addon.BarPanel.Create()
end