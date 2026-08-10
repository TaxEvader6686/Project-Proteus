require("StandardFighterFunctions")

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
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "MISSILE_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "MISSILE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "TIE_GT_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "TIE_X2_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "MISSILE_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_V1_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "CLONE_Z95_HEADHUNTER_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "ASSAULT_ETA2_ACTIS_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "CLONE_Z95_HEADHUNTER_SQUADRON" 
			elseif proteus == "TAMARIN" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON" --Upgrade to Assault ETA 2?
			elseif proteus == "RAYTER" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "G1_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "PROTECTORATE" then
				fighter = "Z95ML_HEADHUNTER_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "SCYK_HEAVY_FIGHTER_SQUADRON"
			elseif proteus == "THORN" then
				fighter = "TIE_GT_SQUADRON"
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
