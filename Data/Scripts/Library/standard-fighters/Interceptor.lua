require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local double = false
		local fighter = "MANKVIM_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			REBEL = "A_WING_SQUADRON",
			EMPIREOFTHEHAND = "KRSSIS_INTERCEPTOR_SQUADRON",
			HAPES_CONSORTIUM = "MIYTIL_FIGHTER_SQUADRON",
			CORPORATE_SECTOR = "MANKVIM_SQUADRON",
			HUTT_CARTELS = "DUNELIZARD_INTERCEPTOR_SQUADRON",
			MANDALORIANS = "DUNELIZARD_INTERCEPTOR_SQUADRON",
			YEVETHA = "TRIFOIL_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if alias == "IMPERIAL" then
			fighter = "TIE_INTERCEPTOR_SQUADRON"
			if owner == "ZSINJ_EMPIRE" then
				if not Get_Fighter_Research("Raptorless") then
					fighter = "TIE_RAPTOR_SQUADRON"
				end
			elseif owner == "ERIADU_AUTHORITY" then
				if Get_Fighter_Research("EATIEShields") then
					if Get_Fighter_Research("ArmoredTIE") then
						fighter = "SHIELDED_ARMORED_INTERCEPTOR_SQUADRON"
					else
						fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
					end
					else
					if Get_Fighter_Research("ArmoredTIE") then
						fighter = "ARMORED_INTERCEPTOR_SQUADRON"
					else
						fighter = "TIE_INTERCEPTOR_SQUADRON"
					end
				end
			elseif owner == "GREATER_MALDROOD" and Get_Fighter_Research("MissileTIE") then
				fighter = "MISSILE_TIE_INTERCEPTOR_SQUADRON"
			end
			if is_main_empire and Check_Flags(flags,"ISD") then
				if regime == 4 or regime == 6 then
					fighter = "A9_SQUADRON"
				elseif regime == 5 then
					fighter = "ROYAL_GUARD_INTERCEPTOR_SQUADRON"
				elseif regime == 7 then
					fighter = "PREYBIRD_SQUADRON"
				end
			end
			if Check_Flags(flags,"SHIELDED_IN") or Check_Flags(flags,"SHIELDED_FIGHTERS") then
				if owner ~= "ZSINJ_EMPIRE" then
					fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
				else
					fighter = "SHIELDED_TIE_RAPTOR_SQUADRON"
				end
			end
		elseif owner == "REBEL" and native ~= "IMPERIAL" then
			local test = Find_First_Object("TALLON_SILENT_WATER")
			if TestValid(test) then
				double = true
			end
		elseif owner == "REBEL" and native == "IMPERIAL" then
			fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
		end
		
		if double then
			suffix = Double_Suffix(suffix)
		end
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "T_WING_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "V38_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "TIE_SENTINEL_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "TOSCAN_INTERCEPTOR_SQUADRON"
			elseif proteus == "VOGEL" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "NIMBUS_V_WING_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "UPGUNNED_TIE_INTERCEPTOR_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "TIE_PHANTOM_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "NIMBUS_V_WING_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "TIE_X2_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "VULTURE_BROWN_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "UPGUNNED_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "SHIELDED_TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "A9_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			elseif proteus == "TAMARIN" then
				fighter = "NIMBUS_V_WING_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "TIE_INTERCEPTOR_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}