return {
	Fighters = {
		["TIE_FIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessThan(4)},
			ERIADU_AUTHORITY = {Initial = 1, Reserve = 1, ResearchType = "~EATIEShields"},
			GREATER_MALDROOD = {Initial = 1, Reserve = 1},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1},
			-- IMPERIAL_PROTEUS = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["LIGHT_FIGHTER_HALF"] = {
			IMPERIAL_PROTEUS = {Initial = 1, Reserve = 1}
		},
		["SHIELDED_TIE_FIGHTER_SQUADRON_HALF"] = {
			ERIADU_AUTHORITY = {Initial = 1, Reserve = 1, ResearchType = "EATIEShields"}
		},
		["TIE_DROID_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = IsOneOf({4, 5})}
		},
		["A9_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(6)}
		},
		["TIE_GT_SQUADRON_HALF"] = {
			PENTASTAR = {Initial = 1, Reserve = 1}
		},
		["Z95_HEADHUNTER_SQUADRON_HALF"] = {
			ZSINJ_EMPIRE = {Initial = 1, Reserve = 1}
		},
		["BOMBER"] = {
			IMPERIAL = {Initial = 1, Reserve = 1},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_CUSTOMS_CORVETTE"] = {
			GREATER_MALDROOD = {Initial = 1, Reserve = 0}
		},
		["SKIRMISH_IPV1"] = {
			EMPIRE = {Initial = 1, Reserve = 0, TechLevel = LessThan(6)},
			ERIADU_AUTHORITY = {Initial = 1, Reserve = 0},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 0},
			-- IMPERIAL_PROTEUS = {Initial = 1, Reserve = 0},
			WARLORDS = {Initial = 1, Reserve = 0}
		},
		["CORVETTE"] = {
			IMPERIAL_PROTEUS = {Initial = 1, Reserve = 0}
		},
		["SKIRMISH_CRUSADER"] = {
			EMPIRE = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(6)}
		},
		["SKIRMISH_RAIDER_I_CORVETTE"] = {
			PENTASTAR = {Initial = 1, Reserve = 0}
		},
		["SKIRMISH_IMPERIAL_CR90"] = {
			ZSINJ_EMPIRE = {Initial = 1, Reserve = 0}
		}
	},
	Scripts = {"fighter-spawn"}
}