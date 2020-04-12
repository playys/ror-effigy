if not Effigy then Effigy = {} end
local Addon = Effigy

function Addon.RegisterStateInfoForGuild()
	local guildxp = EffigyState:new("GuildXP")
	guildxp:updateFunction(Addon.UpdateGuildXP)
	guildxp:updateEvent(SystemData.Events.GUILD_EXP_UPDATED)
end

function Addon.UpdateGuildXP()
	local state = EffigyState:GetState("GuildXP")
	if not state then return end
	
	if (0 == GameData.Guild.m_GuildID) then
		state:SetValid(0)
		state:SetValue(0)
	else
		state:SetValue(GameData.Guild.m_GuildExpInCurrentLevel)
		state:SetMax(GameData.Guild.m_GuildExpNeeded)
		state:SetTitle(towstring(GameData.Guild.m_GuildName))
		--state:SetLevel(L""..GameData.Guild.m_GuildRank)
		state:SetExtraInfo("level", L""..GameData.Guild.m_GuildRank)
		state:SetValid(1)
	end
	state:render()
end