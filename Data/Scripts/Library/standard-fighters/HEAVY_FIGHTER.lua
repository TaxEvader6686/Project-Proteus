require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local double = false
		local fighter = "PREYBIRD_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			IMPERIAL = "TIE_AVENGER_SQUADRON",
			GREATER_MALDROOD = "TIE_V1_SQUADRON",
			ERIADU_AUTHORITY = "TIE_X1_SQUADRON",
			PENTASTAR = "TIE_X2_SQUADRON",
			ZSINJ_EMPIRE = "TIE_AGGRESSOR_SQUADRON",
			EMPIREOFTHEHAND = "SCARSSIS_SQUADRON",
			HAPES_CONSORTIUM = "HOUSE_MIYTIL_FIGHTER_SQUADRON",
			CORPORATE_SECTOR = "DREXL_SQUADRON",
			HUTT_CARTELS = "CLOAKSHAPE_NEW_SQUADRON",
			MANDALORIANS = "FIRESPRAY_SQUADRON",
			CORELLIA = "HLAF_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "EMPIRE" and Check_Flags(flags,"EMPIRE_X1") then
			fighter = "TIE_X1_SQUADRON"
		end
		
		if is_main_empire then
			if regime == 4 then
				fighter = "SHADOW_DROID_LIGHT_SQUADRON"
			end
		end
		
		if owner == "REBEL" or alias == "REBEL" then
			if Check_Flags(flags,"DREXLX") and Get_Fighter_Research("CoS_Tevv") then
				fighter = "DREXL_SQUADRON"
			else
				if techLevel >= 4 then
					if Get_Fighter_Research("Ewing") then
						fighter = "E_WING_SQUADRON"
					else
						fighter = "E_WING_PROTOTYPE_SQUADRON"
					end
				else
					fighter = "X_WING_SQUADRON"
				end
			end
		end
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "ARMORED_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "ELITE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "T_WING_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "TIE_AGGRESSOR_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "MODERN_CLOAKSHAPE_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "ARC_170_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "STARWING_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "CLOAKSHAPE_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "PREYBIRD_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "MODERN_CLOAKSHAPE_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TIE_AGGRESSOR_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "STARWING_FIGHTER_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "BELBULLAB22_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "TIE_SENTINEL_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_AGGRESSOR_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_X1_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "DEFENSIVE_ETA2_ACTIS_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "TOSCAN_GUNSHIP_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "TIE_SENTINEL_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "TIE_V1_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "MODERN_CLOAKSHAPE_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "RIHKXYRK_SQUADRON" 
			elseif proteus == "WESSEX" then
				fighter = "TIE_X1_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "R42_FIGHTER_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "TIE_X1_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "TIE_SENTINEL_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "PROTECTORATE" then
				fighter = "TOSCAN_GUNSHIP_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "THORN" then
				fighter = "TIE_AVENGER_SQUADRON"
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
