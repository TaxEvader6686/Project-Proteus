require("StandardFighterFunctions")

--[[	proteustypes Table Layout: 
	group name = { [1], [2], 
			{ [3], [4], [5] }, --Research Table 1
			{ [6], [7], [8] }, --Research Table 2
			},

	[1] *required* = string (or table, see below), standard unit to use in slot
	[2] *required* = number, multiplier on spawns in that slot, use to replace units on a 2 for 1 basis (or any sensible ratio, given theses files (aside from gunship & corvette) are always spawned in pairs, ie FRIGATE & FRIGATE2 are always spawned together, so setting multiplier to 1 for FRIGATE and 2 for FRIGATE2 will spawn 3 ships total)
	{ [3],[4],[5] } *optional* = table, Research Layout 1
	[3] *required* = string, research name to lookup completion status
	[4] *required* = string, unit to replace if research found complete, replaces [1]
	[5] *required* = number, multiplier to use for unit [4], replaces [2] 
	later order research priotised, research table Y replaces research X if research complete where Y > X
	
	Random spawns can be enabled by using a table of units in place of [1], [4], [7], etc
	Random Table Layout:
	{ { [1], [1a] }, { [2], [2a] }, { [3], [3a] } }
	[1] *required* = string, unit to spawn
	[1a] *required* = number, multiplier used for unit [1]
	Repeat for [2] & [2a] and so on
]]

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "BETA_ETR_3_SQUADRON"
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "BETA_ETR_3_SQUADRON"
		end

		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"BETA_ETR_3_SQUADRON", 1},
			ARDA = {"YE_4_SQUADRON", 1},
			BAKURA = {"GAMMA_ATR_6_SQUADRON", 1},
			BRAK = {"VT49_DECIMATOR_SQUADRON", 1},
			CATO_NEIMOIDIA = {"GUARDIAN_CRUISER_SQUADRON", 1},
			CIUTRIC_HEGEMONY = {"BETA_ETR_3_SQUADRON", 1},
			DASTA = {"GUARDIAN_CRUISER_SQUADRON", 1},
			ELROOD = {"PURSUER_ENFORCEMENT_SHIP_SQUADRON", 1},
			GAROS = {"YZ_775_FREIGHTER_SQUADRON", 1},
			HAMMERS = {"BETA_ETR_3_SQUADRON", 1},
			IMPERIAL_LIANNA = {"GUARDIAN_CRUISER_SQUADRON", 1},
			ISECTOR = {"GOZANTI_CRUISER_SQUADRON", 1},
			JARDEEN = {"YZ_775_FREIGHTER_SQUADRON", 1},
			KAARENTH_DISSENSION = {"DELTA_JV7_SQUADRON", 1},
			KAMINO = {"YZ_775_FREIGHTER_SQUADRON", 1},
			KASHYYYK = {"YZ_775_FREIGHTER_SQUADRON", 1},
			KUAT = {"VT49_DECIMATOR_SQUADRON", 1},
			LAMBDA = {"BETA_ETR_3_SQUADRON", 1},
			LUMIYA = {"VT49_DECIMATOR_SQUADRON", 1},
			MAELSTROM = {"VT49_DECIMATOR_SQUADRON", 1},
			NABOO = {"BETA_ETR_3_SQUADRON", 1},
			PRAKITH = {"DELTA_JV7_SQUADRON", 1},
			PRENTIOCH = {"GUARDIAN_CRUISER_SQUADRON", 1},
			PROPHETS = {"DELTA_JV7_SQUADRON", 1},
			PROTECTORATE = {"GUARDIAN_CRUISER_SQUADRON", 1},
			QUINTAD = {"GOZANTI_CRUISER_SQUADRON", 1},
			RADAMA = {"CITADEL_CRUISER_SQUADRON", 1},
			RAYTER = {"GAMMA_ATR_6_SQUADRON", 1},
			RESTORED_EMPIRE = {"BETA_ETR_3_SQUADRON", 1},
			SECTOR_5 = {"DELTA_JV7_SQUADRON", 1},
			SELLASAS = {"BETA_ETR_3_SQUADRON", 1},
			SHADOWSPAWN = {"YE_4_SQUADRON", 1},
			TAGGE = {"CITADEL_CRUISER_SQUADRON", 1},
			TAMARIN = {"GUARDIAN_CRUISER_LASERS_SQUADRON", 1},
			TAPANI = {"YE_4_SQUADRON", 1},
			TIERFON = {"BETA_ETR_3_SQUADRON", 1},
			VOGEL = {"GAMMA_ATR_6_SQUADRON", 1},
			WESSEX = {"GUARDIAN_CRUISER_SQUADRON", 1},
			WILD_SPACE = {"PURSUER_ENFORCEMENT_SHIP_SQUADRON", 1},
			ZAARIN_REMNANTS = {"BETA_ETR_3_SQUADRON", 1},
			ZERO_COMMAND = {"BETA_ETR_3_SQUADRON", 1},
			ZSINJ_REMNANTS = {"YE_4_SQUADRON", 1},
			--Project Proteus
			ANAXES = {"DELTA_JV7_SQUADRON", 1},
			ALLIED_TION = {"BETA_ETR_3_SQUADRON", 1},--Default
			BALMORRA = {"BETA_ETR_3_SQUADRON", 1},
			BATCH = {"GAMMA_ATR_6_SQUADRON", 1},																
			BRANDEI = {"CITADEL_CRUISER_SQUADRON", 1},
			BORMEA = {"GUARDIAN_CRUISER_SQUADRON", 1},
			CARIDA = {"BETA_ETR_3_SQUADRON", 1},--Default
			CENTRALITY = {"GOZANTI_CRUISER_SQUADRON", 1},
			COMPNOR = {"VT49_DECIMATOR_SQUADRON", 1},
			IMPERIAL_CORELLIA = {"BETA_ETR_3_SQUADRON", 1},--Default
			DROMMEL = {"DELTA_JV7_SQUADRON", 1},			
			EMPIRE_REBORN = {"GOZANTI_CRUISER_SQUADRON", 1},
			FEL = {"BETA_ETR_3_SQUADRON", 1},
			GRUNGER = {"PURSUER_ENFORCEMENT_SHIP_SQUADRON", 1},
			LANOX = {"YE_4_SQUADRON", 1},
			MINOS = {"GUARDIAN_CRUISER_SQUADRON", 1},
			NIVERS = {"YZ_775_FREIGHTER_SQUADRON", 1},
			PRAJI = {"GUARDIAN_CRUISER_SQUADRON", 1},
			RENDILI = {"GOZANTI_CRUISER_SQUADRON", 1},
			SCREED = {"YZ_775_FREIGHTER_SQUADRON", 1},
			SECOND_IMPERIUM = {"DELTA_JV7_SQUADRON", 1},
			STORM_COMMANDOS = {"X4_GUNSHIP_SQUADRON", 1},
			TATOOINE = {"YE_4_SQUADRON", 1},
			THORN = {"GOZANTI_CRUISER_SQUADRON", 1},
			THARKUS = {"YZ_775_FREIGHTER_SQUADRON", 1},
			TRAX = {"PURSUER_ENFORCEMENT_SHIP_SQUADRON", 1},--Based on Dev Doc
			VEERS = {"GAMMA_ATR_6_SQUADRON", 1},
			X1 = {"GAMMA_ATR_6_SQUADRON", 1},
			SECRET = {"BETA_ETR_3_SQUADRON", 1},
		}

		if owner == "IMPERIAL_PROTEUS" then
			local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteustypes[group_name] then
				local entry = proteustypes[group_name]
				if type(entry[1]) ~= "table" then
					fighter = entry[1]
					multiplier = entry[2]
				else
					local random_list = entry[1]
					if table.getn(random_list) > 0 then
						local select = GameRandom.Free_Random(1, table.getn(random_list))
						for pos, data in pairs(random_list) do
							if pos == select then
								fighter = data[1]
								multiplier = data[2]
							end
						end
					end
				end
				if table.getn(entry) > 2 then
					for i = 3, table.getn(entry), 1 do
						local research = entry[i][1]
						if Get_Fighter_Research(research) then
							if type(entry[i][2]) ~= "table" then
								fighter = entry[i][2]
								multiplier = entry[i][3]
							else
								local random_list = entry[i][2]
								if table.getn(random_list) > 0 then
									local select = GameRandom.Free_Random(1, table.getn(random_list))
									for pos, data in pairs(random_list) do
										if pos == select then
											fighter = data[1]
											multiplier = data[2]
										end
									end
								end
							end
						end
					end    
				end
			end
		end
		
		local fighterandquantity = {fighter, multiplier}
		return fighterandquantity
	end
}
