--******************************************
--*  Thrawn's Revenge: Deep Core Conflict  *
--******************************************

require("PGStoryMode")
require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("SetFighterResearch")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = {
		Trigger_Determine_Faction = State_Determine_Faction,
		Trigger_Era_Selection = State_Era_Selection,
		Trigger_Delayed_Initialize = State_Delayed_Initialize,
		Trigger_Night_Hammer_Complete = State_Night_Hammer_Complete,
		Trigger_Megador_And_Dominion = State_Megador_And_Dominion,
	}

	p_harrsk = Find_Player("Empire")
	p_eriadu = Find_Player("Eriadu_Authority")
	p_maldrood = Find_Player("Greater_Maldrood")
	p_yzu = Find_Player("Imperial_Proteus")

	crossplot:galactic()
end

function State_Determine_Faction(message)
	if message == OnEnter then
		local tech_unit = Find_Object_Type("TURR_PHENNIR_TIE_INTERCEPTOR_LOCATION_SET")
		p_harrsk.Lock_Tech(tech_unit)

		if p_harrsk.Is_Human() then
			Story_Event("GE_STORY_START")
		elseif p_eriadu.Is_Human() then
			Story_Event("EA_STORY_START")
		elseif p_maldrood.Is_Human() then
			Story_Event("GM_STORY_START")
		elseif p_yzu.Is_Human() then
			Story_Event("IP_STORY_START")
		end
	end
end

function State_Era_Selection(message)
	if message == OnEnter then
		Set_Fighter_Research("V38")
		GlobalValue.Set("PROTEUS_FIELD_BASE_PAD_OVERRIDE","Field_Base_Pad_Regional_DeepCoreConflict")

		credits = p_maldrood.Get_Credits()
		techLevel = (credits / 1000) + 1

		p_maldrood.Give_Money(8000-credits)
		p_harrsk.Give_Money(8000-credits)
		p_eriadu.Give_Money(8000-credits)
		p_yzu.Give_Money(8000-credits)

		if techLevel < 3 then
			Story_Event("AI_NOTIF_START_ERA_1")
			techLevel = 1
		elseif techLevel == 3 then
			Story_Event("AI_NOTIF_START_ERA_3")
			techLevel = 3
		elseif techLevel == 4 or techLevel == 5 then
			Story_Event("AI_NOTIF_START_ERA_4")
			techLevel = 4

			StoryUtil.SetTechLevel(p_maldrood, 2)
			StoryUtil.SetTechLevel(p_eriadu, 2)
			StoryUtil.SetTechLevel(p_yzu, 2)
		else
			Story_Event("AI_NOTIF_START_ERA_6")
			techLevel = 6

			StoryUtil.SetTechLevel(p_maldrood, 3)
			StoryUtil.SetTechLevel(p_eriadu, 3)
			StoryUtil.SetTechLevel(p_yzu, 3)

			NH_upgrade = Find_Object_Type("Delvardus_Brilliant_Night_Hammer_Dummy")
			p_eriadu.Lock_Tech(NH_upgrade)
		end

		GlobalValue.Set("CURRENT_ERA", techLevel)
	end
end

function State_Delayed_Initialize(message)
	if message == OnEnter then
		crossplot:publish("WARLORD_CHOICE_OPTION", "SECTOR_5", true)

		--renames
		crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", "EMPIRE", "Zero Command")

		crossplot:publish("INITIALIZE_AI", "empty")
	else
		crossplot:update()
	end
end

function State_Night_Hammer_Complete(message)
	if message == OnEnter then
		p_eriadu = Find_Player("Eriadu_Authority")

		start_planet = FindPlanet("Kampe")
		if not StoryUtil.CheckFriendlyPlanet(start_planet,p_eriadu) then
			start_planet = StoryUtil.FindFriendlyPlanet(p_eriadu)
		end
		if start_planet then
			spawn_list_Night_Hammer = {"Cronus_Night_Hammer"}
			SpawnList(spawn_list_Night_Hammer, start_planet, p_eriadu, true, false)
		end
	end
end

function State_Megador_And_Dominion(message)
	if message == OnEnter then
		p_harrsk = Find_Player("Empire")
		if not p_harrsk.Is_Human() then
			start_planet = FindPlanet("Thomork")
			if not StoryUtil.CheckFriendlyPlanet(start_planet,p_harrsk) then
				start_planet = StoryUtil.FindFriendlyPlanet(p_harrsk)
			end
			if start_planet then
				spawn_list_duo = {"Megador", "Dominion"}
				SpawnList(spawn_list_duo, start_planet, p_harrsk, true, false)
			end
		end
	end
end
