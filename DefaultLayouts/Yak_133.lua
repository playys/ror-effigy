-- vim: sw=2 ts=2
if not Effigy then Effigy = {} end
local Addon = Effigy

-- From the lua wiki: http://lua-users.org/wiki/CopyTable
local function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy( getmetatable(object)))
    end
    return _copy(object)
end

local default_colorsettings =
{
	color = {r = 0, g = 0, b = 0},
	alter = {r = "no", g = "no", b = "no"},
	allow_overrides = false,
	color_group = "none",
	ColorPreset = "none",
}

local default_texturesettings =
{
	y = 0,
	slice = "none",
	name = "tint_square",
	scale = 1,
	height = 0,
	x = 0,
	width = 0,
	texture_group = "none",
	style = "cut",
}

-- Future UI accessible Image and Label templates
-- atm no deepcopy, try a "use template" instead of a "load template" semantic
if not UFTemplates then UFTemplates = {} end
if not UFTemplates.Images then UFTemplates.Images = {} end
if not UFTemplates.Labels then UFTemplates.Labels = {} end
if not UFTemplates.Bars then UFTemplates.Bars = {} end
if not UFTemplates.Layouts then UFTemplates.Layouts = {} end

local labelcolorsettings =
{
	color = {r = 220, g = 220, b = 220},
	alter = {r = "no", g = "no", b = "no"},
	allow_overrides = false,
	color_group = "none",
	ColorPreset = "none",
}

		
UFTemplates.Labels.YakUI_133_Name =
{
	parent = "Bar",
	follow = "no",
	clip_after = 14,
	scale = 1,
	formattemplate = "$title",
	layer = "secondary",
	always_show = false,
	alpha = 1,
	width = 0,
	show = true,
	font = 
	{
		name = "font_clear_medium_bold",
		align = "center",
	},
	visibility_group = "none",
	height = 24,
	anchors = {
		[1] = {
			parent = "Bar",
			parentpoint = "center",
			point = "center",
			x = 0,
			y = 0,
		},
	},
}
UFTemplates.Labels.YakUI_133_Name.colorsettings = deepcopy(labelcolorsettings)

UFTemplates.Labels.YakUI_133_Value = 
{
	parent = "Bar",
	follow = "no",
	clip_after = 5,
	scale = 1,
	formattemplate = "$value",
	layer = "overlay",
	always_show = true,
	alpha = 1,
	width = 0,
	show = true,
	font = 
	{
		name = "font_clear_small",
		align = "right",
	},
	visibility_group = "none",
	height = 15,
	anchors = {
		[1] = {
			parent = "Bar",
			parentpoint = "bottomright",
			point = "bottomright",
			x = -2,
			y = -2,
		},
	},
}
UFTemplates.Labels.YakUI_133_Value.colorsettings = deepcopy(labelcolorsettings)

UFTemplates.Labels.YakUI_133_Level = 
{
	scale = 1,
	follow = "no",
	clip_after = 2,
	parent = "Bar",
	font = 
	{
		name = "font_clear_small",
		align = "left",
	},
	formattemplate = "$lvl",
	always_show = false,
	alpha = 1,
	width = 0,
	show = true,
	visibility_group = "none",
	layer = "secondary",
	height = 15,
	anchors = {
		[1] = {
			parent = "Bar",
			parentpoint = "bottomright",
			point = "bottomright",
			x = 2,
			y = -2,
		},
	},
}
UFTemplates.Labels.YakUI_133_Level.colorsettings = deepcopy(labelcolorsettings)

UFTemplates.Labels.YakUI_133_TargetRingName = 
{
	scale = 1,
	follow = "no",
	formattemplate = "$title",
	always_show = false,
	visibility_group = "none",
	layer = "secondary",
	alpha = 1,
	width = 0,
	show = true,
	font = 
	{
		name = "font_clear_medium",
		align = "center",
	},
	height = 24,
	anchors = {
		[1] = {
			parent = "Bar",
			parentpoint = "center",
			point = "center",
			x = 0,
			y = 0,
		},
	},
}
UFTemplates.Labels.YakUI_133_TargetRingName.colorsettings = deepcopy(labelcolorsettings)

--
-- Bar Templates
--
local bgsettings = 
{
	show = true,
	texture = 
	{
		y = 7,
		slice = "none",
		name = "tint_square",
		scale = 15,
		height = 0,
		x = 4,
		width = 0,
		texture_group = "none",
		style = "cut",
	},
	alpha = 
	{
		in_combat = 1,
		out_of_combat = 1,
	},
	colorsettings =
	{
		color = {r = 0, g = 0, b = 0},
		alter = {r = "no", g = "no", b = "no"},
		allow_overrides = false,
		color_group = "none"
	},
}
local fgsettings =
{	
	alpha = 
	{
		clamp = 0.366,
		out_of_combat = 1,
		in_combat = 1,
		alter = "no",
	},
	colorsettings =
	{
		color = {r = 75, g = 70, b = 80},
		alter = {r = "no", g = "no", b = "no"},
		allow_overrides = false,
		color_group = "none"
	},
	texture = 
	{
		scale = 0,
		width = 0,
		y = 0,
		slice = "none",
		name = "SharedMediaYBar3",
		height = 0,
		x = 0,
		texture_group = "none",
		style = "cut",
	},
}


UFTemplates.Bars.YakUI_133_World = 
{
	grow = "up",
	hide_if_target = false,
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	fg = 
	{
		alpha = 
		{
			clamp = 0.2,
			alter = "no",
			in_combat = 1,
			out_of_combat = 1,
		},
		colorsettings =
		{
			color = {r = 160, g = 160, b = 160},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "archetype-colors"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			x = 0,
			style = "cut",
			height = 0,
			name = "SharedMediaYGroupIconShape",
			y = 0,
			slice = "none",
		},
	},
	icon = 
	{
		scale = 0.8,
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				parentpoint = "center",
				point = "center",
				x = 0,
				y = 0,
			},
		},
	},
	no_tooltip = true,
	block_layout_editor = true,
	name = "FTHPunit",
	interactive_type = "none",
	height = 34,
	pos_at_world_object = true,
	border = 
	{
		follow_bg_alpha = true,
		alpha = 1,
		padding = { top = 0, left = 0, right = 0, bottom = 0}
	},
	slow_changing_value = false,
	watching_states = {},
	visibility_group = "none",
	state = "FTHP",
	hide_if_zero = false,
	show_with_target = false,
	width = 34,
	show = true,
	interactive = false,
	scale = 1,
	images = {},
	anchors = {
		[1] = {
			parent = "FTHPunitInvisi",
			parentpoint = "center",
			point = "center",
			x = 0,
			y = -100,
		},
	},
}
UFTemplates.Bars.YakUI_133_World.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_World.border.texture = deepcopy(default_texturesettings)
UFTemplates.Bars.YakUI_133_World.border.texture.name = "SharedMediaYGroupIconShape"
UFTemplates.Bars.YakUI_133_World.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_World.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_133_PlayerHP = 
{
	name = "PlayerHP",
	show = true,
	grow = "right",
	hide_if_target = false,
	width = 185,
	height = 33,
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	no_tooltip = false,
	block_layout_editor = false,
	visibility_group = "none",
	interactive_type = "player",	
	images = {},
	scale = 1,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 2, left = 2, right = 2, bottom = 0}
	},
	slow_changing_value = false,
	watching_states = {},
	interactive = true,
	hide_if_zero = false,
	show_with_target = false,
	state = "PlayerHP",
	pos_at_world_object = false,
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = -290,
			y = 150,
		},
	},
}
UFTemplates.Bars.YakUI_133_PlayerHP.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_PlayerHP.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_PlayerHP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_PlayerHP.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_PlayerHP.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_PlayerAP = 
{
	name = "PlayerAP",
	state = "PlayerAP",
	show = true,
	grow = "right",
	hide_if_target = false,
	interactive_type = "none",
	hide_if_zero = false,
	interactive = false,
	show_with_target = false,
	no_tooltip = false,
	block_layout_editor = false,
	visibility_group = "none",
	slow_changing_value = false,
	
	width = 185,
	height = 10,
	scale = 1,
	pos_at_world_object = false,
	
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = -290,
			y = 179,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	fg = 
	{
		alpha = 
		{
			clamp = 0.366,
			alter = "no",
			in_combat = 1,
			out_of_combat = 1,
		},
		colorsettings =
		{
			color = {r = 160, g = 0, b = 40},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = true,
			color_group = "none"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			y = 0,
			slice = "none",
			style = "grow",
			height = 0,
			x = 0,
			texture_group = "none",
			name = "XPerl_StatusBar4",
		},
	},
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 2, left = 2, right = 2, bottom = 2}
	},
	watching_states = {},
	
}
UFTemplates.Bars.YakUI_133_PlayerAP.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_PlayerAP.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_PlayerAP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_PlayerAP.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_PlayerAP.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_PlayerCareer = 
{
	fg = 
	{
		alpha = 
		{
			clamp = 0.366,
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		colorsettings =
		{
			color = {r = 170, g = 150, b = 80},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "none"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			y = 0,
			slice = "none",
			name = "XPerl_StatusBar4",
			height = 0,
			x = 0,
			texture_group = "none",
			style = "grow",
		},
	},
	no_tooltip = false,
	block_layout_editor = false,
	state = "PlayerCareer",
	interactive_type = "none",
	height = 8,
	pos_at_world_object = false,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 0, left = 2, right = 2, bottom = 2}
	},
	grow = "right",
	slow_changing_value = false,
	watching_states = 
	{
	},
	visibility_group = "none",
	hide_if_target = false,			
	hide_if_zero = false,
	interactive = false,
	show_with_target = false,
	width = 185,
	show = true,
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	scale = 1,
	name = "PlayerCareer",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = -290,
			y = 190,
		},
	},
}
UFTemplates.Bars.YakUI_133_PlayerCareer.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_PlayerCareer.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_PlayerCareer.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_PlayerCareer.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_PlayerCareer.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_Castbar = 
{
	grow = "right",
	hide_if_target = false,
	fg = 
	{
		alpha = 
		{
			clamp = 0.2,
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		colorsettings =
		{
			color = {r = 75, g = 70, b = 80},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = true,
			color_group = "none"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			y = 0,
			x = 0,
			name = "SharedMediaYCastbar3",
			height = 0,
			style = "cut",
			texture_group = "none",
			slice = "none",
		},
	},
	no_tooltip = false,
	block_layout_editor = false,
	state = "Castbar",
	name = "Castbar",
	interactive_type = "none",
	height = 51,
	pos_at_world_object = false,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 2, left = 2, right = 2, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = {},
	scale = 1,
	hide_if_zero = true,
	show_with_target = false,
	width = 225,
	show = true,
	interactive = false,
	visibility_group = "none",
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "bottom",
			point = "bottom",
			x = -129,
			y = -270,
		},
	},
}
UFTemplates.Bars.YakUI_133_Castbar.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_Castbar.border.texture = deepcopy(default_texturesettings)
UFTemplates.Bars.YakUI_133_Castbar.border.texture.name = "SharedMediaYCastbarBG"
UFTemplates.Bars.YakUI_133_Castbar.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_Castbar.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_Castbar.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_Pet = 
{
	grow = "right",
	hide_if_target = false,
	fg = 
	{
		alpha = 
		{
			clamp = 0.366,
			alter = "no",
			in_combat = 1,
			out_of_combat = 1,
		},
		colorsettings =
		{
			color = {r = 75, g = 70, b = 80},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = true,
			color_group = "none"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			y = 0,
			slice = "none",
			style = "cut",
			height = 0,
			x = 0,
			texture_group = "none",
			name = "SharedMediaYBar3",
		},
	},
	no_tooltip = false,
	block_layout_editor = false,
	state = "PlayerPetHP",
	visibility_group = "none",
	interactive_type = "none",
	height = 35,
	pos_at_world_object = false,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 2, left = 2, right = 2, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = {},
	hide_if_zero = true,
	interactive = false,
	show_with_target = false,
	width = 185,
	show = true,
	scale = 1,
	name = "Pet",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = -290,
			y = 350,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
}
UFTemplates.Bars.YakUI_133_Pet.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_Pet.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_Pet.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_Pet.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_Pet.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_HostileTarget = 
{
	grow = "right",
	hide_if_target = false,
	no_tooltip = false,
	block_layout_editor = false,
	state = "HTHP",
	visibility_group = "none",
	interactive_type = "none",
	height = 35,
	scale = 1,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = false,
		padding = { top = 2, left = 2, right = 2, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = 
	{
	},
	hide_if_zero = false,
	interactive = false,
	show_with_target = false,
	width = 185,
	show = true,
	pos_at_world_object = false,
	name = "HostileTarget",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = 290,
			y = 150,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
}
UFTemplates.Bars.YakUI_133_HostileTarget.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_HostileTarget.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_HostileTarget.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_HostileTarget.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_HostileTarget.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_FriendlyTarget = 
{
	grow = "right",
	no_tooltip = false,
	block_layout_editor = false,
	visibility_group = "none",
	interactive_type = "friendly",
	height = 35,
	scale = 1,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = false,
		padding = { top = 2, left = 2, right = 2, bottom = 2}
	},
	state = "FTHP",
	slow_changing_value = false,
	watching_states = 
	{
	},
	hide_if_target = false,
	hide_if_zero = false,
	show_with_target = false,
	width = 185,
	show = true,
	interactive = true,
	pos_at_world_object = false,
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = 290,
			y = 350,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
}
UFTemplates.Bars.YakUI_133_FriendlyTarget.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_FriendlyTarget.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_FriendlyTarget.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_FriendlyTarget.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_FriendlyTarget.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_133_GroupMember = 
{
	grow = "right",
	hide_if_target = false,
	fg = 
	{
		alpha = 
		{
			clamp = 0.366,
			alter = "no",
			in_combat = 1,
			out_of_combat = 1,
		},
		colorsettings =
		{
			color = {r = 75, g = 70, b = 80},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = true,
			color_group = "none"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "SharedMediaYBar3",
			height = 0,
			style = "cut",
			y = 0,
			slice = "none",
		},
	},
	no_tooltip = true,
	block_layout_editor = false,
	state = "grp2hp",
	visibility_group = "none",
	name = "GroupMember1",
	interactive_type = "group",
	height = 35,
	scale = 1,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 2, left = 2, right = 2, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = 
	{
	},
	images = {},
	hide_if_zero = false,
	show_with_target = false,
	width = 150,
	show = true,
	interactive = true,
	pos_at_world_object = false,
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "topleft",
			point = "topleft",
			x = 0,
			y = 160,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
}
UFTemplates.Bars.YakUI_133_GroupMember.border.colorsettings = default_colorsettings
UFTemplates.Bars.YakUI_133_GroupMember.border.texture = default_texturesettings
UFTemplates.Bars.YakUI_133_GroupMember.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_133_GroupMember.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_133_GroupMember.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.Yak_TargetRing = 
{
	grow = "right",
	hide_if_target = false,
	fg = 
	{
		alpha = 
		{
			clamp = 0.2,
			alter = "no",
			in_combat = 0,
			out_of_combat = 0,
		},
		colorsettings =
		{
			color = {r = 255, g = 255, b = 255},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "none"
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			x = 0,
			style = "cut",
			height = 0,
			slice = "none",
			y = 0,
			name = "tint_square",
		},
	},
	no_tooltip = false,
	block_layout_editor = true,
	interactive_type = "none",
	height = 100,
	pos_at_world_object = true,
	border = 
	{
		follow_bg_alpha = false,
		alpha = 0.7,
		padding = { top = 0, left = 0, right = 0, bottom = 0}
	},
	slow_changing_value = false,
	watching_states = 
	{
	},
	state = "FTHP",
	scale = 1,
	hide_if_zero = false,
	show_with_target = false,
	width = 100,
	show = true,
	interactive = false,
	visibility_group = "none",
	name = "FriendlyTargetRing",
	anchors = {
		[1] = {
			parent = "FriendlyTargetRingInvisi",
			parentpoint = "center",
			point = "center",
			x = 0,
			y = 50,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	images = {},
	labels = {},
}
UFTemplates.Bars.Yak_TargetRing.border.colorsettings = deepcopy(default_colorsettings)
UFTemplates.Bars.Yak_TargetRing.border.colorsettings.color.g = 255
UFTemplates.Bars.Yak_TargetRing.border.colorsettings.allow_overrides = true
UFTemplates.Bars.Yak_TargetRing.border.texture = deepcopy(default_texturesettings)
UFTemplates.Bars.Yak_TargetRing.border.texture.name = "SharedMediaTargetRing"
UFTemplates.Bars.Yak_TargetRing.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.Yak_TargetRing.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.Yak_TargetRing.icon = Addon.GetDefaultCareerIcon()

-- Insert local fgsettings into Bar Templates
UFTemplates.Bars.YakUI_133_PlayerHP.fg = fgsettings
UFTemplates.Bars.YakUI_133_HostileTarget.fg = deepcopy(fgsettings)
UFTemplates.Bars.YakUI_133_HostileTarget.fg.colorsettings.allow_overrides = true
UFTemplates.Bars.YakUI_133_FriendlyTarget.fg = fgsettings

-- Insert local bgsettings into Bar Templates
UFTemplates.Bars.YakUI_133_World.bg = deepcopy(bgsettings)
UFTemplates.Bars.YakUI_133_World.bg.texture.name = "SharedMediaYGroupIconShape"
UFTemplates.Bars.YakUI_133_PlayerHP.bg = bgsettings
UFTemplates.Bars.YakUI_133_PlayerAP.bg = deepcopy(bgsettings)
UFTemplates.Bars.YakUI_133_PlayerAP.bg.colorsettings.color = {r = 24, g = 24, b = 24} -- overwrite with individual setting
UFTemplates.Bars.YakUI_133_PlayerCareer.bg = deepcopy(bgsettings)
UFTemplates.Bars.YakUI_133_PlayerCareer.bg.colorsettings.color = {r = 24, g = 24, b = 24} -- overwrite with individual setting
UFTemplates.Bars.YakUI_133_Castbar.bg = deepcopy(bgsettings)
UFTemplates.Bars.YakUI_133_Castbar.bg.colorsettings.color = {r = 30, g = 30, b = 30} -- overwrite with individual setting
UFTemplates.Bars.YakUI_133_Castbar.bg.texture.name = "SharedMediaYCastbarBG" -- overwrite with individual setting
UFTemplates.Bars.YakUI_133_Pet.bg = bgsettings
UFTemplates.Bars.YakUI_133_HostileTarget.bg = bgsettings
UFTemplates.Bars.YakUI_133_FriendlyTarget.bg = bgsettings
UFTemplates.Bars.YakUI_133_GroupMember.bg = bgsettings
UFTemplates.Bars.Yak_TargetRing.bg = deepcopy(bgsettings)
UFTemplates.Bars.Yak_TargetRing.bg.show = false
UFTemplates.Bars.Yak_TargetRing.bg.alpha = { in_combat = 0, out_of_combat = 0}
UFTemplates.Bars.Yak_TargetRing.bg.colorsettings.color = {r = 30, g = 30, b = 30}


-- Insert Label Templates into Bartemplates
UFTemplates.Bars.YakUI_133_World.labels = {}
UFTemplates.Bars.YakUI_133_PlayerHP.labels = {}
UFTemplates.Bars.YakUI_133_PlayerHP.labels.Name = UFTemplates.Labels.YakUI_133_Name
UFTemplates.Bars.YakUI_133_PlayerHP.labels.Value = UFTemplates.Labels.YakUI_133_Value
UFTemplates.Bars.YakUI_133_PlayerAP.labels = {}
UFTemplates.Bars.YakUI_133_PlayerAP.labels.Value = deepcopy(UFTemplates.Labels.YakUI_133_Value)
UFTemplates.Bars.YakUI_133_PlayerAP.labels.Value.font.name = "font_clear_tiny"
UFTemplates.Bars.YakUI_133_PlayerAP.labels.Value.scale = 0.75
UFTemplates.Bars.YakUI_133_PlayerAP.labels.Value.anchors[1].y = 0

UFTemplates.Bars.YakUI_133_PlayerCareer.labels = {}
UFTemplates.Bars.YakUI_133_PlayerCareer.labels.Value = UFTemplates.Labels.YakUI_133_Value
UFTemplates.Bars.YakUI_133_Castbar.labels = {}
UFTemplates.Bars.YakUI_133_Castbar.labels.Name = UFTemplates.Labels.YakUI_133_Name
UFTemplates.Bars.YakUI_133_Pet.labels = {}
UFTemplates.Bars.YakUI_133_Pet.labels.Name = UFTemplates.Labels.YakUI_133_Name
UFTemplates.Bars.YakUI_133_Pet.labels.Value = UFTemplates.Labels.YakUI_133_Value
UFTemplates.Bars.YakUI_133_HostileTarget.labels = {}
UFTemplates.Bars.YakUI_133_HostileTarget.labels.Name = UFTemplates.Labels.YakUI_133_Name
UFTemplates.Bars.YakUI_133_HostileTarget.labels.Value = UFTemplates.Labels.YakUI_133_Value
UFTemplates.Bars.YakUI_133_HostileTarget.labels.Level = UFTemplates.Labels.YakUI_133_Level
UFTemplates.Bars.YakUI_133_FriendlyTarget.labels = {}
UFTemplates.Bars.YakUI_133_FriendlyTarget.labels.Name = UFTemplates.Labels.YakUI_133_Name
UFTemplates.Bars.YakUI_133_FriendlyTarget.labels.Value = UFTemplates.Labels.YakUI_133_Value
UFTemplates.Bars.YakUI_133_FriendlyTarget.labels.Level = UFTemplates.Labels.YakUI_133_Level
UFTemplates.Bars.YakUI_133_GroupMember.labels = {}
UFTemplates.Bars.YakUI_133_GroupMember.labels.Name = UFTemplates.Labels.YakUI_133_Name
UFTemplates.Bars.YakUI_133_GroupMember.labels.Value = UFTemplates.Labels.YakUI_133_Value
UFTemplates.Bars.YakUI_133_GroupMember.labels.Level = UFTemplates.Labels.YakUI_133_Level


-- Layouts

UFTemplates.Layouts.YakUI_133 = {}

-- preview of what will happen with party and larger maybe someday...
--UFTemplates.Layouts.YakUI_133.PlayerHP = deepcopy(UFTemplates.Bars.YakUI_133_PlayerHP)
UFTemplates.Layouts.YakUI_133.PlayerHP = UFTemplates.Bars.YakUI_133_PlayerHP
UFTemplates.Layouts.YakUI_133.PlayerAP = UFTemplates.Bars.YakUI_133_PlayerAP
UFTemplates.Layouts.YakUI_133.PlayerCareer = UFTemplates.Bars.YakUI_133_PlayerCareer
UFTemplates.Layouts.YakUI_133.Castbar = UFTemplates.Bars.YakUI_133_Castbar
UFTemplates.Layouts.YakUI_133.Pet = UFTemplates.Bars.YakUI_133_Pet
UFTemplates.Layouts.YakUI_133.HostileTarget = UFTemplates.Bars.YakUI_133_HostileTarget
UFTemplates.Layouts.YakUI_133.FriendlyTarget = UFTemplates.Bars.YakUI_133_FriendlyTarget
UFTemplates.Layouts.YakUI_133.FriendlyTargetRing = deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.YakUI_133.FriendlyTargetRing.visibility_group = "HideIfSelf"
UFTemplates.Layouts.YakUI_133.HostileTargetRing = deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.YakUI_133.HostileTargetRing.name = "HostileTargetRing"
UFTemplates.Layouts.YakUI_133.HostileTargetRing.state = "HTHP"
UFTemplates.Layouts.YakUI_133.HostileTargetRing.anchors[1].parent = "HostileTargetRingInvisi"
UFTemplates.Layouts.YakUI_133.HostileTargetRing.border.colorsettings.color.r = 255
UFTemplates.Layouts.YakUI_133.HostileTargetRing.border.colorsettings.color.g = 0


UFTemplates.Layouts.YakUI_133.GroupMember1 = deepcopy(UFTemplates.Bars.YakUI_133_GroupMember)
for i = 2,6 do
	UFTemplates.Layouts.YakUI_133["GroupMember"..i] = deepcopy(UFTemplates.Bars.YakUI_133_GroupMember)
	UFTemplates.Layouts.YakUI_133["GroupMember"..i].name = "GroupMember"..i
	UFTemplates.Layouts.YakUI_133["GroupMember"..i].state = "grp"..(i+1).."hp"
	UFTemplates.Layouts.YakUI_133["GroupMember"..i].anchors[1] = {
		parent = "GroupMember"..i-1,
		parentpoint = "bottomleft",
		point = "topleft",
		x = 0,
		y = 100,
	}
end

for i = 1,5 do
	UFTemplates.Layouts.YakUI_133["WorldGroupMember"..i] = deepcopy(UFTemplates.Bars.YakUI_133_World)
	UFTemplates.Layouts.YakUI_133["WorldGroupMember"..i].name = "WorldGroupMember"..i
	UFTemplates.Layouts.YakUI_133["WorldGroupMember"..i].state = "grp"..(i+1).."hp"
	UFTemplates.Layouts.YakUI_133["WorldGroupMember"..i].anchors[1].parent = "WorldGroupMember"..i.."Invisi"
end
