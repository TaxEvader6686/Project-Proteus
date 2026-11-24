return {
	Fighters = {
		["LIGHT_FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 99}
		},
		["INTERCEPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			RENDILI = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(99)},
		},
		["ELITE_INTERCEPTOR"] = {
			RENDILI = {Initial = 1, Reserve = 2},
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["GUNSHIP"] = {--Beta ETR 3
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["CORVETTE"] = {--IPV1
			DEFAULT = {Initial = 2, Reserve = 2}
		},
		["HEAVY_CORVETTE"] = {--Carrack
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["HEAVY_CORVETTE2"] = {--Carrack
			DEFAULT = {Initial = 1, Reserve = 0},
		},
	},
	FighterFlags = {"GARRISON"},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}