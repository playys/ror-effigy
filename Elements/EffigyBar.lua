-- vim: sw=4 ts=4
-- forked of HudUnitFrames: http://war.curseforge.com/addons/huduf/
-- Credits @Metaphaze & Tannecurse

if not Effigy then Effigy = {} end
local Addon = Effigy
if not Addon.Bars then Addon.Bars = {} end
--outsource from Addon.Bars
if not UF_RUNTIMECACHE then UF_RUNTIMECACHE = {} end
if not Addon.States then Addon.States = {} end
local LibGUI = LibStub("LibGUI")

EffigyBar = {}
setmetatable(EffigyBar, {__index = EffigyIndicator})
EffigyBar.__index = EffigyBar

local pairs = pairs
local ipairs = ipairs
local unpack = unpack
local tonumber = tonumber
local towstring = towstring
local max = math.max
local min = math.min
local WindowAddAnchor = WindowAddAnchor
local WindowClearAnchors = WindowClearAnchors
local WindowGetScale = WindowGetScale
local WindowGetShowing = WindowGetShowing
local WindowSetAlpha = WindowSetAlpha
local WindowSetDimensions = WindowSetDimensions
local WindowSetShowing = WindowSetShowing
local WindowSetTintColor = WindowSetTintColor
local WindowSetScale = WindowSetScale
local AttachWindowToWorldObject = AttachWindowToWorldObject
local DetachWindowFromWorldObject = DetachWindowFromWorldObject

function EffigyBar:new(barname) return EffigyBar:new_from_bar(barname, EffigyBarDefaults) end

function EffigyBar:new_from_bar(barname, bar)
    if (nil ~= Addon.Bars[barname] or DoesWindowExist(barname)) then
        EA_ChatWindow.Print(L"Cannot create a new bar for one that exists")
        return nil  -- must be a new bar
    end
    local self = Addon.deepcopy(bar)

    setmetatable(self, EffigyBar) -- setup prototype
    self.name = barname
	
	UF_RUNTIMECACHE[barname] = {}
	UF_RUNTIMECACHE[barname].initialized = false
    --d("creating bar "..self.name)

    -- Add it to the Bars table for savings
    Addon.Bars[barname] = self
		
    return self
end

function EffigyBar.Init(barname)
	--if barname == "WBTemplate" or barname == "SCTemplate" then return end
    local self = Addon.Bars[barname]
    if (nil == self) then EA_ChatWindow.Print(L"bar "..towstring(barname)..L" is nil") return end

    setmetatable(self, EffigyBar) -- setup prototype

	--will be in the savedsettings if we use self. and we don´t want that do we
	if not UF_RUNTIMECACHE[barname] then UF_RUNTIMECACHE[barname] = {} end
	if (true == UF_RUNTIMECACHE[barname].initialized) then return end
	
    -- Create the Window
	if not DoesWindowExist(self.name) then
		CreateWindowFromTemplate(self.name, "EffigyBarTemplate", "Root")
	end
	
	-- legacy names
	if not UF_RUNTIMECACHE[barname].Names then UF_RUNTIMECACHE[barname].Names = {} end
    UF_RUNTIMECACHE[barname].Names.bg = barname.."BG"
    UF_RUNTIMECACHE[barname].Names.fg = barname.."FG"
	UF_RUNTIMECACHE[barname].Names.fgfill = barname.."FGFill"
    UF_RUNTIMECACHE[barname].Names.border = barname.."Border"
	UF_RUNTIMECACHE[barname].Names.invisi = barname.."Invisi"
	
	if not UF_RUNTIMECACHE[barname].Images then UF_RUNTIMECACHE[barname].Images = {} end
	if self.images ~= nil then
		for k,_ in pairs(self.images) do
			UF_RUNTIMECACHE[barname].Images[k] = Effigy.Image.Create(self, k)
		end
	else
		self.images = {}
	end
	
	if not UF_RUNTIMECACHE[barname].Icons then UF_RUNTIMECACHE[barname].Icons = {} end
	UF_RUNTIMECACHE[barname].Icons.Career = Addon.CreateCareerIcon(self)
	UF_RUNTIMECACHE[barname].Icons.RvrIndicator = Addon.CreateRvRIndicator(self)
	UF_RUNTIMECACHE[barname].Icons.Status = Addon.CreateStatusIcon(self)
	
	if not UF_RUNTIMECACHE[barname].Labels then UF_RUNTIMECACHE[barname].Labels = {} end
	if self.labels ~= nil then
		for k,_ in pairs(self.labels) do
			UF_RUNTIMECACHE[barname].Labels[k] = Effigy.Label.Create(self, k)
		end
	else
		self.labels = {}
	end
	
    -- register it
    if (true ~= self.block_layout_editor) and LayoutEditor.windowsList[ self.name ] == nil then
        LayoutEditor.RegisterWindow(self.name, L"Effigy Bar "..towstring(self.name), L"Effigy", true, true, true, nil)
	elseif self.block_layout_editor and Vectors then
		Vectors.Register(self.name)
    end

    WindowSetHandleInput(self.name, false)
	UF_RUNTIMECACHE[barname].initialized = true
    return self:fixStates()
end

-- Recreate Name from ConfigUI Dropdown Menu (Parent/AnchorTo)
function EffigyBar:GetFrameNameFromCBoxString(cBoxString)

	if cBoxString =="Bar" then
		return self.name
	--elseif cBoxString =="Root" then
	--	return "Root"
	elseif cBoxString == "Bar Fill" then
		return UF_RUNTIMECACHE[self.name].Names.fg
	elseif cBoxString == "Bar BG" then
		return UF_RUNTIMECACHE[self.name].Names.bg
	elseif cBoxString ~= nil and (DoesWindowExist(self.name..cBoxString)) then
		return self.name..cBoxString
	else
		return cBoxString
	end
end

function EffigyBar:setup()
    if (LayoutEditor.isActive == true) then return end
	local runtimeCache = UF_RUNTIMECACHE[self.name]
	
	if self:isInteractive() then self:addInteractive(self.interactive_type) end
    -- Setup the attach to world object
    if (true == self.pos_at_world_object) then
        -- When you attach to a world object it only goes directly overtop of it
        -- so to have different settings (left, right, top, down) we need to
        -- attach our bar to an invisible window that is actually attached to
        -- the object
		local invisiName = runtimeCache.Names.invisi
        if (false == DoesWindowExist(invisiName)) then
            CreateWindowFromTemplate(invisiName, "EffigyEmpty", "Root")
			WindowSetShowing(invisiName, false)
			WindowSetHandleInput(invisiName, false)
			WindowSetDimensions(invisiName, 50, 5)
        end
        self.anchors[1].parent = invisiName
        WindowSetParent(self.name, invisiName)
    end

    -- Setup the main BG bar
	WindowSetLayer(self.name, Window.Layers[(self.layer and self.layer:upper()) or "DEFAULT"])
	
	WindowSetDimensions(self.name, self.width, self.height)
	--if not (true ~= self.block_layout_editor and Vectors and Vectors.GetWindows()[self.name]) then
	if not (Vectors and Vectors.GetWindows()[self.name]) then
		WindowClearAnchors(self.name)
		WindowAddAnchor(self.name, self.anchors[1].parentpoint, self.anchors[1].parent, self.anchors[1].point, self.anchors[1].x, self.anchors[1].y)
		WindowSetScale(self.name, self.scale)
	end

    -- border
    --WindowSetDimensions(runtimeCache.Names.border, self.width, self.border.padding.top)	-- with two anchors anchored to the magical parentbar, why set some weird dimension?
	--WindowSetScale(runtimeCache.Names.border, self.scale)
    WindowSetTintColor(runtimeCache.Names.border, self.border.colorsettings.color.r, self.border.colorsettings.color.g, self.border.colorsettings.color.b)
    Addon.TextureManager.SetTexture(runtimeCache.Names.border, self.border.texture.name)
	WindowSetAlpha(runtimeCache.Names.border, self.border.alpha)
	
    -- Setup the background image
    WindowSetTintColor(runtimeCache.Names.bg, self.bg.colorsettings.color.r, self.bg.colorsettings.color.g, self.bg.colorsettings.color.b)
    Addon.TextureManager.SetTexture(runtimeCache.Names.bg, self.bg.texture.name)
    WindowClearAnchors(runtimeCache.Names.bg)
    WindowAddAnchor(runtimeCache.Names.bg, "topleft", self.name, "topleft", self.border.padding.left, self.border.padding.top)
	WindowAddAnchor(runtimeCache.Names.bg, "bottomright", self.name, "bottomright", 0 - self.border.padding.right, 0 - self.border.padding.bottom)

    -- Setup the colored image
	local width = self.width - (self.border.padding.left + self.border.padding.right)
    local height = self.height - (self.border.padding.top + self.border.padding.bottom)
    --WindowSetScale(runtimeCache.Names.fg, self.scale)
    WindowSetDimensions(runtimeCache.Names.fg, width, height)
    Addon.TextureManager.SetTexture(runtimeCache.Names.fg.."Fill", self.fg.texture.name)
	DynamicImageSetTextureScale(runtimeCache.Names.fg.."Fill", self.fg.texture.scale)
	
    -- grow direction for bar
	WindowClearAnchors(runtimeCache.Names.fg)
    if ("up" == self.grow) then       
        WindowAddAnchor(runtimeCache.Names.fg, "bottomright", runtimeCache.Names.bg, "bottomright", 0, 0)
    elseif ("down" == self.grow) then
        WindowAddAnchor(runtimeCache.Names.fg, "topright", runtimeCache.Names.bg, "topright", 0, 0)
    elseif ("left" == self.grow) then
        WindowAddAnchor(runtimeCache.Names.fg, "bottomright", runtimeCache.Names.bg, "bottomright", 0, 0)
    elseif ("right" == self.grow) then
		WindowAddAnchor(runtimeCache.Names.fg, "bottomleft", runtimeCache.Names.bg, "bottomleft", 0, 0)
	else
		DEBUG(towstring(runtimeCache.Names.fg)..L" has no grow direction. Abort.")
		return
    end
	
	for _, i in pairs(runtimeCache.Images) do i:Setup() end
	for _, l in pairs(runtimeCache.Labels) do l:Setup() end
	runtimeCache.Icons.Career:Setup()
	runtimeCache.Icons.RvrIndicator:Setup()
	runtimeCache.Icons.Status:Setup()
	
    WindowSetShowing(self.name, false)
    WindowSetHandleInput(self.name, self:isInteractive())
    if (true == self.block_layout_editor) and LayoutEditor.windowsList[ self.name ] ~= nil then LayoutEditor.UnregisterWindow(self.name) end

    return self
end

function EffigyBar.hideBar(barName)
    if (Addon.Bars[barName].name) then
        WindowSetShowing(Addon.Bars[barName].name, false)
    end
end

function EffigyBar.reRenderAfterTargetChange(oldId,newId, VarName)
    for _, bar in pairs (Addon.Bars) do
		local runtimeCache = UF_RUNTIMECACHE[bar.name]
        if (runtimeCache and runtimeCache.initialized)
        then
			if bar[VarName] then
				bar:render()
			elseif bar.hide_if_target and
				runtimeCache.entity_id and
                ((oldId and runtimeCache.entity_id == oldId) or
				(newId and runtimeCache.entity_id == newId)) then
				bar:render()
			else
				local render = false
				for elementName in pairs(bar.images) do
					if bar.images[elementName].show_if_target then
						render = true
						break 
					end
				end
				if render == false then
					for elementName in pairs(bar.labels) do
						if bar.labels[elementName].show_if_target then
							render = true
							break
						end
					end
				end
				if render == true then bar:render() end
			end
        end
    end
end

function EffigyBar.reRenderAfterCombatChange()
    for _,v in pairs (Addon.Bars) do
        if (
			UF_RUNTIMECACHE[v.name] and UF_RUNTIMECACHE[v.name].initialized --[[and
			(v.bg.alpha.in_combat ~= v.bg.alpha.out_of_combat or
            v.fg.alpha.in_combat ~= v.fg.alpha.out_of_combat)]]-- bad bad fix until rule system is overhauled
			)
        then
            --local bar = Addon.Bars[v]
            --setmetatable(bar, EffigyBar)
            v:render()
        end
    end
end

--[[function EffigyBar:renderTintColour()

    if (LayoutEditor.isActive == true) then return end

	if (false == UF_RUNTIMECACHE[self.name].initialized) then return end
	
    local state = Addon.States[self.state]
    if (nil == state) then return end

    if (
        (not self.show) or
        (state.valid) and
        (0 == state.valid)
        )
    then
        return
    end

    local perc = state.curr / state.max
    if (perc > 1) then perc = 1 end
    local invperc = 1 - perc

	local settings = self.fg.colorsettings
    -- Setup the tinting options
    local r = settings.color.r
    local g = settings.color.g
    local b = settings.color.b

    if (
        (true == settings.allow_overrides) and
        (nil ~= state.color_override) and
        (nil ~= state.color_override.r) and
        (nil ~= state.color_override.g) and
        (nil ~= state.color_override.b)
        )
    then
        r = state.color_override.r
        g = state.color_override.g
        b = state.color_override.b
    end

    if ("inv" == settings.alter.r) then
        r = r * invperc
    elseif ("perc" == settings.alter.r) then
        r = r * perc
    end
    if ("inv" == settings.alter.g) then
        g = g * invperc
    elseif ("perc" == settings.alter.g) then
        g = g * perc
    end
    if ("inv" == settings.alter.b) then
        b = b * invperc
    elseif ("perc" == settings.alter.b) then
        b = b * perc
    end


    if (settings.color_group and settings.color_group ~= "none") then
        --local color = Addon.Colouring.GetColour(settings.color_group, state)
		local colorName = Addon.GetPayload("Colors", settings.color_group, state)
		local color = RVMOD_GColorPresets.GetColorPreset(colorName)
        if (color and color.r ~= nil and color.g ~= nil and color.b ~= nil) then
            WindowSetTintColor(UF_RUNTIMECACHE[self.name].Names.fg, color.r, color.g, color.b)
        else
            WindowSetTintColor(UF_RUNTIMECACHE[self.name].Names.fg, r, g, b)
        end
    else
		WindowSetTintColor(UF_RUNTIMECACHE[self.name].Names.fg, r, g, b)
    end

end
]]--

function EffigyBar:getRenderAlpha(settings, state)
	if (settings.alpha_group and settings.alpha_group ~= "none") then
		return Addon.GetPayload("Alpha", settings.alpha_group, state)
	end
	return nil
end

function EffigyBar:getRenderVisibility(settings, state)
	-- change this for push updates from other addons
	--[[if (true == settings.show) then
		if (settings.visibility_group and settings.visibility_group ~= "none") then
			return Addon.Visibility.GetVisibility(settings.visibility_group, state)
		end
		if ((nil ~= settings.show_if_target)and(true == settings.show_if_target)) then
			if (state.entity_id ~= nil and state.entity_id ~= 0 and  state.entity_id == TargetInfo:UnitEntityId("selffriendlytarget") ) then
				return true
			else
				return false
			end
		end
		return true
	end
	return false
	]]--
	if (settings.visibility_group and settings.visibility_group ~= "none") then
		--return Addon.Visibility.GetVisibility(settings.visibility_group, state)
		return Addon.GetPayload("Visibility", settings.visibility_group, state)
	end
	if (true == settings.show_if_target) then
		if (state.entity_id ~= nil and state.entity_id ~= 0 and  state.entity_id == TargetInfo:UnitEntityId("selffriendlytarget") ) then
			return true
		else
			return false
		end
	end
	return nil
end

function EffigyBar:getRenderColor(settings, state)
	
	-- start with the unmodified color
	local r = settings.color.r
	local g = settings.color.g
	local b = settings.color.b
	if settings.ColorPreset ~= nil and settings.ColorPreset ~= "" and settings.ColorPreset ~= "none" then
		local ColorPreset = RVMOD_GColorPresets.GetColorPreset(settings.ColorPreset)
		r = ColorPreset.r
		g = ColorPreset.g
		b = ColorPreset.b
	end
	
	-- override
	if (
        (true == settings.allow_overrides) and
        (nil ~= state.color_override) and
        (nil ~= state.color_override.r) and
        (nil ~= state.color_override.g) and
        (nil ~= state.color_override.b)
        )
    then
		r = state.color_override.r
		g = state.color_override.g
		b = state.color_override.b
    end
	
	-- Dynamic color
    if (settings.color_group and settings.color_group ~= "none") then
		local colorName = Addon.GetPayload("Colors", settings.color_group, state)
		if colorName ~= nil then
			local color = RVMOD_GColorPresets.GetColorPreset(colorName)
			if (color and color.r ~= nil) then		-- check necessary?			
				r = color.r
				g = color.g
				b = color.b
			end
		end
    end
	
	-- Alter
	local perc = state.curr / state.max
    if (perc > 1) then perc = 1 end
    local invperc = 1 - perc
	if (settings.alter.r ~= nil) then
		if ("inv" == settings.alter.r) then
			r = r * invperc
		elseif ("perc" == settings.alter.r) then
			r = r * perc
		end
		if ("inv" == settings.alter.g) then
			g = g * invperc
		elseif ("perc" == settings.alter.g) then
			g = g * perc
		end
		if ("inv" == settings.alter.b) then
			b = b * invperc
		elseif ("perc" == settings.alter.b) then
			b = b * perc
		end
	end
	
	return r, g, b
end

function EffigyBar:getRenderTexture(settings, state)
    if (settings.texture_group and settings.texture_group ~= "none") then
		local textureName = Addon.GetPayload("Textures", settings.texture_group, state)
        if (textureName ~= nil and textureName ~= "none") then
            return textureName
        end
    end
	return settings.texture.name
end

function EffigyBar:render(onlyUpdateValue)
    if (LayoutEditor.isActive == true) then return end
	
    local state = Addon.States[self.state]
    if (nil == state) then return end

	local runtimeCache = UF_RUNTIMECACHE[self.name]
	if not runtimeCache.initialized then return end

	-- Attach the bar to something in the world
	if (true == self.pos_at_world_object) then
		--if runtimeCache.entity_id ~= state.entity_id then
			if (nil ~= runtimeCache.entity_id) then
				DetachWindowFromWorldObject(runtimeCache.Names.invisi, runtimeCache.entity_id)
			end
			if (state.entity_id and state.entity_id > 0) and not (self.state == "HTHP" and state.curr == 0) then
				AttachWindowToWorldObject(runtimeCache.Names.invisi, state.entity_id)
			else
				self:hide()
				return
			end
			runtimeCache.entity_id = state.entity_id
		--end
	end
	
	if ((false == self.show) or (nil ~= state.valid) and (0 == state.valid))
	or ((self.hide_if_zero) and (0 == state.curr))
	or ((self.show_with_target and Addon.States["FTHP"].valid == 0 ) and not (self.show_with_target_ht and Addon.States["HTHP"].valid ~= 0 ))
	or ((self.show_with_target_ht and Addon.States["HTHP"].valid == 0 ) and not (self.show_with_target and Addon.States["FTHP"].valid ~= 0 ))
	or ((self.hide_if_target) and (state.entity_id ~= nil and state.entity_id == TargetInfo:UnitEntityId("selffriendlytarget") ))
	or ((self.visibility_group and self.visibility_group ~= "none") and Addon.GetPayload("Visibility", self.visibility_group, state) == false) then
		-- rvr indicator is not necessarily child of self thanks to mythics core event fail
		local rvrIndicator = runtimeCache.Icons.RvrIndicator
		if rvrIndicator and rvrIndicator.GetMouseOver() and rvrIndicator:Showing() then rvrIndicator:Hide() end
		self:hide()
		return
	end
	
    --WindowSetScale(runtimeCache.Names.fg, self.scale)
	local dynamicAlpha = self:getRenderAlpha(self.alphasettings, state)
	if dynamicAlpha ~= nil then	WindowSetAlpha(self.name, dynamicAlpha) end

    -- Do the coloured bar in the middle
    local bg_alpha
    local fg_alpha
    if (((Addon.States["Combat"]) and (1 == Addon.States["Combat"].curr)) or ((state.curr ~= state.max) and (state.curr ~= 0) and (true ~= self.slow_changing_value))) then
        fg_alpha = self.fg.alpha.in_combat
        bg_alpha = self.bg.alpha.in_combat
    elseif ((self.show_with_target) and ((state.curr > 0) or (state.entity_id and state.entity_id > 0))) then
        fg_alpha = self.fg.alpha.in_combat
        bg_alpha = self.bg.alpha.in_combat
    else
        fg_alpha = self.fg.alpha.out_of_combat
        bg_alpha = self.bg.alpha.out_of_combat
    end
	
    local perc = state.curr / state.max
    if (perc > 1) then perc = 1 end
    local invperc = 1 - perc

    -- Do any alpha stuffs for this bar
	if (self.border.follow_bg_alpha) then
        WindowSetAlpha(runtimeCache.Names.border, bg_alpha)
    end
	
    local a = 1.0
    if ("inv" == self.fg.alpha.alter) then
        a = fg_alpha - perc
    elseif ("perc" == self.fg.alpha.alter) then
        a = perc
    end
	local alpha_clamp = self.fg.alpha.clamp
    if (a < alpha_clamp) then a = alpha_clamp end
    if (a > fg_alpha) then a = fg_alpha end
    WindowSetAlpha(runtimeCache.Names.fg, a)
    WindowSetAlpha(runtimeCache.Names.bg, bg_alpha)
	
    --self:renderTintColour()	
	WindowSetTintColor(runtimeCache.Names.border, self:getRenderColor(self.border.colorsettings, state))
	WindowSetTintColor(runtimeCache.Names.bg, self:getRenderColor(self.bg.colorsettings, state))
	WindowSetTintColor(runtimeCache.Names.fg, self:getRenderColor(self.fg.colorsettings, state))
	
    -- bar fill
    local filltexture = self.fg.texture.name
    if (self.fg.texture.texture_group and self.fg.texture.texture_group ~= "none") then
		local tex = Addon.GetPayload("Textures", self.fg.texture.texture_group, state)
        if (tex ~= nil and tex ~= "none") then filltexture = tex end
    end
    local width = self.width - (self.border.padding.left + self.border.padding.right)
    local height = self.height - (self.border.padding.top + self.border.padding.bottom)
	local percOrInv = perc
	if self.invValue then percOrInv = invperc end
	Addon.TextureManager.SetTextureFill(runtimeCache.Names.fgfill, filltexture, width, height, percOrInv, self.grow, self.fg.texture.style )
    if ("up" == self.grow) or ("down" == self.grow) then
        WindowSetDimensions(runtimeCache.Names.fg, width, height * percOrInv)
    elseif ("left" == self.grow) or ("right" == self.grow) then
        WindowSetDimensions(runtimeCache.Names.fg, width * percOrInv, height)
    end


	for _, i in pairs(runtimeCache.Images) do i:Render() end
	for _, l in pairs(runtimeCache.Labels) do l:Render() end
	-- Icons
    if (not onlyUpdateValue) then
        -- icons do not get displayed if alpha is below 20%
        if (bg_alpha ~= 0 and bg_alpha < 0.2) then bg_alpha = 0.2 end

		runtimeCache.Icons.RvrIndicator:Render(bg_alpha)
		
		-- Career / Ability
		if (self.icon.show) then
			local target = state:GetExtraInfo("ability") or state.extra_info.career
			local newState = 0
			if not target or target == 0 then
				if state:GetExtraInfo("isNPC") then
					newState = 1
					target = state:GetExtraInfo("mapPinType")
				end
			end
			runtimeCache.Icons.Career:Render(target, newState)
		end

		runtimeCache.Icons.Status:Render(bg_alpha)
    end

	WindowSetShowing(self.name, true)
	--return self
end


--
-- Utility Functions
--

function EffigyBar.CopyBar(from, to)
    local from_bar = Addon.Bars[from]
    local to_bar = Addon.Bars[to]

    if ((nil == from_bar)or(nil == to_bar)) then return end

    local name = to_bar.name
    to_bar:destroy()

    to_bar = EffigyBar:new_from_bar(name, from_bar)

    EffigyBar.Init(to_bar.name)

    to_bar:setup()
    to_bar:render()

    return to_bar
end

function EffigyBar.LoadTemplate(template, to)
    local from_bar = Addon.BarTemplates[template]
    if (nil == from_bar) then -- try in the included templates too
		from_bar = UFTemplates.Bars[template]
    end
    local to_bar = Addon.Bars[to]

    if ((nil == from_bar)or(nil == to_bar)) then
        return
    end

    local name = to_bar.name
    to_bar:destroy()

    to_bar = EffigyBar:new_from_bar(name, from_bar)

    EffigyBar.Init(to_bar.name)

    --to_bar:useState("default")

    to_bar:setup()
    to_bar:render()

    return to_bar

end

function EffigyBar:destroy()
    -- remove our main state
    if nil ~= Addon.States[self.state] then
		Addon.States[self.state]:unregisterBar(self)
	end
	
    -- Remove any states we are watching
    for _, name in ipairs(self.watching_states) do
        Addon.States[name]:unregisterBar(self)
    end
	
	for k,_ in pairs(self.labels) do
		UF_RUNTIMECACHE[self.name].Labels[k]:Destroy()
	end
	for k,_ in pairs(self.images) do
		UF_RUNTIMECACHE[self.name].Images[k]:Destroy()
	end
	UF_RUNTIMECACHE[self.name] = nil
    Addon.Bars[self.name] = nil
    DestroyWindow(self.name)
    LayoutEditor.UnregisterWindow(self.name)

    return nil
end

--------------------------------------
-- 
--------------------------------------

function Addon.GetBar(name)
    return Addon.Bars[name]
end

function Addon.CreateBar(name, source)
    if (nil == name)or(L"" == name) then return end
	local new_bar = nil
	
	if nil == source then
		new_bar = EffigyBar:new(name)
	elseif type(source) == "table" then
		new_bar = EffigyBar:new_from_bar(name, source)
	else
		new_bar = EffigyBar:new_from_bar(name, Addon.Bars[source])
	end

    if (nil == new_bar) then
        Addon.Print(L"Could not create bar!")
        return
    end
	
	EffigyBar.Init(name)

	--new_bar:setup()
	--new_bar:render()
	
    return new_bar
end

function Addon.DestroyBar(name)
    local self = Addon.Bars[name]

    if (nil ~= self) then
        self:destroy()
    end
end

-- elementType: "Images", "Labels"
function Addon.DestroyBarElement(barname, elementType, elementName)
	UF_RUNTIMECACHE[barname][elementType][elementName]:Destroy()
	UF_RUNTIMECACHE[barname][elementType][elementName] = nil
end

function Addon.DumpBar(name)
    local self = Addon.Bars[name]

    if (nil ~= self) then
        DUMP_TABLE(self)
        DUMP_TABLE_TO(self, EA_ChatWindow.Print)
    end
end
