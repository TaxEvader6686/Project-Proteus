return {
	Ship_Crew_Requirement = 84,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER2_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		},
	},
	Native = "IMPERIAL",
	FighterFlags = {"PROTEUS_BOMBER_OVERRIDE_NIVERS", "PROTEUS_BOMBER2_OVERRIDE_NIVERS"},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}