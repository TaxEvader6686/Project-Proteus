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
		local fighter = "IMPERIAL_I_STAR_DESTROYER"
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "IMPERIAL_I_STAR_DESTROYER"
		end

		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"IMPERIAL_II_STAR_DESTROYER", 1},
			ARDA = {"IMPERIAL_I_STAR_DESTROYER", 1},
			BAKURA = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			BRAK = {"IMPERIAL_I_STAR_DESTROYER", 1},
			CATO_NEIMOIDIA = {"IMPERIAL_I_STAR_DESTROYER", 1},
			CIUTRIC_HEGEMONY = {"IMPERIAL_I_STAR_DESTROYER", 1},
			DASTA = {"INVINCIBLE_CRUISER", 1},
			ELROOD = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			GAROS = {"ACCLAMATOR_DESTROYER", 1},
			HAMMERS = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			IMPERIAL_LIANNA = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			ISECTOR = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			JARDEEN = {"IMPERIAL_I_STAR_DESTROYER", 1},
			KAARENTH_DISSENSION = {"IMPERIAL_I_STAR_DESTROYER", 1},
			KAMINO = {"IMPERIAL_I_STAR_DESTROYER", 1},
			KASHYYYK = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			KUAT = {"IMPERIAL_I_STAR_DESTROYER_ASSAULT", 1},
			LAMBDA = {"IMPERIAL_I_STAR_DESTROYER", 1},
			LUMIYA = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			MAELSTROM = {"MAELSTROM_BATTLECRUISER", 1},
			NABOO = {"IMPERIAL_I_STAR_DESTROYER", 1},
			PRAKITH = {"IMPERIAL_I_STAR_DESTROYER", 1},
			PRENTIOCH = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			PROPHETS = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			PROTECTORATE = {"IMPERIAL_I_STAR_DESTROYER", 1},
			QUINTAD = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			RADAMA = {"INVINCIBLE_CRUISER", 1},
			RAYTER = {"BULWARK_II", 1},
			RESTORED_EMPIRE = {"IMPERIAL_I_STAR_DESTROYER", 1},
			SECTOR_5 = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			SELLASAS = {"IMPERIAL_I_STAR_DESTROYER", 1},
			SHADOWSPAWN = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			TAGGE = {"IMPERIAL_I_STAR_DESTROYER_COMMAND", 1},
			TAMARIN = {"INVINCIBLE_CRUISER", 1},
			TAPANI = {"IMPERIAL_I_STAR_DESTROYER", 1},
			TIERFON = {"IMPERIAL_II_STAR_DESTROYER", 1},
			VOGEL = {"IMPERIAL_I_STAR_DESTROYER_ASSAULT", 1},
			WESSEX = {"IMPERIAL_I_STAR_DESTROYER", 1},
			WILD_SPACE = {"INVINCIBLE_CRUISER", 1},
			ZAARIN_REMNANTS = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			ZERO_COMMAND = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			ZSINJ_REMNANTS = {"IMPERIAL_I_STAR_DESTROYER_ASSAULT", 1},
			--Project Proteus
			ANAXES = {"INVINCIBLE_CRUISER_MODERNIZED", 1},
			ALLIED_TION = {"TRIUMPH_STAR_DESTROYER", 1},--Based on Dev Doc
			BALMORRA = {"IMPERIAL_I_STAR_DESTROYER_ASSAULT", 1},
			BATCH = {"IMPERIAL_I_STAR_DESTROYER", 1},																
			BRANDEI = {"IMPERIAL_I_STAR_DESTROYER", 1},
			BORMEA = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			CARIDA = {"SKIRMISH_TECTOR_STAR_DESTROYER", 1},--Based on Dev Doc
			CENTRALITY = {"INVINCIBLE_CRUISER", 1},
			COMPNOR = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			IMPERIAL_CORELLIA = {"IMPERIAL_I_STAR_DESTROYER", 1},--Default
			DROMMEL = {"IMPERIAL_I_STAR_DESTROYER", 1},			
			EMPIRE_REBORN = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			FEL = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			GRUNGER = {"IMPERIAL_I_STAR_DESTROYER_HERO_REFIT_PROTEUS", 1},
			LANOX = {"IMPERIAL_I_STAR_DESTROYER", 1},
			MINOS = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			NIVERS = {"ACCLAMATOR_I_CARRIER", 2},
			PRAJI = {"IMPERIAL_I_STAR_DESTROYER_HERO_REFIT_PROTEUS", 1},
			RENDILI = {"INVINCIBLE_CRUISER", 1},
			SCREED = {"TRIUMPH_STAR_DESTROYER", 1},
			SECOND_IMPERIUM = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			STORM_COMMANDOS = {"IMPERIAL_I_STAR_DESTROYER_ASSAULT", 1},
			TATOOINE = {"IMPERIAL_I_STAR_DESTROYER_PATROL", 1},
			THORN = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			THARKUS = {"IMPERIAL_I_STAR_DESTROYER", 1},
			TRAX = {"IMPERIAL_I_STAR_DESTROYER", 1},--Based on Dev Doc
			VEERS = {"IMPERIAL_I_STAR_DESTROYER", 1},
			X1 = {"IMPERIAL_I_STAR_DESTROYER_CARRIER", 1},
			SECRET = {"NEBULA_STAR_DESTROYER", 1},
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
