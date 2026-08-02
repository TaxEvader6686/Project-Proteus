require("StandardFighterFunctions")

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
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if alias == "IMPERIAL" then
			fighter = "TIE_BOMBER_SQUADRON"
			if is_main_empire then
				if regime == 3 or regime > 6 then
					fighter = "SCIMITAR_SQUADRON"
				end
			end
		elseif owner == "CORPORATE_SECTOR" or alias == "CORPORATE_SECTOR" then
			if Check_Flags(flags,"ISD") then
				fighter = "BTLB_Y_WING_SQUADRON"
			else
				fighter = "2_WARPOD_SQUADRON"
			end
		end 
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "TIE_GT_BOMBER_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "STARWING_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "2_WARPOD_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "TIE_LIGHT_BOMBER_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "TIE_BOMBER_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "TIE_BOMBER_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "BTLB_Y_WING_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_AVENGER_BOMBER_SQUADRON"
				if Get_Fighter_Research("ZSC") then
					fighter = "SCIMITAR_SQUADRON"
				end
			elseif proteus == "ELROOD" then
				fighter = "TIE_BOMBER_SQUADRON"
				if Get_Fighter_Research("ELRSC") then
					fighter = "SCIMITAR_SQUADRON"
				end
			elseif proteus == "WILD_SPACE" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "TIE_LIGHT_BOMBER_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "STARWING_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "BELBULLAB24_SQUADRON" 
			elseif proteus == "KUAT" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "TIE_LIGHT_BOMBER_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "TIE_BOMBER_SQUADRON" -- Add Custom Spawn of Hyena to Providence
			elseif proteus == "MAELSTROM" then
				fighter = "STARWING_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "TIE_LIGHT_BOMBER_SQUADRON"
			--elseif proteus == "HAMMERS" then
                --fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "TIE_LIGHT_BOMBER_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "TIE_GT_BOMBER_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "PROTECTORATE" then
				fighter = "MISSILE_BOAT_SQUADRON"
			elseif proteus == "GRUNGER" then
					fighter = "TIE_BOMBER_SQUADRON"
				if Get_Fighter_Research("GRUSC") then
					fighter = "SCIMITAR_SQUADRON"
				end
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "THORN" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "STORM_COMMANDOS" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			--elseif proteus == "X1" then
				--fighter = ""
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
