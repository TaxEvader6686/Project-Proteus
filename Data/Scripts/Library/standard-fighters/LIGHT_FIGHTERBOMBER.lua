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
		local fighter = "Z95ML_HEADHUNTER_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			IMPERIAL = "TIE_GT_SQUADRON",
			ZSINJ_EMPIRE = "Z95ML_HEADHUNTER_SQUADRON",
			EMPIREOFTHEHAND = "TIE_GT_SQUADRON",
			HAPES_CONSORTIUM = "MIYTIL_FIGHTER_SQUADRON",
		}
		
		local proteustypes = {
			-- TR entries
			ARDA = {"Z95ML_HEADHUNTER_SQUADRON", false},
			BAKURA = {"Z95ML_HEADHUNTER_SQUADRON", false},
			BRAK = {"TIE_GT_SQUADRON", false,
					{"BrakFighters", "TIE_X2_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_GT_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_GT_TORPS_SQUADRON", false},
			DASTA = {"Z95ML_HEADHUNTER_SQUADRON", false,
					{"DastaFightersImperial", "TIE_GT_SQUADRON", false},
					{"DastaFightersRebel", "Z95ML_HEADHUNTER_SQUADRON", false}},
			ELROOD = {"CLONE_Z95_HEADHUNTER_SQUADRON", false},
			GAROS = {"Z95ML_HEADHUNTER_SQUADRON", false},
			HAMMERS = {"TIE_GT_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_LIGHT_FIGHTERBOMBER", false},
			ISECTOR = {"Z95ML_HEADHUNTER_SQUADRON", false},
			JARDEEN = {"TIE_GT_TORPS_SQUADRON", false},
			KAARENTH_DISSENSION = {"CLONE_Z95_HEADHUNTER_SQUADRON", false},
			KAMINO = {"TIE_GT_SQUADRON", false},
			KASHYYYK = {"Z95ML_HEADHUNTER_SQUADRON", false},
			KUAT = {"ASSAULT_ETA2_ACTIS_SQUADRON", false},
			LAMBDA = {"TIE_GT_SQUADRON", false},
			LUMIYA = {"TIE_AVENGER_TORPS_SQUADRON", false},
			MAELSTROM = {"TIE_GT_SQUADRON", false},
			NABOO = {"G1_SQUADRON", false},
			PRAKITH = {"TIE_GT_SQUADRON", false},
			PRENTIOCH = {"TIE_GT_SQUADRON", false},
			PROPHETS = {"Z95ML_HEADHUNTER_SQUADRON", false}, --Upgrade to Assault ETA 2?
			PROTECTORATE = {"Z95ML_HEADHUNTER_SQUADRON", false},
			QUINTAD = {"TIE_GT_TORPS_SQUADRON", false},
			RADAMA = {"TIE_GT_SQUADRON", false},
			RAYTER = {"TIE_GT_SQUADRON", false},
			RESTORED_EMPIRE = {"Z95ML_HEADHUNTER_SQUADRON", false},
			SECTOR_5 = {"TIE_GT_TORPS_SQUADRON", false},
			SELLASAS = {"MISSILE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SHADOWSPAWN = {"MISSILE_TIE_INTERCEPTOR_SQUADRON", false},
			TAGGE = {"TIE_GT_SQUADRON", false},
			TAMARIN = {"TIE_GT_SQUADRON", false},
			TAPANI = {"Z95ML_HEADHUNTER_SQUADRON", false},
			TIERFON = {"TIE_X2_SQUADRON", false},
			VOGEL = {"TIE_GT_SQUADRON", false},
			WESSEX = {"TIE_GT_TORPS_SQUADRON", false},
			WILD_SPACE = {"TIE_GT_TORPS_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_V1_SQUADRON", false},
			ZERO_COMMAND = {"TIE_GT_TORPS_SQUADRON", false},
			ZSINJ_REMNANTS = {"Z95ML_HEADHUNTER_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"SCYK_HEAVY_FIGHTER_SQUADRON", false},
			THORN = {"TIE_GT_SQUADRON", false},
			X1 = {"TIE_GT_SQUADRON", false},
			PRAJI = {"TIE_X2_SQUADRON", false},
			BALMORRA = {"T_WING_SQUADRON", false},
			RENDILI = {"TIE_GT_TORPS_SQUADRON", "RIHKXYRK_SQUADRON"},
			VEERS = {"TIE_GT_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_GT_TORPS_SQUADRON", false},
			SECOND_IMPERIUM = {"Z95ML_HEADHUNTER_SQUADRON", false},
			LANOX = {"TIE_GT_TORPS_SQUADRON", false},
			STORM_COMMANDOS = {"MISSILE_TIE_INTERCEPTOR_SQUADRON", false},
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "IMPERIAL_PROTEUS" then
			local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteustypes[group_name] then
				if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_LIGHT_FIGHTERBOMBER")
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
