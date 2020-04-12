if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

local playersRawName = nil
local function GetPlayersRawName()
	if (playersRawName == nil) then
	    playersRawName = L""..GameData.Player.name
	end
	return playersRawName
end

local playersName = nil
local function GetPlayersName()
	if (playersName == nil) then
	    playersName = GetPlayersRawName():match(L"([^^]+)^?([^^]*)")
	end
	return playersName
end

--[[
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_CUR_ACTION_POINTS_UPDATED, "PlayerWindow.UpdateCurrentActionPoints")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_MAX_ACTION_POINTS_UPDATED, "PlayerWindow.UpdateMaximumActionPoints")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_CUR_HIT_POINTS_UPDATED,    "PlayerWindow.UpdateCurrentHitPoints")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_MAX_HIT_POINTS_UPDATED,    "PlayerWindow.UpdateMaximumHitPoints")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_START_RVR_FLAG_TIMER,      "PlayerWindow.OnStartRvRFlagTimer")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_RVR_FLAG_UPDATED,          "PlayerWindow.OnRvRFlagUpdated")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_CAREER_RANK_UPDATED,       "PlayerWindow.UpdateCareerRank")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_CAREER_CATEGORY_UPDATED,   "PlayerWindow.UpdateAdvancementNag" )
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_MORALE_UPDATED,            "PlayerWindow.OnMoraleUpdated")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_AGRO_MODE_UPDATED,         "PlayerWindow.OnAgroModeUpdated")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_KILLING_SPREE_UPDATED,     "PlayerWindow.KillingSpreeUpdated")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_GROUP_LEADER_STATUS_UPDATED, "PlayerWindow.UpdateCrown")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.GROUP_UPDATED,                    "PlayerWindow.UpdateCrown")
    WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_MAIN_ASSIST_UPDATED,		"PlayerWindow.UpdateMainAssist")
	WindowRegisterEventHandler( "PlayerWindow", SystemData.Events.PLAYER_BATTLE_LEVEL_UPDATED,		"PlayerWindow.UpdatePlayerLevel")
]]--
	
function Addon.RegisterStateInfoForPlayer()
	--d("playerstate")
	local hpstate = EffigyState:new("PlayerHP")
	hpstate:updateFunction(Addon.UpdatePlayerHP)
	hpstate:updateEvent(SystemData.Events.PLAYER_CUR_HIT_POINTS_UPDATED)
	hpstate:updateEvent(SystemData.Events.PLAYER_MAX_HIT_POINTS_UPDATED)
	hpstate:updateEvent(SystemData.Events.PLAYER_RVR_FLAG_UPDATED)
	hpstate:updateEvent(SystemData.Events.PLAYER_CAREER_RANK_UPDATED)
	hpstate:updateEvent(SystemData.Events.PLAYER_CAREER_RANK_UPDATED)
	hpstate:updateEvent(SystemData.Events.PLAYER_GROUP_LEADER_STATUS_UPDATED)
	
	-- already available?
	hpstate:SetRawTitle(GetPlayersRawName())
	--EffigyBuffs.RegisterStateForEffect(Addon.States["PlayerHP"],"self")												
 

	local apstate = EffigyState:new("PlayerAP")
	apstate:updateFunction(Addon.UpdatePlayerAP)
	apstate:updateEvent(SystemData.Events.PLAYER_CUR_ACTION_POINTS_UPDATED)
	--apstate:updateEvent(SystemData.Events.PLAYER_MAX_ACTION_POINTS_UPDATED)

	local careerstate = EffigyState:new("PlayerCareer")
	careerstate:SetValid(0) -- it's not valid till we are told it is
	careerstate:updateFunction(Addon.UpdatePlayerCareerPresence)	
	RegisterEventHandler( SystemData.Events.PLAYER_CAREER_RESOURCE_UPDATED,
						  Addon.Name..".UpdatePlayerCareer")

	local lvlstate = EffigyState:new("PlayerLevel")
	lvlstate:updateFunction(Addon.UpdatePlayerLevel)
	lvlstate:updateEvent(SystemData.Events.PLAYER_CAREER_RANK_UPDATED)
	-- TODO: hard coded, checkme after expansion
	lvlstate:SetMax(40)
	
	local playerrenownstate = EffigyState:new("PlayerRenown")
	playerrenownstate:updateFunction(Addon.UpdateRenown)
	playerrenownstate:updateEvent(SystemData.Events.PLAYER_RENOWN_UPDATED)
	
	local playerrenownrankstate = EffigyState:new("PlayerRR")
	playerrenownrankstate:updateFunction(Addon.UpdateRR)
	playerrenownrankstate:updateEvent(SystemData.Events.PLAYER_RENOWN_RANK_UPDATED)
	-- TODO: hard coded, adjust me after expansion
	playerrenownrankstate:SetMax(80)
	
	local namestate = EffigyState:new("Name")
	namestate:updateFunction(Addon.UpdateName)
	
	local expstate = EffigyState:new("Exp")
	expstate:updateFunction(Addon.UpdateExp)
	expstate:updateEvent(SystemData.Events.PLAYER_EXP_UPDATED)
	
	local restedstate = EffigyState:new("RestedExp")
	restedstate:updateFunction(Addon.UpdateRestedExp)
	restedstate:updateEvent(SystemData.Events.PLAYER_EXP_UPDATED)

	local influencestate = EffigyState:new("Influence")
	influencestate:updateFunction(Addon.UpdateInf)
	influencestate:updateEvent(SystemData.Events.PLAYER_INFLUENCE_UPDATED)
	influencestate:updateEvent(SystemData.Events.PLAYER_AREA_CHANGED) 

	local titlestate = EffigyState:new("Title")
	titlestate:updateFunction(Addon.UpdateTitle)
	titlestate:updateEvent(SystemData.Events.PLAYER_ACTIVE_TITLE_UPDATED)
	--d("endplayerstate")
	
	RegisterEventHandler(SystemData.Events.PLAYER_DEATH, "Effigy.OnPlayerDeath")
	RegisterEventHandler(SystemData.Events.LOADING_END, "Effigy.UpdatePlayerAP")		-- Death on load fix
end

function Addon.OnPlayerDeath()--arg)	-- arg: countdown for accept release
	--EA_ChatWindow.Print(L"I just died, didn´t I")
	--if arg then d(arg) end
	local ap_state = Addon.States["PlayerAP"]
	ap_state:SetValue(0)
	ap_state:render()	
end

function Addon.UpdatePlayerHP()
	local state = EffigyState:GetState("PlayerHP")
	if (nil == state) then return end
	local hp = GameData.Player.hitPoints.current
	
	-- temp rule hide fix
	--[[if hp == 0 then
		local ap_state = Addon.States["PlayerAP"]
		ap_state:SetValue(0)
		ap_state:render()
	end]]--
	state:SetValue(hp)
	state:SetMax(GameData.Player.hitPoints.maximum)
	
	state:SetEntityID(GameData.Player.worldObjNum)
	--state:SetLevel(L""..GameData.Player.level)--..L"/"..GameData.Player.Renown.curRank)
	state:SetExtraInfo("level", L""..GameData.Player.level)

	state:SetExtraInfo("isGroupLeader", GameData.Player.isGroupLeader )
	--state:SetExtraInfo("rvr_flagged", GameData.Player.rvrPermaFlagged or GameData.Player.rvrZoneFlagged)
	state:SetExtraInfo("isRVRFlagged", GameData.Player.rvrPermaFlagged or GameData.Player.rvrZoneFlagged)
	state:SetExtraInfo("career", GameData.Player.career.line)
	
	state:SetValid(1)
	state:render()
end

function Addon.UpdatePlayerAP()
	local state = EffigyState:GetState("PlayerAP")
	if (nil == state) then return end
	
	state:SetValue(GameData.Player.actionPoints.current)
	state:SetMax(GameData.Player.actionPoints.maximum)
	state:SetEntityID(GameData.Player.worldObjNum)

	state:SetValid(1)
	state:render()
end

function Addon.UpdateName()
	local state = EffigyState:GetState("Name")
	if (nil == state) then return end

	state:SetTitle(EffigyState:GetState("PlayerAP"):GetTitle()..L" "..GameData.Player.lastname)
	state:SetEntityID(GameData.Player.worldObjNum)

	state:SetValid(1)
	state:render()
end

function Addon.UpdateTitle()
	local state = EffigyState:GetState("Title")
	if (nil == state) then return end

	local str = L""
	if (GameData.Player.activeTitle ~= nil and GameData.Player.activeTitle ~= 0 ) then
		titleData = TomeGetPlayerTitleData(GameData.Player.activeTitle)
		if (titleData ~= nil) and (titleData.name ~= nil) then
			local offset = wstring.find(titleData.name, L",")
			if (offset ~= nil) then
				str = wstring.sub(titleData.name, offset+1)
			else
				str = titleData.name
			end
		end
	end
	if (str == nil or str == L"") then
		str = GameData.Player.Renown.curTitle
	end
	
	state:SetEntityID(GameData.Player.worldObjNum)
	state:SetTitle(L""..str)
	state:SetValid(1)
	state:render()
end

function Addon.UpdateExp()
	local state = EffigyState:GetState("Exp")
	if (nil == state) then return end

	state:SetValue(GameData.Player.Experience.curXpEarned,GameData.Player.Experience.curXpNeeded)
	state:SetTitle(L"R "..GameData.Player.level)
	--state:SetLevel(L""..GameData.Player.level)--(tonumber(GameData.Player.level))
	state:SetExtraInfo("level", L""..GameData.Player.level)
	state:SetValid(1)
	state:render()
end

function Addon.UpdateRestedExp()
	local state = EffigyState:GetState("RestedExp")
	if (nil == state) then return end

	state:SetValue(GameData.Player.Experience.restXp,GameData.Player.Experience.curXpNeeded)
	state:SetTitle(L"R "..GameData.Player.level)
	state:SetValid(1)
	state:render()
end

function Addon.UpdateRenown()
	local state = EffigyState:GetState("PlayerRenown")
	if (nil == state) then return end

	state:SetValue(GameData.Player.Renown.curRenownEarned,GameData.Player.Renown.curRenownNeeded)
	state:SetTitle(L"RR "..GameData.Player.Renown.curRank)
	--state:SetLevel(L""..GameData.Player.Renown.curRank) --(tonumber(GameData.Player.Renown.curRank))
	state:SetValid(1)
	state:render()
end

function Addon.UpdateRR()
	local state = EffigyState:GetState("PlayerRR")
	if (nil == state) then return end
	
	state:SetValue(GameData.Player.Renown.curRank)
	state:SetTitle(L"RR "..GameData.Player.Renown.curRank)
	--state:SetLevel(L""..GameData.Player.Renown.curRank) --(tonumber(GameData.Player.Renown.curRank))	
	state:SetValid(1)
	state:render()
end

function Addon.UpdatePlayerLevel()
	local state = EffigyState:GetState("PlayerLevel")
	if (nil == state) then return end

	state:SetValue(GameData.Player.level)
	state:SetValid(1)
	state:render()
end

function Addon.UpdatePlayerCareerPresence()
	local p_career = GameData.Player.career.line
	if (0 == p_career) or (nil == Addon.CareerResourceSettings[p_career]) then return end
	local state = EffigyState:GetState("PlayerCareer")
	state:SetMax(Addon.CareerResourceSettings[p_career].max)
	if (0 == state:GetMax()) then return end
	state:SetValue(Addon.CareerResourceSettings[p_career].default)
	state:SetValid(1)
	state:SetEntityID(GameData.Player.worldObjNum)
	state:render()
end

local morkColor
local gorkColor
function Addon.UpdatePlayerCareer(prev, curr)
	local state = EffigyState:GetState("PlayerCareer")
	if (nil == state) then return end

	local p_career = GameData.Player.career.line
	--d(prev, curr, p_career)
	if (nil == prev or nil == curr or nil == p_career) then return end
	local rawvalue = 0

	if ((GameData.CareerLine.SHAMAN == p_career) or
		  (GameData.CareerLine.ARCHMAGE == p_career)) 
	then
				
		rawvalue = curr - 5
		
		if (curr > 5) then
			gorkColor = gorkColor or RVMOD_GColorPresets.GetColorPreset("_Gork")
			if gorkColor then
				state:updateMyBarColours(gorkColor.r, gorkColor.g, gorkColor.b)
			else
				state:updateMyBarColours(238, 12, 12) -- red
			end
			curr = curr - 5
		else
			morkColor = morkColor or RVMOD_GColorPresets.GetColorPreset("_Mork")
			if morkColor then
				state:updateMyBarColours(morkColor.r, morkColor.g, morkColor.b)
			else
				state:updateMyBarColours(0, 100, 224) -- blue
			end
		end
	end

	state:SetValid(1)
	state:SetValue(curr)
	state:SetRelativeLevel(rawvalue)
	state:SetMax(Addon.CareerResourceSettings[p_career].max)
	state:SetEntityID(GameData.Player.worldObjNum)
	state:render()
end

function Addon.UpdateInf()
	local state = EffigyState:GetState("Influence")

	local areaData = GetAreaData()
	local inf_id = nil
	
	if areaData ~= nil then
		for k, v in ipairs(areaData) do
			-- The first value with an influenceID of non-zero is the current area's influence id
			-- if there is no influence id then this is a battlefield objective or keep
			if (v.influenceID ~= 0) then
				inf_id = v.influenceID
			end
		end
	end


	if (not inf_id) or (0 == inf_id) then
		state:SetValid(0)
		state:render()
		return
	end

	local inf_data = DataUtils.GetInfluenceData(inf_id)
	if not inf_data then
		state:SetValid(0)
		state:render()
		return
	end    
    
	--local zone  = GetZoneName(inf_data.zoneNum)
	local area = GetZoneAreaName(inf_data.zoneNum, inf_data.zoneAreaNum)
	local chapter = GetChapterShortName(inf_id)

	local imax
	for level = 1, TomeWindow.NUM_REWARD_LEVELS do
		imax = inf_data.rewardLevel[level].amountNeeded
	end     

	state:SetTitle(L""..towstring(chapter)..L":"..towstring(area))
	state:SetValue(inf_data.curValue,imax)
	state:SetValid(1)
	state:render()
end

--
-- Mouse Handlers
--
local XP_TOOLTIP_ANCHOR = { Point = "bottom",  RelativeTo = "XpBarWindow", RelativePoint = "top",  XOffset = 0, YOffset = 10 }
function Addon.MouseoverXPBar()
	XP_TOOLTIP_ANCHOR.RelativeTo = SystemData.ActiveWindow.name
    Tooltips.CreateTextOnlyTooltip( SystemData.ActiveWindow.name )
    Tooltips.SetUpdateCallback( Addon.SetXPLabelText )
end

function Addon.SetXPLabelText()

    local line1 = GetString( StringTables.Default.LABEL_EXP_POINTS )
    Tooltips.SetTooltipText( 1, 1, line1 )
    Tooltips.SetTooltipColorDef( 1, 1, Tooltips.COLOR_HEADING )

    local line2 = GetString( StringTables.Default.TEXT_EXP_BAR_DESC )
    Tooltips.SetTooltipText( 2, 1, line2 )

    local line3 = L""
    local curPoints = GameData.Player.Experience.curXpEarned
    local maxPoints = GameData.Player.Experience.curXpNeeded
    if ( maxPoints == 0 ) then
        -- We're the maximum level.
        line3 = GetString( StringTables.Default.TEXT_CUR_EXP_MAXIMUM )
    else
        local percent = wstring.format(L"%d", curPoints / maxPoints * 100)
        line3 = GetStringFormat( StringTables.Default.TEXT_CUR_EXP, {curPoints, maxPoints, percent } )
    end
    Tooltips.SetTooltipText( 3, 1, line3 )
    Tooltips.SetTooltipColorDef( 3, 1, Tooltips.COLOR_HEADING )

	local line4 = L""
    if ( maxPoints ~= 0 ) then
        line4 = L"- "..(GameData.Player.Experience.curXpNeeded - GameData.Player.Experience.curXpEarned)
    end
    Tooltips.SetTooltipText( 4, 1, line4 )
    Tooltips.SetTooltipColorDef( 4, 1, Tooltips.COLOR_HEADING )
	
    if (GameData.Player.Experience.restXp > 0) then
        local line5 = GetStringFormat( StringTables.Default.LABEL_EXP_RESTED, {GameData.Player.Experience.restXp} )
		line5 = line5..L": "..GameData.Player.Experience.restXp
        Tooltips.SetTooltipText( 5, 1, line5 )
        Tooltips.SetTooltipColorDef( 5, 1, DefaultColor.XP_COLOR_RESTED )
    end

    Tooltips.Finalize()
    Tooltips.AnchorTooltip( XP_TOOLTIP_ANCHOR )

end

-- OnMouseOver Handler for Rp bar
RP_TOOLTIP_ANCHOR = { Point = "bottom",  RelativeTo = "RpBarWindow", RelativePoint = "top",  XOffset = 0, YOffset = 10 }
function Addon.MouseoverRPBar()
	RP_TOOLTIP_ANCHOR.RelativeTo = SystemData.ActiveWindow.name
    Tooltips.CreateTextOnlyTooltip( SystemData.ActiveWindow.name )
    Tooltips.SetUpdateCallback( Addon.SetRPLabelText )
end

function Addon.SetRPLabelText()

    local curPoints = GameData.Player.Renown.curRenownEarned
    local maRpoints = GameData.Player.Renown.curRenownNeeded
    local percent = wstring.format(L"%d", curPoints/maRpoints*100)
    
    local title = GameData.Player.Renown.curTitle 
    if( title == L"" ) then
        title = GetString( StringTables.Default.LABEL_NONE) 
    end
    
    local line1 = GetString( StringTables.Default.LABEL_RENOWN_POINTS )
    local line2 = GetString( StringTables.Default.TEXT_RENOWN_BAR_DESC )
    local line3 = GetString( StringTables.Default.LABEL_RENOWN_RANK )..L": "..GameData.Player.Renown.curRank
    local line4 = GetString( StringTables.Default.LABEL_CUR_TITLE )..L": "..title		
    local line5 = GetStringFormat( StringTables.Default.TEXT_CUR_RENOWN, {curPoints, maRpoints, percent } ) 	
    local line6 = L"- "..(maRpoints-curPoints)
	
    Tooltips.SetTooltipText( 1, 1, line1)
    Tooltips.SetTooltipColorDef( 1, 1, Tooltips.COLOR_HEADING )
    Tooltips.SetTooltipText( 2, 1, line2)
    Tooltips.SetTooltipText( 3, 1, line3)
    Tooltips.SetTooltipColorDef( 3, 1, Tooltips.COLOR_HEADING )
    Tooltips.SetTooltipText( 4, 1, line4)
    Tooltips.SetTooltipColorDef( 4, 1, Tooltips.COLOR_HEADING )
    Tooltips.SetTooltipText( 5, 1, line5)
    Tooltips.SetTooltipColorDef( 5, 1, Tooltips.COLOR_HEADING )
	Tooltips.SetTooltipText( 6, 1, line6)
    Tooltips.SetTooltipColorDef( 6, 1, Tooltips.COLOR_HEADING )
    Tooltips.Finalize();
    Tooltips.AnchorTooltip( RP_TOOLTIP_ANCHOR )   
    
end