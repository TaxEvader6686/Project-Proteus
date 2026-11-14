return {
	Fighters = {
		["X_WING_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 2, TechLevel = LessThan(5)}
		},
		["E_WING_PROTOTYPE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(5), ResearchType = "~Ewing"}
		},
		["E_WING_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(5), ResearchType = "Ewing"}
		},
		["TIE_FIGHTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessThan(4)},
			ERIADU_AUTHORITY = {Initial = 1, Reserve = 2, ResearchType = "~EATIEShields"},
			GREATER_MALDROOD = {Initial = 1, Reserve = 2},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2},
			-- IMPERIAL_PROTEUS = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["LIGHT_FIGHTER_DOUBLE"] = {
			IMPERIAL_PROTEUS = {Initial = 1, Reserve = 2}
		},
		["TIE_DROID_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = IsOneOf({4, 5})}
		},
		["SUPER_TIE_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(6)}
		},
		["SHIELDED_TIE_FIGHTER_SQUADRON_DOUBLE"] = {
			ERIADU_AUTHORITY = {Initial = 1, Reserve = 2, ResearchType = "EATIEShields"}
		},
		["TIE_GT_SQUADRON_DOUBLE"] = {
			PENTASTAR = {Initial = 1, Reserve = 2}
		},
		["Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			ZSINJ_EMPIRE = {Initial = 1, Reserve = 2}
		},
		["DUNELIZARD_INTERCEPTOR_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		},
		["BOMBER"] = {
			IMPERIAL = {Initial = 1, Reserve = 1},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1},
			NIVERS = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(99)}
		},
		["HEAVY_BOMBER"] = {
			NIVERS = {Initial = 1, Reserve = 1},
		},
		["Y_WING_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 1}
		},
		["SCURRG_H6_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_CR90"] = {
			REBEL = {Initial = 2, Reserve = 2}
		},
		["SKIRMISH_CUSTOMS_CORVETTE"] = {
			GREATER_MALDROOD = {Initial = 2, Reserve = 2}
		},
		["SKIRMISH_IPV1"] = {
			EMPIRE = {Initial = 2, Reserve = 2, TechLevel = LessThan(6)},
			ERIADU_AUTHORITY = {Initial = 2, Reserve = 2},
			INDEPENDENT_FORCES = {Initial = 2, Reserve = 2},
			--IMPERIAL_PROTEUS = {Initial = 2, Reserve = 2},
			WARLORDS = {Initial = 2, Reserve = 2}
		},
		["CORVETTE"] = {
			IMPERIAL_PROTEUS = {Initial = 2, Reserve = 2}
		},
		["SKIRMISH_CRUSADER"] = {
			EMPIRE = {Initial = 2, Reserve = 2, TechLevel = GreaterOrEqualTo(6)}
		},
		["SKIRMISH_RAIDER_I_CORVETTE"] = {
			PENTASTAR = {Initial = 2, Reserve = 2}
		},
		["SKIRMISH_IMPERIAL_CR90"] = {
			ZSINJ_EMPIRE = {Initial = 2, Reserve = 2}
		},
		["SKIRMISH_WARLORD_CRUISER"] = {
			HUTT_CARTELS = {Initial = 2, Reserve = 2}
		}
	},
	Scripts = {"turn-station", "fighter-spawn"}
}