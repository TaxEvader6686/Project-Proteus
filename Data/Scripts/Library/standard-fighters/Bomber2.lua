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
			IMPERIAL = "STARWING_SQUADRON",
			GREATER_MALDROOD = "TIE_OPPRESSOR_SQUADRON",
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
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "2_WARPOD_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "SCIMITAR_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "MISSILE_BOAT_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "Z95_BOMBER_SQUADRON"			
			elseif proteus == "VOGEL" then
				fighter = "TIE_GT_BOMBER_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "2_WARPOD_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "H60_TEMPEST_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "STARWING_SQUADRON"
				if Get_Fighter_Research("ZMB") then
					fighter = "MISSILE_BOAT_SQUADRON"
				end
			elseif proteus == "ELROOD" then
				fighter = "STARWING_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "TIE_GT_BOMBER_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "SCIMITAR_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "SCIMITAR_SQUADRON"
				-- if Get_Fighter_Research("ScimitarMKIIFighters") then
				-- 	fighter = "Scimitar_MKII_SQUADRON"
				-- end
			elseif proteus == "ARDA" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "NIMBUS_V_WING_BOMBER_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "TIE_AVENGER_BOMBER_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "BTLS1_Y_WING_SQUADRON"
				if Get_Fighter_Research("TAMSC") then
					fighter = "SCIMITAR_SQUADRON"
				end
			elseif proteus == "BAKURA" then
				fighter = "TIE_BOMBER_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "NIMBUS_V_WING_BOMBER_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "TIE_AVENGER_BOMBER_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "2_WARPOD_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "2_WARPOD_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "2_WARPOD_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "2_WARPOD_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "TIE_OPPRESSOR_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "TIE_GT_BOMBER_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "SHIELDED_TIE_BOMBER_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "TIE_LIGHT_BOMBER_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "Z95_BOMBER_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "NIMBUS_V_WING_BOMBER_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "STARWING_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "ALPHA_NIMBUS_VWING_BOMBER_SQUADRON"
			elseif proteus == "PROTECTORATE" then
				fighter = "TIE_AVENGER_BOMBER_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "STARWING_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "THORN" then
				fighter = "STARWING_SQUADRON"
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
