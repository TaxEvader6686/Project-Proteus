require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

return {
    on_enter = function(self, state_context)

        self.MediatorEvent = false
        self.ViscountEvent = false
        self.NCMPEvent = false
        self.ThrawnCloneEvent = false
		
		Set_Fighter_Research("Ewing")
		Set_Fighter_Research("Kwing")

        self.entry_time = GetCurrentTime()

        if self.entry_time <= 5 then
            UnitUtil.SetLockList("REBEL", {
                "MC80_Liberty",
                "MC30c",
                "MC40a",
                "New_Republic_Army_Trooper_Company",
                "New_Republic_T47_Airspeeder_Company",
                "Incom_HQ",
                "Bulwark_III",
                "Quasar",
                "Liberator_Cruiser",
                "CR90",
                "DP20",
                "Nebulon_B_Frigate",
                "Nebulon_B_Tender",
            }, false)

            UnitUtil.SetLockList("EMPIRE", {
                "Eidolon",
                "IPV1",
                "PX10_Company",
                "AT_ST_Company",
                "Imperial_AT_AT_Walker_Company",
                "TaggeCo_HQ",
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
                "Patrol_Nebulon_B",
                "Crusader_Gunship",
                "Imperial_Dwarf_Spider_Droid_Company",
                "Imperial_AT_AT_Walker_Turbolaser_Refit_Company",
                "AT_ST_A_Company",
				"Imperial_Stormtrooper_Company",
            })

            UnitUtil.SetLockList("REBEL", {
                "Wedge_Lusankya_Dummy",
                "Agave_Corvette",
                "Warrior_Gunship",
                "Sacheen",
                "Hajen",
                "Corona",
                "Belarus",
                "Republic_Star_Destroyer", "Snunb_Resolve_Dummy",
                "REC_HQ",
                "Majestic",
                "Defender_Carrier",
                "Nebula_Star_Destroyer", "SovvDaunt2VP",
                "Endurance_Fleet_Carrier", "Bell_Endurance_Dummy",
				"Brand_Yald_Dummy",
            })

            UnitUtil.SetLockList("PENTASTAR", {
                "Cygnus_HQ",
                "Merkuni_HQ",
                "Adz_Patrol_Destroyer"
            })

            UnitUtil.SetLockList("ZSINJ_EMPIRE", {
                "Adz_Patrol_Destroyer"
            })

            UnitUtil.SetLockList("GREATER_MALDROOD", {
                "Adz_Patrol_Destroyer",
				"Crimson_Victory_II_Star_Destroyer"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "Adz_Patrol_Destroyer",
				"Tarkin_Estates"
            })
			
			UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
				"Imperial_Army_Guard_Company",
                "Adz_Patrol_Destroyer"
            })

            UnitUtil.SetLockList("CORPORATE_SECTOR", {
                "MTC_Combat",
                "MTC_Support"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "TaggeCo_HQ",
                "GormTalquist_HQ",
                "Delvardus_Thalassa_Dummy"
            }, false)

            UnitUtil.SetLockList("GREATER_MALDROOD", {
                "TaggeCo_HQ",
                "GormTalquist_HQ",
				-- Historical-only units
				"Victory_II_Star_Destroyer",
				"Secutor_Star_Destroyer"
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

            self.NCMPEvent = true
        else
            UnitUtil.SetLockList("REBEL", {
                "Brand_Yald_Dummy"
            })
        end
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}