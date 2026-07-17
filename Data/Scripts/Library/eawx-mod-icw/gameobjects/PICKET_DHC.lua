return {
	Ship_Crew_Requirement = 220,
	Fighters = {
		["FIGHTER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"PANAKA_THEED"}, {"N1_SQUADRON_HALF"}}},
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "~IMPERIAL_NABOO"}
		},
		["N1_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "IMPERIAL_NABOO"}
		}
	},
	Native = "IMPERIAL",
	FighterFlags = {"PROTEUS_OVERRIDE"},
	Scripts = {"multilayer", "fighter-spawn"}
}
