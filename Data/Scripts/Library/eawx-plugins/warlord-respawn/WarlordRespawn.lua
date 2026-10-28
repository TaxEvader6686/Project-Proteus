require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("PGDebug")

WarlordRespawn = class()

function WarlordRespawn:new(herokilled_finished_event, human_player)
	self.human_player = human_player
	self.safe_planets = StoryUtil.GetSafePlanetTable()

	herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)
end

function WarlordRespawn:on_galactic_hero_killed(hero_name, owner, killer)
	--Logger:trace("entering WarlordRespawn:on_galactic_hero_killed")
	if hero_name == "DELVARDUS_THALASSA" then
		if not Find_First_Object("Delvardus_Night_Hammer") then
			local spawn = StoryUtil.SpawnAtSafePlanet("KAMPE", Find_Player("Eriadu_Authority"), self.safe_planets, {"Delvardus_Brilliant"}, true, false)
			if spawn then
				StoryUtil.Multimedia("TEXT_WARLORD_RETURN_DELVARDUS", 10, nil, "Delvardus_Loop", 0)
			end
		end
	elseif hero_name == "TREUTEN_13X" then
		if owner == "GREATER_MALDROOD" then
			local spawn = StoryUtil.SpawnAtSafePlanet("HAKASSI", Find_Player("Greater_Maldrood"), self.safe_planets, {"Treuten_Crimson_Sunrise"}, true, false)
			if spawn then
				StoryUtil.Multimedia("TEXT_WARLORD_RETURN_TREUTEN_TERADOC", 10, nil, "Treuten_Teradoc_Loop", 0)
			end
		end
	elseif hero_name == "TYBER_ZANN_MERCILESS" then
		if owner == "ZSINJ_EMPIRE" then
			local spawn = StoryUtil.SpawnAtSafePlanet(nil, Find_Player("Zsinj_Empire"), self.safe_planets, {"Tyber_Zann_Twilek_Dancer"}, true, false)
			if spawn then
				StoryUtil.Multimedia("TEXT_WARLORD_RETURN_TYBER_ZANN", 10, nil, "Tyber_Loop", 0)
			end
		end
	elseif hero_name == "ZSINJ_IRON_FIST_VSD" then
		if owner == "ZSINJ_EMPIRE" then
			local safe_planet = StoryUtil.FindFriendlyPlanet("Zsinj_Empire")
			if safe_planet then
				StoryUtil.Multimedia("TEXT_WARLORD_RETURN_ZSINJ", 10, nil, "Zsinj_Loop", 0)
			end
		end
	elseif hero_name == "THRAWN_GREY_WOLF" then
		if self.human_player.Get_Faction_Name() == "EMPIREOFTHEHAND" then
			local obj_parck = Find_First_Object("Parck_Strikefast")
			if TestValid(obj_parck) then
				StoryUtil.Multimedia("TEXT_THRAWN_GREY_WOLF_DEFEAT_PARCK_ALIVE", 10, nil, "Thrawn_Loop", 0)
			else
				StoryUtil.Multimedia("TEXT_THRAWN_GREY_WOLF_DEFEAT_PARCK_DEAD", 10, nil, "Thrawn_Loop", 0)
			end
		end
		UnitUtil.SetLockList("EMPIREOFTHEHAND", {"Parck_Chaf_Destroyer_Upgrade"})
	elseif hero_name == "FRAAN_GLORY" then
		if killer then
			local p_killer = Find_Player(killer)
			local spawn = StoryUtil.SpawnAtSafePlanet("NZOTH", p_killer, self.safe_planets, {"EX_F"}, true, false)
			if p_killer == self.human_player then
				StoryUtil.Multimedia("TEXT_EX_F_CAPTURE", 10, nil, "Imperial_Naval_Officer_Loop", 0)
			end
		end
	elseif hero_name == "JENN_TEAM" then
		crossplot:publish("JENN_SMEEL_DEATH", "empty")
	elseif hero_name == "JAALIB_BRANDL_PROTECTORATE_I" and killer == "REBEL" then
		crossplot:publish("JAALIB_CAPTURE", "empty")
	end
end
