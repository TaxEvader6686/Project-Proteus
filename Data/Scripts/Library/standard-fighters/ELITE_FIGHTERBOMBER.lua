require("StandardFighterFunctions")

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
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end

		if is_main_empire then
			if regime == 4 then
				fighter = "SHADOW_DROID_HEAVY_SQUADRON"
			end
		end
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "TIE_GT_TORPS_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "ARC_170_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "TIE_AVENGER_ASSAULT_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_HUNTER_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "STARWING_ASSAULT_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "ARC_170_SQUADRON" --TBC TIE Defender Spawn on Stations
			elseif proteus == "LUMIYA" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "STARWING_ASSAULT_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "DREXL_SQUADRON" --TBC
				if Get_Fighter_Research("KPreybird") then
				fighter = "PREYBIRD_SQUADRON"
				end
			elseif proteus == "TAMARIN" then
				fighter = "BTLA4_YWING_STARFIGHTER_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "TIE_GT_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "RADAMA" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "IXIYEN_FIGHTER_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "TIE_AVENGER_ASSAULT_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "MISSILE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "TIE_DEFENDER_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "PROTECTORATE" then
				fighter = "TIE_AVENGER_TORPS_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "THORN" then
				fighter = "TIE_DEFENDER_SQUADRON"
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
