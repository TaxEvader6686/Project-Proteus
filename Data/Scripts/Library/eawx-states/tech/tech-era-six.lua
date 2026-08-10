require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

return {
    on_enter = function(self, state_context)

        self.entry_time = GetCurrentTime()

        self.GorathEvent = false
        self.NCMPEvent = false
        self.ViscountEvent = false
		
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
                "Delta_JV7_Group",
                "Cygnus_HQ",
                "Imperial_Dwarf_Spider_Droid_Company",
                "Imperial_AT_AT_Walker_Turbolaser_Refit_Company",
                "AT_ST_A_Company",
				"Imperial_Stormtrooper_Company",
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
                "IPV4",
				"Tarkin_Estates"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "IPV1"
            }, false)
			
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
				"Raider_I_Corvette",
				"Customs_Corvette",
				"Customs_Corvette",
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
            UnitUtil.SetLockList("REBEL", {
                "Jedi_Temple",
                "New_Republic_Jedi_Knight_Company"
            })

            UnitUtil.SetLockList("PENTASTAR", {
                "Adz_Patrol_Destroyer"
            })

            UnitUtil.SetLockList("ZSINJ_EMPIRE", {
                "Adz_Patrol_Destroyer"
            })

            UnitUtil.SetLockList("GREATER_MALDROOD", {
                "Adz_Patrol_Destroyer"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "Adz_Patrol_Destroyer",
                "IPV4"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "IPV1"
            }, false)

            UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
                "Adz_Patrol_Destroyer"
            })

			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus ~= nil then
				if proteus == "RAYTER" or proteus == "ELROOD" or proteus == "ISECTOR" or proteus == "TAGGE" or proteus == "BAKURA" or proteus == "TAPANI" or proteus == "PRAKITH" or proteus == "CATO_NEIMOIDIA" or proteus == "ARDA" or proteus == "LAMBDA" then
					UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
						"IPV4"
					})
					UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
						"IPV1"
					}, false)
				elseif proteus == "LUMIYA" then
					UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
						"GORATH_RESEARCH_PROTEUS"
					})
				end
			end
        end

    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}