if not Effigy then Effigy = {} end
local Addon = Effigy

if not UFTemplates then UFTemplates = {} end
if not UFTemplates.Images then UFTemplates.Images = {} end
if not UFTemplates.Labels then UFTemplates.Labels = {} end
if not UFTemplates.Bars then UFTemplates.Bars = {} end
if not UFTemplates.Layouts then UFTemplates.Layouts = {} end

function Addon.GetDefaultLabel()
	return {
		follow = "no", -- bar | no		--deprecated?
		formattemplate = "$per",		--move to text/font table
		clip_after = 14,
		--always_show = false,			--deprecated
			
		show = true,
		visibility_group = "none",
		alpha = 1,
		
		layer = "overlay",
		parent = "Bar",
		
		width = 0,						-- 0: width of Bar
		height = 24,
		scale = 1,

		anchors = {
			[1] = {
				parent = "Bar",
				point = "center",
				parentpoint = "center",
				x = 0,
				y = 0,
			},
		},
		colorsettings =
		{
			color = {r = 220, g = 220, b = 220},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "none",
			ColorPreset = "none",
		},
		font = {
			name = "font_clear_medium",
			align = "center",
			case = "none"
		},
	}
end

function Addon.GetDefaultImage()
	return {
		show = true,
		visibility_group = "none",
			
		alpha = 1,
		--follow_bg_alpha = true,
		alpha_group = "none",

		parent = "Bar",
		layer = "default",

		
		anchors = {
			[1] = {
				-- Anchor 1
				parent = "Bar",
				point = "topleft",
				parentpoint = "topleft",
				x = 0,
				y = 0,
			},
			-- Anchor 2; to use size set anchor2 = nil
			--[[ [2] = {
				point = "bottomright",
				parent = "Bar",
				parentpoint = "bottomright",
				x = 0,
				y = 0,
			},]]--
		},
		
		--Size; Fallback for no second Anchor
		width = 60,
		height = 60,
		scale = 1,
		
		colorsettings =
		{
			color = {r = 220, g = 220, b = 220},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "none",
			ColorPreset = "none",
		},	
		texture = {
			texture_group = "none",
			name = "tint_square",
			scale = 1,
			slice = "none",
			x = 0,
			y = 0,
			width = 0,
			height = 0,
			--flipped = false
		}
	}
end

function Addon.GetDefaultRvrIcon()
	return
	{
		scale = .55,		
		alpha = 1,
		show = false,		
		follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "topleft",
				parentpoint = "topleft",
				x = 0,
				y = 0,
			},
		},
	}
end

function Addon.GetDefaultStatusIcon()
	return
	{
        show = false,
        scale = 1,
        alpha = 1,
        follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "bottomleft",
				parentpoint = "topleft",
				x = 0,
				y = 0,
			},
		},
    }
end

function Addon.GetDefaultCareerIcon()
	return
	{
        show = false,
        scale = 1,
        alpha = 1,
        follow_bg_alpha = false,
		anchors = {
			[1] = {
				parent = "Bar",
				point = "bottomleft",
				parentpoint = "bottomleft",
				x = 0,
				y = 0,
			},
		},		
    }
end

function Addon.GetDefaultAnchorOne()
	return {
		parent = "Bar",
		parentpoint = "topleft",
		point = "topleft",
		x = 0,
		y = 0,		
	}
end

function Addon.GetDefaultAnchorTwo()
	return {
		parent = "Bar",
		parentpoint = "bottomright",
		point = "bottomright",
		x = 0,
		y = 0,		
	}
end

local labelcolorsettings =
{
	color = {r = 220, g = 220, b = 220},
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

-- Images
UFTemplates.Images.Indicator = {
	show = false,
	visibility_group = "none",
	
	parent = "Bar Fill",
	layer = "overlay",
	
	alpha = 1,
	follow_bg_alpha = true,

	--Size
	width = 9,
	height = 9,
	scale = 1,
	
	anchors = {
		[1] = {
			parent = "Bar BG",
			point = "topleft",
			parentpoint = "topleft",
			x = 0,
			y = 0,
		},
	},
	colorsettings =
	{
		color = {r = 127, g = 127, b = 127},
		alter = {r = "no", g = "no", b = "no"},
		allow_overrides = false,
		color_group = "none",
		ColorPreset = "none",
	},
}
UFTemplates.Images.Indicator.texture = Addon.deepcopy(default_texturesettings)
	
-- Labels
UFTemplates.Labels.Value = {
	--follow = "no", -- bar | no
	formattemplate = "$value",
	--always_show = false,			--?
	
	show = true,
	alpha = 1,

	parent = "Bar",
	layer = "secondary",
	
	height = 24,
	width = 0,						-- 0: width of Bar
	scale = 1,
	
	anchors = {
		[1] = {
			parent = "Bar",
			point = "bottomright",
			parentpoint = "bottomright",
			x = -15,
			y = -15,
		},
	},
		
	font = {
		name = "font_clear_medium",
		align = "right",
	},
}
UFTemplates.Labels.Value.colorsettings = Addon.deepcopy(labelcolorsettings)

UFTemplates.Labels.Level = {
	--follow = "no", -- bar | no
	formattemplate = "$lvl",
	always_show = false,			--?
	
	show = true,
	alpha = 1,

	parent = "Bar",
	layer = "secondary",
	
	height = 24,
	width = 0,						-- 0: width of Bar
	scale = 1,

	anchors = {
		[1] = {
			parent = "Bar",
			point = "left",
			parentpoint = "left",
			x = 0,
			y = 0,
		},
	},
	
	font = {
		name = "font_clear_medium",
		align = "left",
	},
}
UFTemplates.Labels.Level.colorsettings = Addon.deepcopy(labelcolorsettings)

UFTemplates.Labels.Name = {
	--follow = "no", -- bar | no
	formattemplate = "$title",
	always_show = false,			--?
	
	show = true,
	alpha = 1,

	layer = "secondary",
	parent = "Bar",
	
	height = 24,
	width = 0,						-- 0: width of Bar
	scale = 1,
	
	anchors = {
		[1] = {
			parent = "Bar",
			point = "center",
			parentpoint = "center",
			x = 0,
			y = 0,
		},
	},
	
	font = {
		name = "font_clear_medium",
		align = "center",
	},
}
UFTemplates.Labels.Name.colorsettings = Addon.deepcopy(labelcolorsettings)

-- Bar
EffigyBarDefaults = {
    -- Setup Defaults
    name = "template",

-- General Behaviour
    state = "default",
    watching_states = {},
    --interactive = false,
    interactive_type = "none",
	
    grow = "right",
    width = 300,
    height = 20,

-- General Positioning
	pos_at_world_object = false,
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
	
-- General Visibility
    show = true,
    show_with_target = false,
	show_with_target_ht = false,
    hide_if_zero = false,
    hide_if_target = false,
    visibility_group = "none",

-- General Misc
	slow_changing_value = false,
	no_tooltip = false,
    block_layout_editor = false,
	
	alphasettings = {
		alpha = 1,
		alpha_group = "none"
	},
    fg = {
		alpha = {
			in_combat = 1,
			out_of_combat = 1,
			alter = "no",
			clamp = 0.2
		},
		colorsettings = {
			color = {r = 255, g = 255, b = 255},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = true,
			color_group = "none"
		},
    },

-- Bar Frames
	border = {
        alpha = 1,
        follow_bg_alpha = false,
		colorsettings =
		{
			color = {r = 0, g = 0, b = 0},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "none"
		},
		padding = { top = 2, left = 2, right = 2, bottom = 2}
    }, -- border

	bg = {
        alpha = {
            in_combat = 0.7,
            out_of_combat = 0.7,
        },
        colorsettings =
		{
			color = {r = 30, g = 30, b = 30},
			alter = {r = "no", g = "no", b = "no"},
			allow_overrides = false,
			color_group = "none"
		},
        show = true
    }, -- bg
	
	-- Labels
	labels = {},
	-- Indicators
    images = {},	
}
-- Insert local defaults
EffigyBarDefaults.fg.texture = Addon.deepcopy(default_texturesettings)
EffigyBarDefaults.bg.texture = Addon.deepcopy(default_texturesettings)
EffigyBarDefaults.border.texture = Addon.deepcopy(default_texturesettings)

-- Insert Labels & Images
EffigyBarDefaults.labels.Value = Addon.deepcopy(UFTemplates.Labels.Value)
EffigyBarDefaults.labels.Level = Addon.deepcopy(UFTemplates.Labels.Level)
EffigyBarDefaults.labels.Name = Addon.deepcopy(UFTemplates.Labels.Name)
--[[EffigyBarDefaults.images.Indicator1 = Addon.deepcopy(UFTemplates.Images.Indicator)
EffigyBarDefaults.images.Indicator2 = Addon.deepcopy(UFTemplates.Images.Indicator)
EffigyBarDefaults.images.Indicator2.anchors[1].point = "topright"
EffigyBarDefaults.images.Indicator2.anchors[1].parentpoint = "topright"
EffigyBarDefaults.images.Indicator3 = Addon.deepcopy(UFTemplates.Images.Indicator)
EffigyBarDefaults.images.Indicator3.anchors[1].point = "bottomleft"
EffigyBarDefaults.images.Indicator3.anchors[1].parentpoint = "bottomleft"
EffigyBarDefaults.images.Indicator4 = Addon.deepcopy(UFTemplates.Images.Indicator)
EffigyBarDefaults.images.Indicator4.anchors[1].point = "bottomright"
EffigyBarDefaults.images.Indicator4.anchors[1].parentpoint = "bottomright"
]]--

-- Insert Icons
EffigyBarDefaults.rvr_icon = Addon.GetDefaultRvrIcon()
EffigyBarDefaults.icon = Addon.GetDefaultCareerIcon()
EffigyBarDefaults.status_icon = Addon.GetDefaultStatusIcon()

if not UFTemplates.Bars then UFTemplates.Bars = {} end
UFTemplates.Bars["_Default"] = EffigyBarDefaults
local emptyBar = Addon.deepcopy(EffigyBarDefaults)
emptyBar.border.alpha = 0
emptyBar.bg.alpha.in_combat = 0
emptyBar.bg.alpha.out_of_combat = 0
emptyBar.fg.alpha.in_combat = 0
emptyBar.fg.alpha.out_of_combat = 0
emptyBar.labels = {}
emptyBar.width = 1
emptyBar.height = 1
emptyBar.state = "none"
emptyBar.anchors = {
	[1] = 
	{
		point = "bottomleft",
		parent = "Root",
		parentpoint = "bottomleft",
		x = 0,
		y = 0,
	},
}
emptyBar.layer = "background"
emptyBar.block_layout_editor = true
UFTemplates.Bars["_DefaultEmptyPanel"] = emptyBar