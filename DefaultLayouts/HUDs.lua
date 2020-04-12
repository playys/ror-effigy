if not Effigy then Effigy = {} end
local Addon = Effigy

-- Future UI accessible Image and Label templates
-- atm no deepcopy, try a "use template" instead of a "load template" semantic
if not UFTemplates then UFTemplates = {} end
if not UFTemplates.Images then UFTemplates.Images = {} end
if not UFTemplates.Labels then UFTemplates.Labels = {} end
if not UFTemplates.Bars then UFTemplates.Bars = {} end
if not UFTemplates.Layouts then UFTemplates.Layouts = {} end

UFTemplates.Layouts["HUD-Glow"] = 
{
	TargetHostile = 
	{
		grow = "up",
		hide_if_target = false,
		images = {},
		rvr_icon = 
		{
			show = true,
			follow_bg_alpha = false,
			scale = 0.55,
			alpha = 1,
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
		status_icon = 
		{
			show = true,
			follow_bg_alpha = false,
			scale = 1,
			alpha = 1,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "bottomleft",
					parentpoint = "topleft",
					x = 5,
					y = 0,
				},
			},
		},
		fg = 
		{
			colorsettings = 
			{
				ColorPreset = "__RED_SAT",
				alter = 
				{
					r = "no",
					g = "no",
					b = "no",
				},
				color = 
				{
					r = 200,
					g = 0,
					b = 0,
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
				texture_group = "none",
				x = 0,
				name = "xHUD_RightGlowArcFG",
				height = 0,
				slice = "none",
				y = 0,
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
				scale = 1,
				width = 0,
				texture_group = "none",
				x = 4,
				name = "xHUD_RightGlowArcBG",
				height = 0,
				slice = "none",
				y = 7,
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
		state = "HTHP",
		visibility_group = "none",
		name = "TargetHostile",
		interactive_type = "none",
		height = 256,
		pos_at_world_object = false,
		border = 
		{
			follow_bg_alpha = false,
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
				allow_overrides = false,
				color_group = "none",
			},
			alpha = 0.5,
			texture = 
			{
				scale = 1,
				width = 0,
				texture_group = "none",
				x = 0,
				name = "xHUD_RightGlowArcBG",
				height = 0,
				slice = "none",
				y = 0,
				style = "cut",
			},
		},
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		width = 64,
		show = true,
		icon = 
		{
			show = true,
			follow_bg_alpha = false,
			scale = 0.5,
			alpha = 0.9,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "center",
					parentpoint = "center",
					x = 2,
					y = 0,
				},
			},
		},
		interactive = false,
		scale = 1,
		invValue = false,
		labels = 
		{
			Value = 
			{
				alpha_group = "none",
				follow = "no",
				clip_after = 32,
				formattemplate = "[$lvl] $title: $per%",
				parent = "Bar",
				layer = "secondary",
				always_show = false,
				alpha = 1,
				width = 300,
				show = true,
				font = 
				{
					align = "center",
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
					allow_overrides = true,
					color_group = "none",
				},
				anchors = {
					[1] = {
						parent = "Bar",
						point = "top",
						parentpoint = "bottom",
						x = -25,
						y = 18,
					},
				},
			},
		},
		anchors = {
			[1] = {
				parent = "TargetFriendly",
				point = "center",
				parentpoint = "center",
				x = 25,
				y = 0,
			},
		},
	},
	PlayerHP = 
	{
		grow = "up",
		hide_if_target = false,
		images = {},
		rvr_icon = 
		{
			show = true,
			follow_bg_alpha = false,
			scale = 0.55,
			alpha = 1,
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
		status_icon = 
		{
			show = true,
			follow_bg_alpha = false,
			scale = 1,
			alpha = 1,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "bottomleft",
					parentpoint = "topleft",
					x = 5,
					y = 0,
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
				allow_overrides = false,
				color_group = "percent-trafficlights",
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
				name = "xHUD_LeftGlowArcFG",
				height = 0,
				slice = "none",
				y = 0,
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
				scale = 1,
				width = 0,
				texture_group = "none",
				x = 4,
				name = "xHUD_LeftGlowArcBG",
				height = 0,
				slice = "none",
				y = 7,
				style = "cut",
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
		visibility_group = "CombatOrNotFull",
		name = "PlayerHP",
		interactive_type = "player",
		height = 256,
		pos_at_world_object = false,
		border = 
		{
			follow_bg_alpha = false,
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
				allow_overrides = false,
				color_group = "none",
			},
			alpha = 0.5,
			texture = 
			{
				scale = 1,
				width = 0,
				texture_group = "none",
				x = 0,
				name = "xHUD_LeftGlowArcBG",
				height = 0,
				slice = "none",
				y = 0,
				style = "cut",
			},
		},
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		width = 64,
		show = true,
		invValue = false,
		interactive = true,
		scale = 1,
		anchors = {
			[1] = {
				parent = "Root",
				point = "center",
				parentpoint = "center",
				x = -300,
				y = 0,
			},
		},
		labels = 
		{
			Value = 
			{
				alpha_group = "none",
				follow = "no",
				clip_after = 13,
				formattemplate = "$value / $max",
				parent = "Bar",
				layer = "secondary",
				always_show = false,
				alpha = 1,
				width = 150,
				show = true,
				font = 
				{
					align = "center",
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
				anchors = {
					[1] = {
						parent = "Bar",
						point = "top",
						parentpoint = "bottomright",
						x = 0,
						y = 1,
					},
				},
			},
		},
	},
	PlayerAP = 
	{
		grow = "up",
		hide_if_target = false,
		images = {},
		rvr_icon = 
		{
			show = false,
			alpha = 1,
			scale = 0.55,
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
		status_icon = 
		{
			show = false,
			alpha = 1,
			scale = 1,
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
				alter = "no",
				in_combat = 1,
				out_of_combat = 1,
			},
			texture = 
			{
				scale = 0,
				width = 0,
				y = 0,
				x = 0,
				style = "cut",
				height = 0,
				name = "xHUD_LeftGlowArcFG",
				texture_group = "none",
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
				scale = 1,
				width = 0,
				y = 7,
				x = 4,
				style = "cut",
				height = 0,
				name = "xHUD_LeftGlowArcBG",
				texture_group = "none",
				slice = "none",
			},
		},
		no_tooltip = true,
		alphasettings = 
		{
			alpha = 1,
			alpha_group = "none",
		},
		block_layout_editor = false,
		state = "PlayerAP",
		name = "PlayerAP",
		interactive_type = "player",
		height = 256,
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
			follow_bg_alpha = false,
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
			alpha = 0.5,
			texture = 
			{
				scale = 1,
				width = 0,
				y = 0,
				x = 0,
				style = "cut",
				height = 0,
				name = "xHUD_LeftGlowArcBG",
				texture_group = "none",
				slice = "none",
			},
		},
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		visibility_group = "CombatOrNotFull",
		width = 64,
		show = true,
		invValue = false,
		interactive = true,
		pos_at_world_object = false,
		anchors = {
			[1] = {
				parent = "PlayerHP",
				point = "center",
				parentpoint = "center",
				x = 15,
				y = 16,
			},
		},
		labels = 
		{
			["Value"] = 
			{
				parent = "Bar",
				follow = "no",
				clip_after = 13,
				formattemplate = "$value / $max",
				visibility_group = "none",
				layer = "overlay",
				alpha = 1,
				width = 100,
				show = true,
				font = 
				{
					align = "center",
					name = "font_default_text",
					case = "none",
				},
				scale = 0.8,
				height = 17,
				colorsettings = 
				{
					ColorPreset = "__YELLOW_DARK",
					alter = 
					{
						r = "no",
						g = "no",
						b = "no",
					},
					color = 
					{
						r = 200,
						g = 200,
						b = 0,
					},
					allow_overrides = false,
					color_group = "none",
				},
				alpha_group = "none",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "top",
						parentpoint = "bottomright",
						x = 0,
						y = 1,
					},
				},
			},
		},
	},
	TargetFriendly = 
	{
		grow = "up",
		hide_if_target = false,
		images = {},
		rvr_icon = 
		{
			show = true,
			alpha = 1,
			scale = 0.55,
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
		status_icon = 
		{
			show = true,
			alpha = 1,
			scale = 1,
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
				allow_overrides = true,
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
				y = 0,
				slice = "none",
				name = "xHUD_RightGlowArcFG",
				height = 0,
				style = "cut",
				texture_group = "none",
				x = 0,
			},
		},
		icon = 
		{
			show = true,
			alpha = 0.9,
			scale = 0.5,
			follow_bg_alpha = false,
			anchors = {
				[1] = {
					parent = "Bar",
					point = "center",
					parentpoint = "center",
					x = 2,
					y = 0,
				},
			},
		},
		no_tooltip = true,
		alphasettings = 
		{
			alpha = 1,
			alpha_group = "none",
		},
		block_layout_editor = false,
		state = "FTHP",
		name = "TargetFriendly",
		interactive_type = "none",
		height = 256,
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
			padding = 
			{
				top = 0,
				right = 0,
				left = 0,
				bottom = 0,
			},
			follow_bg_alpha = false,
			alpha = 0.5,
			texture = 
			{
				scale = 1,
				width = 0,
				y = 0,
				slice = "none",
				name = "xHUD_RightGlowArcBG",
				height = 0,
				style = "cut",
				texture_group = "none",
				x = 0,
			},
		},
		slow_changing_value = false,
		watching_states = {},
		hide_if_zero = false,
		show_with_target = false,
		visibility_group = "none",
		width = 64,
		show = true,
		invValue = false,
		interactive = false,
		pos_at_world_object = false,
		anchors = {
			[1] = {
				parent = "Root",
				point = "center",
				parentpoint = "center",
				x = 300,
				y = 0,
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
				scale = 1,
				width = 0,
				y = 7,
				slice = "none",
				name = "xHUD_RightGlowArcBG",
				height = 0,
				style = "cut",
				texture_group = "none",
				x = 4,
			},
		},
		labels = 
		{
			Value = 
			{
				alpha_group = "none",
				follow = "no",
				clip_after = 32,
				formattemplate = "[$lvl] $title: $per%",
				layer = "secondary",
				always_show = false,
				alpha = 1,
				width = 300,
				show = true,
				font = 
				{
					align = "center",
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
					allow_overrides = true,
					color_group = "none",
				},
				parent = "Bar",
				anchors = {
					[1] = {
						parent = "Bar",
						point = "top",
						parentpoint = "bottom",
						x = -25,
						y = 1,
					},
				},
			},
		},
	},
}
UFTemplates.Layouts["HUD-Glow"].PlayerHP.icon = Addon.GetDefaultCareerIcon()
UFTemplates.Layouts["HUD-Glow"].PlayerAP.icon = Addon.GetDefaultCareerIcon()



--
--
--
UFTemplates.Layouts["HUD-Round"] = Addon.deepcopy(UFTemplates.Layouts["HUD-Glow"])
UFTemplates.Layouts["HUD-Round"].PlayerHP.border.texture.name = "xHUD_LeftRoundBarBG"
UFTemplates.Layouts["HUD-Round"].PlayerHP.bg.texture.name = "xHUD_LeftRoundBarBG"
UFTemplates.Layouts["HUD-Round"].PlayerHP.fg.texture.name = "xHUD_LeftRoundBarFG"
UFTemplates.Layouts["HUD-Round"].PlayerAP.border.texture.name = "xHUD_LeftRoundBarBG"
UFTemplates.Layouts["HUD-Round"].PlayerAP.bg.texture.name = "xHUD_LeftRoundBarBG"
UFTemplates.Layouts["HUD-Round"].PlayerAP.fg.texture.name = "xHUD_LeftRoundBarFG"
UFTemplates.Layouts["HUD-Round"].TargetHostile.border.texture.name = "xHUD_RightRoundBarBG"
UFTemplates.Layouts["HUD-Round"].TargetHostile.bg.texture.name = "xHUD_RightRoundBarBG"
UFTemplates.Layouts["HUD-Round"].TargetHostile.fg.texture.name = "xHUD_RightRoundBarFG"
UFTemplates.Layouts["HUD-Round"].TargetFriendly.border.texture.name = "xHUD_RightRoundBarBG"
UFTemplates.Layouts["HUD-Round"].TargetFriendly.bg.texture.name = "xHUD_RightRoundBarBG"
UFTemplates.Layouts["HUD-Round"].TargetFriendly.fg.texture.name = "xHUD_RightRoundBarFG"

UFTemplates.Layouts["HUD-Metal"] = Addon.deepcopy(UFTemplates.Layouts["HUD-Glow"])
UFTemplates.Layouts["HUD-Metal"].PlayerHP.border.texture.name = "xHUD_LeftMetalBG"
UFTemplates.Layouts["HUD-Metal"].PlayerHP.bg.texture.name = "xHUD_LeftMetalBG"
UFTemplates.Layouts["HUD-Metal"].PlayerHP.fg.texture.name = "xHUD_LeftMetalFG"
UFTemplates.Layouts["HUD-Metal"].PlayerAP.border.texture.name = "xHUD_LeftMetalBG"
UFTemplates.Layouts["HUD-Metal"].PlayerAP.bg.texture.name = "xHUD_LeftMetalBG"
UFTemplates.Layouts["HUD-Metal"].PlayerAP.fg.texture.name = "xHUD_LeftMetalFG"
UFTemplates.Layouts["HUD-Metal"].TargetHostile.border.texture.name = "xHUD_RightMetalBG"
UFTemplates.Layouts["HUD-Metal"].TargetHostile.bg.texture.name = "xHUD_RightMetalBG"
UFTemplates.Layouts["HUD-Metal"].TargetHostile.fg.texture.name = "xHUD_RightMetalFG"
UFTemplates.Layouts["HUD-Metal"].TargetFriendly.border.texture.name = "xHUD_RightMetalBG"
UFTemplates.Layouts["HUD-Metal"].TargetFriendly.bg.texture.name = "xHUD_RightMetalBG"
UFTemplates.Layouts["HUD-Metal"].TargetFriendly.fg.texture.name = "xHUD_RightMetalFG"

UFTemplates.Layouts["HUD-Plain"] = Addon.deepcopy(UFTemplates.Layouts["HUD-Glow"])
UFTemplates.Layouts["HUD-Plain"].PlayerHP.border.texture.name = "xHUD_LeftPlainBG"
UFTemplates.Layouts["HUD-Plain"].PlayerHP.bg.texture.name = "xHUD_LeftPlainBG"
UFTemplates.Layouts["HUD-Plain"].PlayerHP.fg.texture.name = "xHUD_LeftPlainFG"
UFTemplates.Layouts["HUD-Plain"].PlayerAP.border.texture.name = "xHUD_LeftPlainBG"
UFTemplates.Layouts["HUD-Plain"].PlayerAP.bg.texture.name = "xHUD_LeftPlainBG"
UFTemplates.Layouts["HUD-Plain"].PlayerAP.fg.texture.name = "xHUD_LeftPlainFG"
UFTemplates.Layouts["HUD-Plain"].TargetHostile.border.texture.name = "xHUD_RightPlainBG"
UFTemplates.Layouts["HUD-Plain"].TargetHostile.bg.texture.name = "xHUD_RightPlainBG"
UFTemplates.Layouts["HUD-Plain"].TargetHostile.fg.texture.name = "xHUD_RightPlainFG"
UFTemplates.Layouts["HUD-Plain"].TargetFriendly.border.texture.name = "xHUD_RightPlainBG"
UFTemplates.Layouts["HUD-Plain"].TargetFriendly.bg.texture.name = "xHUD_RightPlainBG"
UFTemplates.Layouts["HUD-Plain"].TargetFriendly.fg.texture.name = "xHUD_RightPlainFG"