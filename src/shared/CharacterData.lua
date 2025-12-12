-- Character Data Module
-- Contains all character definitions for regular and admin versions

local CharacterData = {}

CharacterData.RegularCharacters = {
	Gojo = {
		Name = "Gojo",
		DisplayName = "Satoru Gojo",
		IsAdmin = false,
		Abilities = {
			{Name = "Blue (Pull)", Type = "Attack", Damage = 25, CECost = 20, Cooldown = 4},
			{Name = "Red (Blast)", Type = "Attack", Damage = 35, CECost = 25, Cooldown = 5},
			{Name = "Hollow Purple", Type = "Attack", Damage = 80, CECost = 50, Cooldown = 12},
			{Name = "Infinity", Type = "Defense", Damage = 0, CECost = 30, Cooldown = 8},
			{Name = "Unlimited Void", Type = "Ultimate", Damage = 150, CECost = 100, Cooldown = 50}
		}
	},
	
	Sukuna = {
		Name = "Sukuna",
		DisplayName = "Ryomen Sukuna",
		IsAdmin = false,
		Abilities = {
			{Name = "Cleave", Type = "Attack", Damage = 30, CECost = 20, Cooldown = 4},
			{Name = "Dismantle", Type = "Attack", Damage = 40, CECost = 25, Cooldown = 5},
			{Name = "Flame Arrow", Type = "Attack", Damage = 60, CECost = 40, Cooldown = 8},
			{Name = "Slash Barrage", Type = "Defense", Damage = 0, CECost = 30, Cooldown = 7},
			{Name = "Malevolent Shrine", Type = "Ultimate", Damage = 200, CECost = 100, Cooldown = 50}
		}
	},
	
	Megumi = {
		Name = "Megumi",
		DisplayName = "Megumi Fushiguro",
		IsAdmin = false,
		Abilities = {
			{Name = "Divine Dog", Type = "Attack", Damage = 25, CECost = 15, Cooldown = 3},
			{Name = "Nue Strike", Type = "Attack", Damage = 35, CECost = 25, Cooldown = 5},
			{Name = "Max Elephant Wave", Type = "Attack", Damage = 50, CECost = 35, Cooldown = 7},
			{Name = "Toad Pull", Type = "Defense", Damage = 0, CECost = 20, Cooldown = 6},
			{Name = "Chimera Shadow Garden", Type = "Ultimate", Damage = 120, CECost = 100, Cooldown = 50}
		}
	},
	
	Yuji = {
		Name = "Yuji",
		DisplayName = "Yuji Itadori",
		IsAdmin = false,
		Abilities = {
			{Name = "Divergent Fist", Type = "Attack", Damage = 30, CECost = 20, Cooldown = 4},
			{Name = "Kick", Type = "Attack", Damage = 20, CECost = 10, Cooldown = 2},
			{Name = "Barrage", Type = "Attack", Damage = 45, CECost = 30, Cooldown = 6},
			{Name = "Guard", Type = "Defense", Damage = 0, CECost = 15, Cooldown = 5},
			{Name = "Black Flash", Type = "Ultimate", Damage = 100, CECost = 100, Cooldown = 50}
		}
	},
	
	Todo = {
		Name = "Todo",
		DisplayName = "Aoi Todo",
		IsAdmin = false,
		Abilities = {
			{Name = "Combo", Type = "Attack", Damage = 35, CECost = 20, Cooldown = 4},
			{Name = "Counter", Type = "Attack", Damage = 40, CECost = 25, Cooldown = 5},
			{Name = "Slam", Type = "Attack", Damage = 50, CECost = 30, Cooldown = 6},
			{Name = "Boogie Woogie (Swap)", Type = "Defense", Damage = 0, CECost = 25, Cooldown = 7},
			{Name = "Brother's Bond", Type = "Ultimate", Damage = 130, CECost = 100, Cooldown = 50}
		}
	}
}

CharacterData.AdminCharacters = {
	GojoAdmin = {
		Name = "GojoAdmin",
		DisplayName = "Gojo (Admin)",
		IsAdmin = true,
		Abilities = {
			{Name = "Blue (Pull)", Type = "Attack", Damage = 50, CECost = 0, Cooldown = 0},
			{Name = "Red (Blast)", Type = "Attack", Damage = 70, CECost = 0, Cooldown = 0},
			{Name = "Hollow Purple", Type = "Attack", Damage = 160, CECost = 0, Cooldown = 0},
			{Name = "Infinity", Type = "Defense", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Unlimited Void", Type = "Ultimate", Damage = 300, CECost = 0, Cooldown = 0},
			{Name = "Reversal Red", Type = "Attack", Damage = 90, CECost = 0, Cooldown = 0},
			{Name = "Six Eyes Pulse", Type = "Attack", Damage = 100, CECost = 0, Cooldown = 0},
			{Name = "Cursed Technique Amplify", Type = "Buff", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Teleport", Type = "Mobility", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Domain: Infinite Void", Type = "Domain", Damage = 500, CECost = 0, Cooldown = 0}
		}
	},
	
	SukunaAdmin = {
		Name = "SukunaAdmin",
		DisplayName = "Sukuna (Admin)",
		IsAdmin = true,
		Abilities = {
			{Name = "Cleave", Type = "Attack", Damage = 60, CECost = 0, Cooldown = 0},
			{Name = "Dismantle", Type = "Attack", Damage = 80, CECost = 0, Cooldown = 0},
			{Name = "Flame Arrow", Type = "Attack", Damage = 120, CECost = 0, Cooldown = 0},
			{Name = "Slash Barrage", Type = "Defense", Damage = 50, CECost = 0, Cooldown = 0},
			{Name = "Malevolent Shrine", Type = "Ultimate", Damage = 400, CECost = 0, Cooldown = 0},
			{Name = "World Slash", Type = "Attack", Damage = 150, CECost = 0, Cooldown = 0},
			{Name = "Fire Meteor", Type = "Attack", Damage = 130, CECost = 0, Cooldown = 0},
			{Name = "King's Aura", Type = "Buff", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Divine Flame", Type = "Attack", Damage = 140, CECost = 0, Cooldown = 0},
			{Name = "Domain: Malevolent Shrine", Type = "Domain", Damage = 600, CECost = 0, Cooldown = 0}
		}
	},
	
	MegumiAdmin = {
		Name = "MegumiAdmin",
		DisplayName = "Megumi (Admin)",
		IsAdmin = true,
		Abilities = {
			{Name = "Divine Dog: Totality", Type = "Attack", Damage = 70, CECost = 0, Cooldown = 0},
			{Name = "Nue Strike", Type = "Attack", Damage = 70, CECost = 0, Cooldown = 0},
			{Name = "Max Elephant Tsunami", Type = "Attack", Damage = 100, CECost = 0, Cooldown = 0},
			{Name = "Toad Pull", Type = "Defense", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Chimera Shadow Garden", Type = "Ultimate", Damage = 240, CECost = 0, Cooldown = 0},
			{Name = "Rabbit Escape", Type = "Mobility", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Great Serpent", Type = "Attack", Damage = 90, CECost = 0, Cooldown = 0},
			{Name = "Shadow Possession", Type = "CC", Damage = 60, CECost = 0, Cooldown = 0},
			{Name = "Piercing Ox", Type = "Attack", Damage = 110, CECost = 0, Cooldown = 0},
			{Name = "Domain: Chimera Shadow Garden", Type = "Domain", Damage = 450, CECost = 0, Cooldown = 0}
		}
	},
	
	YujiAdmin = {
		Name = "YujiAdmin",
		DisplayName = "Yuji (Admin)",
		IsAdmin = true,
		Abilities = {
			{Name = "Divergent Fist", Type = "Attack", Damage = 60, CECost = 0, Cooldown = 0},
			{Name = "Kick", Type = "Attack", Damage = 40, CECost = 0, Cooldown = 0},
			{Name = "Barrage", Type = "Attack", Damage = 90, CECost = 0, Cooldown = 0},
			{Name = "Guard", Type = "Defense", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Black Flash", Type = "Ultimate", Damage = 200, CECost = 0, Cooldown = 0},
			{Name = "Consecutive Black Flash", Type = "Attack", Damage = 250, CECost = 0, Cooldown = 0},
			{Name = "Sukuna's Influence", Type = "Attack", Damage = 100, CECost = 0, Cooldown = 0},
			{Name = "Superhuman Speed", Type = "Mobility", Damage = 50, CECost = 0, Cooldown = 0},
			{Name = "Cursed Strike", Type = "Attack", Damage = 80, CECost = 0, Cooldown = 0},
			{Name = "Domain: Black Flash Zone", Type = "Domain", Damage = 400, CECost = 0, Cooldown = 0}
		}
	},
	
	TodoAdmin = {
		Name = "TodoAdmin",
		DisplayName = "Todo (Admin)",
		IsAdmin = true,
		Abilities = {
			{Name = "Combo", Type = "Attack", Damage = 70, CECost = 0, Cooldown = 0},
			{Name = "Counter", Type = "Attack", Damage = 80, CECost = 0, Cooldown = 0},
			{Name = "Slam", Type = "Attack", Damage = 100, CECost = 0, Cooldown = 0},
			{Name = "Boogie Woogie", Type = "Defense", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Brother's Bond", Type = "Ultimate", Damage = 260, CECost = 0, Cooldown = 0},
			{Name = "Simple Domain", Type = "Defense", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Crushing Blow", Type = "Attack", Damage = 90, CECost = 0, Cooldown = 0},
			{Name = "Clap Barrage", Type = "Attack", Damage = 120, CECost = 0, Cooldown = 0},
			{Name = "Best Friend Power", Type = "Buff", Damage = 0, CECost = 0, Cooldown = 0},
			{Name = "Domain: Boogie Wonderland", Type = "Domain", Damage = 400, CECost = 0, Cooldown = 0}
		}
	}
}

-- Helper function to get character by name
function CharacterData.GetCharacter(characterName, isAdmin)
	if isAdmin then
		return CharacterData.AdminCharacters[characterName]
	else
		return CharacterData.RegularCharacters[characterName]
	end
end

-- Get all available characters for a user
function CharacterData.GetAvailableCharacters(isAdmin)
	local characters = {}
	
	-- Add regular characters
	for name, data in pairs(CharacterData.RegularCharacters) do
		table.insert(characters, {
			Name = name,
			DisplayName = data.DisplayName,
			IsAdmin = false
		})
	end
	
	-- Add admin characters if user is admin
	if isAdmin then
		for name, data in pairs(CharacterData.AdminCharacters) do
			table.insert(characters, {
				Name = name,
				DisplayName = data.DisplayName,
				IsAdmin = true
			})
		end
	end
	
	return characters
end

return CharacterData
