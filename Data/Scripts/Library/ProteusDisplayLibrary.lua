---- GovText is a table of text strings for the gov display to show, each entry is a new line, use "TEXT_NONE" for an empty spacing line
---- No_Legitimacy = true will clear the normal legitimacy information from the display, for any groups that don't interact with legitimacy
---- PirateBaseText is identical in setup to GovText, used to show the garrision info for the pirate base for groups that have it
---- ShipyardOneText is used to override the automatically generated garrison display, for groups that have specific set spawns the normal system is incapable of showing correctly
---- ShipyardTwoText is the same as ShipyardOneText, but for the level 2 shipyard
---- ShipyardThreeText same for level 3 shipyard
---- ShipyardFourText same for level 4 shipyard
return {
--[[
		["TEMPLATE"] = {
			GovText = {
			"String #1", 
			"TEXT_NONE",--spacer
			"String #2", 
			},
			PirateBaseText = {
			"String #1", 
			"String #2", 
			"String #3", 
			},
		},
]]
		["ISECTOR"] = {
			PirateBaseText = {
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_ISECTOR1",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_ISECTOR2",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_ISECTOR3",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_ISECTOR4",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_ISECTOR5",
			},
		},
		["KAARENTH_DISSENSION"] = {
			PirateBaseText = {
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KAARENTH1",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KAARENTH2",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KAARENTH3",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KAARENTH4",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KAARENTH5",
			},
		},
		["KASHYYYK"] = {
			PirateBaseText = {
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KASHYYYK1",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KASHYYYK2",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KASHYYYK3",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KASHYYYK4",
			"TEXT_GOVERNMENT_PROTEUS_PIRATE_KASHYYYK5",
			},
		},
		["NIVERS"] = {
			GovText = {
			"TEXT_GOVERNMENT_PROTEUS_DISPLAY_NIVERS1", 
			"TEXT_NONE",
			"TEXT_GOVERNMENT_PROTEUS_DISPLAY_NIVERS2", 
			"TEXT_GOVERNMENT_PROTEUS_DISPLAY_NIVERS3", 
			"TEXT_GOVERNMENT_PROTEUS_DISPLAY_NIVERS4", 
			"TEXT_GOVERNMENT_PROTEUS_DISPLAY_NIVERS5", 
			"TEXT_NONE",
			"TEXT_GOVERNMENT_PROTEUS_DISPLAY_NIVERS6", 
			},
		},

}
