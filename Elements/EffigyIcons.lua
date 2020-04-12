if not Effigy then Effigy = {} end
local Addon = Effigy

local GetString = GetString
local Tooltips = Tooltips
local TargetObjectType = SystemData.TargetObjectType
local LibGUI = LibStub("LibGUI")

--
-- RvR Icon
--

local RvRTooltips =
{
    [TargetObjectType.NONE]              = L"",
    [TargetObjectType.SELF]              = L"", -- GetString( StringTablesDefault.TOOLTIP_RVR_INDICATOR),
    [TargetObjectType.ALLY_PLAYER]       = L"",
    [TargetObjectType.ALLY_NON_PLAYER]   = L"",
    [TargetObjectType.ENEMY_PLAYER]      = L"", -- GetString (StringTablesDefault.TOOLTIP_PLAYER_RVR_INDICATOR),
    [TargetObjectType.ENEMY_NON_PLAYER]  = L"", -- GetString (StringTablesDefault.TOOLTIP_MONSTER_RVR_INDICATOR),
    [TargetObjectType.STATIC]            = L"",
    [TargetObjectType.STATIC_ATTACKABLE] = L"",
}

local function SetupRvRIcon(self)
	local settings = self.Settings
	local container = self.Container

	local anchor1settings = settings.anchors[1]
	self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, anchor1settings.x, anchor1settings.y)
	self:Alpha(settings.alpha)
	--self:Scale(self.scale * self.rvr_icon.scale)
	self:Scale(WindowGetScale(container.name) * settings.scale)	-- DONOTTOUCH
	local stateName = container.state
	if stateName == "PlayerHP" or stateName == "PlayerAP" or stateName == "PlayerCareer" then
		self.m_TargetType = SystemData.TargetObjectType.SELF
	end
	if not settings.show then self:Hide() end
end

local function RenderRvRIcon (self, bg_alpha)
	local settings = self.Settings
	if not settings.show then return end	-- deal with inactive in Setup()
	if (Effigy.States[self.Container.state]:GetExtraInfo("isRVRFlagged")) then
		if (settings.follow_bg_alpha) then self:Alpha(bg_alpha) end
		self:Show()
	else
		self:Hide()
	end
end
		
local tooltipStringsInitialized = false
function Addon.CreateRvRIndicator(bar)
	local parentWindow = bar.name

	if not tooltipStringsInitialized then
		RvRTooltips[TargetObjectType.SELF] = GetString(StringTables.Default.TOOLTIP_RVR_INDICATOR)
		RvRTooltips[TargetObjectType.ENEMY_PLAYER] = GetString(StringTables.Default.TOOLTIP_PLAYER_RVR_INDICATOR)
		RvRTooltips[TargetObjectType.ENEMY_NON_PLAYER] = GetString(StringTables.Default.TOOLTIP_MONSTER_RVR_INDICATOR)
		tooltipStringsInitialized = true
	end
	
	-- holy waffle, mythic.
	local icon = LibGUI("window", parentWindow.."RvrIndicator", "EffigyEmpty")
	icon:Resize(41, 53)
	
	icon.rvrFrame = icon:Add("image", icon.name.."Image")
	local rvrFrame = icon.rvrFrame
	rvrFrame:AnchorTo(icon.name, "topleft", "topleft", 0, 0)
	rvrFrame:AddAnchor(icon.name, "bottomright", "bottomright", 0, 0)
	rvrFrame:Texture("EA_HUD_01", 113, 90)
	rvrFrame:TexSlice("RvR-Flag")
	rvrFrame:IgnoreInput()
	rvrFrame:UnregisterDefaultEvents()
	
	--icon:RegisterEvent("OnMouseOver")
    	
	-- Make the RvR flag icon smaller.
	icon:Parent(parentWindow)
	icon.parentWindow = parentWindow	-- so so many workarounds -.-
	--rvrFrame:CaptureInput()
	
	icon:Layer("secondary")
	icon.OnMouseOver = 
		function()
			local frameName = icon.name
			local targetType = icon.m_TargetType
			if (RvRTooltips[targetType] ~= L"") then
				Tooltips.CreateTextOnlyTooltip (frameName, RvRTooltips[targetType])
				local tooltip_anchor = 
				{ 
					Point           = "bottom",  
					RelativeTo      = icon.name, --icon.parent,	--WindowGetParent (frameName), 
					RelativePoint   = "top",   
					XOffset         = 0, 
					YOffset         = 20 
				}
				Tooltips.AnchorTooltip (tooltip_anchor)
			end
		end
	icon.SetMouseOver = 
		function(value)
			if value then
				icon.RegisterEvent("OnMouseOver")
				icon:Parent("Root")
			else
				icon.UnregisterEvent("OnMouseOver")
				icon:Parent(icon.parentWindow)
			end
		end
	icon.GetMouseOver =
		function()
			if icon.rEvents then return icon.rEvents["OnMouseOver"] end
			return nil
		end
	icon.SetTargetType = 
		function(value)
			icon.m_TargetType = value
		end
    icon.GetTargetType = 
		function()
			return icon.m_TargetType
		end

	icon.Container = bar
	icon.Settings = bar.rvr_icon
	
	icon.Setup = SetupRvRIcon
	icon.Render = RenderRvRIcon
	
    return icon
end

--
-- Career Icon
--

local function SetupCareerIcon(self)
	local settings = self.Settings
	local container = self.Container
	local state = container.state
	local Image = self.Image
	if state == "PlayerHP" or state == "PlayerAP" or state == "PlayerCareer" then
		self.careerState = -1
		local texture, x, y = GetIconData(Icons.GetCareerIconIDFromCareerLine(GameData.Player.career.line))
		Image:Texture(texture, x, y)
		self:Resize(32, 32)
		if settings.show then self:Show() end	-- final state, render returns early
	elseif state == "PlayerPetHP" then
		self.careerState = -2
		Image:Texture("render_scene_pet_portrait", 0, 0)
		Image:TexScale(0.33)
		self:Resize(32, 32)
		if settings.show then self:Show() end	-- final state, render returns early
	elseif state == "Castbar" then
		self.careerState = -3
		self:Resize(64, 64)
	else
		self.careerState = Addon.States[state].extra_info.career or 0
		self:Resize(32, 32)
	end
	local anchor1settings = settings.anchors[1]
	self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, anchor1settings.x, anchor1settings.y)
	self:Alpha(settings.alpha)
	--self:Scale(self.scale * settings.scale)
	self:Scale(WindowGetScale(container.name) * settings.scale)	-- DONOTTOUCH
	if not settings.show then
		self:Hide()
	end
end

local function RenderCareerIcon(self, value, careerState)
	local settings = self.Settings
	if (not settings.show) then return end
	local container = self.Container
	
	if value == self.value and (careerState == self.careerState or careerState == nil) then return end
	if self.careerState == -1 or self.careerState == -2 then return end
	
	local stateChanged = false
	if careerState and careerState ~= self.careerState and self.careerState ~= -3 then
		stateChanged = true
		self.careerState = careerState
	else
		careerState = self.careerState
	end
	local Image = self.Image
	if careerState == -3 then
		if value ~= 0 then
			local texture, x, y = GetIconData(value)
			if (texture) then
				Image:Texture(texture, x, y)
				self:Show()
			else
				self:Hide()
			end
		else
			self:Hide()
		end
	elseif careerState == 1 then	-- Map Icon for NPCs
		-- MapPinType:

		-- Banker?
		--[[local mapPinType2Slice = {
			[17] = Quest grün
			[18] = Quest grau und fertig?!?
			[21] = Rally Master (Leeres Quest Icon)
			[30] = {slice="KillCollector", scale=1.0},				-- Kill Collector
			[31] = {slice="NPC-Merchant", scale=1.0},				-- Merchant
			[32] = {slice="NPC-TrainerActive", scale=1.0}, 			-- Trainer
			[34] = {slice="Auctioneer", scale=1.0}, 				-- Auctioneer
			[35] = {slice="NPC-Travel", scale=1.0}, 				-- Flight Master
			[37] = {slice="NPC-Binder", scale=1.1},					-- Rally Master ( no icon above head)
			[38] = {slice="NPC-GuildRegistrar-Large", scale=1.0},	-- Guild Registrar
			[39] = {slice="NPC-Healer-Large", scale=1.0}, 			-- Healer
			[48] = {slice="Mail-Large", scale=1.0}, 				-- Mailbox
			[49] = {slice="LastNames-Large", scale=1.0}, 			-- Name Registrar
			[53] = Repeatable Quest
			-- slice="Vault",                       scale=1.0
		}]]--
		local MapPointType2Icon =	-- Map Point Type,Icon,Default Type Desc
		{
		[0] = 0,		-- PIN_TYPE_DEFAULT
		[1] = 0,		-- PIN_TYPE_LANDMARK
		[2] = 0,		-- PIN_TYPE_CHAPTER
		[3] = 0,		-- PIN_TYPE_WAR_CAMP
		[4] = 0,		-- PIN_TYPE_PUBLIC_QUEST
		[5] = 9,		-- PIN_TYPE_OBJECTIVE
		[6] = 103,		-- PIN_TYPE_KEEP
		[15] = 1,		-- PIN_TYPE_PLAYER
		[16] = 2,		-- PIN_TYPE_GROUP
		[17] = 3,		-- PIN_TYPE_QUEST_OFFER_NPC
		[18] = 4,		-- PIN_TYPE_QUEST_PENDING_NPC
		[19] = 5,		-- PIN_TYPE_QUEST_COMPLETE_NPC
		[20] = 6,		-- PIN_TYPE_INFLUENCE_NPC
		[21] = 7,		-- PIN_TYPE_INFLUENCE_NPC_PENDING
		[22] = 10,		-- PIN_ORDER_ARMY
		[23] = 11,		-- PIN_DESTRUCTION_ARMY
		[24] = 12,		-- PIN_TYPE_QUEST_AREA
		[25] = 13,		-- PIN_TYPE_FLAG
		[26] = 14,		-- PIN_TYPE_BOUNTY_HUNTER_QUEST_OFFER_NPC
		[27] = 15,		-- PIN_TYPE_BOUNTY_HUNTER_QUEST_PENDING_NPC
		[28] = 16,		-- PIN_TYPE_BOUNTY_HUNTER_QUEST_COMPLETE_NPC
		[29] = 17,		-- PIN_TYPE_KILL_COLLECTOR_QUEST_PENDING_NPC
		[30] = 18,		-- PIN_TYPE_KILL_COLLECTOR_QUEST_COMPLETE_NPC
		[31] = 19,		-- PIN_TYPE_STORE_NPC
		[32] = 20,		-- PIN_TYPE_TRAINER_NPC
		[33] = 21,		-- PIN_TYPE_SCENARIO_GATEKEEPER_NPC
		[34] = 22,		-- PIN_TYPE_AUCTION_HOUSE_NPC
		[35] = 23,		-- PIN_TYPE_TRAVEL_NPC
		[36] = 24,		-- PIN_TYPE_VAULT_KEEPER_NPC
		[37] = 34,		-- PIN_TYPE_BINDER_NPC
		[38] = 26,		-- PIN_TYPE_GUILD_REGISTRAR_NPC
		[39] = 27,		-- PIN_TYPE_HEALER_NPC
		[40] = 0,		-- PIN_TYPE_EMPTY_SIEGE_PAD
		[41] = 0,		-- PIN_TYPE_SIEGE_WEAPON
		[42] = 1,		-- PIN_TYPE_PLAYER_SIEGE_WEAPON
		[43] = 37,		-- PIN_TYPE_PLAYER_SIEGE_AIM_LOCATION
		[44] = 41,		-- PIN_TYPE_HOTSPOT_SMALL
		[45] = 36,		-- PIN_TYPE_HOTSPOT_MEDIUM
		[46] = 40,		-- PIN_TYPE_HOTSPOT_LARGE
		[47] = 35,		-- PIN_TYPE_RVR_NPC
		[48] = 48,		-- PIN_TYPE_MAILBOX
		[49] = 49,		-- PIN_TYPE_MERCHANT_LASTNAME
		[50] = 46,		-- PIN_TYPE_MERCHANT_DYE
		[51] = 13,		-- PIN_TYPE_BANNER
		[52] = 60,		-- PIN_TYPE_WARBAND
		[53] = 63,		-- PIN_TYPE_REPEATABLE_QUEST_OFFER_NPC
		[54] = 67,		-- PIN_TYPE_LIVE_EVENT_QUEST_OFFER_NPC
		[55] = 12,		-- PIN_TYPE_LIVE_EVENT_WAYPOINT
		[56] = 1099,	-- PIN_TYPE_IMPORTANT_MONSTER
		[57] = 68,		-- PIN_TYPE_EQUIPMENT_UPGRADE_NPC
		}
		
		--local ICON_SIZE = 32--28
		local texture, textureX, textureY, sizeX, sizeY
		local mapicon = MapPointType2Icon[value]
		if mapicon == 0 then
			self:Hide()
			return
		end
		texture, textureX, textureY, sizeX, sizeY = GetMapIconData(mapicon)	-- 1.36
		if texture and not sizeY then
			--we´re on 1.4
			sizeY = sizeX
			sizeX = textureY
			textureY = textureX
			textureX = texture
			texture = "map_markers01"
		end
		--local textureX, textureY, sizeX, sizeY
		--textureX, textureY, sizeX, sizeY = GetMapIconData( value )							-- 1.4
		
		-- Clear the slice on the dynamic image. DynamicImageSetTexture will not work
		-- correctly if a slice is assigned.
		--DynamicImageSetTextureSlice( iconWindow, "" )
		--DEBUG(L"Texture: "..towstring(texture)..L"; textureX: "..textureX..L"; textureY: "..textureY..L"; sizeX: "..sizeX..L"; sizeY: "..sizeY)
		Image:Texture(texture, textureX, textureY)
		
		-- Scale the icon
		--DynamicImageSetTextureDimensions( iconWindow, sizeX, sizeY )
		Image:TexDims(sizeX, sizeY)
		
		if stateChanged then
			local xScale = 32/sizeX
			local yScale = 32/sizeY
			
			if( xScale < yScale ) 
			then
				--WindowSetDimensions( iconWindow, ICON_SIZE, ICON_SIZE*(xScale/yScale))
				--icon:TexScale(xScale)
				self:Resize(32, 32*(xScale/yScale))
			else        
				--WindowSetDimensions( iconWindow, ICON_SIZE*(yScale/xScale), ICON_SIZE)
				--self:TexScale(yScale)
				self:Resize(32*(yScale/xScale), 32)
			end
		end
		self:Show()
	else
		if value and value ~= 0 then
			local texture, x, y = GetIconData(Icons.GetCareerIconIDFromCareerLine(value))
			if (texture) then
				Image:Texture(texture, x, y)
				self:Show()
			else
				self:Hide()
			end
			if stateChanged then
				--self:TexScale()
				Image:TexDims(32, 32)
				self:Resize(32, 32)
			end
		else
			self:Hide()
		end
	end
	self.value = value
end

function Addon.CreateCareerIcon(bar)
	local parentWindow = bar.name
	local icon = LibGUI("window", parentWindow.."IconCareer", "EffigyEmpty")
	if targetType then icon.m_TargetType = targetType end
	icon:Resize(41, 53)
	
	icon.Image = icon:Add("image", icon.name.."Image")
	local Image = icon.Image
	--Image:Parent(icon)
	Image:AnchorTo(icon, "topleft", "topleft", 0, 0)
	Image:AddAnchor(icon, "bottomright", "bottomright", 0, 0)
	Image:IgnoreInput()
	Image:UnregisterDefaultEvents()
	
	icon:Parent(parentWindow)
	icon:Layer("secondary")

	icon.Container = bar
	icon.Settings = bar.icon
	
	icon.Setup = SetupCareerIcon
	icon.Render = RenderCareerIcon
		
	return icon
end

--
-- Status Icon
--
-- GroupLeader, WarbandLeader, Assistant

local function SetupStatusIcon(self)
	local settings = self.Settings
	local container = self.Container
	local anchor1settings = settings.anchors[1]
	self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, anchor1settings.x, anchor1settings.y)
	self:Alpha(settings.alpha)
	--self:Scale(container.scale * settings.scale)
	self:Scale(WindowGetScale(container.name) * settings.scale)	-- DONOTTOUCH
	self:Hide()		-- this icon needs to be always hidden on setup so that Render can return early if value == 0 or show == false
end

local function RenderStatusIcon(self, bg_alpha)
	local settings = self.Settings
	if not settings.show then return end
	local container = self.Container
	local state = Effigy.States[container.state]
	local value = 0
	if state:GetExtraInfo("isGroupLeader") then
		if LibFormationMode.GetFormationMode() == LibFormationMode.FormationModes.Warband then
			value = 2
		else
			value = 1
		end
	elseif state:GetExtraInfo("isAssistant") then
		value = 3
	end
	if self.value == value then return else self.value = value end
	local Image = self.Image
	if value == 1 then
		Image:Texture("EA_HUD_01", 25, 16)
		Image:TexSlice("Group-Leader-Crown")
		self:Resize(25, 16)
		self:Show()
	elseif value == 2 then
		Image:Texture("EA_HUD_01", 25, 16)
		Image:TexSlice("Warband-Leader-Crown")
		self:Resize(25, 16)
		self:Show()
	elseif value == 3 then
		Image:Texture("EA_HUD_01", 25, 14)
		Image:TexSlice("Warband-Assistant")
		self:Resize(25, 14)
		self:Show()
	else
		self:Hide()
	end
end
		
function Addon.CreateStatusIcon(bar)
	local parentWindow = bar.name
	local icon = LibGUI("window", parentWindow.."IconStatus", "EffigyEmpty")
	
	icon.Image = icon:Add("image", icon.name.."Image")
	local Image = icon.Image
	--Image:Parent(icon)
	Image:AnchorTo(icon, "topleft", "topleft", 0, 0)
	Image:AddAnchor(icon, "bottomright", "bottomright", 0, 0)
	Image:IgnoreInput()
	Image:UnregisterDefaultEvents()
	
	icon:Parent(parentWindow)
	icon:Layer("secondary")
	
	icon.value = 0
	
	icon.Container = bar
	icon.Settings = bar.status_icon
	
	icon.Setup = SetupStatusIcon
	icon.Render = RenderStatusIcon

	return icon
end


function Addon.CreateMasterLooterIcon(parentWindow)
end

local function SetupMAIcon(self)
end

local function RenderMAIcon(self)
end

function Addon.CreateMainassistIcon(bar)
--[[<!-- Main Assist Crown Template -->
<DynamicImage name="MainAssistCrown" texture="EA_HUD_01" slice="PartyMarker-Skull" popable="false" handleinput="true" layer="secondary">
  <Size>
	<AbsPoint x="30" y="33" />
  </Size>
</DynamicImage>]]--
	local parentWindow = bar.name
	local icon = LibGUI("image", parentWindow.."IconMA", "EffigyEmpty")
	
	icon.Image = icon:Add("image", icon.name.."Image")
	local Image = icon.Image
	--Image:Parent(icon)
	Image:AnchorTo(icon, "topleft", "topleft", 0, 0)
	Image:AddAnchor(icon, "bottomright", "bottomright", 0, 0)
	Image:IgnoreInput()
	Image:UnregisterDefaultEvents()
	
	icon:Parent(parentWindow)
	icon:Layer("secondary")

	icon.Container = bar
	icon.Settings = bar.status_icon
	
	icon.Setup = SetupMAIcon
	icon.Render = RenderMAIcon

	return icon
end

--
-- Skull Icon
--

local function RenderSkullIcon(self, value)
	local settings = self.Settings
	if not settings.show then return end
	local container = self.Container
	local state = Effigy.States[container.state]
	
	if self.value == value then return end
	local step = 1
	if self.value > value then
		step = -1
	end
	for i = self.value, value, step do
		local w = self[i]
		if step == 1 then
			w:Show()
		else
			w:Hide()
		end
	end
end

-- difficulty Mask 0?, 1-4
function Addon.CreateSkullIcon(parentWindow)
	--[[<!-- Skull Image (for lord, hero, and special monsters) Template -->
	<DynamicImage name="SkullImage" texture="EA_HUD_01" slice="LordHeroSpecial-Skull" handleinput="false" layer="background">
		<Size>
			<AbsPoint x="22" y="29" />
		</Size>
	</DynamicImage>]]--
	local icon = LibGUI("image", parentWindow.."IconSkull")
	icon:Parent(parentWindow)
	icon:Layer("secondary")
	icon.value = 0
	icon:Resize(88, 29)
	for i = 1,4 do
		icon[i] = icon:Add("image", icon.name.."Image"..i)
		local skull = icon[i]
		skull:Texture("EA_HUD_01", 0, 0)
		skull:TexSlice("LordHeroSpecial-Skull")
		skull:IgnoreInput()
		skull:UnregisterDefaultEvents()
		if i == 1 then
			skull:AnchorTo(icon.name, "topleft", "topleft", 0, 0)
		else
			skull:AnchorTo(icon[i-1].name, "right", "left", 0, 0)
		end
	end
	
	icon.Render = RenderSkullIcon

	return icon
end

