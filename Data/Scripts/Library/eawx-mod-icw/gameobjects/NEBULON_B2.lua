return {
	Ship_Crew_Requirement = 39,
	Fighters = {
		["FIGHTER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(99)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(99)},
		}
	},
	Native = "Empire",
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}