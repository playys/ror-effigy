-- OtherTargetList maintains a sorted list of players
-- Each player contains: name, hp, career, and decay

OtherTargetList = {}
OtherTargetList.DEFAULT_DECAY = 60
OtherTargetList.DEFAULT_MAXPLAYERS = 6
OtherTargetList.MAX_PLAYERS = 16

OtherTargetList.PRIO_DEFAULT = 0
OtherTargetList.PRIO_LOCKED = 1
OtherTargetList.PRIO_FAV = 2

local table_sort = table.sort
local table_insert = table.insert
local table_remove = table.remove
local ipairs = ipairs

-- default ctor
function OtherTargetList:new(t)
	t = t or {}
	setmetatable(t, self)
	self.__index = self
	t.players = {}
	t.max_players = OtherTargetList.DEFAULT_MAXPLAYERS
	t.remove_dead = false		-- remove dead players
	t.remove_full_hp = false	-- remove players with full hp
	t.sort_players = true
	t.require_key = false
	return t
end


-- returns false if the player was already inserted --NOW returns true if updateNeeded
function OtherTargetList:put_player(_name, _hp, _career)
	-- locks the player if he is in favorites	-- should be an argument, OtherTargetList shall not depend on an addon just for that!
	local pprio = OtherTargetList.PRIO_DEFAULT
	--[[if (Targets.saved.favorites[_name]) then
		pprio = OtherTargetList.PRIO_FAV
		Targets.alert(_name .. L" spotted !")
	end]]--
	--DEBUG(L"put player ".._name)
	for i, p in ipairs(self.players) do
		if (p.name == _name) then
			-- player found just update its data
			local hpChanged = (p.hp ~= _hp)
			p.hp = _hp
			p.decay = OtherTargetList.DEFAULT_DECAY
			if ((self.remove_dead and _hp == 0 and pprio == OtherTargetList.PRIO_DEFAULT)
					or (self.remove_full_hp and _hp == 100 and pprio == OtherTargetList.PRIO_DEFAULT)) then
				table_remove(self.players,i)
				--DEBUG(L"Removed ".._name..L" because dead or full")
				return true
			end
			--DEBUG(L"Updated "..self.players[i].name)
			return hpChanged
		end
	end

	
	-- new player (name, hp, career ...)
	if not(
			(self.remove_dead and _hp == 0 and pprio == OtherTargetList.PRIO_DEFAULT)
			or (self.remove_full_hp and _hp == 100 and pprio == OtherTargetList.PRIO_DEFAULT)) then
		table_insert(self.players, 1, { name = _name, hp = _hp, career = _career, decay = OtherTargetList.DEFAULT_DECAY, prio = pprio })
		--DEBUG(L"Inserted "..self.players[1].name..L"; returning true")
		return true
	end
	--DEBUG(_name..L" is new; but returning false because dead or full")
	return false
end


function OtherTargetList:update(_elapsed)
	-- fix id's
	for i, p in ipairs(self.players) do
		p.id = i
	end
	if (self.sort_players) then
		-- sort
		table_sort(self.players,
			function(a, b)
				if (a.prio == b.prio) then
					if (a.hp == b.hp) then
						return a.id < b.id
					else
						return a.hp < b.hp
					end
				else
					return a.prio > b.prio
				end
			end
		)
	else
		-- move up all locked
		table_sort(self.players,
			function(a, b)
				if (a.prio == b.prio) then
					return a.id < b.id
				else
					return a.prio > b.prio
				end
			end
		)
	end

	local i = 1
	while (i <= #self.players) do
		local p = self.players[i]
		if (p.prio == OtherTargetList.PRIO_DEFAULT) then
			p.decay = p.decay - _elapsed
		end
		if (p.decay <= 0)
		or (self.remove_dead and p.hp == 0 and p.prio == OtherTargetList.PRIO_DEFAULT)
		or (self.remove_full_hp and p.hp == 100 and p.prio == OtherTargetList.PRIO_DEFAULT) then
			--DEBUG(L"Removing"..self.players[i].name)
			table_remove(self.players, i)	-- only remove normal dead players
		else
			i = i + 1
		end
	end

	-- remove extras
	while (#self.players > self.max_players) do
		table_remove(self.players)
	end
end