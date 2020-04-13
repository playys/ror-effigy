if not Effigy then Effigy = {} end
local Addon = Effigy
if not Addon.Rules then Addon.Rules = {} end
--if not Addon.SavedRules then Addon.SavedRules = {} end

Addon.RuleTypes = {"Alpha", "Colors", "Textures", "Visibility"}
local RuleCache = {}
Addon.RuleCache = RuleCache -- Debugging

local ipairs = ipairs
local pairs = pairs

--
-- Factory Presets
--
local function GetFactoryPresets()
	return 	{
		Alpha =
		{
			Rules = 
			{
				-- Targets
				["Range-OutOf"] = 
				{
					enabled = true,
					filterParam = "65535",
					name = "Range-OutOf",
					filter = "RangeMax",
					scope = "any",
					priority = 3,
					payload = 0.4,
				},

				-- Full
				["Range-Below65"] = 
				{
					enabled = true,
					filterParam = "<65",
					name = "Range-Below65",
					filter = "RangeMax",
					scope = "any",
					priority = 4,
					payload = 1,
				},
				["Range-Below100"] = 
				{
					enabled = true,
					filterParam = "<100",
					name = "Range-Below100",
					filter = "RangeMax",
					scope = "any",
					priority = 5,
					payload = 0.825,
				},
				["Range-Below150"] = 
				{
					enabled = true,
					filterParam = "<150",
					name = "Range-Below150",
					filter = "RangeMax",
					scope = "any",
					priority = 9,
					payload = 0.75,
				},
				["Range-InRange"] = 
				{
					enabled = true,
					filterParam = "<65535",
					name = "Range-InRange",
					filter = "RangeMax",
					scope = "any",
					priority = 10,
					payload = 0.6,
				},

				-- Healer without 65
				["Range-FTbelow150"] = 
				{
					enabled = true,
					filterParam = "<150",
					name = "Range-Below150",
					filter = "RangeMax",
					scope = "any",
					priority = 9,
					payload = 1,
				},
				["Range-FTinRange"] = 
				{
					enabled = true,
					filterParam = "<65535",
					name = "Range-InRange",
					filter = "RangeMax",
					scope = "any",
					priority = 10,
					payload = 0.7,
				},
				
				
				-- Group
				["Range-isNotInSameRegion"] = 
				{
					enabled = true,
					filterParam = "65537",
					name = "Range-isNotInSameRegion",
					filter = "RangeMax",
					scope = "any",
					priority = 1,
					payload = 0.2,
				},
				["Range-isDistant"] = 
				{
					enabled = true,
					filterParam = "65536",
					name = "Range-isDistant",
					filter = "RangeMax",
					scope = "any",
					priority = 1,
					payload = 0.3,
				},
				["Range-GrpOutOf"] = 
				{
					enabled = true,
					filterParam = ">150",
					name = "Range-GrpOutOf",
					filter = "RangeMax",
					scope = "any",
					priority = 2,
					payload = 0.6,
				},
				["Range-Grp-100"] = 
				{
					enabled = true,
					filterParam = "<101",
					name = "Range-Grp-100",
					filter = "RangeMax",
					scope = "any",
					priority = 2,
					payload = 1,
				},
				["Range-GrpInRange"] = 
				{
					enabled = true,
					filterParam = "<151",
					name = "Range-GrpInRange",
					filter = "RangeMax",
					scope = "any",
					priority = 3,
					payload = 0.8,
				},


			},
			RuleSets = 
			{
				["Range-Targets"] = 
				{
					name = "Range-Targets",
					rules = 
					{
						--["Range-isNotInSameRegion"] = "Range-isNotInSameRegion",
						--["Range-isDistant"] = "Range-isDistant",
						["Range-Below65"] = "Range-Below65",
						["Range-Below100"] = "Range-Below100",
						["Range-Below150"] = "Range-Below150",
						["Range-InRange"] = "Range-InRange",
						
						["Range-OutOf"] = "Range-OutOf",
						
					},
				},
				["Range-FriendlyTargets"] = 
				{
					name = "Range-FriendlyTargets",
					rules = 
					{
						["Range-OutOf"] = "Range-OutOf",
						["Range-FTbelow150"] = "Range-FTbelow150",
						["Range-FTinRange"] = "Range-FTinRange",
					},
				},
				["Range-Group"] = -- smaller set for healers
				{
					name = "Range-Group",
					rules = 
					{
						["Range-isNotInSameRegion"] = "Range-isNotInSameRegion",
						["Range-isDistant"] = "Range-isDistant",
						["Range-Grp-100"] = "Range-Grp-100",	-- GroupHeal Range
						["Range-GrpInRange"] = "Range-InRange",	-- Single Target Heal Range

						["Range-GrpOutOf"] = "Range-GrpOutOf",	-- higher alpha then on targets is needed since this is no info too
					},
				},
			}
		},
		Colors =
		{
			Rules =
			{
				["career-ib"] = 
				{
					enabled = true,
					filterParam = "IB",
					name = "career-ib",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-ib",
				},
				["career-sla"] = 
				{
					enabled = true,
					filterParam = "SLA",
					name = "career-sla",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-sla",
				},
				["career-rp"] = 
				{
					enabled = true,
					filterParam = "RP",
					name = "career-rp",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-rp",
				},
				["career-eng"] = 
				{
					enabled = true,
					filterParam = "ENG",
					name = "career-eng",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-eng",
				},
				["career-bo"] = 
				{
					enabled = true,
					filterParam = "BO",
					name = "career-bo",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-bo",
				},
				["career-cop"] = 
				{
					enabled = true,
					filterParam = "COP",
					name = "career-cop",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-cop",
				},
				["career-sha"] = 
				{
					enabled = true,
					filterParam = "SHA",
					name = "career-sha",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-sha",
				},
				["career-sh"] = 
				{
					enabled = true,
					filterParam = "SH",
					name = "career-sh",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-sh",
				},
				["career-wh"] = 
				{
					enabled = true,
					filterParam = "WH",
					name = "career-wh",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-wh",
				},
				["career-kn"] = 
				{
					enabled = true,
					filterParam = "KN",
					name = "career-kn",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-kn",
				},
				["career-bw"] = 
				{
					enabled = true,
					filterParam = "BW",
					name = "career-bw",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-bw",
				},
				["career-wp"] = 
				{
					enabled = true,
					filterParam = "WP",
					name = "career-wp",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-wp",
				},
				["career-cho"] = 
				{
					enabled = true,
					filterParam = "CHO",
					name = "career-cho",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-cho",
				},
				["career-mar"] = 
				{
					enabled = true,
					filterParam = "MAR",
					name = "career-mar",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-mar",
				},
				["career-zel"] = 
				{
					enabled = true,
					filterParam = "ZEL",
					name = "career-zel",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-zel",
				},
				["career-mag"] = 
				{
					enabled = true,
					filterParam = "MAG",
					name = "career-mag",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-mag",
				},
				["career-sm"] = 
				{
					enabled = true,
					filterParam = "SM",
					name = "career-sm",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-sm",
				},
				["career-sw"] = 
				{
					enabled = true,
					filterParam = "SW",
					name = "career-sw",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-sw",
				},
				["career-wl"] = 
				{
					enabled = true,
					filterParam = "WL",
					name = "career-wl",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-wl",
				},
				["career-am"] = 
				{
					enabled = true,
					filterParam = "AM",
					name = "career-am",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-am",
				},
				["career-bg"] = 
				{
					enabled = true,
					filterParam = "BG",
					name = "career-bg",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-bg",
				},
				["career-we"] = 
				{
					enabled = true,
					filterParam = "WE",
					name = "career-we",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-we",
				},
				["career-dok"] = 
				{
					enabled = true,
					filterParam = "DOK",
					name = "career-dok",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-dok",
				},
				["career-src"] = 
				{
					enabled = true,
					filterParam = "SRC",
					name = "career-src",
					filter = "isClass",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "career-src",
				},
				["archtype-tank"] = 
				{
					enabled = true,
					filterParam = "Tank",
					name = "archtype-tank",
					filter = "isArchetype",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "archtype-tank",
				},
				["archtype-mdps"] = 
				{
					enabled = true,
					filterParam = "MDPS",
					scope = "any",
					name = "archtype-mdps",
					filter = "isArchetype",
					priority = 5,
					enable = true,
					payload = "archtype-mdps",
				},
				["isDeadRed"] = 
				{
					enabled = true,
					filterParam = "0",
					name = "isDeadRed",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = "__RED_DARK",
				},
				["isDeadNotBlack"] = 
				{
					enabled = true,
					filterParam = ">0",
					name = "isDeadNotBlack",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = "__BLACK",
				},
				--[[ ["buffs-hot"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-hot",
					filter = "isHealingByMe",
					scope = "any",
					priority = 5,
					payload = "buffs-hot",
				},
				["buffs-blessed"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-blessed",
					filter = "isBlessedByMe",
					scope = "any",
					priority = 3,
					payload = "buffs-blessing",
				},
				["buffs-buffed"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-buffed",
					filter = "isBuffedByMe",
					scope = "any",
					priority = 6,
					payload = "buffs-buff",
				},
				["buffs-cure"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-cure",
					filter = "isCureableByMe",
					scope = "any",
					priority = 2,
					payload = "buffs-cureable",
				},
				]]--
				isMyTarget = 
				{
					enabled = true,
					filterParam = "",
					name = "isMyTarget",
					filter = "isTargeted",
					scope = "any",
					priority = 1,
					payload = "__LIGHTGREY",
				},
				isMyTargetNOT = 
				{
					enabled = true,
					filterParam = "not",
					name = "isMyTargetNOT",
					filter = "isTargeted",
					scope = "any",
					priority = 1,
					payload = "__BLACK",
				},
				["mechanic-71-90"] = 
				{
					enabled = true,
					filterParam = ">71",
					name = "mechanic-71-90",
					filter = "isCurrentValue",
					scope = "any",
					priority = 3,
					payload = "mechanic-medhigh",
				},
				["mechanic-100"] = 
				{
					enabled = true,
					filterParam = ">100",
					name = "mechanic-100",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = "mechanic-high",
				},
				["mechanic-50"] = 
				{
					enabled = true,
					filterParam = ">50",
					name = "mechanic-50",
					filter = "isCurrentValue",
					scope = "any",
					priority = 7,
					payload = "mechanic-med",
				},
				["mechanic-75"] = 
				{
					enabled = true,
					filterParam = ">75",
					name = "mechanic-75",
					filter = "isCurrentValue",
					scope = "any",
					priority = 3,
					payload = "mechanic-medhigh",
				},
				["mechanic-25"] = 
				{
					enabled = true,
					filterParam = ">25",
					name = "mechanic-25",
					filter = "isCurrentValue",
					scope = "any",
					priority = 8,
					payload = "mechanic-lowest",
				},
				["archtype-healers"] = 
				{
					enabled = true,
					filterParam = "Heal",
					scope = "any",
					name = "archtype-healers",
					filter = "isArchetype",
					enable = true,
					priority = 5,
					payload = "archtype-heal",
				},
				["mechanic-31-70"] = 
				{
					enabled = true,
					filterParam = ">31",
					name = "mechanic-31-70",
					filter = "isCurrentValue",
					scope = "any",
					priority = 5,
					payload = "mechanic-med",
				},
				["mechanic-berserk-25-75"] = 
				{
					enabled = true,
					filterParam = ">25",
					name = "mechanic-berserk-25-75",
					filter = "isCurrentValue",
					scope = "any",
					priority = 5,
					payload = "mechanic-med",
				},
				["mechanic-berserk-75-100"] = 
				{
					enabled = true,
					filterParam = ">75",
					name = "mechanic-berserk-75-100",
					filter = "isCurrentValue",
					scope = "any",
					priority = 4,
					payload = "mechanic-high",
				},
				["mechanic-11-30"] = 
				{
					enabled = true,
					filterParam = ">11",
					name = "mechanic-11-30",
					filter = "isCurrentValue",
					scope = "any",
					priority = 7,
					payload = "mechanic-low",
				},
				["mechanic-1-10"] = 
				{
					enabled = true,
					filterParam = ">1",
					name = "mechanic-1-10",
					filter = "isCurrentValue",
					scope = "any",
					priority = 9,
					payload = "mechanic-lowest",
				},
				["mechanic-91-100"] = 
				{
					enabled = true,
					filterParam = ">91",
					name = "mechanic-91-100",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = "mechanic-high",
				},
				["archtype-rdps"] = 
				{
					enabled = true,
					filterParam = "RDPS",
					name = "archtype-rdps",
					filter = "isArchetype",
					scope = "any",
					priority = 5,
					enable = true,
					payload = "archtype-rdps",
				},
				["Range-OutOf"] =
				{
					enabled = true,
					filterParam = "65535",
					name = "Range-OutOf",
					filter = "RangeMax",
					scope = "any",
					priority = 1,
					enable = true,
					payload = "rangelayer-oor",		
				},
				["Range-InRange"] =
				{
					enabled = true,
					filterParam = "<65535",
					name = "Range-InRange",
					filter = "RangeMax",
					scope = "any",
					priority = 3,
					enable = true,
					payload = "rangelayer-inrange",		
				},
				["Range-Healer-OOR"] = 
				{
					enabled = true,
					filterParam = ">=150",
					name = "Range-Healer-OOR",
					filter = "RangeMax",
					scope = "any",
					priority = 2,
					payload = "_LIGHTRED",
				},
				["Range-Healer-SingleHeal"] = 
				{
					enabled = true,
					filterParam = "<=150",
					name = "Range-Healer-SingleHeal",
					filter = "RangeMax",
					scope = "any",
					priority = 2,
					payload = "__YELLOW",
				},
				["Range-Healer-Distant"] = 
				{
					enabled = true,
					filterParam = "",
					name = "Range-Healer-Distant",
					filter = "IsDistant",
					scope = "any",
					priority = 1,
					payload = "__BLUE",
				},
				["Range-Healer-Groupheal"] = 
				{
					enabled = true,
					filterParam = "<= 100",
					name = "Range-Healer-Groupheal",
					filter = "RangeMax",
					scope = "any",
					priority = 1,
					payload = "__LIGHTGREY",
				},
				["percent-red"] = 
				{
					enabled = true,
					filterParam = "<=25",
					name = "percent-red",
					filter = "statePercent",
					scope = "any",
					priority = 1,
					payload = "__RED_SAT",
				},
				["percent-orange"] = 
				{
					enabled = true,
					filterParam = "<=50",
					name = "percent-orange",
					filter = "statePercent",
					scope = "any",
					priority = 2,
					payload = "__ORANGE_DARK",
				},
				["percent-yellow"] = 
				{
					enabled = true,
					filterParam = ">50",
					name = "percent-yellow",
					filter = "statePercent",
					scope = "any",
					priority = 2,
					payload = "__YELLOW_DARK",
				},
				["percent-green"] = 
				{
					enabled = true,
					filterParam = ">=80",
					name = "percent-green",
					filter = "statePercent",
					scope = "any",
					priority = 1,
					payload = "__GREEN_SAT",
				},
				LimboLife0 = 
				{
					enabled = true,
					filterParam = "<=10",
					name = "LimboLife0",
					filter = "statePercent",
					scope = "any",
					priority = 1,
					payload = "Life0",
				},
				LimboLife10 = 
				{
					enabled = true,
					filterParam = "<=20",
					name = "LimboLife10",
					filter = "statePercent",
					scope = "any",
					priority = 2,
					payload = "Life10",
				},
				LimboLife20 = 
				{
					enabled = true,
					filterParam = "<=30",
					name = "LimboLife20",
					filter = "statePercent",
					scope = "any",
					priority = 3,
					payload = "Life20",
				},
				LimboLife30 = 
				{
					enabled = true,
					filterParam = "<=40",
					name = "LimboLife30",
					filter = "statePercent",
					scope = "any",
					priority = 4,
					payload = "Life30",
				},
				LimboLife40 = 
				{
					enabled = true,
					filterParam = "<=50",
					name = "LimboLife40",
					filter = "statePercent",
					scope = "any",
					priority = 5,
					payload = "Life40",
				},
				LimboLife50 = 
				{
					enabled = true,
					filterParam = ">50",
					name = "LimboLife50",
					filter = "statePercent",
					scope = "any",
					priority = 6,
					payload = "Life50",
				},
				LimboLife60 = 
				{
					enabled = true,
					filterParam = ">60",
					name = "LimboLife60",
					filter = "statePercent",
					scope = "any",
					priority = 5,
					payload = "Life60",
				},
				LimboLife70 = 
				{
					enabled = true,
					filterParam = ">70",
					name = "LimboLife70",
					filter = "statePercent",
					scope = "any",
					priority = 4,
					payload = "Life70",
				},
				LimboLife80 = 
				{
					enabled = true,
					filterParam = ">80",
					name = "LimboLife80",
					filter = "statePercent",
					scope = "any",
					priority = 3,
					payload = "Life80",
				},
				LimboLife90 = 
				{
					enabled = true,
					filterParam = ">90",
					name = "LimboLife90",
					filter = "statePercent",
					scope = "any",
					priority = 2,
					payload = "Life90",
				},
				LimboLife100 = 
				{
					enabled = true,
					filterParam = ">99",
					name = "LimboLife100",
					filter = "statePercent",
					scope = "any",
					priority = 1,
					payload = "Life100",
				},
				grudge0 = 
				{
					enabled = true,
					filterParam = "<25",
					name = "grudge0",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = "mechanic-lowest",
				},
				grudge25 = 
				{
					enabled = true,
					filterParam = "<50",
					name = "grudge25",
					filter = "isCurrentValue",
					scope = "any",
					priority = 2,
					payload = "mechanic-low",
				},
				grudge50 = 
				{
					enabled = true,
					filterParam = "<75",
					name = "grudge50",
					filter = "isCurrentValue",
					scope = "any",
					priority = 3,
					payload = "mechanic-med",
				},
				grudge75 = 
				{
					enabled = true,
					filterParam = ">=75",
					name = "grudge75",
					filter = "isCurrentValue",
					scope = "any",
					priority = 2,
					payload = "mechanic-medhigh",
				},
				grudge100 = 
				{
					enabled = true,
					filterParam = ">99",
					name = "grudge100",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = "mechanic-high",
				},				
			},
			RuleSets =
			{
				IsMyTarget = 
				{
					name = "IsMyTarget",
					rules = 
					{
						isMyTarget = "isMyTarget",
						isMyTargetNOT = "isMyTargetNOT",
					},
				},
				["RedWhenDead"] = 
				{
					name = "RedWhenDead",
					rules = 
					{
						isDeadRed = "isDeadRed",
						isDeadNotBlack = "isDeadNotBlack",
					},
				},
				["mechanic-hate"] = 
				{
					name = "mechanic-hate",
					rules = 
					{
						["mechanic-50"] = "mechanic-50",
						["mechanic-100"] = "mechanic-100",
						["mechanic-75"] = "mechanic-75",
						["mechanic-25"] = "mechanic-25",
					},
				},
				["archetype-colors"] = 
				{
					name = "archetype-colors",
					rules = 
					{
						["archtype-tank"] = "archtype-tank",
						["archtype-healers"] = "archtype-healers",
						["archtype-mdps"] = "archtype-mdps",
						["archtype-rdps"] = "archtype-rdps",
					},
				},
				["career-colors"] = 
				{
					name = "career-colors",
					rules = 
					{
						["career-ib"] = "career-ib",
						["career-sla"] = "career-sla",
						["career-rp"] = "career-rp",
						["career-eng"] = "career-eng",
						["career-bo"] = "career-bo",
						["career-cop"] = "career-cop",
						["career-sha"] = "career-sha",
						["career-sh"] = "career-sh",
						["career-wh"] = "career-wh",
						["career-kn"] = "career-kn",
						["career-bw"] = "career-bw",
						["career-wp"] = "career-wp",
						["career-cho"] = "career-cho",
						["career-mar"] = "career-mar",
						["career-zel"] = "career-zel",
						["career-mag"] = "career-mag",
						["career-sm"] = "career-sm",
						["career-sw"] = "career-sw",
						["career-wl"] = "career-wl",
						["career-am"] = "career-am",
						["career-bg"] = "career-bg",
						["career-we"] = "career-we",
						["career-dok"] = "career-dok",
						["career-src"] = "career-src",
					},
				},
				--[[buffs = 
				{
					name = "buffs",
					rules = 
					{
						["buffs-blessed"] = "buffs-blessed",
						["buffs-cure"] = "buffs-cure",
						["buffs-buffed"] = "buffs-buffed",
						["buffs-hot"] = "buffs-hot",
					},
				},
				]]--
				["mechanic-berserk"] = 
				{
					name = "mechanic-berserk",
					rules = 
					{
						["mechanic-berserk-25-75"] = "mechanic-berserk-25-75",
						["mechanic-berserk-75-100"] = "mechanic-berserk-75-100",
					},
				},
				["mechanic-combustion"] = 
				{
					name = "mechanic-combustion",
					rules = 
					{
						["mechanic-11-30"] = "mechanic-11-30",
						["mechanic-31-70"] = "mechanic-31-70",
						["mechanic-91-100"] = "mechanic-91-100",
						["mechanic-1-10"] = "mechanic-1-10",
						["mechanic-71-90"] = "mechanic-71-90",
					},
				},
				["Range"] = 
				{
					name = "Range",
					rules = 
					{
						["Range-OutOf"] = "Range-OutOf",
						["Range-InRange"] = "Range-InRange",
					},
				},
				["Range-Healer"] = 
				{
					name = "Range-Healer",
					rules = 
					{
						["Range-Healer-Groupheal"] = "Range-Healer-Groupheal",
						["Range-Healer-SingleHeal"] = "Range-Healer-SingleHeal",
						["Range-Healer-OOR"] = "Range-Healer-OOR",
						["Range-Healer-Distant"] = "Range-Healer-Distant",
					},
				},
				["percent-trafficlights"] = 
				{
					name = "percent-trafficlights",
					rules = 
					{
						["percent-green"] = "percent-green",
						["percent-yellow"] = "percent-yellow",
						["percent-orange"] = "percent-orange",
						["percent-red"] = "percent-red",
					},
				},
				LimboLife = 
				{
					name = "LimboLife",
					rules = 
					{
						LimboLife40 = "LimboLife40",
						LimboLife80 = "LimboLife80",
						LimboLife50 = "LimboLife50",
						LimboLife20 = "LimboLife20",
						LimboLife10 = "LimboLife10",
						LimboLife100 = "LimboLife100",
						LimboLife90 = "LimboLife90",
						LimboLife30 = "LimboLife30",
						LimboLife60 = "LimboLife60",
						LimboLife0 = "LimboLife0",
						LimboLife70 = "LimboLife70",
					},
				},
				["mechanic-grudge"] = 
				{
					name = "mechanic-grudge",
					rules = 
					{
						grudge25 = "grudge25",
						grudge100 = "grudge100",
						grudge0 = "grudge0",
						grudge50 = "grudge50",
						grudge75 = "grudge75",
					},
				},
			}
		},
		Textures = {Rules = {}, RuleSets = {}},
		Visibility =
		{
			Rules = 
			{
				--[[ ["buffs-blessed"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-blessed",
					filter = "isBlessedByMe",
					scope = "any",
					priority = 3,
					payload = true,
				},
				["buffs-buffed"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-buffed",
					filter = "isBuffedByMe",
					scope = "any",
					priority = 6,
					payload = true,
				},
				["buffs-cure"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-cure",
					filter = "isCureableByMe",
					scope = "any",
					priority = 2,
					payload = true,
				},
				["buffs-hot"] = 
				{
					enabled = true,
					filterParam = "1",
					name = "buffs-hot",
					filter = "isHealingByMe",
					scope = "any",
					priority = 5,
					payload = true,
				},
				]]--
				["curr-HideMax"] = 
				{
					enabled = true,
					filterParam = "max",
					name = "curr-HideMax",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = false,
				},
				["curr-HideZero"] = 
				{
					enabled = true,
					filterParam = "0",
					name = "curr-HideZero",
					filter = "isCurrentValue",
					scope = "any",
					priority = 1,
					payload = false,
				},
				["curr-ShowPositive"] = 
				{
					enabled = true,
					filterParam = ">0",
					name = "curr-ShowPositive",
					filter = "isCurrentValue",
					scope = "any",
					priority = 2,
					payload = true,
				},
				["showPC"] = 
				{
					enabled = true,
					filterParam = "",
					name = "showPC",
					filter = "isPC",
					scope = "any",
					priority = 1,
					payload = true,
				},
				["hideNPC"] = 
				{
					enabled = true,
					filterParam = "",
					name = "hideNPC",
					filter = "isNPC",
					scope = "any",
					priority = 1,
					payload = false,
				},
				["ShowIfDead"] = 
				{
					enabled = true,
					filterParam = ">0",
					name = "ShowIfDead",
					filter = "statePercent",
					scope = "any",
					priority = 1,
					payload = false,
				},
				["HideIfDead"] = 
				{
					enabled = true,
					filterParam = "0",
					name = "HideIfDead",
					filter = "statePercent",
					scope = "any",
					priority = 1,
					payload = false,
				},
				["HideIfSelf"] = 
				{
					enabled = true,
					filterParam = "",
					name = "HideIfSelf",
					filter = "isSelf",
					scope = "any",
					priority = 1,
					payload = false,
				},
				["ShowIfNotSelf"] = 
				{
					enabled = true,
					filterParam = "not",
					name = "ShowIfNotSelf",
					filter = "isSelf",
					scope = "any",
					priority = 1,
					payload = true,
				},
				ShowGrouped = 
				{
					enabled = true,
					filterParam = "",
					name = "ShowGrouped",
					filter = "isGroup",
					scope = "any",
					priority = 1,
					payload = true,
				},
				HideNotGrouped = 
				{
					enabled = true,
					filterParam = "false",
					name = "HideNotGrouped",
					filter = "isGroup",
					scope = "any",
					priority = 1,
					payload = false,
				},
				HideIfFull = 
				{
					enabled = true,
					filterParam = "100",
					name = "HideIfFull",
					filter = "statePercent",
					scope = "any",
					priority = 2,
					payload = false,
				},
				OutOfCombat = 
				{
					enabled = true,
					filterParam = "not",
					name = "OutOfCombat",
					filter = "isInCombat",
					scope = "any",
					priority = 1,
					payload = false,
				},
				ShowIfNotFull = 
				{
					enabled = true,
					filterParam = "<=99",
					name = "ShowIfNotFull",
					filter = "statePercent",
					scope = "any",
					priority = 3,
					payload = true,
				},
				["InCombat"] = 
				{
					enabled = true,
					filterParam = "",
					name = "InCombat",
					filter = "isInCombat",
					scope = "any",
					priority = 1,
					payload = true,
				},
			},
			RuleSets =
			{
				--[[ ["buffs-blessed"] = 
				{
					name = "buffs-blessed",
					rules = 
					{
						["buffs-blessed"] = "buffs-blessed",
					},
				},
				["buffs-buffed"] = 
				{
					name = "buffs-buffed",
					rules = 
					{
						["buffs-buffed"] = "buffs-buffed",
					},
				},
				["buffs-cure"] = 
				{
					name = "buffs-cure",
					rules = 
					{
						["buffs-cure"] = "buffs-cure",
					},
				},
				["buffs-hot"] = 
				{
					name = "buffs-hot",
					rules = 
					{
						["buffs-hot"] = "buffs-hot",
					},
				},
				]]--
				["curr-hideWhenZeroMax"] = 
				{
					name = "curr-hideWhenZeroMax",
					rules = 
					{
						["curr-HideMax"] = "curr-HideMax",
						["curr-HideZero"] = "curr-HideZero",
						["curr-ShowPositive"] = "curr-ShowPositive",
					},
				},
				["hideNPC"] = 
				{
					name = "hideNPC",
					rules = 
					{
						["showPC"] = "showPC",
						["hideNPC"] = "hideNPC",
					},
				},
				["HideIfSelf"] = 
				{
					name = "HideIfSelf",
					rules = 
					{
						["ShowIfNotSelf"] = "ShowIfNotSelf",
						["HideIfSelf"] = "HideIfSelf",
					},
				},
				["HideIfDead"] = 
				{
					name = "HideIfDead",
					rules = 
					{
						["HideIfDead"] = "HideIfDead",
						["curr-ShowPositive"] = "curr-ShowPositive",
					},
				},
				["ShowIfDead"] = 
				{
					name = "ShowIfDead",
					rules = 
					{
						["ShowIfDead"] = "ShowIfDead",
					},
				},
				ShowInGroupOnly = 
				{
					name = "ShowInGroupOnly",
					rules = 
					{
						HideNotGrouped = "HideNotGrouped",
						ShowGrouped = "ShowGrouped",
					},
				},
				Combat = 
				{
					name = "Combat",
					rules = 
					{
						OutOfCombat = "OutOfCombat",
						InCombat = "InCombat",
					},
				},
				CombatOrNotFull = 
				{
					name = "CombatOrNotFull",
					rules = 
					{
						HideIfFull = "HideIfFull",
						ShowIfNotFull = "ShowIfNotFull",
						HideIfDead = "HideIfDead",
						InCombat = "InCombat",
					},
				},
			}
		}
	}
end

local function GetFactoryPresetsFor(ruletype, isRuleSet)	
	if isRuleSet then
		return GetFactoryPresets()[ruletype].RuleSets
	else
		return GetFactoryPresets()[ruletype].Rules
	end
end
Addon.GetRuleFactoryPresetsFor = GetFactoryPresetsFor

local function GetFactoryPreset(ruletype, isRuleSet, ruleName)
	return GetFactoryPresetsFor(ruletype, isRuleSet)[ruleName]
end
Addon.GetRuleFactoryPreset = GetFactoryPreset

--
-- Addon Functions
--
function Addon.InitializeRules()
	-- first establish saved rules
	--Addon.Rules = Addon.deepcopy(Addon.SavedRules) or {}
	
	for _,v in ipairs(Addon.RuleTypes) do
		if not Addon.Rules[v] then Addon.Rules[v] = {} end
		if not Addon.Rules[v].Rules then Addon.Rules[v].Rules = {} end
		if not Addon.Rules[v].RuleSets then Addon.Rules[v].RuleSets = {} end
		
		RuleCache[v] = {}
		RuleCache[v].Rules = {}
		RuleCache[v].isDirty = true
		RuleCache[v].isUpdating = false
	
		--[[if next(Addon.Rules[v].RuleSets) == nil then
			-- my table is empty, import
			Addon.ImportExampleRules(v)
			Addon.UpdateRuleCache(v)
		end]]--
		-- add new Rules
		--[[for name, preset in pairs(GetFactoryPresetsFor(v, false)) do	-- Rules
			if not Addon.Rules[v].Rules[name] then
				Addon.Rules[v].Rules[name] = Addon.deepcopy(preset)	-- deepcopy this?
			end
		end
		for name, preset in pairs(GetFactoryPresetsFor(v, true)) do	-- RuleSets
			if not Addon.Rules[v].RuleSets[name] then
				Addon.Rules[v].RuleSets[name] = Addon.deepcopy(preset)	-- deepcopy this?
			end
		end]]--

		Addon.UpdateRuleCache(v)
	end
end

function Addon.ResetRule(ruletype, isRuleSet, name)
	local factoryPreset = GetFactoryPreset(ruletype, isRuleSet, name)
	
	if isRuleSet then
		local target = Addon.Rules[ruletype].RuleSets[name]
		if factoryPreset then
			target = Addon.deepcopy(factoryPreset)
		else
			target = Addon.deepcopy(Addon.Rule.DefaultRule)
			target.name = name
		end
	else
		local target = Addon.Rules[ruletype].Rules[name]
		if factoryPreset then
			target = Addon.deepcopy(factoryPreset)
		else
			target = Addon.deepcopy(Addon.Rule.DefaultRuleSet)
			target.name = name		
		end
	end
	
	RuleCache[ruletype] = {}
	RuleCache[ruletype].Rules = {}
	RuleCache[ruletype].isDirty = true
	RuleCache[ruletype].isUpdating = false
	Addon.UpdateRuleCache(ruletype)
end

function Addon.DeleteRule(ruletype, isRuleSet, name)
	if GetFactoryPreset(ruletype, isRuleSet, name) then
		Addon.ResetRule(ruletype, isRuleSet, name)
		return
	end
	if isRuleSet then
		Addon.Rules[ruletype].RuleSets[name] = nil
		--Addon.SavedRules[ruletype].RuleSets[name] = nil
	else
		Addon.Rules[ruletype].Rules[name] = nil
		--Addon.SavedRules[ruletype].Rules[name] = nil
	end
	RuleCache[ruletype] = {}
	RuleCache[ruletype].Rules = {}
	RuleCache[ruletype].isDirty = true
	RuleCache[ruletype].isUpdating = false
	Addon.UpdateRuleCache(ruletype)	
end

function Addon.GetPayload(ruleType, ruleSet, source)

	-- build the rule lookup if required, while updating nil is returned
	if ( (RuleCache[ruleType].isDirty == true) and (RuleCache[ruleType].isUpdating == false)) then
		DEBUG(L"Updating rule cache")
		Addon.UpdateRuleCache(ruleType)
	end
	
	if (RuleCache[ruleType].isUpdating == true) then
		DEBUG(L"Update is running ... bailout")
		return nil
	end

	if ( (ruleSet == nil) or (RuleCache[ruleType].Rules[ruleSet] == nil) ) then
		return nil
	end
	
	--local source = source
	
	for prio=1,32 do
		--local i
		--local v
		if (RuleCache[ruleType].Rules[ruleSet][prio] ~= nil) then
			for _, v in ipairs (RuleCache[ruleType].Rules[ruleSet][prio]) do
				--DEBUG(towstring(v.name))
				local a = v:Evaluate(source)
				if (a ~= nil) then return a end
			end
		end
	end
	
	return nil
end

function Addon.UpdateRuleCache(ruleType)
	
	RuleCache[ruleType].isUpdating = true 
	RuleCache[ruleType].Rules = nil
	RuleCache[ruleType].Rules = {}
	
	local i
	local Sets = GetFactoryPresetsFor(ruleType, true)
	for name, ruleset in pairs(Addon.Rules[ruleType].RuleSets) do	-- add/overwrite with saved sets
		Sets[name] = ruleset
	end

	for i in pairs(Sets) do

		RuleCache[ruleType].Rules[i] = {}
		if (Sets[i].rules == nil) then Sets[i].rules = {} end
		if (Sets[i].name == nil) then Sets[i].name = i end
		for k in pairs(Sets[i].rules) do
			local ruleTypeRule = Addon.Rules[ruleType].Rules[k] or GetFactoryPreset(ruleType, false, k)
			if (
					(ruleTypeRule ~= nil) and
					(ruleTypeRule.enabled == true)
					)
			then
				
				local rule = Addon.Rule.Rule:getRuleFromStored(ruleTypeRule.name, ruleTypeRule, ruleType)
				rule.payload = ruleTypeRule.payload
				if (RuleCache[ruleType].Rules[i][rule.priority] == nil) then
					RuleCache[ruleType].Rules[i][rule.priority] = {}
				end
				table.insert(RuleCache[ruleType].Rules[i][rule.priority], rule)
			end
		end
	end
	
	RuleCache[ruleType].isDirty = false
	RuleCache[ruleType].isUpdating = false 
end
