if not Effigy then Effigy = {} end
local Addon = Effigy
if (nil == Addon.Name) then Addon.Name = "Effigy" end

local savedVarsVersion = 2.66

local function round(number, decimals)
	decimals = decimals or 0
	return tonumber(("%."..decimals.."f"):format(number))
end
			
function Addon.UpdateVersion()
	--[[for _,b in pairs(Addon.Bars) do
		local width = b.width - (b.border.padding.left + b.border.padding.right)
		local height = b.height - (b.border.padding.top + b.border.padding.bottom)
		local size = width
		if (height < width) then size = height end
		
		-- Setup the icon size
		local scale = size / 32 
		--b.icon.scale = b.icon.scale * scale / b.scale
		if b.name == "InfoPanel" then
			EA_ChatWindow.Print(towstring(b.name..": "..round((0.5 * scale / b.scale), 2)))
		elseif b.name == "Pet" then
			EA_ChatWindow.Print(towstring(b.name..": "..round((0.6 * scale / b.scale), 2)))
		elseif b.name == "WorldGroupMember1" then
			EA_ChatWindow.Print(towstring(b.name..": "..round((0.8 * scale / b.scale), 2)))
		elseif not(b.name == "PlayerAP" or b.name == "PlayerCareer" or b.name == "GroupMember2" or b.name == "GroupMember3" or b.name == "GroupMember4" or b.name == "GroupMember5"
		or b.name == "WorldGroupMember2" or b.name == "WorldGroupMember3" or b.name == "WorldGroupMember4" or b.name == "WorldGroupMember5"
		or b.name == "TargetsFriendly2" or b.name == "TargetsFriendly3" or b.name == "TargetsFriendly4" or b.name == "TargetsFriendly5" or b.name == "TargetsHostile2" or b.name == "TargetsHostile3"
		or b.name == "TargetsHostile4" or b.name == "TargetsHostile5") then
			EA_ChatWindow.Print(towstring(b.name)..L": "..round((b.icon.scale * scale / b.scale), 2))
		end
	end]]--
	if Addon.SavedVarsVersion and Addon.SavedVarsVersion < savedVarsVersion then
		if Addon.SavedVarsVersion < 2.6 then
			for _,v in pairs(Addon.RuleTypes) do
				local rules = Addon.Rules[v].Rules
				for k,rule in pairs(rules) do
					if rule.filter == "IsNPC" then
						Addon.Rules[v].Rules[k].filter = "isNPC"
					elseif rule.filter == "IsPVP" then
						Addon.Rules[v].Rules[k].filter = "isRVRFlagged"
					elseif rule.filter == "IsDistant" then
						Addon.Rules[v].Rules[k].filter = "isDistant"
					elseif rule.filter == "IsInSameRegion" then
						Addon.Rules[v].Rules[k].filter = "isInSameRegion"
					elseif rule.filter == "IsGroupLeader" then
						Addon.Rules[v].Rules[k].filter = "isGroupLeader"
					elseif rule.filter == "IsAssistant" then
						Addon.Rules[v].Rules[k].filter = "isAssistant"
					elseif rule.filter == "IsMainAssist" then
						Addon.Rules[v].Rules[k].filter = "isMainAssist"
					elseif rule.filter == "IsMasterLooter" then
						Addon.Rules[v].Rules[k].filter = "isMasterLooter"
					elseif rule.filter == "IsSelf" then
						Addon.Rules[v].Rules[k].filter = "isSelf"
					elseif rule.filter == "IsGroupMember" then
						--Addon.Rules[v].Rules[k].filter = 
					elseif rule.filter == "IsScenarioGroupMember" then
						--Addon.Rules[v].Rules[k].filter = 
					elseif rule.filter == "IsWarbandMember" then
						--Addon.Rules[v].Rules[k].filter = 
					elseif rule.filter == "IsTargeted" then
						Addon.Rules[v].Rules[k].filter = "isTargeted"
					elseif rule.filter == "IsMouseOvered" then
						Addon.Rules[v].Rules[k].filter = "isMouseOvered"
						
					elseif rule.filter == "EntityType" then
						Addon.Rules[v].Rules[k].filter = "type"
					elseif rule.filter == "CareerLine" then
						Addon.Rules[v].Rules[k].filter = "careerLine"
					elseif rule.filter == "Level" then
						Addon.Rules[v].Rules[k].filter = "level"
					elseif rule.filter == "Tier" then
						Addon.Rules[v].Rules[k].filter = "tier"
					elseif rule.filter == "DifficultyMask" then
						Addon.Rules[v].Rules[k].filter = "difficultyMask"
					elseif rule.filter == "HitPointPercent" then
						Addon.Rules[v].Rules[k].filter = "healthPercent"
					elseif rule.filter == "ActionPointPercent" then
						Addon.Rules[v].Rules[k].filter = "actionPointPercent"
					elseif rule.filter == "MoraleLevel" then
						Addon.Rules[v].Rules[k].filter = "moraleLevel"
					elseif rule.filter == "ZoneNumber" then
						Addon.Rules[v].Rules[k].filter = "zoneNum"
					elseif rule.filter == "ConType" then
						Addon.Rules[v].Rules[k].filter = "conType"
					elseif rule.filter == "MapPinType" then
						Addon.Rules[v].Rules[k].filter = "mapPinType"
					elseif rule.filter == "SigilEntryId" then
						Addon.Rules[v].Rules[k].filter = "sigilEntryId"
					elseif rule.filter == "GroupIndex" then
						Addon.Rules[v].Rules[k].filter = "groupIndex"
					elseif rule.filter == "MemberIndex" then
						Addon.Rules[v].Rules[k].filter = "memberIndex"
					
					elseif rule.filter == "Name" then
						Addon.Rules[v].Rules[k].filter = "name"
					elseif rule.filter == "Title" then
						Addon.Rules[v].Rules[k].filter = "title"
					elseif rule.filter == "CareerName" then
						Addon.Rules[v].Rules[k].filter = "careerName"
					end
				end
			end
		end
		if Addon.SavedVarsVersion < 2.61 then
			local remap = {
				["grp1hp"] = "grp2hp",
				["grp2hp"] = "grp3hp",
				["grp3hp"] = "grp4hp",
				["grp4hp"] = "grp5hp",
				["grp5hp"] = "grp6hp",
				["grp1ap"] = "grp2ap",
				["grp2ap"] = "grp3ap",
				["grp3ap"] = "grp4ap",
				["grp4ap"] = "grp5ap",
				["grp5ap"] = "grp6ap",
				["grp1morale"] = "grp2morale",
				["grp2morale"] = "grp3morale",
				["grp3morale"] = "grp4morale",
				["grp4morale"] = "grp5morale",
				["grp5morale"] = "grp6morale",
			}
			for _,b in pairs(Addon.Bars) do
				local state = b.state
				if remap[state] then b.state = remap[state] end
			end
		end
		if Addon.SavedVarsVersion < 2.62 then
			local bars = Addon.Bars
			for _,b in pairs(bars) do
				local width = b.width - (b.border.padding.left + b.border.padding.right)
				local height = b.height - (b.border.padding.top + b.border.padding.bottom)
			    local size = width
				if (height < width) then size = height end				
				-- Setup the icon size
				local scale = size / 32 
				b.icon.scale = round((b.icon.scale * scale / b.scale), 2)
				
				if b.fg.texture.name == "SharedMediaYSet5UFBar" then
					b.fg.texture.name = "LiquidBar"
				end
				if b.images.Foreground and b.images.Foreground.texture.name == "SharedMediaYSet5UFFX" then
					b.images.Foreground.texture.name = "LiquidUFFX"
				end
				if b.images.Background and b.images.Background.texture.name == "SharedMediaYSet5UFBG" then
					b.images.Background.texture.name = "LiquidUFBG"
				end
				-- scaling for image, labels (2.6+ bar scale influences child scale)
				for name, image in pairs(b.images) do
					image.scale = image.scale / b.scale
				end
				for name, label in pairs(b.labels) do
					label.scale = label.scale / b.scale
				end
			end
			if bars.InfoPanel and bars.InfoPanel.images.Foreground.texture.name == "SharedMediaYSet5IPFX" then
				bars.InfoPanel.images.Foreground.texture.name = "LiquidIPFX"
			end
			if bars.InfoPanel and bars.InfoPanel.images.Background.texture.name == "SharedMediaYSet5IPBG" then
				bars.InfoPanel.images.Background.texture.name = "LiquidIPBG"
			end
			if bars.Castbar and bars.Castbar.images.Foreground and bars.Castbar.images.Foreground.texture.name == "SharedMediaYSet5CBFX" then
				bars.Castbar.images.Foreground.texture.name = "LiquidCBFX"
			end
			if bars.Castbar and bars.Castbar.images.Background and bars.Castbar.images.Background.texture.name == "SharedMediaYSet5CBBG" then
				bars.Castbar.images.Background.texture.name = "LiquidCBBG"
			end
			if bars.Castbar and bars.Castbar.images.CBEnd and bars.Castbar.images.CBEnd.texture.name == "SharedMediaYSet5CBBarEnd" then
				bars.Castbar.images.CBEnd.texture.name = "LiquidCBBarEnd"
			end
			if bars.Castbar and bars.Castbar.fg.texture.name == "SharedMediaYSet5CBBar" then
				bars.Castbar.fg.texture.name = "LiquidCBBar"
			end
			if bars.Castbar and bars.Castbar.bg.texture.name == "SharedMediaYCastbarBG" then
				bars.Castbar.bg.texture.name = "tint_square"
			end
			if bars.Castbar and bars.Castbar.border.texture.name == "SharedMediaYCastbarBG" then
				bars.Castbar.border.texture.name = "tint_square"
			end
			if bars.Pet and bars.PlayerHP and bars.HostileTarget and bars.FriendlyTarget then
				if bars.Pet.icon.pos_y == 3 then
					bars.Pet.icon.pos_y = 1
				end
				if bars.PlayerHP.icon.pos_y == 17 then
					bars.PlayerHP.icon.pos_y = 15
				end
				if bars.HostileTarget.icon.pos_y == 3 then
					bars.HostileTarget.icon.pos_y = 1
				end
				if bars.FriendlyTarget.icon.pos_y == 3 then
					bars.FriendlyTarget.icon.pos_y = 1
				end
				for i = 1, 5 do
					if bars["GroupMember"..i] then
						if bars["GroupMember"..i].icon.pos_y == 2 then
							bars["GroupMember"..i].icon.pos_y = 1
						end
					end
					if bars["TargetsFriendly"..i] and bars["TargetsFriendly"..i].icon.pos_y == -4 then
						bars["TargetsFriendly"..i].icon.pos_y = -6
					end
					if bars["TargetsHostile"..i] and bars["TargetsHostile"..i].icon.pos_y == -4 then
						bars["TargetsHostile"..i].icon.pos_y = -6
					end
				end
			end
			if bars.FriendlyTargetRing and bars.FriendlyTargetRing.icon.scale == 2.81 then
				bars.FriendlyTargetRing.icon = Addon.GetDefaultCareerIcon()
			end
			if bars.HostileTargetRing and bars.HostileTargetRing.icon.scale == 2.81 then
				bars.HostileTargetRing.icon = Addon.GetDefaultCareerIcon()
			end
		end
		if Addon.SavedVarsVersion < 2.63 then
			for k,v in pairs(Addon.Rules) do	-- k: Color,...
				for k2, v2 in pairs(v) do		-- k2: Rules, RuleSets
					for k3, v3 in pairs(v2) do	-- k3: the rule or ruleset						
						local tt
						if k2 == "RuleSets" then
							tt = Addon.GetRuleFactoryPreset(k, true, k3)
						else
							tt = Addon.GetRuleFactoryPreset(k, false, k3)
						end
						if tt then
							local isIdentical = true
							if k2 == "RuleSets" then
								for key, value in pairs(v3.rules) do
									if tt.rules[key] ~= value then
										isIdentical = false
										break
									end
								end
							else
								for key, value in pairs(v3) do
									if tt[key] ~= value then
										isIdentical = false
										break
									end
								end
							end
							if isIdentical then
								--EA_ChatWindow.Print(towstring(k)..L" "..towstring(k2)..L" "..towstring(k3)..L" is identical to preset. Deleting")
								Addon.Rules[k][k2][k3] = nil
							end
						end
					end
				end
			end
		end
		if Addon.SavedVarsVersion < 2.64 then
			Addon.ProfileSettings.CastbarHookRespawn = true
			if nil == Addon.WindowSettings.castbar_show_gcd then Addon.WindowSettings.castbar_show_gcd = false end
			Addon.ProfileSettings.CastbarShowGCD = Addon.WindowSettings.castbar_show_gcd
			Addon.WindowSettings.castbar_show_gcd = nil
		end
		if Addon.SavedVarsVersion < 2.641 then
			for _,b in pairs(Addon.Bars) do
				-- bar level
				b.anchors = {}
				b.anchors[1] = {}
				b.anchors[1].parent = b.relwin
				b.anchors[1].point = b.my_anchor
				b.anchors[1].parentpoint = b.to_anchor
				b.anchors[1].x = b.x
				b.anchors[1].y = b.y
				b.relwin = nil
				b.my_anchor = nil
				b.to_anchor = nil
				b.x = nil
				b.y = nil

				for k,_ in pairs({["icon"] = true, ["status_icon"] = true, ["rvr_icon"] = true}) do
					if b[k] and next(b[k]) then
						b[k].anchors = {}
						b[k].anchors[1] = {}
						b[k].anchors[1].parent = "Bar"	-- icons have no anchorparent yet
						b[k].anchors[1].point = b[k].my_anchor or "center"
						b[k].anchors[1].parentpoint = b[k].to_anchor or "center"
						b[k].anchors[1].x = b[k].pos_x
						if b[k].anchors[1].x == nil then b[k].anchors[1].x = 0 end
						--d(towstring(b.name)..L": "..towstring(k), b[k].pos_y)
						b[k].anchors[1].y = b[k].pos_y
						if b[k].anchors[1].y == nil then b[k].anchors[1].y = 0 end
						b[k].anchorTo = nil
						b[k].my_anchor = nil
						b[k].to_anchor = nil
						b[k].pos_x = nil
						b[k].pos_y = nil
						if b[k].texture then b[k].texture = nil end
					end
				end
				
				local labelsAndImages = {["labels"] = true, ["images"] = true}
				for loi,_ in pairs(labelsAndImages) do
					if b[loi] and next(b[loi]) then
						for k,v in pairs(b[loi]) do
							b[loi][k].anchors = {}
							b[loi][k].anchors[1] = {}
							b[loi][k].anchors[1].parent = v.anchorTo or "Bar"
							b[loi][k].anchors[1].point = v.my_anchor or "topleft"
							b[loi][k].anchors[1].parentpoint = v.to_anchor or "topleft"
							b[loi][k].anchors[1].x = v.pos_x
							if b[loi][k].anchors[1].x == nil then b[loi][k].anchors[1].x = 0 end
							b[loi][k].anchors[1].y = v.pos_y
							if b[loi][k].anchors[1].y == nil then b[loi][k].anchors[1].y = 0 end
							b[loi][k].anchorTo = nil
							b[loi][k].my_anchor = nil
							b[loi][k].to_anchor = nil
							b[loi][k].pos_x = nil
							b[loi][k].pos_y = nil
						end
					end
				end
				
			end
		end
		if Addon.SavedVarsVersion < 2.65 then
			for _,b in pairs(Addon.Bars) do
				b.icon.anchors[1].x = b.icon.anchors[1].x - b.border.padding.left
				b.icon.anchors[1].y = b.icon.anchors[1].y + b.border.padding.top
				b.rvr_icon.anchors[1].x = b.rvr_icon.anchors[1].x - b.border.padding.left
				b.rvr_icon.anchors[1].y = b.rvr_icon.anchors[1].y + b.border.padding.top
				b.status_icon.anchors[1].x = b.status_icon.anchors[1].x - b.border.padding.left
				b.status_icon.anchors[1].y = b.status_icon.anchors[1].y + b.border.padding.top
			end
		end
		if Addon.SavedVarsVersion < 2.66 then
			for _,b in pairs(Addon.Bars) do
				if (b.state == "FTHP" or b.state == "HTHP" or b.state == "FTlvl" or b.state == "HTlvl") then
					if b.show_with_target then b.show_with_target = false end
					if b.hide_if_target then b.hide_if_target = false end
					if b.labels then
						for _, v in pairs(b.labels) do
							if v.show_if_target then v.show_if_target = false end
						end
					end
					if b.images then
						for _, v in pairs(b.images) do
							if v.show_if_target then v.show_if_target = false end
						end
					end
				end
			end
		end
	end

	--[[for k,_ in pairs(Addon.Rules) do	-- k: Color,...
		local ruleSets = Addon.GetRuleFactoryPresetsFor(k, true)
		for name,_ in pairs(Addon.GetRuleFactoryPresetsFor(k, false)) do
			local found = false
			for _, ruleSet in pairs(ruleSets) do
				for nameInSet,_ in pairs(ruleSet.rules) do
					if name == nameInSet then
						found = true
						break
					end
				end
				if found then break end
			end
			if not found then
				EA_ChatWindow.Print(towstring(k)..L" Rule "..towstring(name)..L" is not in any ruleset.")
			else
				--EA_ChatWindow.Print(towstring(k)..L" "..towstring(k2)..L" "..towstring(k3)..L" is identical to preset and should be removed.")
			end
		end
	end]]--

	Addon.SavedVarsVersion = savedVarsVersion
end

function Addon.CheckForMissingMembers(b)
	if (nil == b) then return end

	if (nil == b.icon.scale) then
		b.icon.scale = 0.9
	end

	if (nil == b.rvr_icon.scale) then
		b.rvr_icon.scale = 1
	end

	if (nil == b.visibility_group) then
		b.visibility_group = "none"
	end
	
	if (nil == b.icon.alpha) then
		b.icon.alpha = 1
	end
	
	if (nil == b.rvr_icon.alpha) then
		b.rvr_icon.alpha = 1
	end

	if (nil == b.status_icon) then b.status_icon = Addon.GetDefaultStatusIcon() end
	
	-- Labels
	if (nil == b.labels) then
		b.labels = Addon.deepcopy(EffigyBarDefaults.labels)
		
		-- migrate
		
		for k,v in pairs(b.labels) do
			local label = nil
			if (i==1 and (nil ~= b.percent_label)) then
				label = b.percent_label
			elseif (i==2 and (nil ~= b.level_label)) then	
				label = b.level_label
			elseif (i==3 and (nil ~= b.title_label)) then
				label = b.title_label
			elseif (i==4 and (nil ~= b.info_label)) then
				label = b.info_label
			end
			
			if nil ~= label then
				--we don´t want to overwrite the whole table...
				--b.labels[i] = Addon.deepcopy(label)
				for l,w in pairs(label) do
					if (tostring(l)~="align" and tostring(l)~="font") then
						b.labels[k][v] = w
					end
				end
				
				if (label.align ~= nil) then
					b.labels[k].font.align = label.align
				end
				if (label.font.r ~= nil) then
					b.labels[k].colorsettings.color.r = label.font.r
				end
				if (label.font.g ~= nil) then
					b.labels[k].colorsettings.color.g = label.font.g
				end
				if (label.font.b ~= nil) then
					b.labels[k].colorsettings.color.b = label.font.b
				end
				if (label.font.name ~= nil) then
					b.labels[k].font.name = label.font.name
				end
			end
			
			if (i==1 and (nil ~= b.percent_label)) then
				b.percent_label = nil
			elseif (i==2 and (nil ~= b.level_label)) then	
				b.level_label = nil
			elseif (i==3 and (nil ~= b.title_label)) then
				b.title_label = nil
			elseif (i==4 and (nil ~= b.info_label)) then
				b.info_label = nil
			end
			
		end
	else
		for name,label in pairs(b.labels) do
			-- Cycle through the default, if the actual is missing some value, insert default
			for defaultSetting_Key, defaultSetting_Value in pairs( Addon.GetDefaultLabel() ) do
				if b.labels[name][defaultSetting_Key] == nil then
					b.labels[name][defaultSetting_Key] = Addon.deepcopy(defaultSetting_Value)
				end
			end
			if label.formattemplate == "$title.Renown" then
				label.formattemplate = "$title.PlayerRR"
			elseif label.formattemplate == "$Renown" then
				label.formattemplate = "PlayerRenown"
			end
		end
	end
	-- should only be necessary until official release (since then the above will cover it)
	if nil ~= b.percent_label then b.percent_label = nil end
	if nil ~= b.level_label then b.level_label = nil end
	if nil ~= b.title_label then b.title_label = nil end
	if nil ~= b.info_label then b.info_label = nil end
	
	if (nil == b.images) then
		b.images = Addon.deepcopy(EffigyBarDefaults.images)
	else
		for name,_ in pairs(b.images) do
			-- Cycle through the default, if the actual is missing some value, insert default
			for defaultSetting_Key, defaultSetting_Value in pairs( Addon.GetDefaultImage() ) do
				if b.images[name][defaultSetting_Key] == nil then
					b.images[name][defaultSetting_Key] = Addon.deepcopy(defaultSetting_Value)
				end
			end
		end
	end
	
end

function Addon.ImportHUDUF(targetLayoutName)
	if not HUDUnitFrames then return end
	local bars = HUDUnitFrames.Bars
	if not bars then return end
	bars = Addon.deepcopy(bars)
	for name, bar in pairs(bars) do
		bar.entity_id = nil
		bar.initialized = nil
		bar.names = nil
		bar.native_228_bar = nil
		if bar.rvr_icon then bar.rvr_icon.texture = nil end
		if bar.icon then bar.icon.texture = nil end
		if bar.status_icon then bar.status_icon.texture = nil end
		
		bar.labels = {}
		if bar.title_label then
			bar.labels["title"] = Addon.GetDefaultLabel()
			bar.labels["title"].formattemplate = bar.title_label.formattemplate or "$title"
			bar.labels["title"].font.align = bar.title_label.align
			bar.labels["title"].scale = bar.title_label.scale -- ToDO: shorten hinterm komma
			bar.labels["title"].width = bar.title_label.width
			bar.labels["title"].clip_after = bar.title_label.clip_after
			bar.labels["title"].colorsettings.color_group = bar.title_label.colour_group or "none"
			bar.labels["title"].colorsettings.color.r = bar.title_label.font.r
			bar.labels["title"].colorsettings.color.g = bar.title_label.font.g
			bar.labels["title"].colorsettings.color.b = bar.title_label.font.b
			bar.labels["title"].height = bar.title_label.height
			bar.labels["title"].show = bar.title_label.show
			bar.labels["title"].anchors[1].x = bar.title_label.pos_x
			bar.labels["title"].anchors[1].y = bar.title_label.pos_y
			bar.labels["title"].anchors[1].point = bar.title_label.my_anchor
			bar.labels["title"].anchors[1].parentpoint = bar.title_label.to_anchor
			bar.labels["title"].font.name = bar.title_label.font.name
			
			bar.title_label = nil
		end
		if bar.level_label then
			bar.labels["level"] = Addon.GetDefaultLabel()
			bar.labels["level"].formattemplate = bar.level_label.formattemplate or "$lvl"
			bar.labels["level"].font.align = bar.level_label.align
			bar.labels["level"].scale = bar.level_label.scale -- ToDO: shorten hinterm komma
			bar.labels["level"].width = bar.level_label.width
			bar.labels["level"].clip_after = bar.level_label.clip_after
			bar.labels["level"].colorsettings.color_group = bar.level_label.colour_group or "none"
			bar.labels["level"].colorsettings.color.r = bar.level_label.font.r
			bar.labels["level"].colorsettings.color.g = bar.level_label.font.g
			bar.labels["level"].colorsettings.color.b = bar.level_label.font.b
			bar.labels["level"].height = bar.level_label.height
			bar.labels["level"].show = bar.level_label.show
			bar.labels["level"].anchors[1].x = bar.level_label.pos_x
			bar.labels["level"].anchors[1].y = bar.level_label.pos_y
			bar.labels["level"].anchors[1].point = bar.level_label.my_anchor
			bar.labels["level"].anchors[1].parentpoint = bar.level_label.to_anchor
			bar.labels["level"].font.name = bar.level_label.font.name
			
			bar.level_label = nil
		end
		if bar.percent_label then
			bar.labels["percent"] = Addon.GetDefaultLabel()
			bar.labels["percent"].formattemplate = bar.percent_label.formattemplate or "$per"
			bar.labels["percent"].font.align = bar.percent_label.align
			bar.labels["percent"].scale = bar.percent_label.scale -- ToDO: shorten hinterm komma
			bar.labels["percent"].width = bar.percent_label.width
			bar.labels["percent"].clip_after = bar.percent_label.clip_after
			bar.labels["percent"].colorsettings.color_group = bar.percent_label.colour_group or "none"
			bar.labels["percent"].colorsettings.color.r = bar.percent_label.font.r
			bar.labels["percent"].colorsettings.color.g = bar.percent_label.font.g
			bar.labels["percent"].colorsettings.color.b = bar.percent_label.font.b
			bar.labels["percent"].height = bar.percent_label.height
			bar.labels["percent"].show = bar.percent_label.show
			bar.labels["percent"].anchors[1].x = bar.percent_label.pos_x
			bar.labels["percent"].anchors[1].y = bar.percent_label.pos_y
			bar.labels["percent"].anchors[1].point = bar.percent_label.my_anchor
			bar.labels["percent"].anchors[1].parentpoint = bar.percent_label.to_anchor
			bar.labels["percent"].font.name = bar.percent_label.font.name
			
			if bar.percent_label.show_max == false then
				-- use ruleset
				bar.labels["percent"].visibility_group = "CombatOrNotFull"
			else
				bar.labels["percent"].visibility_group = "none"
			end
			
			bar.percent_label = nil
		end
		--bar.decal
		bar.images = {}
		
		if bar.rvr_icon then
			local old_rvr_icon = bar.rvr_icon
			bar.rvr_icon = Addon.GetDefaultRvrIcon()
			bar.rvr_icon.show = old_rvr_icon.show or true
			bar.rvr_icon.alpha = old_rvr_icon.alpha or 1
			bar.rvr_icon.scale = old_rvr_icon.scale or 1
			bar.rvr_icon.follow_bg_alpha = old_rvr_icon.follow_bg_alpha or false
			bar.rvr_icon.anchors[1].x = old_rvr_icon.pos_x or 0
			bar.rvr_icon.anchors[1].y = old_rvr_icon.pos_y or 0
			bar.rvr_icon.anchors[1].point = old_rvr_icon.my_anchor or bar.rvr_icon.anchors[1].point
			bar.rvr_icon.anchors[1].parentpoint = old_rvr_icon.to_anchor or bar.rvr_icon.anchors[1].parentpoint
		else
			bar.rvr_icon = Addon.GetDefaultRvrIcon()
		end
		
		if bar.icon then
			local old_icon = bar.icon
			bar.icon = Addon.GetDefaultCareerIcon()
			bar.icon.show = old_icon.show or true
			bar.icon.alpha = old_icon.alpha or 1
			bar.icon.scale = old_icon.scale or 1
			bar.icon.follow_bg_alpha = old_icon.follow_bg_alpha or false
			bar.icon.anchors[1].x = old_icon.pos_x or 0
			bar.icon.anchors[1].y = old_icon.pos_y or 0
			bar.icon.anchors[1].point = old_icon.my_anchor or bar.icon.anchors[1].point
			bar.icon.anchors[1].parentpoint = old_icon.to_anchor or bar.icon.anchors[1].parentpoint
		else
			bar.icon = Addon.GetDefaultCareerIcon()
		end
		
		if bar.status_icon then
			local old_icon = bar.status_icon
			bar.status_icon = Addon.GetDefaultStatusIcon()
			bar.status_icon.show = old_icon.show or true
			bar.status_icon.alpha = old_icon.alpha or 1
			bar.status_icon.scale = old_icon.scale or 1
			bar.status_icon.follow_bg_alpha = old_icon.follow_bg_alpha or false
			bar.status_icon.anchors[1].x = old_icon.pos_x or 0
			bar.status_icon.anchors[1].y = old_icon.pos_y or 0
			bar.status_icon.anchors[1].point = old_icon.my_anchor or bar.status_icon.anchors[1].point
			bar.status_icon.anchors[1].parentpoint = old_icon.to_anchor or bar.status_icon.anchors[1].parentpoint
		else
			bar.status_icon = Addon.GetDefaultStatusIcon()
		end
	end
end