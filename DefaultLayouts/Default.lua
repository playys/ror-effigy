if not Effigy then Effigy = {} end
local Addon = Effigy
if not UFTemplates then UFTemplates = {} end
if not UFTemplates.Images then UFTemplates.Images = {} end
if not UFTemplates.Labels then UFTemplates.Labels = {} end
if not UFTemplates.Bars then UFTemplates.Bars = {} end
if not UFTemplates.Layouts then UFTemplates.Layouts = {} end

local function GetRvrIcon()
	return
		{
			scale = 0.55,
			alpha = 1,
			show = true,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "topleft",
					parentpoint = "topleft",
					x = -7,
					y = -7,
				},
			},
		}
end

local function GetCareerIcon()
	return		
		{
			scale = 0.6,
			alpha = 0.6,
			show = true,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar BG",
					point = "center",
					parentpoint = "center",
					x = 0,
					y = 0,
				},
			},
		}
end

local function GetStatusIcon()
	return
		{
			scale = 1,
			alpha = 1,
			show = true,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "bottomleft",
					parentpoint = "topleft",
					x = 5,
					y = 0,
				},
			},
		}
end

local function GetRangeLabel()
	return				
		{
			parent = "Bar",
			follow = "no",
			clip_after = 4,
			formattemplate = "$rangemax",
			layer = "overlay",
			alpha = 1,
			width = 60,
			show = true,
			visibility_group = "none",
			alpha_group = "none",
			scale = 0.9,
			height = 16,
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
					r = 212,
					g = 216,
					b = 215,
				},
				allow_overrides = false,
				color_group = "Range",
			},
			anchors = {
				[1] = {
					parent = "Bar",
					point = "left",
					parentpoint = "center",
					x = 16,
					y = 0,
				},
			},
			font = 
			{
				align = "left",
				name = "font_default_text_small",
				case = "none",
			},
		}
end

local function GetValueLabel()
	return
		{
			parent = "Bar",
			follow = "no",
			clip_after = 5,
			formattemplate = "$value",
			alpha_group = "none",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "right",
				name = "font_default_text",
				case = "none",
			},
			scale = 0.8,
			visibility_group = "none",
			height = 17,
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
			always_show = false,
			anchors = {
				[1] = {
					parent = "Bar BG",
					point = "right",
					parentpoint = "right",
					x = -4,
					y = 0,
				},
			},
		}
end

local function GetNameLabel()
	return
		{
			parent = "Bar",
			follow = "no",
			clip_after = 9,
			formattemplate = "$title",
			alpha_group = "none",
			layer = "secondary",
			alpha = 1,
			width = 0,
			show = true,
			font = 
			{
				align = "left",
				name = "font_default_text",
				case = "none",
			},
			scale = 0.85,
			visibility_group = "none",
			height = 17,
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
					r = 212,
					g = 216,
					b = 215,
				},
				allow_overrides = false,
				color_group = "none",
			},
			always_show = false,
			anchors = {
				[1] = {
					parent = "Bar BG",
					point = "left",
					parentpoint = "left",
					x = 5,
					y = 1,
				},
			},
		}
end

local function GetTargetFriendlyBar()
	return
	{
		grow = "right",
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
					style = "cut",
					y = 0,
					slice = "none",
				},
				layer = "default",
				alpha = 0.5,
				width = 215,
				show = true,
				visibility_group = "none",
				follow_bg_alpha = true,
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
						b = 32,
						g = 111,
						r = 161,
					},
					allow_overrides = false,
					color_group = "none",
				},
				alpha_group = "none",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "topleft",
						parentpoint = "topleft",
						x = 1,
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
					y = 0,
					slice = "none",
					name = "LiquidUFBG",
					height = 128,
					style = "cut",
					texture_group = "none",
					x = 0,
				},
				layer = "background",
				alpha = 0.7,
				width = 215,
				show = true,
				visibility_group = "none",
				follow_bg_alpha = true,
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
						b = 0,
						g = 37,
						r = 71,
					},
					allow_overrides = false,
					color_group = "none",
				},
				alpha_group = "none",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "topleft",
						parentpoint = "topleft",
						x = 0,
						y = 0,
					},
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
				color_group = "percent-trafficlights",
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
				name = "Statusbar1",
				height = 0,
				style = "cut",
				y = 0,
				slice = "none",
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
		no_tooltip = false,
		alphasettings = 
		{
			alpha = 1,
			alpha_group = "none",
		},
		block_layout_editor = false,
		state = "FTHP",
		name = "TargetFriendly",
		interactive_type = "friendly",
		height = 32,
		scale = 1,
		border = 
		{
			padding = 
			{
				top = 3,
				right = 6,
				left = 4,
				bottom = 3,
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
			follow_bg_alpha = true,
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
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		visibility_group = "none",
		width = 216,
		show = true,
		--interactive = true,
		pos_at_world_object = false,
		invValue = false,
		labels = {},
		anchors = {
			[1] = {
				parent = "Root",
				point = "center",
				parentpoint = "center",
				x = -360,
				y = 200,
			},
		},
		rvr_icon =
		{
			scale = 0.55,
			alpha = 1,
			show = true,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "topleft",
					parentpoint = "topleft",
					x = -7,
					y = -7,
				},
			},
		},
		icon = GetCareerIcon(),
		status_icon =
		{
			scale = 1,
			alpha = 1,
			show = true,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "bottomleft",
					parentpoint = "topleft",
					x = 5,
					y = 0,
				},
			},
		}
	}	
end

UFTemplates.Layouts.Default = 
{
	PlayerHP = 
	{
		grow = "right",
		hide_if_target = false,
		images = 
		{
			Foreground = 
			{
				parent = "Bar",
				texture = 
				{
					texture_group = "none",
					slice = "none",
					name = "LiquidUFFX",
					x = 0,
					scale = 1,
					height = 128,
					y = 0,
					width = 512,
				},
				layer = "default",
				alpha = 0.5,
				width = 215,
				show = true,
				visibility_group = "none",
				follow_bg_alpha = true,
				scale = 1,
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
						b = 32,
						g = 111,
						r = 161,
					},
					allow_overrides = false,
					color_group = "none",
				},
				alpha_group = "none",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "topleft",
						parentpoint = "topleft",
						x = 1,
						y = 0,
					},
				},
			},
			Background = 
			{
				parent = "Root",
				texture = 
				{
					texture_group = "none",
					slice = "none",
					name = "LiquidUFBG",
					x = 0,
					scale = 1,
					y = 0,
					height = 128,
					width = 512,
				},
				layer = "background",
				alpha = 0.7,
				width = 215,
				show = true,
				visibility_group = "none",
				follow_bg_alpha = true,
				scale = 1,
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
						b = 0,
						g = 37,
						r = 71,
					},
					allow_overrides = false,
					color_group = "none",
				},
				alpha_group = "none",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "topleft",
						parentpoint = "topleft",
						x = 0,
						y = 0,
					},
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
				color_group = "percent-trafficlights",
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
				name = "Statusbar1",
				height = 0,
				style = "cut",
				y = 0,
				slice = "none",
			},
		},
		no_tooltip = false,
		alphasettings = 
		{
			alpha = 1,
			alpha_group = "none",
		},
		block_layout_editor = false,
		state = "PlayerHP",		
		name = "PlayerHP",
		interactive_type = "player",
		height = 30,
		scale = 1,
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
			follow_bg_alpha = true,
			padding = 
			{
				top = 4,
				right = 6,
				left = 4,
				bottom = 0,
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
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		width = 216,
		show = true,
		visibility_group = "none",
		invValue = false,
		pos_at_world_object = false,
		--interactive = true,
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
		labels = {},
		anchors = {
			[1] = {
				parent = "Root",
				point = "center",
				parentpoint = "center",
				x = 0,
				y = 300,
			},
		},
	},
	PlayerAP = 
	{
		grow = "right",
		pos_at_world_object = false,
		hide_if_target = false,
		images = {},
		scale = 1,
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
				top = 0,
				right = 6,
				left = 4,
				bottom = 6,
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
				ColorPreset = "__YELLOW_DARK",
				alter = 
				{
					b = "no",
					g = "no",
					r = "no",
				},
				color = 
				{
					b = 0,
					g = 200,
					r = 200,
				},
				allow_overrides = false,
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
				texture_group = "none",
				x = 0,
				style = "cut",
				height = 0,
				name = "Statusbar1",
				y = 0,
				slice = "none",
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
					b = 24,
					g = 24,
					r = 24,
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
		width = 216,
		state = "PlayerAP",
		visibility_group = "none",
		--interactive = false,
		interactive_type = "none",
		height = 20,
		anchors = {
			[1] = {
				parent = "PlayerHP",
				point = "topleft",
				parentpoint = "bottomleft",
				x = 0,
				y = 1,
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
				alpha_group = "none",
				layer = "overlay",
				alpha = 1,
				width = 0,
				show = true,
				font = 
				{
					align = "right",
					name = "font_default_text_small",
					case = "none",
				},
				scale = 0.7,
				visibility_group = "none",
				height = 16,
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
				always_show = false,
				anchors = {
					[1] = {
						parent = "Bar BG",
						point = "bottomright",
						parentpoint = "bottomright",
						x = -4,
						y = -2,
					},
				},
			},
			Level = 
			{
				parent = "Bar",
				follow = "no",
				clip_after = 2,
				formattemplate = "$lvl.PlayerHP",
				layer = "overlay",
				alpha = 1,
				width = 0,
				show = true,
				visibility_group = "none",
				alpha_group = "none",
				scale = 0.7,
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
				font = 
				{
					align = "left",
					name = "font_default_text_small",
					case = "none",
				},
				anchors = {
					[1] = {
						parent = "Bar BG",
						point = "bottomleft",
						parentpoint = "bottomleft",
						x = 5,
						y = -2,
					},
				},
			},
		},
	},
	Castbar = 
	{
		grow = "right",
		hide_if_target = false,
		images = 
		{
			Foreground = 
			{
				scale = 1,
				texture = 
				{
					scale = 1,
					width = 512,
					y = 0,
					slice = "none",
					name = "LiquidUFFX",
					height = 128,
					x = 0,
					texture_group = "none",
					style = "cut",
				},
				alpha_group = "none",
				layer = "default",
				alpha = 0.5,
				width = 215,
				show = true,
				visibility_group = "none",
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
						r = 161,
						g = 111,
						b = 32,
					},
					allow_overrides = false,
					color_group = "none",
				},
				parent = "Bar",
				height = 32,
				follow_bg_alpha = true,
				anchors = {
					[1] = {
						parent = "Bar",
						point = "topleft",
						parentpoint = "topleft",
						x = 1,
						y = 0,
					},
				},
			},
			Background = 
			{
				scale = 1,
				texture = 
				{
					scale = 1,
					width = 512,
					texture_group = "none",
					x = 0,
					name = "LiquidUFBG",
					height = 128,
					slice = "none",
					y = 0,
					style = "cut",
				},
				alpha_group = "none",
				layer = "background",
				alpha = 0.7,
				width = 215,
				show = true,
				visibility_group = "none",
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
						r = 71,
						g = 37,
						b = 0,
					},
					allow_overrides = false,
					color_group = "none",
				},
				parent = "Bar",
				height = 32,
				follow_bg_alpha = true,
				anchors = {
					[1] = {
						parent = "Bar",
						point = "topleft",
						parentpoint = "topleft",
						x = 0,
						y = 0,
					},
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
				name = "Statusbar1",
				height = 0,
				x = 0,
				texture_group = "none",
				style = "cut",
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
		no_tooltip = true,
		alphasettings = 
		{
			alpha = 1,
			alpha_group = "none",
		},
		block_layout_editor = false,
		state = "Castbar",
		visibility_group = "none",
		name = "Castbar",
		interactive_type = "none",
		height = 28,
		pos_at_world_object = false,
		border = 
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
					g = 0,
					b = 0,
				},
				allow_overrides = false,
				color_group = "none",
			},
			padding = 
			{
				top = 2,
				right = 2,
				left = 2,
				bottom = 0,
			},
			follow_bg_alpha = true,
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
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		width = 210,
		show = true,
		--interactive = false,
		scale = 1,
		invValue = false,
		anchors = {
			[1] = {
				parent = "PlayerHP",
				point = "top",
				parentpoint = "bottom",
				x = 0,
				y = 120,
			},
		},
		labels = 
		{
			Name = 
			{
				alpha_group = "none",
				follow = "no",
				clip_after = 9,
				formattemplate = "$title",
				parent = "Bar",
				always_show = false,
				alpha = 1,
				width = 0,
				show = true,
				font = 
				{
					align = "left",
					name = "font_default_text",
					case = "none",
				},
				scale = 0.85,
				visibility_group = "none",
				height = 17,
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
						b = 215,
						g = 216,
						r = 212,
					},
					allow_overrides = false,
					color_group = "none",
				},
				layer = "secondary",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "left",
						parentpoint = "left",
						x = 5,
						y = 1,
					},
				},
			},
		},
	},
}
UFTemplates.Layouts.Default.TargetFriendly = GetTargetFriendlyBar()
UFTemplates.Layouts.Default.TargetFriendly.labels.Range = GetRangeLabel()
UFTemplates.Layouts.Default.TargetHostile = GetTargetFriendlyBar()
UFTemplates.Layouts.Default.TargetHostile.labels.Range = GetRangeLabel()
UFTemplates.Layouts.Default.TargetHostile.name = "TargetHostile"
UFTemplates.Layouts.Default.TargetHostile.state = "HTHP"		
UFTemplates.Layouts.Default.TargetHostile.anchors[1].x = 360
UFTemplates.Layouts.Default.TargetHostile.anchors[1].y = 200
UFTemplates.Layouts.Default.TargetHostile.interactive_type = "none"
UFTemplates.Layouts.Default.TargetHostile.hide_if_zero = true
--UFTemplates.Layouts.Default.TargetHostile.interactive = false
UFTemplates.Layouts.Default.TargetHostile.status_icon.show = false
UFTemplates.Layouts.Default.PlayerPet = GetTargetFriendlyBar()
UFTemplates.Layouts.Default.PlayerPet.name = "PlayerPet"
UFTemplates.Layouts.Default.PlayerPet.state = "PlayerPetHP"
UFTemplates.Layouts.Default.PlayerPet.anchors = {
	[1] = {
		parent = "PlayerHP",
		point = "topright",
		parentpoint = "bottom",
		x = -20,
		y = 60,
	},
}
UFTemplates.Layouts.Default.PlayerPet.interactive_type = "state"
UFTemplates.Layouts.Default.PlayerPet.rvr_icon.show = false
UFTemplates.Layouts.Default.PlayerPet.status_icon.show = false
UFTemplates.Layouts.Default.PlayerPetTarget = GetTargetFriendlyBar()
UFTemplates.Layouts.Default.PlayerPetTarget.name = "PlayerPetTarget"
UFTemplates.Layouts.Default.PlayerPetTarget.state = "PlayerPetTargetHP"
UFTemplates.Layouts.Default.PlayerPetTarget.anchors = {
	[1] = {
		parent = "PlayerHP",
		point = "topleft",
		parentpoint = "bottom",
		x = 20,
		y = 60,
	},
}
--UFTemplates.Layouts.Default.PlayerPetTarget.interactive = false
UFTemplates.Layouts.Default.PlayerPetTarget.interactive_type = "none"
UFTemplates.Layouts.Default.PlayerPetTarget.icon.show = false
UFTemplates.Layouts.Default.PlayerPetTarget.status_icon.show = false

UFTemplates.Layouts.Default.TargetFriendly.labels.Value = GetValueLabel()
UFTemplates.Layouts.Default.TargetHostile.labels.Value = GetValueLabel()
UFTemplates.Layouts.Default.PlayerPet.labels.Value = GetValueLabel()
UFTemplates.Layouts.Default.PlayerPetTarget.labels.Value = GetValueLabel()
UFTemplates.Layouts.Default.PlayerHP.labels.Value = GetValueLabel()
UFTemplates.Layouts.Default.Castbar.labels.Value = GetValueLabel()

UFTemplates.Layouts.Default.TargetFriendly.labels.Name = GetNameLabel()
UFTemplates.Layouts.Default.TargetHostile.labels.Name = GetNameLabel()
UFTemplates.Layouts.Default.PlayerPet.labels.Name = GetNameLabel()
UFTemplates.Layouts.Default.PlayerPetTarget.labels.Name = GetNameLabel()
UFTemplates.Layouts.Default.PlayerHP.labels.Name = GetNameLabel()

--
-- Icons
--
UFTemplates.Layouts.Default.PlayerHP.rvr_icon = GetRvrIcon()
UFTemplates.Layouts.Default.PlayerAP.rvr_icon = GetRvrIcon()
UFTemplates.Layouts.Default.PlayerAP.rvr_icon.show = false
UFTemplates.Layouts.Default.Castbar.rvr_icon = GetRvrIcon()
UFTemplates.Layouts.Default.Castbar.rvr_icon.show = false

UFTemplates.Layouts.Default.PlayerHP.icon = GetCareerIcon()
UFTemplates.Layouts.Default.PlayerAP.icon = GetCareerIcon()
UFTemplates.Layouts.Default.PlayerAP.icon.show = false
UFTemplates.Layouts.Default.Castbar.icon = GetCareerIcon()
UFTemplates.Layouts.Default.Castbar.icon.scale = 0.4

UFTemplates.Layouts.Default.PlayerHP.status_icon = GetStatusIcon()
UFTemplates.Layouts.Default.PlayerAP.status_icon = GetStatusIcon()
UFTemplates.Layouts.Default.PlayerAP.status_icon.show = false
UFTemplates.Layouts.Default.Castbar.status_icon = GetStatusIcon()
UFTemplates.Layouts.Default.Castbar.status_icon.show = false