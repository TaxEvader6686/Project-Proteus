require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")
require("eawx-util/MissionUtil")
require("StandardFighterFunctions")

function Definitions()
	--DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);

	ServiceRate = 1
end

function State_Init(message)
	if Find_Hint("ATTACKER ENTRY POSITION", "main-menu-battle-disable-me") then
		ScriptExit()
	end

	if Get_Game_Mode() ~= "Land" then
		if Get_Game_Mode() == "Space" then
			GlobalValue.Set("GARRISON_UNITS", nil)----Resets the table of units set as garrisons at the start of every battle
			ScriptExit()
		else
			ScriptExit()
		end
	end


	if message == OnEnter then
		if not ModContentLoader then
			ModContentLoader = require("eawx-std/ModContentLoader")
		end
		
		local reinforcementPointTypes = {
			"Reinforcement_Point",
			"Reinforcement_Point_Plus4_Cap",
			"Reinforcement_Point_Plus5_Cap",
			"Reinforcement_Point_Plus6_Cap",
			"Reinforcement_Point_Plus7_Cap",
			"Reinforcement_Point_Plus8_Cap",
			"Reinforcement_Point_Plus10_Cap"
			}

		local lowReinforcementPointTypes = {
			"Victory_Point",
			"Reinforcement_Point_Plus1_Cap",
			"Reinforcement_Point_Plus2_Cap",
			"Reinforcement_Point_Plus3_Cap",
			}
		
		local p_neutral = Find_Player("Neutral")
		
		for _, point_type in pairs(reinforcementPointTypes) do
			--DebugMessage("Checking for point type %s", point_type)
			local reinforcementPoints = Find_All_Objects_Of_Type(point_type)
			
			if reinforcementPoints ~= nil then
				local unit = Find_Object_Type("Field_Base_Pad")
				if GlobalValue.Get("PROTEUS_FIELD_BASE_PAD") then
					if Find_Object_Type(GlobalValue.Get("PROTEUS_FIELD_BASE_PAD")) ~= nil then
						unit = Find_Object_Type(GlobalValue.Get("PROTEUS_FIELD_BASE_PAD"))
					end
				end
				if GlobalValue.Get("PROTEUS_FIELD_BASE_PAD_OVERRIDE") then
					if Find_Object_Type(GlobalValue.Get("PROTEUS_FIELD_BASE_PAD_OVERRIDE")) ~= nil then
						unit = Find_Object_Type(GlobalValue.Get("PROTEUS_FIELD_BASE_PAD_OVERRIDE"))
					end
				end				
				--DebugMessage("Spawning field base pads at point type %s", point_type)
				for _, point in pairs(reinforcementPoints) do
					Create_Generic_Object(unit, point.Get_Position(), p_neutral)
				end
			end
		end

		for _, point_type in pairs(lowReinforcementPointTypes) do
			--DebugMessage("Checking for point type %s", point_type)
			local reinforcementPoints = Find_All_Objects_Of_Type(point_type)
			
			if reinforcementPoints ~= nil then
				--DebugMessage("Spawning field base pads at point type %s", point_type)
				for _, point in pairs(reinforcementPoints) do
					unit = Find_Object_Type("Field_Base_Pad_Emplacement")
					Create_Generic_Object(unit, point.Get_Position(), p_neutral)
				end
			end
		end

		p_attacker = MissionUtil.Find_Attacking_Player()
		ai_awake = nil
		--DebugMessage("DetermineEvents Ground Handler Finished")

	elseif message == OnUpdate then	
		--DebugMessage("DetermineEvents Ground Handler Update Started")
		if ai_awake == nil then
			repeat
				Sleep(0.1)
				ai_awake = EvaluatePerception("Disable_Bombardment", p_attacker)
			until ai_awake ~= nil
		end

		if EvaluatePerception("Disable_Bombardment", p_attacker) > 0 then
			p_attacker.Disable_Orbital_Bombardment(true)
			--DebugMessage("Bombardment disabled for %s", tostring(player.Get_Faction_Name()))
		else
			p_attacker.Disable_Orbital_Bombardment(false)
			--DebugMessage("Bombardment enabled for %s", tostring(player.Get_Faction_Name()))
		end
		--DebugMessage("DetermineEvents Ground Handler Update Finished")
	end
end
