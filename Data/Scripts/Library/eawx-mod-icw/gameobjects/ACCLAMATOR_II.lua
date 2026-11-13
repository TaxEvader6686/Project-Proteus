return {
	Ship_Crew_Requirement = 155,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = {"~V38","~IMPERIAL_NABOO"}}
		},
		["V38_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "V38"}
		},
		["DUNELIZARD_INTERCEPTOR_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "IMPERIAL_NABOO"}
		}
	},
	Native = "IMPERIAL",
	FighterFlags = {"PROTEUS_LIGHT_FIGHTER_OVERRIDE_NIVERS"},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}