if not Effigy then Effigy = {} end
local CoreAddon = Effigy
if not EffigyConfigGui then EffigyConfigGui = {} end
local Addon = EffigyConfigGui

local LibGUI = LibStub("LibGUI")

if (nil == Addon.Name) then Addon.Name = "EffigyConfigGui" end

local function GetBarList()
	local tt={}
	table.foreach(CoreAddon.Bars,
		function (k,b)
			if (nil == b.hidden)or(false == b.hidden) then
				table.insert (tt, k) 
			end
		end)
	table.sort(tt)
	return tt
end

--
--	CREATE Bar Panel ------------------------------------------------
--

Addon.BarPanel = {}
Addon.BarPanel.W = nil

function Addon.ConditionalDeleteBar(barname)
	if (nil ~= barname and nil ~= CoreAddon.Bars[barname]) then
		--[[DialogManager.MakeTwoButtonDialog( dialogText, button1Text, buttonCallback1, button2Text, buttonCallback2,
		timer, autoRespondButton, warningIsChecked, neverWarnCallback, dialogType, dialogID, windowLayer )]]--
		local text = GetStringFormat (StringTables.Default.LABEL_TEXT_DESTROY_ITEM_CONFIRM, { barname } )
		DialogManager.MakeTwoButtonDialog(
		text,
		GetString( StringTables.Default.LABEL_YES ),
		function()
			CoreAddon.DestroyBar(barname)
			local w = Addon.BarPanel.W
			if w and w.name then
				w.cDelete:Clear()
				for _,v in pairs(GetBarList()) do w.cDelete:Add(v) end
				w.cCopy:Clear()
				for _,v in pairs(GetBarList()) do w.cCopy:Add(v) end
			end
			Addon.UpdateLibAddonButton()
			if DoesWindowExist(Addon.Name.."SettingsWindow") then Addon.UpdateSettingsWindow() end
		end, 
		GetString( StringTables.Default.LABEL_NO ))
	else
		EA_ChatWindow.Print(L"Error with Selected Item")
	end
end

function Addon.ConditionalDeleteTemplate(name)
	if (nil ~= name and nil ~= CoreAddon.BarTemplates[name]) then
		local text = GetStringFormat (StringTables.Default.LABEL_TEXT_DESTROY_ITEM_CONFIRM, { name } )
		DialogManager.MakeTwoButtonDialog(
		text,
		GetString( StringTables.Default.LABEL_YES ),
		function()
			CoreAddon.BarTemplates[name] = nil
			local w = Addon.BarPanel.W
			if w and w.name and w.cLoad then
				w.cLoad:Clear()
				local tt={}
				for k,_ in pairs(CoreAddon.BarTemplates) do table.insert (tt, k) end
				for k,_ in pairs(UFTemplates.Bars) do table.insert (tt, k) end
				table.sort(tt)
				for k,v in pairs(tt) do w.cLoad:Add(v) end
			end
			Addon.UpdateLibAddonButton()
			if DoesWindowExist(Addon.Name.."SettingsWindow") then Addon.UpdateSettingsWindow() end
		end, 
		GetString( StringTables.Default.LABEL_NO ))
	else
		EA_ChatWindow.Print(L"Error with Selected Item")
	end
end

function Addon.BarPanel.Create()
	local frameName = Addon.Name.."SettingsWindowCreateBarPopUp"
	local frameSizeW = 640
	local frameSizeH = 480
	
	if (nil ~= Addon.BarPanel.W) then
		Addon.BarPanel.Destroy()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowTemplatesPopUp") then DestroyWindow(Addon.Name.."SettingsWindowTemplatesPopUp") end	
	CreateWindowFromTemplate(frameName, Addon.Name.."PopupWindowTemplate","Root")
	ButtonSetText(frameName.."ButtonOK", L"Close")
	WindowRegisterCoreEventHandler(frameName.."ButtonOK", "OnLButtonUp", Addon.Name..".BarPanel.Destroy")
	WindowRegisterCoreEventHandler(frameName.."ButtonClose", "OnLButtonUp", Addon.Name..".BarPanel.Destroy")
	WindowSetDimensions(frameName, frameSizeW, frameSizeH)
	LabelSetTextColor(frameName.."TitleBarText", 255, 255, 255)
	LabelSetText(frameName.."TitleBarText", L"Manage Bars")
	
	local w = {}

	w = LibGUI("Window")

	w:Resize(frameSizeW - 10, frameSizeH - 100)
	w:Parent(frameName)
	w:AnchorTo(frameName, "top", "top", 0, 30)

	w.lCreate = w("Label")
	w.lCreate:AnchorTo(w, "topleft", "topleft", 40, 40)
	w.lCreate:Resize(150)
	w.lCreate:Font(Addon.FontBold)
	w.lCreate:SetText(L"Create:")
	w.lCreate:Align("left")
	
	w.NewBarName = w("Textbox")
	w.NewBarName:Resize(250)
	w.NewBarName:AnchorTo(w.lCreate, "right", "left", 0, -2)
	-- layout button
	w.NewBarButton = w("Button", nil, Addon.ButtonInherits)
	w.NewBarButton:Resize(Addon.ButtonWidth)
	w.NewBarButton:SetText(L"Create")
	--w.NewBarButton:TextColor(0, 255, 0)
	ButtonSetTextColor(w.NewBarButton.name, 0, 0, 255, 0)
	w.NewBarButton:AnchorTo(w.NewBarName, "right", "left", 20, 0)
	w.NewBarButton.OnLButtonUp = 
		function()
			if (nil ~= w.NewBarName:GetText()) and (L"" ~= w.NewBarName:GetText()) then
				local barname = w.NewBarName:GetText()
				local bar = CoreAddon.CreateBar(WStringToString(barname))
				bar:setup()
				bar:render()
				--w.EditBar:Add(w.NewBarName:GetText())
				if DoesWindowExist(Addon.Name.."SettingsWindow") then Addon.UpdateSettingsWindow() end
				Addon.UpdateLibAddonButton()
				w.cDelete:Add(barname)
				w.cDelete:Select(barname)
				w.cCopy:Add(barname)
				--Addon.BarPanel.Destroy()
			end
		end

	w.lDelete = w("Label")
	w.lDelete:AnchorTo(w.lCreate, "bottomleft", "topleft", 0, 40)
	w.lDelete:Resize(150)
	w.lDelete:Font(Addon.FontHeadline)
	w.lDelete:Color(200, 100, 0)
	w.lDelete:SetText(L"Manage:")
	w.lDelete:Align("left")

	w.cDelete = w("Combobox")
	w.cDelete:AnchorTo(w.lDelete, "right", "left", 0, -2)
	for _,v in pairs(GetBarList()) do w.cDelete:Add(v) end

	w.bDelete = w("Button", nil, Addon.ButtonInherits)
	w.bDelete:Resize(Addon.ButtonWidth)
	w.bDelete:SetText(L"Delete")
	w.bDelete:AnchorTo(w.cDelete, "right", "left", 20, 0)
	--w.bDelete:TextColor(255, 0, 0)
	ButtonSetTextColor(w.bDelete.name, 0, 255, 0, 0)
	w.bDelete.OnMouseOver = 
		function()
			Addon.SetToolTip(w.bDelete, "WARNING!",
				"Deleting a bar is irreversible!")
		end
	w.bDelete.OnLButtonUp = 
		function()
			Addon.ConditionalDeleteBar(WStringToString(w.cDelete:Selected()))
		end
		
	w.lCopy = w("Label")
	w.lCopy:AnchorTo(w.lDelete, "bottomleft", "topleft", 0, 20)
	w.lCopy:Resize(150)
	w.lCopy:Font(Addon.FontBold)
	w.lCopy:SetText(L"Load from Bar:")
	w.lCopy:Align("left")

	w.cCopy = w("Combobox")
	w.cCopy:AnchorTo(w.lCopy, "right", "left", 0, -2)
	for k,v in pairs(GetBarList()) do w.cCopy:Add(v) end

	w.bCopy = w("Button", nil, Addon.ButtonInherits)
	w.bCopy:Resize(Addon.ButtonWidth)
	w.bCopy:SetText(L"Load")
	w.bCopy:AnchorTo(w.cCopy, "right", "left", 20, 0)
	w.bCopy.OnMouseOver = 
		function()
			Addon.SetToolTip(w.bCopy, "WARNING!",
				"Copying a bar replaces your current settings on the target bar!",
				"Including state and position ;) Make sure you change those afterward")
		end
	w.bCopy.OnLButtonUp = 
		function()
			local selected = WStringToString(w.cDelete:Selected())
			if (nil ~= selected and nil ~= CoreAddon.Bars[selected]) then
				local selectedsource = WStringToString(w.cCopy:Selected())
				if (nil ~= selectedsource and nil ~= CoreAddon.Bars[selectedsource]) then
					local text = StringToWString("Are you sure to overwrite "..selected.." with "..selectedsource.."? "..selected.." will be irreversibly deleted in the process!")
					DialogManager.MakeTwoButtonDialog(
					text,
					GetString( StringTables.Default.LABEL_YES ),
					function()
						bar = EffigyBar.CopyBar(selectedsource, selected)
						bar:setup()
						bar:render()
					end, 
					GetString( StringTables.Default.LABEL_NO ))
				else
					EA_ChatWindow.Print(L"Error with Selected Item")
				end
			end
		end
		
	--
	-- Templates
	--
	w.lTemplate = w("Label")
	w.lTemplate:AnchorTo(w.lCopy, "bottomleft", "topleft", 0, 20)
	w.lTemplate:Resize(250)
	w.lTemplate:Font(Addon.FontBold)
	w.lTemplate:Color(200, 100, 0)
	w.lTemplate:SetText(L"Template:")
	w.lTemplate:Align("left")
	
	w.lsave = w("Label")
	w.lsave:AnchorTo(w.lTemplate, "bottomleft", "topleft", 0, 20)
	w.lsave:Resize(150)
	w.lsave:Font(Addon.FontBold)
	w.lsave:SetText(L"Save as:")
	w.lsave:Align("left")

	w.tsave = w("Textbox")
	w.tsave:Resize(250)
	w.tsave:AnchorTo(w.lsave, "right", "left", 0, -2)

	w.bsave = w("Button", nil, Addon.ButtonInherits)
	w.bsave:Resize(Addon.ButtonWidth)
	w.bsave:SetText(L"Save")
	w.bsave:AnchorTo(w.tsave, "right", "left", 20, 0)
	w.bsave.OnLButtonUp = 
		function()
			if (nil ~= w.tsave:GetText() and L"" ~= w.tsave:GetText()) then
				CoreAddon.BarTemplates[WStringToString(w.tsave:GetText())] = CoreAddon.deepcopy(bar)
				w.cLoad:Clear()
				for k,_ in pairs(CoreAddon.BarTemplates) do w.cLoad:Add(k) end
				for k,_ in pairs(UFTemplates.Bars) do w.cLoad:Add(k) end
			end
		end

	w.lLoad = w("Label")
	w.lLoad:AnchorTo(w.lsave, "bottomleft", "topleft", 0, 20)
	w.lLoad:Resize(150)
	w.lLoad:Font(Addon.FontBold)
	w.lLoad:SetText(L"Load:")
	w.lLoad:Align("left")
	w.lLoad.OnMouseOver = 
		function()
			Addon.SetToolTip(w.lLoad, "WARNING!",
				"Loading a template replaces your current settings on this bar.",
				"Including state and position ;) Make sure you change those afterward")
		end
		
	w.cLoad = w("Combobox")
	w.cLoad:AnchorTo(w.lLoad, "right", "left", 0, -2)
	for k,_ in pairs(CoreAddon.BarTemplates) do w.cLoad:Add(k) end
	local tt={}
	for k,_ in pairs(UFTemplates.Bars) do table.insert (tt, k) end
	table.sort(tt)
	for _,v in ipairs(tt) do w.cLoad:Add(v) end
	
	w.bLoad = w("Button", nil, Addon.ButtonInherits)
	w.bLoad:Resize(Addon.ButtonWidth)
	w.bLoad:SetText(L"Load")
	w.bLoad:AnchorTo(w.cLoad, "right", "left", 20, 0)
	w.bLoad.OnMouseOver = 
		function()
			Addon.SetToolTip(w.bLoad, "WARNING!",
				"Loading a template replaces your current settings on this bar.",
				"Including state and position ;) Make sure you change those afterward")
		end
	w.bLoad.OnLButtonUp = 
		function()
			local selectedtarget = WStringToString(w.cDelete:Selected())
			if (nil ~= selectedtarget and nil ~= CoreAddon.Bars[selectedtarget]) then
				local selected = WStringToString(w.cLoad:Selected())
				if (nil ~= selected and (nil ~= CoreAddon.BarTemplates[selected] or nil ~= UFTemplates.Bars[selected])) then
					local text = StringToWString("Are you sure to overwrite "..selectedtarget.." with "..selected.."? "..selectedtarget.." will be irreversibly deleted in the process!")
					DialogManager.MakeTwoButtonDialog(
					text,
					GetString( StringTables.Default.LABEL_YES ),
					function()
						local bar = EffigyBar.LoadTemplate(selected, selectedtarget)
						bar:setup()
						bar:render()
					end, 
					GetString( StringTables.Default.LABEL_NO ))
				else
					EA_ChatWindow.Print(L"Error with Selected Item")
				end
			end
		end
		
	Addon.BarPanel.W = w
	Addon.BarPanel.W:Show()
end

function Addon.BarPanel.Destroy()
	--Addon.EditBarPanel.Destroy()
	if (nil ~= Addon.BarPanel.W) then
		Addon.BarPanel.W:Destroy()
	end
	local frameName = Addon.Name.."SettingsWindowCreateBarPopUp"
	if DoesWindowExist(frameName) then
		WindowUnregisterCoreEventHandler(frameName.."ButtonOK", "OnLButtonUp")
		WindowUnregisterCoreEventHandler(frameName.."ButtonClose", "OnLButtonUp")
		DestroyWindow(frameName)	
	end
end

--
--	Template Settings Panel ---------------------------------------------------
--

Addon.TemplateBarSettings = {}
function Addon.TemplateBarSettings.Create()
	local frameName = Addon.Name.."SettingsWindowTemplatesPopUp"
	local frameSizeW = 640
	local frameSizeH = 280
	
	if (nil ~= Addon.BarPanel.W) then
		Addon.BarPanel.Destroy()
	end
	if DoesWindowExist(Addon.Name.."SettingsWindowCreateBarPopUp") then DestroyWindow(Addon.Name.."SettingsWindowCreateBarPopUp") end
	
	if not DoesWindowExist(frameName) then
		CreateWindowFromTemplate(frameName, Addon.Name.."PopupWindowTemplate","Root")
		ButtonSetText(frameName.."ButtonOK", L"Close")
		WindowRegisterCoreEventHandler(frameName.."ButtonOK", "OnLButtonUp", Addon.Name..".TemplateBarSettings.Destroy")
		WindowRegisterCoreEventHandler(frameName.."ButtonClose", "OnLButtonUp", Addon.Name..".TemplateBarSettings.Destroy")
		WindowSetDimensions(frameName, frameSizeW, frameSizeH)
		LabelSetTextColor(frameName.."TitleBarText", 255, 255, 255)
	end
	LabelSetText(frameName.."TitleBarText", L"Bar Templates: "..towstring(Addon.EditBar))
	
	--w, bar = Addon.CreateEditBarSettingsStart()
	local bar = CoreAddon.Bars[Addon.EditBar]
	local w = LibGUI("window")
	w:Resize(frameSizeW - 10, frameSizeH - 100)
	w:Parent(frameName)
	--w:AnchorTo(Addon.Name.."SettingsWindow", "center", "center", 0, 0)
	w:AnchorTo(frameName, "top", "top", 0, 30)
	--w:Resize(695, 440)
	
	w.lsave = w("Label")
	w.lsave:Position(25,20)
	w.lsave:Resize(250)
	w.lsave:Font(Addon.FontBold)
	w.lsave:SetText(L"Save Bar as Template:")
	w.lsave:Align("left")

	w.tsave = w("Textbox")
	w.tsave:Resize(250)
	w.tsave:AnchorTo(w.lsave, "bottomleft", "topleft", 20, 0)

	w.bsave = w("Button", nil, Addon.ButtonInherits)
	w.bsave:Resize(Addon.ButtonWidth)
	w.bsave:SetText(L"Save")
	w.bsave:AnchorTo(w.tsave, "right", "left", 5, 0)
	w.bsave.OnLButtonUp = 
		function()
			if (nil ~= w.tsave:GetText() and L"" ~= w.tsave:GetText()) then
				CoreAddon.BarTemplates[WStringToString(w.tsave:GetText())] = CoreAddon.deepcopy(bar)
				w.cLoad:Clear()
				for k,_ in pairs(CoreAddon.BarTemplates) do w.cLoad:Add(k) end
				for k,_ in pairs(UFTemplates.Bars) do w.cLoad:Add(k) end
			end
		end

	w.lLoad = w("Label")
	w.lLoad:AnchorTo(w.lsave, "bottomleft", "topleft", 0, 40)
	w.lLoad:Resize(280)
	w.lLoad:Font(Addon.FontBold)
	w.lLoad:SetText(L"Load Template into this bar:")
	w.lLoad:Align("left")
	w.lLoad.OnMouseOver = 
		function()
			Addon.SetToolTip(w.lLoad, "WARNING!",
				"Loading a template replaces your current settings on this bar.",
				"Including state and position ;) Make sure you change those afterward")
		end
		
	w.cLoad = w("Combobox")
	w.cLoad:AnchorTo(w.lLoad, "bottomleft", "topleft", 20, 0)
	local tt={}
	for k,_ in pairs(CoreAddon.BarTemplates) do table.insert (tt, k) end
	for k,_ in pairs(UFTemplates.Bars) do table.insert (tt, k) end
	table.sort(tt)
	for k,v in pairs(tt) do w.cLoad:Add(v) end
	
	w.bLoad = w("Button", nil, Addon.ButtonInherits)
	w.bLoad:Resize(Addon.ButtonWidth)
	w.bLoad:SetText(L"Load")
	w.bLoad:AnchorTo(w.cLoad, "right", "left", 5, 0)
	w.bLoad.OnMouseOver = 
		function()
			Addon.SetToolTip(w.bLoad, "WARNING!",
				"Loading a template replaces your current settings on this bar.",
				"Including state and position ;) Make sure you change those afterward")
		end
	w.bLoad.OnLButtonUp = 
		function()
			local selected = WStringToString(w.cLoad:Selected())
			if (nil ~= selected and (nil ~= CoreAddon.BarTemplates[selected] or
				--nil ~= EffigyBarTemplates.BarTemplates[selected])) then
				nil ~= UFTemplates.Bars[selected])) then
				bar = EffigyBar.LoadTemplate(selected, bar.name)
				bar:setup()
				bar:render()
			else
				EA_ChatWindow.Print(L"Error with Selected Item")
			end
		end

	-- Delete Template
	w.bDelete = w("Button", nil, Addon.ButtonInherits)
	w.bDelete:Resize(Addon.ButtonWidth)
	w.bDelete:SetText(L"Delete")
	w.bDelete:AnchorTo(w.bLoad, "right", "left", 5, 0)
	w.bDelete.OnMouseOver = 
		function()
			Addon.SetToolTip(w.bDelete, "WARNING!",
				"This operation is irreversible.", "No Undo.")
		end
	w.bDelete.OnLButtonUp = 
		function()
			local selected = WStringToString(w.cLoad:Selected())
			if nil ~= selected then
				if UFTemplates.Bars[selected] then
					EA_ChatWindow.Print(L"You can not delete a factory preset")
					return
				end
				if (nil ~= CoreAddon.BarTemplates[selected]) then
					Addon.ConditionalDeleteTemplate(selected)
				else
					EA_ChatWindow.Print(L"Error with Selected Item")
				end
			end
		end	
	
	
	Addon.BarPanel.W = w
	Addon.BarPanel.W:Show()
end

function Addon.TemplateBarSettings.Destroy()
	--Addon.EditBarPanel.Destroy()
	if (nil ~= Addon.BarPanel.W) then
		Addon.BarPanel.W:Destroy()
	end
	local frameName = Addon.Name.."SettingsWindowTemplatesPopUp"
	if DoesWindowExist(frameName) then
		WindowUnregisterCoreEventHandler(frameName.."ButtonOK", "OnLButtonUp")
		WindowUnregisterCoreEventHandler(frameName.."ButtonClose", "OnLButtonUp")
		DestroyWindow(frameName)	
	end
end

