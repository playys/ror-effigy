<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<UiMod name="Effigy" version="2.6.7.4" date="02/02/2011" >

	<Author name="Philosound aka Wothor" email="philosound@gmail.com" />
	<Description text="Unit Frames based on HudUnitFrames by Metaphaze and Tannecurse" />
	<VersionSettings gameVersion="1.4.0" windowsVersion="1.0" savedVariablesVersion="1.0" />

	<Dependencies>
		<Dependency name="EASystem_LayoutEditor" />
		<Dependency name="EASystem_WindowUtils" />
		<Dependency name="EA_PlayerMenu" />
		<Dependency name="EASystem_Strings" />
		<Dependency name="EASystem_Utils" />
		<Dependency name="EASystem_TargetInfo" />
		<Dependency name="EASystem_Tooltips" />
		<Dependency name="EA_MacroWindow" />
		<Dependency name="EA_ChatWindow" optional="true" forceEnable="true" />
		<Dependency name="LibSlash" optional="true" forceEnable="true" />
		<Dependency name="LibRange" optional="true" forceEnable="true" />
		<Dependency name="LibUnits" optional="false" forceEnable="true" />
		<Dependency name="LibOtherTargets" optional="false" forceEnable="true" />
	</Dependencies>

	<Files>
		<File name="LibStub.lua" />
		<File name="LibGUI.lua" />
		<File name="AceLocale-3.0.lua" />
		
		<File name="Effigy.xml" />
		<File name="EffigyConstants.lua" />
		<!-- <File name="EffigyBattleGroup.lua" /> -->
		
		<File name="States\EffigyState.lua" />
		<File name="States\EffigyStateInfo.lua" />
		<File name="States\EffigyStatePlayer.lua" />
		<File name="States\EffigyStatePets.lua" />
		<File name="States\EffigyStateTargets.lua" />
		<File name="States\EffigyStateGuild.lua" />
		<File name="States\EffigyStateCombat.lua" />
		<File name="States\EffigyStateGroup.lua" />
		<File name="States\EffigyStateCastbar.lua" />
		<File name="States\EffigyStateCastbarRespawn.lua" />
		<File name="States\EffigyStateFormation.lua" />
		<File name="States\EffigyStateCustomGroup.lua" />
		
		<File name="Update.lua" />
		<File name="Effigy.lua" />
		<File name="EffigySlashCommands.lua" />
		<File name="Elements\EffigyIndicator.lua" />
		<File name="Elements\EffigyBarDefaults.lua" />
		<File name="Elements\EffigyBar.lua" />
		<File name="Elements\EffigyIcons.lua" />
		<File name="Elements\EffigyImage.lua" />
		<File name="Elements\EffigyLabel.lua" />
		<!-- <File name="EffigyDefaultLayouts.lua" /> -->
		<File name="DefaultLayouts\Default.lua" />
		<File name="DefaultLayouts\Yak_133.lua" />
		<File name="DefaultLayouts\Yak_140.lua" />
		<File name="DefaultLayouts\Wothor.lua" />
		<File name="DefaultLayouts\Limbo.lua" />
		<File name="DefaultLayouts\HUDs.lua" />
		<File name="DefaultLayouts\Yak_Reso_Injector.lua" />
		<File name="LibSharedAssets.lua" />
		<File name="Textures\TextureManager.lua" />
		<File name="Textures\TextureManager.xml" />
		
		<File name="Rules\EffigyRule.lua" />
		<File name="Rules\EffigyRules.lua" />
	</Files>

	<SavedVariables>
            <SavedVariable name="Effigy.WindowSettings" />
			<SavedVariable name="Effigy.ProfileSettings" />
			<SavedVariable name="Effigy.SavedVarsVersion" />
			<SavedVariable name="Effigy.Bars" />
			<SavedVariable name="Effigy.SavedLayouts" global="true"/>
			<SavedVariable name="Effigy.BarTemplates" global="true"/>
			<SavedVariable name="Effigy.Rules" global="true"/>
	</SavedVariables>

	<OnInitialize>
		<CallFunction name="Effigy.Initialize" />
	</OnInitialize>
	
	<WARInfo>
		<Categories>
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
