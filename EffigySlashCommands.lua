-- forked of HudUnitFrames: http://war.curseforge.com/addons/huduf/
-- Credits @Metaphaze & Tannecurse

if not Effigy then Effigy = {} end
local Addon = Effigy

-- Main Slash Command registration entry point
function Addon.RegisterSlashCommands()

	if (nil ~= LibSlash) then
		Addon.RegisterWithLibSlash()
	else
		Addon.RegisterManually()
	end

end

-- LibSlash must have been found, register with that as a preference
function Addon.RegisterWithLibSlash()
    LibSlash.RegisterSlashCmd("effigy", function(input) Addon.SlashHandler(input) end)
    LibSlash.RegisterSlashCmd("unitframes", function(input) Addon.SlashHandler(input) end)
	
	if (false == LibSlash.IsSlashCmdRegistered("effigy") or false == LibSlash.IsSlashCmdRegistered("unitframes")) then
		Addon.RegisterManually()
		return
	else
		d(L"Registered with LibSlash")
	end
end

-- No LibSlash so add our handler onto the enter key
function Addon.RegisterManually()
	local orig_ChatWindow_OnKeyEnter = EA_ChatWindow.OnKeyEnter
	EA_ChatWindow.OnKeyEnter = function(...)

		local input = WStringToString(EA_TextEntryGroupEntryBoxTextInput.Text)
		local cmd, args = input:match("^/([a-zA-Z]+)[ ]?(.*)")

		if cmd then
			if ((cmd:lower() == "effigy") or (cmd:lower() == "unitframes")) then
				Addon.SlashHandler(args)
				EA_TextEntryGroupEntryBoxTextInput.Text = L""
			end
		end

		return orig_ChatWindow_OnKeyEnter(...)
	end

	d(L"Registered Manually")
end

-- Handle a command from the user
function Addon.SlashHandler(cmd)
    local opt, args = cmd:match("([a-zA-Z0-9]+)[ ]?(.*)")

	if (nil == opt) then
		if RVMOD_Manager then
			RVMOD_Manager.API_ToggleAddon("EffigyConfigGui", 2)
		elseif EffigyConfigGui then
			EffigyConfigGui.CreateStandaloneSettingsWindow()
		end
		return
	end

	if ("b" == opt) then
		if (true == DoesWindowExist("test")) then
			DestroyWindow("test")
		end
		CreateWindowFromTemplate("test", args, "Root")
		WindowSetDimensions("test", 500, 100)
		WindowClearAnchors("test")
		WindowAddAnchor("test", "center", "Root", "center", 0, 0)
		return
	end

	if ("d" == opt) then
		d(WindowGetScreenPosition("grp1RoamInvisi"))
		d(WindowGetScreenPosition("grp1Roam"))
		return
	end

	if ("k" == opt) then
		Addon.UpdateGroupInfo()
		return
	end

	if ("reset" == opt) then
		Addon.Bars = Addon.deepcopy(UFTemplates.Layouts.DefaultLayout)
		InterfaceCore.ReloadUI()
		return
	end


	if (nil == args) then
		Addon.SlashHelp()
		return
	end

	if ("create" == opt) then
		local bar = Addon.CreateBar(args)
		bar:setup()
		bar:render()
		return
	end

	if ("destroy" == opt) then
		Addon.DestroyBar(args)
		return
	end

	if ("dumpstate" == opt) then 
		Addon.DumpState(args)
		return
	end

	if ("dumpbar" == opt) then
		Addon.DumpBar(args)
		return
	end

	if ("uselayout" == opt) then
		Addon.LoadLayout(args)
		return
	end

	if ("savelayout" == opt) then
		Addon.SaveLayout(args)
		return
	end

	if ("states" == opt) then
		local str = L"Valid States: "
		for k,v in pairs(Addon.States) do
			str = str..towstring(k)..L", "
		end
		EA_ChatWindow.Print(str)
		return
	end

	if ("bars" == opt) then
		local str = L"Valid Bars: "
		for k,v in pairs(Addon.Bars) do
			str = str..towstring(k)..L", "
		end
		EA_ChatWindow.Print(str)
		return
	end

	if ("layouts" == opt) then
		str = L""
		for k,v in pairs(UFTemplates.Layouts) do
			str = str..towstring(k)..L", "
		end
		EA_ChatWindow.Print(L"Default Layouts:"..str)
		str = L""
		for k,v in pairs(Addon.SavedLayouts) do
			str = str..towstring(k)..L", "
		end
		EA_ChatWindow.Print(L"Saved Layouts:"..str)
		return
	end


	if ("fakeparty" == opt) then
		Addon.CreateFakeParty()
		return
	end


	local param, value = args:match("([a-zA-Z0-9_\.]+)[ ]?(.*)")

	if ("copybar" == opt) then
		local bar = EffigyBar.CopyBar(param, value)
		bar:setup()
		bar:render()
		return
	end

	local bar = Addon.Bars[opt]
	if (nil ~= bar) then

		if ("state" == param) then
			bar:useState(value)
		elseif ("watch" == param) then
			bar:watchState(value)
		elseif ("interactive" == param) then
			if ("none" == value) then
				bar:removeInteractive()
			else
				bar:addInteractive(value)
			end
		end

		bar:setup()
		bar:render()
		return
	else
		EA_ChatWindow.Print(L"Invalid Bar: "..towstring(opt))
	end

	Addon.SlashHelp()
end


-- From: http://lua-users.org/wiki/SplitJoin
-- Compatibility: Lua-5.1
function Addon.split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end


-- Print out the help if something didn't look right
function Addon.SlashHelp()
	local valid_cmds_str = "[window] = "

	for _,v in pairs(Addon.Bars) do
		valid_cmds_str = valid_cmds_str..v.name..", "
	end

	Addon.Print(L"Options:")
	Addon.Print(L"     reset, create, destroy, copybar, uselayout, savelayout, fakeparty, layouts, bars, states, dumpbar, dumpstate")
	Addon.Print(L"     [window] [opt_value] [value]")
	Addon.Print(L"")
	Addon.Print(L" "..towstring(valid_cmds_str))
	Addon.Print(L" [opt_value] = (please see website, too many to list)")
	Addon.Print(L" [value] = dependent on option choosen")
	Addon.Print(L"")
	Addon.Print(L" Please see the addon page on war.curse.com for more information")
end

