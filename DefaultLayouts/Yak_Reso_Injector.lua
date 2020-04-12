if not Effigy then Effigy = {} end
local Addon = Effigy

-- background image rgb 32->24
local function Apply_1280_1024_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" then bar.scale = 0.8 end -- note: Castbar change too
	end
	
	bars.Pet.anchors[1].x = -275
	bars.Pet.anchors[1].y = 340
	bars.HostileTarget.anchors[1].y = 120
	bars.HostileTarget.anchors[1].x = 275
	bars.HostileTarget.labels.Name.clip_after = 12
	--[[bars.HostileTarget.labels.Name.anchors[1].y = 3
	bars.HostileTarget.labels.Value.anchors[1].y = 2
	bars.HostileTarget.labels.Level.anchors[1].y = 2
	bars.HostileTarget.labels.Range.anchors[1].y = 7]]--
	bars.PlayerHP.anchors[1].y = 120
	bars.PlayerHP.anchors[1].x = -275
	--bars.PlayerHP.labels.Value.anchors[1].y = 16
	--bars.PlayerHP.labels.Level.anchors[1].y = 16
	bars.PlayerHP.labels.Name.clip_after = 12
	--bars.Castbar.images.Foreground.anchors[1].y = -6
	bars.Castbar.images.CBEnd.height = 20
	bars.Castbar.images.CBEnd.anchors[1].y = 1
	bars.Castbar.anchors[1].y = -332
	bars.Castbar.anchors[1].x = -2
	bars.FriendlyTarget.anchors[1].x = 275
	bars.FriendlyTarget.labels.Name.clip_after = 12
	--[[bars.FriendlyTarget.labels.Name.anchors[1].y = 3
	bars.FriendlyTarget.labels.Value.anchors[1].y = 2
	bars.FriendlyTarget.labels.Level.anchors[1].y = 2
	bars.FriendlyTarget.labels.Range.anchors[1].y = 7]]--
	
	bars.GroupMember1.anchors[1].y = 100
	bars.GroupMember2.anchors[1].y = 250
	bars.GroupMember3.anchors[1].y = -385
	bars.GroupMember4.anchors[1].y = -235
	bars.GroupMember5.anchors[1].y = -85	
	for i = 1,5 do
		if i >= 3 then
			bars["GroupMember"..i].anchors[1].point = "left"
			bars["GroupMember"..i].anchors[1].parentpoint = "left"
		end
		bars["GroupMember"..i].labels.Value.anchors[1].x = 0
		bars["GroupMember"..i].labels.Value.width = 50
		--bars["GroupMember"..i].labels.Value.anchors[1].y = 18
		bars["GroupMember"..i].labels.Value.anchors[1].point = "bottomright"
		bars["GroupMember"..i].labels.Name.clip_after = 9
		--bars["GroupMember"..i].icon.anchors[1].y = bars["GroupMember"..i].icon.anchors[1].y + 1
	end
	bars.PlayerHP.icon.anchors[1].y = bars.PlayerHP.icon.anchors[1].y + 1
	bars.FriendlyTarget.icon.anchors[1].y = bars.FriendlyTarget.icon.anchors[1].y + 1
	bars.HostileTarget.icon.anchors[1].y = bars.HostileTarget.icon.anchors[1].y + 1
	bars.Pet.icon.anchors[1].y = bars.Pet.icon.anchors[1].y + 1
end

local function Apply_1440_900_075_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" then bar.scale = 0.8 end -- note: Castbar change too
	end	
	bars.Pet.anchors[1].y = 270
	bars.Pet.anchors[1].x = -320
	bars.HostileTarget.anchors[1].y = 0
	bars.HostileTarget.anchors[1].x = 320
	bars.HostileTarget.labels.Name.clip_after = 12
	bars.HostileTarget.labels.Name.anchors[1].y = 3
	bars.HostileTarget.labels.Value.anchors[1].y = 2
	bars.HostileTarget.labels.Level.anchors[1].y = 2
	bars.HostileTarget.labels.Range.anchors[1].y = 7
	bars.PlayerHP.border.padding.bottom = 1
	bars.PlayerHP.anchors[1].x = -320
	bars.PlayerHP.anchors[1].y = 0
	bars.PlayerHP.labels.Value.anchors[1].y = 15
	bars.PlayerHP.labels.Level.anchors[1].y = 15
	bars.PlayerHP.labels.Name.clip_after = 12
	bars.PlayerHP.labels.Name.anchors[1].y = 17
	--bars.Castbar.images.Foreground.anchors[1].y = -6
	bars.Castbar.images.CBEnd.height = 20
	bars.Castbar.images.CBEnd.anchors[1].y = 1
	bars.Castbar.anchors[1].y = -314
	bars.Castbar.anchors[1].x = -200
	bars.FriendlyTarget.anchors[1].y = 270
	bars.FriendlyTarget.anchors[1].x = 320
	bars.FriendlyTarget.labels.Name.clip_after = 12
	bars.FriendlyTarget.labels.Name.anchors[1].y = 3
	bars.FriendlyTarget.labels.Value.anchors[1].y = 2
	bars.FriendlyTarget.labels.Level.anchors[1].y = 2
	bars.FriendlyTarget.labels.Range.anchors[1].y = 7
	
	bars.GroupMember1.anchors[1].y = 100
	bars.GroupMember2.anchors[1].y = 250
	bars.GroupMember3.anchors[1].y = -383
	bars.GroupMember4.anchors[1].y = -233
	bars.GroupMember5.anchors[1].y = -83	
	for i = 1,5 do
		if i >= 3 then
			bars["GroupMember"..i].anchors[1].point = "left"
			bars["GroupMember"..i].anchors[1].parentpoint = "left"
		end
		bars["GroupMember"..i].labels.Value.anchors[1].x = 0
		bars["GroupMember"..i].labels.Value.width = 50
		bars["GroupMember"..i].labels.Value.anchors[1].y = 18
		bars["GroupMember"..i].labels.Value.anchors[1].point = "bottomright"
		bars["GroupMember"..i].labels.Name.clip_after = 7
	end
end

local function Apply_1600_900_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" and k ~= "Castbar" then bar.scale = 0.9 end
	end

	bars.Pet.anchors[1].x = -400
	bars.Pet.anchors[1].y = 300
	bars.HostileTarget.anchors[1].y = 30
	bars.HostileTarget.anchors[1].x = 400
	bars.PlayerHP.anchors[1].y = 30
	bars.PlayerHP.anchors[1].x = -400
	bars.FriendlyTarget.anchors[1].y = 300
	bars.FriendlyTarget.anchors[1].x = 400
	bars.Castbar.anchors[1].y = -333
	bars.Castbar.anchors[1].x = -231
end

local function Apply_1600_1200_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" and k ~= "Castbar" then bar.scale = 0.9 end
	end

	bars.Pet.anchors[1].y = 350
	bars.Castbar.anchors[1].y = -304
	bars.FriendlyTarget.anchors[1].y = 350
end

local function Apply_1680_1050_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" and k ~= "Castbar" then bar.scale = 0.9 end
	end
	bars.Pet.anchors[1].y = 300
	bars.HostileTarget.anchors[1].y = 30
	bars.PlayerHP.anchors[1].y = 30
	bars.Castbar.anchors[1].x = -221
	bars.Castbar.anchors[1].y = -343
	bars.FriendlyTarget.anchors[1].y = 300
end

local function Apply_1920_1080_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" and k ~= "Castbar" then bar.scale = 0.9 end
	end
	--diff:
	bars.FriendlyTarget.anchors[1].y = 280
	bars.Pet.anchors[1].y = 280
	bars.HostileTarget.anchors[1].y = 30
	bars.PlayerHP.anchors[1].y = 30
	bars.Castbar.anchors[1].y = -328
	
	--[[for i = 1,5 do
		bars["GroupMember"..i].icon.anchors[1].x = bars["GroupMember"..i].icon.anchors[1].x + 2 -- Yak_140
	end
	bars.HostileTarget.icon.anchors[1].x = bars.HostileTarget.icon.anchors[1].x + 2
	bars.FriendlyTarget.icon.anchors[1].x = bars.FriendlyTarget.icon.anchors[1].x + 2]]--
end

--
-- 1.0
--
local function Apply_1360_768_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" then bar.scale = 0.8 end -- note: Castbar change too
	end
	
	bars.HostileTarget.anchors[1].y = 0
	bars.HostileTarget.anchors[1].x = 320
	bars.HostileTarget.labels.Name.clip_after = 12
	--[[bars.HostileTarget.labels.Name.anchors[1].x = 56
	bars.HostileTarget.labels.Name.anchors[1].y = 3
	bars.HostileTarget.labels.Value.anchors[1].y = 2
	bars.HostileTarget.labels.Level.anchors[1].y = 2
	bars.HostileTarget.labels.Range.anchors[1].y = 7
	bars.PlayerHP.border.padding.bottom = 1]]--
	bars.PlayerHP.anchors[1].y = 0
	bars.PlayerHP.anchors[1].x = -320
	--bars.PlayerHP.labels.Value.anchors[1].y = 15
	--bars.PlayerHP.labels.Level.anchors[1].y = 15
	bars.PlayerHP.labels.Name.clip_after = 12
	--bars.PlayerHP.labels.Name.anchors[1].x = 56
	--bars.PlayerHP.labels.Name.anchors[1].y = 17
	bars.FriendlyTarget.anchors[1].y = 200
	bars.FriendlyTarget.anchors[1].x = 320
	bars.FriendlyTarget.labels.Name.clip_after = 12
	--[[bars.FriendlyTarget.labels.Name.anchors[1].x = 56
	bars.FriendlyTarget.labels.Name.anchors[1].y = 3
	bars.FriendlyTarget.labels.Value.anchors[1].y = 2
	bars.FriendlyTarget.labels.Level.anchors[1].y = 2
	bars.FriendlyTarget.labels.Range.anchors[1].y = 7]]--
	bars.Pet.anchors[1].x = -320
	bars.Pet.anchors[1].y = 200
	--bars.Pet.labels.Name.anchors[1].x = 56
	--bars.Castbar.images.Foreground.anchors[1].y = -6
	bars.Castbar.images.CBEnd.height = 20
	bars.Castbar.images.CBEnd.anchors[1].y = 1
	bars.Castbar.anchors[1].y = -273
	bars.Castbar.anchors[1].x = -133
	--bars.PlayerCareer.anchors[1].y = 2
	
	bars.GroupMember1.anchors[1].x = 10
	bars.GroupMember2.anchors[1].x = 230
	bars.GroupMember3.anchors[1].x = 450
	bars.GroupMember4.anchors[1].point = "top"
	bars.GroupMember4.anchors[1].parentpoint = "top"
	bars.GroupMember4.anchors[1].x = -293
	bars.GroupMember5.anchors[1].point = "top"
	bars.GroupMember5.anchors[1].parentpoint = "top"
	bars.GroupMember5.anchors[1].x = -73

	for i = 1,5 do
		bars["GroupMember"..i].anchors[1].y = 10
		--[[bars["GroupMember"..i].labels.Name.anchors[1].x = 56
		bars["GroupMember"..i].labels.Value.anchors[1].x = 0
		bars["GroupMember"..i].labels.Value.width = 50
		bars["GroupMember"..i].labels.Value.anchors[1].y = 18
		bars["GroupMember"..i].labels.Value.anchors[1].point = "bottomright"]]--
		bars["GroupMember"..i].labels.Name.clip_after = 7
	end
end

local function Apply_1440_900_1_to_YakUI()
	local bars = Addon.Bars
	for barname, bar in pairs(bars) do
		if k ~= "InfoPanel" then bar.scale = 0.8 end -- note: Castbar change too
	end
	bars.HostileTarget.anchors[1].y = 0
	bars.HostileTarget.anchors[1].x = 280
	bars.HostileTarget.labels.Name.clip_after = 12
	--[[bars.HostileTarget.labels.Name.anchors[1].x = 56
	bars.HostileTarget.labels.Name.anchors[1].y = 3
	bars.HostileTarget.labels.Value.anchors[1].y = 2
	bars.HostileTarget.labels.Level.anchors[1].y = 2
	bars.HostileTarget.labels.Range.anchors[1].y = 7
	bars.PlayerHP.border.padding.bottom = 1]]--
	bars.PlayerHP.anchors[1].y = 0
	bars.PlayerHP.anchors[1].x = -280
	--bars.PlayerHP.labels.Value.anchors[1].y = 15
	--bars.PlayerHP.labels.Level.anchors[1].y = 15
	bars.PlayerHP.labels.Name.clip_after = 12
	--bars.PlayerHP.labels.Name.anchors[1].x = 56
	--bars.PlayerHP.labels.Name.anchors[1].y = 17
	bars.FriendlyTarget.anchors[1].y = 200
	bars.FriendlyTarget.anchors[1].x = 280
	bars.FriendlyTarget.labels.Name.clip_after = 12
	--[[bars.FriendlyTarget.labels.Name.anchors[1].x = 56
	bars.FriendlyTarget.labels.Name.anchors[1].y = 3
	bars.FriendlyTarget.labels.Value.anchors[1].y = 2
	bars.FriendlyTarget.labels.Level.anchors[1].y = 2
	bars.FriendlyTarget.labels.Range.anchors[1].y = 7]]--
	bars.Pet.anchors[1].y = 200
	bars.Pet.anchors[1].x = -280
	--bars.Pet.labels.Name.anchors[1].x = 56
	--bars.PlayerCareer.anchors[1].y = 2
	--bars.Castbar.images.Foreground.anchors[1].y = -6
	bars.Castbar.images.CBEnd.height = 20
	bars.Castbar.images.CBEnd.anchors[1].y = 1
	bars.Castbar.anchors[1].point = "center"
	bars.Castbar.anchors[1].parentpoint = "center"
	bars.Castbar.anchors[1].y = 278
	bars.Castbar.anchors[1].x = 1	
	bars.GroupMember1.anchors[1].x = 10
	bars.GroupMember2.anchors[1].x = 210
	bars.GroupMember3.anchors[1].x = 410
	bars.GroupMember4.anchors[1].point = "top"
	bars.GroupMember4.anchors[1].parentpoint = "top"
	bars.GroupMember4.anchors[1].x = -265
	bars.GroupMember5.anchors[1].point = "top"
	bars.GroupMember5.anchors[1].parentpoint = "top"
	bars.GroupMember5.anchors[1].x = -65
	
	for i = 1,5 do
		bars["GroupMember"..i].anchors[1].y = 10
		--[[bars["GroupMember"..i].labels.Name.anchors[1].x = 56
		bars["GroupMember"..i].labels.Value.anchors[1].x = 0
		bars["GroupMember"..i].labels.Value.width = 50
		bars["GroupMember"..i].labels.Value.anchors[1].y = 18
		bars["GroupMember"..i].labels.Value.anchors[1].point = "bottomright"]]--
		bars["GroupMember"..i].labels.Name.clip_after = 7
	end
end

function Addon.ApplyResoToYakUI(resolution, scale)
	if resolution then resolution = towstring(resolution) end
	if scale then scale = towstring(scale) end
	d(resolution,scale)
	if (scale == L"0.75") and (resolution == L"1920x1200") then
		-- is default
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"0.75") and (resolution == L"1920x1080") then
		Apply_1920_1080_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"0.75") and (resolution == L"1680x1050") then
		Apply_1680_1050_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"0.75") and (resolution == L"1440x900") then
		Apply_1440_900_075_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"1.00") and (resolution == L"1440x900") then
		Apply_1440_900_1_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"0.75") and (resolution == L"1600x1200") then
		Apply_1600_1200_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"1.00") and (resolution == L"1360x768") then
		Apply_1360_768_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"0.75") and (resolution == L"1280x1024") then
		Apply_1280_1024_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	elseif (scale == L"0.75") and (resolution == L"1600x900") then
		Apply_1600_900_to_YakUI()
		EA_ChatWindow.Print(L"Resolution/Scale applied.")
	else
		EA_ChatWindow.Print(L"Unsupporeted Resolution/Scale.")
	end
end