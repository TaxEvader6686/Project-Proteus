require("StandardFighterFunctions")

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
		
		if owner == "REBEL" then
			local test = Find_First_Object("TALLON_SILENT_WATER")
			if TestValid(test) then
				double = true
			end
		end 
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "TIE_X1_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "V38_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "STARWING_FIGHTER_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "PREYBIRD_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "MISSILE_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "NIMBUS_V_WING_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "TIE_AVENGER_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "V38_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "ETA2_ACTIS_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "DEFENSIVE_ETA2_ACTIS_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TRIFIGHTER_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "V38_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "MISSILE_ETA2_ACTIS_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "ROYAL_GUARD_INTERCEPTOR_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "MANEUVER_ETA2_ACTIS_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "NIMBUS_V_WING_ESK_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "T_WING_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "T_WING_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "TOSCAN_INTERCEPTOR_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "V38_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "EAT2_ACTIS_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "V38_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "MISSILE_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "ELITE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "SHIELDED_ARMORED_ION_INTERCEPTOR_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "V38_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "V38_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "MISSILE_ETA2_ACTIS_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "PROTECTORATE" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "TIE_X2_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "THORN" then
				fighter = "ASSAULT_ETA2_ACTIS_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "TIE_X2_SQUADRON"
			--elseif proteus == "X1" then
				--fighter = ""
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
