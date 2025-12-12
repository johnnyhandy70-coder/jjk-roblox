-- Ability Data Module
-- Handles ability information and management

local AbilityData = {}

-- Ability type descriptions
AbilityData.TypeDescriptions = {
	Attack = "Offensive ability that deals damage",
	Defense = "Defensive ability for protection",
	Ultimate = "Powerful ultimate ability",
	Buff = "Enhances your stats",
	Mobility = "Movement ability",
	CC = "Crowd control ability",
	Domain = "Domain Expansion"
}

-- Format ability info for display
function AbilityData.FormatAbilityInfo(ability, isAdmin)
	local info = {}
	
	info.Name = ability.Name
	info.Type = ability.Type
	info.TypeDescription = AbilityData.TypeDescriptions[ability.Type] or "Special ability"
	info.Damage = ability.Damage
	
	-- Format CE Cost
	if isAdmin then
		info.CECost = 0
		info.CECostDisplay = "0 (Admin)"
	else
		info.CECost = ability.CECost
		info.CECostDisplay = tostring(ability.CECost)
	end
	
	-- Format Cooldown
	if isAdmin then
		info.Cooldown = 0
		info.CooldownDisplay = "None (Admin)"
	else
		info.Cooldown = ability.Cooldown
		if ability.Cooldown >= 60 then
			local minutes = math.floor(ability.Cooldown / 60)
			local seconds = ability.Cooldown % 60
			if seconds > 0 then
				info.CooldownDisplay = string.format("%dm %ds", minutes, seconds)
			else
				info.CooldownDisplay = string.format("%dm", minutes)
			end
		else
			info.CooldownDisplay = string.format("%ds", ability.Cooldown)
		end
	end
	
	return info
end

-- Get ability by index from character
function AbilityData.GetAbility(characterData, abilityIndex)
	if characterData and characterData.Abilities then
		return characterData.Abilities[abilityIndex]
	end
	return nil
end

-- Validate ability usage
function AbilityData.CanUseAbility(currentCE, ability, cooldownRemaining, isAdmin)
	-- Admins can always use abilities
	if isAdmin then
		return true, "Ready"
	end
	
	-- Check cooldown
	if cooldownRemaining > 0 then
		return false, string.format("Cooldown: %.1fs", cooldownRemaining)
	end
	
	-- Check CE cost
	if currentCE < ability.CECost then
		return false, string.format("Need %d CE", ability.CECost - currentCE)
	end
	
	return true, "Ready"
end

return AbilityData
