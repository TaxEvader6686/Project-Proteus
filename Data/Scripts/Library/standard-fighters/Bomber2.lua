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
			IMPERIAL = "STARWING_SQUADRON",
			GREATER_MALDROOD = "TIE_OPPRESSOR_SQUADRON",
			EMPIREOFTHEHAND = "SYCA_BOMBER_SQUADRON",
			HAPES_CONSORTIUM = "HETRINAR_BOMBER_SQUADRON",
			CORPORATE_SECTOR = "BTLB_Y_WING_SQUADRON",
			HUTT_CARTELS = "KIMOGILA_SQUADRON",
			MANDALORIANS = "KIMOGILA_SQUADRON",
		}
		
		local proteustypes = {
			-- TR entries 
			ARDA = {"Z95_BOMBER_SQUADRON", false},
			BAKURA = {"TIE_BOMBER_SQUADRON", false},
			BRAK = {"2_WARPOD_SQUADRON", false,
					{"BrakFighters", "SHIELDED_TIE_BOMBER_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_BOMBER_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"STARWING_SQUADRON", false},
			DASTA = {"Z95_BOMBER_SQUADRON", false,
					{"DastaFightersImperial", "STARWING_SQUADRON", false},
					{"DastaFightersRebel", "H60_TEMPEST_SQUADRON", false}},
			ELROOD = {"STARWING_SQUADRON", false},
			GAROS = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			HAMMERS = {"TIE_BOMBER_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_BOMBER2", false},
			ISECTOR = {"BTLS1_Y_WING_SQUADRON", false},
			JARDEEN = {"TIE_OPPRESSOR_SQUADRON", false},
			KAARENTH_DISSENSION = {"TIE_AVENGER_BOMBER_SQUADRON", false},
			KAMINO = {"NIMBUS_V_WING_BOMBER_SQUADRON", false},
			KASHYYYK = {"Z95_BOMBER_SQUADRON", false},
			KUAT = {"NIMBUS_V_WING_BOMBER_SQUADRON", false},
			LAMBDA = {"TIE_BOMBER_SQUADRON", false},
			LUMIYA = {"SCIMITAR_SQUADRON", false},
			MAELSTROM = {"2_WARPOD_SQUADRON", false},
			NABOO = {"Z95_BOMBER_SQUADRON", false},
			PRAKITH = {"TIE_AVENGER_BOMBER_SQUADRON", false},
			PRENTIOCH = {"SCIMITAR_SQUADRON", false},
			PROPHETS = {"2_WARPOD_SQUADRON", false},
			PROTECTORATE = {"TIE_AVENGER_BOMBER_SQUADRON", false},
			QUINTAD = {"TIE_GT_BOMBER_SQUADRON", false},
			RADAMA = {"2_WARPOD_SQUADRON", false},
			RAYTER = {"2_WARPOD_SQUADRON", false},
			RESTORED_EMPIRE = {"H60_TEMPEST_SQUADRON", false},
			SECTOR_5 = {"NIMBUS_V_WING_BOMBER_SQUADRON", false},
			SELLASAS = {"MISSILE_BOAT_SQUADRON", false},
			SHADOWSPAWN = {"TIE_OPPRESSOR_SQUADRON", false},
			TAGGE = {"2_WARPOD_SQUADRON", false},
			TAMARIN = {"BTLS1_Y_WING_SQUADRON", false,
					{"TAMSC", "SCIMITAR_SQUADRON", false}}, --research 1
			TAPANI = {"Z95_BOMBER_SQUADRON", false},
			TIERFON = {"SCIMITAR_SQUADRON", false},
			VOGEL = {"SCIMITAR_SQUADRON", false},
			WESSEX = {"TIE_OPPRESSOR_SQUADRON", false},
			WILD_SPACE = {"TIE_GT_BOMBER_SQUADRON", false},
			ZAARIN_REMNANTS = {"STARWING_SQUADRON", false,
					{"ZMB", "MISSILE_BOAT_SQUADRON", false}}, --research 1
			ZERO_COMMAND = {"ALPHA_NIMBUS_VWING_BOMBER_SQUADRON", false},
			ZSINJ_REMNANTS = {"TIE_BOMBER_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"STARWING_SQUADRON", false},
			THORN = {"STARWING_SQUADRON", false},
			X1 = {"STARWING_SQUADRON", false},
			PRAJI = {"TIE_OPPRESSOR_SQUADRON", false},
			BALMORRA = {"NIMBUS_V_WING_BOMBER_SQUADRON", false}, 
			RENDILI = {"MISSILE_BOAT_SQUADRON", "Y_WING_SQUADRON"},
			VEERS = {"SCIMITAR_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_OPPRESSOR_SQUADRON", false},
			SECOND_IMPERIUM = {"Z95_BOMBER_SQUADRON", false},
			LANOX = {"Z95_BOMBER_SQUADRON", false,
					{"LFU", "Y_WING_SQUADRON", false}}, --research 1
			STORM_COMMANDOS = {"SCIMITAR_SQUADRON", false},
			THARKUS = {"SCIMITAR_SQUADRON", false},
			CENTRALITY = {"TIE_LIGHT_BOMBER_SQUADRON", false},
			ANAXES = {"BTLB_Y_WING_SQUADRON", false},
			SECRET = {"TIE_AVENGER_BOMBER_SQUADRON", false},
			SCREED = {"NIMBUS_V_WING_BOMBER_SQUADRON", false},
		}

		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "ERIADU_AUTHORITY" then
			if Get_Fighter_Research("Scimitar") then
				fighter = "SCIMITAR_SQUADRON"
			else
				fighter = "TIE_BOMBER_SQUADRON"
			end
		end
		
		if owner == "REBEL" then
			if Get_Fighter_Research("BwingE") then
				fighter = "B_WING_E_SQUADRON"
			else
				fighter = "B_WING_SQUADRON"
			end
		elseif alias == "REBEL" then
			fighter = "B_WING_SQUADRON"
		end 
		
		if owner == "IMPERIAL_PROTEUS" then
            local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
            if proteustypes[group_name] then
				if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_BOMBER2")
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
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
