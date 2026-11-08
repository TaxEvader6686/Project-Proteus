require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")
require("eawx-util/StringUtil")
require("eawx-util/UnitUtil")

---@class GovernmentProteus
GovernmentProteus = class()

---@param gc GalacticConquest
---@param GovEmpire GovernmentEmpire
---@param ShipMarket ShipMarket
function GovernmentProteus:new(gc, GovEmpire, ShipMarket)
    self.gc = gc
    self.GovEmpire = GovEmpire
    self.SHIPMARKET = ShipMarket
    self.PlayerImperial_Proteus = Find_Player("Imperial_Proteus")

    self.production_finished_event = gc.Events.GalacticProductionFinished
    self.production_finished_event:attach_listener(self.on_production_finished, self)

    self.herokilled_finished_event = gc.Events.GalacticHeroKilled
    self.herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)

    self.galactic_ssd_killed_event = gc.Events.GalacticSSDKilled
    self.galactic_ssd_killed_event:attach_listener(self.on_galactic_ssd_killed, self)

    self.gamble_table = require("GambleLibrary")
    self.market_updates = {
        ["DUMMY_RECRUIT_GROUP_DELURIN"] = "DRAGON",
        ["DUMMY_RECRUIT_GROUP_WESSEX"] = "WESSEX",
    }

    self.proteus_markets = {"KUAT"}
    self.market_adjustments = require("ShipMarketAdjustmentsLibrary")

    -- Project Proteus specific hero SSDs
    self.hero_ssd_table = {
        ["HARRSK_MEGADOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_HARRSK",
        ["DESANNE_DOMINION"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_DESANNE",
        ["THARKUS_AMBITION"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_THARKUS",
        ["TAXEVADER_DREAM_OF_A_QUIET_LIFE"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_TAX",
        ["MICHAEL_TERROR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_MICHAEL",
    }

    -- Append to GovernmentEmpire hero SSD tables
    for key, value in pairs(self.hero_ssd_table) do
        self.GovEmpire.hero_ssd_table[key] = value
    end

    self.heroes_to_respawn = {
        ["ROGRISS_AURORA"] = {
            spawn_planet = "KUAT",
            spawn_units = {"Rogriss_Agonizer"},
            multimedia_text = "TEXT_ROGRISS_RETURN",
            multimedia_loop = "Imperial_Naval_Officer_Loop"
        },
        --[[ Commented out for now
        ["X1_EXECUTOR"] = {
            spawn_planet = nil,
            spawn_units = {"X1_Team"},
            multimedia_text = "TEXT_WARLORD_RETURN_X1",
            multimedia_loop = "X1_Loop"
        }
        --]]
    }

    crossplot:subscribe("DASTA_FIGHTER_CHOICE_OPTION", self.dasta_fighters, self)
    crossplot:subscribe("KUAT_BC_CHOICE_OPTION", self.kuat_battlecruisers, self)
    crossplot:subscribe("NIVERS_SSD_CHOICE_OPTION", self.Nivers_SSD_Choice, self)
    crossplot:subscribe("ISECTOR_SWAP_CHOICE_OPTION", self.ISector_Swap_Choice, self)--Note for Supernova
end

function GovernmentProteus:update()
    --Logger:trace("entering GovernmentProteus:update")
    local proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
    if proteus == "DASTA" then
        if GlobalValue.Get("CURRENT_ERA") >= 14 then
            local dasta = Find_First_Object("RAGEZ_DASTA_MARAUDER")
            if TestValid(dasta) then
                dasta.Despawn()
                if self.PlayerImperial_Proteus.Is_Human() then
                    StoryUtil.Multimedia("TEXT_CONQUEST_PROTEUS_DASTA_RAGEZ_RETIRE", 10, nil, "Ragez_DAsta_Loop", 0)
                end
                self.GovEmpire.leader_table["FEENA_DASTA_TEAM"] = "FEENA_DASTA"
            end
        end
    end
end

---@param planet Planet
---@param object_type_name string Assumes all CAPS
function GovernmentProteus:on_production_finished(planet, object_type_name)
    --Logger:trace("entering GovernmentProteus:on_production_finished")
    local event = self.market_updates[object_type_name]
    if event then
        if self.proteus_markets[GlobalValue.Get("PROTEUS_GROUP_NAME")] then
            self:Market_Update(event)
        end
    elseif string.find(object_type_name, "DUMMY_RANDOM_UNIT_") then
        self:gamble_manager(object_type_name)
    elseif object_type_name == "KUAT_CHOOSE_BC" then
        GenericPopup("KUAT_BC_CHOICE", {"PRAETOR_II_BATTLECRUISER", "PRAETOR_CARRIER_BATTLECRUISER", "COMMUNICATIONS_BATTLECRUISER", "SORANNAN_STAR_DESTROYER"}, "KUAT_BC_CHOICE_OPTION")
    elseif object_type_name == "DASTA_PROCURE_FIGHTERS" then
        GenericPopup("DASTA_FIGHTER_CHOICE", {"IMPERIAL", "REBEL"}, "DASTA_FIGHTER_CHOICE_OPTION")
	elseif object_type_name == "DUMMY_RESEARCH_ISECTOR_SWAP_1_DUMMY" then--Note for Supernova
        GenericPopup("ISECTOR_SWAP_1_CHOICE", {"ACCLAMATOR_ASSAULT", "ACCLAMATOR_II"}, "ISECTOR_SWAP_CHOICE_OPTION")--keep last variable the same so it calls the same funciton for each research dummy, add elseifs for added choices
     end
end

---Project Proteus specific hero respawn, just like WarlordRespawn
---@param hero_name string Assumes all CAPS
---@param owner string Assumes all CAPS
---@param killer string Assumes all CAPS
function GovernmentProteus:on_galactic_hero_killed(hero_name, owner, killer)
    --Logger:trace("entering GovernmentProteus:on_galactic_hero_killed")
    local hero = self.heroes_to_respawn[hero_name]
    if hero and owner == "IMPERIAL_PROTEUS" then
        local safe_planets = StoryUtil.GetSafePlanetTable()
        local spawn = StoryUtil.SpawnAtSafePlanet(hero.spawn_planet, Find_Player("Imperial_Proteus"), safe_planets, hero.spawn_units, true, false)
        if spawn then
            StoryUtil.Multimedia(hero.multimedia_text, 10, nil, hero.multimedia_loop, 0)
        end
    end
end

---@param short_name string Assumes all CAPS
---@param owner_name string Assumes all CAPS
---@param killer_name string Assumes all CAPS
function GovernmentProteus:on_galactic_ssd_killed(short_name, owner_name, killer_name)
    --Logger:trace("entering GovernmentEmpire:on_galactic_ssd_killed")

	if owner_name ~= "IMPERIAL_PROTEUS" and GlobalValue.Get("PROTEUS_GROUP_NAME") ~= "NIVERS" then
		return
	elseif short_name == "Mandator II" then
		GenericPopup("NIVERS_MANDATOR2_CHOICE", {"BELLATOR", "MANDATOR_III"}, "NIVERS_SSD_CHOICE_OPTION")
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Mandator_II_Dreadnought"))
	elseif short_name == "Bellator" then
		GenericPopup("NIVERS_BELLATOR_CHOICE", {"LEGATOR", "VENGEANCE"}, "NIVERS_SSD_CHOICE_OPTION")
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Bellator_Star_Dreadnought"))
	elseif short_name == "Mandator III" then
		GenericPopup("NIVERS_MANDATOR3_CHOICE", {"EXECUTOR", "ASSERTOR"}, "NIVERS_SSD_CHOICE_OPTION")
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Mandator_III_Dreadnought"))
	elseif short_name == "Legator" then
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Legator_Star_Dreadnought"))
	elseif short_name == "Vengeance" then
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Vengeance_Star_Dreadnought"))
	elseif short_name == "Executor" then
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Executor_Star_Dreadnought"))
	elseif short_name == "Assertor" then
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Assertor_Star_Dreadnought"))
	end
end

---@param choice string Assumes all CAPS
function GovernmentProteus:dasta_fighters(choice)
    --Logger:trace("entering GovernmentProteus:dasta_fighters")
    local option = string.gsub(choice, "DASTA_FIGHTER_CHOICE_", "")
    option = string.lower(option)
    option = CapitalizeFirstCharacterOfEachSentence(option)
    Set_Fighter_Research("DastaFighters"..option)
end

---@param choice string Assumes all CAPS
function GovernmentProteus:kuat_battlecruisers(choice)
    --Logger:trace("entering GovernmentProteus:kuat_battlecruisers")
    self:Market_Update("KUAT_BC")
    local battlecruiser = string.gsub(choice, "KUAT_BC_CHOICE_", "")
    if TestValid(Find_Object_Type(battlecruiser)) then -- Project Proteus Debug ; comment it out for release
        self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type(battlecruiser))
    end
end

---@param unit_type string Assumes all CAPS
function GovernmentProteus:gamble_manager(unit_type)
    --Logger:trace("entering GovernmentProteus:gamble_manager")
    local src_data = self.gamble_table[unit_type]
    local posnr = GameRandom.Free_Random(1,table.getn(src_data))
    local dummy_object = Find_First_Object(unit_type)
    if not TestValid(dummy_object) then
        return
    end

    local planet_object = dummy_object.Get_Planet_Location()
    local unit_to_spawn = Find_Object_Type(src_data[posnr])
    if unit_to_spawn ~= nil then -- Project Proteus Debug ; comment it out for release
        Spawn_Unit(unit_to_spawn, planet_object, self.PlayerImperial_Proteus)
    end
    dummy_object.Despawn()
end

---@param choice string Assumes all CAPS
function GovernmentProteus:ISector_Swap_Choice(choice)--Note for Supernova
	--Logger:trace("entering GovernmentProteus:ISector_Swap_Choice")
	if choice == "ISECTOR_SWAP_1_CHOICE_ACCLAMATOR_ASSAULT" then
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Acclamator_Patrol_Refit"))--lock base roster unit
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Acclamator_I_Assault"))--unlock chosen replacement
	elseif choice == "ISECTOR_SWAP_1_CHOICE_ACCLAMATOR_II" then
		self.PlayerImperial_Proteus.Lock_Tech(Find_Object_Type("Acclamator_Patrol_Refit"))
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Acclamator_II"))
	end
end

---@param choice string Assumes all CAPS
function GovernmentProteus:Nivers_SSD_Choice(choice)
	--Logger:trace("entering GovernmentProteus:Nivers_SSD_Choice")
	--From Mandator-II
	if choice == "NIVERS_MANDATOR2_CHOICE_BELLATOR" then
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Bellator_Star_Dreadnought"))		
	elseif choice == "NIVERS_MANDATOR2_CHOICE_MANDATOR_III" then
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Mandator_III_Dreadnought"))
	--From Bellator		
	elseif choice == "NIVERS_BELLATOR_CHOICE_LEGATOR" then
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Legator_Star_Dreadnought"))		
	elseif choice == "NIVERS_BELLATOR_CHOICE_VENGEANCE" then
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Vengeance_Star_Dreadnought"))	
	--From Mandator-III
	elseif choice == "NIVERS_MANDATOR3_CHOICE_EXECUTOR" then
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Executor_Star_Dreadnought"))	
	elseif choice == "NIVERS_MANDATOR3_CHOICE_ASSERTOR" then
		self.PlayerImperial_Proteus.Unlock_Tech(Find_Object_Type("Assertor_Star_Dreadnought"))	
	end
end

---@param tag string
function GovernmentProteus:Market_Update(tag)
    --Logger:trace("entering GovernmentProteus:Market_Update")
    if not self.market_adjustments[tag] then
        return
    end

    if self.market_adjustments[tag].adjustment_lists then
        self.SHIPMARKET:adjust_ship_chance(self.market_adjustments[tag].adjustment_lists)
    end
    if self.market_adjustments[tag].lock_lists then
        self.SHIPMARKET:lock_or_unlock_options(self.market_adjustments[tag].lock_lists)
    end
    if self.market_adjustments[tag].requirement_lists then
        self.SHIPMARKET:adjust_ship_requirements(self.market_adjustments[tag].requirement_lists)
    end
end

function GovernmentProteus:UpdateProteusMiscellaneousDisplay()
	--Logger:trace("entering GovernmentProteus:UpdateProteusMiscellaneousDisplay")
	local current_proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
	local ProteusDisplayLibrary = require("ProteusDisplayLibrary")

	if not ProteusDisplayLibrary[current_proteus] then--Temporary, will be made universal for garrisons when those are added
		return
	end

	local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
	local government_display_event = plot.Get_Event("Government_Display")

	government_display_event.Set_Reward_Parameter(1, "IMPERIAL_PROTEUS")
	if ProteusDisplayLibrary[current_proteus].No_Legitimacy then
		government_display_event.Clear_Dialog_Text()--Clears the normal empire gov display
	end
	government_display_event.Add_Dialog_Text("TEXT_NONE")
	government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
	government_display_event.Add_Dialog_Text(tostring(GlobalValue.Get("PROTEUS_CURRENT_DISPLAY_NAME")) .. " Unique Mechanics and Garrisons:")
	government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

	if ProteusDisplayLibrary[current_proteus].GovText then
		local GovText = ProteusDisplayLibrary[current_proteus].GovText
		for _, text in pairs(GovText) do
			government_display_event.Add_Dialog_Text(text)
		end
	end

	government_display_event.Add_Dialog_Text("TEXT_NONE")--Spacer
end

function GovernmentProteus:UpdateProteusShipmarketDisplay()
    --Logger:trace("entering GovernmentProteus:UpdateProteusShipmarketDisplay")
    local current_proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")

    if not self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus] then
        return
    end

    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local government_display_event = plot.Get_Event("Government_Display")

    government_display_event.Set_Reward_Parameter(1, "IMPERIAL_PROTEUS")
    -- government_display_event.Clear_Dialog_Text()

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_PROTEUS_MARKET_"..tostring(current_proteus))
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_PROTEUS_MARKET_OVERVIEW_"..tostring(current_proteus))
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_LIST_01")

    local ship_market = self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus]["SHIP_MARKET"]
    local ship_list = SortKeysByElement(ship_market.list,"order","asc")

    for i, ship in ipairs(ship_list) do
        local ship_data = ship_market.list[ship]
        if ship_data.amount > 0 and ship_data.locked == false and ship_data.gc_locked == false then
            government_display_event.Add_Dialog_Text(ship_data.readable_name .." : "..tostring(ship_data.amount) .." - [ ".. tostring(ship_data.chance/10) .."%% ]")
        end
    end

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("None on the market:")

    for i, ship in ipairs(ship_list) do
        local ship_data = ship_market.list[ship]
        if ship_data.amount == 0 and ship_data.locked == false and ship_data.gc_locked == false then
            government_display_event.Add_Dialog_Text(ship_data.readable_name .." : [ ".. tostring(ship_data.chance/10) .."%% ]")
        end
    end

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_LIST_MODIFIERS")

    for i, ship in ipairs(ship_list) do
        local ship_data = ship_market.list[ship]
        if string.len(ship_data.text_requirement) ~= 0 then
            government_display_event.Add_Dialog_Text(ship_data.readable_name ..": ".. ship_data.text_requirement)
        end
    end
end