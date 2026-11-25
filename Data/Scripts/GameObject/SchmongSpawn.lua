require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if Get_Game_Mode() ~= "Space" then
		ScriptExit()
	end
	
	--put era limited ships at the end of the list so they can be easily restricted
	stolen_ships = {
			"Scarssis_Squadron",
			"TIE_Punisher_Squadron_Half",
			"TIE_Hunter_Squadron",
			"Furion_Squadron",
			"T_Wing_Squadron",
			"BTLB_Y_Wing_Squadron",
			"2_Warpod_Squadron",
			"Miytil_Bomber_Squadron",
			"Miytil_Fighter_Squadron",
			"V38_Squadron",
			"ARC_170_Squadron",
			"StarViper_Squadron",
			"StarViper_II_Squadron",
			"Aggressor_Assault_Fighter_Squadron",
			"Rihkxyrk_Squadron",
			"Preybird_Squadron",
			"Drexl_Squadron_Double",
			"TIE_Defender_Squadron",
			"TIE_Avenger_Squadron",
			"Clutch_Squadron_Double",
			"TIE_Heavy_Bomber_Squadron",
			"Starwing_Squadron",
			"TIE_Sentinel_Squadron_Double",
			"Missile_Boat_Squadron",
			"TIE_Aggressor_Squadron_Double",
			"B_Wing_Squadron",
			"Trifoil_Squadron_Double",
			"Shielded_TIE_Raptor_Squadron",
			"TIE_Terror_Squadron",
			"TIE_Oppressor_Squadron",
			"X_Wing_Squadron",
			"Chirdaki_Squadron_Double",
			"BTLS1_Y_Wing_Squadron",
			"Y_Wing_Squadron",
			"A_Wing_Squadron",
			"Advanced_Skipray_Squadron",
			"I_BEAM_Squadron_Double",
			"HLAF_Squadron_Double",
			"N1_Squadron",
			"G1_Squadron",
			"R22_Spearhead_Squadron",
			"ATL_Interceptor_Squadron",
			"Firespray_Squadron",
			"Firespray_Gunship_Squadron",
			"Firespray_Bomber_Squadron",
			"Scurrg_H6_Prototype_Squadron",
			"Scurrg_H6_Squadron",
			"H_Wing_Squadron",
			"Royal_Guard_Interceptor_Squadron",
			"TIE_X2_Squadron",
			"TIE_X3_Squadron",
			"TIE_X7_Squadron",
			"Bakuran_GPA_Squadron_Double",
			"Dunelizard_Interceptor_Squadron_Double",
			"Umbaran_Starfighter_Squadron",
			
			"E_Wing_Prototype_Squadron",
			"E_Wing_Squadron",
			"Scimitar_Squadron",
			"K_Wing_Prototype_Squadron",
			"K_Wing_Squadron",
			"B_Wing_E_Squadron",
			}
			
	local squad_count = GameRandom(3, 5)
	local max_pick = table.getn(stolen_ships)
	
	techLevel = GlobalValue.Get("CURRENT_ERA")
	
	if techLevel < 6 then
		max_pick = max_pick - 3
	end
	
	if techLevel < 3 then
		max_pick = max_pick - 3
	end
	
	for spawns = 1, squad_count do
		local rando = GameRandom(1, max_pick)
		Spawn_Unit(Find_Object_Type(stolen_ships[rando]), Find_First_Object("Kiara_Schmong"), Object.Get_Owner())
	end
	
	Object.Despawn()
	
	ScriptExit()
end