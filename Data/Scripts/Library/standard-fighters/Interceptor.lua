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
		local fighter = "MANKVIM_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			REBEL = "A_WING_SQUADRON",
			EMPIREOFTHEHAND = "KRSSIS_INTERCEPTOR_SQUADRON",
			HAPES_CONSORTIUM = "MIYTIL_FIGHTER_SQUADRON",
			CORPORATE_SECTOR = "MANKVIM_SQUADRON",
			HUTT_CARTELS = "DUNELIZARD_INTERCEPTOR_SQUADRON",
			MANDALORIANS = "DUNELIZARD_INTERCEPTOR_SQUADRON",
			YEVETHA = "TRIFOIL_SQUADRON"
		}
		
		local proteustypes = {
			-- TR entries
			ARDA = {"NIMBUS_V_WING_ESK_SQUADRON", false},
			BAKURA = {"TIE_INTERCEPTOR_SQUADRON", false},
			BRAK = {"NIMBUS_V_WING_SQUADRON", false,
					{"BrakFighters", "UPGUNNED_TIE_INTERCEPTOR_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_INTERCEPTOR_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			DASTA = {"TOSCAN_INTERCEPTOR_SQUADRON", false,
					{"DastaFightersImperial", "MISSILE_TIE_INTERCEPTOR_SQUADRON", false},
					{"DastaFightersRebel", "A_WING_SQUADRON", false}},
			ELROOD = {"TIE_INTERCEPTOR_SQUADRON", false,
					{"ELRArmoredTIE", "ARMORED_INTERCEPTOR_SQUADRON", false}}, --research 1
			GAROS = {"ARMORED_INTERCEPTOR_SQUADRON", false},
			HAMMERS = {"TIE_INTERCEPTOR_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_INTERCEPTOR", false},
			ISECTOR = {"SHIELDED_TIE_INTERCEPTOR_SQUADRON", false},
			JARDEEN = {"TIE_INTERCEPTOR_ION_SQUADRON", false},
			KAARENTH_DISSENSION = {"TIE_INTERCEPTOR_SQUADRON", false,
					{"SkiprayZeta", "TIE_INTERCEPTOR_ION_SQUADRON", false}}, --research 1
			KAMINO = {"TIE_INTERCEPTOR_SQUADRON", false},
			KASHYYYK = {"TIE_INTERCEPTOR_SQUADRON", false,
					{"KSM", "TIE_INTERCEPTOR_BF2_SQUADRON", false}}, --research 1
			KUAT = {"MANEUVER_ETA2_ACTIS_SQUADRON", false},
			LAMBDA = {"TIE_INTERCEPTOR_SQUADRON", false},
			LUMIYA = {"ASSAULT_ETA2_ACTIS_SQUADRON", false},
			MAELSTROM = {"NIMBUS_V_WING_SQUADRON", false},
			NABOO = {"NIMBUS_V_WING_SQUADRON", false},
			PRAKITH = {"TIE_INTERCEPTOR_ION_SQUADRON", false}, --Shielded Upgrade?
			PRENTIOCH = {"VULTURE_BROWN_SQUADRON", false},
			PROPHETS = {"TIE_INTERCEPTOR_SQUADRON", false}, --Fighter Swap with Upgunned Variant
			PROTECTORATE = {"V38_SQUADRON", false},
			QUINTAD = {"ARMORED_INTERCEPTOR_SQUADRON", false},
			RADAMA = {"TIE_INTERCEPTOR_SQUADRON", false},
			RAYTER = {"TIE_AGGRESSOR_SQUADRON", false},
			RESTORED_EMPIRE = {"NIMBUS_V_WING_SQUADRON", false},
			SECTOR_5 = {"UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SELLASAS = {"ION_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SHADOWSPAWN = {"TIE_PHANTOM_SQUADRON", false},
			TAGGE = {"T_WING_SQUADRON", false},
			TAMARIN = {"NIMBUS_V_WING_SQUADRON", false},
			TAPANI = {"TIE_INTERCEPTOR_SQUADRON", false,
					{"ProteusA9", "A9_SQUADRON", false}}, --research 1
			TIERFON = {"V38_SQUADRON", false},
			VOGEL = {"TIE_INTERCEPTOR_SQUADRON", false},
			WESSEX = {"A9_SQUADRON", false},
			WILD_SPACE = {"SHIELDED_TIE_INTERCEPTOR_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_X2_SQUADRON", false},
			ZERO_COMMAND = {"SHIELDED_TIE_INTERCEPTOR_SQUADRON", false},
			ZSINJ_REMNANTS = {"TIE_RAPTOR_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			THORN = {"TIE_INTERCEPTOR_SQUADRON", false},
			X1 = {"TIE_INTERCEPTOR_BF2_SQUADRON", false},
			PRAJI = {"SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			BALMORRA = {"NIMBUS_V_WING_SQUADRON", false,
					{"ProteusA9", "A9_SQUADRON", false}},
			RENDILI = {"V38_SQUADRON", "TOSCAN_INTERCEPTOR_SQUADRON"},
			VEERS = {"V38_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_X3_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_INTERCEPTOR_ION_SQUADRON", false},
			LANOX = {"A9_SQUADRON", false},
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if alias == "IMPERIAL" then
			fighter = "TIE_INTERCEPTOR_SQUADRON"
			if owner == "ZSINJ_EMPIRE" then
				if not Get_Fighter_Research("Raptorless") then
					fighter = "TIE_RAPTOR_SQUADRON"
				end
			elseif owner == "ERIADU_AUTHORITY" then
				if Get_Fighter_Research("EATIEShields") then
					if Get_Fighter_Research("ArmoredTIE") then
						fighter = "SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
					else
						fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
					end
					else
					if Get_Fighter_Research("ArmoredTIE") then
						fighter = "ARMORED_INTERCEPTOR_SQUADRON"
					else
						fighter = "TIE_INTERCEPTOR_SQUADRON"
					end
				end
			elseif owner == "GREATER_MALDROOD" and Get_Fighter_Research("MissileTIE") then
				fighter = "MISSILE_TIE_INTERCEPTOR_SQUADRON"
			end
			
			if owner == "IMPERIAL_PROTEUS" then
				local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
				if proteustypes[group_name] then
					if string.find(proteustypes[group_name][1], "GAMBLE_") then
						local random_list = require("random-fighters/GAMBLE_INTERCEPTOR")
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
			
			if is_main_empire and Check_Flags(flags,"ISD") then
				if regime == 4 or regime == 6 then
					fighter = "A9_SQUADRON"
				elseif regime == 5 then
					fighter = "ROYAL_GUARD_INTERCEPTOR_SQUADRON"
				elseif regime == 7 then
					fighter = "PREYBIRD_SQUADRON"
				end
			end
			if Check_Flags(flags,"SHIELDED_IN") or Check_Flags(flags,"SHIELDED_FIGHTERS") then
				if owner ~= "ZSINJ_EMPIRE" then
					fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
				else
					fighter = "SHIELDED_TIE_RAPTOR_SQUADRON"
				end
			end
		elseif owner == "REBEL" and native ~= "IMPERIAL" then
			local test = Find_First_Object("TALLON_SILENT_WATER")
			if TestValid(test) then
				double = true
			end
		elseif owner == "REBEL" and native == "IMPERIAL" then
			fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
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
