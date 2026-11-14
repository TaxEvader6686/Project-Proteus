--Duplicate of the one in SetFighterResearch, but this avoids needing to load the hero library for every standard fighter using object
function Get_Fighter_Research(rtype)
	local levels = GlobalValue.Get("FIGHTER_RESEARCH")
	if levels == nil then
		return false
	end
	for index, obj in pairs(levels) do
		if obj == rtype then
			return true
		end
	end
	return false
end

function Set_Garrison_Units(rtype)
	local levels = GlobalValue.Get("GARRISON_UNITS")
	if levels == nil then
		levels = {}
	end
	for index, obj in pairs(levels) do
		if obj == rtype then
			return
		end
	end
	table.insert(levels, rtype)
	GlobalValue.Set("GARRISON_UNITS", levels)
end

function Clear_Garrison_Units(rtype)
	local levels = GlobalValue.Get("GARRISON_UNITS")
	if levels == nil then
		return
	end
	for index, obj in pairs(levels) do
		if obj == rtype then
			table.remove(levels, index)
			GlobalValue.Set("GARRISON_UNITS", levels)
			return
		end
	end
end

function Get_Garrison_Units(rtype)
	local levels = GlobalValue.Get("GARRISON_UNITS")
	if levels == nil then
		return false
	end
	for index, obj in pairs(levels) do
		if obj == rtype then
			return true
		end
	end
	return false
end

function Check_Flags(flags, flag)
	if flags == nil then
		return false
	end
	for index, obj in pairs(flags) do
		if obj == flag then
			return true
		end
	end
	return false
end

function Double_Suffix(suffix)
	local new_suffix = ""
    if suffix == "_HALF" then
		new_suffix = ""
	end
	if suffix == "" then
		new_suffix = "_DOUBLE"
	end
	return new_suffix
end

function Halve_Suffix(suffix)
	local new_suffix = ""
    if suffix == "_DOUBLE" then
		new_suffix = ""
	end
	if suffix == "" then
		new_suffix = "_HALF"
	end
	return new_suffix
end

function HeroOverride(hero, owner)
	local test = Find_First_Object(hero)
	if TestValid(test) then
		if owner == nil then
			return true
		else
			local player = Find_Player(owner)
			if player == test.Get_Owner() then
				return true
			end
		end
	end
	return false
end

function Is_Amalgam(faction)
    if GlobalValue.Get("FACTIONAL_FIGHTERS") or faction == "INDEPENDENT_FORCES" or faction == "HOSTILE" or faction == "SSIRUUVI_IMPERIUM" or faction == "KILLIK_HIVES" or faction == "CORELLIA" then
		return true
	end
	return false
end