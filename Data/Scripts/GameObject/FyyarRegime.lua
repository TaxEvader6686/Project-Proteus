require("PGStateMachine")
require("PGBase")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")
require("eawx-util/UnitUtil")
require("eawx-util/StoryUtil")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
            return
        end

        local owner = Object.Get_Owner()
        owner.Lock_Tech(Find_Object_Type("Lictor"))
        owner.Lock_Tech(Find_Object_Type("Trenchant"))
        owner.Unlock_Tech(Find_Object_Type("Acclamator_I_Support"))
         owner.Unlock_Tech(Find_Object_Type("Surveyor_Frigate"))       

		Set_Fighter_Research("FyyarFighters")

        local heroes = {
            "Hethrir",
            "Desann",
            "Antinnis_Tremayne",
            "Tavion_Axmis"
        }

        for _, hero in ipairs(heroes) do
            local obj = Find_First_Object(hero)
            if TestValid(obj) then
                obj.Despawn()
            end
        end

        local fyyar = Find_First_Object("Fyyar_Doomgiver")

        if TestValid(fyyar) then
            UnitUtil.ReplaceAtLocation("Fyyar_Doomgiver", "Fyyar_Doomgiver_Emperor")
        end

        local spawn_planet = Object.Get_Planet_Location()

        if TestValid(spawn_planet) then
            local new_heroes = {
                "Parnet_Team",
                "Waleran_Interrogator"
            }

            for _, hero in ipairs(new_heroes) do
                Spawn_Unit(Find_Object_Type(hero), spawn_planet, owner)
            end
        end

        if owner == Find_Player("local") then
            StoryUtil.Multimedia("TEXT_FYYAR_REGIME_COMPLETE", 15, nil, "Galak_Fyyar_Loop", 0)
        end
		
        Object.Despawn()
        ScriptExit()
    end
end