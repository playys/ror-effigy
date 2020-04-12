-- vim: sw=2 ts=2
if not Effigy then Effigy = {} end
local Addon = Effigy

-- Future UI accessible Image and Label templates
-- atm no deepcopy, try a "use template" instead of a "load template" semantic
if not UFTemplates then UFTemplates = {} end
if not UFTemplates.Images then UFTemplates.Images = {} end
if not UFTemplates.Labels then UFTemplates.Labels = {} end
if not UFTemplates.Bars then UFTemplates.Bars = {} end
if not UFTemplates.Layouts then UFTemplates.Layouts = {} end


--
-- Labels
--
UFTemplates.Labels.Wothor_Name = Addon.GetDefaultLabel()
UFTemplates.Labels.Wothor_Name.anchors[1].point = "bottomleft"
UFTemplates.Labels.Wothor_Name.anchors[1].parentpoint = "topleft"
UFTemplates.Labels.Wothor_Name.width = 200
UFTemplates.Labels.Wothor_Name.scale = 0.66
UFTemplates.Labels.Wothor_Name.font = {	name = "font_default_text_small", align = "left"}
UFTemplates.Labels.Wothor_Name.formattemplate = "$title"

UFTemplates.Labels.Wothor_Range = Addon.GetDefaultLabel()
UFTemplates.Labels.Wothor_Range.anchors[1].point = "bottom"
UFTemplates.Labels.Wothor_Range.anchors[1].y = -30
UFTemplates.Labels.Wothor_Range.clip_after = 4
UFTemplates.Labels.Wothor_Range.scale = 0.75
UFTemplates.Labels.Wothor_Range.formattemplate = "$rangemax"
UFTemplates.Labels.Wothor_Range.font.name = "font_default_text_small"

UFTemplates.Labels.Wothor_GroupMemberName = Addon.GetDefaultLabel()
UFTemplates.Labels.Wothor_GroupMemberName.anchors[1].point = "top"
UFTemplates.Labels.Wothor_GroupMemberName.anchors[1].parentpoint = "top"
UFTemplates.Labels.Wothor_GroupMemberName.clip_after = 6
UFTemplates.Labels.Wothor_GroupMemberName.scale = 0.66
UFTemplates.Labels.Wothor_GroupMemberName.font.name = "font_default_text_small"
UFTemplates.Labels.Wothor_GroupMemberName.formattemplate = "$title"
UFTemplates.Labels.Wothor_GroupMemberName.anchors[1].y = 6

UFTemplates.Labels.Wothor_GroupRange = Addon.GetDefaultLabel()
UFTemplates.Labels.Wothor_GroupRange.anchors[1].point = "bottom"
UFTemplates.Labels.Wothor_GroupRange.anchors[1].parentpoint = "bottom"
UFTemplates.Labels.Wothor_GroupRange.clip_after = 4
UFTemplates.Labels.Wothor_GroupRange.scale = 0.66
UFTemplates.Labels.Wothor_GroupRange.formattemplate = "$rangemax"
UFTemplates.Labels.Wothor_GroupRange.font.name = "font_default_text_small"

UFTemplates.Labels.Wothor_Value = Addon.GetDefaultLabel()
UFTemplates.Labels.Wothor_Value.anchors[1].point = "bottom"
UFTemplates.Labels.Wothor_Value.anchors[1].parentpoint = "bottom"
UFTemplates.Labels.Wothor_Value.anchors[1].y = -15
UFTemplates.Labels.Wothor_Value.scale = 0.75
UFTemplates.Labels.Wothor_Value.font.name = "font_default_text_small"
UFTemplates.Labels.Wothor_Value.formattemplate = "$value"

--	
-- Bars
--
local default_colorsettings =
{
	color = {r = 30, g = 30, b = 30},
	alter = {r = "no", g = "no", b = "no"},
	allow_overrides = false,
	color_group = "none",
	ColorPreset = "none",
}

local default_colorsettingsBG =
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

UFTemplates.Bars.Wothor_HP = 
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
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		colorsettings =
		{
			color = {r = 0, g = 139, b = 3},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "percent-trafficlights",
			ColorPreset = "none"
		},
		texture = 
		{
			scale = 5,
			width = 0,
			y = 0,
			x = 0,
			style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "squared_bar_2",
		},
	},
	bg = 
	{
		show = true,
		alpha = 
		{
			in_combat = 1,
			out_of_combat = 1,
		},
	},
	no_tooltip = false,
	block_layout_editor = true,
	state = "PlayerHP",	
	name = "PlayerHP",
	interactive_type = "player",
	height = 154,
	pos_at_world_object = false,
	anchors = {
		[1] = {
			point = "bottom",
			x = 0,
			y = 0,
			parentpoint = "bottom",
			parent = "Root",
		},
	},
	border = 
	{
		alpha = 1,
		follow_bg_alpha = false,
		padding = { top = 2, left = 3, right = 3, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = 
	{
	},
	hide_if_zero = false,
	show_with_target = false,
	width = 60,
	show = true,
	status_icon = 
	{
		scale = 0.9,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "bottomleft",
				parentpoint = "bottomleft",
				x = 0,
				y = 0,
			},
		},
		alpha = 1,
		show = false,
		texture = 
		{
			y = 0,
			slice = "none",
			name = "none",
			scale = 1,
			x = 0,
		},
		follow_bg_alpha = true,
	},
	--interactive = true,
	icon = 
	{
		scale = 1,
		anchors = {
			[1] = {
				parent = "Bar",
				parentpoint = "center",
				point = "center",
				x = 0,
				y = 0,
			},
		},
		alpha = 0.5,
		show = true,
		texture = 
		{
			y = 0,
			slice = "none",
			name = "icon020195",
			scale = 1,
			x = 0,
		},
		follow_bg_alpha = false,
	},
	visibility_group = "none",
	scale = 1,
	images = {},
	labels = {},
}
UFTemplates.Bars.Wothor_HP.border.colorsettings = default_colorsettings
UFTemplates.Bars.Wothor_HP.border.texture = default_texturesettings
UFTemplates.Bars.Wothor_HP.bg.colorsettings = default_colorsettingsBG
UFTemplates.Bars.Wothor_HP.bg.texture = default_texturesettings
UFTemplates.Bars.Wothor_HP.labels.Value = Addon.deepcopy(UFTemplates.Labels.Wothor_Value)
UFTemplates.Bars.Wothor_HP.rvr_icon = Addon.GetDefaultRvrIcon()

local function CreateIndicators(imagesTable)
	imagesTable.Indicator1 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator2 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator2.anchors[1].point = "topright"
	imagesTable.Indicator2.anchors[1].parentpoint = "topright"
	imagesTable.Indicator2.colorsettings.ColorPreset = "HD-50"
	imagesTable.Indicator21 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator21.anchors[1].point = "bottomright"
	imagesTable.Indicator21.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator21.anchors[1].parent = "ImageIndicator2"
	imagesTable.Indicator21.colorsettings.ColorPreset = "HD-25"
	imagesTable.Indicator22 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator22.anchors[1].point = "bottomright"
	imagesTable.Indicator22.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator22.anchors[1].parent = "ImageIndicator21"
	imagesTable.Indicator22.colorsettings.ColorPreset = "HD-out"
	imagesTable.Indicator3 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator3.anchors[1].point = "bottomleft"
	imagesTable.Indicator3.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator4 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator4.anchors[1].point = "bottomright"
	imagesTable.Indicator4.anchors[1].parentpoint = "bottomright"
	imagesTable.Indicator4.colorsettings.ColorPreset = "Hot-15"
	imagesTable.Indicator41 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator41.anchors[1].point = "bottomright"
	imagesTable.Indicator41.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator41.anchors[1].parent = "ImageIndicator4"
	imagesTable.Indicator41.colorsettings.ColorPreset = "Hot-5"
	imagesTable.Indicator42 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator42.anchors[1].point = "bottomright"
	imagesTable.Indicator42.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator42.anchors[1].parent = "ImageIndicator41"
	imagesTable.Indicator42.colorsettings.ColorPreset = "Hot-ExtraHot"
	imagesTable.Indicator43 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator43.anchors[1].point = "bottomright"
	imagesTable.Indicator43.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator43.anchors[1].parent = "ImageIndicator42"
	imagesTable.Indicator43.colorsettings.ColorPreset = "Hot-Shield"
	imagesTable.Indicator44 = Addon.deepcopy(UFTemplates.Images.Indicator)
	imagesTable.Indicator44.anchors[1].point = "bottomright"
	imagesTable.Indicator44.anchors[1].parentpoint = "bottomleft"
	imagesTable.Indicator44.anchors[1].parent = "ImageIndicator43"
	imagesTable.Indicator44.colorsettings.ColorPreset = "Hot-Extra"
end
CreateIndicators(UFTemplates.Bars.Wothor_HP.images)

UFTemplates.Bars.Wothor_PlayerAP =
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
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		colorsettings =
		{
			color = {r = 192, g = 156, b = 0},
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
			name = "squared_bar_2",
			height = 0,
			slice = "none",
			texture_group = "none",
			style = "cut",
		},
	},
	bg = 
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
			in_combat = 0.7,
			out_of_combat = 0.7,
		},
	},
	no_tooltip = false,
	block_layout_editor = true,
	state = "PlayerAP",
	visibility_group = "none",
	name = "PlayerAP",
	interactive_type = "player",
	height = 154,
	scale = 1,
	anchors = {
		[1] = {
			parent = "PlayerHP",
			point = "right",
			parentpoint = "left",
			x = 0,
			y = 0,
		},
	},
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 2, left = 3, right = 1, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = 
	{
	},
	hide_if_zero = false,
	pos_at_world_object = false,
	show_with_target = false,
	width = 16,
	show = true,
	--interactive = true,
	images = {},
	labels = {},
}
UFTemplates.Bars.Wothor_PlayerAP.border.colorsettings = default_colorsettings
UFTemplates.Bars.Wothor_PlayerAP.border.texture = default_texturesettings
UFTemplates.Bars.Wothor_PlayerAP.bg.colorsettings = default_colorsettingsBG
UFTemplates.Bars.Wothor_PlayerAP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.Wothor_PlayerAP.status_icon = Addon.GetDefaultStatusIcon()
UFTemplates.Bars.Wothor_PlayerAP.icon = Addon.GetDefaultCareerIcon()
	
UFTemplates.Bars.Wothor_Castbar = 
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
			clamp = 1,
			out_of_combat = 1,
			in_combat = 1,
			alter = "inv",
		},
		colorsettings =
		{
			color = {r = 220, g = 97, b = 0},
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
			style = "cut",
			height = 0,
			name = "squared_bar_2",
			texture_group = "none",
			slice = "none",
		},
	},
	icon = 
	{
		scale = 0.25,
		alpha = 1,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "bottom",
				parentpoint = "top",
				x = 0,
				y = 0,
			},
		},
	},
	no_tooltip = true,
	block_layout_editor = true,
	state = "Castbar",	
	name = "Castbar",
	interactive_type = "none",
	height = 154,
	scale = 1,
	border = 
	{
		follow_bg_alpha = true,
		alpha = 1,
		padding = { top = 2, left = 1, right = 3, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = 
	{
	},
	hide_if_zero = false,
	show_with_target = false,
	width = 16,
	show = true,
	pos_at_world_object = false,
	--interactive = false,
	visibility_group = "none",	
	bg = 
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
	},
	anchors = {
		[1] = {
			point = "left",
			parentpoint = "right",
			parent = "PlayerHP",
			x = 0,
			y = 0,
		},
	},
	images = {},
	labels = {},
}
UFTemplates.Bars.Wothor_Castbar.border.colorsettings = default_colorsettings
UFTemplates.Bars.Wothor_Castbar.border.texture = default_texturesettings
UFTemplates.Bars.Wothor_Castbar.bg.colorsettings = default_colorsettingsBG
UFTemplates.Bars.Wothor_Castbar.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.Wothor_Castbar.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.Wothor_GroupMember = 
{
	grow = "up",
	hide_if_target = false,
	alphasettings = {
		alpha = 1,
		alpha_group = "Range-Formation"
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
		colorsettings =
		{
			color = {r = 0, g = 139, b = 3},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = true,
			color_group = "percent-trafficlights"
		},
		texture = 
		{
			scale = 5,
			width = 0,
			texture_group = "none",
			x = 0,
			name = "squared_bar_2",
			height = 0,
			slice = "none",
			y = 0,
			style = "cut",
		},
	},
	bg = 
	{
		show = true,
		texture = 
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
		},
		alpha = 
		{
			in_combat = 1,
			out_of_combat = 1,
		},
	},
	no_tooltip = true,
	block_layout_editor = true,
	state = "grp1hp",
	name = "GroupMember1HP",
	interactive_type = "group",
	height = 60,
	pos_at_world_object = false,
	border = 
	{
		alpha = 1,
		follow_bg_alpha = true,
		padding = { top = 3, left = 3, right = 3, bottom = 2}
	},
	slow_changing_value = false,
	watching_states = {},
	hide_if_zero = false,
	show_with_target = false,
	width = 60,
	show = true,
	--interactive = true,
	icon = 
	{
		scale = 0.8,
		alpha = 0.5,
		show = true,
		texture = 
		{
			y = 0,
			slice = "none",
			name = "",
			scale = 1,
			x = 0,
		},
		follow_bg_alpha = false,
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
	visibility_group = "none",
	scale = 0.75,
	anchors = {
		[1] = {
			parent = "Root",
			point = "left",
			parentpoint = "left",
			x = 0,
			y = 0,
		},
	},
	images = {},
	labels = {},
}
UFTemplates.Bars.Wothor_GroupMember.border.colorsettings = Addon.deepcopy(default_colorsettings)
UFTemplates.Bars.Wothor_GroupMember.border.colorsettings.color_group = "IsMyTarget"
UFTemplates.Bars.Wothor_GroupMember.border.texture = default_texturesettings
UFTemplates.Bars.Wothor_GroupMember.bg.colorsettings = Addon.deepcopy(default_colorsettingsBG)
UFTemplates.Bars.Wothor_GroupMember.bg.colorsettings.color_group = "RedWhenDead"
UFTemplates.Bars.Wothor_GroupMember.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.Wothor_GroupMember.status_icon = Addon.GetDefaultStatusIcon()

UFTemplates.Bars.Wothor_GroupMember.labels.Name = Addon.deepcopy(UFTemplates.Labels.Wothor_GroupMemberName)
UFTemplates.Bars.Wothor_GroupMember.labels.Range = Addon.deepcopy(UFTemplates.Labels.Wothor_GroupRange)
-- UFTemplates.Bars.Wothor_GroupMember.labels.Range.colorsettings.color_group = "Range"
CreateIndicators(UFTemplates.Bars.Wothor_GroupMember.images)

UFTemplates.Bars.Wothor_GroupMemberAP = 
{
	grow = "up",
	pos_at_world_object = false,
	hide_if_target = false,	
	scale = 0.75,
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
				r = 30,
				g = 30,
				b = 30,
			},
			allow_overrides = false,
			color_group = "none",
		},
		follow_bg_alpha = true,
		padding = 
		{
			top = 3,
			right = 0,
			left = 3,
			bottom = 2,
		},
		alpha = 1,
		texture = 
		{
			scale = 1,
			width = 0,
			texture_group = "none",
			slice = "none",
			style = "cut",
			height = 0,
			x = 0,
			y = 0,
			name = "tint_square",
		},
	},
	state = "grp1ap",
	status_icon = 
	{
		scale = 0.9,
		alpha = 1,
		show = false,
		texture = 
		{
			y = 0,
			slice = "none",
			name = "none",
			scale = 1,
			x = 0,
		},
		follow_bg_alpha = true,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "bottomleft",
				parentpoint = "bottomleft",
				x = 0,
				y = 0,
			},
		},
	},
	fg = 
	{
		colorsettings = 
		{
			ColorPreset = "__YELLOW",
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
				b = 0,
			},
			color_group = "none",
			allow_overrides = true,
		},
		alpha = 
		{
			clamp = 0.2,
			out_of_combat = 1,
			in_combat = 1,
			alter = "no",
		},
		texture = 
		{
			scale = 2,
			width = 0,
			y = 0,
			x = 0,
			style = "cut",
			height = 0,
			slice = "none",
			texture_group = "none",
			name = "squared_bar_2",
		},
	},
	name = "GroupMember1AP",
	slow_changing_value = false,
	watching_states = 
	{
	},
	width = 10,
	no_tooltip = true,
	show = true,
	hide_if_zero = false,
	--interactive = true,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "Range-Group",
	},
	show_with_target = false,
	block_layout_editor = true,
	visibility_group = "none",	
	interactive_type = "group",
	height = 60,
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
				r = 60,
				g = 60,
				b = 60,
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
			scale = 1,
			width = 0,
			texture_group = "none",
			slice = "none",
			style = "cut",
			height = 0,
			x = 0,
			y = 0,
			name = "tint_square",
		},
	},
	anchors = {
		[1] = {
			parent = "GroupMember1",
			point = "bottomright",
			parentpoint = "bottomleft",
			x = 0,
			y = 0,
		},
	},
	labels = {},
	images = {},
}
UFTemplates.Bars.Wothor_GroupMemberAP.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.Wothor_GroupMemberAP.icon = Addon.GetDefaultCareerIcon()

UFTemplates.Bars.Wothor_GroupMemberMorale = 
{
	grow = "up",
	hide_if_target = false,	
	scale = 0.75,
	border = 
	{
		padding = 
		{
			top = 3,
			right = 0,
			left = 3,
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
				b = 30,
				g = 30,
				r = 30,
			},
			allow_overrides = false,
			color_group = "none",
		},
		follow_bg_alpha = true,
		alpha = 1,
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
	pos_at_world_object = false,
	fg = 
	{
		colorsettings = 
		{
			ColorPreset = "__RED",
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
				r = 255,
			},
			allow_overrides = true,
			color_group = "none",
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
			scale = 2,
			width = 0,
			y = 0,
			x = 0,
			style = "cut",
			height = 0,
			name = "squared_bar_2",
			texture_group = "none",
			slice = "none",
		},
	},
	icon = 
	{
		scale = 0.8,
		alpha = 0.5,
		show = true,
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "center",
				parentpoint = "center",
				x = 0,
				y = 0,
			},
		},
		texture = 
		{
			y = 0,
			slice = "none",
			name = "",
			scale = 1,
			x = 0,
		},
	},
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
				b = "no",
				g = "no",
				r = "no",
			},
			color = 
			{
				b = 60,
				g = 60,
				r = 60,
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
	block_layout_editor = true,
	no_tooltip = true,
	hide_if_zero = false,
	alphasettings = 
	{
		alpha = 1,
		alpha_group = "Range-Group",
	},
	show_with_target = false,
	visibility_group = "none",
	width = 10,
	show = true,
	--interactive = true,
	interactive_type = "group",
	height = 60,
	name = "GroupMember1Morale",
	state = "grp1morale",
	anchors = {
		[1] = {
			point = "bottomright",
			parentpoint = "bottomleft",
			parent = "GroupMember1AP",
			x = 0,
			y = 0,
		},
	},
	images = {},
	labels = {},
}
UFTemplates.Bars.Wothor_GroupMemberMorale.rvr_icon = Addon.GetDefaultRvrIcon()
UFTemplates.Bars.Wothor_GroupMemberMorale.status_icon = Addon.GetDefaultStatusIcon()

--
-- Layouts
--
UFTemplates.Layouts.Wothor = {}

UFTemplates.Layouts.Wothor.PlayerHP = UFTemplates.Bars.Wothor_HP
UFTemplates.Layouts.Wothor.PlayerAP = UFTemplates.Bars.Wothor_PlayerAP

UFTemplates.Layouts.Wothor.Castbar = UFTemplates.Bars.Wothor_Castbar

--UFTemplates.Layouts.Wothor.HostileTarget = UFTemplates.Bars.Wothor_HostileTarget
UFTemplates.Layouts.Wothor.HostileTarget = Addon.deepcopy(UFTemplates.Bars.Wothor_HP)
UFTemplates.Layouts.Wothor.HostileTarget.name = "HostileTarget"
UFTemplates.Layouts.Wothor.HostileTarget.state = "HTHP"
UFTemplates.Layouts.Wothor.HostileTarget.anchors[1].parent = "Castbar"
UFTemplates.Layouts.Wothor.HostileTarget.anchors[1].parentpoint = "right"
UFTemplates.Layouts.Wothor.HostileTarget.anchors[1].point = "left"
UFTemplates.Layouts.Wothor.HostileTarget.x = 0
UFTemplates.Layouts.Wothor.HostileTarget.y = 0
UFTemplates.Layouts.Wothor.HostileTarget.interactive_type = "none"
UFTemplates.Layouts.Wothor.HostileTarget.alphasettings.alpha_group = "Range-Targets"
UFTemplates.Layouts.Wothor.HostileTarget.labels.Name = Addon.deepcopy(UFTemplates.Labels.Wothor_Name)
UFTemplates.Layouts.Wothor.HostileTarget.labels.Range = Addon.deepcopy(UFTemplates.Labels.Wothor_Range)
UFTemplates.Layouts.Wothor.HostileTarget.labels.Range.colorsettings.color_group = "Range"
UFTemplates.Layouts.Wothor.HostileTarget.fg.colorsettings.allow_overrides = true
UFTemplates.Layouts.Wothor.HostileTarget.fg.colorsettings.color_group = "none"

--UFTemplates.Layouts.Wothor.FriendlyTarget = UFTemplates.Bars.Wothor_FriendlyTarget
UFTemplates.Layouts.Wothor.FriendlyTarget = Addon.deepcopy(UFTemplates.Bars.Wothor_HP)
UFTemplates.Layouts.Wothor.FriendlyTarget.name = "FriendlyTarget"
UFTemplates.Layouts.Wothor.FriendlyTarget.state = "FTHP"
UFTemplates.Layouts.Wothor.FriendlyTarget.anchors[1].parent = "PlayerAP"
UFTemplates.Layouts.Wothor.FriendlyTarget.anchors[1].parentpoint = "left"
UFTemplates.Layouts.Wothor.FriendlyTarget.anchors[1].point = "right"
UFTemplates.Layouts.Wothor.FriendlyTarget.x = 0
UFTemplates.Layouts.Wothor.FriendlyTarget.y = 0
UFTemplates.Layouts.Wothor.FriendlyTarget.interactive_type = "friendly"
UFTemplates.Layouts.Wothor.FriendlyTarget.alphasettings.alpha_group = "Range-FriendlyTargets"
UFTemplates.Layouts.Wothor.FriendlyTarget.labels.Name = Addon.deepcopy(UFTemplates.Labels.Wothor_Name)
UFTemplates.Layouts.Wothor.FriendlyTarget.labels.Name.font.align = "right"
UFTemplates.Layouts.Wothor.FriendlyTarget.labels.Name.anchors[1].point = "bottomright"
UFTemplates.Layouts.Wothor.FriendlyTarget.labels.Name.anchors[1].parentpoint = "topright"
UFTemplates.Layouts.Wothor.FriendlyTarget.labels.Range = Addon.deepcopy(UFTemplates.Labels.Wothor_Range)
UFTemplates.Layouts.Wothor.FriendlyTarget.labels.Range.colorsettings.color_group = "Range"
UFTemplates.Layouts.Wothor.FriendlyTarget.fg.colorsettings.allow_overrides = true
UFTemplates.Layouts.Wothor.FriendlyTarget.fg.colorsettings.color_group = "none"

UFTemplates.Layouts.Wothor.FriendlyTargetunit = Addon.deepcopy(UFTemplates.Bars.Yak_TargetRing)
UFTemplates.Layouts.Wothor.FriendlyTargetunit.visibility_group = "HideIfSelf"
UFTemplates.Layouts.Wothor.HostileTargetunit = UFTemplates.Layouts.YakUI_140.HostileTargetRing

for i = 1, 6  do
	UFTemplates.Layouts.Wothor["GroupMember"..i.."AP"] = Addon.deepcopy(UFTemplates.Bars.Wothor_GroupMemberAP)
	UFTemplates.Layouts.Wothor["GroupMember"..i.."AP"].name = "GroupMember"..i.."AP"
	UFTemplates.Layouts.Wothor["GroupMember"..i.."AP"].state = "grp"..i.."ap"
	if i == 1 then
		UFTemplates.Layouts.Wothor["GroupMember"..i.."AP"].anchors[1] = {
			parent = "Root",
			parentpoint = "left",
			point = "left",
			x = 10,
			y = 50,
		}
	else
		UFTemplates.Layouts.Wothor["GroupMember"..i.."AP"].anchors[1] = {
			parent = "GroupMember"..(i-1),
			parentpoint = "bottomright",
			point = "bottomleft",
			x = 0,
			y = 0,
		}
	end
	
	UFTemplates.Layouts.Wothor["GroupMember"..i] = Addon.deepcopy(UFTemplates.Bars.Wothor_GroupMember)
	UFTemplates.Layouts.Wothor["GroupMember"..i].name = "GroupMember"..i
	UFTemplates.Layouts.Wothor["GroupMember"..i].state = "grp"..i.."hp"
	UFTemplates.Layouts.Wothor["GroupMember"..i].anchors[1] = {
		parent = "GroupMember"..i.."AP",
		parentpoint = "bottomright",
		point = "bottomleft",
		x = 0,
		y = 0,
	}

end


for i = 2, 6 do
	UFTemplates.Layouts.Wothor["WorldGroupMember"..i] = Addon.deepcopy(UFTemplates.Bars.YakUI_140_WorldGroupMember)
	UFTemplates.Layouts.Wothor["WorldGroupMember"..i].name = "WorldGroupMember"..i
	UFTemplates.Layouts.Wothor["WorldGroupMember"..i].state = "grp"..i.."hp"
	UFTemplates.Layouts.Wothor["WorldGroupMember"..i].anchors[1].parent = "WorldGroupMember"..i.."Invisi"
	UFTemplates.Layouts.Wothor["WorldGroupMember"..i].alphasettings.alpha_group = "Range-Formation"
end


-- Friendly Custom Group
for i = 1,6 do
	UFTemplates.Layouts.Wothor["GroupMemberCF"..i] = Addon.deepcopy(UFTemplates.Bars.Wothor_GroupMember)
	UFTemplates.Layouts.Wothor["GroupMemberCF"..i].name = "GroupMemberCF"..i
	UFTemplates.Layouts.Wothor["GroupMemberCF"..i].state = "grpCF"..i.."hp"
	UFTemplates.Layouts.Wothor["GroupMemberCF"..i].interactive_type = "state"
	UFTemplates.Layouts.Wothor["GroupMemberCF"..i].alphasettings.alpha_group = "none"
	if i == 1 then
		UFTemplates.Layouts.Wothor.GroupMemberCF1.anchors[1] = {
			parent = "GroupMember6",
			parentpoint = "bottom",
			point = "top",
			x = 0,
			y = 5,
		}
	else
		UFTemplates.Layouts.Wothor["GroupMemberCF"..i].anchors[1] = {
			parent = "GroupMemberCF"..(i-1),
			parentpoint = "bottomright",
			point = "bottomleft",
			x = 5,
			y = 0,
		}
	end
end


-- Hostile Custom Group
for i = 1,6 do
	UFTemplates.Layouts.Wothor["GroupMemberCH"..i] = Addon.deepcopy(UFTemplates.Bars.Wothor_GroupMember)
	UFTemplates.Layouts.Wothor["GroupMemberCH"..i].name = "GroupMemberCH"..i
	UFTemplates.Layouts.Wothor["GroupMemberCH"..i].state = "grpCH"..i.."hp"
	UFTemplates.Layouts.Wothor["GroupMemberCH"..i].interactive_type = "state"
	UFTemplates.Layouts.Wothor["GroupMemberCH"..i].alphasettings.alpha_group = "none"
	if i == 1 then
		UFTemplates.Layouts.Wothor.GroupMemberCH1.anchors[1] = {
			parent = "Root",
			parentpoint = "center",
			point = "center",
			x = 280,
			y = 460,
		}
	else
		UFTemplates.Layouts.Wothor["GroupMemberCH"..i].anchors[1] = {
			parent = "GroupMemberCH"..(i-1),
			parentpoint = "bottomright",
			point = "bottomleft",
			x = 5,
			y = 0,
		}
	end
end

--
--	Formation
--
for i = 1, 5 do
	for j = 1, 6 do
		UFTemplates.Layouts.Wothor["FormationMember"..i..j] = Addon.deepcopy(UFTemplates.Bars.Wothor_GroupMember)
		UFTemplates.Layouts.Wothor["FormationMember"..i..j].name = "FormationMember"..i..j
		UFTemplates.Layouts.Wothor["FormationMember"..i..j].state = "formation"..i..j.."hp"
		UFTemplates.Layouts.Wothor["FormationMember"..i..j].interactive_type = "formation"
		if j ~= 1 then
			UFTemplates.Layouts.Wothor["FormationMember"..i..j].anchors[1] = {
				parent = "FormationMember"..i..(j-1),
				parentpoint = "bottomright",
				point = "bottomleft",
				x = 5,
				y = 0,
			}
		elseif i~= 1 then
			UFTemplates.Layouts.Wothor["FormationMember"..i..j].anchors[1] = {
				parent = "FormationMember"..(i-1)..j,
				parentpoint = "topleft",
				point = "bottomleft",
				x = 0,
				y = -5,
			}
		else
			UFTemplates.Layouts.Wothor["FormationMember"..i..j].anchors[1] = {
				parent = "GroupMember1",
				parentpoint = "top",
				point = "bottom",
				x = 0,
				y = -5,
			}
		end
	end
end