require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/RandomDistribution")
require("UnitSpawnerTables")
CONSTANTS = ModContentLoader.get("GameConstants")

-- Changes Planet owner to new Owner and randomly populates with fleet adjusted around inserted combat power value
function ChangePlanetOwnerAndPopulate(planet, newOwner, combat_power, overrideOwner, limit_ground_structures, no_structures, max_ground_units)
	DebugMessage("%s -- entering ChangePlanetOwnerAndPopulate", tostring(Script))
	-- Possible spawning units
		-- Arranged as Unit_Table = {{Find_Object_Type("Unit_Name"), weight}}

	local factionString = newOwner.Get_Faction_Name()
	local rosterOverride = DefineRosterOverride(planet.Get_Type().Get_Name())

	if overrideOwner then
		if type(overrideOwner) == "string" then
			if overrideOwner == "RANDOM" then
				if not rosterOverride then
					local num = table.getn(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL)
					rosterOverride = CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL[GameRandom.Free_Random(1, num)]
				end
			else
				rosterOverride = overrideOwner
			end
		elseif type(overrideOwner) == "userdata" then
			rosterOverride = overrideOwner.Get_Faction_Name()
		end
	end

	-- pick a random unit selection table, could probably use something other than free random
	total_spawn_table = DefineUnitTable(factionString, rosterOverride)

	local space_combat_power
	local land_combat_power

	if combat_power == nil then
		combat_power = 4500
	end

	if type(combat_power) == "table" then
		space_combat_power = combat_power[1]
		land_combat_power = combat_power[2]
	else
		space_combat_power = combat_power
		land_combat_power = combat_power / 4
	end

	--difficulty_multiplier
	local difficulty_multiplier = 1.0
	if not newOwner.Is_Human() then
		local difficulty_level = StoryUtil.GetDifficulty()
		if difficulty_level == "EASY" then
			difficulty_multiplier = 0.75
		elseif difficulty_level == "HARD" then
			difficulty_multiplier = 1.2
		end
	end

	space_combat_power = space_combat_power * difficulty_multiplier
	land_combat_power = land_combat_power * difficulty_multiplier

	DebugMessage("%s -- Attempting to spawn units at %s, from table for %s, space combat power %s, land combat power %s, difficulty modifier %s", tostring(Script), tostring(planet), tostring(newOwner), tostring(space_combat_power), tostring(land_combat_power), tostring(difficulty_multiplier))

	-- spawn random space units
	Spawn_Random_Units(total_spawn_table["Space_Unit_Table"], planet, newOwner, space_combat_power, nil)

	-- spawn random ground units
	local base_level = EvaluatePerception("MaxGroundbaseLevel", newOwner, planet)
	if base_level > 0 then
		if max_ground_units == nil then
			max_ground_units = 5
		elseif max_ground_units == "unlimited" then
			max_ground_units = nil
		end
		Spawn_Random_Units(total_spawn_table["Land_Unit_Table"], planet, newOwner, land_combat_power, max_ground_units)
	end

	-- spawn starting buildings; returns additional infrastructure spawned
	if no_structures then
		return 0
	else
		return Spawn_Random_Buildings(total_spawn_table, planet, newOwner, limit_ground_structures)
	end
end

-- Collects valid units for the year from the total spawn table
-- In: complete spawn table
function CreateDistribution(spawn_table)
	-- Create distribution to sample from
	local year = GlobalValue.Get("GALACTIC_YEAR")
	if year == nil then
		year = 0.0
	end

	local distribution = RandomDistribution()
	
	-- Add units to distributions
	for _, possible_spawn in pairs(spawn_table) do
		--Insert unit into distribution
		local start = possible_spawn["StartYear"]
		local last = possible_spawn["LastYear"]
		if (start == nil or year >= start) and (last == nil or year <= last) then
			distribution:Insert(Find_Object_Type(possible_spawn[1]), possible_spawn[2])
		end
	end
	
	return distribution
end


function Spawn_Random_Units(spawn_table, planet, player, combat_power, max_units)
	if not spawn_table or not planet or not player then
		DebugMessage("%s -- Expected arguments: spawn table, planet, playerobject. Got %s, %s, %s instead", tostring(Script), tostring(spawn_table), tostring(planet), tostring(player))
		return
	end

	if planet.Get_Owner() ~= player then
		DebugMessage("%s -- Planet owner %s is different to the intended player %s, retreating existing forces", tostring(Script), tostring(planet.Get_Owner()), tostring(player))
		ChangePlanetOwnerAndRetreat(planet, player)
	end

	DebugMessage("%s -- Attempting to spawn units at %s", tostring(Script), tostring(planet))

	local distribution = CreateDistribution(spawn_table)
	local units_to_be_spawned = {}

	SpawnTableInsert(combat_power, distribution, units_to_be_spawned, max_units)

	SpawnListType(units_to_be_spawned, planet, player)
end

function Spawn_Random_Buildings(total_spawn_table, planet, player, limit_ground_structures)
	if not total_spawn_table or not planet or not player then
		DebugMessage("%s -- Expected arguments: table of spawn tables, planet, playerobject. Got %s, %s, %s instead", tostring(Script), tostring(total_spawn_table), tostring(planet), tostring(player))
		return
	end

	if planet.Get_Owner() ~= player then
		DebugMessage("%s -- Planet owner %s is different to the intended player %s, retreating existing forces", tostring(Script), tostring(planet.Get_Owner()), tostring(player))
		ChangePlanetOwnerAndRetreat(planet, player)
	end

	starbase_level = SpawnStarBase(player, planet, total_spawn_table["Starbase_Table"], limit_ground_structures)
	groundbase_level = SpawnGroundBase(player, planet, total_spawn_table["Groundbase_Table"], total_spawn_table["Government_Building"], total_spawn_table["GTS_Weapon"], total_spawn_table["Base_Defences"], limit_ground_structures)
	shipyard_spawned = SpawnShipyard(player, planet, total_spawn_table["Shipyard_Table"], total_spawn_table["Defenses_Table"])

	-- return infrastructure added, each structure adds 1 and removes one empty slot
	return (starbase_level + groundbase_level) * 2 + shipyard_spawned
end

-- Spawns a list of units for a faction matching a target cp
-- In: target combat power, name of faction to spawn for, planet, land/space, optional roster set, optional allowed overflow
function SpawnCPOfUnits(combat_value, faction, planet, land, roster, allowed_overflow)
	if roster == nil then
		roster = faction
	end
	local total_spawn_table = DefineUnitTable(roster)
	local spawn_table
	if land then
		spawn_table = total_spawn_table["Land_Unit_Table"]
	else
		spawn_table = total_spawn_table["Space_Unit_Table"]
	end
	local distribution = CreateDistribution(spawn_table)
	local units_to_be_spawned = {}
	SpawnTableInsert(combat_value, distribution, units_to_be_spawned, nil, allowed_overflow)
	SpawnListType(units_to_be_spawned, planet, Find_Player(faction))
end

-- Spawns a list of units for a faction matching a target cp and planet list
-- In: name of faction to spawn for, list of planets and cp, land/space, optional roster set, optional allowed overflow
-- Planets should start with a target cp. This will be applied to all planets (entered as strings, not plaent entities) until the next CP
-- e.g. {4000, "CONTRUUM", "CHAMPALA", 2000, "FARRFIN"} with spawn 4000 CP at Contruum and Champala and 200 at Farrfin
function SpawnCPOnPlanets(faction, planets, land, roster, allowed_overflow)
	if roster == nil then
		roster = faction
	end
	local total_spawn_table = DefineUnitTable(roster)
	local tabletype
	if land then
		tabletype = "Land_Unit_Table"
	else
		tabletype = "Space_Unit_Table"
	end
	faction = Find_Player(faction)
	local spawn_table = total_spawn_table[tabletype]
	
	local main_distribution = CreateDistribution(spawn_table)
	local combat_value = 1000
	for _, planet in pairs(planets) do
		if type(planet) == "number" then
			combat_value = planet
		else
			local rosterOverride = DefineRosterOverride(planet)
			local distribution
			if rosterOverride ~= nil then
				local new_spawntable = DefineUnitTable(roster, rosterOverride)[tabletype]
				distribution = CreateDistribution(new_spawntable)
			else
				distribution = main_distribution
			end
			
			local units_to_be_spawned = {}
			SpawnTableInsert(combat_value, distribution, units_to_be_spawned, nil, allowed_overflow)
			SpawnListType(units_to_be_spawned, FindPlanet(planet), faction)
		end
	end
	
end

-- Insert units into the spawn table
-- In: combat value for the units, number of units, distribution of units,
-- the spawn_table to fill, and optional max number of units to return, the optional % overflow of cp allowed
function SpawnTableInsert(combat_value, distribution, spawn_table, max_units, allowed_overflow)
	local total_count = 0
	local combat_value_j = 0
	local give_up = 0
	local ceiling = nil
	if allowed_overflow then
		ceiling = combat_value + (1+allowed_overflow/100)
	end

	while combat_value_j <= combat_value and give_up < 4 do
		if max_units == nil then
			--this space intentionally left blank
		elseif total_count == max_units then
			break
		end

		-- Get a unit based on their weighting
		local spawn_unit = distribution:Sample()

		if TestValid(spawn_unit) then
			if not spawn_unit then
				DebugMessage("%s -- Error! unit not found!", tostring(Script))
			end
			
			local ceilcheck = combat_value_j + spawn_unit.Get_Combat_Rating()
			
			if ceiling ~= nil and ceilcheck > ceiling then
				give_up = give_up + 1
			else
				give_up = 0
				table.insert(spawn_table, spawn_unit)
				combat_value_j = ceilcheck
				total_count = total_count + 1
			end
		else
			combat_value_j = combat_value + 1
		end
	end
end

-- Simple spawn function that can use the found object list instead of the name list
-- In: List of gameobjects, location, playerobject
function SpawnListType(type_list, entry_marker, player)
	for _, unit_type in pairs(type_list) do
		DebugMessage("%s -- Spawning %s", tostring(Script), tostring(unit_type.Get_Name()))
		new_units = Spawn_Unit(unit_type, entry_marker, player)
		for _, unit in pairs(new_units) do
			unit.Prevent_AI_Usage(false)
		end
	end
end

-- Spawns groundbase for player
-- In: playerobject, planet to spawn at, table index to get ground bases from
function SpawnGroundBase(player, planet, base_table, government_building, gts_weapon, base_defences, limit_ground_structures)

	local base_level = EvaluatePerception("MaxGroundbaseLevel", player, planet)
	local starbase_level = EvaluatePerception("MaxStarbaseLevel", player, planet)
	local shipyard_level = EvaluatePerception("Max_Shipyard_Level", player, planet)
	local capital = EvaluatePerception("Planet_Has_Capital_Building", player, planet)
	local base_limit = base_level / 2
	local buildings_spawned = 0

	if base_level == 0 then
		return 0
	end

	-- Check if the planet has a starbase
	local current_base_level = EvaluatePerception("GroundbaseLevel", player, planet)

	if current_base_level > 0 and capital == 0 then
		return 0
	end

	if limit_ground_structures and capital == 0 then
		base_limit = 2
	end

	if government_building then
		Spawn_Unit(Find_Object_Type(government_building), planet, player)
		buildings_spawned = buildings_spawned + 1
	end

	local base_table_length = table.getn(base_table)


	while buildings_spawned < base_limit do
		building = base_table[GameRandom.Free_Random(1, base_table_length)]
		DebugMessage("%s -- Spawning %s", tostring(Script), building)
		Spawn_Unit(Find_Object_Type(building), planet, player)
		buildings_spawned = buildings_spawned + 1
	end

	local open_slots = base_level - buildings_spawned - current_base_level

	if open_slots > 0 and capital > 0 then
		if not base_defences then
			base_defences = "Galactic_Turbolaser_Tower_Defenses"
		end
		Spawn_Unit(Find_Object_Type(base_defences), planet, player)
	end

	-- if planet's starbase is 5 or has a capital shipyard and it has a free slot, give it a GtS weapon
	if shipyard_level > 2 and open_slots > 1 and gts_weapon ~= nil and EvaluatePerception("Is_Connected_To_Enemy", player, planet) > 0 and not limit_ground_structures then
		Spawn_Unit(Find_Object_Type(gts_weapon), planet, player)
		buildings_spawned = buildings_spawned + 1
	end

	return buildings_spawned
end

-- Spawns starbase for player
-- In: playerobject, planet to spawn at, table to get star bases from
function SpawnStarBase(player, planet, base_table, limit_ground_structures, set_level)
	-- Check if the planet has a starbase level
	local base_level = EvaluatePerception("MaxStarbaseLevel", player, planet)
	local capital = EvaluatePerception("Planet_Has_Capital_Building", player, planet)

	if base_level == nil then
		return 0
	end

	if base_level == 0 then
		StoryUtil.ShowScreenText("Starbase level 0 for base level".. tostring(base_level) .. "on" .. tostring(planet), 5)
		return 0
	end

	-- Check if the planet has a starbase
	local current_base_level = EvaluatePerception("StarbaseLevel", player, planet)

	if current_base_level > 0 then
		return 0
	end

	if set_level ~= nil then
		if set_level < base_level then
			base_level = set_level
		end
	elseif limit_ground_structures and EvaluatePerception("Is_Connected_To_Enemy", player, planet) == 0 and capital == 0 then
		base_level = 2
	end

	Spawn_Unit(Find_Object_Type(base_table[base_level]), planet, player)
	return base_level
end

-- Spawns shipyard for player
-- In: playerobject, planet to spawn at, table to get star bases from
function SpawnShipyard(player, planet, yard_table, defense_table)
	-- Check if the planet has a shipyard level
	local base_level = EvaluatePerception("Max_Shipyard_Level", player, planet)

	-- Check if the planet has a shipyard
	local current_shipyard_level = EvaluatePerception("Planet_Has_Shipyard", player, planet)

	if current_shipyard_level > 0 then
		return 0
	end

	if yard_table[base_level] then
		DebugMessage("%s -- Spawning %s", tostring(Script), tostring(yard_table[base_level]))
		Spawn_Unit(Find_Object_Type(yard_table[base_level]), planet, player)
	else
		StoryUtil.ShowScreenText("No shipyard for base level".. tostring(base_level) .. "on" .. tostring(planet), 5)
	end

	local current_base_level = EvaluatePerception("StarbaseLevel", player, planet)

	if defense_table[current_base_level] then
		local station = defense_table[current_base_level]
		if type(station) == "table" then
			station = station[GameRandom.Free_Random(1, table.getn(station))]
		end
		Spawn_Unit(Find_Object_Type(station), planet, player)
	end

	return 1
end

function SpawnTradeStation(player, planet)
    local needs_trade = EvaluatePerception("Needs_Tradestation", player, planet)

    if needs_trade > 1 then
        if  GlobalValue.Get("PROTEUS_GROUP_NAME") == "DASTA" then
            Spawn_Unit(Find_Object_Type("Dasta_TradeStation"), planet, player)
            return true
        else
            Spawn_Unit(Find_Object_Type("TradeStation"), planet, player)
            return true
        end
    end

    return false
end

function SaveSpaceStructures(planet)
	local player = planet.Get_Owner()

	local SpaceStructures = {
		["PRIMARY"] = 0,
		["SECONDARY"] = {},
	}

	SpaceStructures["PRIMARY"] = EvaluatePerception("StarbaseLevel", player, planet)

	local structureCategoryLists = require("StructureCategoryLists")
	local allFactionUnitInstances = Find_All_Objects_Of_Type(player) or {}
	for i, unitInstance in pairs(allFactionUnitInstances) do
		if TestValid(unitInstance) then
			local unitPlanet = unitInstance.Get_Planet_Location()
			local unitAction = determine_unit_action(unitInstance, unitPlanet, {planet}, structureCategoryLists)

			--if unitInstance is a secondary space structure insert to table
			if unitAction == 1 then
				table.insert(SpaceStructures["SECONDARY"],unitInstance.Get_Type().Get_Name())
			end
		end
	end

	return SpaceStructures
end

function RestoreSpaceStructures(planet,saved_table)
	local player = planet.Get_Owner()

	local current_table = SaveSpaceStructures(planet)

	if current_table["PRIMARY"] == 0 and saved_table["PRIMARY"] > 0 then
		local total_spawn_table = DefineUnitTable(player)
		SpawnStarBase(player, planet, total_spawn_table["Starbase_Table"], nil, saved_table["PRIMARY"])
	end

	local spawn_table = {}
	
	for _,saved_structure_name in pairs(saved_table["SECONDARY"]) do
		local found = false

		for _,current_structure_name in pairs(current_table["SECONDARY"]) do
			if saved_structure_name == current_structure_name then
				found = true
				break
			end
		end
		
		if found == false then
			table.insert(spawn_table,saved_structure_name)
		end
	end
	
	SpawnList(spawn_table,planet,player,true,false)
end

function SaveGroundStructures(planet)
	local player = planet.Get_Owner()

	local GroundStructures = {}

	local allFactionUnitInstances = Find_All_Objects_Of_Type(player) or {}
	for i, unitInstance in pairs(allFactionUnitInstances) do
		if TestValid(unitInstance) then
			local unitPlanet = unitInstance.Get_Planet_Location()
			local unitAction = determine_unit_action(unitInstance, unitPlanet, {planet}, nil, "groundStructureOnly")

			if unitAction == 2 then
				table.insert(GroundStructures,unitInstance.Get_Type().Get_Name())
			end
		end
	end

	return GroundStructures
end

function RestoreGroundStructures(planet,saved_table)
	local player = planet.Get_Owner()

	local current_table = SaveGroundStructures(planet)

	local spawn_table = {}
	
	for _,saved_structure_name in pairs(saved_table) do
		local found = false

		for i,current_structure_name in pairs(current_table) do
			if saved_structure_name == current_structure_name then
				table.remove(current_table,i)
				found = true
				break
			end
		end

		if found == false then
			table.insert(spawn_table,saved_structure_name)
		end
	end
	
	SpawnList(spawn_table,planet,player,true,false)
end