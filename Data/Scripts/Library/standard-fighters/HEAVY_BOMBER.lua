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
		local fighter = "H_WING_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			IMPERIAL = "TIE_HEAVY_BOMBER_SQUADRON",
			PENTASTAR = "TIE_TERROR_SQUADRON",
			ZSINJ_EMPIRE = "SCURRG_H6_PROTOTYPE_SQUADRON",
			EMPIREOFTHEHAND = "TIE_HEAVY_BOMBER_SQUADRON",
			MANDALORIANS = "FIRESPRAY_BOMBER_SQUADRON",
			HUTT_CARTELS = "SCURRG_H6_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if (owner == "REBEL" or alias == "REBEL") and Check_Flags(flags,"NCMP") then
			if Get_Fighter_Research("Kwing") then
				fighter = "K_WING_SQUADRON"
			else
				fighter = "K_WING_PROTOTYPE_SQUADRON"
			end
		end
		
		local proteustypes = {
			-- TR entries
			ARDA = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			BAKURA = {"SCURRG_H6_SQUADRON", false},
			BRAK = {"NTB_630_SQUADRON", false,
					{"BrakFighters", "TIE_HEAVY_BOMBER_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_TERROR_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			DASTA = {"SKIPRAY_BOMBER_SQUADRON", false,
					{"DastaFightersImperial", "SKIPRAY_BOMBER_SQUADRON", false},
					{"DastaFightersRebel", "H_WING_SQUADRON", false}},
			ELROOD = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			GAROS = {"SKIPRAY_BOMBER_SQUADRON", false},
			HAMMERS = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			IMPERIAL_LIANNA = {"GAMBLE_HEAVY_BOMBER", false},
			ISECTOR = {"FIRESPRAY_BOMBER_SQUADRON", false},
			JARDEEN = {"TIE_TERROR_SQUADRON", false},
			KAARENTH_DISSENSION = {"SCURRG_H6_SQUADRON", false},
			KAMINO = {"TIE_TERROR_SQUADRON", false},
			KASHYYYK = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			KUAT = {"FIRESPRAY_BOMBER_SQUADRON", false},
			LAMBDA = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			LUMIYA = {"TIE_TERROR_SQUADRON", false},
			MAELSTROM = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			NABOO = {"SCURRG_H6_PROTOTYPE_SQUADRON", false},
			PRAKITH = {"SKIPRAY_BOMBER_SQUADRON", false},
			PRENTIOCH = {"SKIPRAY_BOMBER_SQUADRON", false},
			PROPHETS = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			PROTECTORATE = {"TIE_TERROR_SQUADRON", false},
			QUINTAD = {"SCURRG_H6_PROTOTYPE_SQUADRON", false},
			RADAMA = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			RAYTER = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			RESTORED_EMPIRE = {"NTB_630_SQUADRON", false},
			SECTOR_5 = {"TIE_TERROR_SQUADRON", false},
			SELLASAS = {"SCURRG_H6_SQUADRON", false},
			SHADOWSPAWN = {"TIE_TERROR_SQUADRON", false},
			TAGGE = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			TAMARIN = {"FIRESPRAY_BOMBER_SQUADRON", false},
			TAPANI = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			TIERFON = {"TIE_TERROR_SQUADRON", false},
			VOGEL = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			WESSEX = {"FIRESPRAY_BOMBER_SQUADRON", false},
			WILD_SPACE = {"H_WING_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_TERROR_SQUADRON", false},
			ZERO_COMMAND = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			ZSINJ_REMNANTS = {"TIE_TERROR_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"FIRESPRAY_BOMBER_SQUADRON", false},
			THORN = {"TIE_TERROR_SQUADRON", false},
			X1 = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			PRAJI = {"TIE_HEAVY_BOMBER_SQUADRON", false},
			BALMORRA = {"FIRESPRAY_BOMBER_SQUADRON", false},
			RENDILI = {"SKIPRAY_BOMBER_SQUADRON", false},
			VEERS = {"SCURRG_H6_SQUADRON", false},
			EMPIRE_REBORN = {"TIE_TERROR_SQUADRON", false},
			SECOND_IMPERIUM = {"TIE_TERROR_SQUADRON", false},
            LANOX = {"FIRESPRAY_BOMBER_SQUADRON", false},
		}
		
		if owner == "IMPERIAL_PROTEUS" then
			local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteustypes[group_name] then
				if string.find(proteustypes[group_name][1], "GAMBLE_") then
					local random_list = require("random-fighters/GAMBLE_HEAVY_BOMBER")
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

		if Check_Flags(flags,"PUNISHERS") then
			fighter = "TIE_PUNISHER_SQUADRON"
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		
		return fighter
	end
}
