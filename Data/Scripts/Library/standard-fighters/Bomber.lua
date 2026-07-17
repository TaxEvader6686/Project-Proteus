require("StandardFighterFunctions")

-- Project Proteus standard fighter edit
-- proteustypes table is layed out in the following format
-- group name = { [1], [2],
--         { [3],[4],[5] }, --research table 1
--         { [6],[7],[8] }, --research table 2
-- }
-- 
-- [1] *required* = string, standard fighter to use in slot
-- [2] *required* = false or string, replaces [1] fighter with fighter type when proteus override found
-- { [3],[4],[5] } *optional* = table, research layout 1
-- [3] *required* = string, research name to lookup completion status
-- [4] *required* = string, unit to replace if research found complete, replaces [1]
-- [5] *required* = false or string, similar setup to [2] 
-- later order research priotised, research table Y replaces research X if research complete where Y > X
--
-- Random Spawns, Proteus specific and independent to the EAWX random fighter pool system
-- set [1] as "GAMBLE_BLASTBOAT" to enable random spawns, needs a proteus specific list in /random-fighters/GAMBLE_BLASTBOAT.lua
-- the random pool can be overridden on unit-by-unit basis by using the proteus as explained above

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "BTLB_Y_WING_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			REBEL = "Y_WING_SQUADRON",
			EMPIREOFTHEHAND = "SYCA_BOMBER_SQUADRON",
			HAPES_CONSORTIUM = "MIYTIL_BOMBER_SQUADRON",
			CORPORATE_SECTOR = "BTLB_Y_WING_SQUADRON",
			HUTT_CARTELS = "KIMOGILA_SQUADRON",
			MANDALORIANS = "KIMOGILA_SQUADRON",
			CORELLIA = "BTLS1_Y_WING_SQUADRON"
		}
		
		local proteustypes = {
			-- TR entries
			ARDA = {"TIE_BOMBER_SQUADRON", false},
			BAKURA = {"Z95_BOMBER_SQUADRON", false},
			BRAK = {"TIE_BOMBER_SQUADRON", false,
					{"BrakFighters", "TIE_BOMBER_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"BELBULLAB24_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_BOMBER_SQUADRON", false},
			DASTA = {"2_WARPOD_SQUADRON", false,
					{"DastaFightersImperial", "SCIMITAR_SQUADRON", false},
					{"DastaFightersRebel", "B_WING_SQUADRON", false}},
			ELROOD = {"TIE_BOMBER_SQUADRON", false,
					{"ELRSC", "SCIMITAR_SQUADRON", false}}, --research 1
			GAROS = {"TIE_GT_BOMBER_SQUADRON", false},
			HAMMERS = {"TIE_BOMBER_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_BOMBER", false},
			ISECTOR = {"SHIELDED_TIE_BOMBER_SQUADRON", false},
			JARDEEN = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			KAARENTH_DISSENSION = {"TIE_BOMBER_SQUADRON", false},
			KAMINO = {"TIE_BOMBER_SQUADRON", false},
			KASHYYYK = {"TIE_BOMBER_SQUADRON", false},
			KUAT = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			LAMBDA = {"TIE_BOMBER_SQUADRON", false},
			LUMIYA = {"STARWING_SQUADRON", false},
			MAELSTROM = {"STARWING_SQUADRON", false},
			NABOO = {"SHIELDED_TIE_BOMBER_SQUADRON", false},
			PRAKITH = {"TIE_BOMBER_SQUADRON", false},
			PRENTIOCH = {"TIE_BOMBER_SQUADRON", false},
			PROPHETS = {"TIE_BOMBER_SQUADRON", false},
			PROTECTORATE = {"MISSILE_BOAT_SQUADRON", false},
			QUINTAD = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			RADAMA = {"TIE_BOMBER_SQUADRON", false}, -- Add Custom Spawn of Hyena to Providence
			RAYTER = {"TIE_BOMBER_SQUADRON", false},
			RESTORED_EMPIRE = {"BTLB_Y_WING_SQUADRON", false},
			SECTOR_5 = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			SELLASAS = {"STARWING_SQUADRON", false},
			SHADOWSPAWN = {"TIE_BOMBER_SQUADRON", false},
			TAGGE = {"TIE_GT_BOMBER_SQUADRON", false},
			TAMARIN = {"TIE_BOMBER_SQUADRON", false},
			TAPANI = {"TIE_BOMBER_SQUADRON", false},
			TIERFON = {"TIE_OPPRESSOR_SQUADRON", false},
			VOGEL = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			WESSEX = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			WILD_SPACE = {"SHIELDED_TIE_BOMBER_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_AVENGER_BOMBER_SQUADRON", false,
					{"ZSC", "SCIMITAR_SQUADRON", false}}, --research 1
			ZERO_COMMAND = {"SHIELDED_TIE_BOMBER_SQUADRON", false},
			ZSINJ_REMNANTS = {"BTLS1_Y_WING_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"TIE_BOMBER_SQUADRON", false,
					{"GRUSC", "SCIMITAR_SQUADRON", false}}, --research 1
			THORN = {"TIE_BOMBER_SQUADRON", false},
			X1 = {"TIE_BOMBER_SQUADRON", false},
			PRAJI = {"SHIELDED_TIE_BOMBER_SQUADRON", false},
			BALMORRA = {"2_WARPOD_SQUADRON", false},
			RENDILI = {"SHIELDED_TIE_BOMBER_SQUADRON", "TOSCAN_BOMBER_SQUADRON"},
			VEERS = {"2_WARPOD_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_GT_BOMBER_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_BOMBER_SQUADRON", false},
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if alias == "IMPERIAL" then
			fighter = "TIE_BOMBER_SQUADRON"
			if owner == "IMPERIAL_PROTEUS" then
				local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
				if proteustypes[group_name] then
					if string.find(proteustypes[group_name][1], "GAMBLE_") then
						local random_list = require("random-fighters/GAMBLE_BOMBER")
						if random_list[group_name] then
							local gamble = {}
							local year = GlobalValue.Get("GALACTIC_YEAR")
							for option, data in pairs(random_list[group_name]) do
								if year >= data.Min_Year and year <= data.Max_Year then
									if data.Research then
										if Get_Fighter_Research(data.Research) then
											table.insert(gamble, option)
										end
									else 
										table.insert(gamble, option)
									end
								end
							end
							if table.getn(gamble) > 0 then
								local select = GameRandom.Free_Random(1, table.getn(gamble))
								for pos, obj in pairs(gamble) do
									if pos == select then
										fighter = obj
									end
								end
							end
						end
					else
						fighter = proteustypes[group_name][1]
					end
					if proteustypes[group_name][2] ~= false then
						if Check_Flags(flags, "PROTEUS_OVERRIDE") then
							fighter = proteustypes[group_name][2]
						end
					end
					if table.getn(proteustypes[group_name]) > 2 then
						for i = 3, table.getn(proteustypes[group_name]), 1 do
							local research = proteustypes[group_name][i][1]
							if Get_Fighter_Research(research) then
								fighter = proteustypes[group_name][i][2]
								if proteustypes[group_name][i][3] ~= false then
									if Check_Flags(flags, "PROTEUS_OVERRIDE") then
										fighter = proteustypes[group_name][i][3]
									end
								end
							end
						end	
					end
				end
			end
		elseif owner == "CORPORATE_SECTOR" or alias == "CORPORATE_SECTOR" then
			if Check_Flags(flags,"ISD") then
				fighter = "BTLB_Y_WING_SQUADRON"
			else
				fighter = "2_WARPOD_SQUADRON"
			end
		end
			
		if is_main_empire then
			if regime == 3 or regime > 6 then
				fighter = "SCIMITAR_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
			
		return fighter
	end
}
