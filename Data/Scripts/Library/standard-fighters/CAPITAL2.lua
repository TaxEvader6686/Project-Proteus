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
		local fighter = "SKIRMISH_TECTOR_STAR_DESTROYER"
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "SKIRMISH_TECTOR_STAR_DESTROYER"
		end

		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"IMPERIAL_II_STAR_DESTROYER_ION", 1},
			ARDA = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			BAKURA = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			BRAK = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			CATO_NEIMOIDIA = {"IMPERIAL_II_STAR_DESTROYER", 1},
			CIUTRIC_HEGEMONY = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			DASTA = {"IMPERIAL_II_STAR_DESTROYER_SENTRY", 1},
			ELROOD = {"IMPERIAL_I_STAR_DESTROYER_HERO_REFIT_PROTEUS", 1},
			GAROS = {"IMPERIAL_II_STAR_DESTROYER", 1},
			HAMMERS = {"IMPERIAL_II_STAR_DESTROYER", 1},
			IMPERIAL_LIANNA = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			ISECTOR = {"IMPERIAL_II_STAR_DESTROYER_SENTRY", 1},
			JARDEEN = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			KAARENTH_DISSENSION = {"MAELSTROM_BATTLECRUISER", 1},
			KAMINO = {"ACCLAMATOR_BATTLESHIP", 1},
			KASHYYYK = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			KUAT = {"IMPERIAL_II_STAR_DESTROYER", 1},
			LAMBDA = {"IMPERIAL_II_STAR_DESTROYER", 1},
			LUMIYA = {"IMPERIAL_II_STAR_DESTROYER", 1},
			MAELSTROM = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			NABOO = {"IMPERIAL_II_STAR_DESTROYER", 1},
			PRAKITH = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			PRENTIOCH = {"PROCURATOR_BATTLECRUISER", 1},
			PROPHETS = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			PROTECTORATE = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			QUINTAD = {"PROCURATOR_BATTLECRUISER", 1},
			RADAMA = {"IMPERIAL_I_STAR_DESTROYER", 1},
			RAYTER = {"BULWARK_II", 1},
			RESTORED_EMPIRE = {"MAELSTROM_BATTLECRUISER", 1},
			SECTOR_5 = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			SELLASAS = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			SHADOWSPAWN = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			TAGGE = {"TRIUMPH_STAR_DESTROYER", 1},
			TAMARIN = {"IMPERIAL_I_STAR_DESTROYER_HERO_REFIT_PROTEUS", 1},
			TAPANI = {"IMPERIAL_I_STAR_DESTROYER_ASSAULT", 1},
			TIERFON = {"IMPERIAL_II_STAR_DESTROYER_ION", 1},
			VOGEL = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			WESSEX = {"IMPERIAL_II_STAR_DESTROYER", 1},
			WILD_SPACE = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			ZAARIN_REMNANTS = {"IMPERIAL_II_STAR_DESTROYER", 1},
			ZERO_COMMAND = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			ZSINJ_REMNANTS = {"IMPERIAL_II_STAR_DESTROYER_ION", 1},
			--Project Proteus
			ANAXES = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			ALLIED_TION = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},--Based on Dev Doc
			BALMORRA = {"MAELSTROM_BATTLECRUISER", 1},
			BATCH = {"ACCLAMATOR_BATTLESHIP", 1},																
			BRANDEI = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},
			BORMEA = {"PROCURATOR_BATTLECRUISER", 1},
			CARIDA = {"ACCLAMATOR_BATTLESHIP", 1},--Based on Dev Doc
			CENTRALITY = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			COMPNOR = {"IMPERIAL_II_STAR_DESTROYER", 1},
			IMPERIAL_CORELLIA = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},--Default
			DROMMEL = {"IMPERIAL_II_STAR_DESTROYER", 1},			
			EMPIRE_REBORN = {"IMPERIAL_II_STAR_DESTROYER", 1},
			FEL = {"IMPERIAL_II_STAR_DESTROYER", 1},
			GRUNGER = {"IMPERIAL_II_STAR_DESTROYER", 1},
			LANOX = {"ACCLAMATOR_BATTLESHIP", 1},
			MINOS = {"IMPERIAL_II_STAR_DESTROYER_SENTRY", 1},
			NIVERS = {"IMPERIAL_II_STAR_DESTROYER", 1, 
						{"NiversAggressor", "IMPERIAL_II_STAR_DESTROYER_SENTRY", 1}},
			PRAJI = {"IMPERIAL_II_STAR_DESTROYER", 1},
			RENDILI = {"TRIUMPH_STAR_DESTROYER", 1},
			SCREED = {"IMPERIAL_II_STAR_DESTROYER_SENTRY", 1},
			SECOND_IMPERIUM = {"IMPERIAL_II_STAR_DESTROYER_SENTRY", 1},
			STORM_COMMANDOS = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			TATOOINE = {"IMPERIAL_I_STAR_DESTROYER_HERO_REFIT_PROTEUS", 1},
			THORN = {"IMPERIAL_II_STAR_DESTROYER", 1},
			THARKUS = {"IMPERIAL_II_STAR_DESTROYER", 1},
			TRAX = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},--Based on Dev Doc
			VEERS = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			X1 = {"IMPERIAL_II_STAR_DESTROYER", 1},
			SECRET = {"SHADOW_IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
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
