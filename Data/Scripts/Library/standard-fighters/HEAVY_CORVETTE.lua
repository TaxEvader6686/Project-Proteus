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
		local fighter = "CARRACK_CRUISER"--Non-skirmish carrack for group-specific fighter spawns, SUR is automatically disabled for spawned ships
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "CARRACK_CRUISER"
		end

		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"CARRACK_CRUISER", 1},
			ARDA = {"CARRACK_CRUISER", 1},
			BAKURA = {"NAMANA_CRUISER_PROTEUS", 1},
			BRAK = {"SKIRMISH_VICTORY_I_FRIGATE", 1},
			CATO_NEIMOIDIA = {"MUNIFEX", 1},
			CIUTRIC_HEGEMONY = {"CARRACK_CRUISER", 1},
			DASTA = {"MARAUDER_CRUISER", 2},
			ELROOD = {"BAYONET_CRUISER", 1},--Reconsider after Bayonet restat
			GAROS = {"IMPERIAL_NEBULON_B", 1},
			HAMMERS = {"CARRACK_CRUISER", 1},
			IMPERIAL_LIANNA = {"MARAUDER_CRUISER", 2},
			ISECTOR = {"CARRACK_CRUISER_LASER", 1},
			JARDEEN = {"VIGIL", 1},
			KAARENTH_DISSENSION = {"CARRACK_CRUISER_ZETA", 1},
			KAMINO = {"ACTIVE_FRIGATE", 1},
			KASHYYYK = {"STARBOLT", 1},
			KUAT = {"SKIRMISH_ARQUITENS", 1},
			LAMBDA = {"STRIKE_CRUISER", 1},
			LUMIYA = {"SKIRMISH_RAIDER_II_CORVETTE", 3},
			MAELSTROM = {"CARRACK_CRUISER", 1},
			NABOO = {"CARRACK_CRUISER", 1},
			PRAKITH = {"PATROL_NEBULON_B", 1},
			PRENTIOCH = {"CEC_LIGHT_CRUISER", 1},
			PROPHETS = {"PATROL_NEBULON_B", 1},
			PROTECTORATE = {"CARRACK_CRUISER", 1},
			QUINTAD = {"CARRACK_CRUISER", 1},
			RADAMA = {"CARRACK_CRUISER", 1},
			RAYTER = {"CARRACK_CRUISER", 1},
			RESTORED_EMPIRE = {"PELTA_ASSAULT", 2},
			SECTOR_5 = {"STRIKE_CRUISER", 1},
			SELLASAS = {"CARRACK_CRUISER", 1},
			SHADOWSPAWN = {"SKIRMISH_VICTORY_I_FRIGATE", 1},
			TAGGE = {"SURVEYOR_FRIGATE", 1},
			TAMARIN = {"SKIRMISH_VICTORY_II_FRIGATE", 1},
			TAPANI = {"SKIRMISH_RAIDER_II_CORVETTE", 4},
			TIERFON = {"SKIRMISH_RAIDER_II_CORVETTE", 3},
			VOGEL = {"ACTIVE_FRIGATE", 1},
			WESSEX = {"NEBULON_B2", 1},
			WILD_SPACE = {"CORELLIAN_BUCCANEER", 2},
			ZAARIN_REMNANTS = {"NEBULON_B2", 1},
			ZERO_COMMAND = {"ACTIVE_FRIGATE", 1},
			ZSINJ_REMNANTS = {"IPV1_GUNBOAT_PROTEUS", 3},
			--Project Proteus
			ANAXES = {"BAYONET_CRUISER", 1},
			ALLIED_TION = {"SKIRMISH_VICTORY_I_FRIGATE", 1},--Based on Dev Doc
			BALMORRA = {"MARAUDER_MISSILE_CRUISER", 2},
			BATCH = {"ACTIVE_FRIGATE", 1},																
			BRANDEI = {"CARRACK_CRUISER", 1},
			BORMEA = {"CARRACK_CRUISER", 1},
			CARIDA = {"CARRACK_CRUISER", 1},--Based on Dev Doc
			CENTRALITY = {"CARRACK_CRUISER_LASER", 1},
			COMPNOR = {"SKIRMISH_ARQUITENS_REFIT", 1},
			IMPERIAL_CORELLIA = {"CARRACK_CRUISER", 1},--Default
			DROMMEL = {"CARRACK_CRUISER", 1},			
			EMPIRE_REBORN = {"CLASS_C_FRIGATE", 1},
			FEL = {"CR92A", 3},
			GRUNGER = {"CARRACK_CRUISER", 1},
			LANOX = {"CARRACK_CRUISER_LASER", 1},
			MINOS = {"SKIRMISH_VICTORY_I_FRIGATE", 1},
			NIVERS = {"SKIRMISH_CORELLIAN_BUCCANEER", 3},
			PRAJI = {"SKIRMISH_TRENCHANT", 1},
			RENDILI = {"CARRACK_CRUISER", 1},
			SCREED = {"BAYONET_CRUISER", 1},
			SECOND_IMPERIUM = {"ACTIVE_FRIGATE", 1},
			STORM_COMMANDOS = {"CR92A", 4},
			TATOOINE = {"CR90B_GUNBOAT", 3},
			THORN = {"SKIRMISH_ARQUITENS_REFIT", 1},
			THARKUS = {"CARRACK_CRUISER", 1},
			TRAX = {"CARRACK_CRUISER", 1},--Based on Dev Doc
			VEERS = {"CARRACK_CRUISER", 1},
			X1 = {"CARRACK_CRUISER", 1},
			SECRET = {"CARRACK_CRUISER_ZETA", 1},
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
