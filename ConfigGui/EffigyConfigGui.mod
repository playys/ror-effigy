<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<UiMod name="EffigyConfigGui" version="1" date="03/15/2010" >
	<VersionSettings gameVersion="1.4.0" windowsVersion="1.0" savedVariablesVersion="1.0" />
	<Author name="Philosound" email="" />
	<Description text="Gui for Effigy Options" />

	<Dependencies>
		<Dependency name="EASystem_Utils" optional="false" forceEnable="true" />
		<Dependency name="Effigy" optional="false" forceEnable="true" />
		<!--<Dependency name="RVMOD_Manager" optional="false" forceEnable="true" />-->
		<Dependency name="RVAPI_ColorDialog" optional="false" forceEnable="true" />
		<Dependency name="RVMOD_GColorPresets" optional="true" forceEnable="true" />
	</Dependencies>

	<Files>
		<File name="LibStub.lua" />
		<File name="LibGUI.lua" />
		<File name="LibGUI_Comboboxer.xml" />
		<File name="LibGUI_Comboboxer.lua" />
		<File name="EffigyConfigGui.xml" />
		<File name="EffigyConfigGui.lua" />
		<File name="EffigyConfigGuiBar.xml" />
		<File name="EffigyConfigGuiBar.lua" />
		<File name="EffigyConfigGuiBarManagers.lua" />
		<File name="EffigyConfigGuiLayout.lua" />
		<File name="EffigyConfigGuiMisc.lua" />
		<File name="EffigyConfigGuiRules.xml" />
		<File name="EffigyConfigGuiRules.lua" />
	</Files>
	
	<OnInitialize>
		<CallFunction name="EffigyConfigGui.Initialize" />
	</OnInitialize>

	<OnUpdate />

	<OnShutdown>
		<CallFunction name="EffigyConfigGui.Shutdown" />
	</OnShutdown>

	<WARInfo>
		<Categories>
			<Category name="BUFFS_DEBUFFS" />
			<Category name="RVR" />
			<Category name="GROUPING" />
			<Category name="COMBAT" />
		</Categories>
		<Careers>
			<Career name="BLACKGUARD" />
			<Career name="WITCH_ELF" />
			<Career name="DISCIPLE" />
			<Career name="SORCERER" />
			<Career name="IRON_BREAKER" />
			<Career name="SLAYER" />
			<Career name="RUNE_PRIEST" />
			<Career name="ENGINEER" />
			<Career name="BLACK_ORC" />
			<Career name="CHOPPA" />
			<Career name="SHAMAN" />
			<Career name="SQUIG_HERDER" />
			<Career name="WITCH_HUNTER" />
			<Career name="KNIGHT" />
			<Career name="BRIGHT_WIZARD" />
			<Career name="WARRIOR_PRIEST" />
			<Career name="CHOSEN" />
			<Career name="MARAUDER" />
			<Career name="ZEALOT" />
			<Career name="MAGUS" />
			<Career name="SWORDMASTER" />
			<Career name="SHADOW_WARRIOR" />
			<Career name="WHITE_LION" />
			<Career name="ARCHMAGE" />
		</Careers>
	</WARInfo>
</UiMod>
</ModuleFile>
