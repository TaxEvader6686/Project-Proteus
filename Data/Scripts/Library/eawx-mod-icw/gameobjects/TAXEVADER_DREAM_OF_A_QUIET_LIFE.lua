return {
	Ship_Crew_Requirement = 7500,
	Fighters = {
		["FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["INTERCEPTOR_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["BLASTBOAT_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Native = "IMPERIAL",
	Scripts = {"fighter-spawn", "persistent-damage-tactical", "tactical-superlaser"},
	Flags = {HANGAR = true}
}