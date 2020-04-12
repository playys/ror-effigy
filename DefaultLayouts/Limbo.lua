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

UFTemplates.Layouts.Limbo = {}

UFTemplates.Layouts.Limbo.PlayerHP = 
{
	grow = "right",
	hide_if_target = false,
	images = {},
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
				b = 187,
				g = 207,
				r = 0,
			},
			allow_overrides = false,
			color_group = "LimboLife",
		},
		alpha = 
		{
			clamp = 0.366,
			alter = "no",
			in_combat = 1,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			slice = "none",
			style = "cut",
			height = 0,
			name = "XPerl_StatusBar3",
			y = 0,
			x = 0,
		},
	},
	no_tooltip = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	block_layout_editor = true,
	visibility_group = "none",
	name = "PlayerHP",
	interactive_type = "player",
	height = 22,
	scale = 1,
	border = 
	{
		follow_bg_alpha = false,
		padding = 
		{
			top = 2,
			right = 2,
			left = 2,
			bottom = 2,
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
				b = 0,
				g = 0,
				r = 0,
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
			style = "cut",
			height = 0,
			name = "tint_square",
			y = 0,
			x = 0,
		},
	},
	slow_changing_value = false,
	watching_states = {},
	hide_if_zero = false,
	show_with_target = false,
	width = 187,
	show = true,
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
			in_combat = 1,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 2,
			width = 0,
			texture_group = "none",
			slice = "none",
			style = "cut",
			height = 0,
			name = "tint_square",
			y = 7,
			x = 4,
		},
	},
	interactive = true,
	state = "PlayerHP",
	pos_at_world_object = false,
	invValue = false,
	anchors = {
		[1] = {
			parent = "Root",
			point = "bottom",
			parentpoint = "bottom",
			x = -148,
			y = -262,
		},
	},
	labels = 
	{
		Value = 
		{
			alpha_group = "none",
			clip_after = 5,
			formattemplate = "$value",
			follow = "no",
			layer = "secondary",
			always_show = false,
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "center",
				name = "font_default_sub_heading",
				case = "none",
			},
			scale = 0.6,
			visibility_group = "CombatOrNotFull",
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
					point = "center",
					parentpoint = "center",
					x = 0,
					y = 2,
				},
			},
		},
	},
}
UFTemplates.Layouts.Limbo.PlayerHP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Layouts.Limbo.PlayerHP.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Layouts.Limbo.PlayerHP.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Layouts.Limbo.PlayerAP = 
{
	grow = "right",
	pos_at_world_object = false,
	hide_if_target = false,
	images = {},
	scale = 1,
	border = 
	{
		follow_bg_alpha = false,
		padding = 
		{
			top = 0.7,
			right = 2,
			left = 2,
			bottom = 2,
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
				b = 0,
				g = 0,
				r = 0,
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
			style = "cut",
			height = 0,
			name = "tint_square",
			y = 0,
			x = 0,
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
				b = 198,
				g = 255,
				r = 220,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 
		{
			clamp = 0.366,
			out_of_combat = 0,
			in_combat = 1,
			alter = "no",
		},
		texture = 
		{
			scale = 0,
			width = 0,
			texture_group = "none",
			slice = "none",
			name = "XPerl_StatusBar3",
			height = 0,
			style = "cut",
			y = 0,
			x = 0,
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
				b = 24,
				g = 24,
				r = 24,
			},
			color_group = "none",
			allow_overrides = false,
		},
		alpha = 
		{
			in_combat = 1,
			out_of_combat = 0,
		},
		texture = 
		{
			scale = 2,
			width = 0,
			y = 7,
			x = 4,
			style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "tint_square",
		},
	},
	slow_changing_value = true,
	watching_states = {},
	block_layout_editor = true,
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
	width = 187,
	visibility_group = "none",
	interactive_type = "none",
	height = 11,
	interactive = false,
	state = "PlayerAP",
	anchors = {
		[1] = {
			parent = "PlayerHP",
			point = "topleft",
			parentpoint = "bottomleft",
			x = 0,
			y = 0,
		},
	},
	labels = 
	{
		Value = 
		{
			parent = "Bar",
			clip_after = 5,
			show_if_target = false,
			formattemplate = "$value",
			follow = "no",
			layer = "secondary",
			always_show = false,
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_default_sub_heading",
				case = "none",
			},
			scale = 0.4,
			visibility_group = "Combat",
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
					point = "bottomright",
					parentpoint = "bottomright",
					x = -3,
					y = 0,
				},
			},
		},
	},
}
UFTemplates.Layouts.Limbo.PlayerAP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Layouts.Limbo.PlayerAP.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Layouts.Limbo.PlayerAP.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Layouts.Limbo.FriendlyTarget = 
{
	grow = "right",
	scale = 1,
	hide_if_target = false,
	images = 
	{
		Background = 
		{
			alpha_group = "none",
			texture = 
			{
				scale = 1,
				width = 512,
				texture_group = "none",
				x = 0,
				name = "tint_square",
				height = 128,
				style = "cut",
				y = 0,
				slice = "none",
			},
			parent = "Bar",
			layer = "background",
			alpha = 1,
			width = 187,
			show = true,
			visibility_group = "none",
			scale = 1,
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
			height = 33,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar BG",
					point = "topleft",
					parentpoint = "topleft",
					x = -2,
					y = -2,
				},
			},
		},
	},
	pos_at_world_object = false,
	border = 
	{
		padding = 
		{
			top = 2,
			right = 2,
			left = 2,
			bottom = 0,
		},
		follow_bg_alpha = false,
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
			y = 0,
			slice = "none",
			name = "tint_square",
			height = 0,
			x = 0,
			texture_group = "none",
			style = "cut",
		},
	},
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
				r = 0,
				g = 192,
				b = 160,
			},
			allow_overrides = true,
			color_group = "none",
		},
		alpha = 
		{
			clamp = 0.366,
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		texture = 
		{
			scale = 0,
			width = 0,
			y = 0,
			slice = "none",
			name = "XPerl_StatusBar3",
			height = 0,
			x = 0,
			texture_group = "none",
			style = "cut",
		},
	},
	icon = 
	{
		scale = 0.73,
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "center",
				parentpoint = "left",
				x = -2,
				y = 1,
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
			scale = 2,
			width = 0,
			y = 7,
			slice = "none",
			name = "tint_square",
			height = 0,
			x = 4,
			texture_group = "none",
			style = "cut",
		},
	},
	width = 187,
	no_tooltip = false,
	hide_if_zero = false,
	interactive = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	block_layout_editor = true,
	state = "FTHP",
	visibility_group = "none",
	name = "FriendlyTarget",
	interactive_type = "friendly",
	height = 20,
	show = true,
	anchors = {
		[1] = {
			parent = "Root",
			point = "bottomright",
			parentpoint = "bottomright",
			x = -279,
			y = -265,
		},
	},
	labels = 
	{
		Career = 
		{
			parent = "Bar",
			follow = "no",
			clip_after = 15,
			formattemplate = "$career",
			font = 
			{
				align = "right",
				name = "font_default_sub_heading",
				case = "none",
			},
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			scale = 0.4,
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
					parent = "ImageBackground",
					point = "bottomright",
					parentpoint = "bottomright",
					x = -2,
					y = -1,
				},
			},
		},
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
				align = "center",
				name = "font_default_sub_heading",
				case = "none",
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
			scale = 0.6,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "center",
					parentpoint = "center",
					x = 0,
					y = 2,
				},
			},
		},
		Level = 
		{
			scale = 0.52,
			follow = "no",
			clip_after = 14,
			formattemplate = "$lvl",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			font = 
			{
				align = "right",
				name = "font_heading_target_mouseover_name",
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
			parent = "Bar",
			anchors = {
				[1] = {
					parent = "Bar",
					point = "right",
					parentpoint = "right",
					x = -3,
					y = 3,
				},
			},
		},
		Range = 
		{
			scale = 0.86,
			clip_after = 14,
			formattemplate = "$rangemax",
			follow = "no",
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
			alpha_group = "none",
			parent = "Bar Fill",
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
			visibility_group = "none",
			anchors = {
				[1] = {
					parent = "Bar",
					point = "right",
					parentpoint = "right",
					x = -4,
					y = 6,
				},
			},
		},
		Name = 
		{
			alpha_group = "none",
			clip_after = 24,
			formattemplate = "$title",
			follow = "no",
			layer = "overlay",
			always_show = false,
			alpha = 1,
			width = 400,
			show = true,
			font = 
			{
				align = "left",
				name = "font_default_sub_heading",
				case = "none",
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
			scale = 0.53,
			anchors = {
				[1] = {
					parent = "ImageBackground",
					point = "bottomleft",
					parentpoint = "bottomleft",
					x = 2,
					y = 1,
				},
			},
		},
	},
}
UFTemplates.Layouts.Limbo.FriendlyTarget.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Layouts.Limbo.FriendlyTarget.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Layouts.Limbo.Castbar = 
{
	grow = "right",
	hide_if_target = false,
	images = {},
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
				b = 120,
				g = 120,
				r = 120,
			},
			color_group = "none",
			allow_overrides = false,
		},
		alpha = 
		{
			clamp = 0.2,
			alter = "no",
			in_combat = 1,
			out_of_combat = 1,
		},
		texture = 
		{
			scale = 1,
			width = 211,
			texture_group = "none",
			slice = "none",
			name = "XPerl_StatusBar3",
			height = 10,
			x = 0,
			y = 0,
			style = "cut",
		},
	},
	icon = 
	{
		scale = 0.3,
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "left",
				parentpoint = "left",
				x = -1,
				y = 2,
			},
		},
	},
	no_tooltip = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	block_layout_editor = true,
	state = "Castbar",
	name = "Castbar",
	interactive_type = "none",
	height = 21,
	scale = 1,
	border = 
	{
		follow_bg_alpha = false,
		padding = 
		{
			top = 2,
			right = 2,
			left = 2,
			bottom = 2,
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
				b = 0,
				g = 0,
				r = 0,
			},
			allow_overrides = false,
			color_group = "none",
		},
		alpha = 0,
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
	slow_changing_value = false,
	watching_states = {},
	hide_if_zero = true,
	show_with_target = false,
	visibility_group = "none",
	width = 410,
	show = true,
	interactive = false,
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
				b = 0,
				g = 0,
				r = 0,
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
			width = 0,
			y = 7,
			x = 4,
			style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "tint_square",
		},
	},
	pos_at_world_object = false,
	invValue = false,
	anchors = {
		[1] = {
			parent = "Root",
			point = "bottom",
			parentpoint = "bottom",
			x = 0,
			y = -337,
		},
	},
	labels = 
	{
		Name = 
		{
			alpha_group = "none",
			clip_after = 20,
			formattemplate = "$title",
			follow = "no",
			always_show = false,
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "center",
				name = "font_default_sub_heading",
				case = "none",
			},
			scale = 0.6,
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
					parent = "Bar BG",
					point = "center",
					parentpoint = "center",
					x = 0,
					y = 0,
				},
			},
		},
	},
}
UFTemplates.Layouts.Limbo.Castbar.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Layouts.Limbo.Castbar.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Layouts.Limbo.PlayerCareer = 
{
	grow = "right",
	pos_at_world_object = false,
	hide_if_target = false,
	images = {},
	scale = 1,
	border = 
	{
		follow_bg_alpha = false,
		padding = 
		{
			top = 2,
			right = 2,
			left = 2,
			bottom = 2,
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
				b = 0,
				g = 0,
				r = 0,
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
			style = "cut",
			height = 0,
			name = "tint_square",
			y = 0,
			x = 0,
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
				b = 95,
				g = 150,
				r = 190,
			},
			allow_overrides = false,
			color_group = "mechanic-berserk",
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
			style = "grow",
			height = 0,
			name = "XPerl_StatusBar3",
			y = 0,
			x = 0,
		},
	},
	name = "PlayerCareer",
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
				r = "no",
				g = "no",
				b = "no",
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
		alpha = 
		{
			in_combat = 1,
			out_of_combat = 1,
		},
		texture = 
		{
			scale = 2,
			width = 0,
			y = 7,
			x = 4,
			style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "tint_square",
		},
	},
	block_layout_editor = true,
	no_tooltip = false,
	hide_if_zero = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	visibility_group = "none",
	width = 410,
	show = true,
	interactive = false,
	interactive_type = "none",
	height = 16,
	state = "PlayerCareer",
	anchors = {
		[1] = {
			parent = "Root",
			point = "bottom",
			parentpoint = "bottom",
			x = 0,
			y = -305,
		},
	},
	labels = 
	{
		Value = 
		{
			alpha_group = "none",
			clip_after = 5,
			formattemplate = "$value",
			follow = "no",
			always_show = false,
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "center",
				name = "font_default_sub_heading",
				case = "none",
			},
			scale = 0.4,
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
					point = "center",
					parentpoint = "center",
					x = 0,
					y = 0,
				},
			},
		},
	},
}
UFTemplates.Layouts.Limbo.PlayerCareer.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Layouts.Limbo.PlayerCareer.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Layouts.Limbo.PlayerCareer.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Layouts.Limbo.HostileTarget = 
{
	grow = "right",
	scale = 1,
	hide_if_target = false,
	images = 
	{
		Background = 
		{
			alpha_group = "none",
			scale = 1,
			layer = "background",
			alpha = 1,
			width = 187,
			show = true,
			visibility_group = "none",
			parent = "Bar",
			follow_bg_alpha = false,
			height = 33,
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
			anchors = {
				[1] = {
					parent = "Bar BG",
					point = "topleft",
					parentpoint = "topleft",
					x = -2,
					y = -2,
				},
			},
			texture = 
			{
				scale = 1,
				width = 512,
				y = 0,
				x = 0,
				name = "tint_square",
				height = 128,
				style = "cut",
				texture_group = "none",
				slice = "none",
			},
		},
	},
	pos_at_world_object = false,
	border = 
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
		alpha = 0,
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
				b = 0,
				g = 0,
				r = 180,
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
			x = 0,
			name = "XPerl_StatusBar3",
			height = 0,
			style = "cut",
			y = 0,
			slice = "none",
		},
	},
	icon = 
	{
		scale = 0.73,
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "center",
				parentpoint = "left",
				x = -2,
				y = 1,
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
			scale = 2,
			width = 0,
			texture_group = "none",
			x = 4,
			name = "tint_square",
			height = 0,
			style = "cut",
			y = 7,
			slice = "none",
		},
	},
	width = 187,
	no_tooltip = false,
	hide_if_zero = false,
	--interactive = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "none",
	},
	show_with_target = false,
	block_layout_editor = true,
	state = "HTHP",
	visibility_group = "none",
	name = "HostileTarget",
	interactive_type = "none",
	height = 20,
	show = true,
	anchors = {
		[1] = {
			parent = "Root",
			point = "bottom",
			parentpoint = "bottom",
			x = 148,
			y = -265,
		},
	},
	labels = 
	{
		Name = 
		{
			alpha_group = "none",
			clip_after = 24,
			formattemplate = "$title",
			follow = "no",
			layer = "overlay",
			always_show = false,
			alpha = 1,
			width = 400,
			show = true,
			font = 
			{
				align = "left",
				name = "font_default_sub_heading",
				case = "none",
			},
			scale = 0.53,
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
					parent = "ImageBackground",
					point = "bottomleft",
					parentpoint = "bottomleft",
					x = 2,
					y = 1,
				},
			},
		},
		Value = 
		{
			alpha_group = "none",
			clip_after = 5,
			formattemplate = "$value",
			follow = "no",
			layer = "secondary",
			always_show = false,
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "center",
				name = "font_default_sub_heading",
				case = "none",
			},
			scale = 0.6,
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
					point = "center",
					parentpoint = "center",
					x = 0,
					y = 2,
				},
			},
		},
		Level = 
		{
			alpha_group = "none",
			follow = "no",
			clip_after = 5,
			formattemplate = "$lvl",
			scale = 0.52,
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_heading_target_mouseover_name",
				case = "none",
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
			anchors = {
				[1] = {
					parent = "Bar",
					point = "right",
					parentpoint = "right",
					x = -3,
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
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = false,
			visibility_group = "HideIfDead",
			scale = 0.86,
			font = 
			{
				align = "right",
				name = "font_clear_small_bold",
				case = "none",
			},
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
					parent = "Bar",
					point = "right",
					parentpoint = "right",
					x = -4,
					y = 6,
				},
			},
		},
		Career = 
		{
			alpha_group = "none",
			clip_after = 15,
			formattemplate = "$career",
			follow = "no",
			layer = "overlay",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_default_sub_heading",
				case = "none",
			},
			parent = "Bar",
			scale = 0.4,
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
			visibility_group = "none",
			anchors = {
				[1] = {
					parent = "ImageBackground",
					point = "bottomright",
					parentpoint = "bottomright",
					x = -2,
					y = -1,
				},
			},
		},
	},
}
UFTemplates.Layouts.Limbo.HostileTarget.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Layouts.Limbo.HostileTarget.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Layouts.Limbo.FriendlyTargetRing = deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.Limbo.FriendlyTargetRing.visibility_group = "HideIfSelf"

UFTemplates.Layouts.Limbo.HostileTargetRing = deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.Limbo.HostileTargetRing.name = "HostileTargetRing"
UFTemplates.Layouts.Limbo.HostileTargetRing.state = "HTHP"
UFTemplates.Layouts.Limbo.HostileTargetRing.anchors[1].parent = "HostileTargetRingInvisi"
UFTemplates.Layouts.Limbo.HostileTargetRing.border.colorsettings.color.r = 255
UFTemplates.Layouts.Limbo.HostileTargetRing.border.colorsettings.color.g = 0
