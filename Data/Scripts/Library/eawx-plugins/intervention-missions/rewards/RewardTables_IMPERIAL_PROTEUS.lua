function Get_RewardTable()
	local ProteusLibrary = require("ProteusWarlordLibrary")
	local ProteusGroup = GlobalValue.Get("PROTEUS_GROUP_NAME")
	local Proteus_RewardTables = require("eawx-plugins/intervention-missions/rewards/proteus-reward-tables/IMPERIAL_PROTEUS")
	if ProteusLibrary[ProteusGroup].CustomRewardTable then
		Proteus_RewardTables = require("eawx-plugins/intervention-missions/rewards/proteus-reward-tables/"..ProteusGroup)
	end
	return Proteus_RewardTables
end

return Get_RewardTable()