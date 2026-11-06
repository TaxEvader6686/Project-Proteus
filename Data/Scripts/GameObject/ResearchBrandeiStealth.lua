require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
        end

        local owner = Object.Get_Owner()
        owner.Lock_Tech(Find_Object_Type("Imperial_I_Star_Destroyer"))
        owner.Unlock_Tech(Find_Object_Type("Imperial_I_Star_Destroyer_Stealth"))

        Object.Despawn()
        ScriptExit()
    end
end