--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            HeroFighterLibrary.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2021-05-25T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
function Get_Hero_Entries(upgrade_object)
	local heroes = {
		--Index is name of build option to open popup. For ground units tied to an orbiting unit, it is the rebuild option if one exists, or a dummy value that should not match the name of any buildable unit if it does not
		--Hero_Squadron = name of spawned squadron. Can be a table to define multiple options
		--PopupBody = name of header object for popup
		--Options = first item in sublist is popup option suffix. Locations is a list of all heroes who are associated with this option. Optionally, GroundPerception is the perception to detect these heroes for ground forms.
		--NoInit = optional parameter to prevent fighter from being automatically assigned to the first found hero on startup
		--FirstOptionInit = optional parameter to force the initial assignment to the first entry in the list instead of any option that exist when the first doesn't
		--Faction = Primary owner who is the only valid init. Optional, and Factions[1] will serve the same purpose if not defined
		--Factions = specifies faction list for ground reinforcement perceptions. If a primary faction exists it should be specified first for efficiency
		--NoPlayerInit  = NoInit if Faction is Human. Requires Faction/Factions
		--GroundCompany = name of company to add to reinforcements when squadron/ship is in orbit. Requires GroundPerception and Factions. Can be a table to define multiple options
		--NoSpawnFlag = name of global variable that will prevent spawn. If used the squadron will not be cleared even if Enabler is set
		--Enabler = name of object used to reenable ground forms of fighter squadrons when killed. If not set the hero will not be unassigned and disabled
		--DeathMessage = The string to display when a GroundCompany is killed. Optional field
		--Hero_Squadron and GroundCompany multiple values default to the first listed. Others are accessed through Set_Fighter_Hero_Index and Set_Fighter_Hero_Ground_Index, with arguements of the index and name of the new value
		
		--When piggybacking reinforcement system to check for orbital object instead of squadron, set a dummy index that does not match any buildable object and set NoInit to prevent all the missing fields from causing errors. 
		--GroundReinforcementPerception = the perception to detect when a unit is in orbit. Requires Faction and GroundCompany
		--NoSpawnFlag = name of global variable that will prevent spawn
		
		--WARNING: using indexes with too long of names can prevent them from working in grount tactical. It makes no sense, but watch that
		
		-- Galactic Empire
		["SOONTIR_FEL_181ST_LOCATION_SET"] = {
			Hero_Squadron = "SOONTIR_FEL_181ST_SQUADRON",
			NoInit = true,
			PopupBody = "SOONTIR_FEL_181ST_SELECTOR_BODY",
			Options = {
				--Pestage regime
				{"ROGRISS", Locations = {"ROGRISS_AGONIZER","ROGRISS_AURORA","ROGRISS_DOMINION"}},
				--Palpatine, Jax, Daala, & Pellaeon regime assignments shared w/ Phennir
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"KLEV", Locations = {"KLEV_SILENCER_7_FRIGATE","KLEV_SILENCER_7_DESTROYER","KLEV_SILENCER_7_BATTLECRUISER"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"ARDAX", Locations = {"ARDAX_VENDETTA"}},
				{"EXECUTOR", Locations = {"EXECUTOR_STAR_DREADNOUGHT"}}
			}
		},
		["TURR_PHENNIR_TIE_INTERCEPTOR_LOCATION_SET"] = {
			Hero_Squadron = "TURR_PHENNIR_TIE_INTERCEPTOR_181ST_SQUADRON",
			PopupBody = "TURR_PHENNIR_SELECTOR_BODY",
			Options = {
				--Isard + CCOGM regime
				{"ROGRISS", Locations = {"ROGRISS_AGONIZER","ROGRISS_AURORA","ROGRISS_DOMINION"}},
				--Isard regime
				{"MAKATI", Locations = {"MAKATI_STEADFAST"}},
				--CCOGM regime
				{"TAKEL", Locations = {"TAKEL_MAGICDRAGON"}},
				--Thrawn regime
				{"BRANDEI", Locations = {"BRANDEI_JUDICATOR"}},
				{"DORJA", Locations = {"DORJA_RELENTLESS"}},
				--Palpatine, Jax, Daala, & Pellaeon regime assignments shared w/ Fel
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"KLEV", Locations = {"KLEV_SILENCER_7_FRIGATE","KLEV_SILENCER_7_DESTROYER","KLEV_SILENCER_7_BATTLECRUISER"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"ARDAX", Locations = {"ARDAX_VENDETTA"}},
				{"EXECUTOR", Locations = {"EXECUTOR_STAR_DREADNOUGHT"}}
			}
		},
		["TURR_PHENNIR_TIE_DEFENDER_LOCATION_SET"] = {
			Hero_Squadron = "TURR_PHENNIR_TIE_DEFENDER_181ST_SQUADRON",
			NoInit = true,
			PopupBody = "TURR_PHENNIR_SELECTOR_BODY",
			Options = {
				--Isard + CCOGM regime
				{"ROGRISS", Locations = {"ROGRISS_AGONIZER","ROGRISS_AURORA","ROGRISS_DOMINION"}},
				--Isard regime
				{"MAKATI", Locations = {"MAKATI_STEADFAST"}},
				--CCOGM regime
				{"TAKEL", Locations = {"TAKEL_MAGICDRAGON"}},
				--Thrawn regime
				{"BRANDEI", Locations = {"BRANDEI_JUDICATOR"}},
				{"DORJA", Locations = {"DORJA_RELENTLESS"}},
				--Palpatine, Jax, Daala, & Pellaeon regime assignments shared w/ Fel
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"KLEV", Locations = {"KLEV_SILENCER_7_FRIGATE","KLEV_SILENCER_7_DESTROYER","KLEV_SILENCER_7_BATTLECRUISER"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"ARDAX", Locations = {"ARDAX_VENDETTA"}}
			}
		},
		["MAAREK_STELE_181ST_LOCATION_SET"] = {
			Hero_Squadron = "MAAREK_STELE_181ST_SQUADRON",
			NoInit = true,
			PopupBody = "MAAREK_STELE_181ST_SELECTOR_BODY",
			Options = {
				--only options needed for historicals FIP & Caamas
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_GRAND","PELLAEON_MEGADOR"}},
				{"DAALA", Locations = {"DAALA_SCYLLA"}},
				{"DORJA", Locations = {"DORJA_RELENTLESS"}},
				{"FLIM", Locations = {"FLIM_TIERCE_IRONHAND"}},
			}
		},
		["SHADOW_SQUADRON_LOCATION_SET"] = {
			Hero_Squadron = "BROADSIDE_SHADOW_SQUADRON",
			PopupBody = "SHADOW_SQUADRON_SELECTOR_BODY",
			Options = {
				{"BRASHIN", Locations = {"BRASHIN_INQUISITOR"}},
				{"KERMEN", Locations = {"KERMEN_BELLIGERENT"}},
				{"KRENNEL", Locations = {"KRENNEL_RECKONING"}},
				{"DENN_WESSEX", Locations = {"WESSEX_REDOUBT"}},
				{"CRONAL", Locations = {"CRONAL_SINGULARITY"}},
				{"BALAN", Locations = {"BALAN_JAVELIN"}},
				{"EXECUTOR", Locations = {"EXECUTOR_STAR_DREADNOUGHT"}}
			}
		},
		["SCIMITAR_SQUADRON_LOCATION_SET"] = {
			Hero_Squadron = "RHYMER_SCIMITAR_SQUADRON",
			NoInit = true,
			PopupBody = "SCIMITAR_SQUADRON_SELECTOR_BODY",
			Options = {
				{"HISSA", Locations = {"HISSA_MOFFSHIP"}},
				{"TIGELLINUS", Locations = {"TIGELLINUS_AVATAR"}},
				{"DUNHAUSEN", Locations = {"DUNHAUSEN_ESPA"}},
				{"THISTLEBORN", Locations = {"THISTLEBORN_DARKGREETER"}},
				{"LANOX", Locations = {"LANOX_HAZARD"}},
				{"PANAKA", Locations = {"PANAKA_THEED"}},
				{"GRUNGER", Locations = {"GRUNGER_AGGRESSOR"}},
				{"EXECUTOR", Locations = {"EXECUTOR_STAR_DREADNOUGHT"}}
			}
		},
		["VESSERY_STRANGER_LOCATION_SET"] = {
			Hero_Squadron = "VESSERY_STRANGER_SQUADRON",
			PopupBody = "VESSERY_SELECTOR_BODY",
			Options = {
				{"ISARD", Locations = {"ISARD_LUSANKYA"}},
				{"DEVLIA", Locations = {"DEVLIA_IEC"}},
				{"CONVARION", Locations = {"CONVARION_CORRUPTER"}},
				{"LIRA_WESSEX", Locations = {"WESSEX_DAUNTLESS"}},
				{"NICLARA", Locations = {"NICLARA_PULSARS_REVENGE"}},
				{"KEDLER", Locations = {"KEDLER_ELEOS"}},
				{"EXECUTOR", Locations = {"EXECUTOR_STAR_DREADNOUGHT"}}
			}
		},
		["ERISI_DLARIT_LOCATION_SET"] = {
			Hero_Squadron = "ERISI_DLARIT_ELITE_SQUADRON",
			PopupBody = "ERISI_DLARIT_SELECTOR_BODY",
			Options = {
				{"ISARD", Locations = {"ISARD_LUSANKYA"}},
				{"YONKA", Locations = {"YONKA_AVARICE"}},
				{"CONVARION", Locations = {"CONVARION_CORRUPTER"}},
				{"LIRA_WESSEX", Locations = {"WESSEX_DAUNTLESS"}},
				{"NICLARA", Locations = {"NICLARA_PULSARS_REVENGE"}},
				{"KEDLER", Locations = {"KEDLER_ELEOS"}},
			}
		},
		["XECR_NIST_DARK_SIDE_LOCATION_SET"] = {
			Hero_Squadron = "XECR_NIST_DARK_SIDE_SQUADRON",
			NoInit = true,
			PopupBody = "XECR_NIST_DARK_SIDE_SELECTOR_BODY",
			Options = {
				{"ECLIPSE", Locations = {"ECLIPSE_STAR_DREADNOUGHT"}},
				{"SOVEREIGN", Locations = {"SOVEREIGN_STAR_DREADNOUGHT"}},
				{"KLEV", Locations = {"KLEV_SILENCER_7_FRIGATE","KLEV_SILENCER_7_DESTROYER","KLEV_SILENCER_7_BATTLECRUISER"}},
				{"PRAJI", Locations = {"PRAJI_SECUTOR"}},
				{"PELLAEON", Locations = {"PELLAEON_13X","PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"BRASHIN", Locations = {"BRASHIN_INQUISITOR"}},
				{"LANOX", Locations = {"LANOX_HAZARD"}},
				{"BRANDEI", Locations = {"BRANDEI_JUDICATOR"}},
				{"NERVI", Locations = {"NERVI_BLOOD_AMBITION"}},
				{"DARILLIAN", Locations = {"DARILLIAN_NIGHT_CALLER"}},
				{"PRITTICK", Locations = {"PRITTICK_CONQUEST"}},
				{"SYSCO", Locations = {"SYSCO_VENGEANCE"}},
			}
		},
		["REBUILD_BRASHIN"] = {
			NoInit = true,
			GroundReinforcementPerception = "Brashin_In_Orbit",
			GroundCompany = "BRASHIN_TRMB_TEAM",
			Factions = {"Empire"},
			NoSpawnFlag = "BRASHIN_TRMB_DEAD",
			DeathMessage = "General Brashin's TR-MB has been destroyed and must be replaced."
		},
		["TYBER_ZANN_GROUND_NOREBUILD"] = {
			NoInit = true,
			GroundReinforcementPerception = "Zann_In_Orbit",
			GroundCompany = "TYBER_ZANN_TEAM",
			Factions = {"Zsinj_Empire", "Empire", "Pentastar", "Greater_Maldrood", "Eriadu_Authority", "Imperial_Proteus"},
			NoSpawnFlag = "DEPLOYED_TYBER_ZANN_DEAD",
			DeathMessage = "Tyber Zann has been wounded and can no longer fight on land."
		},
		["GRODIN_TIERCE_GROUND_NOREBUILD"] = {
			NoInit = true,
			GroundReinforcementPerception = "Flim_Tierce_In_Orbit",
			GroundCompany = "GRODIN_TIERCE_TEAM",
			Factions = {"Empire"},
			NoSpawnFlag = "DEPLOYED_GRODIN_TIERCE_DEAD",
			DeathMessage = "Grodin Tierce has been wounded and can no longer fight on land."
		},
		-- Zsinj
		["TETRAN_COWALL_LOCATION_SET"] = {
			Hero_Squadron = "TETRAN_COWALL_FALSE_181ST_SQUADRON",
			Faction = "Zsinj_Empire",
			PopupBody = "TETRAN_COWALL_SELECTOR_BODY",
			Options = {
				{"ZSINJ", Locations = {"ZSINJ_IRON_FIST_VSD","ZSINJ_IRON_FIST_EXECUTOR"}},
				{"RASLAN", Locations = {"RASLAN_RAZORS_KISS"}},
				{"NABYL", Locations = {"NABYL_HAWKBAT"}},
				{"DARILLIAN", Locations = {"DARILLIAN_NIGHT_CALLER"}},
				{"TRIGIT", Locations = {"TRIGIT_IMPLACABLE"}},
				{"VENGEANCE", Locations = {"VENGEANCE_STAR_DREADNOUGHT"}}
			}
		},
		["JAG_127TH_LOCATION_SET"] = {
			Hero_Squadron = "JAG_127TH_SQUADRON",
			Factions = {"Zsinj_Empire", "Empire", "Pentastar", "Greater_Maldrood", "Eriadu_Authority", "Imperial_Proteus"},
			PopupBody = "JAG_127TH_SELECTOR_BODY",
			Options = {
				{"SCREED", Locations = {"SCREED_DEMOLISHER"}, GroundPerception = "Screed_In_Orbit"},
				{"BANJEER", Locations = {"BANJEER_QUASAR","BANJEER_NEUTRON"}, GroundPerception = "Banjeer_In_Orbit"},
				{"JOSHI", Locations = {"JOSHI_PROVOCATEUR"}, GroundPerception = "Joshi_In_Orbit"},
				{"CRONAL", Locations = {"CRONAL_SINGULARITY"}, GroundPerception = "Cronal_In_Orbit"},
				{"TOULER", Locations = {"TOULER_KORASA_MAZE"}, GroundPerception = "Touler_In_Orbit"},
				{"GROT", Locations = {"GROT_RESOLUTION"}, GroundPerception = "Grot_In_Orbit"},
			},
			GroundCompany = "JAG_127TH_TEAM",
			Enabler = "REFORM_127TH",
			DeathMessage = "The 127th has taken crippling casualties and must be reformed.",
		},
		-- Eriadu
		["NERWAL_AVENGER_LOCATION_SET"] = {
			Hero_Squadron = "NERWAL_AVENGER_SQUADRON",
			Faction = "Eriadu_Authority",
			PopupBody = "NERWAL_AVENGER_SELECTOR_BODY",
			Options = {
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"PRITTICK", Locations = {"PRITTICK_CONQUEST"}},
				{"HUBLIN", Locations = {"HUBLIN_KABALIAN_CROSS"}},
				{"PELLAEON", Locations = {"PELLAEON_13X","PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PRENTIOCH", Locations = {"PRENTIOCH_PRENTIOCH"}},
				{"SAHREEL", Locations = {"SAHREEL_IMPENDING_DOOM"}},
				{"TROMMER", Locations = {"TROMMER_RAVAGOR"}},
				{"ASSERTOR", Locations = {"ASSERTOR_STAR_DREADNOUGHT"}}
			}
		},
		["REXLER_BRATH_ONYX_LOCATION_SET"] = {
			Hero_Squadron = "REXLER_BRATH_ONYX_SQUADRON",
			Faction = "Eriadu_Authority",
			PopupBody = "REXLER_BRATH_ONYX_SELECTOR_BODY",
			Options = {
				{"PRITTICK", Locations = {"PRITTICK_CONQUEST"}},
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"RESUUN", Locations = {"RESUUN_RETRIBUTION"}},
				{"PRAJI", Locations = {"PRAJI_SECUTOR"}},
				{"PELLAEON", Locations = {"PELLAEON_13X","PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"ZED", Locations = {"ZED_STALKER"}},
				{"RAVEEN", Locations = {"RAVEEN_PREDOMINANT"}},
				{"ASSERTOR", Locations = {"ASSERTOR_STAR_DREADNOUGHT"}}
			}
		},
		["REDLINE_BLACK_EIGHT_LOCATION_SET"] = {
			Hero_Squadron = "REDLINE_BLACK_EIGHT_SQUADRON",
			Faction = "Eriadu_Authority",
			PopupBody = "REDLINE_BLACK_EIGHT_SELECTOR_BODY",
			Options = {
				{"HUBLIN", Locations = {"HUBLIN_KABALIAN_CROSS"}},
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"PRITTICK", Locations = {"PRITTICK_CONQUEST"}},
				{"RESUUN", Locations = {"RESUUN_RETRIBUTION"}},
				{"PELLAEON", Locations = {"PELLAEON_13X","PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"HEGGEL", Locations = {"HEGGEL_TABAL"}},
				{"WALERAN", Locations = {"WALERAN_INTERROGATOR"}},
				{"YZU", Locations = {"YZU_CONSTITUTION"}},
				{"BELLATOR", Locations = {"BELLATOR_STAR_DREADNOUGHT"}}
			}
		},
		-- Greater Maldrood
		["VYNDER_RHO_LOCATION_SET"] = {
			Hero_Squadron = "VYNDER_RHO_SQUADRON",
			Faction = "Greater_Maldrood",
			PopupBody = "VYNDER_RHO_SELECTOR_BODY",
			Options = {
				{"TREUTEN", Locations = {"TREUTEN_13X","TREUTEN_CRIMSON_SUNRISE"}},
				{"NERVI", Locations = {"NERVI_BLOOD_AMBITION"}},
				{"NEOMEN", Locations = {"NEOMEN_ION_STORM"}},
				{"PELLAEON", Locations = {"PELLAEON_13X","PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"LARM", Locations = {"LARM_CARRACK"}},
				{"JAALIB", Locations = {"JAALIB_BRANDL_PROTECTORATE_I"}},
				{"TRIER", Locations = {"TRIER_SECUTOR"}},
				{"BELLATOR", Locations = {"BELLATOR_STAR_DREADNOUGHT"}}
			}
		},
		["TYRESI_BOLT_LOCATION_SET"] = {
			Hero_Squadron = "TYRESI_GURTT_BOLT_SQUADRON",
			Faction = "Greater_Maldrood",
			PopupBody = "TYRESI_GURTT_BOLT_SELECTOR_BODY",
			Options = {
				{"TAVIRA", Locations = {"TAVIRA_INVIDIOUS"}},
				{"RIIZOLO", Locations = {"RIIZOLO_NEUTRON"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"ZANN", Locations = {"TYBER_ZANN_MERCILESS"}},
				{"DELURIN", Locations = {"DELURIN_GALAXY_DRAGON"}},
				{"TORPIN", Locations = {"TORPIN_PASSENGER"}},
			}
		},
		-- Pentastar
		["TRELIX_LOCATION_SET"] = {
			Hero_Squadron = "TRELIX_INDENTURE",
			NoPlayerInit = true,
			Faction = "Pentastar",
			PopupBody = "TRELIX_SELECTOR_BODY",
			Options = {
				{"OTRO", Locations = {"OTRO_ENFORCER"}},
				{"DEKEET", Locations = {"DEKEET_INTRACTABLE"}},
				{"KAINE", Locations = {"KAINE_REAPER"}},
				{"ZANN", Locations = {"TYBER_ZANN_MERCILESS"}},
				{"PARNELL", Locations = {"PARNELL_SUPER_TRANSPORT_XI"}},
				{"DROMMEL", Locations = {"DROMMEL_GUARDIAN"}},
			}
		},
		["IMPERIAL_ACE_LOCATION_SET"] = {
			Hero_Squadron = "IMPERIAL_ACE_SQUADRON",
			Faction = "Pentastar",
			PopupBody = "IMPERIAL_ACE_SELECTOR_BODY",
			Options = {
				{"TRICO", Locations = {"TRICO_PULA"}},
				{"COROSS", Locations = {"COROSS_VENGEANCE_II"}},
				{"SYSCO", Locations = {"SYSCO_VENGEANCE"}},
				{"DEKEET", Locations = {"DEKEET_INTRACTABLE"}},
				{"BETHROGG", Locations = {"BETHROGG_BEHEMOTH"}},
				{"VANKO", Locations = {"VANKO_INVINCIBLE"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"MANDATOR_III", Locations = {"MANDATOR_III_DREADNOUGHT"}}
			}
		},
		["DEATHRAIN_LOCATION_SET"] = {
			Hero_Squadron = "DEATHRAIN_PUNISHER_SQUADRON",
			Faction = "Pentastar",
			PopupBody = "DEATHRAIN_SELECTOR_BODY",
			Options = {
				{"KAINE", Locations = {"KAINE_REAPER"}},
				{"COROSS", Locations = {"COROSS_VENGEANCE_II"}},
				{"SYSCO", Locations = {"SYSCO_VENGEANCE"}},
				{"VERPALION", Locations = {"VERPALION_WARLORD"}},
				{"GENDARR", Locations = {"GENDARR_RELIANCE"}},
				{"DARIUS", Locations = {"DARIUS_SHIELD_BREAKER"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"MANDATOR_III", Locations = {"MANDATOR_III_DREADNOUGHT"}}
			}
		},
		["WHISPER_SIGMA_LOCATION_SET"] = {
			Hero_Squadron = "WHISPER_SIGMA_SQUADRON",
			Faction = "Pentastar",
			PopupBody = "WHISPER_SELECTOR_BODY",
			Options = {
				{"GRANT", Locations = {"GRANT_ORIFLAMME"}},
				{"COROSS", Locations = {"COROSS_VENGEANCE_II"}},
				{"DEKEET", Locations = {"DEKEET_INTRACTABLE"}},
				{"SYSCO", Locations = {"SYSCO_VENGEANCE"}},
				{"WALERAN", Locations = {"WALERAN_INTERROGATOR"}},
				{"DENN_WESSEX", Locations = {"WESSEX_REDOUBT"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"MANDATOR_III", Locations = {"MANDATOR_III_DREADNOUGHT"}}
			}
		},
		-- Legitimacy
		["OBERHAUR_STORM_LOCATION_SET"] = {
			Hero_Squadron = "OBERHAUR_STORM_SQUADRON",
			NoInit = true,
			PopupBody = "OBERHAUR_STORM_SELECTOR_BODY",
			Options = {
				{"KERMEN", Locations = {"KERMEN_BELLIGERENT"}},
				{"ISARD", Locations = {"ISARD_LUSANKYA"}},
				{"HISSA", Locations = {"HISSA_MOFFSHIP"}},
				{"THRAWN_GA", Locations = {"THRAWN_CHIMAERA"}},
				{"KAINE", Locations = {"KAINE_REAPER"}},
				{"KOSH", Locations = {"KOSH_LANCET"}},
				{"TREUTEN", Locations = {"TREUTEN_13X","TREUTEN_CRIMSON_SUNRISE"}},
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"ZSINJ", Locations = {"ZSINJ_IRON_FIST_VSD","ZSINJ_IRON_FIST_EXECUTOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"RAKEHELL", Locations = {"EX_F"}},
			}
		},
		["TAM_BLACKSTAR_DARK_BLADE_LOCATION_SET"] = {
			Hero_Squadron = "TAM_BLACKSTAR_DARK_BLADE_SQUADRON",
			NoInit = true,
			PopupBody = "TAM_BLACKSTAR_DARK_BLADE_SELECTOR_BODY",
			Options = {
				{"KERMEN", Locations = {"KERMEN_BELLIGERENT"}},
				{"ISARD", Locations = {"ISARD_LUSANKYA"}},
				{"HISSA", Locations = {"HISSA_MOFFSHIP"}},
				{"THRAWN_GA", Locations = {"THRAWN_CHIMAERA"}},
				{"KAINE", Locations = {"KAINE_REAPER"}},
				{"KOSH", Locations = {"KOSH_LANCET"}},
				{"TREUTEN", Locations = {"TREUTEN_13X","TREUTEN_CRIMSON_SUNRISE"}},
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"ZSINJ", Locations = {"ZSINJ_IRON_FIST_VSD","ZSINJ_IRON_FIST_EXECUTOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"RAKEHELL", Locations = {"EX_F"}},
			}
		},
		["DEATHFIRE_GAMMA_LOCATION_SET"] = {
			Hero_Squadron = "DEATHFIRE_GAMMA_SQUADRON",
			FirstOptionInit = true,
			PopupBody = "DEATHFIRE_GAMMA_SELECTOR_BODY",
			Options = {
				{"RAVEEN", Locations = {"RAVEEN_PREDOMINANT"}},
				{"KERMEN", Locations = {"KERMEN_BELLIGERENT"}},
				{"ISARD", Locations = {"ISARD_LUSANKYA"}},
				{"HISSA", Locations = {"HISSA_MOFFSHIP"}},
				{"THRAWN_GA", Locations = {"THRAWN_CHIMAERA"}},
				{"KAINE", Locations = {"KAINE_REAPER"}},
				{"KOSH", Locations = {"KOSH_LANCET"}},
				{"TREUTEN", Locations = {"TREUTEN_13X","TREUTEN_CRIMSON_SUNRISE"}},
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"ZSINJ", Locations = {"ZSINJ_IRON_FIST_VSD","ZSINJ_IRON_FIST_EXECUTOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"RAKEHELL", Locations = {"EX_F"}},
			}
		},
		["SILVERLINE_LOCATION_SET"] = {
			Hero_Squadron = "SILVERLINE_OPPRESSOR_SQUADRON",
			FirstOptionInit = true,
			PopupBody = "SILVERLINE_OPPRESSOR_SELECTOR_BODY",
			Options = {
				{"PANAKA", Locations = {"PANAKA_THEED"}},
				{"GROT", Locations = {"GROT_RESOLUTION"}},
				{"KERMEN", Locations = {"KERMEN_BELLIGERENT"}},
				{"ISARD", Locations = {"ISARD_LUSANKYA"}},
				{"HISSA", Locations = {"HISSA_MOFFSHIP"}},
				{"THRAWN_GA", Locations = {"THRAWN_CHIMAERA"}},
				{"KAINE", Locations = {"KAINE_REAPER"}},
				{"KOSH", Locations = {"KOSH_LANCET"}},
				{"TREUTEN", Locations = {"TREUTEN_13X","TREUTEN_CRIMSON_SUNRISE"}},
				{"DELVARDUS", Locations = {"DELVARDUS_BRILLIANT","DELVARDUS_THALASSA","DELVARDUS_NIGHT_HAMMER"}},
				{"ZSINJ", Locations = {"ZSINJ_IRON_FIST_VSD","ZSINJ_IRON_FIST_EXECUTOR"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"RAKEHELL", Locations = {"EX_F"}},
			}
		},
		["LORRIR_LOCATION_SET"] = {
			Hero_Squadron = "LORRIR_TIE_INTERCEPTOR_SQUADRON",
			FirstOptionInit = true,
			PopupBody = "LORRIR_TIE_INTERCEPTOR_SELECTOR_BODY",
			Options = {
				{"KRENNEL", Locations = {"KRENNEL_WARLORD"}},
				{"DARRON", Locations = {"DARRON_DIREPTION"}},
				{"PHULIK", Locations = {"PHULIK_BINDER"}},
				{"ISARD", Locations = {"ISARD_LUSANKYA_NO_TRANSITION"}},
				{"KLEV", Locations = {"KLEV_SILENCER_7_FRIGATE","KLEV_SILENCER_7_DESTROYER","KLEV_SILENCER_7_BATTLECRUISER"}},
				{"WESSEL", Locations = {"WESSEL_EMPERORS_REVENGE"}},
				{"DAALA", Locations = {"DAALA_GORGON","DAALA_KNIGHT_HAMMER","DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
			}
		},
		["SCARLET_LOCATION_SET"] = {
			Hero_Squadron = "KATH_SCARLET",
			PopupBody = "SCARLET_SELECTOR_BODY",
			NoInit = true,
			Options = {
				{"LON_DONELL", Locations = {"LON_DONELL_DETAINER"}},
				{"RNEEKII", Locations = {"RNEEKLII_SUMPNTODO"}},
				{"SLAGORTH", Locations = {"SLAGORTH_ARC"}},
				{"HILMA", Locations = {"HILMA_BLOODTHIRSTY"}},
				{"SAIT", Locations = {"SAIT_BLACKGUARD"}},
				{"QUINCE", Locations = {"QUINCE_QUINCEYS_GIRL"}},
				{"SORORITY", Locations = {"VEILED_QUEEN_SAVRIP"}},
				{"ZAN_DANE", Locations = {"DANE_SWEET_VICTORY"}},
				{"TARGRIM", Locations = {"TARGRIM_QUASAR"}},
				{"RENTHAL", Locations = {"RENTHALS_VIGILANCE"}},
				{"THALASSIAN", Locations = {"THALASSIAN_HARMZUAY"}},
				{"AYCEN", Locations = {"AYCEN_FREEJACK"}},
				{"XUFUSH", Locations = {"XUFUSH_FALOHSUI"}},
				{"SKANDREI", Locations = {"SKANDREI_BANDITS"}},
				{"COORSHA", Locations = {"COORSHAS_CROSS"}},
				{"ARDELLA", Locations = {"ARDELLA_SMOKESWIMMER"}},
				{"DREDNAR", Locations = {"DREDNAR_SABLE_III"}},
				{"VULTURE_PIRATES", Locations = {"VULTURE_PIRATES"}},
				{"LOOSE_CANNON", Locations = {"LOOSE_CANNON_PIRATES"}},
				{"MIKTISS", Locations = {"MIKTISS_ASAGOV_RAIDER"}},
				{"KAEROBANI", Locations = {"KAEROBANI_INTERDICTOR"}},
				{"FAARL", Locations = {"FAARL_DP20"}},
				{"TYRUS", Locations = {"TYRUS_STACKED_DECK"}},
			}
		},
		["SSURUSSK_LOCATION_SET"] = {
			Hero_Squadron = "SSURUSSK_NEBULA_RAIDERS",
			PopupBody = "SSURUSSK_SELECTOR_BODY",
			NoInit = true,
			Options = {
				{"LON_DONELL", Locations = {"LON_DONELL_DETAINER"}},
				{"RNEEKII", Locations = {"RNEEKLII_SUMPNTODO"}},
				{"SLAGORTH", Locations = {"SLAGORTH_ARC"}},
				{"HILMA", Locations = {"HILMA_BLOODTHIRSTY"}},
				{"SAIT", Locations = {"SAIT_BLACKGUARD"}},
				{"QUINCE", Locations = {"QUINCE_QUINCEYS_GIRL"}},
				{"SORORITY", Locations = {"VEILED_QUEEN_SAVRIP"}},
				{"ZAN_DANE", Locations = {"DANE_SWEET_VICTORY"}},
				{"TARGRIM", Locations = {"TARGRIM_QUASAR"}},
				{"RENTHAL", Locations = {"RENTHALS_VIGILANCE"}},
				{"THALASSIAN", Locations = {"THALASSIAN_HARMZUAY"}},
				{"AYCEN", Locations = {"AYCEN_FREEJACK"}},
				{"XUFUSH", Locations = {"XUFUSH_FALOHSUI"}},
				{"SKANDREI", Locations = {"SKANDREI_BANDITS"}},
				{"COORSHA", Locations = {"COORSHAS_CROSS"}},
				{"ARDELLA", Locations = {"ARDELLA_SMOKESWIMMER"}},
				{"DREDNAR", Locations = {"DREDNAR_SABLE_III"}},
				{"VULTURE_PIRATES", Locations = {"VULTURE_PIRATES"}},
				{"LOOSE_CANNON", Locations = {"LOOSE_CANNON_PIRATES"}},
				{"MIKTISS", Locations = {"MIKTISS_ASAGOV_RAIDER"}},
				{"KAEROBANI", Locations = {"KAEROBANI_INTERDICTOR"}},
				{"FAARL", Locations = {"FAARL_DP20"}},
				{"TYRUS", Locations = {"TYRUS_STACKED_DECK"}},
			}
		},
		["STORMTROOPER_X_LOCATION_SET"] = {
			Hero_Squadron = "X_ROGUE_IMPERIAL_SQUADRON",
			PopupBody = "X_SELECTOR_BODY",
			NoInit = true,
			Options = {
				{"LON_DONELL", Locations = {"LON_DONELL_DETAINER"}},
				{"RNEEKII", Locations = {"RNEEKLII_SUMPNTODO"}},
				{"SLAGORTH", Locations = {"SLAGORTH_ARC"}},
				{"HILMA", Locations = {"HILMA_BLOODTHIRSTY"}},
				{"SAIT", Locations = {"SAIT_BLACKGUARD"}},
				{"QUINCE", Locations = {"QUINCE_QUINCEYS_GIRL"}},
				{"SORORITY", Locations = {"VEILED_QUEEN_SAVRIP"}},
				{"ZAN_DANE", Locations = {"DANE_SWEET_VICTORY"}},
				{"TARGRIM", Locations = {"TARGRIM_QUASAR"}},
				{"RENTHAL", Locations = {"RENTHALS_VIGILANCE"}},
				{"THALASSIAN", Locations = {"THALASSIAN_HARMZUAY"}},
				{"AYCEN", Locations = {"AYCEN_FREEJACK"}},
				{"XUFUSH", Locations = {"XUFUSH_FALOHSUI"}},
				{"SKANDREI", Locations = {"SKANDREI_BANDITS"}},
				{"COORSHA", Locations = {"COORSHAS_CROSS"}},
				{"ARDELLA", Locations = {"ARDELLA_SMOKESWIMMER"}},
				{"DREDNAR", Locations = {"DREDNAR_SABLE_III"}},
				{"VULTURE_PIRATES", Locations = {"VULTURE_PIRATES"}},
				{"LOOSE_CANNON", Locations = {"LOOSE_CANNON_PIRATES"}},
				{"MIKTISS", Locations = {"MIKTISS_ASAGOV_RAIDER"}},
				{"KAEROBANI", Locations = {"KAEROBANI_INTERDICTOR"}},
				{"FAARL", Locations = {"FAARL_DP20"}},
				{"TYRUS", Locations = {"TYRUS_STACKED_DECK"}},
			}
		},
		-- EotH
		["SOONTIR_FEL_GRAY_LOCATION_SET"] = {
			Hero_Squadron = "SOONTIR_FEL_GRAY_SQUADRON",
			PopupBody = "SOONTIR_FEL_GRAY_SELECTOR_BODY",
			Options = {
				{"THRAWN", Locations = {"THRAWN_GREY_WOLF"}},
				{"THRAWN_CLONE", Locations = {"THRAWN_CLONE_EVISCERATOR"}},
				{"PARCK", Locations = {"PARCK_STRIKEFAST","PARCK_CHAF_DESTROYER"}},
				{"STENT", Locations = {"STENT_THRAWNS_HAND"}},
				{"NIRIZ", Locations = {"NIRIZ_ADMONITOR"}},
				{"FEROB", Locations = {"FEROB_IRON_FIST"}},
				{"GIMALD_NURUODO", Locations = {"NURUODO_FOREAS"}},
				{"TARRAK", Locations = {"TARRAK_BOGNOG"}},
			}
		},
		["CHAK_FEL_LOCATION_SET"] = {
			Hero_Squadron = "CHAK_FEL_SQUADRON",
			NoInit = true,
			PopupBody = "CHAK_FEL_SELECTOR_BODY",
			Options = {
				{"PARCK", Locations = {"PARCK_STRIKEFAST","PARCK_CHAF_DESTROYER"}},
				{"STENT", Locations = {"STENT_THRAWNS_HAND"}},
				{"NIRIZ", Locations = {"NIRIZ_ADMONITOR"}},
				{"FEROB", Locations = {"FEROB_IRON_FIST"}},
				{"GIMALD_NURUODO", Locations = {"NURUODO_FOREAS"}},
				{"TARRAK", Locations = {"TARRAK_BOGNOG"}},
				{"THRAWN", Locations = {"THRAWN_GREY_WOLF"}},
				{"THRAWN_CLONE", Locations = {"THRAWN_CLONE_EVISCERATOR"}},
			}
		},
		["JAGGED_FEL_SPIKE_LOCATION_SET"] = {
			Hero_Squadron = "JAGGED_FEL_SPIKE_SQUADRON",
			NoInit = true,
			PopupBody = "JAGGED_FEL_SELECTOR_BODY",
			Options = {
				{"STENT", Locations = {"STENT_THRAWNS_HAND"}},
				{"PARCK", Locations = {"PARCK_STRIKEFAST","PARCK_CHAF_DESTROYER"}},
				{"NIRIZ", Locations = {"NIRIZ_ADMONITOR"}},
				{"FEROB", Locations = {"FEROB_IRON_FIST"}},
				{"GIMALD_NURUODO", Locations = {"NURUODO_FOREAS"}},
				{"TARRAK", Locations = {"TARRAK_BOGNOG"}},
				{"THRAWN", Locations = {"THRAWN_GREY_WOLF"}},
				{"THRAWN_CLONE", Locations = {"THRAWN_CLONE_EVISCERATOR"}},
			}
		},
		-- New Republic
		["TALDIRA_LOCATION_SET"] = {
			Hero_Squadron = "TALDIRA_SQUADRON_SPACE",
			NoInit = true,
			PopupBody = "TALDIRA_SELECTOR_BODY",
			--X-wing series related people and the scavenged carrier hero
			Options = {
				{"VANTAI", Locations = {"VANTAI_MOONSHADOW"}},
				{"YONKA", Locations = {"YONKA_FREEDOM"}},
				{"BELL", Locations = {"BELL_ENDURANCE","BELL_SWIFT_LIBERTY"}},
				{"MASSA", Locations = {"MASSA_LUCREHULK_CARRIER","MASSA_LUCREHULK_AUXILIARY"}},
			}
		},
		["WEDGE_ROGUES_LOCATION_SET"] = {
			Hero_Squadron = "WEDGE_ANTILLES_ROGUE_SQUADRON",
			Factions = {"Rebel"},
			PopupBody = "ANTILLES_ROGUE_SELECTOR_BODY",
			--Mostly locations where they were known to have been stationed, with a noted fighter commander for good measure
			Options = {
				{"ACKBAR", Locations = {"ACKBAR_HOME_ONE","ACKBAR_GALACTIC_VOYAGER","ACKBAR_GUARDIAN"}, GroundPerception = "Ackbar_In_Orbit"},
				{"RAGAB", Locations = {"RAGAB_EMANCIPATOR"}, GroundPerception = "Ragab_In_Orbit"},
				{"BELL", Locations = {"BELL_SWIFT_LIBERTY","BELL_ENDURANCE"}, GroundPerception = "Bell_In_Orbit"},
				{"TALLON", Locations = {"TALLON_SILENT_WATER"}, GroundPerception = "Tallon_In_Orbit"},
				{"BRAND", Locations = {"BRAND_INDOMITABLE","BRAND_YALD"}, GroundPerception = "Brand_In_Orbit"},
				{"KREFEY", Locations = {"KREFEY_RALROOST","KREFEY_RALROOST_SUPCOM"}, GroundPerception = "Krefey_In_Orbit"},
				{"VIEDAS", Locations = {"VIEDAS_SOLIDARITY"}, GroundPerception = "Viedas_In_Orbit"},
				{"WHYRRRYK", Locations = {"WHYRRRYK_OBI_WAN"}, GroundPerception = "Whyrrryk_In_Orbit"},
			},
			GroundCompany = "WEDGE_ANTILLES_ROGUE_TEAM",
			Enabler = "REFORM_ROGUES",
			DeathMessage = "Rogue Squadron has taken crippling casualties and must be reformed.",
		},
		["TYCHO_ROGUES_LOCATION_SET"] = {
			Hero_Squadron = "TYCHO_CELCHU_ROGUE_SQUADRON",
			Factions = {"Rebel"},
			PopupBody = "CELCHU_ROGUE_SELECTOR_BODY",
			NoInit = true,
			Options = {
				{"WEDGE", Locations = {"WEDGE_LUSANKYA"}, GroundPerception = "Wedge_Lusankya_In_Orbit"},
				{"ACKBAR", Locations = {"ACKBAR_HOME_ONE","ACKBAR_GALACTIC_VOYAGER","ACKBAR_GUARDIAN"}, GroundPerception = "Ackbar_In_Orbit"},
				{"RAGAB", Locations = {"RAGAB_EMANCIPATOR"}, GroundPerception = "Ragab_In_Orbit"},
				{"BELL", Locations = {"BELL_SWIFT_LIBERTY","BELL_ENDURANCE"}, GroundPerception = "Bell_In_Orbit"},
				{"TALLON", Locations = {"TALLON_SILENT_WATER"}, GroundPerception = "Tallon_In_Orbit"},
				{"BRAND", Locations = {"BRAND_INDOMITABLE","BRAND_YALD"}, GroundPerception = "Brand_In_Orbit"},
				{"KREFEY", Locations = {"KREFEY_RALROOST","KREFEY_RALROOST_SUPCOM"}, GroundPerception = "Krefey_In_Orbit"},
				{"VIEDAS", Locations = {"VIEDAS_SOLIDARITY"}, GroundPerception = "Viedas_In_Orbit"},
				{"WHYRRRYK", Locations = {"WHYRRRYK_OBI_WAN"}, GroundPerception = "Whyrrryk_In_Orbit"},
			},
			--GroundCompany = "Tycho_Celchu_Rogue_Team",
			GroundCompany = {"TYCHO_CELCHU_ROGUE_TEAM","TYCHO_CELCHU_ROGUE_TEAM_T47_AIRSPEEDER"},
			Enabler = "REFORM_ROGUES",
			DeathMessage = "Rogue Squadron has taken crippling casualties and must be reformed.",
		},
		["WEDGE_WRAITH_LOCATION_SET"] = {
			Hero_Squadron = "WRAITH_SQUADRON_SPACE",
			Factions = {"Rebel"},
			PopupBody = "WRAITH_SELECTOR_BODY",
			NoInit = true,
			--Known location, intel guy, and Bell gets everyone as her perk
			Options = {
				{"DRAYSON", Locations = {"DRAYSON_NEW_HOPE"}, GroundPerception = "Drayson_In_Orbit"},
				{"HAN_SOLO", Locations = {"HAN_SOLO_MON_REMONDA","HAN_SOLO_INTREPID"}, GroundPerception = "Han_Solo_In_Orbit"},
				{"BELL", Locations = {"BELL_ENDURANCE","BELL_SWIFT_LIBERTY"}, GroundPerception = "Bell_In_Orbit"},
			},
		},
		["SALM_LOCATION_SET"] = {
			Hero_Squadron = {"SALM_Y_WING_SQUADRON","SALM_B_WING_SQUADRON","SALM_K_WING_SQUADRON"},
			PopupBody = "SALM_SELECTOR_BODY",
			--Known locations, fighter commanders, and locations distinct from Rogues
			Options = {
				{"VANTAI", Locations = {"VANTAI_MOONSHADOW"}},
				{"BURKE", Locations = {"BURKE_REMEMBER_ALDERAAN"}},
				{"KALBACK", Locations = {"KALBACK_JUSTICE"}},
				{"ABAHT", Locations = {"ABAHT_INTREPID","ABAHT_INTREPID_SUPCOM"}},
				{"SOVV", Locations = {"SOVV_DAUNTLESS","SOVV_VOICE_OF_THE_PEOPLE","SOVV_VOICE_OF_THE_PEOPLE_SUPCOM"}},
				{"HAN_SOLO", Locations = {"HAN_SOLO_MON_REMONDA","HAN_SOLO_INTREPID"}},
				{"MASSA", Locations = {"MASSA_LUCREHULK_CARRIER","MASSA_LUCREHULK_AUXILIARY"}},
				{"KRANE", Locations = {"KRANE_RAND_ECLIPTIC"}},
			}
		},
		["RANULF_TROMMER_LOCATION_SET"] = {
			Hero_Squadron = "RANULF_TROMMER_SEER_SQUADRON",
			PopupBody = "RANULF_TROMMER_SELECTOR_BODY",
			NoInit = true,
			Options = {
				{"NANTZ", Locations = {"NANTZ_INDEPENDENCE","NANTZ_FAITHFUL_WATCHMAN","NANTZ_INDEPENDENCE_SUPCOM","NANTZ_FAITHFUL_WATCHMAN_SUPCOM"}},
				{"LANDO", Locations = {"LANDO_LIBERATOR","LANDO_ALLEGIANCE"}},
				{"DORAT", Locations = {"DORAT_ARROW_OF_SULLUST"}},
				{"HOLT", Locations = {"HOLT_SIMOOM"}},
				{"VIEDAS", Locations = {"VIEDAS_SOLIDARITY"}},
				{"IILLOR", Locations = {"IILLOR_CORUSCA_RAINBOW"}},
				{"GRANT", Locations = {"GRANT_ORIFLAMME_NR"}},
				{"SLIXIKE", Locations = {"SLIXIKE"}},
			}
		},
		["JAKE_FARRELL_LOCATION_SET"] = {
			Hero_Squadron = "JAKE_FARRELL_GREEN_SQUADRON",
			PopupBody = "JAKE_FARRELL_SELECTOR_BODY",
			--Cooperation with Tallon and Ackbar to create the A-wing, squadron present at Endor so including Nantz, and fighter commanders
			Options = {
				{"TALLON", Locations = {"TALLON_SILENT_WATER"}},
				{"NANTZ", Locations = {"NANTZ_INDEPENDENCE","NANTZ_FAITHFUL_WATCHMAN","NANTZ_INDEPENDENCE_SUPCOM","NANTZ_FAITHFUL_WATCHMAN_SUPCOM"}},
				{"ACKBAR", Locations = {"ACKBAR_HOME_ONE","ACKBAR_GALACTIC_VOYAGER","ACKBAR_GUARDIAN"}},
				{"BURKE", Locations = {"BURKE_REMEMBER_ALDERAAN"}},
				{"KALBACK", Locations = {"KALBACK_JUSTICE"}},
				{"MASSA", Locations = {"MASSA_LUCREHULK_CARRIER","MASSA_LUCREHULK_AUXILIARY"}},
				{"DORAT", Locations = {"DORAT_ARROW_OF_SULLUST"}},
				{"GRANT", Locations = {"GRANT_ORIFLAMME_NR"}},
				{"WEDGE", Locations = {"WEDGE_LUSANKYA"}},
			}
		},
		["ALEXANDRA_WINGER_LOCATION_SET"] = {
			Hero_Squadron = "ALEXANDRA_WINGER_BLUE_SQUADRON",
			PopupBody = "ALEXANDRA_WINGER_SELECTOR_BODY",
			NoInit = true,
			--Inferred stations from HfZ for squadron's dual presence in story, presence at Evacuation of Mon Calamari, association with Iblis much later on, and prominent fighter commanders
			Options = {
				{"HAN_SOLO", Locations = {"HAN_SOLO_MON_REMONDA","HAN_SOLO_INTREPID"}},
				{"BELL", Locations = {"BELL_ENDURANCE","BELL_SWIFT_LIBERTY"}},
				{"SNUNB", Locations = {"SNUNB_ANTARES_SIX","SNUNB_RESOLVE"}},
				{"RAGAB", Locations = {"RAGAB_EMANCIPATOR"}},
				{"LANDO", Locations = {"LANDO_LIBERATOR","LANDO_ALLEGIANCE"}},
				{"IBLIS", Locations = {"IBLIS_PEREGRINE","IBLIS_SELONIAN_FIRE","IBLIS_SELONIAN_FIRE_SUPCOM","IBLIS_BAIL_ORGANA","IBLIS_BAIL_ORGANA_SUPCOM","IBLIS_HARBINGER","IBLIS_HARBINGER_SUPCOM"}},
				{"ABAHT", Locations = {"ABAHT_INTREPID","ABAHT_INTREPID_SUPCOM"}},
				{"WEDGE", Locations = {"WEDGE_LUSANKYA"}},
			}
		},
		-- CSA
		["MYRSK_LOCATION_SET"] = {
			Hero_Squadron = "MYRSK_MANKVIM_SQUADRON",
			PopupBody = "MYRSK_SELECTOR_BODY",
			NoPlayerInit = true,
			Faction = "Corporate_Sector",
			Options = {
				{"KRIN", Locations = {"KRIN_INVINCIBLE"}},
				{"WEPLINN", Locations = {"WEPLINN_ISD"}},
				{"SLOANE", Locations = {"SLOANE_ENFORCE"}},
				{"TAGGE", Locations = {"ULRIC_TAGGE"}},
				{"GRUMBY", Locations = {"GRUMBY_NOTROPIS"}},
				{"BROLLYX", Locations = {"BROLLYX_DAUNTLESS"}},
				{"PHINEAS", Locations = {"PHINEAS_VSD"}},
				{"SUUB", Locations = {"SIIN_SUUB_PROCLAMATION"}},
			}
		},
		["WINDLE_LOCATION_SET"] = {
			Hero_Squadron = "WINDLE_HLAF_SQUADRON",
			PopupBody = "WINDLE_SELECTOR_BODY",
			Options = {
				{"KRIN", Locations = {"KRIN_INVINCIBLE"}},
				{"WEPLINN", Locations = {"WEPLINN_ISD"}},
				{"SLOANE", Locations = {"SLOANE_ENFORCE"}},
				{"TAGGE", Locations = {"ULRIC_TAGGE"}},
				{"GRUMBY", Locations = {"GRUMBY_NOTROPIS"}},
				{"BROLLYX", Locations = {"BROLLYX_DAUNTLESS"}},
				{"PHINEAS", Locations = {"PHINEAS_VSD"}},
				{"SUUB", Locations = {"SIIN_SUUB_PROCLAMATION"}},
			}
		},
		-- Hapes
		["VHORK_SQUADRON_LOCATION_SET"] = {
			Hero_Squadron = "VHORK_SQUADRON",
			PopupBody = "VHORK_SELECTOR_BODY",
			Options = {
				{"TAA_CHUME", Locations = {"TAA_CHUME_STAR_HOME"}},
				{"ISOLDER", Locations = {"ISOLDER_SONG_OF_WAR"}},
				{"ASTARTA", Locations = {"ASTARTA_SIREN_STAR"}},
				{"ALYSSIA", Locations = {"ALYSSIA_STARSONG"}},
				{"CHELIK", Locations = {"CHELIK_DANGEROUS_DANCE"}},
				{"GRAY", Locations = {"GRAY_KENDALL"}},
			}
		},
		["AEGEL_SQUADRON_LOCATION_SET"] = {
			Hero_Squadron = "AEGEL_SQUADRON",
			PopupBody = "AEGEL_SELECTOR_BODY",
			Options = {
				{"ALYSSIA", Locations = {"ALYSSIA_STARSONG"}},
				{"CHELIK", Locations = {"CHELIK_DANGEROUS_DANCE"}},
				{"GRAY", Locations = {"GRAY_KENDALL"}},
				{"TAA_CHUME", Locations = {"TAA_CHUME_STAR_HOME"}},
				{"ISOLDER", Locations = {"ISOLDER_SONG_OF_WAR"}},
				{"ASTARTA", Locations = {"ASTARTA_SIREN_STAR"}},
			}
		},
		-- Hutts
		["OBEROS_LOCATION_SET"] = {
			Hero_Squadron = "OBEROS_KIMOGILA_SQUADRON",
			PopupBody = "OBEROS_SELECTOR_BODY",
			Options = {
				{"MIKA", Locations = {"MIKA_TEMPEST"}},
				{"GANIS", Locations = {"GANIS_NAL_HUTTA_JEWEL"}},
				{"TOBBA", Locations = {"TOBBA_YTOBBA"}},
				{"RIBOGA", Locations = {"RIBOGA_RIGHTFUL_DOMINION"}},
				{"ULAL", Locations = {"ULAL_POTALA_UM_VAR"}},
				{"DURGA", Locations = {"DURGA_DARKSABER"}},
			}
		},
		["THWEEK_LOCATION_SET"] = {
			Hero_Squadron = "THWEEK_STARVIPER_II_SQUADRON",
			PopupBody = "THWEEK_SELECTOR_BODY",
			Options = {
				{"GANIS", Locations = {"GANIS_NAL_HUTTA_JEWEL"}},
				{"MIKA", Locations = {"MIKA_TEMPEST"}},
				{"TOBBA", Locations = {"TOBBA_YTOBBA"}},
				{"RIBOGA", Locations = {"RIBOGA_RIGHTFUL_DOMINION"}},
				{"ULAL", Locations = {"ULAL_POTALA_UM_VAR"}},
				{"DURGA", Locations = {"DURGA_DARKSABER"}},
			}
		},

		-- Project Proteus

		["RED_STAR_LOCATION_SET"] = {
			Hero_Squadron = "RED_STAR_SQUADRON",
			PopupBody = "RED_STAR_SELECTOR_BODY",
			Options = {
				{"DARIUS", Locations = {"DARIUS_SHIELD_BREAKER"}},
				{"EXECUTOR", Locations = {"EXECUTOR_STAR_DREADNOUGHT"}},
				{"GRUNGER", Locations = {"GRUNGER_AGGRESSOR"}},
				{"BALAN", Locations = {"BALAN_JAVELIN"}},
				{"DROMMEL", Locations = {"DROMMEL_GUARDIAN"}},
				{"GRONN", Locations = {"GRONN_ACULEUS"}},
				{"KIEZ", Locations = {"KIEZ_WHELM"}},
				{"COMEG", Locations = {"COMEG_BELLATOR"}},
				{"X1", Locations = {"X1_EXECUTOR"}},
				{"THORN", Locations = {"THORN_ASSERTOR"}},
			}
		},

		["BENJO_ALPHA_LOCATION_SET"] = {
			Hero_Squadron = "BENJO_ALPHA_SQUADRON",
			PopupBody = "BENJO_ALPHA_SELECTOR_BODY",
			Options = {
				{"VALEK", Locations = {"VALEK_REVENANT"}},
				{"BETHROGG", Locations = {"BETHROGG_BEHEMOTH"}},
				{"DAALA", Locations = {"DAALA_SCYLLA"}},
				{"PELLAEON", Locations = {"PELLAEON_CHIMAERA_CAPTAIN","PELLAEON_CHIMAERA_GRAND","PELLAEON_REAPER","PELLAEON_MEGADOR"}},
				{"SHADOW_VENGEANCE", Locations = {"SHADOW_VENGEANCE_STAR_DREADNOUGHT"}},
			}
		},

		["YARNAR_LOCATION_SET"] = {
			Hero_Squadron = "YARNAR_SQUADRON",
			PopupBody = "YARNAR_SELECTOR_BODY",
			Options = {
				{"RAGEZ", Locations = {"RAGEZ_DASTA_MARAUDER"}},
				{"MNISTA", Locations = {"MNISTA_QUASAR"}},
				{"MANDATOR_III", Locations = {"MANDATOR_III_DREADNOUGHT"}},
				{"GRUNGER", Locations = {"GRUNGER_AGGRESSOR"}},
				{"BALAN", Locations = {"BALAN_JAVELIN"}},
				{"DROMMEL", Locations = {"DROMMEL_GUARDIAN"}},
				{"GRONN", Locations = {"GRONN_ACULEUS"}},
				{"KIEZ", Locations = {"KIEZ_WHELM"}},
				{"COMEG", Locations = {"COMEG_BELLATOR"}},
				{"X1", Locations = {"X1_EXECUTOR"}},
				{"THORN", Locations = {"THORN_ASSERTOR"}},
			}
		},
	}

	if upgrade_object ~= nil then
		return heroes[upgrade_object]
	end
	return heroes
end

function Get_Hero_Upgrade(upgrade_object)
	--Define Setter and NewObject of an entry with the index being the name of a dummy object that triggers the change
	local upgrades = {
		["DUMMY_SALM_BWING"] = {
			Setter = "SALM_LOCATION_SET",
			NewSquadron = "SALM_B_WING_SQUADRON",
		}
	}
	return upgrades[upgrade_object]
end