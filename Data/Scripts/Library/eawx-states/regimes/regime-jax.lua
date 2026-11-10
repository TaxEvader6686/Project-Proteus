require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")

return {
    on_enter = function(self, state_context)
        local infinity = GlobalValue.Get("PROGRESSIVE_INFINITY")
        self.leader_approach = false

        self.p_empire = Find_Player("Empire")
        self.regime_host_name = GlobalValue.Get("IMPERIAL_REGIME_HOST")
        self.p_regime_host = Find_Player(self.regime_host_name)

        self.active_planets = StoryUtil.GetSafePlanetTable()
        self.entry_time = GetCurrentTime()
        self.progress = GlobalValue.Get("PROGRESS_REGIME")

        GlobalValue.Set("REGIME_INDEX", 5)

        local imperial_table = {
            "Empire",
            "Greater_Maldrood",
            "Zsinj_Empire",
            "Eriadu_Authority",
            "Pentastar",
            "Imperial_Proteus"
        }
        for _, faction in pairs(imperial_table) do
            Find_Player(faction).Lock_Tech(Find_Object_Type("Dummy_Regicide_Jax"))
        end

        --Interim(?) edge case handling: if the regime host has no safe planets when Palpy dies. ~Mord
        if not StoryUtil.FindFriendlyPlanet(self.p_regime_host) then
            if not (infinity and self.entry_time <= 5) then
                GlobalValue.Set("GOV_EMP_DISABLE_MULTIMEDIA_HOLO", 1)
                StoryUtil.Multimedia("TEXT_CONQUEST_REGIME_JAX_EMPIRE_DEFEATED", 15, nil, "Jax_Loop", 0, nil, {r = 255, g = 255, b = 100})
                StoryUtil.SetPlanetRestricted("THE_MAW", 0)
                return
            end
        end

        Story_Event("JAX_REQUEST_COMPLETED")

        if self.p_regime_host.Is_Human() then
            StoryUtil.Multimedia("TEXT_CONQUEST_REGIME_JAX_ERA", 15, nil, "Jax_Loop", 0)
        end

        if self.entry_time <= 5 then

            StoryUtil.SetPlanetRestricted("THE_MAW", 1)

            UnitUtil.SetLockList("EMPIRE", {
                "Executor_Star_Dreadnought",
                "Eidolon",
                "Imperial_Dark_Jedi_Company",
                "PX10_Company",
                -- Historical-only units
                "Navy_Commando_Company"
            }, false)

            UnitUtil.SetLockList("EMPIRE", {
                "Delta_JV7_Group",
                "Cygnus_HQ"
            })

            if self.p_empire.Is_Human() then
                Story_Event("JAX_WELCOME")
            end

            Set_To_First_Extant_Host("WEDGE_ROGUES_LOCATION_SET", Find_Player("Rebel"), true)

        else

            if not self.p_regime_host.Is_Human() then
                StoryUtil.Multimedia("TEXT_CONQUEST_REGIME_JAX_NONPLAYER", 15, nil, nil, 0, nil, {r = 255, g = 255, b = 100})
            end

            UnitUtil.SetLockList(self.regime_host_name, {
                "Eclipse_Star_Dreadnought",
                "Sovereign_Star_Dreadnought",
                "Hunter_Killer_Probot",
                "Imperial_Chrysalide_Company",
                "Imperial_Dark_Jedi_Company",
                "Dark_Stormtrooper_Company",
                "Compforce_Assault_Company"
            }, false)

            UnitUtil.SetLockList(self.regime_host_name, {
                "Delta_JV7_Group",
                "Cygnus_HQ"
            })

            if GlobalValue.Get("PROTEUS_GROUP_NAME") == "LUMIYA" and self.regime_host_name ~= "IMPERIAL_PROTEUS" then
			    Clear_Fighter_Hero("PRAETORIAN_SQUADRON")
                UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
                    "Kile_Hannad_Location_Set"
                }, false)
            end

            UnitUtil.DespawnList{
                "Dummy_Regicide_Jax",
                "Carnor_Jax_Proteus_Team",
            }
        end

        Set_To_First_Extant_Host("TURR_PHENNIR_TIE_INTERCEPTOR_LOCATION_SET", self.p_empire, true)

        local starting_era = false
        if self.entry_time <= 5 then
            starting_era = true
        end
        self.Starting_Spawns = require("eawx-mod-icw/spawn-sets/EmpireProgressSet")
        for planet, herolist in pairs(self.Starting_Spawns["JAX"]) do
            for _, hero_table in pairs(herolist) do
                if (starting_era and infinity) or (starting_era == false and hero_table.progress == false) then
                    --this space intentionally left blank
                else
                    StoryUtil.SpawnAtSafePlanet(planet, self.regime_host_name, self.active_planets, {hero_table.object})
                end
            end
        end

        if not (starting_era and infinity) then
            local obj_banjeer = Find_First_Object("Banjeer_Quasar")

            if TestValid(obj_banjeer) then
                if self.p_regime_host == obj_banjeer.Get_Owner() then
                    UnitUtil.ReplaceAtLocation("Banjeer_Quasar", "Banjeer_Neutron")
                end
            end
        end
    end,

    on_update = function(self, state_context)
        self.current_time = GetCurrentTime() - self.entry_time
        if self.current_time >= 60 and self.leader_approach == false and self.progress == true then
            self.leader_approach = true
            if self.p_regime_host.Is_Human() then
                StoryUtil.Multimedia("TEXT_CONQUEST_REGIME_DAALA_CONTACT", 15, nil, "Daala_Loop", 0)

                local plot = Get_Story_Plot("Conquests\\Events\\EventLogRepository.xml")
                local regime_display_event = plot.Get_Event("Daala_Request_Dialog")

                regime_display_event.Add_Dialog_Text("TEXT_CAMPAIGN_EVENT_PROGRESS_DAALA_LOSS_HERO")
                for planet, herolist in pairs(self.Starting_Spawns["JAX"]) do
                    for _, hero_table in pairs(herolist) do
                        if hero_table.remove == true then
                            regime_display_event.Add_Dialog_Text("TEXT_BULLETED_LIST_ENTRY_VARIABLE", Find_Object_Type(hero_table.object))
                        end
                    end
                end
                Story_Event("DAALA_REQUEST_STARTED")
                self.p_regime_host.Unlock_Tech(Find_Object_Type("Dummy_Regicide_Daala"))
            end
        end
    end,

    --NB: on_exit cannot access self-scoped variables declared in on_enter or on_update
    on_exit = function(self, state_context)
        local Starting_Spawns = require("eawx-mod-icw/spawn-sets/EmpireProgressSet")
        local RegimeHostName = GlobalValue.Get("IMPERIAL_REGIME_HOST")
        local p_regime_host = Find_Player(RegimeHostName)

        --Despawns of Jax heroes are allowed to happen on leaving Jax because there is no progress option that allows them to remain
        for planet, herolist in pairs(Starting_Spawns["JAX"]) do
            for _, hero_table in pairs(herolist) do
                if hero_table.remove == true then
                    local target_object = Find_First_Object(hero_table.object)
                    if hero_table.override then
                        target_object = Find_First_Object(hero_table.override)
                    end
                    if TestValid(target_object) then
                        if target_object.Get_Owner() == p_regime_host then
                            target_object.Despawn()
                        end
                    end
                end
            end
        end
    end
}
