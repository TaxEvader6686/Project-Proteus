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
		local fighter = "VICTORY_I_STAR_DESTROYER"
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "VICTORY_I_STAR_DESTROYER"
		end
		
		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"VICTORY_II_STAR_DESTROYER", 1},
			ARDA = {"VICTORY_I_STAR_DESTROYER", 1},
			BAKURA = {"BAKURA_DESTROYER_PROTEUS", 1},
			BRAK = {"VICTORY_I_STAR_DESTROYER", 1},
			CATO_NEIMOIDIA = {"LUCREHULK_CORE_DESTROYER", 1},
			CIUTRIC_HEGEMONY = {"VICTORY_II_STAR_DESTROYER", 1},
			DASTA = {"VICTORY_I_STAR_DESTROYER", 1},
			ELROOD = {"VICTORY_II_STAR_DESTROYER", 1},
			GAROS = {"ACCLAMATOR_II", 1},
			HAMMERS = {"VINDICATOR_CRUISER", 1},
			IMPERIAL_LIANNA = {"VINDICATOR_CRUISER", 1},
			ISECTOR = {"VINDICATOR_CRUISER", 1},
			JARDEEN = {"ACCLAMATOR_I_ASSAULT", 1},
			KAARENTH_DISSENSION = {"VICTORY_I_STAR_DESTROYER", 1},
			KAMINO = {"VICTORY_II_STAR_DESTROYER", 1},
			KASHYYYK = {"VICTORY_I_STAR_DESTROYER", 1},
			KUAT = {"VICTORY_I_STAR_DESTROYER", 1},
			LAMBDA = {"VICTORY_I_STAR_DESTROYER", 1},
			LUMIYA = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			MAELSTROM = {"ACCLAMATOR_PATROL_REFIT", 1},
			NABOO = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			PRAKITH = {"VICTORY_I_STAR_DESTROYER", 1},
			PRENTIOCH = {"VICTORY_II_STAR_DESTROYER", 1},
			PROPHETS = {"ACCLAMATOR_PATROL_REFIT", 1},
			PROTECTORATE = {"VICTORY_II_STAR_DESTROYER", 1},
			QUINTAD = {"VICTORY_I_STAR_DESTROYER", 1},
			RADAMA = {"GLADIATOR_II", 1},
			RAYTER = {"BULWARK_I", 1},
			RESTORED_EMPIRE = {"ACCLAMATOR_II", 1},
			SECTOR_5 = {"IMPERIAL_II_FRIGATE", 1},
			SELLASAS = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			SHADOWSPAWN = {"VICTORY_II_STAR_DESTROYER", 1},
			TAGGE = {"SURVEYOR_FRIGATE", 1},
			TAMARIN = {"VICTORY_II_STAR_DESTROYER", 1},
			TAPANI = {"VICTORY_I_STAR_DESTROYER", 1},
			TIERFON = {"EIDOLON", 1},
			VOGEL = {"VICTORY_II_STAR_DESTROYER", 1},
			WESSEX = {"ACCLAMATOR_II", 1},
			WILD_SPACE = {"VICTORY_I_STAR_DESTROYER", 1},
			ZAARIN_REMNANTS = {"STRIKE_CRUISER", 2},
			ZERO_COMMAND = {"VICTORY_I_STAR_DESTROYER", 1},
			ZSINJ_REMNANTS = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			--Project Proteus
			ANAXES = {"ACCLAMATOR_I_ASSAULT", 1},
			ALLIED_TION = {"PROCURSATOR_STAR_DESTROYER", 1},--Based on Dev Doc
			BALMORRA = {"CAPTOR", 1},
			BATCH = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},																
			BRANDEI = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			BORMEA = {"ACCLAMATOR_PATROL_REFIT", 1},
			CARIDA = {"ACCLAMATOR_II", 1},--Based on Dev Doc
			CENTRALITY = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			COMPNOR = {"VICTORY_II_STAR_DESTROYER", 1},
			IMPERIAL_CORELLIA = {"VICTORY_I_STAR_DESTROYER", 1},--Default
			DROMMEL = {"VICTORY_II_STAR_DESTROYER", 1},			
			EMPIRE_REBORN = {"VICTORY_II_CARRIER", 1},
			FEL = {"VICTORY_II_STAR_DESTROYER", 1},
			GRUNGER = {"VINDICATOR_CARRIER", 1},
			LANOX = {"VINDICATOR_CRUISER", 1},
			MINOS = {"VICTORY_I_STAR_DESTROYER", 1},
			NIVERS = {"NEUTRON_STAR_MERCENARY", 2},
			PRAJI = {"GLADIATOR_II", 1},
			RENDILI = {	{{"VICTORY_I_STAR_DESTROYER", 1},
						{"VICTORY_II_STAR_DESTROYER", 1},
						{"VICTORY_II_CARRIER", 1},
						{"VICTORY_I_FLEET_STAR_DESTROYER", 1},
						{"VECTOR_STAR_DESTROYER", 1},
						{"VICTORY_I_STAR_DESTROYER_PATROL", 1},
						}, 1},
			SCREED = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			SECOND_IMPERIUM = {"ACCLAMATOR_I_ASSAULT", 1},
			STORM_COMMANDOS = {"VICTORY_II_STAR_DESTROYER", 1},
			TATOOINE = {"VICTORY_I_STAR_DESTROYER_PATROL", 1},
			THORN = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			THARKUS = {"VICTORY_II_STAR_DESTROYER", 1},
			TRAX = {"VICTORY_I_STAR_DESTROYER", 1},--Based on Dev Doc
			VEERS = {"VICTORY_I_FLEET_STAR_DESTROYER", 1},
			X1 = {"ACCLAMATOR_II", 1},
			SECRET = {"VICTORY_I_STAR_DESTROYER_PATROL", 1},
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
