if not Effigy then Effigy = {} end
local CoreAddon = Effigy
if not EffigyConfigGui then EffigyConfigGui = {} end
local Addon = EffigyConfigGui
if (nil == Addon.Name) then Addon.Name = "EffigyConfigGui" end

local LibGUI = LibStub("LibGUI")

Addon.Misc = {}
Addon.Misc.W = nil

local SettingsWindow = Addon.Name.."SettingsWindowMisc"
--------------------------------------------------------------
-- function InitializeSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.Misc.InitializeSettingsWindow(ParentWindow)
	local frameSizeW = 630
	local frameSizeH = 480
	--
	-- XML Part
	--
	-- First step: create window from template
	CreateWindowFromTemplate(SettingsWindow, Addon.Name.."PopupWindowTemplate","Root")
	WindowRegisterCoreEventHandler(SettingsWindow.."ButtonOK", "OnLButtonUp", Addon.Name..".Misc.OnClickCloseSettings")
	WindowRegisterCoreEventHandler(SettingsWindow.."ButtonClose", "OnLButtonUp", Addon.Name..".Misc.OnClickCloseSettings")
	WindowSetDimensions(SettingsWindow, frameSizeW, frameSizeH)
	LabelSetText(SettingsWindow.."TitleBarText", L"Misc")
	ButtonSetText(SettingsWindow.."ButtonOK", L"Close")
	
	--
	-- LibGUI Part
	--	
	local w = {}
	w = LibGUI("Window")
	w:Resize(frameSizeW - 10, frameSizeH - 100)
	w:AnchorTo(SettingsWindow, "top", "top", 0, 30)
	w:Parent(SettingsWindow)

	w.Fakes = Addon.GetFakesWindow()
	w.Fakes:AnchorTo(w, "top", "top", 0, 0)
	w.Fakes:Parent(w)
	
	w.ShowGroup = Addon.GetShowGroupWindow()
	w.ShowGroup:AnchorTo(w.Fakes, "bottom", "topright", -10, 10)
	w.ShowGroup:Parent(w)
	
	w.Castbar = Addon.GetCastbarWindow()
	w.Castbar:AnchorTo(w.Fakes, "bottom", "topleft", 10, 10)
	w.Castbar:Parent(w)
	
	if (nil ~= Addon.Misc.W) then
		Addon.Misc.Destroy()
	end


	Addon.Misc.W = w
	Addon.Misc.W:Show()
end

--------------------------------------------------------------
-- function ShowModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.Misc.ShowModuleSettings()--ModuleWindow)

	-- First step: check for window
	if not DoesWindowExist(SettingsWindow) then
		Addon.Misc.InitializeSettingsWindow("root")--ModuleWindow)
	end

	-- Second step: update fields with the current configuration 
	Addon.Misc.UpdateSettingsWindow()

	-- Final step: show everything
	WindowSetShowing(SettingsWindow, true)
end

--------------------------------------------------------------
-- function HideModuleSettings()
-- Description:
--------------------------------------------------------------
function Addon.Misc.HideModuleSettings()

	-- Final step: hide window
	WindowSetShowing(SettingsWindow, false)
end

function Addon.Misc.Destroy()
	Addon.Misc.W:Destroy()
end

--------------------------------------------------------------
-- function UpdateSettingsWindow()
-- Description:
--------------------------------------------------------------
function Addon.Misc.UpdateSettingsWindow()
--[[
	local isCombatCheckBox
	if 1 == CoreAddon.States["Combat"].curr then
		isCombatCheckBox = true
	else
		isCombatCheckBox = false
	end
	ButtonSetPressedFlag(SettingsWindow.."CheckBoxFakeCombat", isCombatCheckBox)
	]]--
end

--------------------------------------------------------------
-- CLICK HANDLERS
--------------------------------------------------------------

function Addon.Misc.OnClickCloseSettings()
	Addon.Misc.HideModuleSettings()
end

--------------------------------------------------------------
-- STUFF ;D
--------------------------------------------------------------
function Addon.GetFakesWindow()
	w = LibGUI("Frame")
	w:Resize(620, 160)
	--w:AnchorTo(SettingsWindow, "top", "top", 0, 30)
	--w:Parent(SettingsWindow)
	--[[
	w.bCloseButton = w("Closebutton")
	w.bCloseButton.OnLButtonUp =
	function()
		Addon.Misc.Destroy()
	end
	]]--
	--w:MakeMovable()
	
	w.Title = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.Title:Resize(250)
	w.Title:AnchorTo(w, "topleft", "topleft", 25, 20)
	w.Title:Font(Addon.FontHeadline)
	w.Title:SetText(L"Fake:")
	w.Title:Align("left")
	w.Title:IgnoreInput()
	
	-- Fake Party button
	w.FakePartyButton = w("Button", nil, Addon.ButtonInherits)
	w.FakePartyButton:Resize(Addon.ButtonWidth)
	w.FakePartyButton:SetText(L"Party")
	w.FakePartyButton:Position(25, 60)
	w.FakePartyButton.OnLButtonUp = function() CoreAddon.CreateFakeParty()  end
	w.FakePartyButton.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.FakePartyButton, "Creates a Party with random classes / HPs",
				"A New Party at the Click of a Button! (tm)") 
		end
		
	-- Fake Warband button
--[[	w.FakeWBButton = w("Button", nil, Addon.ButtonInherits)
	w.FakeWBButton:Resize(Addon.ButtonWidth)
	w.FakeWBButton:SetText(L"Warband")
	w.FakeWBButton:AnchorTo(w.FakePartyButton, "right", "left", 20, 0)
	w.FakeWBButton.OnLButtonUp = function() CoreAddon.CreateFakeWarband()  end
	w.FakeWBButton.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.FakeWBButton, "Creates a Warband with random classes / HPs",
				"A new Warband at the Click of a Button! (tm)") 
		end
		
	-- Fake Scenario button
	w.FakeSCButton = w("Button", nil, Addon.ButtonInherits)
	w.FakeSCButton:Resize(Addon.ButtonWidth)
	w.FakeSCButton:SetText(L"Scenario")
	w.FakeSCButton:AnchorTo(w.FakeWBButton, "right", "left", 20, 0)
	w.FakeSCButton.OnLButtonUp = function() CoreAddon.FakeSC()  end
	w.FakeSCButton.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.FakeSCButton, "Creates a Scenario Party with random classes / HPs",
				"A new Party at the Click of a Button! (tm)") 
		end
]]--


	-- Clear Fakes button
	w.ClearFakesButton = w("Button", nil, Addon.ButtonInherits)
	w.ClearFakesButton:Resize(Addon.ButtonWidth)
	w.ClearFakesButton:SetText(L"Clear Fakes")
	w.ClearFakesButton:AnchorTo(w, "bottomright", "bottomright", -20, -20)
	w.ClearFakesButton.OnLButtonUp = function() CoreAddon.FakeParty = false  end
	w.ClearFakesButton.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.ClearFakesButton, "Clear your fake parties",
					"Note: takes a sec")
		end
	w.ClearFakesButton.OnLButtonUp =
		function()
			CoreAddon.FakeParty = false
			for i=1,6 do
				CoreAddon.States["grp"..i.."hp"].valid = 0
				CoreAddon.States["grp"..i.."ap"].valid = 0
				CoreAddon.States["grp"..i.."morale"].valid = 0
		
				CoreAddon.States["grp"..i.."hp"]:renderElements()
				CoreAddon.States["grp"..i.."ap"]:renderElements()
				CoreAddon.States["grp"..i.."morale"]:renderElements()
			end
		end

	-- Fake Combat label
	w.FakeCombatLabel = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.FakeCombatLabel:Resize(100)
	w.FakeCombatLabel:AnchorTo(w.FakePartyButton, "right", "left", 0, 0)
	w.FakeCombatLabel:Align("leftcenter")
	w.FakeCombatLabel:SetText(L"In-Combat:")
	w.FakeCombatLabel.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.FakeCombatLabel, "Sets your in/out combat state",
				"Allows for testing bar combat alpha changes",
				"Tip: If your bar does not update as you expect make sure it is Watching the Combat State") 
		end

	w.FakeCombat = w("Checkbox")
	w.FakeCombat:AnchorTo(w.FakeCombatLabel, "right", "left", 0, 0)
	w.FakeCombat.OnLButtonUp =
		function()
			if (1 == CoreAddon.States["Combat"].curr) then
				CoreAddon.States["Combat"].curr = 0
			else
				CoreAddon.States["Combat"].curr = 1
			end

			CoreAddon.States["Combat"]:renderElements()
		end

	return w
end

function Addon.GetShowGroupWindow()
	local w = LibGUI("Frame")
	w:Resize(220,180)
	
	w.lShow = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShow:Position(10,10)
	w.lShow:Resize(300)
	w.lShow:Font(Addon.FontHeadline)
	w.lShow:SetText(L"Show:")
	w.lShow:Align("left")
	
	w.lShowGroup = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShowGroup:AnchorTo(w.lShow, "bottomleft", "topleft", 5, 15)
	w.lShowGroup:Resize(65)
	w.lShowGroup:Font(Addon.FontBold)
	w.lShowGroup:SetText(L"Group:")
	w.lShowGroup:Align("left")
	w.ckShowGroup = w("checkbox")
	w.ckShowGroup:AnchorTo(w.lShowGroup, "right", "left", 0, 0)
	w.ckShowGroup.OnLButtonUp =
		function()
			CoreAddon.SetShowGroup(false, w.ckShowGroup:GetValue())
		end
	local value = CoreAddon.GetShowGroup(false)
	w.ckShowGroup:SetEnabled(value ~= nil)
	w.ckShowGroup:SetValue(value or false) --worldobj

	w.lShowGroupInWB = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShowGroupInWB:AnchorTo(w.lShowGroup, "bottomleft", "topleft", 20, 10)
	w.lShowGroupInWB:Resize(110)
	w.lShowGroupInWB:Font(Addon.FontText)
	w.lShowGroupInWB:SetText(L"in Warband:")
	w.lShowGroupInWB:Align("left")
	w.ckShowGroupInWB = w("checkbox")
	w.ckShowGroupInWB:AnchorTo(w.lShowGroupInWB, "right", "left", 5, 0)
	w.ckShowGroupInWB.OnLButtonUp =
		function()
			CoreAddon.WindowSettings["SC"].showgroup = w.ckShowGroupInWB:GetValue()
		end
	w.ckShowGroupInWB:SetValue(CoreAddon.WindowSettings["WB"].showgroup)
	
	w.lShowGroupInSC = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShowGroupInSC:AnchorTo(w.lShowGroupInWB, "bottomleft", "topleft", 0, 10)
	w.lShowGroupInSC:Resize(110)
	w.lShowGroupInSC:Font(Addon.FontText)
	w.lShowGroupInSC:SetText(L"in Scenario:")
	w.lShowGroupInSC:Align("left")
	w.ckShowGroupInSC = w("checkbox")
	w.ckShowGroupInSC:AnchorTo(w.lShowGroupInSC, "right", "left", 5, 0)
	w.ckShowGroupInSC.OnLButtonUp =
		function()
			CoreAddon.WindowSettings["SC"].showgroup = w.ckShowGroupInSC:GetValue()
		end
	w.ckShowGroupInSC:SetValue(CoreAddon.WindowSettings["SC"].showgroup)
	
	w.lShowGroupWO = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.lShowGroupWO:AnchorTo(w.lShowGroupInSC, "bottomleft", "topleft", -10, 10)
	w.lShowGroupWO:Resize(125)
	w.lShowGroupWO:Font(Addon.FontText)
	w.lShowGroupWO:SetText(L"WorldObjects:")
	w.lShowGroupWO:Align("left")
	w.ckShowGroupWO = w("checkbox")
	w.ckShowGroupWO:AnchorTo(w.lShowGroupWO, "right", "left", 5, 0)
	w.ckShowGroupWO.OnLButtonUp =
		function()
			CoreAddon.SetShowGroup(true, w.ckShowGroupWO:GetValue())
		end
	value = CoreAddon.GetShowGroup(true)
	w.ckShowGroupWO:SetEnabled(value ~= nil)
	w.ckShowGroupWO:SetValue(value or false) --worldobj
	
	return w
end

function Addon.GetCastbarWindow()
	local w = LibGUI("frame")
	w:Resize(220,180)
	
	w.l1 = w("Label", nil, "EffigyAutoresizeLabelTemplate")
	w.l1:Resize(175)
	w.l1:AnchorTo(w, "topleft", "topleft", 10, 10)
	w.l1:Font(Addon.FontHeadline)
	w.l1:SetText(L"Castbar")
	w.l1:Align("left")


	w.l11 = w("Label", nil ,"EffigyAutoresizeLabelTemplate")
	--w.l11:Resize(140)
	w.l11:AnchorTo(w.l1, "bottomleft", "topleft", 10, 15)
	w.l11:Font(Addon.FontText)
	w.l11:SetText(L"Show GCD:")
	w.l11:Align("left")
	w.l11.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.l11, "Show GCD when using instant spells.")
		end

	w.k9 = w("Checkbox")
	w.k9:AnchorTo(w.l11, "right", "left", 5, 0)
	w.k9.OnLButtonUp =
		function()
			CoreAddon.ProfileSettings.CastbarShowGCD = w.k9:GetValue()
		end
	if (nil ~= CoreAddon.ProfileSettings.CastbarShowGCD)and
		 (true == CoreAddon.ProfileSettings.CastbarShowGCD) then
		w.k9:Check()
	end

	w.lCastbarHRS = w("Label", nil ,"EffigyAutoresizeLabelTemplate")
	--w.lCastbarHRS:Resize(140)
	w.lCastbarHRS:AnchorTo(w.l11, "bottomleft", "topleft", 0, 15)
	w.lCastbarHRS:Font(Addon.FontText)
	w.lCastbarHRS:SetText(L"Show Respawn:")
	w.lCastbarHRS:Align("left")
	w.lCastbarHRS.OnMouseOver = 
		function() 
			Addon.SetToolTip(w.lCastbarHRS, "Show the respawn timer at the castbar instead of its own window.")
		end

	w.kCastbarHRS = w("Checkbox")
	w.kCastbarHRS:AnchorTo(w.lCastbarHRS, "right", "left", 5, 0)
	w.kCastbarHRS.OnLButtonUp =
		function()
			CoreAddon.ProfileSettings.CastbarHookRespawn = w.kCastbarHRS:GetValue()
		end
	if (nil ~= CoreAddon.ProfileSettings.CastbarHookRespawn)and
		 (true == CoreAddon.ProfileSettings.CastbarHookRespawn) then
		w.kCastbarHRS:Check()
	end
		
	return w
end
