return {
	Ship_Crew_Requirement = 220,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		},
		["BOMBER2"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			IMPERIAL = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(99)},
			REBEL = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(99)}
		},
		["BOMBER"] = {
			IMPERIAL = {Initial = 1, Reserve = 2},
			REBEL = {Initial = 1, Reserve = 2}
		}
	},
	Native = "CORPORATE_SECTOR",
	FighterFlags = {"PROTEUS_OVERRIDE"},
	Scripts = {"multilayer", "single-unit-retreat", "fighter-spawn"}
}
