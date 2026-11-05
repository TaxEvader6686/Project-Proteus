require("RandomReplaceSpawn")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then		
		RandomInfantry = {
			{"Hutt_Guard_Company"},
			{"Gamorrean_Guard_Company"},
			{"Armored_Hutt_Company"},
			{"Trandoshan_Hunter_Company"},
			{"Ailon_Nova_Guard_Influence_Company"},
			{"Sun_Guard_Influence_Company"},
			{"Nimbus_Commando_Influence_Company"},
			{"Mandalorian_Soldier_Influence_Company"},
			{"Mandalorian_Commando_Influence_Company"},
			{"Neimoidian_Guard_Company"},
			{"Mercenary_Phalanx_Trooper_Company"},
			{"CSA_Destroyer_Droid_Company"},
			{"CSA_B1_Droid_Company"},
			{"B2_Droid_Company"},
			{"Backwater_Soldier_Company"},
			{"PDF_Soldier_Company"},
			{"Military_Soldier_Company"},
			{"PDF_Tactical_Unit_Company"},
			{"Heavy_PDF_Company"},
			{"Scavenger_Company"},
			{"Heavy_Scavenger_Company"},
			{"Imperial_Navy_Trooper_Company"},
			{"Imperial_Army_Trooper_Company"},
			{"Faux_Stormtrooper_Company"},
			{"Navy_Commando_Company"},
		}
		
		Random_Replacement(Object, RandomInfantry, false)
        ScriptExit()
    end
end
