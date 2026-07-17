return {
	Ship_Crew_Requirement = 680,
	Fighters = {
		["FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2, HeroOverride = {{"KRIN_INVINCIBLE"}, {"SHIELDED_IRDA_SQUADRON_DOUBLE"}}}
		},
		["LIGHT_FIGHTERBOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			CORPORATE_SECTOR = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(99)},
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
			HUTT_CARTELS = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(99)},
		},
		["BTLB_Y_WING_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1}
		},
		["Z95_HEADHUNTER_SQUADRON"] = {
			CORPORATE_SECTOR = {Initial = 1, Reserve = 4}
		}
	},
	Native = "CORPORATE_SECTOR",
	FighterFlags = {"PROTEUS_OVERRIDE"},
	Scripts = {"multilayer", "fighter-spawn"}
}
