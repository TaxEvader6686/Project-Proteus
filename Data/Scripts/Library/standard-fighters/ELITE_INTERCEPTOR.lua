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
		local double = false
		local fighter = "T_WING_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			IMPERIAL = "V38_SQUADRON",
			ZSINJ_EMPIRE = "TIE_X7_SQUADRON",
			ERIADU_AUTHORITY = "TIE_X7_SQUADRON",
			REBEL = "A_WING_SQUADRON",
			EMPIREOFTHEHAND = "SCARSSIS_SQUADRON",
			HAPES_CONSORTIUM = "HOUSE_MIYTIL_FIGHTER_SQUADRON",
			CORPORATE_SECTOR = "T_WING_SQUADRON",
			HUTT_CARTELS = "CLOAKSHAPE_NEW_SQUADRON",
			MANDALORIANS = "AGGRESSOR_ASSAULT_FIGHTER_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		local proteustypes = {
			-- TR entries
			ARDA = {"MANEUVER_ETA2_ACTIS_SQUADRON", false},
			BAKURA = {"TOSCAN_INTERCEPTOR_SQUADRON", false},
			BRAK = {"NIMBUS_V_WING_SQUADRON", false,
					{"BrakFighters", "TIE_AVENGER_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_AVENGER_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_X7_SQUADRON", false},
			DASTA = {"PREYBIRD_SQUADRON", false,
					{"DastaFightersImperial", "MISSILE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
					{"DastaFightersRebel", "T_WING_SQUADRON", false}},
			ELROOD = {"TIE_AVENGER_TORPS_SQUADRON", false},
			GAROS = {"V38_SQUADRON", false},
			HAMMERS = {"V38_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_ELITE_INTERCEPTOR", false},
			ISECTOR = {"TIE_X7_SQUADRON", false},
			JARDEEN = {"V38_SQUADRON", false},
			KAARENTH_DISSENSION = {"T_WING_SQUADRON", false},
			KAMINO = {"MISSILE_ETA2_ACTIS_SQUADRON", false},
			KASHYYYK = {"MISSILE_ETA2_ACTIS_SQUADRON", false},
			KUAT = {"TIE_X7_SQUADRON", false},
			LAMBDA = {"V38_SQUADRON", false},
			LUMIYA = {"ROYAL_GUARD_INTERCEPTOR_SQUADRON", false},
			MAELSTROM = {"UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			NABOO = {"V38_SQUADRON", false},
			PRAKITH = {"EAT2_ACTIS_SQUADRON", false},
			PRENTIOCH = {"TRIFIGHTER_SQUADRON", false},
			PROPHETS = {"MISSILE_TIE_INTERCEPTOR_SQUADRON", false},
			PROTECTORATE = {"TIE_AVENGER_SQUADRON", false},
			QUINTAD = {"ION_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			RADAMA = {"V38_SQUADRON", false},
			RAYTER = {"TIE_AVENGER_SQUADRON", false},
			RESTORED_EMPIRE = {"ETA2_ACTIS_SQUADRON", false},
			SECTOR_5 = {"TIE_X7_SQUADRON", false},
			SELLASAS = {"ELITE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SHADOWSPAWN = {"TIE_X7_SQUADRON", false},
			TAGGE = {"TIE_X1_SQUADRON", false},
			TAMARIN = {"T_WING_SQUADRON", false},
			TAPANI = {"V38_SQUADRON", false},
			TIERFON = {"TIE_X7_SQUADRON", false},
			VOGEL = {"MISSILE_TIE_INTERCEPTOR_SQUADRON", false},
			WESSEX = {"ELITE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			WILD_SPACE = {"DEFENSIVE_ETA2_ACTIS_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_X7_SQUADRON", false},
			ZERO_COMMAND = {"TIE_X7_SQUADRON", false},
			ZSINJ_REMNANTS = {"T_WING_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"TIE_X2_SQUADRON", false},
			THORN = {"ASSAULT_ETA2_ACTIS_SQUADRON", false},
			X1 = {"", false},
			PRAJI = {"TIE_X7_SQUADRON", false},
			BALMORRA = {"DEFENSIVE_ETA2_ACTIS_SQUADRON", false},
			RENDILI = {"UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			VEERS = {"TIE_X7_SQUADRON", false},
			EMPIRE_REBORN = {"ELITE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_PHANTOM_SQUADRON", false},
			LANOX = {"V38_SQUADRON", false},

		}
		
		if owner == "REBEL" then
			local test = Find_First_Object("TALLON_SILENT_WATER")
			if TestValid(test) then
				double = true
			end
		end 
		
		if owner == "IMPERIAL_PROTEUS" then
			local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteustypes[group_name] then
				if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_ELITE_INTERCEPTOR")
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
							if proteustypes[group_name][i][3][1] ~= false then
								if Check_Flags(flags, "PROTEUS_OVERRIDE") then
									fighter = proteustypes[group_name][i][3]
								end
							end
						end
					end	
				end
			end
		end
		
		if double then
			suffix = Double_Suffix(suffix)
		end
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
