return {
	Ship_Crew_Requirement = 155,
	Fighters = {
		["LIGHT_FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Native = "IMPERIAL",
	FighterFlags = {"PROTEUS_LIGHT_FIGHTER_OVERRIDE_NIVERS"},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}