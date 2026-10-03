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

    crossplot:subscribe("DASTA_FIGHTER_CHOICE_OPTION", self.dasta_fighters, self)
    crossplot:subscribe("KUAT_BC_CHOICE_OPTION", self.kuat_battlecruisers, self)
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
