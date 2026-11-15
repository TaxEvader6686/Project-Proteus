return {
	Ship_Crew_Requirement = 480,
	Fighters = {
		["TIE_HUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	Native = "IMPERIAL",
	Scripts = {"multilayer", "fighter-spawn", "tactical-superlaser"},
	Flags = {HANGAR = true}
}