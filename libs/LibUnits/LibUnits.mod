<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<UiMod name="LibUnits" version="1.0.1" date="18/11/2010" >

	<Author name="Philosound aka Wothor" email="philosound@gmail.com" />
	<Description text="LibUnits" />
	<VersionSettings gameVersion="1.4.0" windowsVersion="1.0" savedVariablesVersion="1.0" />

	<Dependencies>
		<Dependency name="EASystem_Utils" />
		<Dependency name="EASystem_TargetInfo" />
	</Dependencies>

	<Files>
		<File name="TargetInfoFix.lua" />
		<File name="LibFormationMode.lua" />
		<File name="LibUnits.lua" />
	</Files>

	<SavedVariables>
	</SavedVariables>

	<OnInitialize>
	</OnInitialize>
	
	<OnUpdate>
		<CallFunction name="LibUnits.OnUpdate" />
	</OnUpdate>
	
	<WARInfo>
		<Categories>
			<Category name="GROUPING" />
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
