-- vim: sw=2 ts=2
if not Effigy then Effigy = {} end
-- Make addon table ref local for performance
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

if not Addon.States then Addon.States = {} end

--local Addon = Addon
--local EffigyState = EffigyState

function Addon.RegisterForStateInfo()

	Addon.States["default"] = EffigyState:new("default")
	Addon.States["none"] = EffigyState:new("none")
	Addon.States["none"].max = 0
	Addon.States["none"].curr = 0
	Addon.States["none"].valid = 1
	Addon.States["full"] = EffigyState:new("full")
	Addon.States["full"].curr = 10
	Addon.States["full"].max = 10
	Addon.States["full"].valid = 1

	Addon.States["test"] = EffigyState:new("Template")
	Addon.States["test"].max = 100
	Addon.States["test"].valid = 0
	Addon.States["test"].level = math.random(1, 40)
	Addon.States["test"].career = math.random(1, 10)
	Addon.States["test"].word = L"Test"
	Addon.States["test"].curr = math.random(1, 100)


	Addon.RegisterStateInfoForPlayer()
	Addon.RegisterStateInfoForPets()
	Addon.RegisterStateInfoForTargets()
	Addon.RegisterStateInfoForCombat()
	Addon.RegisterStateInfoForGroup()
	Addon.RegisterStateInfoForCastbar()
	--Addon.RegisterStateInfoForWarband()
	Addon.RegisterStateInfoForFormation()
	--Addon.RegisterStateInfoForScenario()
	Addon.RegisterStateInfoForGuild()
	Addon.RegisterStateInfoForCGroup()
end




function Addon.DumpState(state_name)
	local state = Addon.States[state_name]
	if (nil == state) then return end

	DUMP_TABLE(state)

	DUMP_TABLE_TO(state, EA_ChatWindow.Print)

end

