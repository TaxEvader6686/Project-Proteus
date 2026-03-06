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
				fighter = "V38_SQUADRON"
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
				fighter = "ARMORED_INTERCEPTOR_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "ETA2_ACTIS_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "ARC_170_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "TRIFIGHTER_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "V38_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "TIE_X7_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_SENTINEL_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_AVENGER_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "V38_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "V38_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "T_WING_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "TOSCAN_INTERCEPTOR_SQUADRON"
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