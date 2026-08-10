--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox <Pox>
--*   @Date:                2018-01-06T18:36:14+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GameObjectLibrary.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-04-12T00:17:51+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("eawx-util/Comparators")

GameObjectLibrary = {
    Interdictors = {
        "CC7700",
        "CC7700_E",
        "Coronal_Fleet_Tender",
        "Eclipse_Star_Dreadnought",
        "Interdictor_Star_Destroyer",
        "Immobilizer_418",
        "Immobilizer_Twin_Well",
        "Interdiction_Minefield_Container",
        "Mothma_Star_Destroyer",
        "Prolipsi",
        "Sovereign_Star_Dreadnought",
        "Strike_Interdictor",
        "Super_Transport_VII_Interdictor",
        -- heroes
        "Dezon_Constrainer",
        "Iblis_Bail_Organa",
        "Iillor_Corusca_Rainbow",
        "Kaerobani_Interdictor",
        "Lon_Donell_Detainer",
        "Lovett_Riverlord",
        "Phulik_Binder",
        "Voota_Splendor",
        "Wellam_Eternal_Wrath",
        "Valles_Interdictor",
		"Commander_III_Interdictor_Star_Destroyer",
        "DHC_Interdictor",
    },
    Numbers = {
        "Display_One",
        "Display_Two",
        "Display_Three",
        "Display_Four",
        "Display_Five",
        "Display_Six",
        "Display_Seven",
        "Display_Eight",
        "Display_Nine",
        "Display_Ten"
    },
    OrbitalStructures = {
    --Construction Stations
        ["TEMPLATE_SHIPYARD_LEVEL_ONE"] = {
            Text = "TEXT_DISPLAY_SHIPYARD1",
            Equation = "Planet_Has_Shipyard_One"
        },
        ["TEMPLATE_SHIPYARD_LEVEL_TWO"] = {
            Text = "TEXT_DISPLAY_SHIPYARD2",
            Equation = "Planet_Has_Shipyard_Two"
        },
        ["TEMPLATE_SHIPYARD_LEVEL_THREE"] = {
            Text = "TEXT_DISPLAY_SHIPYARD3",
            Equation = "Planet_Has_Shipyard_Three"
        },
        ["TEMPLATE_SHIPYARD_LEVEL_FOUR"] = {
            Text = "TEXT_DISPLAY_SHIPYARD4",
            Equation = "Planet_Has_Shipyard_Four"
        },
        ["PIRATE_BASE"] = {
            Text = "TEXT_DISPLAY_PIRATE_BASE",
            Equation = "Planet_Has_Pirate_Base"
        },
        ["RANCOR_BASE"] = {
            Text = "TEXT_DISPLAY_RANCOR_BASE",
            Equation = "Planet_Has_Rancor_Base"
        },
        ["CSA_SHIP_MARKET"] = {
            Text = "TEXT_DISPLAY_SHIP_MARKET",
            Equation = "Planet_Has_Ship_Market"
        },    
        ["HAPAN_SHIPYARD_ROYAL"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_ROYAL",
            Equation = "Planet_Has_Shipyard_Royal"
        },
        ["HAPAN_SHIPYARD_THANE"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_THANE",
            Equation = "Planet_Has_Shipyard_Thane"
        },
        ["HAPAN_SHIPYARD_ALGRAY"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_ALGRAY",
            Equation = "Planet_Has_Shipyard_AlGray"
        },
        ["HAPAN_SHIPYARD_REQUUD"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_REQUUD",
            Equation = "Planet_Has_Shipyard_Requud"
        },
        ["HAPAN_SHIPYARD_CORR"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_CORR",
            Equation = "Planet_Has_Shipyard_Corr"
        },        
        ["HAPAN_SHIPYARD_MALURI"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_MALURI",
            Equation = "Planet_Has_Shipyard_Maluri"
        },
        ["HAPAN_SHIPYARD_GALNEY"] = {
            Text = "TEXT_DISPLAY_HAPAN_SHIPYARD_GALNEY",
            Equation = "Planet_Has_Shipyard_Galney"
        },
        ["TIERFON_SHIPYARD_CAPITAL"] = {
            Text = "TEXT_DISPLAY_TIERFON_CAPITAL",
            Equation = "Planet_Has_Tierfon_Capital"
        },

    --Defense Stations
        ["SECONDARY_GOLAN_ONE"] = {
            Text = "TEXT_DISPLAY_SECONDARY_GOLAN_ONE",
            Equation = "Planet_Has_Secondary_Golan_One"
        },
        ["SECONDARY_GOLAN_TWO"] = {
            Text = "TEXT_DISPLAY_SECONDARY_GOLAN_TWO",
            Equation = "Planet_Has_Secondary_Golan_Two"
        },
        ["SECONDARY_GOLAN_THREE"] = {
            Text = "TEXT_DISPLAY_SECONDARY_GOLAN_THREE",
            Equation = "Planet_Has_Secondary_Golan_Three"
        },
        ["SECONDARY_VALOR"] = {
            Text = "TEXT_DISPLAY_SECONDARY_VALOR",
            Equation = "Planet_Has_Secondary_Valor"
        },
        ["SECONDARY_EPINEIO"] = {
            Text = "TEXT_DISPLAY_SECONDARY_EPINEIO",
            Equation = "Planet_Has_Secondary_Epineio"
        },
        ["SECONDARY_TEICHOS"] = {
            Text = "TEXT_DISPLAY_SECONDARY_TEICHOS",
            Equation = "Planet_Has_Secondary_Teichos"
        },
        ["SECONDARY_BRASK"] = {
            Text = "TEXT_DISPLAY_SECONDARY_BRASK",
            Equation = "Planet_Has_Secondary_Brask"
        },
        ["SECONDARY_IERO"] = {
            Text = "TEXT_DISPLAY_SECONDARY_IERO",
            Equation = "Planet_Has_Secondary_Iero"
        },
        ["SECONDARY_ETYMOS"] = {
            Text = "TEXT_DISPLAY_SECONDARY_ETYMOS",
            Equation = "Planet_Has_Secondary_Etymos"
        },
        ["SECONDARY_VISVIA"] = {
            Text = "TEXT_DISPLAY_SECONDARY_VISVIA",
            Equation = "Planet_Has_Secondary_Visvia"
        },
        ["SECONDARY_MERIDIAN_I"] = {
            Text = "TEXT_DISPLAY_SECONDARY_MERIDIAN_I",
            Equation = "Planet_Has_Secondary_Meridian_I"
        },
        ["SECONDARY_MERIDIAN_II"] = {
            Text = "TEXT_DISPLAY_SECONDARY_MERIDIAN_II",
            Equation = "Planet_Has_Secondary_Meridian_II"
        },
        ["SECONDARY_MERIDIAN_III"] = {
            Text = "TEXT_DISPLAY_SECONDARY_MERIDIAN_III",
            Equation = "Planet_Has_Secondary_Meridian_III"
        },
        ["SECONDARY_MERIDIAN_IV"] = {
            Text = "TEXT_DISPLAY_SECONDARY_MERIDIAN_IV",
            Equation = "Planet_Has_Secondary_Meridian_IV"
        },

    --Econ Stations
        ["TRADESTATION"] = {
            Text = "TEXT_DISPLAY_TRADE",
            Equation = "Planet_Has_Trade_Station"
        },
        ["GOLAN_COLONY_ONE"] = {
            Text = "TEXT_DISPLAY_COLONY_ONE",
            Equation = "Planet_Has_Colony_One"
        },
        ["GOLAN_COLONY_TWO"] = {
            Text = "TEXT_DISPLAY_COLONY_TWO",
            Equation = "Planet_Has_Colony_Two"
        },
        ["MINING_FACILITY_MINERALS_SPACE"] = {
            Text = "TEXT_DISPLAY_MINING_FACILITY_MINERALS",
            Equation = "Planet_Has_Mining_Facility_Minerals_Space"
        },
        ["MINING_FACILITY_SPICE_SPACE"] = {
            Text = "TEXT_DISPLAY_MINING_FACILITY_SPICE",
            Equation = "Planet_Has_Mining_Facility_Spice_Space"
        },
        ["MINING_FACILITY_TIBANNA_SPACE"] = {
            Text = "TEXT_DISPLAY_MINING_FACILITY_TIBANNA",
            Equation = "Planet_Has_Mining_Facility_Tibanna_Space"
        },
        ["BLACK_15"] = {
            Text = "TEXT_DISPLAY_BLACK_15",
            Equation = "Planet_Has_Black_Fifteen"
        },

        --  ["CREW_RESOURCE_DUMMY"]={
        --      Text="TEXT_DISPLAY_SLAYN_KORPIL"
        --  },
        --    ["PLACEHOLDER_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_PLACEHOLDER_CATEGORY_DUMMY"
        --    },
        --    ["NON_CAPITAL_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_NON_CAPITAL_CATEGORY_DUMMY"
        --    },
        --    ["CAPITAL_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_CAPITAL_CATEGORY_DUMMY"
        --    },
        --    ["STRUCTURE_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_STRUCTURE_CATEGORY_DUMMY"
        --    }
    },
    InfluenceLevels = {
        ["INFLUENCE_ONE"] = {},
        ["INFLUENCE_TWO"] = {},
        ["INFLUENCE_THREE"] = {},
        ["INFLUENCE_FOUR"] = {},
        ["INFLUENCE_FIVE"] = {},
        ["INFLUENCE_SIX"] = {},
        ["INFLUENCE_SEVEN"] = {},
        ["INFLUENCE_EIGHT"] = {},
        ["INFLUENCE_NINE"] = {},
        ["INFLUENCE_TEN"] = {},
        ["BONUS_PLACEHOLDER"] = {}
    },
    Units = require("GameObjectList"),
    GroundCompanies = require("GroundCompanyList"),
	IndividualGroundUnits = require("GroundUnitList"),
	GroundStructures = require("GroundStructureList")
}
return GameObjectLibrary