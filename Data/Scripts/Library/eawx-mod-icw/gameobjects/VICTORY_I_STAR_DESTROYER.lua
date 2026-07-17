return {
	Ship_Crew_Requirement = 200,
	Fighters = {
		["FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "~IMPERIAL_NABOO"}
		},
		["X_WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "IMPERIAL_NABOO"}
		}
	},
	Native = "IMPERIAL",
	FighterFlags = {"PROTEUS_OVERRIDE"},
	Scripts = {"multilayer", "fighter-spawn"}
}
