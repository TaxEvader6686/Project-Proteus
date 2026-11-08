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
        owner.Lock_Tech(Find_Object_Type("Imperial_UT_AA_Company"))
        owner.Unlock_Tech(Find_Object_Type("1L_Tank_AV_Company"))
        owner.Unlock_Tech(Find_Object_Type("1H_Tank_Company"))
        owner.Unlock_Tech(Find_Object_Type("AT_AA_Flak_Walker_Company"))
        owner.Unlock_Tech(Find_Object_Type("Tracked_Shield_Disabler_Company"))

        Object.Despawn()
        ScriptExit()
    end
end