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
		local fighter = ""
		if Is_Amalgam(owner) or owner == "HUTT_CARTELS" or owner == "REBEL" then
			fighter = "ARC_170_SQUADRON"
		elseif owner == "CORPORATE_SECTOR" then
			fighter = "PREYBIRD_SQUADRON"
		else
			fighter = "TIE_DEFENDER_SQUADRON"
		end
		
		local proteustypes = {
			-- TR entries
			ARDA = {"STARWING_ASSAULT_SQUADRON", false},
			BAKURA = {"TIE_GT_SQUADRON", false},
			BRAK = {"ARC_170_SQUADRON", false,
					{"BrakFighters", "TIE_AVENGER_ASSAULT_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_DEFENDER_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_DEFENDER_SQUADRON", false},
			DASTA = {"ARC_170_SQUADRON", false,
					{"DastaFightersImperial", "TIE_AVENGER_TORPS_SQUADRON", false},
					{"DastaFightersRebel", "E_WING_SQUADRON", false}},
			ELROOD = {"TIE_DEFENDER_SQUADRON", false},
			GAROS = {"MISSILE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			HAMMERS = {"TIE_DEFENDER_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_ELITE_FIGHTERBOMBER", false},
			ISECTOR = {"ARC_170_SQUADRON", false},
			JARDEEN = {"TIE_AVENGER_SQUADRON", false},
			KAARENTH_DISSENSION = {"DREXL_SQUADRON", false,
					{"KPreybird", "PREYBIRD_SQUADRON", false}}, --research 1
			KAMINO = {"ARC_170_SQUADRON", false},
			KASHYYYK = {"ARC_170_SQUADRON", false},
			KUAT = {"TIE_DEFENDER_SQUADRON", false},
			LAMBDA = {"TIE_DEFENDER_SQUADRON", false},
			LUMIYA = {"TIE_AVENGER_TORPS_SQUADRON", false},
			MAELSTROM = {"ARC_170_SQUADRON", false},
			NABOO = {"TIE_DEFENDER_SQUADRON", false},
			PRAKITH = {"ARC_170_SQUADRON", false},
			PRENTIOCH = {"STARWING_ASSAULT_SQUADRON", false},
			PROPHETS = {"ARC_170_SQUADRON", false},
			PROTECTORATE = {"TIE_AVENGER_TORPS_SQUADRON", false},
			QUINTAD = {"TIE_DEFENDER_SQUADRON", false},
			RADAMA = {"TIE_DEFENDER_SQUADRON", false},
			RAYTER = {"IXIYEN_FIGHTER_SQUADRON", false},
			RESTORED_EMPIRE = {"ARC_170_SQUADRON", false},
			SECTOR_5 = {"ARC_170_SQUADRON", false},
			SELLASAS = {"STARWING_FIGHTER_SQUADRON", false},
			SHADOWSPAWN = {"TIE_HUNTER_SQUADRON", false},
			TAGGE = {"TIE_X2_SQUADRON", false},
			TAMARIN = {"BTLA4_YWING_STARFIGHTER_SQUADRON", false},
			TAPANI = {"TIE_DEFENDER_SQUADRON", false},
			TIERFON = {"TIE_DEFENDER_SQUADRON", false},
			VOGEL = {"TIE_GT_TORPS_SQUADRON", false},
			WESSEX = {"TIE_AVENGER_ASSAULT_SQUADRON", false},
			WILD_SPACE = {"ARC_170_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_DEFENDER_SQUADRON", false},
			ZERO_COMMAND = {"TIE_DEFENDER_SQUADRON", false},
			ZSINJ_REMNANTS = {"PREYBIRD_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"TIE_DEFENDER_SQUADRON", false},
			THORN = {"TIE_DEFENDER_SQUADRON", false},
			X1 = {"TIE_DEFENDER_SQUADRON", false},
			PRAJI = {"TIE_AVENGER_TORPS_SQUADRON", false},
			BALMORRA = {"ARC_170_SQUADRON", false},
			RENDILI = {"IXIYEN_FIGHTER_SQUADRON", false},
			VEERS = {"TIE_AVENGER_TORPS_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_AVENGER_TORPS_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_AVENGER_TORPS_SQUADRON", false},
			LANOX = {"TIE_DEFENDER_SQUADRON", false},
		}
		
		if owner == "IMPERIAL_PROTEUS" then
            local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
            if proteustypes[group_name] then
				if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_ELITE_FIGHTERBOMBER")
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
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end

		if is_main_empire then
			if regime == 4 then
				fighter = "SHADOW_DROID_HEAVY_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
