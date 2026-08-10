require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "EARLY_SKIPRAY_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = "IMPERIAL"
		end
		
		local simpletypes = {
			IMPERIAL = "SKIPRAY_SQUADRON",
			PENTASTAR = "ADVANCED_SKIPRAY_SQUADRON",
			GREATER_MALDROOD = "EARLY_SKIPRAY_SQUADRON",
			ERIADU_AUTHORITY = "EARLY_SKIPRAY_SQUADRON",
			REBEL = "SKIPRAY_SQUADRON",
			MANDALORIANS = "FIRESPRAY_GUNSHIP_SQUADRON",
			HUTT_CARTELS = "KRAYT_GUNSHIP_SQUADRON",
			YEVETHA = "SKIPRAY_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "IMPERIAL_PROTEUS" then
			local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
			if proteus == "TAGGE" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "TIERFON" then
				fighter = "ADVANCED_SKIPRAY_SQUADRON"
			elseif proteus == "SELLASAS" then
				fighter = "ADVANCED_SKIPRAY_SQUADRON"
			elseif proteus == "DASTA" then
				fighter = "VCX_820_SQUADRON" 
			elseif proteus == "VOGEL" then
				fighter = "SKIPRAY_INTERCEPTOR_SQUADRON"
			elseif proteus == "BRAK" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
				if Get_Fighter_Research("BrakFighters") then
					fighter = "ADVANCED_SKIPRAY_SQUADRON"
				end
			elseif proteus == "ISECTOR" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "PRAJI" then
				fighter = "SKIPRAY_INTERCEPTOR_SQUADRON"
			elseif proteus == "SHADOWSPAWN" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "TAPANI" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "RESTORED_EMPIRE" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "ZAARIN_REMNANTS" then
				fighter = "ADVANCED_SKIPRAY_SQUADRON"
			elseif proteus == "ELROOD" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "WILD_SPACE" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "PRENTIOCH" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "JARDEEN" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "KASHYYYK" then
				fighter = "SKIPRAY_INTERCEPTOR_SQUADRON"
			elseif proteus == "LUMIYA" then
				fighter = "THETA_ASSAULT_SQUADRON"
			elseif proteus == "ARDA" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "CATO_NEIMOIDIA" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "KUAT" then
				fighter = "FIRESPRAY_GUNSHIP_SQUADRON"
			elseif proteus == "KAARENTH_DISSENSION" then
				fighter = "SKIPRAY_SQUADRON"
				if Get_Fighter_Research("SkiprayZeta") then
					fighter = "SKIPRAY_ION_SQUADRON"
				end
			elseif proteus == "TAMARIN" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "BAKURA" then
				fighter = "ADVANCED_SKIPRAY_SQUADRON"
			elseif proteus == "ANTEMERIDIAS" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "SECTOR_5" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "PRAKITH" then
				fighter = "THETA_ASSAULT_SQUADRON" 
			elseif proteus == "RADAMA" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "MAELSTROM" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "PROPHETS" then
				fighter = "THETA_ASSAULT_SQUADRON"
			elseif proteus == "RAYTER" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "WESSEX" then
				fighter = "FIRESPRAY_GUNSHIP_SQUADRON"
			--elseif proteus == "HAMMERS" then
				--fighter = ""
			elseif proteus == "QUINTAD" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "IMPERIAL_LIANNA" then
				fighter = "ADVANCED_SKIPRAY_SQUADRON"
			elseif proteus == "GAROS" then
				fighter = "VCX_820_SQUADRON"
			elseif proteus == "NABOO" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "KAMINO" then
				fighter = "SKIPRAY_SQUADRON"
			elseif proteus == "CIUTRIC_HEGEMONY" then
				fighter = "EARLY_SKIPRAY_SQUADRON"
			elseif proteus == "ZERO_COMMAND" then
				fighter = "SKIPRAY_SQUADRON"
			--elseif proteus == "LAMBDA" then
				--fighter = ""
			elseif proteus == "PROTECTORATE" then
				fighter = "FIRESPRAY_GUNSHIP_SQUADRON"
			elseif proteus == "GRUNGER" then
				fighter = "ADVANCED_SKIPRAY_SQUADRON"
			elseif proteus == "THORN" then
				fighter = "THETA_ASSAULT_SQUADRON"
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
