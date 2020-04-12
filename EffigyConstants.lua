-- forked of HudUnitFrames: http://war.curseforge.com/addons/huduf/
-- Credits @Metaphaze & Tannecurse

if not Effigy then Effigy = {} end
local Addon = Effigy

Addon.ConvertToCareerId = {
	["Warrior Priest"] = GameData.CareerLine.WARRIOR_PRIEST,
	["Disciple of Khaine"] = GameData.CareerLine.DISCIPLE or GameData.CareerLine.BLOOD_PRIEST,
	["Swordmaster"] = GameData.CareerLine.SWORDMASTER,
	["Black Orc"] =  GameData.CareerLine.BLACK_ORC,
	["Ironbreaker"] =  GameData.CareerLine.IRON_BREAKER,
	["Sorceress"] = GameData.CareerLine.SORCERER,
	["Bright Wizard"] = GameData.CareerLine.BRIGHT_WIZARD,
	["Shaman"] = GameData.CareerLine.SHAMAN,
	["Archmage"] =  GameData.CareerLine.ARCHMAGE,
	["Witch Hunter"] = GameData.CareerLine.WITCH_HUNTER,
	["Witch Elf"] = GameData.CareerLine.WITCH_ELF or GameData.CareerLine.ASSASSIN,
	["Marauder"] = GameData.CareerLine.MARAUDER or GameData.CareerLine.WARRIOR,
	["Blackguard"] = GameData.CareerLine.BLACKGUARD or GameData.CareerLine.SHADE,
	["Shadow Warrior"] = GameData.CareerLine.SHADOW_WARRIOR,
	["Knight of the Blazing Sun"] = GameData.CareerLine.KNIGHT,
	["Magus"] = GameData.CareerLine.MAGUS,
	["White Lion"] = GameData.CareerLine.WHITE_LION or GameData.CareerLine.SEER,
	["Chosen"] = GameData.CareerLine.CHOSEN,
	["Squig Herder"] = GameData.CareerLine.SQUIG_HERDER,
	["Zealot"] = GameData.CareerLine.ZEALOT,
	["Engineer"] = GameData.CareerLine.ENGINEER,
	["Rune Priest"] = GameData.CareerLine.RUNE_PRIEST,
	["Slayer"] = GameData.CareerLine.SLAYER,
	["Choppa"] = GameData.CareerLine.CHOPPA,
}

-- scenarios use different ids
Addon.ConvertCareerIDToLine = {
	[20] = GameData.CareerLine.IRON_BREAKER,
	[100] = GameData.CareerLine.SWORDMASTER,
	[64] = GameData.CareerLine.CHOSEN,
	[24] = GameData.CareerLine.BLACK_ORC,
	[60] = GameData.CareerLine.WITCH_HUNTER,
	[102] = GameData.CareerLine.WHITE_LION or GameData.CareerLine.SEER,
	[65] = GameData.CareerLine.MARAUDER or GameData.CareerLine.WARRIOR,
	[105] = GameData.CareerLine.WITCH_ELF or GameData.CareerLine.ASSASSIN,
	[62] = GameData.CareerLine.BRIGHT_WIZARD,
	[67] = GameData.CareerLine.MAGUS,
	[107] = GameData.CareerLine.SORCERER,
	[23] = GameData.CareerLine.ENGINEER,
	[101] = GameData.CareerLine.SHADOW_WARRIOR,
	[27] = GameData.CareerLine.SQUIG_HERDER,
	[63] = GameData.CareerLine.WARRIOR_PRIEST,
	[106] = GameData.CareerLine.DISCIPLE or GameData.CareerLine.BLOOD_PRIEST,
	[103] = GameData.CareerLine.ARCHMAGE,
	[26] = GameData.CareerLine.SHAMAN,
	[22] = GameData.CareerLine.RUNE_PRIEST,
	[66] = GameData.CareerLine.ZEALOT,
	[104] = GameData.CareerLine.BLACKGUARD or GameData.CareerLine.SHADE,
	[61] = GameData.CareerLine.KNIGHT,
	[21] = GameData.CareerLine.SLAYER,
	[25] = GameData.CareerLine.CHOPPA,
}

Addon.CareerNames = {
	[0] = { "NPC","NPC"},
	[1] = { tostring(CareerNames[1].name), "IB" },
	[2] = { tostring(CareerNames[2].name), "SLA" },
	[3] = { tostring(CareerNames[3].name), "RP" },
	[4] = { tostring(CareerNames[4].name), "ENG" },
	[5] = { tostring(CareerNames[5].name), "BO" },
	[6] = { tostring(CareerNames[6].name), "COP" },
	[7] = { tostring(CareerNames[7].name), "SHA" },
	[8] = { tostring(CareerNames[8].name), "SH" },
	[9] = { tostring(CareerNames[9].name), "WH" },
	[10] = { tostring(CareerNames[10].name), "KN" },
	[11] = { tostring(CareerNames[11].name), "BW" },
	[12] = { tostring(CareerNames[12].name), "WP" },
	[13] = { tostring(CareerNames[13].name), "CHO" },
	[14] = { tostring(CareerNames[14].name), "MAR" },
	[15] = { tostring(CareerNames[15].name), "ZEL" },
	[16] = { tostring(CareerNames[16].name), "MAG" },
	[17] = { tostring(CareerNames[17].name), "SM" },
	[18] = { tostring(CareerNames[18].name), "SW" },
	[19] = { tostring(CareerNames[19].name), "WL" },
	[20] = { tostring(CareerNames[20].name), "AM" },
	[21] = { tostring(CareerNames[21].name), "BG" },
	[22] = { tostring(CareerNames[22].name), "WE" },
	[23] = { tostring(CareerNames[23].name), "DOK" },
	[24] = { tostring(CareerNames[24].name), "SRC" }
}



-- Some settings that allows us to draw the bar correctly.  Max is the
-- max resource value for that class.  flip determines if they start at
-- the low or the high value (for alphaizing).  Default is a default value
-- to use right after a world-load or reload UI when it seems to not provide
-- one (it only provides it on a Resource Update)

Addon.CareerResourceSettings = 
{
	[ GameData.CareerLine.WARRIOR_PRIEST ] = { max = 250, flip = false, default=250, pet=0, ctype="Heal" },
	[ GameData.CareerLine.DISCIPLE or GameData.CareerLine.BLOOD_PRIEST ] = { max = 250, flip = false, default=250, pet=0, ctype="Heal" },	-- 1.3.6 547
	[ GameData.CareerLine.SWORDMASTER ] = { max = 2, flip = true, default=0, pet=0, ctype="Tank" },
	[ GameData.CareerLine.BLACK_ORC ] = { max = 2, flip = true, default=0, pet=0, ctype="Tank" },
	[ GameData.CareerLine.IRON_BREAKER ] = { max = 100, flip = true, default=0, pet=0, ctype="Tank" },
	[ GameData.CareerLine.SORCERER ] = { max = 100, flip = true, default=0, pet=0, ctype="RDPS" },
	[ GameData.CareerLine.BRIGHT_WIZARD ] = { max = 100, flip = true, default=0, pet=0, ctype="RDPS" },
 -- It's actually '10' as a value, but 5 for each 'side' for the next two
	[ GameData.CareerLine.SHAMAN ] = { max = 5, flip = true, default=0, pet=0, ctype="Heal" }, -- 5 vs. 10
	[ GameData.CareerLine.ARCHMAGE ] = { max = 5, flip = true, default=0, pet=0, ctype="Heal" }, -- 5 vs. 10
	[ GameData.CareerLine.WITCH_HUNTER ] = { max = 5, flip = true, default=0, pet=0, ctype="MDPS" },
	[ GameData.CareerLine.WITCH_ELF or GameData.CareerLine.ASSASSIN ] = { max = 5, flip = true, default=0, pet=0, ctype="MDPS"},				-- 1.3.6 547
	[ GameData.CareerLine.MARAUDER or GameData.CareerLine.WARRIOR ] = { max = 0, flip = false,default=0, pet=0, ctype="MDPS" },				-- MARAUDER
	[ GameData.CareerLine.BLACKGUARD or GameData.CareerLine.SHADE ] = { max = 100, flip = false,default=0, pet=0, ctype="Tank" },				-- BLACKGUARD
	[ GameData.CareerLine.SHADOW_WARRIOR ] = { max = 0, flip = false,default=0, pet=0, ctype="RDPS" },
	[ GameData.CareerLine.ENGINEER ] = { max = 0, flip = false,default=0, pet=1, ctype="RDPS" },
	[ GameData.CareerLine.KNIGHT ] = { max = 0, flip = false,default=0, pet=0, ctype="Tank" },
	[ GameData.CareerLine.SLAYER ] = { max = 100, flip = false,default=0, pet=0, ctype="MDPS" },	
	[ GameData.CareerLine.CHOPPA ] = { max = 100, flip = false,default=0, pet=0, ctype="MDPS" },
	[ GameData.CareerLine.MAGUS ] = { max = 0, flip = false,default=0, pet=1, ctype="RDPS" },
	[ GameData.CareerLine.WHITE_LION or GameData.CareerLine.SEER ] = { max = 0, flip = false,default=0, pet=1, ctype="MDPS" }, 				-- WHITE_LION
	[ GameData.CareerLine.CHOSEN ] = { max = 0, flip = false,default=0, pet=0, ctype="Tank" },
	[ GameData.CareerLine.SQUIG_HERDER ] = { max = 0, flip = false,default=0, pet=1, ctype="RDPS" },
	[ GameData.CareerLine.ZEALOT ] = { max = 0, flip = false,default=0, pet=0, ctype="Heal" },
	[ GameData.CareerLine.RUNE_PRIEST ] = { max = 0, flip = false,default=0, pet=0, ctype="Heal" }
	--[ 7 ] = { max = 0, flip = false,default=0, pet=0, ctype="Heal" }
}
