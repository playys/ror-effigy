<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<UiMod name="RVMOD_GColorPresets" version="1" date="03/15/2010" >
	<VersionSettings gameVersion="1.4.0" windowsVersion="1.0" savedVariablesVersion="1.0" />
	<Author name="Philosound" email="" />
	<Description text="Global Color Preset Storage" />

	<Dependencies>
		<Dependency name="EASystem_Utils" optional="false" forceEnable="true" />
		<!--<Dependency name="RVMOD_Manager" optional="false" forceEnable="true" />-->
		<Dependency name="RVAPI_ColorDialog" optional="false" forceEnable="true" />
	</Dependencies>

	<Files>
		<File name="LibStub.lua" />
		<File name="LibGUI.lua" />
		<File name="RVMOD_GColorPresets_FactoryPresets.lua" />
		<File name="RVMOD_GColorPresets.xml" />
		<File name="RVMOD_GColorPresets.lua" />
	</Files>
	
	<OnInitialize>
		<CallFunction name="RVMOD_GColorPresets.Initialize" />
	</OnInitialize>

	<OnUpdate />

	<OnShutdown>
		<CallFunction name="RVMOD_GColorPresets.Shutdown" />
	</OnShutdown>
	
	<SavedVariables>
		<SavedVariable name="RVMOD_GColorPresets.CurrentConfiguration" global="true"/>
	</SavedVariables>
	
	<WARInfo>
		<Categories>
			<Category name="SYSTEM" />
			<Category name="DEVELOPMENT" />
			<Category name="OTHER" />
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
