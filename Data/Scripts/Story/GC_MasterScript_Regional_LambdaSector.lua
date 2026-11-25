--*******************************************
--****  Thrawn's Revenge: Lambda Sector  ****
--*******************************************

require("PGStoryMode")
require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("SetFighterResearch")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = {
		Trigger_Determine_Faction = State_Determine_Faction,
		Trigger_Delayed_Initialize = State_Delayed_Initialize,
		Trigger_Nantz_Arrives_Timer = State_Nantz_Arrives_Timer,
		Trigger_Storm_Commando_Debounce = State_Storm_Commando_Debounce,
		Trigger_Conquer_Tatooine = State_Conquer_Tatooine,
		Trigger_Conquer_Ryloth	= State_Conquer_Ryloth,
		Trigger_Fable_Timer	= State_Fable_Timer,
	}

	p_newrep = Find_Player("Rebel")
	p_naboo = Find_Player("Empire")
	p_eriadu = Find_Player("Eriadu_Authority")
	p_csa = Find_Player("Corporate_Sector")
	p_hutts = Find_Player("Hutt_Cartels")
	p_kamino = Find_Player("Zsinj_Empire")
	p_protectorate = Find_Player("Greater_Maldrood")
	p_lambda = Find_Player("Imperial_Proteus")

	FableNeedsSpawn = true
	Lose_Storms = true

	crossplot:galactic()

	crossplot:publish("OVERRIDE_AI_PLAYER","ALL_FACTIONS_AI", "CORPORATE_SECTOR", "GenericAI")
	crossplot:publish("OVERRIDE_AI_PLAYER","ALL_FACTIONS_CRUEL_AI", "CORPORATE_SECTOR", "SkynetAI")

	crossplot:subscribe("JENN_SMEEL_DEATH", Jenn_Smeel_Death)
	crossplot:subscribe("JAALIB_CAPTURE", Jaalib_Capture)
end

function State_Determine_Faction(message)
	if message == OnEnter then
		Set_Fighter_Research("Raptorless")
		Set_Fighter_Research("IMPERIAL_NABOO")
		GlobalValue.Set("PROTEUS_FIELD_BASE_PAD_OVERRIDE","Field_Base_Pad_Regional_LambdaSector")

		local tech_unit

		--Lambda Sector setup
		tech_unit = Find_Object_Type("COMPFORCE_ASSAULT_COMPANY")
		p_lambda.Unlock_Tech(tech_unit)
		tech_unit = Find_Object_Type("ISB_INFILTRATOR_COMPANY")
		p_lambda.Unlock_Tech(tech_unit)

		--Imperial Naboo setup
		tech_unit = Find_Object_Type("STORM_COMMANDO_COMPANY")
		p_naboo.Unlock_Tech(tech_unit)

		--Strike Cruiser unlock handled in State_Delayed_Initialize due to regime conflict

		tech_unit = Find_Object_Type("EIDOLON")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("S_1_FIREHAWKE_COMPANY")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IPV1")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("LANCER_FRIGATE")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("TON_FALK_ESCORT_CARRIER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("VINDICATOR_CRUISER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMMOBILIZER_418")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("VICTORY_I_STAR_DESTROYER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("VICTORY_II_STAR_DESTROYER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("PROCURSATOR_STAR_DESTROYER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("INTERDICTOR_STAR_DESTROYER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("TECTOR_STAR_DESTROYER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMPERIAL_AT_PT_COMPANY")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("CHARIOT_LAV_COMPANY")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("AT_AA_WALKER_COMPANY")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("SPMAG_WALKER_COMPANY")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("DEATHHAWK_COMPANY")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("STRIKE_CRUISER")
		p_naboo.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("TURR_PHENNIR_TIE_INTERCEPTOR_LOCATION_SET")
		p_naboo.Lock_Tech(tech_unit)

		--Imperial Kamino setup
		tech_unit = Find_Object_Type("KAMINO_OFFICE")
		p_kamino.Unlock_Tech(tech_unit)
		tech_unit = Find_Object_Type("ZE_CAPITAL_ALTERNATE")
		p_kamino.Unlock_Tech(tech_unit)

		tech_unit = Find_Object_Type("ZSINJ_OFFICE")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("RANCOR_BASE")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("RAPTOR_TROOPER_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("ZSINJ_74Z_BIKE_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMPERIAL_DROPSHIP_TRANSPORT_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("PIRATE_BASE")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("TETRAN_COWALL_LOCATION_SET")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMPERIAL_ARMY_TROOPER_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("PX10_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("REPULSOR_SCOUT_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMPERIAL_AT_AP_WALKER_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("SPMAT_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("TRACKED_SHIELD_DISABLER_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("A9_FLOATING_FORTRESS_COMPANY")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMPERIAL_CR90")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("CR92A")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("STAR_GALLEON")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("NEUTRON_STAR")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("DRAGON_HEAVY_CRUISER")
		p_kamino.Lock_Tech(tech_unit)
		tech_unit = Find_Object_Type("IMPERIAL_II_STAR_DESTROYER")
		p_kamino.Lock_Tech(tech_unit)

		--The Protectorate setup
		tech_unit = Find_Object_Type("TECTOR_STAR_DESTROYER")--Everything else handled in tech-era-one.lua
		p_protectorate.Lock_Tech(tech_unit)
		
		--CSA setup
		tech_unit = Find_Object_Type("MYRSK_LOCATION_SET")
		p_csa.Lock_Tech(tech_unit)

		if p_newrep.Is_Human() then
			Story_Event("NR_STORY_START")
		elseif p_naboo.Is_Human() then
			Story_Event("NABOO_STORY_START")
			GlobalValue.Set("IMPERIAL_NABOO", true)
		elseif p_lambda.Is_Human() then
			Story_Event("LAMBDA_STORY_START")
		elseif p_eriadu.Is_Human() then
			Story_Event("EA_STORY_START")
		elseif p_csa.Is_Human() then
			Story_Event("CSA_STORY_START")
		elseif p_hutts.Is_Human() then
			Story_Event("HUTT_STORY_START")
		elseif p_kamino.Is_Human() then
			Story_Event("KAMINO_STORY_START")
		elseif p_protectorate.Is_Human() then
			Story_Event("PROTECTORATE_STORY_START")
		end
	end
end

function State_Delayed_Initialize(message)
	if message == OnEnter then
		--Cut heroes known to be elsewhere to play up the theme of the NR being busy elsewhere and not really trying here
		crossplot:publish("COMMAND_STAFF_INITIALIZE", {
			["SUPCOM"] = {
				["SLOT_SET"] = 0,
			},
			["HIGHCOM"] = {
				["STORY_LOCK"] = {"Nantz","Drayson","Kalback","Burke","Nammo"},
			},
			["ADMIRAL"] = {
				["EXIT"] = {"Sovv","Ragab"},
			},
			["ARMY"] = {
				["LOCKIN"] = {"Garret"},
				["SLOT_ADJUST"] = -1,
				["STORY_LOCK"] = {"Calrissian", "Kryll","Cracken","Taskeen","Tantor","Veertag","Tulon"},
			},
			["JEDI"] = {
				["SLOT_ADJUST"] = -1,
			},
		})

		crossplot:publish("NR_FILTER_REMOVE", {"Wedge_Rogues_Location_Set", "Salm_Location_Set"}, 2)
		Clear_Fighter_Hero("WEDGE_ANTILLES_ROGUE_SQUADRON")
		Clear_Fighter_Hero("SALM_Y_WING_SQUADRON")

		--renames
		crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", "ZSINJ_EMPIRE", "Imperial Kamino")
		crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", "GREATER_MALDROOD", "The Protectorate")

		crossplot:publish("WARLORD_CHOICE_OPTION", "LAMBDA", true)

		--if included in State_Determine_Faction, the Pestage regime overrides
		p_naboo.Unlock_Tech(Find_Object_Type("STRIKE_CRUISER"))

		crossplot:publish("INITIALIZE_AI", "empty")
	else
		crossplot:update()
	end
end

function State_Nantz_Arrives_Timer(message)
	if message == OnEnter then
		crossplot:publish("COMMAND_STAFF_RETURN", {"Nantz"}, "HIGHCOM")
		crossplot:publish("COMMAND_STAFF_RETURN", {"Taskeen"}, "ARMY")

		if p_newrep.Is_Human() then
			StoryUtil.Multimedia("TEXT_CONQUEST_LAMBDASECTOR_NR_NANTZ", 20, nil, "Leia_Loop", 0)
		end
	else
		crossplot:update()
	end
end

function Jenn_Smeel_Death()
	if not Lose_Storms then
		return
	end

	local tech_unit = Find_Object_Type("STORM_COMMANDO_COMPANY")
	p_naboo.Lock_Tech(tech_unit)
	if p_naboo.Is_Human() then
		StoryUtil.Multimedia("TEXT_CONQUEST_LAMBDASECTOR_NABOO_SMEEL", 20, nil, "Quarsh_Panaka_Loop", 0)
	end
end

function State_Storm_Commando_Debounce(message)
	if message == OnEnter then
		local Weir = Find_First_Object("Weir").Get_Owner()
		if Weir == p_naboo then
			Lose_Storms = false
		end
	else
		crossplot:update()
	end
end

function State_Conquer_Tatooine(message)
	if message == OnEnter then
		if FindPlanet("Tatooine").Get_Owner() == p_protectorate then
			Spawn_Fable_Astin()
		end
	else
		crossplot:update()
	end
end

function State_Conquer_Ryloth(message)
	if message == OnEnter then
		if FindPlanet("Ryloth").Get_Owner() == p_protectorate then
			Spawn_Fable_Astin()
		end
	else
		crossplot:update()
	end
end

function State_Fable_Timer(message)
	if message == OnEnter then
		Spawn_Fable_Astin()
	else
		crossplot:update()
	end
end

function Spawn_Fable_Astin()
	if not FableNeedsSpawn then
		return
	end

	FableNeedsSpawn = false
	local spawn = StoryUtil.SpawnAtSafePlanet("TRULALIS", p_protectorate, StoryUtil.GetSafePlanetTable(), {"FABLE_ASTIN_TEAM"}, true, false)
	if p_protectorate.Is_Human() then
		StoryUtil.Multimedia("TEXT_CONQUEST_LAMBDASECTOR_PROTECTORATE_FABLE", 20, nil, "Generic_Sith_Loop", 0)
	end
end

function Jaalib_Capture()
	if not FableNeedsSpawn then
		return
	end

	FableNeedsSpawn = false
	local spawn = StoryUtil.SpawnAtSafePlanet("TRULALIS", p_protectorate, StoryUtil.GetSafePlanetTable(), {"JAALIB_BRANDL_PROTECTORATE_I","FABLE_ASTIN_TEAM"}, true, false)
	if p_newrep.Is_Human() then
		StoryUtil.Multimedia("TEXT_CONQUEST_LAMBDASECTOR_NR_FABLE", 20, nil, "Luke_Loop", 0)

		if GlobalValue.Get("CRUEL_ON") == 1 then
			StoryUtil.ChangeAIPlayer("GREATER_MALDROOD", "SkynetAI")
		else
			StoryUtil.ChangeAIPlayer("GREATER_MALDROOD", "IsolationistAI")
		end

		crossplot:publish("OVERRIDE_AI_PLAYER","ALL_FACTIONS_AI", "GREATER_MALDROOD", "IsolationistAI")
		crossplot:publish("OVERRIDE_AI_PLAYER","ALL_FACTIONS_CRUEL_AI", "GREATER_MALDROOD", "SkynetAI")
	end
	if p_protectorate.Is_Human() then
		StoryUtil.Multimedia("TEXT_CONQUEST_LAMBDASECTOR_PROTECTORATE_JAALIB", 20, nil, "Generic_Sith_Loop", 0)
	end
end
