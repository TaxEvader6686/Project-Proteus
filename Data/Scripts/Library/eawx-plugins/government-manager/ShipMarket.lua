require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("PGStoryMode")

---@class ShipMarket
ShipMarket = class()

function ShipMarket:new(gc)
    self.human_player = Find_Player("local")

    self.market_types = require("ShipMarketOptions")

    self.proteus_init = false
    if Find_Player("Imperial_Proteus").Is_Human() == true then
        crossplot:subscribe("PROTEUS_MARKET", self.proteus_init_setup, self)
    end
    self:first_week_setup()

    gc.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)
    gc.Events.GalacticProductionCanceled:attach_listener(self.on_production_canceled, self)
    crossplot:subscribe("ADJUST_MARKET_CHANCE", self.adjust_ship_chance, self)
    crossplot:subscribe("ADJUST_MARKET_AMOUNT", self.add_or_remove_amount, self)
    crossplot:subscribe("LOCK_MARKET_OPTIONS", self.lock_or_unlock_options, self)

    self.Events = {}
    self.Events.ShipsAdded = Observable()
end

function ShipMarket:first_week_setup()
    --Logger:trace("entering ShipMarket:first_week_setup")
    for faction, market_tables in pairs(self.market_types) do
        if faction ~= "IMPERIAL_PROTEUS" then
            for market, market_data in pairs(market_tables) do
                for ship, ship_data in pairs(market_data.list) do
                    market_data.faction_object.Lock_Tech(Find_Object_Type(ship))
                end
            end
        end
    end
end

function ShipMarket:proteus_init_setup()
    --Logger:trace("entering ShipMarket:proteus_init_setup")
    self.proteus_init = true
    self.current_proteus = GlobalValue.Get("PROTEUS_GROUP_NAME")
    for faction, market_tables in pairs(self.market_types) do
        if faction == "IMPERIAL_PROTEUS" then
            for proteus, proteus_data in pairs(market_tables) do
                if proteus ~= self.current_proteus then
                    self.market_types["IMPERIAL_PROTEUS"][proteus] = nil
                else
                    for market, market_data in pairs(proteus_data) do
                        for ship, ship_data in pairs(market_data.list) do
                            market_data.faction_object.Lock_Tech(Find_Object_Type(ship))
                        end
                    end
                end
            end
        end
    end
	crossplot:unsubscribe("PROTEUS_MARKET", self.proteus_init_setup, self)
end

function ShipMarket:update()
    --Logger:trace("entering ShipMarket:Update")
    for faction, market_tables in pairs(self.market_types) do
        if faction == "IMPERIAL_PROTEUS" then
			if self.proteus_init == true then
				for market, market_data in pairs(market_tables[self.current_proteus]) do
					for ship, ship_data in pairs(market_data.list) do
						if GameRandom.Free_Random(1,1000) <= ship_data.chance and ship_data.locked == false and ship_data.gc_locked == false then
							self.market_types[faction][self.current_proteus][market].list[ship].amount = ship_data.amount + 1
							if market_data.faction_object.Is_Human() then
								self.Events.ShipsAdded:notify {
									added = ship_data.readable_name,
									market_name = market_data.market_name,
									news_colour = market_data.news_colour
								}
							end
						end
						if ship_data.amount > 0 then
							market_data.faction_object.Unlock_Tech(Find_Object_Type(ship))
						end
					end
				end
			elseif self.proteus_init == false and GetCurrentTime() > 5 then
			    crossplot:unsubscribe("PROTEUS_MARKET", self.proteus_init_setup, self)
				self.market_types["IMPERIAL_PROTEUS"] = nil
			end
        else
            for market, market_data in pairs(market_tables) do
                for ship, ship_data in pairs(market_data.list) do
                    if GameRandom.Free_Random(1,1000) <= ship_data.chance and ship_data.locked == false and ship_data.gc_locked == false then
                        self.market_types[faction][market].list[ship].amount = ship_data.amount + 1
                        if market_data.faction_object.Is_Human() then
                            self.Events.ShipsAdded:notify {
                                added = ship_data.readable_name,
                                market_name = market_data.market_name,
                                news_colour = market_data.news_colour
                            }
                        end
                    end
                    if ship_data.amount > 0 then
                        market_data.faction_object.Unlock_Tech(Find_Object_Type(ship))
                    end
                end
            end
        end
    end
end

---@param planet Planet
function ShipMarket:on_production_canceled(planet, game_object_type_name)
    --Logger:trace("entering ShipMarket:on_production_canceled")
    local owner = planet:get_owner().Get_Faction_Name()
    if self.market_types[owner] then
        self:find_market(owner, game_object_type_name, 1)
    end
end

function ShipMarket:on_production_queued(planet, game_object_type_name)
     --Logger:trace("entering ShipMarket:on_production_queued")
    local owner = planet:get_owner().Get_Faction_Name()
    if self.market_types[owner] then
        self:find_market(owner, game_object_type_name, -1)
    end
end

function ShipMarket:find_market(owner, game_object_type_name, adjustment)
    --Logger:trace("entering ShipMarket:add_or_remove_constructor")
    local market_name = nil
    if owner == "IMPERIAL_PROTEUS" then
		if self.proteus_init == true then
			for market, market_data in pairs(self.market_types[owner][self.current_proteus]) do
				if market_data.list[game_object_type_name] then
					market_name = market
					self:add_or_remove_amount({{owner, market_name, game_object_type_name, adjustment}})
					break
				end
			end
        end
    else    
        for market, market_data in pairs(self.market_types[owner]) do
            if market_data.list[game_object_type_name] then
                market_name = market
                self:add_or_remove_amount({{owner, market_name, game_object_type_name, adjustment}})
                break
            end
        end
    end
end

function ShipMarket:add_or_remove_amount(add_or_remove_tables)
     --Logger:trace("entering ShipMarket:add_or_remove_amount")
    DebugMessage("In ShipMarket:add_or_remove_amount")
    for _, add_or_remove_table in pairs(add_or_remove_tables) do
        local owner = add_or_remove_table[1] --faction
        local market = add_or_remove_table[2] --market
        local game_object_type_name = add_or_remove_table[3] --name
        local adjustment = add_or_remove_table[4] --adjustment
        local overwrite = add_or_remove_table[5] --overwrite

        if owner == "IMPERIAL_PROTEUS" and self.proteus_init == true then
            if self.market_types[owner][self.current_proteus][market].list[game_object_type_name] then
                if overwrite then
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].amount = adjustment
                else
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].amount = self.market_types[owner][self.current_proteus][market].list[game_object_type_name].amount + adjustment
                end
    
                if self.market_types[owner][self.current_proteus][market].list[game_object_type_name].amount < 1 then
                    self.market_types[owner][self.current_proteus][market].faction_object.Lock_Tech(Find_Object_Type(game_object_type_name))
                else
                    self.market_types[owner][self.current_proteus][market].faction_object.Unlock_Tech(Find_Object_Type(game_object_type_name))
                end
            end
        else
            if self.market_types[owner][market].list[game_object_type_name] then
                if overwrite then
                    self.market_types[owner][market].list[game_object_type_name].amount = adjustment
                else
                    self.market_types[owner][market].list[game_object_type_name].amount = self.market_types[owner][market].list[game_object_type_name].amount + adjustment
                end
    
                if self.market_types[owner][market].list[game_object_type_name].amount < 1 then
                    self.market_types[owner][market].faction_object.Lock_Tech(Find_Object_Type(game_object_type_name))
                else
                    self.market_types[owner][market].faction_object.Unlock_Tech(Find_Object_Type(game_object_type_name))
                end
            end
        end
    end
end

function ShipMarket:adjust_ship_chance(adjustment_tables)
    --Logger:trace("entering ShipMarket:adjust_ship_chance")
    DebugMessage("In ShipMarket:adjust_ship_chance")
    for _, adjustment_table in pairs(adjustment_tables) do
        local owner = adjustment_table[1] --faction
        local market = adjustment_table[2] --market
        local game_object_type_name = adjustment_table[3] --name
        local adjustment = adjustment_table[4] --adjustment
        local overwrite = adjustment_table[5] --overwrite

        if owner == "IMPERIAL_PROTEUS" and self.proteus_init == true then
            if self.market_types[owner][self.current_proteus][market].list[game_object_type_name] then
                if overwrite == true then
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].chance = adjustment
                else
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].chance = self.market_types[owner][self.current_proteus][market].list[game_object_type_name].chance + adjustment
                end
            end
        else
            if self.market_types[owner][market].list[game_object_type_name] then
                if overwrite == true then
                    self.market_types[owner][market].list[game_object_type_name].chance = adjustment
                else
                    self.market_types[owner][market].list[game_object_type_name].chance = self.market_types[owner][market].list[game_object_type_name].chance + adjustment
                end
            end
        end
    end
end

function ShipMarket:lock_or_unlock_options(lock_tables)
    --Logger:trace("entering ShipMarket:adjust_ship_chance")
    DebugMessage("In ShipMarket:adjust_ship_chance")
    for _, lock_table in pairs(lock_tables) do
        local owner = lock_table[1] --faction
        local market = lock_table[2] --market
        local game_object_type_name = lock_table[3] --name
        local lock = lock_table[4] --lock status
        local remove_existing = lock_table[5] --reduce existing
        local gc_lock = lock_table[6] --GC lock status

        if owner == "IMPERIAL_PROTEUS" and self.proteus_init == true then
            if self.market_types[owner][self.current_proteus][market].list[game_object_type_name] then
                if gc_lock == true then
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].gc_locked = true
                elseif gc_lock == false then
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].gc_locked = false
                end

                if lock == true then
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].locked = true
                elseif lock == false then
                    self.market_types[owner][self.current_proteus][market].list[game_object_type_name].locked = false
                end

                if remove_existing == true then
                    self:add_or_remove_amount({{owner, market, game_object_type_name, 0, true}})
                end
            end
        else
            if self.market_types[owner][market].list[game_object_type_name] then
                if gc_lock == true then
                    self.market_types[owner][market].list[game_object_type_name].gc_locked = true
                elseif gc_lock == false then
                    self.market_types[owner][market].list[game_object_type_name].gc_locked = false
                end

                if lock == true then
                    self.market_types[owner][market].list[game_object_type_name].locked = true
                elseif lock == false then
                    self.market_types[owner][market].list[game_object_type_name].locked = false
                end

                if remove_existing == true then
                    self:add_or_remove_amount({{owner, market, game_object_type_name, 0, true}})
                end
            end
        end
    end
end

function ShipMarket:adjust_ship_requirements(adjustment_tables)
    --Logger:trace("entering ShipMarket:adjust_ship_requirements")
    DebugMessage("In ShipMarket:adjust_ship_requirements")
    for _, adjustment_table in pairs(adjustment_tables) do
        local owner = adjustment_table[1] --faction
        local market = adjustment_table[2] --market
        local game_object_type_name = adjustment_table[3] --name
        local new_requirement = adjustment_table[4] --new requirements (always overwrites)

        if owner == "IMPERIAL_PROTEUS" and self.proteus_init == true then
            if self.market_types[owner][self.current_proteus][market].list[game_object_type_name] then
                self.market_types[owner][self.current_proteus][market].list[game_object_type_name].text_requirement = new_requirement
            end
        else
            if self.market_types[owner][market].list[game_object_type_name] then
                self.market_types[owner][market].list[game_object_type_name].text_requirement = new_requirement
            end
        end
    end
end

return ShipMarket
