if not Effigy then Effigy = {} end
local Addon = Effigy

-- background image rgb 32->24

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

-- Future UI accessible Image and Label templates
-- atm no deepcopy, try a "use template" instead of a "load template" semantic
if not UFTemplates then UFTemplates = {} end
if not UFTemplates.Images then UFTemplates.Images = {} end
if not UFTemplates.Labels then UFTemplates.Labels = {} end
if not UFTemplates.Bars then UFTemplates.Bars = {} end
if not UFTemplates.Layouts then UFTemplates.Layouts = {} end

local function GetDefaultYakBarFG()
	return
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
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 220,
				g = 220,
				b = 220,
			},
			allow_overrides = false,
			color_group = "none",
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			slice = "none",
			style = "cut",
			height = 0,
			x = 0,
			y = 0,
			name = "LiquidBar",
		},
	}
end

local function GetDefaultYakBarBG()
	return
	{
		show = true,
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 0,
				g = 0,
				b = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 
		{
			in_combat = 0,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			slice = "none",
			--style = "cut",
			height = 0,
			x = 0,
			y = 0,
			name = "tint_square",
		},
	}
end

local function GetDefaultYakBarBorder()
	return
	{
		follow_bg_alpha = false,
		padding = 
		{
			top = 2,
			right = 2,
			left = 2,
			bottom = 0,
		},
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 0,
				g = 0,
				b = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 0,
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			slice = "none",
			--style = "cut",
			height = 0,
			x = 0,
			y = 0,
			name = "tint_square",
		},
	}
end

local function GetDefaultYakLabelName()
	return
	{
		scale = 0.86,
		follow = "no",
		alpha_group = "none",
		clip_after = 8,
		formattemplate = "$title",
		layer = "secondary",
		alpha = 1,
		width = 0,
		show = true,
		font = 
		{
			align = "left",
			name = "font_clear_small_bold",
			case = "upper",
		},
		parent = "Bar",
		visibility_group = "none",
		height = 15,
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 220,
				g = 220,
				r = 220,
			},
			allow_overrides = false,
			color_group = "none",
		},
		always_show = false,
		anchors = {
			[1] = {
				parent = "Bar BG",
				parentpoint = "bottom",
				point = "top",
				x = 42,
				y = 3,
			},
		},
	}
end

local function GetDefaultYakCareerIcon()
	return
	{
		scale = 0.44,			-- 2.6 beta 2 0.64 -> 0.44
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "LabelName",
				parentpoint = "left",
				point = "right",
				x = -5,
				y = 0,
			},
		},
	}
end

UFTemplates.Bars.YakUI_140_InfoPanel =
{
	grow = "right",
	pos_at_world_object = false,
	hide_if_target = false,
	images = 
	{
		Foreground = 
		{
			parent = "Bar",
			--follow_bg_alpha = true,
			alpha_group = "none",
			scale = 1,
			alpha = 0.6,
			width = 600,
			show = true,
			visibility_group = "none",
			layer = "overlay",
			height = 70,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 180,
					g = 220,
					b = 255,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
			texture = 
			{
				texture_group = "none",
				x = 0,
				name = "LiquidIPFX",
				slice = "none",
				scale = 1,
				height = 70,
				y = 0,
				width = 600,
			},
		},
		Background = 
		{
			parent = "Bar",
			--follow_bg_alpha = true,
			alpha_group = "none",
			scale = 1,
			alpha = 0.8,
			width = 600,
			show = true,
			visibility_group = "none",
			layer = "background",
			height = 70,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 24,
					g = 24,
					b = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
			texture = 
			{
				scale = 1,
				width = 600,
				texture_group = "none",
				x = 0,
				--style = "cut",
				height = 70,
				slice = "none",
				y = 0,
				name = "LiquidIPBG",
			},
		},
	},
	scale = 1,
	border = 
	{
		padding = 
		{
			top = 0,
			right = 0,
			left = 0,
			bottom = 0,
		},
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 255,
				g = 255,
				r = 255,
			},
			color_group = "none",
			allow_overrides = false,
		},
		follow_bg_alpha = false,
		alpha = 0,
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "tint_square",
			height = 0,
			slice = "none",
			y = 0,
			--style = "cut",
		},
	},
	slow_changing_value = true,
	watching_states = {},
	icon = 
	{
		scale = 1.09,			-- 2.6 beta 2: 0.5 -> 1.09
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				parentpoint = "top",
				point = "top",
				x = 0,
				y = 5,
			},
		},
	},
	block_layout_editor = true,
	no_tooltip = true,
	show = true,
	hide_if_zero = false,
	interactive = false,
	visibility_group = "none",
	show_with_target = false,
	width = 600,
	interactive_type = "none",
	height = 70,
	name = "InfoPanel",
	state = "PlayerHP",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "top",
			point = "top",
			x = 0,
			y = 10,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	labels = 
	{
		Guild = 
		{
			scale = 0.7,
			follow = "no",
			clip_after = 29,
			formattemplate = "[$lvl.GuildXP] $title.GuildXP",
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "center",
				name = "font_clear_small_bold",
				case = "upper",
			},
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "center",
					point = "center",
					x = 0,
					y = 16,
				},
			},
		},
		Title = 
		{
			scale = 0.7,
			follow = "no",
			clip_after = 20,
			formattemplate = "$title.Title",
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_medium_bold",
				case = "upper",
			},
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "center",
					point = "left",
					x = 30,
					y = -10,
				},
			},
		},
		Name = 
		{
			scale = 0.7,
			clip_after = 18,
			formattemplate = "$title",
			follow = "no",
			always_show = false,
			alpha = 1,
			width = 230,
			show = true,
			font = 
			{
				align = "right",
				name = "font_clear_medium_bold",
				case = "upper",
			},
			visibility_group = "none",
			parent = "Bar",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			layer = "overlay",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "center",
					point = "right",
					x = -30,
					y = -10,
				},
			},
		},
		Level = 
		{
			scale = 1,
			clip_after = 14,
			formattemplate = "$lvl",
			visibility_group = "none",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = false,
			font = 
			{
				name = "font_clear_medium",
				align = "left",
			},
			always_show = false,
			parent = "Bar",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			follow = "no",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "left",
					point = "left",
					x = 0,
					y = 0,
				},
			},
		},
		RenownRank = 
		{
			scale = 0.7,
			follow = "no",
			clip_after = 14,
			formattemplate = "$title.PlayerRR",
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_clear_medium_bold",
				case = "none",
			},
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "right",
					point = "right",
					x = -25,
					y = -10,
				},
			},
		},
		Rank = 
		{
			scale = 0.7,
			follow = "no",
			clip_after = 14,
			formattemplate = "$title.Exp",
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_medium_bold",
				case = "none",
			},
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "left",
					point = "left",
					x = 25,
					y = -10,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_InfoPanel.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_InfoPanel.fg.alpha.in_combat = 0
UFTemplates.Bars.YakUI_140_InfoPanel.fg.alpha.out_of_combat = 0
UFTemplates.Bars.YakUI_140_InfoPanel.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_InfoPanel.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_InfoPanel.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_140_WorldGroupMember = 
{
	grow = "up",
	scale = 1,
	hide_if_target = false,
	pos_at_world_object = true,
	border = 
	{
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 0,
				g = 0,
				r = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		padding = 
		{
			top = 0,
			right = 0,
			left = 0,
			bottom = 0,
		},
		follow_bg_alpha = false,
		alpha = 0,
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "SharedMediaYGroupIconShape",
			height = 0,
			slice = "none",
			y = 0,
			--style = "cut",
		},
	},
	fg = 
	{
		alpha = 
		{
			clamp = 0.2,
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		texture = 
		{
			scale = 0,
			width = 48,
			texture_group = "none",
			slice = "none",
			name = "SharedMediaYGroupIconShape",
			height = 48,
			x = 0,
			y = 0,
			style = "cut",
		},
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 160,
				g = 160,
				r = 160,
			},
			color_group = "archetype-colors",
			allow_overrides = false,
		},
	},
	bg = 
	{
		show = true,
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 0,
				g = 0,
				b = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 
		{
			in_combat = 1,
			out_of_combat = 1,
		},
		texture = 
		{
			scale = 2,
			width = 50,
			texture_group = "none",
			x = 4,
			name = "SharedMediaYGroupIconShape",
			height = 50,
			slice = "none",
			y = 7,
			--style = "cut",
		},
	},
	slow_changing_value = false,
	watching_states = {},
	icon = 
	{
		scale = 0.85,					-- 2.6 beta 2 0.8 -> 0.85
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
	block_layout_editor = true,
	no_tooltip = true,
	show = true,
	hide_if_zero = false,
	interactive = false,
	visibility_group = "none",
	show_with_target = false,
	width = 34,
	state = "grp1hp",
	interactive_type = "none",
	height = 34,
	name = "WorldGroupMember1",
	anchors = {
		[1] = {
			parent = "WorldGroupMember1Invisi",
			parentpoint = "center",
			point = "center",
			x = 0,
			y = -100,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	images = 
	{
		FX = 
		{
			parent = "Bar",
			--follow_bg_alpha = true,
			alpha_group = "none",
			scale = 1,
			alpha = 1,
			width = 36,
			show = true,
			visibility_group = "none",
			layer = "overlay",
			height = 36,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
			texture = 
			{
				y = 0,
				x = 0,
				name = "SharedMediaYGroupIconGloss",
				slice = "none",
				scale = 1,
				texture_group = "none",
				height = 50,
				width = 50,
			},
		},
	},
	labels = 
	{
	},
}
UFTemplates.Bars.YakUI_140_WorldGroupMember.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_WorldGroupMember.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_140_GroupMember =
{
	grow = "right",
	pos_at_world_object = false,
	hide_if_target = false,
	images = 
	{
		Foreground = 
		{
			scale = 1,
			parent = "Bar",
			alpha_group = "none",
			alpha = 0.6,
			width = 170,
			show = true,
			visibility_group = "none",
			layer = "default",
			height = 50,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 180,
					g = 220,
					b = 255,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = -6,
					y = 0,
				},
				[2] = {
					parent = "Bar",
					parentpoint = "bottomright",
					point = "bottomright",
					x = 0,
					y = 0,
				}
			},
			texture = 
			{
				y = 0,
				x = 0,
				name = "LiquidUFFX",
				slice = "none",
				scale = 1,
				texture_group = "none",
				height = 128,
				width = 512,
			},
		},
		Background = 
		{
			scale = 1,
			parent = "Bar",
			alpha_group = "none",
			alpha = 0.8,
			width = 170,
			show = true,
			visibility_group = "none",
			layer = "background",
			height = 50,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 24,
					g = 24,
					b = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = -7,
					y = 0,
				},
				[2] = {
					parent = "Bar",
					parentpoint = "bottomright",
					point = "bottomright",
					x = -1,
					y = 0,
				}
			},
			texture = 
			{
				y = 0,
				x = 0,
				name = "LiquidUFBG",
				slice = "none",
				scale = 1,
				texture_group = "none",
				height = 128,
				width = 512,
			},
		},
	},
	scale = 1,
	state = "grp2hp",
	name = "GroupMember1",
	slow_changing_value = false,
	watching_states = {},
	block_layout_editor = false,
	no_tooltip = false,
	show = true,
	hide_if_zero = false,
	interactive = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	visibility_group = "none",
	width = 162,
	interactive_type = "group",
	height = 50,
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "topleft",
			point = "topleft",
			x = 0,
			y = 75,
		},
	},
	labels = 
	{
		Value = 
		{
			scale = 0.9,
			follow = "no",
			clip_after = 3,
			formattemplate = "$value",
			layer = "secondary",
			always_show = false,
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_clear_small_bold",
				case = "none",
			},
			parent = "Bar",
			visibility_group = "none",
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			alpha_group = "none",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomright",
					point = "topright",
					x = -4,
					y = 2,
				},
			},
		},
		Level = 
		{
			scale = 0.9,
			follow = "no",
			clip_after = 2,
			formattemplate = "$lvl",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			visibility_group = "none",
			parent = "Bar",
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "none",
			},
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			alpha_group = "none",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomleft",
					point = "topleft",
					x = 2,
					y = 2,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_GroupMember.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_GroupMember.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_GroupMember.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_GroupMember.border.padding = {
	top = 6,
	right = 4,
	left = 2,
	bottom = 20,
}
--UFTemplates.Bars.YakUI_140_GroupMember.icon = GetDefaultYakCareerIcon()
UFTemplates.Bars.YakUI_140_GroupMember.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_GroupMember.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_140_GroupMember.icon = GetDefaultYakCareerIcon()
UFTemplates.Bars.YakUI_140_GroupMember.labels.Name = GetDefaultYakLabelName()
UFTemplates.Bars.YakUI_140_GroupMember.labels.Name.anchors[1].x = 38


UFTemplates.Bars.YakUI_140_PlayerHP = 
{
	grow = "right",
	hide_if_target = false,
	images = 
	{
		Foreground = 
		{
			texture = 
			{
				texture_group = "none",
				x = 0,
				name = "LiquidUFFX",
				slice = "none",
				scale = 1,
				y = 0,
				height = 128,
				width = 512,
			},
			parent = "Bar",
			alpha_group = "none",
			scale = 1,
			alpha = 0.6,
			width = 220,
			show = true,
			visibility_group = "none",
			layer = "default",
			height = 66,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 255,
					g = 220,
					r = 180,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
		},
		Background = 
		{
			texture = 
			{
				texture_group = "none",
				x = 0,
				name = "LiquidUFBG",
				slice = "none",
				scale = 1,
				y = 0,
				height = 128,
				width = 512,
			},
			parent = "Root",
			alpha_group = "none",
			scale = 1,
			alpha = 0.8,
			width = 220,
			show = true,
			visibility_group = "none",
			layer = "background",
			height = 66,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 24,
					g = 24,
					r = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
		},
	},
	scale = 1,
	pos_at_world_object = false,
	slow_changing_value = false,
	watching_states = {},
	block_layout_editor = false,
	no_tooltip = false,
	state = "PlayerHP",
	hide_if_zero = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	width = 220,
	show = true,
	visibility_group = "none",
	interactive = true,
	interactive_type = "player",
	height = 30,
	name = "PlayerHP",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "topright",
			x = -210,
			y = 80,
		},
	},
	labels = 
	{
		Value = 
		{
			alpha_group = "none",
			follow = "no",
			clip_after = 5,
			formattemplate = "$value",
			scale = 0.9,
			always_show = false,
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_clear_small_bold",
				case = "none",
			},
			parent = "Bar",
			visibility_group = "none",
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomright",
					point = "topright",
					x = -4,
					y = 19,
				},
			},
		},
		Level = 
		{
			scale = 0.9,
			follow = "no",
			clip_after = 2,
			formattemplate = "$lvl",
			visibility_group = "none",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "none",
			},
			parent = "Bar",
			alpha_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomleft",
					point = "topleft",
					x = 6,
					y = 19,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_PlayerHP.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_PlayerHP.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_PlayerHP.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_PlayerHP.border.padding = 
		{
			top = 6,
			right = 8,
			left = 6,
			bottom = 2,
		}
--UFTemplates.Bars.YakUI_140_PlayerHP.icon = GetDefaultYakCareerIcon()
--UFTemplates.Bars.YakUI_140_PlayerHP.icon.anchors[1].y = 15							-- 2.6 beta 2 17 -> 15
UFTemplates.Bars.YakUI_140_PlayerHP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_PlayerHP.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_140_PlayerHP.icon = GetDefaultYakCareerIcon()
UFTemplates.Bars.YakUI_140_PlayerHP.labels.Name = GetDefaultYakLabelName()
UFTemplates.Bars.YakUI_140_PlayerHP.labels.Name.clip_after = 15
UFTemplates.Bars.YakUI_140_PlayerHP.labels.Name.anchors[1].y = 19

UFTemplates.Bars.YakUI_140_PlayerAP = 
{
	grow = "right",
	hide_if_target = false,
	images = {},
	pos_at_world_object = false,
	scale = 1,
	slow_changing_value = false,
	watching_states = {},
	block_layout_editor = false,
	no_tooltip = true,
	show = true,
	hide_if_zero = false,
	name = "PlayerAP",
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	width = 220,
	visibility_group = "none",
	interactive_type = "player",
	height = 11,
	interactive = true,
	state = "PlayerAP",
	anchors = {
		[1] = {
			parent = "PlayerHP",
			parentpoint = "bottomleft",
			point = "topleft",
			x = 0,
			y = 0,
		},
	},
	labels = 
	{
		Value = 
		{
			scale = 0.8,
			follow = "no",
			clip_after = 5,
			formattemplate = "$value",
			alpha_group = "none",
			always_show = false,
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = false,
			font = 
			{
				align = "right",
				name = "font_clear_small_bold",
				case = "none",
			},
			parent = "Bar",
			visibility_group = "none",
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomright",
					point = "bottomright",
					x = -2,
					y = 0,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_PlayerAP.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_PlayerAP.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_PlayerAP.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_PlayerAP.border.padding = 
		{
			top = 0,
			right = 8,
			left = 6,
			bottom = 1,
		}
UFTemplates.Bars.YakUI_140_PlayerAP.icon = Addon.GetDefaultCareerIcon()
UFTemplates.Bars.YakUI_140_PlayerAP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_PlayerAP.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_140_PlayerCareer = 
{
	grow = "right",
	hide_if_target = false,
	images = {},
	pos_at_world_object = false,
	scale = 1,
	slow_changing_value = false,
	watching_states = {},
	width = 220,
	no_tooltip = true,
	hide_if_zero = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	visibility_group = "none",
	block_layout_editor = false,
	show = true,
	interactive = true,
	interactive_type = "player",
	height = 25,
	name = "PlayerCareer",
	state = "PlayerCareer",
	anchors = {
		[1] = {
			parent = "PlayerAP",
			parentpoint = "bottomleft",
			point = "topleft",
			x = 0,
			y = 0,
		},
	},
	labels = 
	{
		Value = 
		{
			parent = "Bar",
			follow = "no",
			clip_after = 5,
			formattemplate = "$value",
			layer = "overlay",
			always_show = false,
			alpha = 1,
			width = 0,
			show = false,
			font = 
			{
				name = "font_clear_small",
				align = "right",
			},
			scale = 1,
			visibility_group = "none",
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "bottomright",
					point = "bottomright",
					x = -2,
					y = -2,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_PlayerCareer.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_PlayerCareer.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_PlayerCareer.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_PlayerCareer.border.padding = 
		{
			top = 0,
			right = 8,
			left = 6,
			bottom = 21,
		}
UFTemplates.Bars.YakUI_140_PlayerCareer.icon = Addon.GetDefaultCareerIcon()
UFTemplates.Bars.YakUI_140_PlayerCareer.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_PlayerCareer.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_140_FriendlyTarget = 
{
	grow = "right",
	hide_if_target = false,
	images = 
	{
		Foreground = 
		{
			parent = "Bar",
			alpha_group = "none",
			scale = 1,
			alpha = 0.6,
			width = 220,
			show = true,
			visibility_group = "none",
			layer = "default",
			height = 50,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 180,
					g = 220,
					b = 255,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
				[2] = {
					parent = "Bar",
					parentpoint = "bottomright",
					point = "bottomright",
					x = 0,
					y = 0,
				},
			},
			texture = 
			{
				scale = 1,
				width = 512,
				y = 0,
				x = 0,
				--style = "cut",
				height = 128,
				name = "LiquidUFFX",
				texture_group = "none",
				slice = "none",
			},
		},
		Background = 
		{
			show = true,
			visibility_group = "none",
			
			alpha = 0.8,
			alpha_group = "none",
			
			parent = "Bar",
			layer = "background",
			
			width = 220,
			height = 50,
			scale = 1,
			
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
				[2] =
				{
					parent = "Bar",
					parentpoint = "bottomright",
					point = "bottomright",
					x = 0,
					y = 0,
				},
			},
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					b = 24,
					g = 24,
					r = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			texture = 
			{
				scale = 1,
				width = 512,
				y = 0,
				x = 0,
				--style = "cut",
				height = 128,
				name = "LiquidUFBG",
				texture_group = "none",
				slice = "none",
			},
		},
	},
	scale = 1,
	pos_at_world_object = false,
	slow_changing_value = false,
	watching_states = {},
	width = 220,
	no_tooltip = true,
	hide_if_zero = false,
	--interactive = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	block_layout_editor = false,
	show = true,
	visibility_group = "none",
	interactive_type = "friendly",
	height = 50,
	name = "FriendlyTarget",
	state = "FTHP",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "topleft",
			x = 210,
			y = 320,
		},
	},
	labels = 
	{
		Value = 
		{
			alpha_group = "none",
			follow = "no",
			clip_after = 3,
			formattemplate = "$value",
			layer = "secondary",
			always_show = false,
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_clear_small_bold",
				case = "none",
			},
			scale = 0.9,
			visibility_group = "none",
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomright",
					point = "topright",
					x = -4,
					y = 3,
				},
			},
		},
		Level = 
		{
			parent = "Bar",
			follow = "no",
			clip_after = 5,
			formattemplate = "$lvl",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "none",
			},
			scale = 0.9,
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			alpha_group = "none",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomleft",
					point = "topleft",
					x = 6,
					y = 3,
				},
			},
		},
		Range = 
		{
			parent = "Bar Fill",
			follow = "no",
			clip_after = 14,
			formattemplate = "$rangemax",
			font = 
			{
				align = "right",
				name = "font_clear_small_bold",
				case = "none",
			},
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = false,
			visibility_group = "none",
			scale = 0.86,
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			alpha_group = "none",
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "right",
					point = "right",
					x = -4,
					y = 6,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_FriendlyTarget.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_FriendlyTarget.fg.colorsettings.color = {r = 0, g = 192, b = 160}
UFTemplates.Bars.YakUI_140_FriendlyTarget.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_FriendlyTarget.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_FriendlyTarget.border.padding = 
		{
			top = 6,
			right = 7,
			left = 7,
			bottom = 22,
		}
--UFTemplates.Bars.YakUI_140_FriendlyTarget.icon = GetDefaultYakCareerIcon()
UFTemplates.Bars.YakUI_140_FriendlyTarget.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_FriendlyTarget.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_140_FriendlyTarget.icon = GetDefaultYakCareerIcon()
UFTemplates.Bars.YakUI_140_FriendlyTarget.labels.Name = GetDefaultYakLabelName()
UFTemplates.Bars.YakUI_140_FriendlyTarget.labels.Name.clip_after = 14
UFTemplates.Bars.YakUI_140_FriendlyTarget.labels.Name.anchors[1].y = 4

UFTemplates.Bars.YakUI_140_HostileTarget = deepcopy(UFTemplates.Bars.YakUI_140_FriendlyTarget)
UFTemplates.Bars.YakUI_140_HostileTarget.fg.colorsettings.color = {r = 192, g = 48, b = 160}
UFTemplates.Bars.YakUI_140_HostileTarget.anchors[1].y = 80
UFTemplates.Bars.YakUI_140_HostileTarget.interactive_type = "none"
UFTemplates.Bars.YakUI_140_HostileTarget.interactive = false
UFTemplates.Bars.YakUI_140_HostileTarget.name = "HostileTarget"
UFTemplates.Bars.YakUI_140_HostileTarget.state = "HTHP"

UFTemplates.Bars.YakUI_140_Pet = deepcopy(UFTemplates.Bars.YakUI_140_FriendlyTarget)
UFTemplates.Bars.YakUI_140_Pet.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_Pet.anchors[1].point = "topright"
UFTemplates.Bars.YakUI_140_Pet.anchors[1].x = -210
UFTemplates.Bars.YakUI_140_Pet.name = "Pet"
UFTemplates.Bars.YakUI_140_Pet.state = "PlayerPetHP"
UFTemplates.Bars.YakUI_140_Pet.interactive_type = "state"


UFTemplates.Bars.YakUI_140_Castbar = 
{
	grow = "right",
	pos_at_world_object = false,
	hide_if_target = false,
	images = 
	{
		--[[Foreground = 
		{
			texture = 
			{
				texture_group = "none",
				slice = "none",
				name = "LiquidCBFX",
				x = 0,
				scale = 1,
				height = 0,
				y = 0,
				width = 0,
				style = "cut",
			},
			scale = 1,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 255,
					g = 220,
					r = 180,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			alpha = 0.6,
			width = 225,
			show = true,
			visibility_group = "none",
			layer = "default",
			height = 20,
			alpha_group = "none",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "topleft",
					point = "topleft",
					x = -7,
					y = -5,
				},
			},
		},
		Background = 
		{
			texture = 
			{
				texture_group = "none",
				slice = "none",
				name = "LiquidCBBG",
				x = 0,
				scale = 1,
				height = 20,
				y = 0,
				width = 225,
			},
			scale = 1,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					r = 24,
					g = 24,
					b = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			parent = "Bar",
			alpha = 0.8,
			width = 225,
			show = true,
			visibility_group = "none",
			layer = "background",
			height = 20,
			alpha_group = "none",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "topleft",
					point = "topleft",
					x = -7,
					y = -5,
				},
			},
		},]]--
		CBEnd = 
		{
			parent = "Bar",
			--follow_bg_alpha = true,
			alpha_group = "none",
			scale = 1,
			alpha = 1,
			width = 20,
			show = true,
			visibility_group = "none",
			layer = "secondary",
			height = 25,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 255,
					g = 255,
					b = 255,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar Fill",
					parentpoint = "right",
					point = "left",
					x = -10,
					y = 0,
				},
			},
			texture = 
			{
				texture_group = "none",
				slice = "none",
				name = "LiquidCBBarEnd",
				x = 0,
				scale = 1,
				y = 0,
				height = 25,
				width = 20,
			},
		},
	},
	scale = 1,
	show = true,
	interactive = false,
	slow_changing_value = false,
	watching_states = {},
	width = 225,
	no_tooltip = true,
	state = "Castbar",
	hide_if_zero = true,
	name = "Castbar",
	show_with_target = false,
	block_layout_editor = false,
	visibility_group = "none",
	interactive_type = "none",
	height = 20,
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "bottom",
			point = "bottom",
			x = -130,
			y = -320,
		},
	},
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
	labels = 
	{
		Name = 
		{
			scale = 0.8,
			follow = "no",
			clip_after = 20,
			formattemplate = "$title",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "center",
				name = "font_clear_small_bold",
				case = "upper",
			},
			parent = "Bar",
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			always_show = false,
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottom",
					point = "top",
					x = 0,
					y = 4,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_Castbar.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_Castbar.fg.texture = {
	scale = 1,
	width = 211,
	texture_group = "none",
	slice = "none",
	name = "LiquidCBBar",
	height = 10,
	style = "cut",
	y = 0,
	x = 0,
}
UFTemplates.Bars.YakUI_140_Castbar.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_Castbar.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_Castbar.border.padding = {
	top = 5,
	right = 7,
	left = 7,
	bottom = 5,
}
UFTemplates.Bars.YakUI_140_Castbar.images.Background = Addon.GetDefaultImage()
UFTemplates.Bars.YakUI_140_Castbar.images.Background.texture.name = "LiquidCBBG"
UFTemplates.Bars.YakUI_140_Castbar.images.Background.colorsettings.color = { r = 24, g = 24, b = 24 }
UFTemplates.Bars.YakUI_140_Castbar.images.Background.alpha = 0.8
UFTemplates.Bars.YakUI_140_Castbar.images.Background.layer = "background"
UFTemplates.Bars.YakUI_140_Castbar.images.Background.anchors[2] = Addon.GetDefaultAnchorTwo()
--UFTemplates.Bars.YakUI_140_Castbar.images.Background.width = 225
--UFTemplates.Bars.YakUI_140_Castbar.images.Background.height = 20
UFTemplates.Bars.YakUI_140_Castbar.images.Foreground = Addon.GetDefaultImage()
UFTemplates.Bars.YakUI_140_Castbar.images.Foreground.texture.name = "LiquidCBFX"
UFTemplates.Bars.YakUI_140_Castbar.images.Foreground.colorsettings.color = { r = 180, g = 220, b = 255 }
UFTemplates.Bars.YakUI_140_Castbar.images.Foreground.alpha = 0.6
UFTemplates.Bars.YakUI_140_Castbar.images.Foreground.anchors[2] = Addon.GetDefaultAnchorTwo()
--UFTemplates.Bars.YakUI_140_Castbar.images.Foreground.width = 225
--UFTemplates.Bars.YakUI_140_Castbar.images.Foreground.height = 20

UFTemplates.Bars.YakUI_140_Castbar.icon = Addon.GetDefaultCareerIcon()
UFTemplates.Bars.YakUI_140_Castbar.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_Castbar.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_140_Targets = 
{
	grow = "right",
	scale = 1,
	hide_if_target = false,
	images = 
	{
		Foreground = 
		{
			parent = "Bar",
			texture = 
			{
				scale = 1,
				width = 512,
				texture_group = "none",
				x = 0,
				name = "LiquidUFFX",
				height = 128,
				y = 0,
				slice = "none",
			},
			--follow_bg_alpha = true,
			alpha_group = "none",
			layer = "default",
			alpha = 0.6,
			width = 140,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			scale = 1,
			height = 32,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 255,
					g = 220,
					r = 180,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parentpoint = "topleft",
					x = 0,
					point = "topleft",
					parent = "Bar",
					y = 0,
				},
				
				[2] = {
					parentpoint = "bottomright",
					x = 0,
					point = "bottomright",
					parent = "Bar",
					y = 0,
				},
			},
		},
		Background = 
		{
			parent = "Bar",
			texture = 
			{
				scale = 1,
				width = 512,
				texture_group = "none",
				x = 0,
				name = "LiquidUFBG",
				height = 128,
				y = 0,
				slice = "none",
			},
			--follow_bg_alpha = true,
			alpha_group = "none",
			layer = "background",
			alpha = 0.8,
			width = 140,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			scale = 1,
			height = 32,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					r = 24,
					g = 24,
					b = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parentpoint = "topleft",
					x = 0,
					point = "topleft",
					parent = "Bar",
					y = 0,
				},
				
				[2] = {
					parentpoint = "bottomright",
					x = 0,
					point = "bottomright",
					parent = "Bar",
					y = 0,
				},
			},
		},
	},
	pos_at_world_object = false,
	slow_changing_value = false,
	watching_states = {},
	block_layout_editor = false,
	no_tooltip = false,
	state = "grpCH1hp",
	hide_if_zero = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	width = 132,
	show = true,
	visibility_group = "none",
	interactive = true,
	interactive_type = "friendly",
	height = 28,
	name = "TargetsHostile1",
	anchors = {
		[1] = {
			parent = "Root",
			parentpoint = "right",
			point = "bottomright",
			x = -300,
			y = -60,
		},
	},
	labels = 
	{
		Level = 
		{
			scale = 0.9,
			clip_after = 2,
			formattemplate = "$lvl",
			parent = "Bar",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "none",
			},
			alpha_group = "none",
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			follow = "no",
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "left",
					point = "left",
					x = 6,
					y = 5,
				},
			},
		},
		Name = 
		{
			parent = "Bar",
			clip_after = 8,
			formattemplate = "$title",
			layer = "secondary",
			alpha_group = "none",
			always_show = false,
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "upper",
			},
			scale = 0.86,
			visibility_group = "none",
			height = 24,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			follow = "no",
			anchors = {
				[1] = {
					parent = "LabelLevel",
					parentpoint = "left",
					point = "left",
					x = 42,
					y = 0,
				},
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_Targets.fg = GetDefaultYakBarFG()
UFTemplates.Bars.YakUI_140_Targets.fg.colorsettings.color = {r = 192, g = 48, b = 160}
UFTemplates.Bars.YakUI_140_Targets.bg = GetDefaultYakBarBG()
UFTemplates.Bars.YakUI_140_Targets.border = GetDefaultYakBarBorder()
UFTemplates.Bars.YakUI_140_Targets.border.padding = {
	top = 4,
	right = 4,
	left = 4,
	bottom = 4,
}
UFTemplates.Bars.YakUI_140_Targets.icon = GetDefaultYakCareerIcon()
UFTemplates.Bars.YakUI_140_Targets.icon.anchors[1].y = -4
--[[UFTemplates.Bars.YakUI_140_Targets.icon.anchors[1] = {
	parentpoint = "left",
	x = 32,
	point = "left",
	parent = "Bar",
	y = -4,
}]]--
UFTemplates.Bars.YakUI_140_Targets.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_Targets.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.YakUI_140_MouseoverTarget = 
{
	grow = "right",
	scale = 1,
	hide_if_target = false,
	images = 
	{
		Foreground = 
		{
			texture = 
			{
				scale = 1,
				width = 512,
				y = 0,
				slice = "none",
				--style = "grow",
				height = 128,
				x = 0,
				texture_group = "none",
				name = "LiquidUFFX",
			},
			parent = "Bar",
			alpha_group = "none",
			scale = 1,
			alpha = 0.6,
			width = 219,
			show = true,
			visibility_group = "none",
			layer = "default",
			height = 50,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 255,
					g = 220,
					r = 180,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 1,
					y = 0,
				},
			},
		},
		Background = 
		{
			texture = 
			{
				scale = 1,
				width = 512,
				y = 0,
				slice = "none",
				--style = "grow",
				height = 128,
				x = 0,
				texture_group = "none",
				name = "LiquidUFBG",
			},
			parent = "Bar",
			alpha_group = "none",
			scale = 1,
			alpha = 0.8,
			width = 220,
			show = true,
			visibility_group = "none",
			layer = "background",
			height = 50,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 24,
					g = 24,
					r = 24,
				},
				allow_overrides = false,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "topleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
		},
	},
	pos_at_world_object = false,
	border = 
	{
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 0,
				g = 0,
				r = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		follow_bg_alpha = false,
		padding = 
		{
			top = 6,
			right = 6,
			left = 8,
			bottom = 34,
		},
		alpha = 0,
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			slice = "none",
			--style = "cut",
			height = 0,
			name = "tint_square",
			y = 0,
			x = 0,
		},
	},
	rvr_icon = 
	{
		show = true,
		follow_bg_alpha = false,
		scale = 0.55,
		alpha = 1,
		anchors = {
			[1] = {
				parent = "Bar",
				parentpoint = "topleft",
				point = "topleft",
				x = -6,
				y = -12,
			},
		},
	},
	fg = 
	{
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 220,
				g = 220,
				r = 220,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 
		{
			clamp = 0.366,
			alter = "no",
			in_combat = 1,
			out_of_combat = 1,
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			slice = "none",
			style = "cut",
			height = 0,
			name = "LiquidBar",
			y = 0,
			x = 0,
		},
	},
	icon = 
	{
		show = true,
		follow_bg_alpha = false,
		scale = 0.44,
		alpha = 1,
		anchors = {
			[1] = {
				parent = "LabelLevel",
				parentpoint = "left",
				point = "left",
				x = 24,
				y = 0,
			},
		},
	},
	slow_changing_value = false,
	watching_states = {},
	bg = 
	{
		show = true,
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 0,
				g = 0,
				r = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 
		{
			in_combat = 0,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			slice = "none",
			--style = "cut",
			height = 0,
			name = "tint_square",
			y = 0,
			x = 0,
		},
	},
	block_layout_editor = false,
	no_tooltip = true,
	state = "MOHP",
	hide_if_zero = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	width = 220,
	anchors = {
		[1] = {
			parent = "EA_Window_RvRTracker",
			parentpoint = "topright",
			point = "bottomright",
			x = 0,
			y = 0,
		},
	},
	visibility_group = "none",
	name = "MouseoverTarget",
	interactive_type = "none",
	height = 50,
	interactive = false,
	show = true,
	labels = 
	{
		Level = 
		{
			scale = 0.8,
			clip_after = 6,
			formattemplate = "$lvl",
			alpha_group = "none",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "none",
			},
			parent = "Bar",
			visibility_group = "none",
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 220,
					g = 220,
					r = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			follow = "no",
			anchors = {
				[1] = {
					parent = "LabelName",
					parentpoint = "bottomleft",
					point = "topleft",
					x = 0,
					y = 0,
				},
			},
		},
		Quest = 
		{
			parent = "Bar",
			follow = "no",
			clip_after = 32,
			formattemplate = "$npcTitle $quest",
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			scale = 0.9,
			height = 13,
			anchors = {
				[1] = {
					parent = "Bar",
					parentpoint = "bottomright",
					point = "bottomright",
					x = -4,
					y = -4,
				},
			},
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = false,
				color_group = "none",
			},
			font = 
			{
				align = "right",
				name = "font_clear_tiny",
				case = "none",
			},
		},
		Name = 
		{
			parent = "Bar",
			follow = "no",
			clip_after = 48,
			formattemplate = "$title",
			layer = "overlay",
			alpha = 1,
			width = 200,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			scale = 0.9,
			height = 15,
			colorsettings = 
			{
				ColorPreset = "none",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 220,
					g = 220,
					b = 220,
				},
				allow_overrides = true,
				color_group = "none",
			},
			anchors = {
				[1] = {
					parent = "Bar BG",
					parentpoint = "bottomleft",
					point = "topleft",
					x = 2,
					y = 3,
				},
			},
			font = 
			{
				align = "left",
				name = "font_clear_small_bold",
				case = "upper",
			},
		},
	},
}
UFTemplates.Bars.YakUI_140_MouseoverTarget.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_140_MouseoverTarget.images.Foreground.anchors[2] = Addon.GetDefaultAnchorTwo()
UFTemplates.Bars.YakUI_140_MouseoverTarget.images.Background.anchors[2] = Addon.GetDefaultAnchorTwo()

UFTemplates.Bars.YakUI_140_InfoPanelRenown = 
{
	grow = "right",
	hide_if_target = false,
	images = {},
	pos_at_world_object = false,
	border = 
	{
		padding = 
		{
			top = 0,
			right = 0,
			left = 0,
			bottom = 0,
		},
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 0,
				g = 0,
				b = 0,
			},
			color_group = "none",
			allow_overrides = false,
		},
		follow_bg_alpha = false,
		alpha = 0,
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "tint_square",
			height = 0,
			--style = "cut",
			y = 0,
			slice = "none",
		},
	},
	state = "PlayerRenown",
	fg = 
	{
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 255,
				g = 255,
				b = 255,
			},
			color_group = "none",
			allow_overrides = true,
		},
		alpha = 
		{
			clamp = 0.2,
			out_of_combat = 0,
			in_combat = 0,
			alter = "no",
		},
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "tint_square",
			height = 0,
			style = "cut",
			y = 0,
			slice = "none",
		},
	},
	name = "InfoPanelRenown",
	slow_changing_value = false,
	watching_states = 
	{
	},
	bg = 
	{
		show = true,
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				r = "no",
				g = "no",
				b = "no",
			},
			color = 
			{
				r = 30,
				g = 30,
				b = 30,
			},
			color_group = "none",
			allow_overrides = false,
		},
		alpha = 
		{
			in_combat = 0,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "tint_square",
			height = 0,
			--style = "cut",
			y = 0,
			slice = "none",
		},
	},
	width = 260,
	no_tooltip = false,
	hide_if_zero = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	block_layout_editor = true,
	show = true,
	visibility_group = "none",
	interactive = true,
	interactive_type = "state",
	height = 20,
	scale = 1,
	anchors = {
		[1] = {
			parent = "InfoPanel",
			parentpoint = "center",
			point = "bottomleft",
			x = 24,
			y = -2,
		},
	},
	labels = {},
}
UFTemplates.Bars.YakUI_140_InfoPanelRenown.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_140_InfoPanelRenown.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_InfoPanelRenown.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.YakUI_140_InfoPanelExp = 
{
	grow = "right",
	hide_if_target = false,
	images = {},
	pos_at_world_object = false,
	border = 
	{
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 0,
				g = 0,
				r = 0,
			},
			color_group = "none",
			allow_overrides = false,
		},
		padding = 
		{
			top = 0,
			right = 0,
			left = 0,
			bottom = 0,
		},
		follow_bg_alpha = false,
		alpha = 0,
		texture = 
		{
			scale = 1,
			width = 0,
			y = 0,
			x = 0,
			--style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "tint_square",
		},
	},
	bg = 
	{
		show = true,
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 30,
				g = 30,
				r = 30,
			},
			color_group = "none",
			allow_overrides = false,
		},
		alpha = 
		{
			in_combat = 0,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 1,
			width = 0,
			y = 0,
			x = 0,
			--style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "tint_square",
		},
	},
	fg = 
	{
		colorsettings = 
		{
			ColorPreset = "none",
			alter = 
			{
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 255,
				g = 255,
				r = 255,
			},
			color_group = "none",
			allow_overrides = true,
		},
		alpha = 
		{
			clamp = 0.2,
			alter = "no",
			in_combat = 0,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 1,
			width = 0,
			y = 0,
			x = 0,
			style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "tint_square",
		},
	},
	scale = 1,
	slow_changing_value = false,
	watching_states = {},
	block_layout_editor = true,
	no_tooltip = false,
	show = true,
	hide_if_zero = false,
	interactive = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	visibility_group = "none",
	width = 260,
	interactive_type = "state",
	height = 20,
	name = "InfoPanelExp",
	state = "Exp",
	anchors = {
		[1] = {
			parent = "InfoPanel",
			parentpoint = "center",
			point = "bottomright",
			x = -24,
			y = -2,
		},
	},
	labels = {},
}
UFTemplates.Bars.YakUI_140_InfoPanelExp.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.YakUI_140_InfoPanelExp.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.YakUI_140_InfoPanelExp.icon = Addon.GetDefaultCareerIcon()

--
-- Layout
--
UFTemplates.Layouts.YakUI_140 = {}
UFTemplates.Layouts.YakUI_140.InfoPanel = UFTemplates.Bars.YakUI_140_InfoPanel
UFTemplates.Layouts.YakUI_140.InfoPanelRenown = UFTemplates.Bars.YakUI_140_InfoPanelRenown
UFTemplates.Layouts.YakUI_140.InfoPanelExp = UFTemplates.Bars.YakUI_140_InfoPanelExp
UFTemplates.Layouts.YakUI_140.PlayerHP = UFTemplates.Bars.YakUI_140_PlayerHP
UFTemplates.Layouts.YakUI_140.PlayerAP = UFTemplates.Bars.YakUI_140_PlayerAP
UFTemplates.Layouts.YakUI_140.PlayerCareer = UFTemplates.Bars.YakUI_140_PlayerCareer
UFTemplates.Layouts.YakUI_140.HostileTarget = UFTemplates.Bars.YakUI_140_HostileTarget
UFTemplates.Layouts.YakUI_140.FriendlyTarget = UFTemplates.Bars.YakUI_140_FriendlyTarget
UFTemplates.Layouts.YakUI_140.Castbar = UFTemplates.Bars.YakUI_140_Castbar
UFTemplates.Layouts.YakUI_140.Pet = UFTemplates.Bars.YakUI_140_Pet
UFTemplates.Layouts.YakUI_140.MouseoverTarget = UFTemplates.Bars.YakUI_140_MouseoverTarget

UFTemplates.Layouts.YakUI_140.FriendlyTargetRing = deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.YakUI_140.FriendlyTargetRing.visibility_group = "HideIfSelf"
UFTemplates.Layouts.YakUI_140.HostileTargetRing = deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.YakUI_140.HostileTargetRing.name = "HostileTargetRing"
UFTemplates.Layouts.YakUI_140.HostileTargetRing.state = "HTHP"
UFTemplates.Layouts.YakUI_140.HostileTargetRing.anchors[1].parent = "HostileTargetRingInvisi"
UFTemplates.Layouts.YakUI_140.HostileTargetRing.border.colorsettings.color.r = 255
UFTemplates.Layouts.YakUI_140.HostileTargetRing.border.colorsettings.color.g = 0

for i = 1, 5 do
	UFTemplates.Layouts.YakUI_140["GroupMember"..i] = deepcopy(UFTemplates.Bars.YakUI_140_GroupMember)
	UFTemplates.Layouts.YakUI_140["GroupMember"..i].name = "GroupMember"..i
	UFTemplates.Layouts.YakUI_140["GroupMember"..i].state = "grp"..(i+1).."hp"
	UFTemplates.Layouts.YakUI_140["GroupMember"..i].anchors[1].parent = "Root"
	UFTemplates.Layouts.YakUI_140["GroupMember"..i].anchors[1].x = 0
end
UFTemplates.Layouts.YakUI_140.GroupMember2.anchors[1].parentpoint = "topleft"
UFTemplates.Layouts.YakUI_140.GroupMember2.anchors[1].point = "topleft"
UFTemplates.Layouts.YakUI_140.GroupMember2.anchors[1].y = 225
UFTemplates.Layouts.YakUI_140.GroupMember3.anchors[1].parentpoint = "topleft"
UFTemplates.Layouts.YakUI_140.GroupMember3.anchors[1].point = "topleft"
UFTemplates.Layouts.YakUI_140.GroupMember3.anchors[1].y = 375
UFTemplates.Layouts.YakUI_140.GroupMember4.anchors[1].parentpoint = "left"
UFTemplates.Layouts.YakUI_140.GroupMember4.anchors[1].point = "left"
UFTemplates.Layouts.YakUI_140.GroupMember4.anchors[1].y = -245
UFTemplates.Layouts.YakUI_140.GroupMember5.anchors[1].parentpoint = "left"
UFTemplates.Layouts.YakUI_140.GroupMember5.anchors[1].point = "left"
UFTemplates.Layouts.YakUI_140.GroupMember5.anchors[1].y = -95

for i = 1,5 do
	UFTemplates.Layouts.YakUI_140["WorldGroupMember"..i] = deepcopy(UFTemplates.Bars.YakUI_140_WorldGroupMember)
	UFTemplates.Layouts.YakUI_140["WorldGroupMember"..i].name = "WorldGroupMember"..i
	UFTemplates.Layouts.YakUI_140["WorldGroupMember"..i].state = "grp"..(i+1).."hp"
	UFTemplates.Layouts.YakUI_140["WorldGroupMember"..i].anchors[1].parent = "WorldGroupMember"..i.."Invisi"
end
	
UFTemplates.Layouts.YakUI_140.TargetsHostile1 = deepcopy(UFTemplates.Bars.YakUI_140_Targets)
for i = 2,6 do
	UFTemplates.Layouts.YakUI_140["TargetsHostile"..i] = deepcopy(UFTemplates.Bars.YakUI_140_Targets)
	UFTemplates.Layouts.YakUI_140["TargetsHostile"..i].name = "TargetsHostile"..i
	UFTemplates.Layouts.YakUI_140["TargetsHostile"..i].state = "grpCH"..i.."hp"
	UFTemplates.Layouts.YakUI_140["TargetsHostile"..i].anchors[1] = {
		parent = "TargetsHostile"..i-1,
		parentpoint = "bottomleft",
		point = "topleft",
		x = 0,
		y = 20,
	}
	UFTemplates.Layouts.YakUI_140["TargetsHostile"..i].block_layout_editor = true
end

UFTemplates.Layouts.YakUI_140.TargetsFriendly1 = deepcopy(UFTemplates.Bars.YakUI_140_Targets)
UFTemplates.Layouts.YakUI_140.TargetsFriendly1.name = "TargetsFriendly1"
UFTemplates.Layouts.YakUI_140.TargetsFriendly1.state = "grpCF1hp"
UFTemplates.Layouts.YakUI_140.TargetsFriendly1.anchors[1].parentpoint = "left"
UFTemplates.Layouts.YakUI_140.TargetsFriendly1.anchors[1].point = "bottomleft"
UFTemplates.Layouts.YakUI_140.TargetsFriendly1.anchors[1].x = UFTemplates.Layouts.YakUI_140.TargetsFriendly1.anchors[1].x * -1
UFTemplates.Layouts.YakUI_140.TargetsFriendly1.fg.colorsettings.color = { r = 220, g = 220,	b = 220}

for i = 2,6 do
	UFTemplates.Layouts.YakUI_140["TargetsFriendly"..i] = deepcopy(UFTemplates.Bars.YakUI_140_Targets)
	UFTemplates.Layouts.YakUI_140["TargetsFriendly"..i].name = "TargetsFriendly"..i
	UFTemplates.Layouts.YakUI_140["TargetsFriendly"..i].state = "grpCF"..i.."hp"
	UFTemplates.Layouts.YakUI_140["TargetsFriendly"..i].anchors[1] = {
		parent = "TargetsFriendly"..i-1,
		parentpoint = "bottomleft",
		point = "topleft",
		x = 0,
		y = 20,
	}
	UFTemplates.Layouts.YakUI_140["TargetsFriendly"..i].fg.colorsettings.color = { r = 220, g = 220, b = 220}
	UFTemplates.Layouts.YakUI_140["TargetsFriendly"..i].block_layout_editor = true
end