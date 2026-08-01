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
		local fighter = "Z95_HEADHUNTER_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
			owner = native
		end

		local proteustypes = {
			-- TR entries
			ARDA = {"TIE_FIGHTER_SQUADRON", false},
			BAKURA = {"Z95_HEADHUNTER_SQUADRON", false},
			BRAK = {"TIE_FIGHTER_SQUADRON", false,
						{"BrakFighters", "NIMBUS_V_WING_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_FIGHTER_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_INTERCEPTOR_SQUADRON", false},
			DASTA = {"R22_SPEARHEAD_SQUADRON", false,
					{"DastaFightersImperial", "SHIELDED_MISSILE_TIE_FIGHTER_SQUADRON", false},
					{"DastaFightersRebel", "DEFENDER_STARFIGHTER_SQUADRON", false}},
			ELROOD = {"TIE_Fighter_BF2_SQUADRON", false},
			GAROS = {"TIE_FIGHTER_SQUADRON", false},
			HAMMERS = {"TIE_STARFIGHTER_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_LIGHT_FIGHTER", false},
			ISECTOR = {"SHIELDED_TIE_FIGHTER_SQUADRON", false},
			JARDEEN = {"TIE_DROID_SQUADRON", false},
			KAARENTH_DISSENSION = {"TIE_FIGHTER_SQUADRON", false},
			KAMINO = {"TIE_FIGHTER_SQUADRON", false},
			KASHYYYK = {"TIE_FIGHTER_SQUADRON", false,
						{"KSM", "TIE_FIGHTER_BF2_SQUADRON", false}}, --research 1
			KUAT = {"NIMBUS_V_WING_SQUADRON", false},
			LAMBDA = {"TIE_FIGHTER_SQUADRON", false},
			LUMIYA = {"SHIELDED_TIE_FIGHTER_SQUADRON", false},
			MAELSTROM = {"TIE_FIGHTER_SQUADRON", false},
			NABOO = {"SHIELDED_TIE_FIGHTER_SQUADRON", false},
			PRAKITH = {"TIE_INTERCEPTOR_SQUADRON", false}, --Shielded Upgrade and Time switch to droids? But also, Prakith always starts late...
			PRENTIOCH = {"TIE_FIGHTER_SQUADRON", false},
			PROPHETS = {"NIMBUS_V_WING_SQUADRON", false},
			PROTECTORATE = {"STARVIPER_SQUADRON", false},
			QUINTAD = {"TIE_STARFIGHTER_SQUADRON", false},
			RADAMA = {"TIE_FIGHTER_SQUADRON", false},
			RAYTER = {"TIE_FIGHTER_SQUADRON", false},
			RESTORED_EMPIRE = {"Z95_HEADHUNTER_SQUADRON", false},
			SECTOR_5 = {"NIMBUS_V_WING_ESK_SQUADRON", false},
			SELLASAS = {"SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SHADOWSPAWN = {"TIE_X3_SQUADRON", false},
			TAGGE = {"TIE_FIGHTER_SQUADRON", false},
			TAMARIN = {"TIE_FIGHTER_SQUADRON", false},
			TAPANI = {"TIE_FIGHTER_SQUADRON", false},
			TIERFON = {"TIE_INTERCEPTOR_ION_SQUADRON", false},
			VOGEL = {"TIE_FIGHTER_SQUADRON", false},
			WESSEX = {"MISSILE_TIE_FIGHTER_SQUADRON", false},
			WILD_SPACE = {"SHIELDED_TIE_FIGHTER_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_X3_SQUADRON", false},
			ZERO_COMMAND = {"SHIELDED_TIE_FIGHTER_SQUADRON", false},
			ZSINJ_REMNANTS = {"MIXED_UGLY_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"NIMBUS_V_WING_ESK_SQUADRON", false},
			THORN = {"NIMBUS_V_WING_SQUADRON", false},
			X1 = {"TIE_Fighter_BF2_SQUADRON", false},
			PRAJI = {"SHIELDED_MISSILE_TIE_FIGHTER_SQUADRON", false},
			BALMORRA = {"Z95ML_HEADHUNTER_SQUADRON", false},
			RENDILI = {"TIE_STARFIGHTER_SQUADRON", "ATL_INTERCEPTOR_SQUADRON"},
			VEERS = {"SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_FIGHTER_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_FIGHTER_SQUADRON", false},
			LANOX = {"TIE_DROID_SQUADRON", false},
		}
		
		if alias == "IMPERIAL" or owner == "CORELLIA" then
			fighter = "TIE_FIGHTER_SQUADRON"
			if owner == "PENTASTAR" and Get_Fighter_Research("X3") then
				fighter = "TIE_X3_SQUADRON"
			elseif owner == "ERIADU_AUTHORITY" and Get_Fighter_Research("EATIEShields") then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif owner == "ZSINJ_EMPIRE" and native ~= "IMPERIAL" then
				fighter = "Z95_HEADHUNTER_SQUADRON"
			end
			if Check_Flags(flags,"SHIELDED_LN") or Check_Flags(flags,"SHIELDED_FIGHTERS") then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			end

			if owner == "IMPERIAL_PROTEUS" then
				local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
				if proteustypes[group_name] then
					if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_LIGHT_FIGHTER")
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

			if is_main_empire then
				if regime == 4 then
					if owner == "ERIADU_AUTHORITY" and Get_Fighter_Research("EATIEShields") then
						fighter = "SHIELDED_TIE_DROID_SQUADRON"
					else
						fighter = "TIE_DROID_SQUADRON"
					end
				elseif regime == 6 and not Get_Fighter_Research("V38") then --No Super TIE for Zero Command
					fighter = "SUPER_TIE_SQUADRON"
				end
			end
		elseif owner == "REBEL" then
			if techLevel >= 4 then
				fighter = "DEFENDER_STARFIGHTER_SQUADRON"
			else
				fighter = "Z95_HEADHUNTER_SQUADRON"
			end
			if native == "IMPERIAL" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif Get_Fighter_Research("CoS_Shesh") then
				fighter = "A9_SQUADRON"
			end
		elseif owner == "HAPES_CONSORTIUM" then
			if native == "IMPERIAL" then
				fighter = "TIE_FIGHTER_SQUADRON"
			else
				fighter = "PATROL_MIYTIL_FIGHTER_SQUADRON"
			end
		elseif owner == "EMPIREOFTHEHAND" then
			if native == "IMPERIAL" then
				fighter = "TIE_FIGHTER_SQUADRON"
			else
				fighter = "NSSIS_SQUADRON"
			end
		elseif owner == "CORPORATE_SECTOR" then
			fighter = "IRD_SQUADRON"
		elseif owner == "HUTT_CARTELS" then
			fighter = "Z95_HEADHUNTER_SQUADRON"
		elseif owner == "BAKURA" then
			fighter = "BAKURAN_GPA_SQUADRON"
		end 
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
