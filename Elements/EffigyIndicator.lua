-- forked of HudUnitFrames: http://war.curseforge.com/addons/huduf/
-- Credits @Avatar of Metaphaze & Tannecurse

if not Effigy then Effigy = {} end
-- Make addon table ref local for performance
local Addon = Effigy
--if not EffigyElement then EffigyElement = {} end --only occurrence in code?
EffigyIndicator = {}
EffigyIndicator.__index = EffigyIndicator


function EffigyIndicator:newInstance()
    local new_inst = {}
    setmetatable( new_inst, EffigyIndicator_mt ) 
    return new_inst
end

-- Overload
function EffigyIndicator:setup()
	if (LayoutEditor.isActive == true) then return end
	d("Indicator Setup must be overloaded")
	return nil
end
	
function EffigyIndicator:render()
	if (LayoutEditor.isActive == true) then return end
	d("Indicator render must be overloaded")
	return nil
end

-- NonOverload	
function EffigyIndicator:hide()
	--if not self.name or not self.initialized then
	if not self.name or not UF_RUNTIMECACHE[self.name].initialized then
		return
	end
	WindowSetShowing(self.name, false)
end
	
function EffigyIndicator:show()
	if not self.name then return end
	WindowSetShowing(self.name, true)
end
	
--[[function EffigyIndicator:TintElement(elementName,r,g,b,ruleset)
	if (ruleset and ruleset ~= "none") then
		local color = Addon.Colouring.GetColour(ruleset, Addon.States[self.state])
	    if (color and color.r ~= nil and color.g ~= nil and color.b ~= nil)
	    then
	    	WindowSetTintColor(elementName,
	                           color.r,
	                           color.g,
	       	                   color.b)
		else
	    	WindowSetTintColor(elementName, r, g, b)
	    end
	end
end
]]--

--[[function EffigyIndicator:place(x, y)
	self.x = x
	self.y = y
	
	self:render()
	
	return self
end
]]--

-- State
function EffigyIndicator:fixStates()
    if (nil ~= Addon.States[self.state]) then
        self:useState(self.state)
    end

    local watching_bk = Addon.deepcopy(self.watching_states)
    self.watching_states = {}
    for _,v in ipairs(watching_bk) do
        self:watchState(v)
    	--d(self.name, v)
	end
	
	if self:isInteractive() then self:addInteractive(self.interactive_type) end
    return self
end

function EffigyIndicator:useState(name)
    if (nil == Addon.States[name]) then
        EA_ChatWindow.Print(L"That state does not exist")
        return
    end

    if (nil ~= self.state) then
        Addon.States[self.state]:unregisterBar(self)
    end

    self.state = name

    EffigyState.registerBars(self.state,self)
    return self
end

function EffigyIndicator:watchState(name)
    if (nil == Addon.States[name]) then
        EA_ChatWindow.Print("That state does not exist")
        return
    end

    EffigyState.registerBars(self.state,self)
    --Addon.States[name]:registerBar(self)
    table.insert(self.watching_states, name)

    return self
end

function EffigyIndicator:stopWatchingState(name)
    Addon.States[name]:unregisterBar(self)

    for k, v in ipairs(self.watching_states) do
        if (v == name) then
            table.remove(self.watching_states, k)
        end
    end

    return self
end

-- Interactive
function EffigyIndicator:isInteractive() return (self.interactive_type and self.interactive_type ~= "none") end

function EffigyIndicator:addInteractive(interactive_type)
    WindowSetHandleInput(self.name, true)

    --self.interactive = true
    self.interactive_type = interactive_type

    if ("player" == interactive_type) then
        WindowSetGameActionData(self.name, GameData.PlayerActions.SET_TARGET, 0, GameData.Player.name)
    end
end

function EffigyIndicator:removeInteractive()
    WindowSetHandleInput(self.name, false)

    --self.interactive = false
    self.interactive_type = "none"
end
