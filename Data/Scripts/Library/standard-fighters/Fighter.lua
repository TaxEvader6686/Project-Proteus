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
		local fighter = "HOWLRUNNER_SQUADRON"
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			IMPERIAL = "HOWLRUNNER_SQUADRON",
			ERIADU_AUTHORITY = "TIE_SENTINEL_SQUADRON",
			EMPIREOFTHEHAND = "NSSIS_SQUADRON",
			HAPES_CONSORTIUM = "MIYTIL_FIGHTER_SQUADRON",
			CORPORATE_SECTOR = "IRDA_SQUADRON",
			HUTT_CARTELS = "DUNELIZARD_FIGHTER_SQUADRON",
			MANDALORIANS = "STARVIPER_II_SQUADRON",
			CORELLIA = "HLAF_SQUADRON",
			YEVETHA = "TRIFOIL_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "CORPORATE_SECTOR" then
			local test = Find_First_Object("KRIN_INVINCIBLE")
			if TestValid(test) then
				fighter = "SHIELDED_IRDA_SQUADRON"
			end
		end
		
		if owner == "REBEL" or alias == "REBEL" then
			if Check_Flags(flags,"DREXLX") and Get_Fighter_Research("CoS_Tevv") then
				fighter = "DREXL_SQUADRON"
			else
				fighter = "X_WING_SQUADRON"
			end
		end 
		
		if owner == "HAPES_CONSORTIUM" then
			if native == "REBEL" then
				fighter = "X_WING_SQUADRON"
			end
		end
		
		local proteustypes = {
			-- TR entries
			ARDA = {"TIE_POD_SQUADRON", false},
			BAKURA = {"TIE_FIGHTER_SQUADRON", false,
					{"BGPA", "BAKURAN_GPA_SQUADRON", false}}, --research 1
			BRAK = {"TWIN_ION_ENGINE_STARFIGHTER_SQUADRON", false,
					{"BrakFighters", "TIE_INTERCEPTOR_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"R41_STARCHASER_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"MISSILE_TIE_FIGHTER_SQUADRON", false},
			DASTA = {"HOWLRUNNER_SQUADRON", false,
					{"DastaFightersImperial", "HOWLRUNNER_SQUADRON", false},
					{"DastaFightersRebel", "X_WING_SQUADRON", false}},
			ELROOD = {"HOWLRUNNER_SQUADRON", false},
			GAROS = {"HOWLRUNNER_SQUADRON", false},
			HAMMERS = {"HOWLRUNNER_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_FIGHTER", false},
			ISECTOR = {"NIMBUS_V_WING_ESK_SQUADRON", false},
			JARDEEN = {"HOWLRUNNER_SQUADRON", false},
			KAARENTH_DISSENSION = {"Z95_HEADHUNTER_SQUADRON", false,
					{"KPreybird", "DREXL_SQUADRON", false}}, --research 1
			KAMINO = {"CLONE_Z95_HEADHUNTER_SQUADRON", false},
			KASHYYYK = {"Z95_HEADHUNTER_SQUADRON", false},
			KUAT = {"A9_SQUADRON", false},
			LAMBDA = {"HOWLRUNNER_SQUADRON", false},
			LUMIYA = {"HOWLRUNNER_SQUADRON", false},
			MAELSTROM = {"R41_STARCHASER_SQUADRON", false},
			NABOO = {"N1_SQUADRON", false},
			PRAKITH = {"HOWLRUNNER_SQUADRON", false},
			PRENTIOCH = {"TIE_SENTINEL_SQUADRON", false},
			PROPHETS = {"TIE_FIGHTER_SQUADRON", false},
			PROTECTORATE = {"STARVIPER_II_SQUADRON", false},
			QUINTAD = {"Z95_HEADHUNTER_SQUADRON", false},
			RADAMA = {"R41_STARCHASER_SQUADRON", false},
			RAYTER = {"TIE_FIGHTER_SQUADRON", false},
			RESTORED_EMPIRE = {"TWIN_ION_ENGINE_STARFIGHTER_SQUADRON", false},
			SECTOR_5 = {"TIE_FIGHTER_BF2_SQUADRON", false},
			SELLASAS = {"UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SHADOWSPAWN = {"TIE_FIGHTER_BF2_SQUADRON", false},
			TAGGE = {"HOWLRUNNER_SQUADRON", false},
			TAMARIN = {"Z95_HEADHUNTER_SQUADRON", false},
			TAPANI = {"MANTA_FIGHTER_SQUADRON", false},
			TIERFON = {"TIE_AGGRESSOR_SQUADRON", false},
			VOGEL = {"MISSILE_TIE_FIGHTER_SQUADRON", false},
			WESSEX = {"HOWLRUNNER_SQUADRON", false},
			WILD_SPACE = {"NIMBUS_V_WING_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_X1_SQUADRON", false},
			ZERO_COMMAND = {"SHIELDED_MISSILE_TIE_FIGHTER_SQUADRON", false},
			ZSINJ_REMNANTS = {"DREXL_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"TWIN_ION_ENGINE_STARFIGHTER_SQUADRON", false},
			THORN = {"TIE_FIGHTER_BF2_SQUADRON", false},
			X1 = {"HOWLRUNNER_SQUADRON", false},
			PRAJI = {"A9_SQUADRON", false},
			BALMORRA = {"HOWLRUNNER_SQUADRON", false},
			RENDILI = {"HOWLRUNNER_SQUADRON", "R42_STARCHASER_SQUADRON"},
			VEERS = {"HLAF_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_POD_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_AGGRESSOR_SQUADRON", false},
			LANOX = {"NIMBUS_V_WING_SQUADRON", false},
			STORM_COMMANDOS = {"TIE_HUNTER_SQUADRON", false},
			SECRET = {"X_WING_SQUADRON", false},
		}
		
		if owner == "IMPERIAL_PROTEUS" then
			local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteustypes[group_name] then
				if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_FIGHTER")
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
