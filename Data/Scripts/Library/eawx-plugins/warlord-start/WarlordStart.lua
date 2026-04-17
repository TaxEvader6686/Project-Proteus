require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("eawx-util/MissionUtil")
require("eawx-util/ChangeOwnerUtilities")
require("SetFighterResearch")

---@class WarlordStart
WarlordStart = class()

--Note: a specific choice can be forced with this call: crossplot:publish("WARLORD_CHOICE_OPTION","WARLORD_CHOICE_ZERO_COMMAND")
--AI_Proteus_Dummy being placed on the map will trigger the choice when not playing as Proteus

--crossplot:publish("WARLORD_CHOICE_OPTION", "SECTOR_5", true) will force a cosmetic only choice (faction leader, tech modifiers, faction name...) without affecting hero placement or planet ownership
--Use this for historicals where the Imperial_Proteus faction is set up as if it were a normal faction (e.g. Lamba Sector GC's Lankin, DCC GC's Prakith, OSH GC's Zero Command)

--Neither function can be called too early due to poorly understood initialization dependencies

function WarlordStart:new(galactic_conquest, id, human_player, planets)
	self.galactic_conquest = galactic_conquest
	self.gcid = id
	self.human_player = human_player
	self.warlord_name = "Imperial_Proteus"
	self.p_zsinj = Find_Player("Zsinj_Empire")
	self.warlord_player = Find_Player(self.warlord_name)
	self.selectionlist = {}
	self.optionlist = {}
	self.pagesize = 8
	self.optionindex = self.pagesize --starts at the first index of the second page
	self.capital = "Imperial_Proteus_Capital"

	self.warlordlist = require("ProteusWarlordLibrary")

	self.SafePlanetTable = StoryUtil.GetSafePlanetTable()
	
	self.nonplayable = false
	local ai_proteus_dummy = Find_First_Object("AI_Proteus_Dummy")
	if ai_proteus_dummy then
		ai_proteus_dummy.Despawn()
		self.nonplayable = true
	end

	crossplot:subscribe("WARLORD_START", self.Start_Trigger, self)
	crossplot:subscribe("WARLORD_CHOICE_OPTION", self.Choice_Chosen, self)
end

function WarlordStart:update()
	--this space intentionally left blank
end

function get_value_per_era(array, year, nontable)
	if nontable and type(array) ~= "table" then
		return array
	end
	if nontable or type(array[1]) == "table" then
		local corenne = array[1]
		local maxevent = 0 --The order of evaluation is not guaranteed
		for event, data in pairs(array) do
			if year >= event and event > maxevent then
				maxevent = event
				corenne = data
			end
		end
		return corenne
	else
		return array
	end
end

function WarlordStart:Start_Trigger()
	local year = GlobalValue.Get("GALACTIC_YEAR")
	if year == nil then
		year = 0.0
	end
	
	self:ZsinjRemnantHandler(year)
	
	if self.human_player ~= self.warlord_player then
		if self.nonplayable ~= true then
			return
		end
		StoryUtil.ShowScreenText("This Galactic Conquest features an AI-controlled Minor Warlord", 20, nil, {r = 244, g = 244, b = 0})
	end

	for id, entry in pairs(self.warlordlist) do
		local start = entry.StartYear
		local last = entry.LastYear
		if (start == nil or year >= start) and (last == nil or year <= last) then
			local ok_to_add = false
			for _, planet in pairs(get_value_per_era(entry.Planets, year)) do
				if self.SafePlanetTable[planet] then
					local locale = FindPlanet(planet)
					local owner = locale.Get_Owner()
					if owner == Find_Player("Warlords") or (entry.FactionOverride and owner == Find_Player(entry.FactionOverride)) or (entry.FactionOverride2 and owner == Find_Player(entry.FactionOverride2)) or (entry.FactionOverride3 and owner == Find_Player(entry.FactionOverride3)) then
						ok_to_add = true
						break
					end
				end
			end
			if ok_to_add then
				table.insert(self.optionlist, id)
			end
		end
	end

	if table.getn(self.optionlist) == 0 then
		StoryUtil.ShowScreenText("No warlord options exist on this map", 20, nil, {r = 244, g = 244, b = 0})
		GlobalValue.Set("STORYLINE", "NO_PROTEUS_START")
		GlobalValue.Set("NORANK",true)
	else
		local choices = {}
		if table.getn(self.optionlist) <= self.pagesize then
			choices = self.optionlist
		else
			choices = {"MORE"}
			for i=1,self.pagesize-1 do
				table.insert(choices, self.optionlist[i])
			end
		end
		crossplot:publish("POPUPEVENT", "WARLORD_CHOICE", choices, "WARLORD_CHOICE_OPTION")
	end
end

function WarlordStart:Choice_Chosen(choice, cosmetic)
	if choice == "WARLORD_CHOICE_MORE" then
		local optioncount = table.getn(self.optionlist)
		local endid = self.optionindex + self.pagesize - 2 --Show up to pagesize-1 ids, inclusive
		local loopback = false --flag for restart if you reach the end of the list
		if endid >= optioncount then
			endid = optioncount
			loopback = true
		end
		local choices = {"MORE"} --show current set
		for i=self.optionindex,endid do
			table.insert(choices, self.optionlist[i])
		end
		if loopback then --Move to next set, possibly going back to the start of the list
			self.optionindex = 1
		else
			self.optionindex = endid + 1
		end
		crossplot:publish("POPUPEVENT", "WARLORD_CHOICE", choices, "WARLORD_CHOICE_OPTION")
	else
		self:Populate_Chosen_Faction(choice, cosmetic)
	end
end

function WarlordStart:Populate_Chosen_Faction(choice, cosmetic)
	if cosmetic == nil then
		choice = string.gsub(choice, "WARLORD_CHOICE_", "")
	end
	local entry = self.warlordlist[choice] --Get entry data
	local year = GlobalValue.Get("GALACTIC_YEAR")
	if year == nil then
		year = 1.0
	end

	GlobalValue.Set("PROTEUS_GROUP_NAME",choice)
	GlobalValue.Set("PROTEUS_INITIAL_DISPLAY_NAME",entry.FriendlyName)
	GlobalValue.Set("PROTEUS_CURRENT_DISPLAY_NAME",entry.FriendlyName)

	crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", string.upper(self.warlord_name), entry.FriendlyName, entry.PlanetParticle)

	if choice == "KUAT" then
		crossplot:publish("PROTEUS_MARKET")
	end
	
    local initial_proteus_lock_units = require("eawx-plugins/warlord-start/ProteusLocks")
    if type(initial_proteus_lock_units) == "table" then
        UnitUtil.SetLockList(self.warlord_name, get_value_per_era(initial_proteus_lock_units, year), false)
    end
	
	if entry.LockList then
		UnitUtil.SetLockList(self.warlord_name, get_value_per_era(entry.LockList, year), false)
	end
	if entry.UnlockList then
		UnitUtil.SetLockList(self.warlord_name, get_value_per_era(entry.UnlockList, year))
	end

	if cosmetic ~= nil then
		crossplot:publish("INITIALIZE_PROTEUS_LEGITIMACY", entry.LeaderTable)
		return
	end

	if self.human_player == self.warlord_player then
		local IntroText = get_value_per_era(entry.IntroText, year, true)
		local IntroHolo = get_value_per_era(entry.IntroHolo, year, true)
		StoryUtil.Multimedia(IntroText, 15, nil, IntroHolo, 0)
	end

	if entry.RemoveList then
		for _, hero in pairs(get_value_per_era(entry.RemoveList, year)) do
			local exists = Find_All_Objects_Of_Type(hero)
			for __, object in pairs(exists) do
				UnitUtil.DespawnCompany(hero)
			end
		end
	end

	local spawncapital = true
	for _, planet in pairs(get_value_per_era(entry.Planets, year)) do
		if self.SafePlanetTable[planet] then
			local locale = FindPlanet(planet)
			local owner = locale.Get_Owner()
			if owner == Find_Player("Warlords") or (entry.FactionOverride and owner == Find_Player(entry.FactionOverride)) or (entry.FactionOverride2 and owner == Find_Player(entry.FactionOverride2)) or (entry.FactionOverride3 and owner == Find_Player(entry.FactionOverride3)) then
				ChangePlanetOwnerAndRetreatHeroes(locale, self.warlord_player, nil, 2)
				if spawncapital then
					spawncapital = false
					if entry.ShipyardCapitalOverride then
						UnitUtil.SetLockList(self.warlord_name, {self.capital}, false)
						local FactionObjects = Find_All_Objects_Of_Type(self.warlord_player)
						for _, obj in pairs(FactionObjects) do
							if obj.Get_Planet_Location() == locale then
								if string.find(obj.Get_Type().Get_Name(), "IMPERIAL_PROTEUS_SHIPYARD_LEVEL_") then
									obj.Despawn()
									break
								end
							end
						end
						self.capital = entry.ShipyardCapitalOverride
						UnitUtil.SetLockList(self.warlord_name, {self.capital})
					elseif entry.CapitalOverride then
						UnitUtil.SetLockList(self.warlord_name, {self.capital}, false)
						local FactionObjects = Find_All_Objects_Of_Type(self.warlord_player)
						for _, obj in pairs(FactionObjects) do
							if obj.Get_Planet_Location() == locale then
								if string.find(obj.Get_Type().Get_Name(), "IMPERIAL_PROTEUS_CAPITAL") then
									obj.Despawn()
									break
								end
							end
						end
						self.capital = entry.CapitalOverride
						UnitUtil.SetLockList(self.warlord_name, {self.capital})
					end
					SpawnList({self.capital},locale,self.warlord_player,true,false)
					local heroes = get_value_per_era(entry.HeroList,year)
					for __, hero in pairs(heroes) do
						local exists = Find_All_Objects_Of_Type(hero)
						if exists ~= nil then
							for ___, object in pairs(exists) do
								UnitUtil.DespawnCompany(hero)
							end
						else
							StoryUtil.ShowScreenText(hero .. " isn't real. Fix this typo", 20, nil, {r = 244, g = 244, b = 0})
						end
					end
					SpawnList(heroes,locale,self.warlord_player,true,false)
					MissionUtil.PositionCamera(locale)
				end
			end
		end
	end

	if entry.FighterHero then
		for _, pair in pairs(entry.FighterHero) do
			Set_Fighter_Hero(pair[1], pair[2])
		end
	end

	crossplot:publish("INITIALIZE_PROTEUS_LEGITIMACY", entry.LeaderTable)
	crossplot:publish("INITIALIZE_AI", "empty")
	self.warlordlist = nil
	self.human_player = nil
	self.gcid = nil

	self.warlord_name = nil
	self.warlord_player = nil
	self.capital = nil

	self.p_human = nil
	self.p_zsinj = nil
	self.SafePlanetTable = nil

	self.selectionlist = nil
	self.optionlist = nil
end

--Turns the ZSINJ_EMPIRE faction into the "Zsinj Remnants" in these scenarios:
-- 1) human starts in late era and there are ZE assets on the map (cosmetic)
-- 2) human selects ZE start in late era and there are not ZE assets on the map (planets flip, forces generate)

--if human selects non-ZE start in late era and there are no ZE assets on the map, nothing important happens
function WarlordStart:ZsinjRemnantHandler(year)
	if self.gcid == "FTGU" or self.gcid == "CUSTOM" or GlobalValue.Get("PROGRESSIVE_INFINITY") == 1 then
		return
	end

	if year < 9 then
		return
	end

	self.p_zsinj.Lock_Tech(Find_Object_Type("RANCOR_BASE"))
	self.p_zsinj.Unlock_Tech(Find_Object_Type("ZE_CAPITAL_ALTERNATE"))
	local Rancor_Base = Find_First_Object("RANCOR_BASE")
	if Rancor_Base then --RandomSpawnManager can make it appear when it shouldn't exist
		Rancor_Base.Despawn()
	end

	--if there are pre-placed Zsinj assets on the map, don't flip any planets
	if table.getn(Find_All_Objects_Of_Type(self.p_zsinj)) > 0 then
		local warlordlist = require("ProteusWarlordLibrary")
		local zsinjdata = warlordlist["ZSINJ_REMNANTS"]
		crossplot:publish("FACTION_DISPLAY_NAME_CHANGE", "ZSINJ_EMPIRE", zsinjdata.FriendlyName)
		if self.p_zsinj.Is_Human() then
			StoryUtil.Multimedia(zsinjdata.IntroText, 15, nil, zsinjdata.IntroHolo, 0)
		end

		return
	end

	if self.p_zsinj.Is_Human() ~= true then
		return
	end

	self.warlord_name = "Zsinj_Empire"
	self.warlord_player = self.p_zsinj
	self.capital = "ZE_Capital_Alternate"

	self:Populate_Chosen_Faction("ZSINJ_REMNANTS")

	--put everything back to permit selection of an AI minor warlord using the IMPERIAL_PROTEUS faction
	self.warlord_name = "Imperial_Proteus"
	self.warlord_player = Find_Player(self.warlord_name)
	self.capital = "Imperial_Proteus_Capital"
end

return WarlordStart
