-- Configuration Module for JJK Roblox System
-- Contains whitelist, admin list, and system settings

local Config = {}

-- Whitelisted users who can access the system
Config.Whitelist = {
	"02Drop",
	"donavn"
}

-- Admin users who can access admin characters
Config.Admins = {
	"02Drop",
	"donavn"
}

-- Key bindings
Config.Keys = {
	OpenAbilityPanel = Enum.KeyCode.K
}

-- Cursed Energy settings
Config.CE = {
	MaxCE = 500,
	RegenRate = 5, -- CE per second
	RegenDelay = 2 -- Seconds after ability use before regen starts
}

-- Cooldown settings
Config.Cooldowns = {
	UltimateCooldown = 50, -- Default ultimate cooldown
	AdminCooldown = 0 -- Admins have no cooldowns
}

-- Helper functions
function Config.IsWhitelisted(username)
	for _, whitelistedUser in ipairs(Config.Whitelist) do
		if whitelistedUser == username then
			return true
		end
	end
	return false
end

function Config.IsAdmin(username)
	for _, admin in ipairs(Config.Admins) do
		if admin == username then
			return true
		end
	end
	return false
end

return Config
