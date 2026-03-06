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
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "ARC_170_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "TIE_DEFENDER_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_HUNTER_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TRIFIGHTER_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "TIE_DEFENDER_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "TOSCAN_MISSILE_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "BTLA4_YWING_STARFIGHTER_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "TIE_GT_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}