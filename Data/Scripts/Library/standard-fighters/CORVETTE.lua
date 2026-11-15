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
		local fighter = "SKIRMISH_IPV1"
		local multiplier = 1
		if Is_Amalgam(owner) then
			fighter = "SKIRMISH_IPV1"
		end

		local proteustypes = {
			-- TR entries
			ANTEMERIDIAS = {"SKIRMISH_IPV1", 1},
			ARDA = {"SKIRMISH_IPV1", 1},
			BAKURA = {"SKIRMISH_IPV1", 1},
			BRAK = {"IMPERIAL_CR90", 1},
			CATO_NEIMOIDIA = {"SKIRMISH_IPV1", 1},
			CIUTRIC_HEGEMONY = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			DASTA = {"IMPERIAL_CR90", 1},
			ELROOD = {"SKIRMISH_IPV1", 1},
			GAROS = {"CUSTOMS_CORVETTE", 1},
			HAMMERS = {"SKIRMISH_IPV1", 1},
			IMPERIAL_LIANNA = {"SKIRMISH_IPV1", 1},
			ISECTOR = {"ACTION_VI_REFIT", 1},
			JARDEEN = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			KAARENTH_DISSENSION = {"IPV1_ZETA", 1},
			KAMINO = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			KASHYYYK = {"IMPERIAL_CR90", 1},
			KUAT = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			LAMBDA = {"SKIRMISH_IPV1", 1},
			LUMIYA = {"IMPERIAL_CR90", 1},
			MAELSTROM = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			NABOO = {"CUSTOMS_CORVETTE", 1},
			PRAKITH = {"SKIRMISH_IPV1", 1},
			PRENTIOCH = {"CUSTOMS_CORVETTE", 1},
			PROPHETS = {"ACTION_VI_REFIT", 1},
			PROTECTORATE = {"CUSTOMS_CORVETTE", 1},
			QUINTAD = {"LAC", 1},
			RADAMA = {"SKIRMISH_IPV1", 1},
			RAYTER = {"SKIRMISH_IPV1", 1},
			RESTORED_EMPIRE = {"IMPERIAL_CR90", 1},
			SECTOR_5 = {"CUSTOMS_CORVETTE", 1},
			SELLASAS = {"CUSTOMS_CORVETTE", 1},
			SHADOWSPAWN = {"SHADOW_CUSTOMS_CORVETTE", 1},
			TAGGE = {"SKIRMISH_IPV1", 1},
			TAMARIN = {"CUSTOMS_CORVETTE", 1},
			TAPANI = {"MANSK_FRIGATE", 1},
			TIERFON = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			VOGEL = {"SKIRMISH_IPV1", 1},
			WESSEX = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			WILD_SPACE = {"ACTION_VI_REFIT", 1},
			ZAARIN_REMNANTS = {"IMPERIAL_CR90", 1},
			ZERO_COMMAND = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			ZSINJ_REMNANTS = {"IMPERIAL_CR90", 1},
			--Project Proteus
			ANAXES = {"SKIRMISH_IPV1", 1},
			ALLIED_TION = {"CRUSADER_GUNSHIP", 1},--Based on Dev Doc
			BALMORRA = {"SKIRMISH_IPV1", 1},
			BATCH = {"SKIRMISH_IPV1", 1},																
			BRANDEI = {"IMPERIAL_CR90", 1},
			BORMEA = {"CUSTOMS_CORVETTE", 1},
			CARIDA = {"SKIRMISH_RAIDER_I_CORVETTE", 1},--Based on Dev Doc
			CENTRALITY = {"IMPERIAL_CR90", 1},
			COMPNOR = {"SKIRMISH_IPV1", 1},
			IMPERIAL_CORELLIA = {"SKIRMISH_IPV1", 1},--Default
			DROMMEL = {"CUSTOMS_CORVETTE", 1},			
			EMPIRE_REBORN = {"IMPERIAL_CR90", 1},
			FEL = {"SKIRMISH_IPV1", 1},
			GRUNGER = {"CRUSADER_GUNSHIP", 1},
			LANOX = {"IMPERIAL_CR90", 1},
			MINOS = {"CUSTOMS_CORVETTE", 1},
			NIVERS = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			PRAJI = {"CUSTOMS_CORVETTE", 1},
			RENDILI = {"CUSTOMS_CORVETTE", 1},
			SCREED = {"LAC", 1},
			SECOND_IMPERIUM = {"SKIRMISH_IPV1", 1},
			STORM_COMMANDOS = {"IMPERIAL_CR90", 1},
			TATOOINE = {"CUSTOMS_CORVETTE", 1},
			THORN = {"SKIRMISH_RAIDER_I_CORVETTE", 1},
			THARKUS = {"CUSTOMS_CORVETTE", 1},
			TRAX = {"ACTION_VI_REFIT", 1},--Based on Dev Doc
			VEERS = {"CRUSADER_GUNSHIP", 1},
			X1 = {"SKIRMISH_IPV1", 1},
			SECRET = {"CUSTOMS_CORVETTE", 1},
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
