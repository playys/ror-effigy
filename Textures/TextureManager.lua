
-- vim: sw=2 ts=2
if not Effigy then Effigy = {} end
local Addon = Effigy


Addon.texture_list_local = {
	["XPerl_StatusBar"] = { scale = 1, width=256, height=32 },
	["XPerl_StatusBar2"] = { scale = 1, width=256, height=32 },
	["XPerl_StatusBar3"] = { scale = 1, width=256, height=32 },
	["XPerl_StatusBar4"] = { scale = 1, width=64, height=64 },
	["XPerl_StatusBar5"] = { scale = 1, width=512, height=64 },
	["XPerl_StatusBar6"] = { scale = 1, width=256, height=32 },
	["XPerl_StatusBar7"] = { scale = 1, width=512, height=64 },
	["XPerl_StatusBar8"] = { scale = 1, width=256, height=32 },
	["XPerl_StatusBar9"] = { scale = 1, width=256, height=32 },
	["XPerl_StatusBar10"] = { scale = 1, width=256, height=32 }, 
	["Statusbar1"] = { scale = 1, width=256, height=32 }, 
	["Gloss"] = { scale = 1, width=64, height=64 }, 
	["Statusbar"] = { scale = 1, width=16, height=128 }, 
	["rothTex"] = { scale = 1, width=16, height=16 }, 
	["Statusbar2"] = { scale = 1, width=256, height=32 },
	
	["LiquidUFBG"] = { scale = 1, width=512, height=128 }, 
	["LiquidUFFX"] = { scale = 1, width=512, height=128 }, 
	["LiquidBar"] = { scale = 1, width=256, height=32 },
	["LiquidCBBarEnd"] = { scale = 1, width=20, height=25 },
	["LiquidCBBar"] = { scale = 1, width=211, height=10 },
	["LiquidCBBG"] = { scale = 1, width=225, height=20 },
	["LiquidCBFX"] = { scale = 1, width=225, height=20 },
	["LiquidIPBG"] = { scale = 1, width=600, height=70 },
	["LiquidIPFX"] = { scale = 1, width=600, height=70 },
	
	["GroupIcon Gloss"] = { scale = 1, width=50, height=50 }, 
	["GroupIcon Shape"] = { scale = 1, width=50, height=50 }, 
	
	["tint_square"] = { },
}

Addon.texture_list = Addon.texture_list_local

local LibSA = LibStub("LibSharedAssets")
Addon.TextureManager = {}

function Addon.TextureManager.GetTextureList()
	local tex = {}
	
	for k,v in pairs(Addon.texture_list_local) do tex[k]=v end
	
	a= LibSA:GetTextureList()
	for k,v in pairs (a)
	do
		local meta = LibSA:GetMetadata(v)
		
		tex[v] = {scale=1, width=meta.size[1], height=meta.size[2]}
	end
	return tex;
end

function  Addon.TextureManager.BuildTextureList()
	Addon.texture_list = Addon.TextureManager.GetTextureList()
end

function Addon.TextureManager.SetTextureFill(win_name,t, width, height, perc, direction, type )
	if (not Addon.texture_list[t] or not Addon.texture_list[t].width or not Addon.texture_list[t].height)
	then
		return nil
	end

	if (direction == "right")
	then
		if (type and type == "grow")
		then
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width - Addon.texture_list[t].width * perc,
				Addon.texture_list[t].height)
		else
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width,
				Addon.texture_list[t].height)
		end
		DynamicImageSetTextureDimensions(win_name, perc * Addon.texture_list[t].width , Addon.texture_list[t].height)
	elseif (direction == "left") 
	then
		if (type and type == "grow")
		then
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width,
				Addon.texture_list[t].height)
		else
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width - Addon.texture_list[t].width * perc,
				Addon.texture_list[t].height)	
		end
		DynamicImageSetTextureDimensions(win_name, perc * Addon.texture_list[t].width , Addon.texture_list[t].height)
	elseif (direction == "down") 
	then
		if (type and type == "grow")
		then
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width,
				Addon.texture_list[t].height - Addon.texture_list[t].height * perc)
		else
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width,
				Addon.texture_list[t].height)
		end
		DynamicImageSetTextureDimensions(win_name, Addon.texture_list[t].width , Addon.texture_list[t].height * perc )
	elseif (direction == "up") 
	then
		if (type and type == "grow")
		then
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width,
				Addon.texture_list[t].height)
		else
			DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].width,
				Addon.texture_list[t].height - Addon.texture_list[t].height * perc)	
		end
		DynamicImageSetTextureDimensions(win_name, Addon.texture_list[t].width , Addon.texture_list[t].height * perc )
	end
end

function Addon.TextureManager.SetTexture(win_name, t)
	if (nil == Addon.texture_list[t]) then t = "tint_square" end

	if (nil ~= Addon.texture_list[t].real_texture) then
		DynamicImageSetTexture(win_name, Addon.texture_list[t].real_texture, 0, 0)
	else
		DynamicImageSetTexture(win_name, t, 
				Addon.texture_list[t].x or 0,
				Addon.texture_list[t].y or 0)
	end

	if (nil ~= Addon.texture_list[t].scale) then
		DynamicImageSetTextureScale(win_name, Addon.texture_list[t].scale)
	end

	if (nil ~= Addon.texture_list[t].width)and(nil ~= Addon.texture_list[t].height) then
		DynamicImageSetTextureDimensions(win_name, 
				Addon.texture_list[t].width, Addon.texture_list[t].height)
	end

	if (nil ~= Addon.texture_list[t].slice) then
		DynamicImageSetTextureSlice(win_name, Addon.texture_list[t].slice)
	end

end
