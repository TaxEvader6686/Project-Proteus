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
		
		local proteustypes = {--{"Alternate field base pad for the group", "false or fighter research to switch to alternate pad", "Alternate field base pad"}
			ANTEMERIDIAS = {"Field_Base_Pad_Antemeridias", false},
			ARDA = {"Field_Base_Pad_Arda", false},
			BAKURA = {"Field_Base_Pad_Bakura", false},
			BRAK = {"Field_Base_Pad_Brak", false},
			CATO_NEIMOIDIA = {"Field_Base_Pad_Neimoidia", false},
			CIUTRIC_HEGEMONY = {"Field_Base_Pad_Ciutric", false},
			DASTA = {"Field_Base_Pad_Dasta", false},
			ELROOD = {"Field_Base_Pad_Elrood", false},
			GAROS = {"Field_Base_Pad_Garos", false},
			HAMMERS = {"Field_Base_Pad_Hammers", false},
			IMPERIAL_LIANNA = {"Field_Base_Pad_Imperial_Lianna", false},
			ISECTOR = {"Field_Base_Pad_Isector", false},
			JARDEEN = {"Field_Base_Pad_Jardeen", false},
			KAARENTH_DISSENSION = {"Field_Base_Pad_Kaarenth", false},
			KAMINO = {"Field_Base_Pad_Kamino", false},
			KASHYYYK = {"Field_Base_Pad_Kashyyyk", false},
			KUAT = {"Field_Base_Pad_Kuat", false},
			LAMBDA = {"Field_Base_Pad_Lambda", "IMPERIAL_NABOO", "Field_Base_Pad_Regional_LambdaSector"},--using the research for the lambda Sector GC, so no research for the groups present there without doing some specific setup below (and making a bunch of new field base pads)
			LUMIYA = {"Field_Base_Pad_Lumiya", false},
			MAELSTROM = {"Field_Base_Pad_Maelstrom", false},
			NABOO = {"Field_Base_Pad_Naboo", false},
			PRAKITH = {"Field_Base_Pad_Prakith", false},
			PRENTIOCH = {"Field_Base_Pad_Prentioch", false},
			PROPHETS = {"Field_Base_Pad_Prophets", false},
			PROTECTORATE = {"Field_Base_Pad_Protectorate", false},
			QUINTAD = {"Field_Base_Pad_Quintad", false},
			RADAMA = {"Field_Base_Pad_Radama", false},
			RAYTER = {"Field_Base_Pad_Rayter", false},
			RESTORED_EMPIRE = {"Field_Base_Pad_Restored_Empire", false},
			SECTOR_5 = {"Field_Base_Pad_Sector_5", "V38", "Field_Base_Pad_Regional_DeepCoreConflict"},--using the research for the Deep Core Conflict GC, so no research for the groups present there without doing some specific setup below (and making a bunch of new field base pads)
			SELLASAS = {"Field_Base_Pad_Sellasas", false},
			SHADOWSPAWN = {"Field_Base_Pad_Shadowspawn", false},
			TAGGE = {"Field_Base_Pad_Tagge", false},
			TAMARIN = {"Field_Base_Pad_Tamarin", false},
			TAPANI = {"Field_Base_Pad_Tapani", false},
			TIERFON = {"Field_Base_Pad_Tierfon", false},
			VOGEL = {"Field_Base_Pad_Vogel", false},
			WESSEX = {"Field_Base_Pad_Wessex", false},
			WILD_SPACE = {"Field_Base_Pad_Wild_Space", false},
			ZAARIN_REMNANTS = {"Field_Base_Pad_Zaarin", false},
			ZERO_COMMAND = {"Field_Base_Pad_Zero_Command", false},
			ZSINJ_REMNANTS = {"Field_Base_Pad_Zsinj_Remnants", false},
		--	ANAXES = {"Field_Base_Pad_Anaxes", false},--TODO
			ALLIED_TION = {"Field_Base_Pad_Allied_Tion", false},
			BALMORRA = {"Field_Base_Pad_Balmorra", false},
		--	CARIDA = {"Field_Base_Pad_Carida", false},--TODO
		--	CENTRALITY = {"Field_Base_Pad_Centrality", false},--TODO
			EMPIRE_REBORN = {"Field_Base_Pad_Empire_Reborn", false},
			GRUNGER = {"Field_Base_Pad_Grunger", false},
		--	LANOX = {"Field_Base_Pad_Lanox", false},--TODO
			PRAJI = {"Field_Base_Pad_Praji", false},
			RENDILI = {"Field_Base_Pad_Rendili", false},
		--	SCREED = {"Field_Base_Pad_Screed", false},--TODO
			SECOND_IMPERIUM = {"Field_Base_Pad_Second_Imperium", false},
		--	STORM_COMMANDOS = {"Field_Base_Pad_Storm_Commandos", false},--TODO
			THORN = {"Field_Base_Pad_Thorn", false},
		--	THARKUS = {"Field_Base_Pad_Tharkus", false},--TODO
			VEERS = {"Field_Base_Pad_Veers", false},
		--	BRANDEI = {"Field_Base_Pad_Brandei", false},--TODO
			X1 = {"Field_Base_Pad_X1", false},
			SECRET = {"Field_Base_Pad_Secret", false},
			}
		
		local p_neutral = Find_Player("Neutral")
		
		for _, point_type in pairs(reinforcementPointTypes) do
			--DebugMessage("Checking for point type %s", point_type)
			local reinforcementPoints = Find_All_Objects_Of_Type(point_type)
			
			if reinforcementPoints ~= nil then
				local unit = Find_Object_Type("Field_Base_Pad")
				if GlobalValue.Get("PROTEUS_GROUP_NAME") ~= nil then
					local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
					if proteustypes[proteus] then
						unit = Find_Object_Type(proteustypes[proteus][1])
						if proteustypes[proteus][2] ~= false then
							if Get_Fighter_Research(proteustypes[proteus][2]) then
								unit = Find_Object_Type(proteustypes[proteus][3])
							end
						end
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
