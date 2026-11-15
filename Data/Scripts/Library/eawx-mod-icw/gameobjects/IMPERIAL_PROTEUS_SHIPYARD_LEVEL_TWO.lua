return {
	Fighters = {
		["LIGHT_FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 99}
		},
		["INTERCEPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["CORVETTE"] = {--IPV1
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["HEAVY_CORVETTE"] = {--Carrack
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["HEAVY_CORVETTE2"] = {--Carrack
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["FRIGATE"] = {--DHC
			DEFAULT = {Initial = 1, Reserve = 0},
		},
		["FRIGATE2"] = {--DHC
			DEFAULT = {Initial = 1, Reserve = 0},
		},
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}