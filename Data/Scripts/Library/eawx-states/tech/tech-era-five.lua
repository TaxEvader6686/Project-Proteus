require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

return {
    on_enter = function(self, state_context)

        self.NCMPEvent = false
        self.ViscountEvent = false

        self.entry_time = GetCurrentTime()
		
		Set_Fighter_Research("Ewing")

        if self.entry_time <= 5 then
            UnitUtil.SetLockList("REBEL", {
                "MC80_Liberty",
                "MC30c",
                "MC40a",
                "New_Republic_Army_Trooper_Company",
                "New_Republic_T47_Airspeeder_Company",
                "Incom_HQ",
                "Bulwark_III",
                "Jedi_Temple",
                "New_Republic_Jedi_Knight_Company",
                "Nebulon_B_Frigate",
                "Nebulon_B_Tender",
            }, false)

            UnitUtil.SetLockList("REBEL", {
                "Wedge_Lusankya_Dummy",
                "Sacheen",
                "Hajen",
                "Corona",
                "Belarus",
                "Republic_Star_Destroyer",
                "Snunb_Resolve_Dummy",
                "REC_HQ"
            })

            UnitUtil.SetLockList("EMPIRE", {
                "Executor_Star_Dreadnought",
                "Eidolon",
                "Imperial_Dark_Jedi_Company",
                "PX10_Company",
                "AT_ST_Company",
                "Imperial_AT_AT_Walker_Company",
                -- Historical-only units
                "Navy_Commando_Company",
				"Dark_Trooper_Phase_II_Company",
				"AT_XT_Company",
				"AT_AA_Missile_Walker_Company",
				"SPMAT_Company",
				"Imperial_Flashblind_Company",
				"Customs_Corvette",
				"Vigil",
				"Surveyor_Frigate",
				"Battle_Horn",
				"Gladiator_I",
				"Imperial_II_Frigate",
				"Immobilizer_418_Refit",
				"Acclamator_I_Carrier"
            }, false)

            UnitUtil.SetLockList("EMPIRE", {
                "Delta_JV7_Group",
                "Cygnus_HQ",
                "Imperial_AT_AT_Walker_Turbolaser_Refit_Company",
                "AT_ST_A_Company",
				"Imperial_Stormtrooper_Company"
            })
            
			UnitUtil.SetLockList("GREATER_MALDROOD", {
                "Crimson_Victory_II_Star_Destroyer",
				-- Historical-only units
				"Victory_II_Star_Destroyer",
				"Secutor_Star_Destroyer"
            })

            UnitUtil.SetLockList("PENTASTAR", {
                "Cygnus_HQ",
                "Merkuni_HQ"
            })

            UnitUtil.SetLockList("CORPORATE_SECTOR", {
                "MTC_Combat",
                "MTC_Support"
            })
			
			UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "Tarkin_Estates"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "TaggeCo_HQ",
                "GormTalquist_HQ",
                "Delvardus_Thalassa_Dummy"
            }, false)

            UnitUtil.SetLockList("GREATER_MALDROOD", {
                "TaggeCo_HQ",
                "GormTalquist_HQ"
            }, false)

            UnitUtil.SetLockList("PENTASTAR", {
                "TaggeCo_HQ",
                "GormTalquist_HQ"
            }, false)

            UnitUtil.SetLockList("ZSINJ_EMPIRE", {
                "TaggeCo_HQ",
                "GormTalquist_HQ"
            }, false)
			
			UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
                "Imperial_Army_Guard_Company"
            })
			
			UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
				"TIE_Crawler_Company",
				"Dragon_Heavy_Cruiser",
				"Marauder_Cruiser",
				"Customs_Corvette",
				"Raider_I_Corvette",
				"CR92A",
				"Eidolon",
				"Pursuit_Light_Cruiser",
				"Persuader_Company",
				"Imperial_AT_AP_Walker_Company",
				"AT_MP_Company",
				"Torpedo_Sphere",
				"Venator_Star_Destroyer",
				"Raptor_Trooper_Company",
                "TaggeCo_HQ",
				"CEC_HQ",
				"TransGalMeg_HQ",
				"Bulwark_I"
            }, false)
        else
            UnitUtil.SetLockList("CORPORATE_SECTOR", {
                "MTC_Combat",
                "MTC_Support"
            })
        end
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}