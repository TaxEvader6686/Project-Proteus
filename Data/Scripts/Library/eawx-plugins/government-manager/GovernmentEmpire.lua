require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/GalacticUtil")
require("eawx-util/ChangeOwnerUtilities")
require("TRCommands")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("UnitSwitcherLibrary")
require("eawx-util/Sort")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class GovernmentEmpire
GovernmentEmpire = class()

function GovernmentEmpire:new(gc, absorb, dark_empire_available, id)
    self.id = id

    self.inited = false
    self.ProteusInited = false

    self.PlayerEmpire = Find_Player("Empire")
    self.PlayerPentastar = Find_Player("Pentastar")
    self.PlayerMaldrood = Find_Player("Greater_Maldrood")
    self.PlayerZsinj = Find_Player("Zsinj_Empire")
    self.PlayerEriadu = Find_Player("Eriadu_Authority")
    self.PlayerImperial_Proteus = Find_Player("Imperial_Proteus")
    self.PlayerWarlords = Find_Player("Warlords")
    self.PlayerHuman = Find_Player("local")
    self.HumanFactionName = self.PlayerHuman.Get_Faction_Name()

    self.StartingEra = GlobalValue.Get("CURRENT_ERA")
    self.Unit_List = require("hardpoint-lists/PersistentDamageLibrary")
    self.Convoy_List = require("eawx-plugins/intervention-missions/ConvoyHuntTarget_Table")
    self.DarkEmpirePlanetBasedOnlyThreshold = table.getn(FindPlanet.Get_All_Planets())/2

    self.StartingEmpires = 0
    self.LegitimacyAbsorb = 3
    if absorb then
        self.LegitimacyAbsorb = absorb
    end

    self.legitimacy_groups = require("eawx-mod-icw/LegitimacyRewardLibrary")
    self.legitimacy_documentation = {}

    self.HighestLegitimacy = "EMPIRE"
    self.LowestLegitimacy = "GREATER_MALDROOD"

    GlobalValue.Set("IMPERIAL_REGIME_HOST", "EMPIRE")

    self.PlanetTable = require("eawx-util/PlanetTable")

    --Dark Empire
    self.DarkEmpireAvailable = true
    if self.StartingEra >= 4 or dark_empire_available == false then
        self.DarkEmpireAvailable = false
    end
    self.DarkEmpireUnlocked = false
    self.DarkEmpireUnderstudyName = nil
    self.DarkEmpireUnderstudyExNihilo = false
    self.DarkEmpireRequireIntegrations = 2
    self.DarkEmpirePlanetBasedOnly = false

    self.imperial_table = {
        ["EMPIRE"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            pending_integration = false,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Imperial_Stormtrooper_Company"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_STORMTROOPER"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 2
        },
        ["PENTASTAR"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            pending_integration = false,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Pellaeon_Reaper_Dummy"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_PELLAEON_REAPER"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["GREATER_MALDROOD"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            pending_integration = false,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Crimson_Victory_II_Star_Destroyer"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_CCVSD"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["ZSINJ_EMPIRE"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            pending_integration = false,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Defiler_Company"},
            destruction_unlock_descs = {},
            zann_unlocked = false,
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["ERIADU_AUTHORITY"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            pending_integration = false,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Daala_Knight_Hammer_Dummy"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_DAALA_KNIGHT_HAMMER"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["IMPERIAL_PROTEUS"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            pending_integration = false,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {},
            destruction_unlock_descs = {},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
    }

    self.human_is_imperial = false
    for faction_name, _ in pairs(self.imperial_table) do
        if Find_Player(faction_name).Is_Human() then
            self.human_is_imperial = true
        end
    end

    --SSD heroes who are leaders do not need to be on this list
    self.leader_table = {
        -- Green Empire leaders
        ["PESTAGE_TEAM"] = {"SATE_PESTAGE"},
        ["YSANNE_ISARD_TEAM"] = {"YSANNE_ISARD"},
        "HISSA_MOFFSHIP",
        "THRAWN_CHIMAERA",
        "FLIM_TIERCE_IRONHAND",

        -- Pentastar leaders
        ["ARDUS_KAINE_TEAM"] = {"ARDUS_KAINE"},

        -- Greater Maldrood leaders
        "TREUTEN_13X",
        "TREUTEN_CRIMSON_SUNRISE",
        "KOSH_LANCET",

        -- Zsinj's Empire leaders
        "ZSINJ_IRON_FIST_VSD",

        -- Eriadu Authority leaders
        "DELVARDUS_BRILLIANT",
        "DELVARDUS_THALASSA",

        -- Legitimacy winner leaders
        ["EMPEROR_PALPATINE_TEAM"] = {"EMPEROR_PALPATINE"},
        ["CARNOR_JAX_TEAM"] = {"CARNOR_JAX"},
        "DAALA_GORGON",
        "PELLAEON_CHIMAERA_GRAND"
    }

    --SSD heroes need to be on *this* list whether or not they are leaders
    self.hero_ssd_table = {
        ["ISARD_LUSANKYA"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_ISARD",
        ["CRONUS_NIGHT_HAMMER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_CRONUS_NIGHT_HAMMER",
        ["DELVARDUS_NIGHT_HAMMER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_DELVARDUS",
        ["DAALA_KNIGHT_HAMMER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_DAALA",
        ["PELLAEON_REAPER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_PELLAEON_REAPER",
        ["PELLAEON_MEGADOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_PELLAEON_MEGADOR",
        ["ROGRISS_DOMINION"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_ROGRISS_DOMINION",
        ["KAINE_REAPER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_KAINE",
        ["SYSCO_VENGEANCE"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_SYSCO_VENGEANCE",
        ["ZSINJ_IRON_FIST_EXECUTOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_ZSINJ",
        ["RASLAN_RAZORS_KISS"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_RASLAN_RAZORS_KISS",
        ["DROMMEL_GUARDIAN"] = "TEXT_GOVERNMENT_EMPIRE_SSD_WARLORD_DROMMEL",
        ["GRUNGER_AGGRESSOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_WARLORD_GRUNGER",
        ["GRONN_ACULEUS"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_GRONN",
        ["BALAN_JAVELIN"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_BALAN",
        ["KIEZ_WHELM"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_KIEZ",
        ["COMEG_BELLATOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_COMEG",
        ["X1_EXECUTOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_WARLORD_X1",
        ["THORN_ASSERTOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_THORN",
    }

    self.planet_values = {
        ["BASTION"] = 3,
        ["CARIDA"] = 5,
        ["CORUSCANT"] = 10,
        ["ERIADU"] = 3,
        ["KUAT"] = 5
    }

    self.dead_leader_table = {}

    self.galactic_hero_killed_event = gc.Events.GalacticHeroKilled
    self.galactic_hero_killed_event:attach_listener(self.on_galactic_hero_killed, self)

    self.planet_owner_changed_event = gc.Events.PlanetOwnerChanged
    self.planet_owner_changed_event:attach_listener(self.on_planet_owner_changed, self)

    self.production_finished_event = gc.Events.GalacticProductionFinished
    self.production_finished_event:attach_listener(self.on_production_finished, self)

    crossplot:subscribe("INITIALIZE_PROTEUS_LEGITIMACY", self.proteus_init, self)
    crossplot:subscribe("INITIALIZE_AI", self.initialize_legitimacy, self)
    crossplot:subscribe("INCREASE_LEGITIMACY", self.adjust_legitimacy, self)
    crossplot:subscribe("DARK_EMPIRE_CHEAT_CHOICE_MADE", self.dark_empire_unlock, self)
    crossplot:subscribe("DARK_EMPIRE_CHOICE_MADE", self.dark_empire_choice_made, self)
    crossplot:subscribe("FACTION_DISPLAY_NAME_CHANGE", self.faction_display_name_change, self)

    if self.human_is_imperial == true then
        crossplot:subscribe("UPDATE_GOVERNMENT", self.UpdateDisplay, self)
    end

    self.Events = {}
    self.Events.FactionIntegrated = Observable()
end


function GovernmentEmpire:set_absorb(newvalue)
    self.LegitimacyAbsorb = newvalue
end

function GovernmentEmpire:proteus_init(leaders)
    --Logger:trace("entering GovernmentEmpire:proteus_init")
    if table.getn(leaders) > 0 then
        if leaders[1] == "NO_LEGITIMACY" then
            self.imperial_table["IMPERIAL_PROTEUS"] = nil
            return
        end
    end
    self.imperial_table["IMPERIAL_PROTEUS"].controls_planets = true
    self.imperial_table["IMPERIAL_PROTEUS"].legitimacy = 25
    for leaderteam, leader in pairs(leaders) do
        if type(leaderteam) == "string" then
            self.leader_table[leaderteam] = leader
        else
            table.insert(self.leader_table, leader)
            if leader == "ULRIC_TAGGE" then
                UnitUtil.SetLockList("CORPORATE_SECTOR", {"DUMMY_RECRUIT_GROUP_TAGGE_CSA"}, false)
            end
        end
    end
    if self.inited == true then
        --Remove any group that got spawned in by a Proteus choice, but only if the regular init has already missed them
         for index=1,table.getn(self.legitimacy_groups) do
            local groups_to_remove = {}

            for i, entry in pairs(self.legitimacy_groups[index]) do
                local swap_entry = StoryUtil.Get_Swap_Entry(string.upper(entry.unlocks[1]))
                local removegroup = false

                for j, hero in pairs(swap_entry[2]) do
                    local h = Find_All_Objects_Of_Type(hero)
                    if table.getn(h) > 0 then
                        local owner = h[1].Get_Owner() --Technically this fails to account for the group being broken up under multiple owners, but that shouldn't come up much

                        if owner == self.PlayerImperial_Proteus then
                            removegroup = true
                        end
                    end
                end
                local units = entry["AlternateUnitLocks"]
                if units then
                    for j, hero in pairs(units) do
                        local h = Find_First_Object(hero)
                        if TestValid(h) then
                            local owner = h.Get_Owner()

                            if owner == self.PlayerImperial_Proteus then
                                removegroup = true
                                break
                            end
                        end
                    end
                end
                if removegroup then
                    table.insert(groups_to_remove, 1, i) --insert in reverse order so removing groups doesn't break the iteration
                    for level,data in pairs(self.legitimacy_documentation) do
                        for _,docentry in pairs(data) do
                            if docentry.name == entry.name then
                                docentry.state = " / [ " .. GlobalValue.Get("PROTEUS_CURRENT_DISPLAY_NAME") .. " ]"
                                break
                            end
                        end
                    end
                end
            end

            for _, id in pairs(groups_to_remove) do
                table.remove(self.legitimacy_groups[index], id)
            end
            --Debug print all enabled groups after removals
            --for i, entry in pairs(self.legitimacy_groups[index]) do
            --    StoryUtil.ShowScreenText(entry.unlocks[1], 15)
            --end
         end
     end
    self.ProteusInited = true
end

function GovernmentEmpire:initialize_legitimacy()
    --Logger:trace("entering GovernmentEmpire:initialize_legitimacy")

    if self.inited == true then
        return
    end

    self.StartingEmpires = 0
    for faction_name, _ in pairs(self.imperial_table) do

        local added_legitimacy = EvaluatePerception("Planet_Ownership", Find_Player(faction_name))

        if added_legitimacy == nil then
            return
        end

        if added_legitimacy > 0 then
            self.imperial_table[faction_name].controls_planets = true
            self.StartingEmpires = self.StartingEmpires + 1
        end

        --Needs to be one under the value, since one point already comes from initial count.
        for planet_name, value in pairs(self.planet_values) do
            if TestValid(FindPlanet(planet_name)) and (FindPlanet(planet_name).Get_Owner() == Find_Player(faction_name)) then
                added_legitimacy = added_legitimacy + value - 1
            end
        end

        self.imperial_table[faction_name].legitimacy = self.imperial_table[faction_name].legitimacy + added_legitimacy

        if not (self.id == "FTGU" or GlobalValue.Get("PROGRESSIVE_INFINITY")) then
            for faction, stats in pairs(self.imperial_table) do
                if faction_name ~= faction then
                    UnitUtil.SetLockList(faction_name, stats.destruction_unlocks, false)
                end
            end
        end

        if self.imperial_table[faction_name].controls_planets == false then
            self.imperial_table[faction_name].legitimacy = 0
        end
    end

    if self.StartingEmpires == 2 then
        self.DarkEmpireRequireIntegrations = 1
    elseif self.StartingEmpires <= 1 then
        self.DarkEmpirePlanetBasedOnly = true
    end

    self:calculate_percentile_legitimacy()

    local year = GlobalValue.Get("GALACTIC_YEAR")

    if year == 12 then
        self.PlayerEmpire.Unlock_Tech(Find_Object_Type("Pellaeon_Reaper_Dummy"))
    end
    if year >= 12 then
        self.PlayerEmpire.Unlock_Tech(Find_Object_Type("Crimson_Victory_II_Star_Destroyer"))
    end

    for index=1,table.getn(self.legitimacy_groups) do
		local PlanetTable = require("eawx-util/PlanetTable")
        local doctable = {}
        local groups_to_remove = {}
        for i, entry in pairs(self.legitimacy_groups[index]) do
            local doc_entry = {name = entry.name, documentation = entry.documentation, state = ""}
            local removegroup = false
            local swap_entry = StoryUtil.Get_Swap_Entry(string.upper(entry.unlocks[1]))

            local locale = {}
            local uselocale = false

            for j, hero in pairs(swap_entry[2]) do
                local h = Find_All_Objects_Of_Type(hero)
                if table.getn(h) > 0 then
                    local owner = h[1].Get_Owner() --Technically this fails to account for the group being broken up under multiple owners, but that shouldn't come up much
                    removegroup = true
                    if owner ~= self.PlayerWarlords then
                        if owner == self.PlayerImperial_Proteus then
                            doc_entry.state = " / [ " .. GlobalValue.Get("PROTEUS_CURRENT_DISPLAY_NAME") .. " ]"
                        else
                            doc_entry.state = " / [ " .. owner.Get_Name() .. " ]"
                        end
                        break
                    else
                        locale[PlanetTable[h[1].Get_Planet_Location().Get_Type().Get_Name()]] = true
                        uselocale = true
                    end
                end
            end
            local units = entry["AlternateUnitLocks"]
            if units then
                for j, hero in pairs(units) do
                    local h = Find_First_Object(hero)
                    if TestValid(h) then
                        local owner = h.Get_Owner()
                        removegroup = true
                        if owner ~= self.PlayerWarlords then
                            if owner == self.PlayerImperial_Proteus then
                                doc_entry.state = " / [ " .. GlobalValue.Get("PROTEUS_CURRENT_DISPLAY_NAME") .. " ]"
                            else
                                doc_entry.state = " / [ " .. owner.Get_Name() .. " ]"
                            end
                            break
                        else
                            locale[PlanetTable[h.Get_Planet_Location().Get_Type().Get_Name()]] = true
                            uselocale = true
                        end
                    end
                end
            end
           if uselocale then
                local first = true
                local text = ""
                for planet, bool in pairs(locale) do
                    if first then
                        first = false
                    else
                        text = text .. ", "
                    end
                    text = text .. planet
                end
                doc_entry.state = " / [ On map: " .. text .. " ]"
            end
            local maxstart = entry["maxstartyear"]
            if maxstart then
                if year > maxstart then
                    doc_entry.state = " / [ Locked ]"
                    removegroup = true
                end
            end
            local minstart = entry["minstartyear"]
            if minstart then
                if year < minstart then
                    doc_entry.state = " / [ Locked ]"
                    removegroup = true
                end
            end
            if entry["DarkEmpireLocked"] and self.DarkEmpireAvailable then
                doc_entry.state = " / [ Locked ]"
                removegroup = true
            end
            if removegroup then
                table.insert(groups_to_remove, 1, i) --insert in reverse order so removing groups doesn't break the interation
            end
            table.insert(doctable, doc_entry)
            entry.documentation = nil
        end
        for i, id in pairs(groups_to_remove) do
            table.remove(self.legitimacy_groups[index], id)
        end
        --Debug print all enabled groups after removals
        --for i, entry in pairs(self.legitimacy_groups[index]) do
        --    StoryUtil.ShowScreenText(entry.unlocks[1], 15)
        --end
        table.insert(self.legitimacy_documentation, doctable)
    end

    if TestValid(Find_First_Object("URAI_FEN")) then
            self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked = true
    end

    crossplot:unsubscribe("INITIALIZE_AI", self.initialize_legitimacy, self)

    self.inited = true
end

function GovernmentEmpire:update()
    --Logger:trace("entering GovernmentEmpire:Update")

    self:process_pending_integrations()

    for faction_name, table in pairs(self.imperial_table) do
        if self.imperial_table[faction_name].controls_planets == true and EvaluatePerception("Planet_Ownership", Find_Player(faction_name)) == 0 then
            self.imperial_table[faction_name].controls_planets = false
        end
    end

    if self.DarkEmpireAvailable == true and self.DarkEmpireUnlocked == false then
        for faction_name, stats in pairs(self.imperial_table) do
            if self.imperial_table[faction_name].factions_integrated >= self.DarkEmpireRequireIntegrations then
                if self.imperial_table[faction_name].percentile_legitimacy > 60 then
                    self:dark_empire_unlock(faction_name)
                end
            elseif self.DarkEmpirePlanetBasedOnly == true then
                if EvaluatePerception("Planet_Ownership", Find_Player(faction_name)) > self.DarkEmpirePlanetBasedOnlyThreshold then
                    self:dark_empire_unlock(faction_name)
                end
            end
        end
    end

    if self.StartingEra >= 4 and self.DarkEmpireUnlocked == false then
        for faction_name, stats in pairs(self.imperial_table) do
            if self.imperial_table[faction_name].factions_integrated >= 2 then
                if self.imperial_table[faction_name].percentile_legitimacy > 60 then
                    self.DarkEmpireUnlocked = true
                    GlobalValue.Set("IMPERIAL_REGIME_HOST", faction_name)
                end
            end
        end
    end
end

function GovernmentEmpire:process_pending_integrations()
    for victim_name, imptable in pairs(self.imperial_table) do
        if imptable.pending_integration then
            --Logger:trace("entering GovernmentEmpire- integrate loop")
            local player_victim = Find_Player(victim_name)
            local player_highest_legitimacy = Find_Player(self.HighestLegitimacy)

            crossplot:publish("CANCEL_CONVOY_HUNTS",victim_name)
            Faction_Total_Replace(player_victim,player_highest_legitimacy,1)

            --Logger:trace("entering GovernmentEmpire- integrate addons")
            if self.imperial_table[victim_name].destruction_unlocks then
                UnitUtil.SetLockList(victim_name, self.imperial_table[victim_name].destruction_unlocks, false)
                UnitUtil.SetLockList(self.HighestLegitimacy, self.imperial_table[victim_name].destruction_unlocks)
                for _, unit in pairs(self.imperial_table[victim_name].destruction_unlocks) do
                    table.insert(self.imperial_table[self.HighestLegitimacy].destruction_unlocks, unit)
                end
                for _, desc in pairs(self.imperial_table[victim_name].destruction_unlock_descs) do
                    table.insert(self.imperial_table[self.HighestLegitimacy].destruction_unlock_descs, desc)
                end
                self.imperial_table[victim_name].destruction_unlocks = {}
                self.imperial_table[victim_name].destruction_unlock_descs = {}
                self.imperial_table[victim_name].legitimacy = 0
                self.imperial_table[victim_name].controls_planets = false
                self.imperial_table[self.HighestLegitimacy].factions_integrated = self.imperial_table[self.HighestLegitimacy].factions_integrated + self.imperial_table[victim_name].integrate_value + self.imperial_table[victim_name].factions_integrated
            end

            self.imperial_table[victim_name].pending_integration = false
            self.imperial_table[victim_name].is_integrated = true
        end
    end
end

function GovernmentEmpire:on_galactic_hero_killed(hero_name, owner, killer)
    --Logger:trace("entering GovernmentEmpire:on_galactic_hero_killed")
    local should_exit = false
    for _, outer_table in pairs(self.Convoy_List) do
        for _, inner_table in pairs(outer_table) do
            if inner_table[1] == hero_name then
                should_exit = true
                break
            end
        end
    end

    if should_exit == true then
        return
    end

    for faction_name, _ in pairs(self.imperial_table) do
        if faction_name == owner then
            --all heroes
            self:adjust_legitimacy(owner, -1)

            --non-SSD leaders & warlords
            for leader_key, leader_value in pairs(self.leader_table) do
                if type(leader_value) ~= "table" then
                    if hero_name == leader_value then
                        self:adjust_legitimacy(owner, -4) --The 1 above adds to this
                    end
                elseif hero_name == leader_key then
                    self:adjust_legitimacy(owner, -4) --The 1 above adds to this
                    table.insert(self.dead_leader_table,hero_name)
                end
            end

            --SSD heroes
            for unit, _ in pairs(self.Unit_List[1]) do
                if hero_name == unit then
                    self:adjust_legitimacy(owner, -4) --The 1 above adds to this
                end
            end
        end

        if faction_name == killer then
            self.imperial_table[faction_name].heroes_killed_since_last_roll = self.imperial_table[faction_name].heroes_killed_since_last_roll + 1
        end
    end
end

function GovernmentEmpire:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering GovernmentEmpire:on_planet_owner_changed")
    if self.inited == false then
        return
    end

    if new_owner_name ~= "NEUTRAL" and old_owner_name ~= "NEUTRAL" then
        if self.imperial_table[old_owner_name] or self.imperial_table[new_owner_name] then
            local value = 1
            local name = planet:get_name()
            for important_planet, new_value in pairs(self.planet_values) do
                if name == important_planet then
                    value = new_value
                    break
                end
            end

            if self.imperial_table[old_owner_name] then
                self:adjust_legitimacy(old_owner_name, -value)
            end

            if self.imperial_table[new_owner_name] then
                if self.ProteusInited or new_owner_name ~= "IMPERIAL_PROTEUS" then --Don't let Proteus get rolls for their setup
                    self:adjust_legitimacy(new_owner_name, value)
                end
            end
        end
    end

    self:check_for_integration(old_owner_name)
end

function GovernmentEmpire:check_for_integration(old_owner_name)
    if not self.imperial_table[old_owner_name] then
        return
    end

    if self.imperial_table[old_owner_name].is_integrated == true then
        return
    end

    if self.imperial_table[old_owner_name].pending_integration == true then
        return
    end

    if self.HighestLegitimacy == old_owner_name then
        return
    end

    if self.imperial_table[self.HighestLegitimacy].controls_planets == false then
        return
    end

    if self.imperial_table[self.HighestLegitimacy].is_integrated == true then
        return
    end

    if self.imperial_table[self.HighestLegitimacy].pending_integration == true then
        return
    end

    if EvaluatePerception("Planet_Ownership", Find_Player(old_owner_name)) > self.LegitimacyAbsorb then
        return
    end

    if self:faction_has_living_leaders(old_owner_name) then
        return
    end

    StoryUtil.ChangeAIPlayer(old_owner_name, "None")

    if self.LegitimacyAbsorb > 0 or table.getn(self.imperial_table[old_owner_name].destruction_unlocks) > 0 then
        if GlobalValue.Get("GOV_EMP_DISABLE_MULTIMEDIA_HOLO") == 1 then
            StoryUtil.Multimedia("TEXT_GOVERNMENT_LEGITIMACY_ABSORB_SPEECH_"..tostring(old_owner_name), 15, nil, nil, 0, nil, {r = 255, g = 255, b = 100})
            GlobalValue.Set("GOV_EMP_DISABLE_MULTIMEDIA_HOLO", 0)
        else
            StoryUtil.Multimedia("TEXT_GOVERNMENT_LEGITIMACY_ABSORB_SPEECH_"..tostring(old_owner_name), 15, nil, "Imperial_Naval_Officer_Loop", 0, nil, {r = 255, g = 255, b = 100})
        end
    end

    self.imperial_table[old_owner_name].pending_integration = true
end

function GovernmentEmpire:on_production_finished(planet, game_object_type_name)
    --Logger:trace("entering GovernmentEmpire:on_production_finished")
    if game_object_type_name == "DUMMY_RECRUIT_GROUP_TAGGE_CSA" then
        self:tagge_handler(planet, game_object_type_name)
    end

	if game_object_type_name == "SELLASAS_LOADOUT_SWAP1" then
        --locks first loadout
        UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
            "Sellasas_Loadout_Swap1", "Imperial_DHC", "Neutron_Star_Mercenary", "Carrack_Cruiser", "Victory_I_Fleet_Star_Destroyer", "Victory_II_Star_Destroyer", "Imperial_I_Star_Destroyer"
        }, false)
        --unlocks second
        UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
            "Sellasas_Loadout_Swap2", "Rep_DHC", "Neutron_Star", "Carrack_Cruiser_Laser", "Victory_I_Star_Destroyer", "Victory_II_Carrier", "Imperial_I_Star_Destroyer_Patrol"
        })
    elseif game_object_type_name == "SELLASAS_LOADOUT_SWAP2" then
        --locks second loadout
        UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
            "Sellasas_Loadout_Swap2", "Rep_DHC", "Neutron_Star", "Carrack_Cruiser_Laser", "Victory_I_Star_Destroyer", "Victory_II_Carrier", "Imperial_I_Star_Destroyer_Patrol"
        }, false)
        --unlocks first
        UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
            "Sellasas_Loadout_Swap1", "Imperial_DHC", "Neutron_Star_Mercenary", "Carrack_Cruiser", "Victory_I_Fleet_Star_Destroyer", "Victory_II_Star_Destroyer", "Imperial_I_Star_Destroyer"
        })
    end

end

function GovernmentEmpire:tagge_handler(planet, game_object_type_name)
    --Logger:trace("entering GovernmentEmpire:tagge_handler")

    -- In case they've unlocked it. Probably need to handle this differently since it'd be annoying to get the group and then lose it.
    for faction_name, _ in pairs(self.imperial_table) do
        UnitUtil.SetLockList(faction_name, {
            "DUMMY_RECRUIT_GROUP_TAGGE"
        }, false)
    end

    for _,docentry in pairs(self.legitimacy_documentation[4]) do
        if docentry.name == "=== Tagge House ===" then
            docentry.state = " / [ Corporate Sector ]"
            break
        end
    end
    for i, entry in pairs(self.legitimacy_groups[4]) do
        if entry.text == "TEXT_GOVERNMENT_LEGITIMACY_GROUP_TAGGE" then
            table.remove(self.legitimacy_groups[4], i)
        end
    end
    local tagge_table = {{"CORPORATE_SECTOR","SHIP_MARKET","CSA_TAGGE_BATTLECRUISER",3}}

    crossplot:publish("ADJUST_MARKET_CHANCE", tagge_table)
    self.production_finished_event:detach_listener(self.tagge_handler, self)
end

function GovernmentEmpire:dark_empire_unlock(choice_name)
    --Logger:trace("entering GovernmentEmpire:dark_empire_unlock")
    if self.DarkEmpireUnlocked == true then
        return
    end

    local faction_name = string.gsub(choice_name, "DARK_EMPIRE_CHEAT_CHOICE_", "")

    self.DarkEmpireUnlocked = true

    if self.PlayerHuman == Find_Player(faction_name) then
        local runner_up = {}
        for faction,data in pairs(self.imperial_table) do
            if faction == self.HumanFactionName then
                --this space intentionally left blank
            elseif data.controls_planets == false then
                --this space intentionally left blank
            elseif data.pending_integration == true then
                --this space intentionally left blank
            elseif table.getn(runner_up) == 0 then
                runner_up = {faction,data.legitimacy}
            elseif data.legitimacy > runner_up[2] then
                runner_up = {faction,data.legitimacy}
            end
        end

        if table.getn(runner_up) == 0 then
            if self.HumanFactionName == "IMPERIAL_PROTEUS" then
                self.DarkEmpireUnderstudyName = "EMPIRE"
            else
                self.DarkEmpireUnderstudyName = "IMPERIAL_PROTEUS"
            end
            self.DarkEmpireUnderstudyExNihilo = true
        else
            self.DarkEmpireUnderstudyName = runner_up[1]
        end

        Story_Event("DARK_EMPIRE_CHOICE_BEGIN")

        local plot = Get_Story_Plot("Conquests\\Events\\EventLogRepository.xml")
        local dark_empire_ask_dialog_event = plot.Get_Event("Dark_Empire_Choice_Dialog")

        if self.DarkEmpireUnderstudyExNihilo == true then
            dark_empire_ask_dialog_event.Add_Dialog_Text("REFUSE: The Dark Empire emerges as a new enemy faction.")
        else
            dark_empire_ask_dialog_event.Add_Dialog_Text("REFUSE: "..CONSTANTS.ALL_FACTION_NAMES[self.DarkEmpireUnderstudyName].." becomes the Dark Empire. ")
        end
    else
        self:dark_empire_choice_made("DARK_EMPIRE_CHOICE_AI",faction_name)
    end
end

function GovernmentEmpire:dark_empire_choice_made(option,ai_faction_name)
    --Logger:trace("entering GovernmentEmpire:dark_empire_choice_made")
    local dark_empire_faction_name= nil

    if option == "DARK_EMPIRE_CHOICE_AI" then
        dark_empire_faction_name = ai_faction_name
        Story_Event("DARK_EMPIRE_NO_CONTACT")
    elseif option == "DARK_EMPIRE_CHOICE_ACCEPT" then
        dark_empire_faction_name = self.HumanFactionName
        Story_Event("DARK_EMPIRE_ACCEPT")
    elseif option == "DARK_EMPIRE_CHOICE_REFUSE" then
        GlobalValue.Set("LEGITIMACY_WINNER", self.HumanFactionName)
        dark_empire_faction_name = self.DarkEmpireUnderstudyName
        Story_Event("DARK_EMPIRE_REFUSE")
    end

    if self.DarkEmpireUnderstudyExNihilo == true then
        local safe_planets = StoryUtil.GetSafePlanetTable()
        if safe_planets["BYSS"] then
            StoryUtil.ShowScreenText("[ The Dark Empire has emerged from isolation on Byss ]", 15, nil, {r = 255, g = 255, b = 100}, false)
        else
            StoryUtil.ShowScreenText("[ The Dark Empire has emerged from its hidden stronghold ]", 15, nil, {r = 255, g = 255, b = 100}, false)
        end
        GlobalValue.Set("DARK_EMPIRE_EX_NIHILO",true)
    else
        StoryUtil.ShowScreenText("[ "..CONSTANTS.ALL_FACTION_NAMES[dark_empire_faction_name].." has become the Dark Empire ]", 15, nil, {r = 255, g = 255, b = 100}, false)
    end

    GlobalValue.Set("IMPERIAL_REGIME_HOST", dark_empire_faction_name)

    crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", dark_empire_faction_name, "Dark Empire")
    if dark_empire_faction_name == "IMPERIAL_PROTEUS" then
        GlobalValue.Set("PROTEUS_CURRENT_DISPLAY_NAME","Dark Empire")
    end

    if dark_empire_faction_name ~= "EMPIRE" then
        crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", "EMPIRE", "Ruling Council")
    end

    crossplot:publish("STATE_TRANSITION", "STATE_TRANSITION_DARK_EMPIRE")
end

function GovernmentEmpire:check_leader_dead(hero_team_name)
   if not next(self.dead_leader_table) then
        return false
    else
        for _,dead_team_name in pairs(self.dead_leader_table) do
            if hero_team_name == dead_team_name then
                return true
            end
        end
    end
    return false
end

function GovernmentEmpire:adjust_legitimacy(faction_name, added_legitimacy)
    --Logger:trace("entering GovernmentEmpire:adjust_legitimacy")

    local old_legitimacy = self.imperial_table[faction_name].legitimacy
    self.imperial_table[faction_name].legitimacy = self.imperial_table[faction_name].legitimacy +  added_legitimacy
    if self.imperial_table[faction_name].legitimacy <  0 then
        self.imperial_table[faction_name].legitimacy = 0
    end

    if self.imperial_table[faction_name].legitimacy > self.imperial_table[self.HighestLegitimacy].legitimacy then
        self.HighestLegitimacy = faction_name
    end

    if self.imperial_table[faction_name].legitimacy < self.imperial_table[self.LowestLegitimacy].legitimacy then
        self.LowestLegitimacy = faction_name
    end

    self:calculate_percentile_legitimacy()

    if old_legitimacy >= self.imperial_table[faction_name].legitimacy then
        return
    end

    local chance = GameRandom.Free_Random(1,40) + added_legitimacy + self.imperial_table[faction_name].heroes_killed_since_last_roll
    if self.imperial_table[faction_name].next_tier == 1 then
        chance = chance + 10
    end
    if self.imperial_table[faction_name].next_tier == 2 then
        chance = chance + 5
    end
    if chance >= 40 or self.imperial_table[faction_name].failed_rolls >= 14 or (self.imperial_table[faction_name].zann_unlocked == false and self.imperial_table[faction_name].failed_rolls >= 4) then
        self.imperial_table[faction_name].failed_rolls = 0
        self:group_joins(faction_name)
        self.imperial_table[faction_name].heroes_killed_since_last_roll = 0
        self.imperial_table[faction_name].failed_rolls = self.imperial_table[faction_name].failed_rolls - 5
        if self.imperial_table[faction_name].failed_rolls < 0 then
            self.imperial_table[faction_name].failed_rolls = 0
        end
    else
        self.imperial_table[faction_name].failed_rolls = self.imperial_table[faction_name].failed_rolls + 1
    end
end

function GovernmentEmpire:calculate_percentile_legitimacy()
    --Logger:trace("entering GovernmentEmpire:calculate_percentile_legitimacy")
    local total_legitimacy = 0
    for faction, _ in pairs(self.imperial_table) do
        total_legitimacy = total_legitimacy + self.imperial_table[faction].legitimacy
    end

    if total_legitimacy <= 0 then
        total_legitimacy = 1
    end

    for faction, _ in pairs(self.imperial_table) do
        self.imperial_table[faction].percentile_legitimacy = tonumber(Dirty_Floor((self.imperial_table[faction].legitimacy / total_legitimacy)*100 ))
    end
end

function GovernmentEmpire:group_joins(faction_name)
    --Logger:trace("entering GovernmentEmpire:group_joins")
    local level = self.imperial_table[faction_name].next_tier
    if self.imperial_table[faction_name].max_unlocked == true then
        level = GameRandom.Free_Random(1, 4)
    end

    if faction_name == "ZSINJ_EMPIRE" then
        if self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked == false then

            if self.PlayerZsinj.Is_Human() then
                StoryUtil.Multimedia("TEXT_GOVERNMENT_LEGITIMACY_GROUP_ZANN", 15, nil, "Tyber_Loop", 0)
            end
            UnitUtil.SetLockList(faction_name, {"AGGRESSOR_STAR_DESTROYER", "VENGEANCE_FRIGATE", "Dummy_Recruit_Group_Zann"})
            self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked = true
            table.insert(self.imperial_table[faction_name].joined_groups, "Dummy_Recruit_Group_Zann")
            return
        end
    end

    while table.getn(self.legitimacy_groups[level]) == 0 do
        level = level - 1
        if level == 0 then
            return
        end
    end
    local group_number = GameRandom.Free_Random(1, table.getn(self.legitimacy_groups[level]))

    UnitUtil.SetLockList(faction_name, self.legitimacy_groups[level][group_number].unlocks)

    if self.legitimacy_groups[level][group_number].text == "TEXT_GOVERNMENT_LEGITIMACY_GROUP_TAGGE" then
        UnitUtil.SetLockList("CORPORATE_SECTOR", {
            "DUMMY_RECRUIT_GROUP_TAGGE_CSA"
        }, false)
    end

    if Find_Player(faction_name).Is_Human() then
        if GlobalValue.Get("GOV_EMP_DISABLE_MULTIMEDIA_HOLO") == 1 then
            StoryUtil.Multimedia(self.legitimacy_groups[level][group_number].text, 15, nil, nil, 0)
              GlobalValue.Set("GOV_EMP_DISABLE_MULTIMEDIA_HOLO", 0)
        else
            StoryUtil.Multimedia(self.legitimacy_groups[level][group_number].text, 15, nil, self.legitimacy_groups[level][group_number].movie, 0)
        end
    end
    -- StoryUtil.ShowScreenText(faction_name, 15)
    -- self.Events.FactionIntegrated:notify {
    --     joined = Find_Player(faction_name)
    -- }

    local index = self.legitimacy_groups[level][group_number].name

    if self.legitimacy_documentation[level] == nil then
        StoryUtil.ShowScreenText(GetCurrentTime().." Attempted to recruit legitimacy group of level "..tostring(level).." but failed. Please report this bug!", 30, nil, {r = 217, g = 2, b = 125}, false)
    else
        for _,docentry in pairs(self.legitimacy_documentation[level]) do
            if index == docentry.name then
                docentry.state = " / [ " .. CONSTANTS.ALL_FACTION_NAMES[string.upper(faction_name)] .. " ]"
                break
            end
        end
    end

    table.insert(self.imperial_table[faction_name].joined_groups, self.legitimacy_groups[level][group_number].unlocks[1])
    table.remove(self.legitimacy_groups[level], group_number)
    if level == 5 then
        self.imperial_table[faction_name].max_unlocked = true
    end
    if self.imperial_table[faction_name].next_tier < 5 then
        self.imperial_table[faction_name].next_tier = self.imperial_table[faction_name].next_tier + 1
    end
end

function GovernmentEmpire:faction_has_living_leaders(faction_name)
    --Logger:trace("entering GovernmentEmpire:faction_has_living_leaders")
    local leader_alive = 0
    faction_player = Find_Player(faction_name)
    for leader_key, leader_value in pairs(self.leader_table) do
        if type(leader_value) ~= "table" then
            if Find_First_Object(leader_value) then
                if Find_First_Object(leader_value).Get_Owner() == faction_player then
                    leader_alive = leader_alive + 1
                end
            end
        elseif not self:check_leader_dead(leader_key) then
            if Find_First_Object(leader_value[1]) then
                if Find_First_Object(leader_value[1]).Get_Owner() == faction_player then
                    leader_alive = leader_alive + 1
                end
            end
        end
    end

    local ssd_alive = 0
    local object_list = {}
    for unit, _ in pairs(self.Unit_List[1]) do
        object_list = Find_All_Objects_Of_Type(unit, Find_Player(faction_name))
        ssd_alive = ssd_alive + table.getn(object_list)
    end

    if leader_alive == 0 and ssd_alive == 0 then
        return false
    end

    return true
end

---@param player_name string (must be XML faction name)
---@param new_display_name string
---@param new_particle string (must be XML particle name)
function GovernmentEmpire:faction_display_name_change(player_name, new_display_name, new_particle)
    if new_display_name then
        CONSTANTS.ALL_FACTION_TEXTS[player_name] = new_display_name
        CONSTANTS.ALL_FACTION_NAMES[player_name] = new_display_name
    end

    if new_particle then
        CONSTANTS.PARTICLES[player_name] = new_particle
    end
end

function GovernmentEmpire:UpdateDisplay()
    --Logger:trace("entering GovernmentEmpire:UpdateDisplay")
    if self.human_is_imperial ~= true then
        return
    end

    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local government_display_event = plot.Get_Event("Government_Display")

    government_display_event.Clear_Dialog_Text()

    government_display_event.Set_Reward_Parameter(1, self.PlayerHuman.Get_Faction_Name())

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    for i,faction_name in ipairs(SortKeysByElement(self.imperial_table,"legitimacy","desc")) do
        if self.imperial_table[faction_name].controls_planets == true then
            government_display_event.Add_Dialog_Text(
                "%s".. ": "..tostring(self.imperial_table[faction_name].legitimacy).." ("..tostring(self.imperial_table[faction_name].percentile_legitimacy).."%%)",
                CONSTANTS.ALL_FACTION_TEXTS[string.upper(faction_name)]
            )
            if self:faction_has_living_leaders(faction_name) then
                government_display_event.Add_Dialog_Text("TEXT_NONE")
                government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LIVING_LEADERS")
                faction_player = Find_Player(faction_name)
                --SSD heroes
                for hero_ssd, hero_ssd_text in pairs(self.hero_ssd_table) do
                    if Find_First_Object(hero_ssd) then
                        if Find_First_Object(hero_ssd).Get_Owner() == faction_player then
                            government_display_event.Add_Dialog_Text(hero_ssd_text)
                        end
                    end
                end
                --Non-SSD leaders & warlords
                for leader_key, leader_value in pairs(self.leader_table) do
                    if type(leader_value) ~= "table" then
                        if Find_First_Object(leader_value) then
                            if Find_First_Object(leader_value).Get_Owner() == faction_player then
                                government_display_event.Add_Dialog_Text("%s",Find_Object_Type(leader_value))
                            end
                        end
                    elseif not self:check_leader_dead(leader_key) then
                        if Find_First_Object(leader_value[1]) then
                            if Find_First_Object(leader_value[1]).Get_Owner() == faction_player then
                                government_display_event.Add_Dialog_Text("%s",Find_Object_Type(leader_value[1]))
                            end
                        end
                    end
                end
                --Generic SSDs
                for unit, _ in pairs(self.Unit_List[1]) do
                    if Find_First_Object(unit) then
                        if Find_First_Object(unit).Get_Owner() == faction_player then
                            if not self.hero_ssd_table[unit] then
                                government_display_event.Add_Dialog_Text("%s",Find_Object_Type(unit))
                            end
                        end
                    end
                end
            end
            if self.imperial_table[faction_name].destruction_unlock_descs[1] ~= nil then
                government_display_event.Add_Dialog_Text("TEXT_NONE")
                government_display_event.Add_Dialog_Text("Integration Rewards:")
                for _, desc in pairs(self.imperial_table[faction_name].destruction_unlock_descs) do
                    government_display_event.Add_Dialog_Text(desc)
                end
            end
            if self.imperial_table[faction_name].factions_integrated ~= 0 then
                government_display_event.Add_Dialog_Text("TEXT_NONE")
                government_display_event.Add_Dialog_Text("Factions Integrated: " .. tostring(self.imperial_table[faction_name].factions_integrated))
            end
            if self.imperial_table[faction_name].joined_groups[1] ~= nil then
                government_display_event.Add_Dialog_Text("TEXT_NONE")
                government_display_event.Add_Dialog_Text("Minor Groups Integrated:")
                for _, name in pairs(self.imperial_table[faction_name].joined_groups) do
                    government_display_event.Add_Dialog_Text("%s",Find_Object_Type(name))
                end
            end

            government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        end
    end

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DESCRIPTION")

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_BASE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_CONQUEST")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_MISSION")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_PLUS3")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_PLUS5")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_PLUS10")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_DEAD_HERO")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_DEAD_LEADER")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_INTEGRATION_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_INTEGRATION_DESCRIPTION", self.LegitimacyAbsorb)

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_DESCRIPTION")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("Requirements:")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    if self.DarkEmpireAvailable then
        if self.DarkEmpirePlanetBasedOnly == false then
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REQUIREMENT_1")
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REQUIREMENT_2", self.DarkEmpireRequireIntegrations)
        else
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REQUIREMENT_2", self.DarkEmpireRequireIntegrations)
        end
    else
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_UNAVAILABLE")
    end

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_1")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_2")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_3")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_4")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_5")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_6")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_7")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_8")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_9")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_10")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_11")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_12")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_CRIMSON_EMPIRE_REWARD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_CRIMSON_EMPIRE_REWARD_REWARD_1")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REUNIFICATION_REWARD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REUNIFICATION_REWARD_REWARD_1")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REUNIFICATION_REWARD_REWARD_2")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_1")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_2")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_3")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_4")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_5")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_6")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_EVENTS")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_EVENTS_REBORN_EMPIRE_REWARD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_EVENTS_REBORN_EMPIRE_REWARD_REWARD_1")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_EVENTS_REBORN_EMPIRE_REWARD_REWARD_2")

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_EVENTS_DISCIPLES_OF_RAGNOS_REWARD_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_EVENTS_DISCIPLES_OF_RAGNOS_REWARD_REWARD_1")

    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REWARD_LIST")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    for index=table.getn(self.legitimacy_documentation),1,-1 do
        local reversed = table.getn(self.legitimacy_documentation) + 1 - index
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_" .. reversed)
        for i, entry in pairs(self.legitimacy_documentation[index]) do
            government_display_event.Add_Dialog_Text(entry.name .. entry.state)
            if entry.documentation == nil then
                StoryUtil.ShowScreenText(entry.name .. " is missing documentation", 15)
            else
                for j, doc in pairs(entry.documentation) do
                    government_display_event.Add_Dialog_Text(doc)
                end
            end
        end
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    end
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL")
    if self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked then
        government_display_event.Add_Dialog_Text("=== Zann Consortium === / [ Zsinj's Empire ]")
    else
        government_display_event.Add_Dialog_Text("=== Zann Consortium === / [ Zsinj's Empire-only ]")
    end
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_1")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_2")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_3")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_4")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_5")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_6")

    Story_Event("GOVERNMENT_DISPLAY")
end

return GovernmentEmpire
