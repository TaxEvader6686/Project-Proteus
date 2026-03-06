return {
	Fighters = {
		["TIE_AVENGER_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 3}
		},
		["TIE_DEFENDER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["STARWING_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
			IMPERIAL = {Initial = 1, Reserve = 1, ResearchType = "~ZMB"}
		},
		["MISSILE_BOAT_SQUADRON_HALF"] = {
			IMPERIAL = {Initial = 1, Reserve = 1, ResearchType = "ZMB"}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}