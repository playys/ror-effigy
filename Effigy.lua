-- forked of HudUnitFrames: http://war.curseforge.com/addons/huduf/
-- Credits @Avatar of Metaphaze & Tannecurse
--
-- Effigy base code
-- vim: sw=2 ts=2
if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end
Addon.ProfileSettings = {}
local firstload

local SendChatText = SendChatText
function string.startsWith(String, Start)
	return string.sub(String, 1, string.len(Start))==Start
end

function string.endsWith(String, End)
	return End=='' or string.sub(String, -string.len(End))==End
end

local function GetMacroId(aWString)
	local macros = DataUtils.GetMacros()
	for slot = 1, EA_Window_Macro.NUM_MACROS do
		if macros[slot].name == aWString or macros[slot].text == aWString then return slot end
	end
	return nil
end

local function CreateMacro(name, text, iconId)
	local slot = GetMacroId (text)
	if (slot) then return slot end
	local macros = DataUtils.GetMacros ()
	for slot = 1, EA_Window_Macro.NUM_MACROS do
		if (macros[slot].text == L"") then
			SetMacroData (name, text, iconId, slot)
 			EA_Window_Macro.UpdateMacros ()
			return slot
		end
	end
	return nil
end

local unitframeMacroName = L"AssistUnitframe"
local unitframeMacroId = -1

--Addon.FirstRunv1 = true
--Addon.FirstRunv2 = true

Addon.BarTemplates = {}

function Addon.Print(args)
	if args == nil then 
		args = "nil"
	elseif type(args) == "boolean" then 
		args = args and L"true" or L"false"
	elseif type(args) == "wstring" then
		args = WStringToString(args)
	end
	
	--[[
	if type(args) == "table" then 
		for _,v in ipairs(args) do
			if v == nil then v = "nil"
			elseif type(v) == "boolean" then 
				v = v and L"true" or L"false"
			end		
		end
		local outString = L""
		for _,v in ipairs(argTable) do
		--string append
		end
	
	end
	]]--
	
	--v = towstring(v)
	EA_ChatWindow.Print(towstring(Addon.Name)..L": "..towstring(args))
end


-- From the lua wiki: http://lua-users.org/wiki/CopyTable
function Addon.deepcopy(object)
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

--[[function Addon.FixAlpha(b)
	local idp = 2	
	local mult = 10^idp
    b.bg.alpha.in_combat = math.floor( b.bg.alpha.in_combat * mult + 0.5) / mult
	b.bg.alpha.out_of_combat = math.floor( b.bg.alpha.out_of_combat * mult + 0.5) / mult

	b.alpha.in_combat  = math.floor( b.alpha.in_combat * mult + 0.5) / mult
	b.alpha.out_of_combat  = math.floor( b.alpha.out_of_combat * mult + 0.5) / mult
	b.alpha.clamp  = math.floor( b.alpha.clamp * mult + 0.5) / mult
end]]--

function Addon.Initialize()
	DEBUG(L"Initialization...")

	if (nil == Addon.SavedLayouts) then	Addon.SavedLayouts = {}	end
	
	DEBUG(L"Initialization...Migrating")
	
	Addon.UpdateVersion()
	
	--missingmembers check is redundant will be done later again
	if nil ~= Addon.Bars then
		for _,b in pairs(Addon.Bars) do
			Addon.CheckForMissingMembers(b)
			--Addon.FixAlpha(b)
		end
	end

	DEBUG(L"Initialization...Migration Done")
	
	-- no sc/wb frames for now
	--[[if (nil == Addon.Bars.SCTemplate) then
		Addon.Bars.SCTemplate = Addon.deepcopy(Effigy.SCTemplate)
	end
	if (nil == Addon.Bars.WBTemplate) then
		Addon.Bars.WBTemplate = Addon.deepcopy(Effigy.WBTemplate)
	end]]--

	if (not Addon.WindowSettings) then
		--Addon.CreateWindowSettings("WB")
		--Addon.CreateWindowSettings("SC")
		Addon.WindowSettings = {}
		if (not Addon.WindowSettings.WB) then
			Addon.WindowSettings.WB = 
				{
					showgroup = true,
					disabled = false,
					--Template = "WBTemplate",
				}
		end
		if (not Addon.WindowSettings.SC) then
			Addon.WindowSettings.SC = {
					showgroup = true,
					disabled = false,
					--Template = "SCTemplate",
				}
		end
	end
	
	Addon.InitializeRules()
	
	RegisterEventHandler(SystemData.Events.ALL_MODULES_INITIALIZED, Addon.Name..".OnAllModulesInitialized")
	RegisterEventHandler(SystemData.Events.LOADING_END, Addon.Name..".OnLoad")	
  	RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, Addon.Name..".OnLoad")
	--RegisterEventHandler(SystemData.Events.PLAYER_ZONE_CHANGED, Addon.Name..".OnLoad")

	-- Need to know when the User changes things in the layout editor
	--table.insert(LayoutEditor.EventHandlers, Addon.LayoutEditorDone)
	LayoutEditor.RegisterEditCallback( Addon.LayoutEditorDone )
	
	Addon.RegisterForStateInfo()
	Addon.RegisterSlashCommands()
	--EffigyBuffs.RegisterEvents()
	
	if ( not GetMacroId(unitframeMacroName) ) then
		CreateMacro(unitframeMacroName, L"/assist ", 177)
	end
	unitframeMacroId = GetMacroId(unitframeMacroName)

	firstload = true
	Addon.isInitialized = true
	DEBUG(L"Initialization...Done")
end

function Addon.OnAllModulesInitialized()
	DEBUG(L"UnitFrames OnAllModulesInitialized...")
	
	--RegisterEventHandler(SystemData.Events.PLAYER_ZONE_CHANGED, Addon.Name..".OnLoad")
	-- Need to know when the User changes things in the layout editor
	--table.insert(LayoutEditor.EventHandlers, Addon.LayoutEditorDone)
	
end

function Addon.OnLoad()
	if firstload then
		DEBUG(L"OnLoad (First)...")
		
		Addon.TextureManager.BuildTextureList()
		-- this needs a kick starter?
		Addon.UpdateTitle()
		
		-- Init all the bars, get them created etc
		for _,b in pairs(Addon.Bars) do
			--Addon.CheckForMissingMembers(b)
			EffigyBar.Init(b.name)
		end
		
		for _,b in pairs(Addon.Bars) do
			b:setup()
		end
		for _,s in pairs(Addon.States) do
			s:update()
		end
		-- Draw them to the screen
		for _,b in pairs(Addon.Bars) do
			b:setup()
			b:render()
		end
		
		Addon.FakeParty = false
		firstload = false
		Addon.isLoaded = true
	else
		DEBUG(L"OnLoad...")
	end
end

function Addon.LoadLayout(layout)
	local layout_table = UFTemplates.Layouts[layout]
	if (nil == layout_table) then
		layout_table = Addon.SavedLayouts[layout]
	end
	if (nil == layout_table) then
		Addon.Print(L"Error, layout "..towstring(layout)..L" doesn't exist")
		return
	end
	
	if Addon.isLoaded then
		for _,v in pairs(Addon.Bars) do
			v:destroy()
		end
		for _,v in pairs(Addon.States) do
			if (v.bars) then v.bars = {} end
		end
		for name, bar in pairs(layout_table) do
			Addon.CreateBar(name, bar)
		end
	else
		Addon.Bars = Addon.deepcopy(layout_table)
	end
	
	-- Yak temp injector
	if layout == "YakUI_140" and not Vectors then
		local scalemath = math.floor((InterfaceCore.GetScale()/InterfaceCore.GetResolutionScale()) *100 + 0.5) * 0.01
		local resolution = towstring(SystemData.screenResolution.x)..L"x"..towstring(SystemData.screenResolution.y)
		if scalemath == 0.75 then scalemath = L"0.75"
		elseif scalemath == 1 then scalemath = L"1.00"
		else
			scalemath = wstring.format( L"%0.2f", towstring(scalemath) )
		end
		Addon.ApplyResoToYakUI(resolution, scalemath)
	end
	-- /Yak temp injector
	
	--Addon.OnLoad()
	-- Draw them to the screen
	if Addon.isLoaded then
		for _,b in pairs(Addon.Bars) do
			b:setup()
			b:render()
		end
	end
	--InterfaceCore.ReloadUI()
end

function Addon.SaveLayout(layout)
	Addon.SavedLayouts[layout] = Addon.deepcopy(Addon.Bars)
	EA_ChatWindow.Print(L"Saved current layout to "..towstring(layout))
end

function Addon.LayoutEditorDone(event)
	-- Grab the Users settings (show vs. hide) for each bar from
	-- the layout editor
	if (LayoutEditor.EDITING_END ~= event) then return end
	--DEBUG(L"LayoutEditor Done")
	--d(LayoutEditor.windowsList)
	local VectorsTable = (Vectors and Vectors.GetWindows()) or {}
	for _,v in pairs(Addon.Bars) do
		if (false == v.block_layout_editor) and (false == v.pos_at_world_object) and ( LayoutEditor.windowsList[ v.name] ~= nil ) and (UF_RUNTIMECACHE[v.name] and UF_RUNTIMECACHE[v.name].initialized) then	-- check for LayoutEditor for Vectors Addon
			v.show = not LayoutEditor.IsWindowHidden(v.name)
			local dimx, dimy = WindowGetDimensions(v.name)
			local point, parentpoint, parent, x, y = WindowGetAnchor(v.name, 1)
			
			v.width = math.floor(dimx + 0.5)
			v.height = math.floor(dimy + 0.5)
			v.anchors[1].point  = parentpoint	-- switch
			v.anchors[1].parentpoint = point	-- eroo?
			v.anchors[1].parent = parent
			v.anchors[1].x = math.floor(x + 0.5)
			v.anchors[1].y = math.floor(y + 0.5)
			v.scale = WindowGetScale(v.name)
			
			if (nil ~= Addon.States[v.state]) then
				Addon.States[v.state]:update()
			end
			v:setup()
			--v:render()
		elseif VectorsTable[v.name] then
			local runtimeCache = UF_RUNTIMECACHE[v.name]
			if (runtimeCache) and (runtimeCache.initialized) then
				for _,ioloi in ipairs({runtimeCache.Images, runtimeCache.Labels, runtimeCache.Icons}) do
					for _,element in pairs(ioloi) do
						element:Setup()
					end
				end
			end
		end
	end
	for _,v in pairs(Addon.Bars) do
		if (UF_RUNTIMECACHE[v.name]) and (UF_RUNTIMECACHE[v.name].initialized) then --(v.block_layout_editor) and (false == v.pos_at_world_object) and
			if (nil ~= Addon.States[v.state]) then
				Addon.States[v.state]:update()
			end
			--v:setup()
			v:render()
		end
	end
end


--
-- Mouse Events
--
---------------------------------------------------------------------------------------------------------------------

local GetDesiredInteractAction = GetDesiredInteractAction
local WindowSetGameActionData = WindowSetGameActionData
function Addon.LButtonDown(flags, x, y)
	local barname = SystemData.ActiveWindow.name
	local bar = Addon.Bars[barname]
	if (nil == bar) then return end
	
	if ("player" == bar.interactive_type) then
		-- This is handled by SetGameAction
	elseif ("friendly" == bar.interactive_type) then
		if not (flags == SystemData.ButtonFlags.SHIFT or flags == SystemData.ButtonFlags.CONTROL or flags == SystemData.ButtonFlags.ALT) then return end
		SetMacroData (unitframeMacroName, L"/assist "..EffigyState:GetState(bar.state):GetTitle(), 177, unitframeMacroId)
		WindowSetGameActionData(barname, GameData.PlayerActions.DO_MACRO, unitframeMacroId, L"")
		--WindowSetGameActionData(barname,GameData.PlayerActions.ASSIST_PLAYER,0,EffigyState:GetState(bar.state):GetTitle())
	elseif ("group" == bar.interactive_type) or ("formation" == bar.interactive_type) then
		-- This is handled by SetGameAction
		if( GetDesiredInteractAction() == SystemData.InteractActions.TELEPORT ) then
            UseItemTargeting.SendTeleport()
        end
		if not (flags == SystemData.ButtonFlags.SHIFT or flags == SystemData.ButtonFlags.CONTROL or flags == SystemData.ButtonFlags.ALT) then return end
		--WindowSetGameActionData(barname,GameData.PlayerActions.ASSIST_PLAYER,0,EffigyState:GetState(bar.state):GetTitle())
		SetMacroData (unitframeMacroName, L"/assist "..EffigyState:GetState(bar.state):GetTitle(), 177, unitframeMacroId)
		WindowSetGameActionData(barname, GameData.PlayerActions.DO_MACRO, unitframeMacroId, L"")
	elseif bar.state == "PlayerPetHP" then
		BroadcastEvent( SystemData.Events.TARGET_PET )
	elseif bar.state == "grpCH1hp" or bar.state == "grpCH2hp" or bar.state == "grpCH3hp" or bar.state == "grpCH4hp" or bar.state == "grpCH5hp" or bar.state == "grpCH6hp" then
		SendChatText(L"/target "..EffigyState:GetState(bar.state):GetTitle(), L"")
	end
end

function Addon.LButtonUp(flags, x, y)
	--if not (flags == SystemData.ButtonFlags.SHIFT or flags == SystemData.ButtonFlags.CONTROL or flags == SystemData.ButtonFlags.ALT) then return end
	local barname = SystemData.ActiveWindow.name
	local bar = Addon.Bars[barname]
	if (nil == bar) then return end

	if not ("friendly" == bar.interactive_type or "group" == bar.interactive_type or "formation" == bar.interactive_type) then return end
	WindowSetGameActionData(barname, GameData.PlayerActions.SET_TARGET, 0, EffigyState:GetState(bar.state):GetTitle())		
end

local function OnMenuClickFlagRvR() SendChatText(L"/pvp", L"") end	-- same as unflag
local function OnMenuClickLeaveGroup() BroadcastEvent(SystemData.Events.GROUP_LEAVE) end
local function OnMenuClickLeaveScenarioGroup() ScenarioGroupWindow.LeaveGroup() end
--local function ToggleCustomizeUI() WindowUtils.ToggleShowing("CustomizeUiWindow") end
local function PlayerRightClickMenu()

	EA_Window_ContextMenu.CreateContextMenu("EffigyPlayerInfo")

	--if (false == GameData.Player.rvrPermaFlagged) then
	if (true == GameData.Player.rvrPermaFlagged) then
			EA_Window_ContextMenu.AddMenuItem(
					GetStringFromTable("HUDStrings", StringTables.HUD.LABEL_UNFLAG_PLAYER_RVR), 
					OnMenuClickFlagRvR, 
					GameData.Player.rvrZoneFlagged, 
					true)
	else
			EA_Window_ContextMenu.AddMenuItem(
					GetStringFromTable("HUDStrings", StringTables.HUD.LABEL_FLAG_PLAYER_RVR), 
					OnMenuClickFlagRvR, 
					GameData.Player.rvrZoneFlagged or GameData.Player.rvrPermaFlagged, 
					true)
	end
	--end


			EA_Window_ContextMenu.AddMenuItem(
			L"Show Open Party Window",
			EA_Window_OpenParty.ToggleFullWindow,
			WindowGetShowing("EA_Window_OpenParty"),
			true)

			
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Abilities Window",
			AbilitiesWindow.ToggleShowing,
			WindowGetShowing("AbilitiesWindow"),
			true)
			
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Backpack Window",
			EA_Window_Backpack.ToggleShowing,
			WindowGetShowing("EA_Window_Backpack"),
			true)
			
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Character Window",
			CharacterWindow.ToggleShowing,
			WindowGetShowing("CharacterWindow"),
			true)
			
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Tome Of Knowledge",
			TomeWindow.ToggleShowing,
			WindowGetShowing("TomeWindow"),
			true)
			
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Main Menu",
			MainMenuWindow.ToggleShowing,
			WindowGetShowing("MainMenuWindow"),
			true)
									
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Guild Window",
			GuildWindow.ToggleShowing,
			WindowGetShowing("GuildWindow"),
			true)
			
			EA_Window_ContextMenu.AddMenuItem(
			L"-- Help!",
			EA_Window_Help.ToggleShowing,
			WindowGetShowing("EA_Window_Help"),
			true)

	
-- Add some new menu items to replace the Menu Bar so we can hide that

	-- Show the "Leave Party" option if the player is currently in a player-made party
	if(GroupWindow.inWorldGroup) then
		EA_Window_ContextMenu.AddMenuItem(
				GetStringFromTable("HUDStrings", StringTables.HUD.LABEL_LEAVE_GROUP), 
				OnMenuClickLeaveGroup, 
				false, 
				true)        
	end

	-- Show the "Leave Scenario Party" option if the player is in a scenario party
	--if(GroupWindow.inScenarioGroup) then
	if(GameData.Player.isInScenarioGroup) then
		EA_Window_ContextMenu.AddMenuItem(
				GetStringFromTable("HUDStrings", StringTables.HUD.LABEL_LEAVE_SCENARIO_GROUP),
				OnMenuClickLeaveScenarioGroup, 
				false, 
				true)        
	end

	EA_Window_ContextMenu.Finalize()
end

local function FriendlyRightClickMenu()	-- Hook into the normal right click on people menu
	if(TargetInfo:UnitEntityId("selffriendlytarget") ~= 0 
		and TargetInfo:UnitType("selffriendlytarget") == SystemData.TargetObjectType.ALLY_PLAYER  )
	then
			PlayerMenuWindow.ShowMenu( 
				TargetInfo:UnitName("selffriendlytarget"), 
				TargetInfo:UnitEntityId("selffriendlytarget"), 
				nil )
	end
end

-- ToDo:
--[[local function FormationRightClickMenu()

    EA_Window_ContextMenu.CreateContextMenu( SystemData.ActiveWindow.name )
    
    -- If the local player is main assist, give the option to re-assign it
    if( LocalPlayerIsMainAssist ) then
        local member = GetMemberFromWindowId( WindowGetId( SystemData.ActiveWindow.name ) )
        SystemData.UserInput.selectedGroupMember = member.name
        local disableMainAssist = ( WStringsCompareIgnoreGrammer( member.name, GameData.Player.name ) == 0 )
        EA_Window_ContextMenu.AddMenuItem( GetString( StringTables.Default.LABEL_MAKE_MAIN_ASSIST ), BattlegroupHUD.OnMenuClickMakeMainAssist, disableMainAssist, true )
    end

    EA_Window_ContextMenu.Finalize()
end]]--

function Addon.RButtonUp()
	local barname = SystemData.ActiveWindow.name
	local bar = Addon.Bars[barname]
	if (nil == bar) then return end

	if ("player" == bar.interactive_type) then
		PlayerRightClickMenu()
	elseif ("friendly" == bar.interactive_type) then
		FriendlyRightClickMenu()
	elseif ("group" == bar.interactive_type) then
		local state = Addon.States[bar.state]
		if (nil == state) then return end
		local member_name = state.word
		if (nil ~= member_name) then
			GroupWindow.ShowMenu(member_name) --Show the default menu
		end
	end
end

local function PlayerMouseOver() end
local function FriendlyMouseOver() end

local function GroupMouseOver(bar)
	local state = Addon.States[bar.state]
	if (nil == state) then return end

	local level_class = GetStringFormat(StringTables.Default.RANK_X_Y, { state.level, state.careerName })
	local actiontext = GetString(StringTables.Default.TEXT_R_CLICK_TO_OPEN_GROUP_MENU)
	local m_name = state.word
	if (nil == m_name) then m_name = L"" end
	
	Tooltips.CreateTextOnlyTooltip(bar.name)
	Tooltips.SetTooltipText(1, 1, m_name)
	Tooltips.SetTooltipText(2, 1, level_class)
	Tooltips.SetTooltipColorDef(1, 1, Tooltips.COLOR_HEADING )
	if ((nil ~= state.inSameRegion)and(false == state.inSameRegion)) then
		Tooltips.SetTooltipText(3, 1, towstring("This player is far away"))
	end
            
	Tooltips.SetTooltipActionText(actiontext)

	Tooltips.Finalize()
	local anchor = { 
					Point = "topleft",  
					RelativeTo = bar.name, 
					RelativePoint = "topleft",   
					XOffset = -5, YOffset = -5 }

	Tooltips.AnchorTooltip(anchor)
end

local function GenericMouseOver(bar)
	local state = Addon.States[bar.state]
	if (nil == state) then return end


	local m_name = state.word
	if (nil == m_name) then m_name = towstring(bar.name) end

	local values = L""..state.curr..L" / "..state.max
	
	Tooltips.CreateTextOnlyTooltip(bar.name)
	Tooltips.SetTooltipText(1, 1, towstring(bar.name))
	Tooltips.SetTooltipText(2, 1, m_name)
	Tooltips.SetTooltipText(3, 1, values)
	Tooltips.SetTooltipColorDef(1, 1, Tooltips.COLOR_HEADING )
            

	Tooltips.Finalize()
	local anchor = { 
					Point = "topleft",  
					RelativeTo = bar.name, 
					RelativePoint = "topleft",   
					XOffset = -5, YOffset = -5 }

	Tooltips.AnchorTooltip(anchor)
end

function Addon.MouseOver()
	local barname = SystemData.ActiveWindow.name
	local bar = Addon.Bars[barname]
	if (nil == bar) or bar.no_tooltip then return end
	
	if "state" == bar.interactive_type then
		if bar.state == "Exp" then
			Addon.MouseoverXPBar()
		elseif bar.state == "PlayerRenown" then
			Addon.MouseoverRPBar()
		end
	elseif ("player" == bar.interactive_type) then
		PlayerMouseOver()
	elseif ("friendly" == bar.interactive_type) then
		FriendlyMouseOver()
	elseif ("group" == bar.interactive_type) then
		GroupMouseOver(bar)
	else
		GenericMouseOver(bar)
	end
end

--
-- Fakes
--

function Addon.CreateFakeParty()
	Addon.Print("Creating Fake Party!")
	local careers ={
		{GameData.CareerLine.IRON_BREAKER, GameData.CareerLine.SWORDMASTER, GameData.CareerLine.SLAYER, GameData.CareerLine.ARCHMAGE, GameData.CareerLine.SEER, GameData.CareerLine.WARRIOR_PRIEST, GameData.CareerLine.RUNE_PRIEST, GameData.CareerLine.ENGINEER, GameData.CareerLine.SHADOW_WARRIOR, GameData.CareerLine.BRIGHT_WIZARD, GameData.CareerLine.KNIGHT, GameData.CareerLine.WITCH_HUNTER},
		{GameData.CareerLine.CHOSEN, GameData.CareerLine.BLACK_ORC, GameData.CareerLine.WARRIOR, GameData.CareerLine.CHOPPA, GameData.CareerLine.SQUIG_HERDER, GameData.CareerLine.SORCERER, GameData.CareerLine.MAGUS, GameData.CareerLine.SHAMAN, GameData.CareerLine.ZEALOT, GameData.CareerLine.ASSASSIN, GameData.CareerLine.BLOOD_PRIEST, GameData.CareerLine.SHADE}
	}
	Addon.FakeParty = true
	local groupleader = math.random(5) + 1
	Addon.States["grp"..(groupleader).."hp"]:SetExtraInfo("isGroupLeader", true)
	for i = 2, 6 do
		if i ~= groupleader then
			Addon.States["grp"..(i).."hp"]:SetExtraInfo("isGroupLeader", false)
		end
	end
	for i=1,6 do
		Addon.States["grp"..i.."morale"].curr = math.random(1,4)
		Addon.States["grp"..i.."morale"].max = 4
		Addon.States["grp"..i.."ap"].curr = math.random(100)
		Addon.States["grp"..i.."ap"].max = 100
		Addon.States["grp"..i.."hp"].curr = math.random(100)
		Addon.States["grp"..i.."hp"].max = 100
		Addon.States["grp"..i.."hp"].word = i..L" Party Member"
		Addon.States["grp"..i.."hp"].extra_info.career = careers[GameData.Player.realm][math.random(1,12)]
		Addon.States["grp"..i.."hp"].level = math.random(40)
		Addon.States["grp"..i.."hp"].careerName = "TestCareer"
		if (math.random(50) < 25) then
			Addon.States["grp"..i.."hp"].rvr_flagged = true
		else
			Addon.States["grp"..i.."hp"].rvr_flagged = false
		end
		if (math.random(50) < 25) then
			Addon.States["grp"..i.."hp"].extra_info.isInSameRegion = true
		else
			Addon.States["grp"..i.."hp"].extra_info.isInSameRegion = false
		end
		Addon.States["grp"..i.."hp"].valid = 1
		Addon.States["grp"..i.."ap"].valid = 1
		Addon.States["grp"..i.."morale"].valid = 1

		Addon.States["grp"..i.."hp"]:renderElements()
		Addon.States["grp"..i.."ap"]:renderElements()
		Addon.States["grp"..i.."morale"]:renderElements()
	end
end

function Addon.CreateFakeWarband()
	Addon.Print("Creating Fake Warband!")
	Addon.FakeWB = true
	for groupIndex = 1,5 do
		for memberIndex = 1,6 do
			Addon.States["formation"..groupIndex..memberIndex.."hp"].curr = math.random(100)
			Addon.States["formation"..groupIndex..memberIndex.."hp"].max = 100
			Addon.States["formation"..groupIndex..memberIndex.."hp"].word = L"Party Member "..groupIndex..memberIndex
			Addon.States["formation"..groupIndex..memberIndex.."hp"].career = math.random(1,10)
			Addon.States["formation"..groupIndex..memberIndex.."hp"].level = math.random(40)
			Addon.States["formation"..groupIndex..memberIndex.."hp"].careerName = "TestCareer"
			if (math.random(50) < 25) then
				Addon.States["formation"..groupIndex..memberIndex.."hp"].rvr_flagged = true
			else
				Addon.States["formation"..groupIndex..memberIndex.."hp"].rvr_flagged = false
			end
			if (math.random(50) < 25) then
				Addon.States["formation"..groupIndex..memberIndex.."hp"].extra_info.isInSameRegion = true
			else
				Addon.States["formation"..groupIndex..memberIndex.."hp"].extra_info.isInSameRegion = false
			end
			Addon.States["formation"..groupIndex..memberIndex.."hp"].extra_info.group = groupIndex
			Addon.States["formation"..groupIndex..memberIndex.."hp"].valid = 1
			Addon.States["formation"..groupIndex..memberIndex.."hp"]:renderElements()
		end
	end
end

function Addon.DiffBars(sourceBar, target)
	local test = deepcopy(sourceBar)
	local function compare(source, target)
		for k, v in pairs(source) do
			if type(v) == "table" then
				if next(v) ~= nil and target[k] ~= nil then
					compare(v, target[k])
				end
			else
				if target[k] ~= nil and v == target[k] then
					source[k] = nil
				end
			end
		end
		return source
	end
	return compare(test, target)
end

-- Effigy.DiffLayout("1440_900_1")
function Addon.DiffLayout(layoutname)
	local sourceTable = Addon.TestBars[layoutname]
	local targetTable = UFTemplates.Layouts.YakUI_135
	--local diffTable = {}
	d("Comparing "..layoutname.." with YakUI")
	-- pre comparison cleanup
	sourceTable.InfoPanel.fg = nil
	sourceTable.PlayerAP.fg.colorsettings.allow_overrides = false
	sourceTable.FriendlyTarget.images.Foreground.scale = nil
	sourceTable.FriendlyTarget.images.Background.scale = nil
	sourceTable.HostileTarget.images.Foreground.scale = nil
	sourceTable.HostileTarget.images.Background.scale = nil
	sourceTable.PlayerHP.images.Foreground.scale = nil
	sourceTable.PlayerHP.images.Background.scale = nil
	sourceTable.Pet.images.Foreground.scale = nil
	sourceTable.Pet.images.Background.scale = nil
	sourceTable.Castbar.border.texture.name = nil
	sourceTable.Castbar.fg.colorsettings.allow_overrides = nil
	sourceTable.Castbar.fg.alpha.clamp = nil
	for i = 1,5 do
		if sourceTable["GroupMember"..i] then
			sourceTable["GroupMember"..i].images.Foreground.scale = nil
			sourceTable["GroupMember"..i].images.Background.scale = nil
		end
	end
	for bar, bartable in pairs(sourceTable) do
		for k, v in pairs(bartable) do
			if k == "status_icon" or k == "rvr_icon" then
				bartable[k] = nil
			end
		end
		if bartable.icon and bartable.icon.texture then
			bartable.icon.texture = nil
		end
		if bartable.labels.ReownRank then
			bartable.labels.ReknownRank = Addon.deepcopy(bartable.labels.ReownRank)
			bartable.labels.ReownRank = nil
		end
		if bartable.bg.alpha.in_combat == 0 and bartable.bg.alpha.out_of_combat == 0 then
			bartable.bg = nil
		end
	end
	
	local function compare(source, target)
		for k, v in pairs(source) do
			if type(v) == "table" then
				--if k == "Foreground" or k == "Background" or k == "CBEnd" then
					source[k].follow_bg_alpha = nil
				--end
				if next(v) ~= nil and target[k] ~= nil then
					--diffTable[k] = {}
					compare(v, target[k])
				end
			else
				if k == "name" then
					if v == "SharedMediaYSet5UFBar" then
						v = "LiquidBar"
					elseif v == "SharedMediaYSet5CBBar" then
						v = "LiquidCBBar"
					elseif v == "SharedMediaYSet5CBBarEnd" then
						v = "LiquidCBBarEnd"
					elseif v == "SharedMediaYSet5CBBG" then
						v = "LiquidCBBG"
					elseif v == "SharedMediaYSet5CBFX" then
						v = "LiquidCBFX"
					elseif v == "SharedMediaYSet5IPBG" then
						v = "LiquidIPBG"
					elseif v == "SharedMediaYSet5IPFX" then
						v = "LiquidIPFX"						
					elseif v == "SharedMediaYSet5UFBG" then
						v = "LiquidUFBG"
					elseif v == "SharedMediaYSet5UFFX" then
						v = "LiquidUFFX"
					end
				end
				if target[k] ~= nil and v == target[k] then
					source[k] = nil
				end
			end
		end
		return source
	end
	return compare(sourceTable, targetTable)
end

function Addon.SetShowGroup(worldObj, onoff)
	for barName, settings in pairs(Addon.Bars) do
		if settings.state == "grp1hp" or settings.state == "grp2hp" or settings.state == "grp3hp" or settings.state == "grp4hp" or settings.state == "grp5hp" or settings.state == "grp6hp" then
			if worldObj == settings.pos_at_world_object then
				settings.show = onoff or not settings.show
				Addon.Bars[barName]:setup()
				Addon.Bars[barName]:render()
			end
		end
	end
end

function Addon.GetShowGroup(worldObj)
	for _, settings in pairs(Addon.Bars) do
		if settings.state == "grp2hp" and worldObj == settings.pos_at_world_object then	-- let us assume no one is gonna showing/hiding group bars partly
			return settings.show
		end
	end
	return nil
end