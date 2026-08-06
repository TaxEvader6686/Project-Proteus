return {
		--["EVEN_NAME"] = {
		--	lock_lists = {
		--		{"IMPERIAL_PROTEUS", "SHIP_MARKET", "UNIT_NAME", state}, -- state: false to unlock, true to lock 
		--	},
		--	requirement_lists = {
		--		{"IMPERIAL_PROTEUS", "SHIP_MARKET", "UNIT_NAME", ""}, -- Description; "" = None
		--	},
		--	adjustment_lists = {
		--		{"IMPERIAL_PROTEUS", "SHIP_MARKET", "UNIT_NAME", X}, -- X can be positive and negative integer; adding optional ', true' after X sets X as new chance
		--	}
		--},
		["DRAGON"] = {
			lock_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "DRAGON_HEAVY_CRUISER", false},
			},
			requirement_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "DRAGON_HEAVY_CRUISER", ""},
			},
		},
		["WESSEX"] = {
			adjustment_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "EXECUTOR_STAR_DREADNOUGHT", 30, true},
			},
		},
		["KUAT_BC"] = {
			lock_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "PRAETOR_II_BATTLECRUISER", true},
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "PRAETOR_CARRIER_BATTLECRUISER", true},
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "COMMUNICATIONS_BATTLECRUISER", true},
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "SORANNAN_STAR_DESTROYER", true},
			},
			requirement_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "PRAETOR_II_BATTLECRUISER", "[ This design has been retired ]"},
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "PRAETOR_CARRIER_BATTLECRUISER", "[ This design has been retired ]"},
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "COMMUNICATIONS_BATTLECRUISER", "[ This design has been retired ]"},
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "SORANNAN_STAR_DESTROYER", "[ This design has been retired ]"},
			}
		}
}
