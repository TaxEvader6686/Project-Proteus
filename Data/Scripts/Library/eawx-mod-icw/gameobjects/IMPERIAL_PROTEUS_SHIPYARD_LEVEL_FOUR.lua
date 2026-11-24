return {
	Fighters = {
		["INTERCEPTOR"] = {
			DEFAULT = {Initial = 3, Reserve = 99},
			TIERFON = {Initial = 3, Reserve = 99, TechLevel = GreaterOrEqualTo(99)},
		},
		["ELITE_INTERCEPTOR"] = {
			TIERFON = {Initial = 3, Reserve = 99},
		},
		["HEAVY_FIGHTER"] = {
			DEFAULT = {Initial = 3, Reserve = 6}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["CORVETTE"] = {--IPV
			DEFAULT = {Initial = 3, Reserve = 6}
		},
		["FRIGATE"] = {--DHC
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["FRIGATE2"] = {--DHC
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["HEAVY_FRIGATE"] = {--VSD I
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["HEAVY_FRIGATE2"] = {--VSD I
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["CAPITAL"] = {--ISD I
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["CAPITAL2"] = {--Tector
			DEFAULT = {Initial = 1, Reserve = 0},
		},
	},
	FighterFlags = {"GARRISON"},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}