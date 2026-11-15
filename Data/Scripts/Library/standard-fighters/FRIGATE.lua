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
		local fighter = "IMPERIAL_DHC"
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "IMPERIAL_DHC"
		end

		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"GLADIATOR_II", 1},
			ARDA = {"NEUTRON_STAR", 1},
			BAKURA = {"NEUTRON_STAR", 1},
			BRAK = {"REP_DHC", 1},
			CATO_NEIMOIDIA = {"IMPERIAL_DHC", 1},
			CIUTRIC_HEGEMONY = {"IMPERIAL_DHC", 1},
			DASTA = {"NEUTRON_STAR", 1},
			ELROOD = {"STRIKE_CRUISER_LIGHT", 1},
			GAROS = {"DHC_CARRIER", 1},
			HAMMERS = {"IMPERIAL_DHC", 1},
			IMPERIAL_LIANNA = {"GLADIATOR_II", 1},
			ISECTOR = {"REP_DHC", 1},
			JARDEEN = {"GLADIATOR_II", 1},
			KAARENTH_DISSENSION = {"NEUTRON_STAR_MERCENARY", 1},
			KAMINO = {"GLADIATOR_II", 1},
			KASHYYYK = {"PURSUIT_LIGHT_CRUISER", 1},
			KUAT = {"PURSUIT_LIGHT_CRUISER", 1},
			LAMBDA = {"IMPERIAL_DHC", 1},
			LUMIYA = {"VINDICATOR_CARRIER", 1},
			MAELSTROM = {"PURSUIT_LIGHT_CRUISER", 1},
			NABOO = {"IMPERIAL_DHC", 1},
			PRAKITH = {"DHC_GUNBOAT", 1},
			PRENTIOCH = {"REP_DHC", 1},
			PROPHETS = {"NEUTRON_STAR", 1},
			PROTECTORATE = {"PURSUIT_LIGHT_CRUISER", 1},
			QUINTAD = {"REP_DHC", 1},
			RADAMA = {"REP_DHC", 1},
			RAYTER = {"IMPERIAL_DHC", 1},
			RESTORED_EMPIRE = {"REP_DHC", 1},
			SECTOR_5 = {"PURSUIT_LIGHT_CRUISER", 1},
			SELLASAS = {"IMPERIAL_DHC", 1},
			SHADOWSPAWN = {"GLADIATOR_II", 1},
			TAGGE = {"PICKET_DHC", 1},
			TAMARIN = {"DHC_CARRIER", 1},
			TAPANI = {"TAPANI_ASSAULT_FRIGATE", 1},
			TIERFON = {"VICTORY_II_CARRIER", 1},
			VOGEL = {"DHC_GUNBOAT", 1},
			WESSEX = {"PURSUIT_LIGHT_CRUISER", 1},
			WILD_SPACE = {"STARBOLT", 1},
			ZAARIN_REMNANTS = {"PURSUIT_LIGHT_CRUISER", 1},
			ZERO_COMMAND = {"GLADIATOR_I", 1},
			ZSINJ_REMNANTS = {"NEUTRON_STAR", 1},
			--Project Proteus
			ANAXES = {"IMPERIAL_DHC", 1},
			ALLIED_TION = {"DHC_GUNBOAT", 1},--Based on Dev Doc
			BALMORRA = {"PROTEUS_MISSILE_DHC", 1},
			BATCH = {"PURSUIT_LIGHT_CRUISER", 1},																
			BRANDEI = {"CLASS_C_FRIGATE", 1},
			BORMEA = {"STARBOLT", 1},
			CARIDA = {"IMPERIAL_DHC", 1},--Based on Dev Doc
			CENTRALITY = {"IMPERIAL_DHC", 1},
			COMPNOR = {"CR92A", 2},
			IMPERIAL_CORELLIA = {"IMPERIAL_DHC", 1},--Default
			DROMMEL = {"CR92A", 2},	
			EMPIRE_REBORN = {"IMPERIAL_DHC", 1},
			FEL = {"IMPERIAL_DHC", 1},
			GRUNGER = {"GLADIATOR_II", 1},
			LANOX = {"DHC_GUNBOAT", 1},
			MINOS = {"IMPERIAL_DHC", 1},
			NIVERS = {"GLADIATOR_I", 1},
			PRAJI = {"MODERNIZED_DHC", 1},
			RENDILI = {	{{"PDF_DHC", 1},
						{"REP_DHC", 1},
						{"IMPERIAL_DHC", 1},
						{"DHC_GUNBOAT", 1},
						{"DHC_CARRIER", 1},
						{"PICKET_DHC", 1},
						{"MODERNIZED_DHC", 1},
						{"ALLIANCE_ASSAULT_FRIGATE", 1},
						{"PROTEUS_MISSILE_DHC", 1},
						}, 1},
			SCREED = {"GLADIATOR_DEMOLISHER", 1},
			SECOND_IMPERIUM = {"PURSUIT_LIGHT_CRUISER", 1},
			STORM_COMMANDOS = {"IMPERIAL_ESCORT_CARRIER", 1},
			TATOOINE = {"UBRIKKIAN_CRUISER_GCW", 1},
			THORN = {"GLADIATOR_DEMOLISHER", 1},
			THARKUS = {"PURSUIT_LIGHT_CRUISER", 1},
			TRAX = {"IMPERIAL_DHC", 1},--Based on Dev Doc
			VEERS = {"REP_DHC", 1},
			X1 = {"IMPERIAL_DHC", 1},
			SECRET = {"MODERNIZED_DHC", 1},
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
