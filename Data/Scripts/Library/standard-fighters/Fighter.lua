require("StandardFighterFunctions")

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
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "UPGUNNED_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "UPGUNNED_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "MISSILE_TIE_FIGHTER_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "TIE_INTERCEPTOR_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "SHIELDED_MISSILE_TIE_FIGHTER_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_FIGHTER_BF2_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "MANTA_FIGHTER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_X1_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "NIMBUS_V_WING_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TIE_SENTINEL_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_POD_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "R41_STARCHASER_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "A9_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "Z95_HEADHUNTER_SQUADRON" --TBC Replace with Drexl upon upgrade
				if Get_Fighter_Research("KPreybird") then
				fighter = "DREXL_SQUADRON"
				end
			elseif proteus == "TAMARIN" then
				fighter = "Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "TIE_FIGHTER_SQUADRON" 
				if Get_Fighter_Research("BGPA") then
					fighter = "BAKURAN_GPA_SQUADRON"
				end
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "TIE_FIGHTER_BF2_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "R41_STARCHASER_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "R41_STARCHASER_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "HOWLRUNNER_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_X1_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "HOWLRUNNER_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "N1_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "CLONE_Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "MISSILE_TIE_FIGHTER_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "SHIELDED_MISSILE_TIE_FIGHTER_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "PROTECTORATE" then
				fighter = "STARVIPER_II_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"
			elseif proteus == "THORN" then
				fighter = "TIE_FIGHTER_BF2_SQUADRON"
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
