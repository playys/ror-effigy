if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

function Addon.RegisterStateInfoForPets()
	-- PLAYER_PET_UPDATED
	-- PLAYER_PET_HEALTH_UPDATED
	-- PLAYER_PET_STATE_UPDATED
	-- PLAYER_PET_TARGET_UPDATED
	-- PLAYER_PET_TARGET_HEALTH_UPDATED
	local state = EffigyState:new("PlayerPetHP")
	state:updateFunction(Addon.UpdatePlayerPet)
	state:updateEvent(SystemData.Events.PLAYER_PET_UPDATED)
	RegisterEventHandler(SystemData.Events.PLAYER_PET_HEALTH_UPDATED, "Effigy.OnPlayerPetHealthUpdated")
	state:SetMax(100)
	local state_petTarget = EffigyState:new("PlayerPetTargetHP")
	local state_petTarget_lvl = EffigyState:new("PlayerPetTargetlvl")
	state_petTarget:updateFunction(Addon.UpdatePlayerPetTarget)
	state_petTarget:updateEvent(SystemData.Events.PLAYER_PET_TARGET_UPDATED)
	
	state_petTarget_lvl:updateFunction(Addon.UpdatePlayerPetTarget)
	state_petTarget_lvl:updateEvent(SystemData.Events.PLAYER_PET_TARGET_UPDATED)
	--local state_petTargetCon = EffigyState:new("PlayerPetTargetCon")
	--state_petTargetCon:updateFunction(Addon.UpdatePlayerPetTarget)
	--state_petTargetCon:updateEvent(SystemData.Events.PLAYER_PET_TARGET_UPDATED)
	RegisterEventHandler( SystemData.Events.PLAYER_PET_TARGET_HEALTH_UPDATED, Addon.Name..".OnPlayerPetTargetHealthUpdated")
end

function Addon.UpdatePlayerPet()
	local state = EffigyState:GetState("PlayerPetHP")
	if (nil == state) then return end

	local level = GameData.Player.Pet.level
	if (0 == level) then
		state:SetValid(0)
	else
		state:SetValid(1)
	end
	--state:SetLevel(level)
	state:SetExtraInfo("level", level)
	state:SetValue(GameData.Player.Pet.healthPercent)
	state:SetRawTitle(GameData.Player.Pet.name)
	state:SetEntityID(GameData.Player.Pet.objNum)
	
	state:render()
end

function Addon.OnPlayerPetHealthUpdated()
	local state = EffigyState:GetState("PlayerPetHP")
	if (nil == state) then return end
	state:SetValue(GameData.Player.Pet.healthPercent)
	state:render()
end

function Addon.UpdatePlayerPetTarget()
	local hp_state = EffigyState:GetState("PlayerPetTargetHP")
	if (nil == hp_state) then return end
	local lvl_state = EffigyState:GetState("PlayerPetTargetlvl")
	if (nil == lvl_state) then return end
	
	local petTarget = GameData.Player.Pet.Target
	
	if (0 == petTarget.level) then
		hp_state:SetValid(0)
		lvl_state:SetValid(0)
		hp_state:render()
		lvl_state:render()
		return
	else
		hp_state:SetValid(1)
		lvl_state:SetValid(1)
	end
	
	hp_state:SetValue(petTarget.healthPercent)
	hp_state:SetMax(100)
	
	local name = L""..petTarget.name
	hp_state:SetRawTitle(name)
	lvl_state:SetRawTitle(name)
	
	local lvltext = petTarget.level
	lvl_state:SetValue(lvltext)
	lvl_state:SetRelativeLevel(lvltext - GameData.Player.Pet.level)
	for i=1,petTarget.tier do
		lvltext = lvltext..L"+"
	end
	--hp_state:SetLevel(lvltext)
	hp_state:SetExtraInfo("level", lvltext)
	
	local unittype = petTarget.type -- just guessing...
	if unittype == 1 or unittype == 3 or unittype == 5 then 
		hp_state:SetExtraInfo("isNPC", false)
	else
		hp_state:SetExtraInfo("isNPC", true)	
	end
	hp_state:SetExtraInfo("unittype", unittype )
	hp_state:SetExtraInfo("isFriendly", false)	
	hp_state:SetExtraInfo("isEnemy", true)
	
	
	--state:SetEntityID(petTarget.objNum)
	-- TODO: hard coded
	lvl_state:SetMax(40)
	
	
	hp_state:render()
	lvl_state:render()
	
	--[[local con_state = EffigyState:GetState("PlayerPetTargetCon")
	con_state:SetValue(petTarget.conType)
	con_state:SetMax(8)]]--
	
	--type
	
	
end

function Addon.OnPlayerPetTargetHealthUpdated(healthPercent)
	local hp_state = EffigyState:GetState("PlayerPetTargetHP")
	if (nil == hp_state) then return end
	hp_state:SetValue(healthPercent)
	hp_state:render()
end