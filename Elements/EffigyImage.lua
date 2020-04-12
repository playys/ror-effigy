if not Effigy then Effigy = {} end
local Addon = Effigy
Addon.Image = {}

local LibGUI = LibStub("LibGUI")

local ipairs = ipairs
local type = type
local wstring_sub = wstring.sub
local wstring_upper = wstring.upper
local wstring_lower = wstring.lower

local function Setup(self)
	local container = self.Container
	local containerName = container.name
	local settings = self.Settings
	--
	-- WINDOW attributes
	--
	if settings.parent == nil or settings.parent == "" then
		self:Parent(containerName) -- this will stay unconfigurable for a while
	else
		self:Parent(container:GetFrameNameFromCBoxString(settings.parent))
	end
	self:Layer(settings.layer)
	local anchor1settings = settings.anchors[1]
	if ((anchor1settings.x ~= nil) and (anchor1settings.y ~= nil)) then
		self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, anchor1settings.x, anchor1settings.y)
	else
		self:AnchorTo(container:GetFrameNameFromCBoxString(anchor1settings.parent), anchor1settings.parentpoint, anchor1settings.point, 0, 0)
	end
	if settings.anchors[2] then
		self:AddAnchor(container:GetFrameNameFromCBoxString(settings.anchors[2].parent), settings.anchors[2].parentpoint, settings.anchors[2].point, settings.anchors[2].x, settings.anchors[2].y)
	else
		self:Resize(settings.width, settings.height)
		if (settings.scale ~= nil) then
			-- this is ugly
			if settings.parent == "Bar" or settings.parent == "Bar Fill" or settings.parent == "Bar BG" 
			or DoesWindowExist(containerName..container:GetFrameNameFromCBoxString(settings.parent)) then
				self:Scale(WindowGetScale(containerName) * settings.scale)	-- DONOTTOUCH
			else
				self:Scale(WindowGetScale(containerName) * settings.scale)	-- DONOTTOUCH
			end
		end
	end
	
	--self:Popable(settings.Popable)
	self:Alpha(settings.alpha)

	--
	-- IMAGE attributes
	--
	
	-- does it make a difference if we tint the window or the image?
	if settings.colorsettings.ColorPreset ~= nil and settings.colorsettings.ColorPreset ~= "" and settings.colorsettings.ColorPreset ~= "none" then
		local ColorPreset = RVMOD_GColorPresets.GetColorPreset(settings.colorsettings.ColorPreset)
		self.Image:Tint(ColorPreset.r, ColorPreset.g, ColorPreset.b)
	else
		self.Image:Tint(settings.colorsettings.color.r, settings.colorsettings.color.g, settings.colorsettings.color.b)
	end

	--self.Image:Rotate(angle)			-- image		
	--self.Image:Texture(texture, x, y)
	self.Image:Texture(settings.texture.name)
	--self.Image:TexSlice(settings.texture.slice)
	if settings.texture.width == 0 and settings.texture.height == 0 then
		self.Image:TexDims(Addon.texture_list[settings.texture.name].width, Addon.texture_list[settings.texture.name].height)
	else
		self.Image:TexDims(settings.texture.width, settings.texture.height)
	end
	self.Image:TexScale(settings.texture.scale)
	--self.Image:TexFlip(settings.texture.flipped)
	
	if (true == settings.show) then self:Show() else self:Hide() end
end

local function Render(self)
	local container = self.Container
	-- change this for visibility push updates from other addons
	--[[if container:getRenderVisibility(settings, state) == true then
		local w = UF_RUNTIMECACHE[containerName].Images[k]
		self:Texture(container:getRenderTexture(settings, state))
		self:Tint(container:getRenderColor(settings, state))
		self:Show()
	else
		UF_RUNTIMECACHE[containerName].Images[k]:Hide()
	end]]--
	local settings = self.Settings
	local state = Effigy.States[container.state]
	local i = self.Image
	i:Texture(container:getRenderTexture(settings, state))
	local r,g,b = container:getRenderColor(settings.colorsettings, state)
	-- external push updates for tint support
	--if (self.Color.r ~= r) or (self.Color.g ~= g) or (self.Color.b ~= b) then
		i:Tint(r,g,b)
	--	self.Color.r, self.Color.g, self.Color.b = r,g,b
	--end
	local dynamicAlpha = container:getRenderAlpha(settings, state)
	if dynamicAlpha ~= nil then	self:Alpha(dynamicAlpha) end
	local dynamicVisibility = container:getRenderVisibility(settings, state)
	if dynamicVisibility ~= nil then
		if dynamicVisibility == true then	
			self:Show()
		else
			self:Hide()
		end
	end
end

function Effigy.Image.Create(bar, name)
	if not UF_RUNTIMECACHE[bar.name].Images then UF_RUNTIMECACHE[bar.name].Images = {} end
	local w = UF_RUNTIMECACHE[bar.name].Images[name]
	if w then return w end	-- element already exists
	
	-- we need to encapsulate the element in a window for proper scaling
	w = LibGUI("window", bar.name.."Image"..name, "EffigyEmpty")
	w.Image = w:Add("image", w.name.."Image")
	--w.Image:Parent(w)
	w.Image:AnchorTo(w, "topleft", "topleft", 0, 0)
	w.Image:AddAnchor(w, "bottomright", "bottomright", 0, 0)
	
	w:IgnoreInput()
	w.Image:IgnoreInput()
	
	w.Container = bar
	w.Settings = bar.images[name] --or Effigy.GetDefaultImage()
	
	w.Setup = Setup
	w.Render = Render
	
	return w
end
