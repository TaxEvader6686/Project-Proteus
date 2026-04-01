require("deepcore/std/class")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")
require("eawx-util/Sort")

---@class GalacticStatDisplay
GalacticStatDisplay = class()

---@param galactic_conquest GalacticConquest
function GalacticStatDisplay:new(galactic_conquest)
    self.galactic_conquest = galactic_conquest
    self.persistent_damage_library = require("hardpoint-lists/PersistentDamageLibrary")
    self.display_name_library = require("DisplayNameLibrary")
    self.id = string.lower(GlobalValue.Get("MOD_ID"))

    local plot_name = StoryUtil.PlayerAgnosticPlots.Galactic
    local plot = Get_Story_Plot(plot_name)
    --DebugMessage("GalacticStatDisplay::new -- story plot is %s", tostring(plot))

    local stat_display_click_event = plot.Get_Event("Stat_Display_Clicked")
    stat_display_click_event.Set_Reward_Parameter(1, self.galactic_conquest.HumanPlayer.Get_Faction_Name())

    ---@private
    self.stat_display_event = plot.Get_Event("Show_Stat_Display")
    --DebugMessage("GalacticStatDisplay::new -- stat display event is %s", tostring(self.stat_display_event))

    crossplot:subscribe("FACTION_DISPLAY_NAME_CHANGE", self.faction_display_name_change, self)
end

function GalacticStatDisplay:update()
    DebugMessage("GalacticStatDisplay::update -- update started")
    self.stat_display_event.Clear_Dialog_Text()

    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    self.stat_display_event.Add_Dialog_Text("Economic Structures:")
    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    
    if Find_Player("local") == Find_Player("HUTT_CARTELS") then
        self.stat_display_event.Add_Dialog_Text(
            "STAT_CANTINA_COUNT",
            EvaluatePerception("Cantina_Count", self.galactic_conquest.HumanPlayer)
        )
    else
        self.stat_display_event.Add_Dialog_Text(
            "STAT_TAX_COUNT",
            EvaluatePerception("Tax_Count", self.galactic_conquest.HumanPlayer)
        )
    end
    
    self.stat_display_event.Add_Dialog_Text(
        "STAT_MINES_COUNT",
        EvaluatePerception("Mines_Count", self.galactic_conquest.HumanPlayer)
    )

    if  GlobalValue.Get("PROTEUS_GROUP_NAME") == "DASTA" then
        self.stat_display_event.Add_Dialog_Text(
            "STAT_TRADESTATION_COUNT_DASTA",
            EvaluatePerception("Tradestation_Count", self.galactic_conquest.HumanPlayer)
        )
    else
        self.stat_display_event.Add_Dialog_Text(
            "STAT_TRADESTATION_COUNT",
            EvaluatePerception("Tradestation_Count", self.galactic_conquest.HumanPlayer)
        )
    end
    
    self.stat_display_event.Add_Dialog_Text("TEXT_NONE")
    
    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    self.stat_display_event.Add_Dialog_Text("Persistent Damage for Super Star Destroyers:")
    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    for object_name, repair_data in pairs(self.persistent_damage_library[1]) do
        local objects = Find_All_Objects_Of_Type(object_name)
        if table.getn(objects) > 0 then
            for _,object in pairs(objects) do
                local p_owner = object.Get_Owner()
                if p_owner.Is_Human() then
                    local unit_globalvalue = object_name.."_"..p_owner.Get_Faction_Name()
                    local current_health = GlobalValue.Get(unit_globalvalue)
                    self.stat_display_event.Add_Dialog_Text(self.display_name_library[object_name]..": "..tostring(current_health).."%%")
                end
            end
        end
    end
    
    self.stat_display_event.Add_Dialog_Text("TEXT_NONE")
    self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    self.stat_display_event.Add_Dialog_Text("STAT_FACTIONS")

    local number_of_planets_per_faction = self.galactic_conquest.Number_Of_Owned_Planets_By_Faction

    for i, faction_name in ipairs(SortKeys(number_of_planets_per_faction,"desc")) do
        local number_of_owned_planets = number_of_planets_per_faction[faction_name]
        if number_of_owned_planets ~= 0 then
            local faction = Find_Player(faction_name)

            if not faction then
                DebugMessage("GalacticStatDisplay::update -- could not find faction %s", tostring(faction_name))
            end

            self.stat_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            self.stat_display_event.Add_Dialog_Text(CONSTANTS.ALL_FACTION_TEXTS[faction_name])
            self.stat_display_event.Add_Dialog_Text("STAT_PLANET_COUNT", number_of_owned_planets)

            local force_percentage = nil
            local income = nil
            local upkeep = nil
            local credits = nil
            local smuggling_income = nil

            if self:should_show(faction_name,"STAT_FORCE_PERCENT") then
                force_percentage = EvaluatePerception("Percent_Forces", faction)
                self.stat_display_event.Add_Dialog_Text("STAT_FORCE_PERCENT", force_percentage)
            end     

            if self:should_show(faction_name,"economic_stats") then
                income = EvaluatePerception("Current_Income", faction)
                self.stat_display_event.Add_Dialog_Text("STAT_INCOME", income)

                if faction == Find_Player("HUTT_CARTELS") then
                    smuggling_income = GlobalValue.Get("HUTT_SMUGGLING_INCOME")

                    if smuggling_income == nil then
                        smuggling_income = 0
                    end
                    self.stat_display_event.Add_Dialog_Text("STAT_INCOME_SMUGGLING", smuggling_income)
                end

                upkeep = tonumber(Dirty_Floor(EvaluatePerception("Total_Maintenance", faction)))
                self.stat_display_event.Add_Dialog_Text("STAT_UPKEEP", upkeep)

                credits = faction.Get_Credits()
                self.stat_display_event.Add_Dialog_Text("STAT_CREDITS", credits)
            end

            DebugMessage(
                "GalacticStatDisplay::update -- Faction %s, planets: %s, forces: %s, income %s, upkeep %s",
                faction_name,
                tostring(number_of_owned_planets),
                tostring(force_percentage),
                tostring(income),
                tostring(upkeep)
            )
        end
    end

    Story_Event("SHOW_STAT_DISPLAY")
end

function GalacticStatDisplay:should_show(faction_name,stat_name)
    --display no statistics beyond planet count for Neutral
    if faction_name == "NEUTRAL" then
        return false
    end
    
    --display force percent and planet count for factions with no AI
    if stat_name == "STAT_FORCE_PERCENT" then
        return true
    end
    
    --display no additional stats for factions with no AI
    if CONSTANTS.ALL_FACTIONS_AI[faction_name] == "None" then
        return false
    end
    
    return true
end

---@param player_name string (must be XML faction name)
---@param new_display_name string
---@param new_particle string (must be XML particle name)
function GalacticStatDisplay:faction_display_name_change(player_name, new_display_name, new_particle)
    if new_display_name then
        CONSTANTS.ALL_FACTION_TEXTS[player_name] = new_display_name
        CONSTANTS.ALL_FACTION_NAMES[player_name] = new_display_name
    end

    if new_particle then
        CONSTANTS.PARTICLES[player_name] = new_particle
    end
end
