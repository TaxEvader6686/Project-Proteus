require("PGStateMachine")
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

		Set_Fighter_Research("BrakFighters")
		
        Object.Despawn()
        ScriptExit()
    end
end