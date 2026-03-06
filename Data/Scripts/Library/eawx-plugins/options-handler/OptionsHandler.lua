require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("eawx-util/ChangeOwnerUtilities")
CONSTANTS = ModContentLoader.get("GameConstants")
require("deepcore/crossplot/crossplot")

OptionsHandler = class()

function OptionsHandler:new(galactic_conquest, gc_id)
    self.galactic_conquest = galactic_conquest
    self.gc_id = gc_id

    self.human_player = Find_Player("local")
    self.human_name = self.human_player.Get_Faction_Name()

    self.ai_initialized = false
    self.ai_normal_on = false
    self.ai_cruel_on = false

    self.galactic_display_initialized = false

    self.isFotR = (Find_Object_Type("fotr") ~= nil)
    self.isTR = (Find_Object_Type("icw") ~= nil)
    self.isRev = (Find_Object_Type("rev") ~= nil)

    GlobalValue.Set("CRUEL_ON", 0)

    crossplot:subscribe("INITIALIZE_AI", self.activate_normal_ai, self)
    crossplot:subscribe("OVERRIDE_AI_PLAYER", self.override_ai_player, self)
    crossplot:subscribe("RESET_AI_PLAYER", self.reset_ai_player, self)

    self.production_finished_event = galactic_conquest.Events.GalacticProductionFinished
    self.production_finished_event:attach_listener(self.on_construction_finished, self)

    --debug only
    self.cheater_flag = false
    self.cheat_govt_flag = false
    self.cheat_disable_ai_on = false
    self.cheat_vision_on = false
    self.cheat_influence_on = false
    self.cheat_infra_and_discount_on = false
    self.cheat_crews_on = false

    --comment out to disable cheats for release builds
    self:enable_cheats()
end

function OptionsHandler:on_construction_finished(planet, game_object_type_name)
    --Logger:trace("entering OptionsHandler:on_construction_finished")
    if planet:get_owner() ~= self.human_player then
        return
    end

    --options
    if string.find(game_object_type_name,"OPTION") ~= nil then
        if game_object_type_name == "OPTION_CRUEL_ON" then 
            self:activate_cruel_ai()
        elseif game_object_type_name == "OPTION_CRUEL_OFF" then 
            self:activate_normal_ai()
        elseif game_object_type_name == "OPTION_CANON_UNITS" then 
            self:canon_units()
        elseif game_object_type_name == "OPTION_FS_UNITS" then 
            self:fs_units()
        elseif game_object_type_name == "OPTION_FACTIONAL_FIGHTERS" then 
            self:factional_fighters()
        end

        return
    end

    --cheats
    if string.find(game_object_type_name,"CHEAT") ~= nil then
        if game_object_type_name == "CHEAT_DISABLE_AI" then
            self:cheat_disable_ai()
        elseif game_object_type_name == "CHEAT_GIVE_CREDITS" then
            self:cheat_give_credits()
        elseif game_object_type_name == "CHEAT_GIVE_UNIT" then
            self:cheat_unit()
        elseif game_object_type_name == "CHEAT_GIVE_VISION" then
            self:cheat_give_vision()
        elseif game_object_type_name == "CHEAT_GOVERNMENT" then
            self:cheat_government()
        elseif game_object_type_name == "CHEAT_INFLUENCE" then
            self:cheat_influence()
        elseif game_object_type_name == "CHEAT_INFRA_AND_DISCOUNT" then
            self:cheat_infra_and_discount()
        elseif game_object_type_name == "CHEAT_KILL_ALL" then
            self:cheat_kill_all()
        elseif game_object_type_name == "CHEAT_TURN_OFF_CREWS" then
            self:cheat_turn_off_crews()
        elseif game_object_type_name == "CHEAT_VICTORY" then
            self:cheat_victory()
        end
    end
end

--options

function OptionsHandler:activate_normal_ai()
    --Logger:trace("entering OptionsHandler:activate_normal_ai")
    if self.ai_normal_on == true then
        return
    end

    for _, faction_name in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
        if faction_name ~= self.human_name then
            local ai_type = CONSTANTS.ALL_FACTIONS_AI[faction_name]
            if self.isFotR == true then
                if self.gc_id == "HISTORICAL" then
                    ai_type = CONSTANTS.ALL_FACTIONS_AI_HISTORICAL[faction_name]
                elseif self.human_name == "REBEL" then
                    ai_type = CONSTANTS.ALL_FACTIONS_AI_CIS[faction_name]
                end
            end
            StoryUtil.ChangeAIPlayer(faction_name, ai_type)
        end
    end
    if self.isFotR == true and self.ai_initialized == false then
        Sleep(0.1) --Some FOTR historical GCs CTD for CIS player w/o this. ~Mord
    end

    self.human_player.Lock_Tech(Find_Object_Type("OPTION_CRUEL_OFF"))
    self.human_player.Unlock_Tech(Find_Object_Type("OPTION_CRUEL_ON"))
    GlobalValue.Set("CRUEL_ON", 0)
    self.ai_initialized = true
    self.ai_cruel_on = false
    self.ai_normal_on = true

    --a bit of an ugly hack to put this here, but every GC calls the AI, so it's not an entirely horrible place ~Mord
    if self.galactic_display_initialized == false then
        GlobalValue.Set("GALACTIC_DISPLAY_ON", 1)
        crossplot:publish("UPDATE_INFRA",true)
        crossplot:publish("CALCULATE_CREW_INCOME",true)
        crossplot:publish("CHECK_UPKEEP",true)
        self.galactic_display_initialized = true
        StoryUtil.UnlockAllControls()
    end
end

function OptionsHandler:activate_cruel_ai()
    --Logger:trace("entering OptionsHandler:activate_cruel_ai")
    if self.ai_cruel_on == true or self.ai_initialized == false then
        return
    end

    for _, faction_name in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
        if faction_name ~= self.human_name then
            local ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI[faction_name]
            if self.isFotR == true then
                if self.gc_id == "HISTORICAL" then
                    ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI_HISTORICAL[faction_name]
                elseif self.human_name == "REBEL" then
                    ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI_CIS[faction_name]
                end
            end
            StoryUtil.ChangeAIPlayer(faction_name, ai_type)
        end
    end

    self.human_player.Unlock_Tech(Find_Object_Type("OPTION_CRUEL_OFF"))
    self.human_player.Lock_Tech(Find_Object_Type("OPTION_CRUEL_ON"))
    GlobalValue.Set("CRUEL_ON", 1)
    self.ai_cruel_on = true
    self.ai_normal_on = false
end

function OptionsHandler:deactivate_ai()
    --Logger:trace("entering OptionsHandler:deactivate_ai")
    if self.ai_initialized == false then
        return
    end

    for _, faction_name in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
        if faction_name ~= self.human_name then
            StoryUtil.ChangeAIPlayer(faction_name, "None")
        end
    end

    self.human_player.Lock_Tech(Find_Object_Type("OPTION_CRUEL_OFF"))
    self.human_player.Lock_Tech(Find_Object_Type("OPTION_CRUEL_ON"))
    GlobalValue.Set("CRUEL_ON", 0)
    self.ai_cruel_on = false
    self.ai_normal_on = false
end

function OptionsHandler:canon_units()
    --Logger:trace("entering OptionsHandler:canon_units")

    UnitUtil.SetLockList("REBEL", {
        "MC75",
        "Starhawk_MK1"})
    crossplot:publish("NR_CANON_ADMIRALS")
end

function OptionsHandler:fs_units()
    --Logger:trace("entering OptionsHandler:fs_units")

    UnitUtil.SetLockList("EMPIRE", {
        "Impellor_Carrier", "Compellor_Battlecruiser"})

    UnitUtil.SetLockList("GREATER_MALDROOD", {
        "Legator_Star_Dreadnought"})
end

function OptionsHandler:factional_fighters()
    --Logger:trace("entering OptionsHandler:factional_fighters")

    local factional = GlobalValue.Get("FACTIONAL_FIGHTERS")
    if factional then
        factional = nil
        StoryUtil.ShowScreenText("Factional fighters turned off", 5)
    else
        factional = true
        StoryUtil.ShowScreenText("Factional fighters turned on", 5)
    end
    GlobalValue.Set("FACTIONAL_FIGHTERS", factional)
end

---@param tag string (refer to GameConstants.lua)
---@param player_name string (refer to GameConstants.lua)
---@param ai_player_name string (must be AI player name)
function OptionsHandler:override_ai_player(tag, faction_name, ai_player_name)
    CONSTANTS[tag][faction_name] = ai_player_name
end

---@param player_name string (refer to GameConstants.lua)
function OptionsHandler:reset_ai_player(faction_name)
    local ai_type = "None"
    if self.ai_normal_on then
        ai_type = CONSTANTS.ALL_FACTIONS_AI[faction_name]
    elseif self.ai_cruel_on then
        ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI[faction_name]
    end

    StoryUtil.ChangeAIPlayer(faction_name, ai_type)
end

--cheats

function OptionsHandler:enable_cheats()
    local cheat_list = {
        "Cheat_Disable_AI",
        "Cheat_Give_Credits",
        "Cheat_Give_Unit",
        "Cheat_Give_Vision",
        "Cheat_Government",
        "Cheat_Influence",
        "Cheat_Infra_And_Discount",
        "Cheat_Kill_All",
        "Cheat_Turn_Off_Crews",
        "Cheat_Victory",
    }

    for _, cheat in pairs(cheat_list) do
        self.human_player.Unlock_Tech(Find_Object_Type(cheat))
    end
end

function OptionsHandler:set_cheater()
    Find_Player("local").Give_Money(1)

    if self.cheater_flag == true then
        return
    end

    self.cheater_flag = true
    GlobalValue.Set("CHEATER",true)
end

function OptionsHandler:cheat_disable_ai()
    self:set_cheater()

    self.cheat_disable_ai_on = not self.cheat_disable_ai_on

    if self.cheat_disable_ai_on == true then
        StoryUtil.ShowScreenText("All non-human factions have been set to AI player \"None.\"", 15, nil, {r = 217, g = 2, b = 125}, false)
        self:deactivate_ai()
    else
        StoryUtil.ShowScreenText("All non-human factions have been restored to their default AI players.", 15, nil, {r = 217, g = 2, b = 125}, false)
        self:activate_normal_ai()
    end
end

function OptionsHandler:cheat_give_credits()
    self:set_cheater()

    StoryUtil.ShowScreenText("$100,000 added to reserves.", 15, nil, {r = 217, g = 2, b = 125}, false)
    Find_Player("local").Give_Money(100000)
end

function OptionsHandler:cheat_unit()
    self:set_cheater()

    local planet_object = FindPlanet(GlobalValue.Get("SELECTED_PLANET"))
    local player_object = Find_Player("local")
    if StoryUtil.CheckFriendlyPlanet(planet_object, player_object, false) == true then
        StoryUtil.ShowScreenText("The Buick Electra is a full-size luxury car manufactured and marketed by Buick from 1959 to 1990.", 15, nil, {r = 217, g = 2, b = 125}, false)
        Spawn_Unit(Find_Object_Type("Cheat_Team"),planet_object,player_object)
    else
        StoryUtil.ShowScreenText("Spawn failed; selected planet unsafe.", 15, nil, {r = 217, g = 2, b = 125}, false)
    end
end

function OptionsHandler:cheat_give_vision()
    self:set_cheater()

    self.cheat_vision_on = not self.cheat_vision_on

    if self.cheat_vision_on == true then
        StoryUtil.ShowScreenText("Galactic spy vision enabled.", 15, nil, {r = 217, g = 2, b = 125}, false)
        StoryUtil.SpawnAtSafePlanet(nil,Find_Player("local"),{},{"Cheat_Dummy_Vision"},true,false)
    else
        StoryUtil.ShowScreenText("Galactic spy vision disabled.", 15, nil, {r = 217, g = 2, b = 125}, false)
        local cheat_dummy_vision = Find_First_Object("Cheat_Dummy_Vision")
        if TestValid(cheat_dummy_vision) == true then
            cheat_dummy_vision.Despawn()
        end
    end
end

function OptionsHandler:cheat_government()
    self:set_cheater()

    if self.cheat_govt_flag == true then
        StoryUtil.ShowScreenText("No effect.", 15, nil, {r = 217, g = 2, b = 125}, false)
        return
    end

    self.cheat_govt_flag = true

    if self.isFotR == true then
        crossplot:publish("SENATE_SUPPORT_REACHED", "empty")
        StoryUtil.ShowScreenText("Senate support capstone has been triggered for Republic player.", 15, nil, {r = 217, g = 2, b = 125}, false)
    elseif self.isTR == true then
        StoryUtil.ShowScreenText("Choose an Imperial faction to host the Dark Empire.", 15, nil, {r = 217, g = 2, b = 125}, false)

        crossplot:publish("POPUPEVENT", "DARK_EMPIRE_CHEAT_CHOICE", {"EMPIRE","PENTASTAR","ZSINJ_EMPIRE","ERIADU_AUTHORITY","GREATER_MALDROOD","IMPERIAL_PROTEUS"}, "DARK_EMPIRE_CHEAT_CHOICE_MADE")

    elseif self.isRev then
        StoryUtil.ShowScreenText("This cheat doesn't do anything in Revan's Revenge.", 15, nil, {r = 217, g = 2, b = 125}, false)
    end
end

function OptionsHandler:cheat_influence()
    self:set_cheater()

    self.cheat_influence_on = not self.cheat_influence_on

    if self.cheat_influence_on == true then
        StoryUtil.ShowScreenText("Influence will be fixed at 10 on your planets starting next cycle.", 15, nil, {r = 217, g = 2, b = 125}, false)
    else
        StoryUtil.ShowScreenText("Influence will be calculated normally on your planets starting next cycle.", 15, nil, {r = 217, g = 2, b = 125}, false)
    end
end

function OptionsHandler:cheat_infra_and_discount()
    self:set_cheater()

    self.cheat_infra_and_discount_on = not self.cheat_infra_and_discount_on

    if self.cheat_infra_and_discount_on == true then
        StoryUtil.ShowScreenText("Infrastructure disabled & discount applied.", 15, nil, {r = 217, g = 2, b = 125}, false)
    else
        StoryUtil.ShowScreenText("Infrastructure effects re-enabled & discount removed.", 15, nil, {r = 217, g = 2, b = 125}, false)
    end
    crossplot:publish("UPDATE_INFRA", "empty")
end

function OptionsHandler:cheat_kill_all()
    self:set_cheater()

    StoryUtil.ShowScreenText("All units & structures for all non-player factions will die, except heroes and primary starbases.", 15, nil, {r = 217, g = 2, b = 125}, false)
    KillAllNonHumanNonHeroObjects()
end

function OptionsHandler:cheat_turn_off_crews()
    self:set_cheater()

    self.cheat_crews_on = not self.cheat_crews_on

    if self.cheat_crews_on == true then
        StoryUtil.ShowScreenText("Crew requirements disabled.", 15, nil, {r = 217, g = 2, b = 125}, false)
    else
        StoryUtil.ShowScreenText("Crew requirements re-enabled.", 15, nil, {r = 217, g = 2, b = 125}, false)
    end
    crossplot:publish("UPDATE_AVAILABILITY", "empty")
end

function OptionsHandler:cheat_victory()
    self:set_cheater()

    GlobalValue.Set("ENDING","DEFAULT_WIN")

    StoryUtil.ShowScreenText("Victory will be declared imminently.", 15, nil, {r = 217, g = 2, b = 125}, false)
    StoryUtil.DeclareVictory(Find_Player("local"), true)
end

return OptionsHandler
