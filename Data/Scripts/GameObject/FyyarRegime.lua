require("PGStateMachine")
require("PGBase")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

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
        owner.Unlock_Tech(Find_Object_Type("Acclamator_I_Support"))

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
            ReplaceAtLocation("Fyyar_Doomgiver", "Fyyar_Doomgiver_Emperor")
        end
		
        Object.Despawn()
        ScriptExit()
    end
end