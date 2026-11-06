require("PGBase")
require("PGStateMachine")
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
        end

        local owner = Object.Get_Owner()
        
        owner.Unlock_Tech(Find_Object_Type("Navy_Commando_Company"))
        owner.Unlock_Tech(Find_Object_Type("Imperial_Fleet_Commando_Company"))
		Set_Fighter_Research("BatchInfantry")
        
        Object.Despawn()
        ScriptExit()
    end
end