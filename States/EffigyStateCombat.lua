if not Effigy then Effigy = {} end
local Addon = Effigy

function Addon.RegisterStateInfoForCombat()
	local combat = EffigyState:new("Combat")
	combat:updateFunction(Addon.UpdateCombatStatus)
	combat:updateEvent(SystemData.Events.PLAYER_COMBAT_FLAG_UPDATED )
	combat:SetMax(1)
end

local inCombat
function Addon.UpdateCombatStatus()
	local state = EffigyState:GetState("Combat")
	if not state then return end
	local playerInCombat = GameData.Player.inCombat
	if inCombat == playerInCombat then return else inCombat = playerInCombat end
	if playerInCombat then
		state:SetValue(1)
		state:SetTitle(L"Combat")
		state:SetValid(1)
	else
		state:SetValue(0)
		state:SetTitle(L"")
		state:SetValid(0)
	end
	
	state:render()
	EffigyBar.reRenderAfterCombatChange()
end