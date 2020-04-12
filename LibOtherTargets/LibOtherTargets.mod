<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<UiMod name="LibOtherTargets" version="0.75-beta" date="2009-10-18T14:07:48Z">
	<Author name="Philosound aka Wothor; forked off Targeta by Differential and Eowoyn" email="no@way"/>
	<VersionSettings gameVersion="1.4.0" windowsVersion="1.0" savedVariablesVersion="1.0"/>
	<Description text="Player target helper"/>

	<Dependencies>
		<Dependency name="LibSlash"/>
		<Dependency name="EASystem_Strings"/>
		<Dependency name="EASystem_Utils"/>
		<Dependency name="EASystem_TargetInfo"/>
		<Dependency name="EASystem_LayoutEditor"/>
		<Dependency name="LibUnits" optional="true" forceEnable="true" />
	</Dependencies>

	<Files>
		<File name="OtherTargetList.lua"/>
		<File name="LibOtherTargets.lua"/>
	</Files>

	<OnInitialize>
		<CallFunction name="LibOtherTargets.Initialize"/>
	</OnInitialize>

	<SavedVariables>
		<SavedVariable name="LibOtherTargets.saved"/>
	</SavedVariables>

	<OnUpdate>
		<CallFunction name="LibOtherTargets.update"/>
	</OnUpdate>

	<OnShutdown/>


	<WARInfo>
		<Categories>
			<Category name="SYSTEM" />
			<Category name="DEVELOPMENT" />
		</Categories>
		<Careers />
	</WARInfo>
</UiMod>
</ModuleFile>