require("pgevents")

-- Build a field base.

function Definitions()
	
	Category = "Build_Field_Base"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Empire_Field_Commando_Base | UC_Empire_Field_Scout_Base | UC_Rebel_Field_Commando_Base | UC_Teradoc_Field_Commando_Base | UC_Teradoc_Field_Scout_Base | UC_Zsinj_Field_Commando_Base | UC_EotH_Field_Commando_Base | UC_Corporate_Sector_Field_Commando_Base | UC_Eriadu_Field_Commando_Base | UC_Pentastar_Field_Commando_Base | UC_Hapes_Field_Requud_Base | UC_Imperial_Proteus_Field_Commando_Base | UC_Proteus_Scout_Trooper_Field_Commando_Base | UC_Proteus_Fleet_Commando_Field_Commando_Base | UC_Proteus_ISB_Field_Commando_Base | UC_Proteus_Army_Commando_Droideka_Field_Commando_Base | UC_Proteus_Red_Police_Field_Commando_Base | UC_Proteus_EVO_Raptor_Commando_Field_Commando_Base | UC_Proteus_EVO_Field_Commando_Base | UC_Proteus_IntSec_Field_Commando_Base | UC_Proteus_Shadow_EVO_Field_Commando_Base | UC_Proteus_PDF_Tactical_Field_Commando_Base | UC_Proteus_Nemoidian_Guard_Field_Commando_Base | UC_Proteus_Incinerator_Stormtrooper_Field_Commando_Base | UC_Proteus_Jumptrooper_Field_Scout_Base | UC_Proteus_Dark_Trooper_Field_Scout_Base | UC_Proteus_Elite_Field_Mercenary_Base | UC_Proteus_Trandoshan_Field_Mercenary_Base | UC_Proteus_Mandalorian_Soldier_Field_Mercenary_Base | UC_Proteus_Mandalorian_Commando_Field_Mercenary_Base = 1"
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



