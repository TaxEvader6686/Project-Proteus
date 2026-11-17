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
		owner.Lock_Tech(Find_Object_Type("Imperial_II_Star_Destroyer"))
		
		owner.Unlock_Tech(Find_Object_Type("Aggressor_Star_Destroyer"))
		Set_Fighter_Research("NiversAggressor")
		
		Object.Despawn()
		ScriptExit()
	end
end