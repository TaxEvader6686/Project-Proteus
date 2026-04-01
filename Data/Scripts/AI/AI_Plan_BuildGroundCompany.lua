require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Ground_Company"
	IgnoreTarget = true
	TaskForce = {
	{
		"StructureForce",
		"Aratech_HQ | Balmorran_Arms_HQ | Bespin_Motors_HQ | CEC_HQ | CEDF_HQ | Colicoid_HQ | Cloning_HQ | Damorian_HQ | Hoersch_Kessel_HQ | Incom_HQ | KDY_HQ | KDY_HQ_Cheap | Mandal_Motors_HQ | Mekuun_HQ | Rendili_HQ | Rendili_HQ_Cheap | Sorosuub_HQ | Sorosuub_HQ_Cheap | Taim_Bak_HQ | TransGalMeg_HQ | Ubrikkian_HQ | Ubrikkian_HQ_Cheap | ADC_HQ | Arakyd_HQ | Baktoid_HQ | Bothawui_HQ | Carida_Academy | Cygnus_HQ | Galentro_HQ | GormTalquist_HQ | KDY_Branch | KDY_Branch_Cheap | Koensayr_HQ | Loronar_HQ | MCS_HQ | Merkuni_HQ  | Metalworks_Guild_HQ | NenCarvon_HQ | Nettehi_HQ | Olanji_Charubah_HQ | Rapacc_HQ | REC_HQ | Rossum_HQ | SecuriTech_HQ | Sienar_HQ | Sienar_HQ_Cheap | Slayn_Korpil | Solitair_HQ | TaggeCo_HQ | Tarkin_Estates | Telgorn_HQ | Ulban_HQ | Uulshos_HQ | Yutrane_Trackata_HQ | zZip_HQ | Biscuit_Baron | Ubiqtorate_Base = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function StructureForce_Thread()
	DebugMessage("%s -- In StructureForce_Thread.", tostring(Script))
	
	StructureForce.Set_As_Goal_System_Removable(false)
	AssembleForce(StructureForce)
	
	StructureForce.Set_Plan_Result(true)
	--Clean out MajorItem budget
	Budget.Flush_Category("MajorItem")
	DebugMessage("%s -- StructureForce done!", tostring(Script));
	ScriptExit()
end

function StructureForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end