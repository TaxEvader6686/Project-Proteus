require("deepcore/std/class")
require("eawx-plugins/government-manager/GovernmentNewRepublic")
require("eawx-plugins/government-manager/GovernmentEmpire")
require("eawx-plugins/government-manager/GovernmentFavour")
require("eawx-plugins/government-manager/GovernmentHutts")
require("eawx-plugins/government-manager/GovernmentEotH")
require("eawx-plugins/government-manager/ShipMarket")
require("eawx-util/Sort")

---@class GovernmentManager
GovernmentManager = class()

---@param dummy_lifecycle_handler KeyDummyLifeCycleHandler
function GovernmentManager:new(gc, absorb, dark_empire, id, dummy_lifecycle_handler, galactic_display)
    self.NRGOV = GovernmentNewRepublic(gc, dummy_lifecycle_handler)
    self.EMPIREGOV = GovernmentEmpire(gc, absorb, dark_empire, id)
    self.SHIPMARKET = ShipMarket(gc)
    self.FAVOUR = GovernmentFavour(gc)
    self.HUTTGOV = GovernmentHutts(gc, id)
    self.EOTHGOV = GovernmentEotH(gc, self.FAVOUR.FavourTables["EMPIREOFTHEHAND"])

    self.human = Find_Player("local")
    self.HuttPlayer = Find_Player("Hutt_Cartels")
    self.hutt_scum = false
    self.hutt_mobilize = false
    self.hutt_empire = false

    crossplot:subscribe("TEMPEST_RESEARCH_FINISHED", self.Hutt_Research_Tempest, self)
    crossplot:subscribe("CHELANDION_AVAILABLE", self.Hutt_Militarization_Chelandion, self)
    crossplot:subscribe("TARRADA_AVAILABLE", self.Hutt_Militarization_Tarrada, self)
    crossplot:subscribe("UBRIKKIAN_CRUISER_AVAILABLE", self.Hutt_Militarization_Ubrikkian, self)
    crossplot:subscribe("KARABOS_AVAILABLE", self.Hutt_Militarization_Karabos, self)
    crossplot:subscribe("HUTT_MAX_SCUM", self.Hutt_Max_Scum, self)
    crossplot:subscribe("HUTT_MAX_MOBILIZE", self.Hutt_Max_Mobilize, self)
    crossplot:subscribe("UPDATE_GOVERNMENT", self.UpdateDisplayContainer, self)

    crossplot:subscribe("FAVOUR_PROCESSED", self.PassFavour, self)
end

function GovernmentManager:update()
    self.NRGOV:update()
    self.EMPIREGOV:update()
    self.SHIPMARKET:update()
    self.FAVOUR:update()
    self.HUTTGOV:update()
end

function GovernmentManager:Hutt_Research_Tempest()
    GlobalValue.Set("TEMPEST_ENABLED",true)
end

function GovernmentManager:Hutt_Militarization_Chelandion()
    GlobalValue.Set("CHELANDION_ENABLED",true)
end

function GovernmentManager:Hutt_Militarization_Tarrada()
    GlobalValue.Set("TARRADA_ENABLED",true)
end

function GovernmentManager:Hutt_Militarization_Ubrikkian()
    GlobalValue.Set("UBRIKKIAN_CRUISER_ENABLED",true)
end

function GovernmentManager:Hutt_Militarization_Karabos()
    GlobalValue.Set("KARABOS_ENABLED",true)
end

function GovernmentManager:PassFavour()
    self.EOTHGOV:update_favour(self.FAVOUR.FavourTables["EMPIREOFTHEHAND"])    
end


function GovernmentManager:Hutt_Max_Scum()
    self.hutt_scum = true
    self:Hutt_Empire_Formation()
end

function GovernmentManager:Hutt_Max_Mobilize()
    self.hutt_mobilize = true
    self:Hutt_Empire_Formation()
end

function GovernmentManager:Hutt_Empire_Formation()
    --Logger:trace("entering GovernmentManager:Hutt_Empire_Formation")
    if self.hutt_scum == false or self.hutt_mobilize == false or self.hutt_empire == true then
        return
    end

    self.hutt_empire = true

    UnitUtil.SetLockList("HUTT_CARTELS", {"BouHalec_Star_Dreadnought"})
    crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", "HUTT_CARTELS", "Hutt Empire")

    if self.HuttPlayer.Is_Human() then
        StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_HUTTS_EMPIRE_FORMATION", 20, nil, "Jabba_Loop", 0)
    end
end

function GovernmentManager:UpdateDisplayContainer()
    if self.human == Find_Player("HUTT_CARTELS") then
        self.HUTTGOV:UpdateDisplay(self.FAVOUR.FavourTables["HUTT_CARTELS"])
    elseif self.human == Find_Player("EMPIRE")
        or self.human == Find_Player("ERIADU_AUTHORITY")
        or self.human == Find_Player("ZSINJ_EMPIRE")
        or self.human == Find_Player("GREATER_MALDROOD")
        or self.human == Find_Player("PENTASTAR")
        or self.human == Find_Player("IMPERIAL_PROTEUS")
        then
            self.EMPIREGOV:UpdateDisplay()
            if GlobalValue.Get("PROTEUS_GROUP_NAME") == "KUAT" then
                self:UpdateProteusShipmarketDisplay()
            end
    elseif self.human == Find_Player("REBEL") then
        self.NRGOV:UpdateDisplay()
    elseif self.human == Find_Player("EMPIREOFTHEHAND") then
        self.EOTHGOV:OpenDisplay()
    elseif self.human == Find_Player("CORPORATE_SECTOR") then
        self:UpdateDisplayCSA()
    elseif self.human == Find_Player("HAPES_CONSORTIUM") then
        self:UpdateDisplayHapes()
    elseif self.human == Find_Player("EMPIREOFTHEHAND") then
        self.EOTHGOV:OpenDisplay()
    end
end

function GovernmentManager:UpdateProteusShipmarketDisplay()
	local current_proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
	if self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus] then
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
        for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus]["SHIP_MARKET"].list,"order","asc")) do
            local ship_data = self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus]["SHIP_MARKET"].list[ship]
            if ship_data.amount > 0 then
                government_display_event.Add_Dialog_Text(ship_data.readable_name .." : "..tostring(ship_data.amount) .." - [ ".. tostring(ship_data.chance/10) .."%% ]")
            end
        end
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        government_display_event.Add_Dialog_Text("None on the market:")
        for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus]["SHIP_MARKET"].list,"order","asc")) do
            local ship_data = self.SHIPMARKET.market_types["IMPERIAL_PROTEUS"][current_proteus]["SHIP_MARKET"].list[ship]
            if ship_data.amount == 0 then
                government_display_event.Add_Dialog_Text(ship_data.readable_name .." : [ ".. tostring(ship_data.chance/10) .."%% ]")
            end
        end
    end
end

function GovernmentManager:UpdateDisplayCSA()
    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local government_display_event = plot.Get_Event("Government_Display")

    government_display_event.Set_Reward_Parameter(1, "CORPORATE_SECTOR")
    government_display_event.Clear_Dialog_Text()

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_OVERVIEW_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_OVERVIEW")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_LIST_01")
    for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list,"order","asc")) do
        local ship_data = self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list[ship]
        if ship_data.amount > 0 then
            government_display_event.Add_Dialog_Text(ship_data.readable_name .." : "..tostring(ship_data.amount) .." - [ ".. tostring(ship_data.chance/10) .."%% ]")
        end
    end
    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("None on the market:")
    for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list,"order","asc")) do
        local ship_data = self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list[ship]
        if ship_data.amount == 0 then
            government_display_event.Add_Dialog_Text(ship_data.readable_name .." : [ ".. tostring(ship_data.chance/10) .."%% ]")
        end
    end
    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_LIST_MODIFIERS")
    for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list,"order","asc")) do
        local ship_data = self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list[ship]
        if string.len(ship_data.text_requirement) ~= 0 then
            government_display_event.Add_Dialog_Text(ship_data.readable_name ..": ".. ship_data.text_requirement)
        end
    end

    Story_Event("GOVERNMENT_DISPLAY")
end

function GovernmentManager:UpdateDisplayHapes()
    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local government_display_event = plot.Get_Event("Government_Display")

    government_display_event.Set_Reward_Parameter(1, "HAPES_CONSORTIUM")

    government_display_event.Clear_Dialog_Text()

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_DESCRIPTION_1")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_DESCRIPTION_2")

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_LOYALTY_HEADER")
    for house, house_info in pairs(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]) do
        government_display_event.Add_Dialog_Text(
        "- "..house_info.name..": "..tostring(house_info.favour)
        )
    end

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_REWARD_HEADER")

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_ROYAL_HEADER")
    for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["ROYAL"].reward_list,"threshold","desc")) do
        local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["ROYAL"].reward_list[reward]

        government_display_event.Add_Dialog_Text(
            "- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
        )
    end

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_REQUUD_HEADER")
    for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["REQUUD"].reward_list,"threshold","desc")) do
        local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["REQUUD"].reward_list[reward]

        government_display_event.Add_Dialog_Text(
            "- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
        )
    end

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_GALNEY_HEADER")
    for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["GALNEY"].reward_list,"threshold","desc")) do
        local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["GALNEY"].reward_list[reward]

        government_display_event.Add_Dialog_Text(
            "- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
        )
    end

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_MALURI_HEADER")
    for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["MALURI"].reward_list,"threshold","desc")) do
        local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["MALURI"].reward_list[reward]

        government_display_event.Add_Dialog_Text(
            "- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
        )
    end

    Story_Event("GOVERNMENT_DISPLAY")
end

return GovernmentManager
