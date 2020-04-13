if not RVMOD_GColorPresets then RVMOD_GColorPresets = {} end

local Addon = RVMOD_GColorPresets

function Addon.ResetFactoryPreset(colorName)
	if (Addon.DefaultConfiguration[colorName] ~= nil) then
		for k,v in pairs(Addon.DefaultConfiguration[colorName]) do
			Addon.CurrentConfiguration[colorName][k] = v
		end
	end
end

function Addon.ResetFactoryPresets()
	for _,v in pairs(Addon.DefaultConfiguration) do
		Addon.ResetFactoryPresets(v.name)
	end
end

function Addon.GetFactoryPresets()
	return
	{
		default = 
		{
			name = "default",
			r = 255,
			g = 255,
			b = 255,
			a = 1,
		},
		["__BLACK"] =
		{
			name = "__BLACK",
			r = 0,
			g = 0,
			b = 0,
			a = 1,
		},		
		["__RED"] = 
		{
			name = "__RED",
			r = 255,
			g = 0,
			b = 0,
			a = 1,
		},
		["__GREEN"] = 
		{
			name = "__GREEN",
			r = 0,
			g = 255,
			b = 0,
			a = 1,
		},
		["__BLUE"] = 
		{
			name = "__BLUE",
			r = 0,
			g = 0,
			b = 255,
			a = 1,
		},
		["__YELLOW"] = 
		{
			name = "__YELLOW",
			r = 255,
			g = 255,
			b = 0,
			a = 1,
		},
		["__RED_SAT"] = 
		{
			a = 1,
			name = "__RED_SAT",
			r = 200,
			g = 0,
			b = 0,
		},
		["__GREEN_SAT"] = 
		{
			b = 0,
			g = 150,
			name = "__GREEN_SAT",
			r = 0,
		},
		["__RED_DARK"] = 
		{
			name = "__RED_DARK",
			r = 100,
			g = 0,
			b = 0,
			a = 1,
		},
		["__YELLOW_DARK"] = 
		{
			name = "__YELLOW_DARK",
			r = 200,
			g = 200,
			b = 0,
			a = 1,
		},
		["__ORANGE_DARK"] = 
		{
			b = 0,
			g = 100,
			name = "__ORANGE_DARK",
			r = 200,
		},
		["__LIGHTGREY"] = 
		{
			r = 220,
			name = "__LIGHTGREY",
			g = 220,
			b = 220,
		},
		["_Mork"] =
		{
			name = "_Mork",
			r = 255,
			g = 255,
			b = 0,
			a = 1,
		},
		["_Gork"] =
		{
			name = "_Gork",
			r = 255,
			g = 0,
			b = 0,
			a = 1,
		},
		["career-ib"] = 
		{
			name = "career-ib",
			r = 155, g = 82, b = 65,
			a = 1,
		},
		["career-sla"] = 
		{
			name = "career-sla",
			r = 179, g = 1, b = 1,
			a = 1,
		},
		["career-rp"] = 
		{
			name = "career-rp",
			r = 246, g = 227, b = 148,
			a = 1,
		},
		["career-eng"] = 
		{
			name = "career-eng",
			r = 232, g = 181, b = 128,
			a = 1,
		},
		["career-bo"] = 
		{
			name = "career-bo",
			r =  51, g = 115, b =  21,
			a = 1,
		},
		["career-cop"] = 
		{
			name = "career-cop",
			r = 147, g = 200, b = 120,
			a = 1,
		},
		["career-sha"] = 
		{
			name = "career-sha",
			r = 147, g = 200, b = 120,
			a = 1,
		},
		["career-sh"] = 
		{
			name = "career-sh",
			r =  60, g =  96, b =  48,
			a = 1,
		},
		["career-wh"] = 
		{
			name = "career-wh",
			r = 150, g =  26, b =  18,
			a = 1,
		},
		["career-kn"] = 
		{
			name = "career-kn",
			r = 246, g = 106, b =  19,
			a = 1,
		},
		["career-bw"] = 
		{
			name = "career-bw",
			r = 255, g =  37, b =  10,
			a = 1,
		},
		["career-wp"] = 
		{
			name = "career-wp",
			r = 237, g = 129, b = 100,
			a = 1,
		},
		["career-cho"] = 
		{
			name = "career-cho",
			r =  86, g =  89, b =  96,
			a = 1,
		},
		["career-mar"] = 
		{
			name = "career-mar",
			r = 177, g = 136, b = 134,
			a = 1,
		},
		["career-zel"] = 
		{
			name = "career-zel",
			r = 144, g = 142, b = 145,
			a = 1,
		},
		["career-mag"] = 
		{
			name = "career-mag",
			r =  44, g =  81, b = 136,
			a = 1,
		},
		["career-sm"] = 
		{
			name = "career-sm",
			r =  52, g =  96, b = 159,
			a = 1,
		},
		["career-sw"] = 
		{
			name = "career-sw",
			r =  60, g =  61, b =  78,
			a = 1,
		},
		["career-wl"] = 
		{
			name = "career-wl",
			r = 227, g = 240, b = 246,
			a = 1,
		},
		["career-am"] = 
		{
			name = "career-am",
			r = 175, g = 206, b = 234,
			a = 1,
		},
		["career-bg"] = 
		{
			name = "career-bg",
			r =  88, g =  17, b =  76,
			a = 1,
		},
		["career-we"] = 
		{
			name = "career-we",
			r = 188, g = 106, b = 204,
			a = 1,
		},
		["career-dok"] = 
		{
			name = "career-dok",
			r = 204, g =  43, b = 211,
			a = 1,
		},
		["career-src"] = 
		{
			name = "career-src",
			r =  92, g =  24, b = 125,
			a = 1,
		},
		["archtype-heal"] = 
		{
			name = "archtype-heal",
			r = 143.72312927246,
			g = 105.33601379395,
			b = 209.30107116699,
			a = 1,
		},
		["archtype-mdps"] = 
		{
			name = "archtype-mdps",
			r = 255,
			b = 63.064517974854,
			g = 64.892471313477,
			a = 1,
		},
		["archtype-rdps"] = 
		{
			name = "archtype-rdps",
			r = 255,
			g = 172.74194335938,
			b = 0,
			a = 1,
		},
		["archtype-tank"] = 
		{
			name = "archtype-tank",
			r = 190,
			g = 150,
			b = 95,
			a = 1,
		},
		["buffs-blessing"] = 
		{
			name = "buffs-blessing",
			r = 255,
			g = 167.25805664063,
			b = 63.75,
			a = 1,
		},
		["buffs-buff"] = 
		{
			name = "buffs-buff",
			r = 50.268817901611,
			g = 127.5,
			b = 191.25,
			a = 1,
		},
		["buffs-cureable"] = 
		{
			name = "buffs-cureable",
			r = 255,
			g = 70,
			b = 10,
			a = 1,
		},
		["buffs-hot"] = 
		{
			name = "buffs-hot",
			r = 94.139778137207,
			g = 214.78494262695,
			b = 127.5,
			a = 1,
		},
		["HD-25"] = 
		{
			name = "HD-25",
			r = 190,
			g = 0,
			b = 128,
			a = 1,
		},
		["HD-50"] = 
		{
			name = "HD-50",
			r = 0,
			g = 0,
			b = 0,
			a = 1,
		},
		["HD-out"] = 
		{
			name = "HD-out",
			r = 255,
			g = 128,
			b = 64,
			a = 1,
		},		
		["Hot-15"] = 
		{
			name = "Hot-15",
			r = 150,
			g = 200,
			b = 150,
			a = 1,
		},
		["Hot-5"] = 
		{
			name = "Hot-5",
			r = 200,
			g = 150,
			b = 150,
			a = 1,
		},
		["Hot-ExtraHot"] = 
		{
			name = "Hot-ExtraHot",
			r = 200,
			g = 200,
			b = 100,
			a = 1,
		},
		["Hot-Shield"] = 
		{
			name = "Hot-Shield",
			r = 150,
			g = 150,
			b = 200,
			a = 1,
		},
		["Hot-Extra"] = 
		{
			name = "Hot-Extra",
			r = 200,
			g = 150,
			b = 200,
			a = 1,
		},
		["mechanic-lowest"] = 
		{
			name = "mechanic-lowest",
			r = 50.268817901611,
			g = 212.95698547363,
			b = 0,
			a = 1,
		},
		["mechanic-low"] = 
		{
			name = "mechanic-low",
			r = 187.36558532715,
			g = 165.43011474609,
			b = 0,
			a = 1,
		},				
		["mechanic-med"] = 
		{
			name = "mechanic-med",
			r = 249.51612854004,
			g = 205.64515686035,
			b = 0,
			a = 1,
		},
		["mechanic-medhigh"] = 
		{
			name = "mechanic-medhigh",
			r = 255,
			g = 115,
			b = 0,
			a = 1,
		},
		["mechanic-high"] = 
		{
			name = "mechanic-high",
			r = 255,
			g = 4.5698928833008,
			b = 0,
			a = 1,
		},		
		["rangelayer-oor"] =
		{
			name = "rangelayer-oor",
			r = 132,
			g = 33,
			b = 33,
			a = 1,
		},
		["rangelayer-inrange"] =
		{
			name = "rangelayer-inrange",
			r = 255,
			g = 255,
			b = 255,
			a = 1,
		},
		["rangelayer-inrangel2"] =
		{
			name = "rangelayer-inrangel2",
			r = 255,
			g = 255,
			b = 0,
			a = 1,
		},
		Life0 = 
		{
			b = 0,
			g = 0,
			name = "Life0",
			r = 140,
		},
		Life10 = 
		{
			b = 32,
			g = 70,
			name = "Life10",
			r = 158,
		},
		Life20 = 
		{
			b = 34,
			g = 90,
			name = "Life20",
			r = 150,
		},
		Life30 = 
		{
			b = 26,
			g = 133,
			name = "Life30",
			r = 172,
		},
		Life40 = 
		{
			b = 65,
			g = 154,
			name = "Life40",
			r = 176,
		},
		Life50 = 
		{
			b = 73,
			g = 180,
			name = "Life50",
			r = 168,
		},
		Life60 = 
		{
			b = 67,
			g = 201,
			name = "Life60",
			r = 148,
		},
		Life70 = 
		{
			b = 98,
			g = 200,
			name = "Life70",
			r = 125,
		},
		Life80 = 
		{
			b = 128,
			g = 201,
			name = "Life80",
			r = 25,
		},
		Life90 = 
		{
			b = 138,
			g = 193,
			name = "Life90",
			r = 4,
		},
		Life100 = 
		{
			b = 187,
			g = 207,
			name = "Life100",
			r = 0,
		},	
	}
end