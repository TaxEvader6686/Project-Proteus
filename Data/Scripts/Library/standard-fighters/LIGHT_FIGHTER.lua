require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "Z95_HEADHUNTER_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
			owner = native
		end
		
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
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "R22_SPEARHEAD_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "TIE_FIGHTER_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "NIMBUS_V_WING_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_X3_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_X3_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "TIE_Fighter_BF2_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "TIE_DROID_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "TIE_FIGHTER_SQUADRON" --TBC Upgrade to BF2 Fighter
				if Get_Fighter_Research("KSM") then
					fighter = "TIE_FIGHTER_BF2_SQUADRON"
				end
			elseif proteus == "LUMIYA" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_FIGHTER_SQUADRON" 
			elseif proteus == "KUAT" then
				fighter = "NIMBUS_V_WING_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "Z95_HEADHUNTER_SQUADRON" 
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "SWARM_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "NIMBUS_V_WING_ESK_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "TIE_INTERCEPTOR_SQUADRON" --Shielded Upgrade and Time switch to droids? But also, Prakith always starts late...
			elseif proteus == "RADAMA" then
				fighter = "TIE_FIGHTER_SQUADRON" --Custom Vulture Spawn on Providences
			elseif proteus == "MAELSTROM" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "NIMBUS_V_WING_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "MISSILE_TIE_FIGHTER_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "TIE_STARFIGHTER_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_X3_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "TIE_FIGHTER_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "SHIELDED_TIE_FIGHTER_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "PROTECTORATE" then
				fighter = "STARVIPER_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "NIMBUS_V_WING_ESK_SQUADRON"
			elseif proteus == "THORN" then
				fighter = "NIMBUS_V_WING_SQUADRON"
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
