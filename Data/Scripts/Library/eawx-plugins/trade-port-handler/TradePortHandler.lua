require("deepcore/std/class")
require("eawx-util/GalacticUtil")
require("eawx-util/StoryUtil")


---@class TradePortHandler
TradePortHandler = class()

---@param human_player PlayerObject
---@param planets table<string, Planet>
---@param dummy_lifecycle_handler KeyDummyLifeCycleHandler
function TradePortHandler:new(human_player, planets, maxroutes, production_finished, dummy_lifecycle_handler)
    self.human_player = human_player
    self.planets = {}
    self.dummy_lifecycle_handler = dummy_lifecycle_handler
    self.maxroutes = 2
    
    local all_planets = FindPlanet.Get_All_Planets()
    local num_planets = table.getn(all_planets)

    for _, planet in pairs(planets) do
        self.planets[planet] = {
            __current_trade_dummies = {},
            had_port = false
        }
    end

    self.production_finished_event = production_finished
    self.production_finished_event:attach_listener(self.on_production_finished, self)
end

---@param planet Planet
function TradePortHandler:update(planet)
    --Logger:trace("entering TradePortHandler:update")
    local planet_stats = self.planets[planet]

    if planet:get_owner() == Find_Player("Neutral") then
        return
    end

    if EvaluatePerception("Planet_Has_Trade_Station", self.human_player, planet:get_game_object()) > 0 then
        self:add_dummies(planet)
    else
        if planet_stats.had_port == true and planet_stats.__current_trade_dummies ~= nil then
            planet_stats.had_port = false
            self.dummy_lifecycle_handler:remove_from_dummy_set(planet, planet_stats.__current_trade_dummies)
        end
    end
end

---@param planet Planet
function TradePortHandler:on_production_finished(planet, object_type_name)
    --Logger:trace("entering TradePortHandler:on_production_finished")
    if object_type_name == "TRADESTATION" or object_type_name == "DASTA_TRADESTATION" then
        self:add_dummies(planet)
    end
end

---@private
---@param planet Planet
function TradePortHandler:add_dummies(planet)
    --Logger:trace("entering TradePortHandler:add_dummies")
    local planet_stats = self.planets[planet]
    if planet_stats.__current_trade_dummies ~= nil then
        self.dummy_lifecycle_handler:remove_from_dummy_set(planet, planet_stats.__current_trade_dummies)
    end

    local dummy_amount_table = {
        {TRADE_INCOME_DUMMY = 1},
        {TRADE_INCOME_DUMMY = 2},
        {TRADE_INCOME_DUMMY = 3},
        {TRADE_INCOME_DUMMY = 4},
        {TRADE_INCOME_DUMMY = 5},
        {TRADE_INCOME_DUMMY = 6},
        {TRADE_INCOME_DUMMY = 7},
        {TRADE_INCOME_DUMMY = 8},
        {TRADE_INCOME_DUMMY = 9},
        {TRADE_INCOME_DUMMY = 10}
    }
	local dummy_amount_hub_table = {
        {TRADE_HUB_INCOME_DUMMY = 1},
        {TRADE_HUB_INCOME_DUMMY = 2},
        {TRADE_HUB_INCOME_DUMMY = 3},
        {TRADE_HUB_INCOME_DUMMY = 4},
        {TRADE_HUB_INCOME_DUMMY = 5},
        {TRADE_HUB_INCOME_DUMMY = 6},
        {TRADE_HUB_INCOME_DUMMY = 7},
        {TRADE_HUB_INCOME_DUMMY = 8},
        {TRADE_HUB_INCOME_DUMMY = 9},
        {TRADE_HUB_INCOME_DUMMY = 10}
    }
    planet_stats.had_port = true
	
	local needint = true
	--StoryUtil.ShowScreenText("Checking routes", 5, nil, {r = 244, g = 0, b = 0})
	while needint do
		local routes = self.maxroutes * EvaluatePerception("Planet_TradeRoutes", self.human_player, planet:get_game_object())
		local diff = routes - Dirty_Floor(routes)
		if not (diff < 0.01 or diff > 0.99)	then
			--StoryUtil.ShowScreenText("failed for " .. tostring(self.maxroutes), 5, nil, {r = 244, g = 0, b = 0})
			self.maxroutes = self.maxroutes+1
		else
			needint = false
		end
	end
	--StoryUtil.ShowScreenText("Final routes: " .. tostring(self.maxroutes), 5, nil, {r = 244, g = 0, b = 0})
	

    local connections = tonumber(Dirty_Floor(self.maxroutes * EvaluatePerception("Planet_TradeRoutes", self.human_player, planet:get_game_object()) * EvaluatePerception("Planet_ActiveTradeRoutes", self.human_player, planet:get_game_object()) + 0.15)+EvaluatePerception("Connected_Ally_Count", planet:get_game_object().Get_Owner(), planet:get_game_object()))
	local is_trade_hub = EvaluatePerception("Resource_Trade_Hub", self.human_player, planet:get_game_object())
    if connections > 0 then
        if is_trade_hub == 0 then
			planet_stats.__current_trade_dummies = dummy_amount_table[connections]
		else
			planet_stats.__current_trade_dummies = dummy_amount_hub_table[connections]
		end
		
        self.dummy_lifecycle_handler:add_to_dummy_set(planet, planet_stats.__current_trade_dummies)
    end
end

return TradePortHandler
