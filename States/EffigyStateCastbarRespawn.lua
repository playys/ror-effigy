-- Credits @ Addon by Aiiane

if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

local firstLoad = true

local respawnTimeLeft = 0

--
--	Locales
--
local T = LibStub("WAR-AceLocale-3.0"):NewLocale("Effigy", "enUS", true)
if T then
	-- Actual text displayed in the black box
	T["Respawning..."]      = L"Respawning%.%.%."
	-- Text displayed on the new 'bar'
	T["Respawning in "]     = L"Respawning"
end

T = LibStub("WAR-AceLocale-3.0"):NewLocale("Effigy", "deDE")
if T then
	-- Actual text displayed in the black box
	T["Respawning..."]      = L"Ihr kehrt zurück in:"
	-- Text displayed on the new 'bar'
	T["Respawning in "]     = L"Ihr kehrt zurück"
end

T = LibStub("WAR-AceLocale-3.0"):NewLocale("Effigy", "esES")
if T then
	-- Actual text displayed in the black box
	T["Respawning..."]      = L"Reaparecer%.%.%."
	-- Text displayed on the new 'bar'
	T["Respawning in "]     = L"Reaparecer"
end

T = LibStub("WAR-AceLocale-3.0"):NewLocale("Effigy", "frFR")
if T then
	-- Actual text displayed in the black box
	T["Respawning..."]      = L"Réapparition%.%.%."
	-- Text displayed on the new 'bar'
	T["Respawning in "]     = L"Réapparition"
end

T = LibStub("WAR-AceLocale-3.0"):NewLocale("Effigy", "itIT")
if T then
	-- Actual text displayed in the black box
	T["Respawning..."]      = L"Ritorno in gioco%.%.%."
	-- Text displayed on the new 'bar'
	T["Respawning in "]     = L"Ritorno in gioco"
end

T = LibStub("WAR-AceLocale-3.0"):NewLocale("Effigy", "ruRU")
if T then
	-- Actual text displayed in the black box
	T["Respawning..."]      = L"???????????%.%.%."
	-- Text displayed on the new 'bar'
	T["Respawning in "]     = L"??????????? "
end
T = LibStub("WAR-AceLocale-3.0"):GetLocale("Effigy")

--
-- Functions
--

function Addon.InitializeCastbarRespawn()
	--RegisterEventHandler(SystemData.Events.LOADING_END, "Effigy.SetRespawnHook")
	--RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, "Effigy.SetRespawnHook")
	RegisterEventHandler(SystemData.Events.PLAYER_CUR_HIT_POINTS_UPDATED, "Effigy.RespawnHealthUpdate")
	Addon.SetRespawnHook()
end

function Addon.OnApplicationTwoButtonDialogHook(...)
    -- only pass down the call chain if it's not a respawn box
    if (Addon.ProfileSettings.CastbarHookRespawn and (SystemData.Dialogs.AppDlg.text):find(T["Respawning..."])) then
	        -- show respawn timer window
        local respawnTimeLeft = SystemData.Dialogs.AppDlg.timer
        --StatusBarSetMaximumValue("RespawnTimerWindowBar", respawnTimeLeft)
		local state = Addon.States["Castbar"]
		state:SetMax(respawnTimeLeft)
		state:SetValue(respawnTimeLeft)
		state:SetExtraInfo("isSpellChannel", true )
		state:SetExtraInfo("isSpellInteract", false )
		state:SetExtraInfo("ability", 0 )
		state:SetTitle(T["Respawning in "])
		state:SetValid(1)
		state:render()
			
        --Addon.UpdateRespawnTimer(0)
        --WindowSetShowing("RespawnTimerWindow", true)
    else
		Addon.oldOnApplicationTwoButtonDialog(...)
    end
end

function Addon.SetRespawnHook()
    if not firstLoad then return end
    firstLoad = false
    
    Addon.oldOnApplicationTwoButtonDialog = DialogManager.OnApplicationTwoButtonDialog
    DialogManager.OnApplicationTwoButtonDialog = Addon.OnApplicationTwoButtonDialogHook
    
    --CreateWindow("RespawnTimerWindow", false)
end

function Addon.RespawnHealthUpdate()
    if respawnTimeLeft <= 0 then return end
    
    if GameData.Player.hitPoints.current > 0 then
        --WindowSetShowing("RespawnTimerWindow", false)
		Addon.EndCast()
        respawnTimeLeft = 0
    end
end

--[[function Addon.UpdateRespawnTimer(timePassed)
    if respawnTimeLeft <= 0 then return end

    respawnTimeLeft = respawnTimeLeft - timePassed
    
    if respawnTimeLeft <= 0 then
        --WindowSetShowing("RespawnTimerWindow", false)
		Addon.EndCast()
    --else
    --    StatusBarSetCurrentValue("RespawnTimerWindowBar", respawnTimeLeft)
    --    LabelSetText("RespawnTimerWindowText", T["Respawning in "]..towstring(math.ceil(respawnTimeLeft))..L"s...")
    end
end]]--
