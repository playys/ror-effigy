LibGUIComboboxer = {}

local LibGUI = LibStub("LibGUI")

local CurrentCombobox

local function empty_function()
end

function LibGUIComboboxer.NewCombobox(elementType, elementName, elementBase)
	local elementType = elementType or "combobox"
    --local elementName = (elementName ~= "") and elementName or getNewElementName(elementType)
    
    elementType = elementType:lower()
    
    local newElement
	if elementType == "combobox" then
        newElement = LibGUI("combobox", elementName, "LibGUI_ComboBox_DefaultResizable_Template")
	elseif elementType == "smallcombobox" then
        newElement = LibGUI("combobox", elementName, "LibGUI_ComboBox_DefaultResizableSmall_Template")
    elseif elementType == "tinycombobox" then
        newElement = LibGUI("combobox", elementName, "LibGUI_ComboBox_DefaultResizableTiny_Template")
    elseif elementType == "largecombobox" then
        newElement = LibGUI("combobox", elementName, "LibGUI_ComboBox_DefaultResizableLarge_Template")
    elseif elementType == "mediumcombobox" then
        newElement = LibGUI("combobox", elementName, "LibGUI_ComboBox_DefaultResizableMedium_Template")
    elseif elementType == "mediumlargecombobox" then
        newElement = LibGUI("combobox", elementName, "LibGUI_ComboBox_DefaultResizableMediumLarge_Template")
	else
		newElement = LibGUI("combobox", elementName, elementBase)
	end
	
	--newElement.OnLButtonDown = function() EA_ChatWindow.Print(L"Pressed") CurrentCombobox = newElement end	-- overloading OnLButtonDown breaks the combobox!
	-- apparently nothing works with comboboxes; not even OnLButtonDown; this is getting ridiculous
	newElement.clickWindow = LibGUI("button")
	newElement.clickWindow:Parent(newElement)
	newElement.clickWindow:Layer("overlay")
	newElement.clickWindow:Alpha(0)
	newElement.clickWindow:AnchorTo(newElement, "topleft", "topleft", 0, 0)
	newElement.clickWindow:AddAnchor(newElement, "bottomright", "bottomright", 0, 0)
	newElement.clickWindow.OnLButtonDown = function() CurrentCombobox = newElement end
	
	-- since the metatable magic of LibGUI is a little beyond me, just define an empty funtion to be overloaded
	newElement.OnSelChanged = empty_function
	
	return newElement
end

function LibGUIComboboxer.OnSelChanged()
	CurrentCombobox.OnSelChanged()
	-- clean up reference
	CurrentCombobox = empty_function
end