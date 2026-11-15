return {
	Fighters = {
		["INTERCEPTOR_DOUBLE"] = {
			DEFAULT = {Initial = 3, Reserve = 99}
		},
		["FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 3, Reserve = 6}
		},
		["CORVETTE"] = {--IPV
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["HEAVY_CORVETTE"] = {--Carrack
			DEFAULT = {Initial = 2, Reserve = 0},
		},
		["HEAVY_CORVETTE2"] = {--Carrack
			DEFAULT = {Initial = 2, Reserve = 0},
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
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}