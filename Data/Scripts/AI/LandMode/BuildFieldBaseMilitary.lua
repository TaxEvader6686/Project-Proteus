require("pgevents")

-- Build a field base.

function Definitions()
	
	Category = "Build_Field_Base"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Rebel_Field_Military_Base | UC_Teradoc_Field_Military_Base | UC_Zsinj_Field_Military_Base | UC_EotH_Field_Military_Base | UC_Corporate_Sector_Field_Military_Base | UC_Eriadu_Field_Military_Base | UC_Pentastar_Field_Military_Base | UC_Hapes_Field_Galney_Base | UC_Hutt_Cartels_Field_Military_Base | UC_Imperial_Proteus_Field_Military_Base | UC_Proteus_Army_Guard_Field_Military_Base | UC_Proteus_Navy_Trooper_Field_Military_Base | UC_Proteus_Galactic_Marine_Field_Military_Base | UC_Proteus_Dragon_Trooper_Field_Military_Base | UC_Proteus_Army_Trooper_DSD1_Field_Military_Base | UC_Proteus_Citadel_Guardsman_Field_Military_Base | UC_Proteus_Raptor_Trooper_Field_Military_Base | UC_Proteus_Navy_Commando_Field_Military_Base | UC_Proteus_Shadow_Stormtrooper_Field_Military_Base | UC_Proteus_Force_Cultist_Field_Military_Base | UC_Proteus_Special_Missions_Field_Military_Base | UC_Proteus_Local_Military_Field_Military_Base | UC_Proteus_Special_Missions_Compforce_Field_Military_Base | UC_Proteus_Compforce_Field_Military_Base | UC_Proteus_Army_Guard_Light_Mercenary_Field_Military_Base | UC_Proteus_Clone_Phase_II_Field_Military_Base | UC_Proteus_Stormtrooper_Galactic_Marine_Field_Military_Base | UC_Proteus_Stormtrooper_Faux_Stormtrooper_Field_Military_Base | UC_Proteus_Light_Field_Mercenary_Base | UC_Proteus_Standard_Field_Mercenary_Base = 1"
	}
	}

end

function MainForce_Thread()
	-- Build the task force
	-- Blocking shouldn't be necessary, but we'll use it to ease watching the script
	MainForce.Set_Plan_Result(true)
	BlockOnCommand(MainForce.Build_All())
	ScriptExit()
end



