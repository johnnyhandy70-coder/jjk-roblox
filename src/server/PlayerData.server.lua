-- Server Script: PlayerData.server.lua
-- Handles player data, CE management, and cooldowns

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create remote events and functions
local RemoteEventsFolder = Instance.new("Folder")
RemoteEventsFolder.Name = "JJKRemotes"
RemoteEventsFolder.Parent = ReplicatedStorage

local SelectCharacterEvent = Instance.new("RemoteEvent")
SelectCharacterEvent.Name = "SelectCharacter"
SelectCharacterEvent.Parent = RemoteEventsFolder

local UseAbilityEvent = Instance.new("RemoteEvent")
UseAbilityEvent.Name = "UseAbility"
UseAbilityEvent.Parent = RemoteEventsFolder

local GetPlayerDataFunction = Instance.new("RemoteFunction")
GetPlayerDataFunction.Name = "GetPlayerData"
GetPlayerDataFunction.Parent = RemoteEventsFolder

local GetAbilityInfoFunction = Instance.new("RemoteFunction")
GetAbilityInfoFunction.Name = "GetAbilityInfo"
GetAbilityInfoFunction.Parent = RemoteEventsFolder

local AbilityEffectEvent = Instance.new("RemoteEvent")
AbilityEffectEvent.Name = "AbilityEffect"
AbilityEffectEvent.Parent = RemoteEventsFolder

-- Load shared modules
local SharedFolder = ReplicatedStorage:WaitForChild("JJKShared", 10)
if not SharedFolder then
	error("[JJK ERROR] Cannot find 'JJKShared' folder in ReplicatedStorage. Please create it and add the required ModuleScripts. See INSTALLATION.md for setup instructions.")
end

local Config = require(SharedFolder:WaitForChild("Config", 5))
local CharacterData = require(SharedFolder:WaitForChild("CharacterData", 5))
local AbilityData = require(SharedFolder:WaitForChild("AbilityData", 5))

-- Load AbilityHandler with error handling
local AbilityHandler
local abilityHandlerModule = SharedFolder:WaitForChild("AbilityHandler", 5)
if abilityHandlerModule then
	local success, result = pcall(function()
		return require(abilityHandlerModule)
	end)
	if success then
		AbilityHandler = result
		print("[JJK] AbilityHandler loaded successfully")
	else
		warn("[JJK ERROR] Failed to load AbilityHandler:", result)
		warn("[JJK] Abilities will not have visual effects. Check that AbilityHandler is a ModuleScript in ReplicatedStorage/JJKShared")
	end
else
	warn("[JJK ERROR] AbilityHandler module not found in ReplicatedStorage/JJKShared")
	warn("[JJK] Please create a ModuleScript named 'AbilityHandler' in ReplicatedStorage/JJKShared")
	warn("[JJK] Copy code from src/shared/AbilityHandler.lua")
	warn("[JJK] Abilities will work but without visual effects")
end

-- Player data storage
local PlayerDataStore = {}

-- Initialize player data
local function InitializePlayerData(player)
	local username = player.Name
	
	-- Check if player is whitelisted
	if not Config.IsWhitelisted(username) then
		return nil
	end
	
	local isAdmin = Config.IsAdmin(username)
	
	PlayerDataStore[player.UserId] = {
		Player = player,
		Username = username,
		IsAdmin = isAdmin,
		IsWhitelisted = true,
		CurrentCharacter = nil,
		CurrentCE = Config.CE.MaxCE,
		MaxCE = Config.CE.MaxCE,
		Cooldowns = {}, -- [abilityIndex] = timeRemaining
		LastAbilityUse = 0
	}
	
	return PlayerDataStore[player.UserId]
end

-- Get player data
local function GetPlayerData(player)
	return PlayerDataStore[player.UserId]
end

-- Update CE regeneration
local function UpdateCERegeneration()
	while true do
		task.wait(1) -- Update every second
		
		for userId, data in pairs(PlayerDataStore) do
			if data.CurrentCE < data.MaxCE then
				-- Check if enough time has passed since last ability use
				local timeSinceLastUse = os.clock() - data.LastAbilityUse
				if timeSinceLastUse >= Config.CE.RegenDelay then
					data.CurrentCE = math.min(data.CurrentCE + Config.CE.RegenRate, data.MaxCE)
				end
			end
			
			-- Update cooldowns
			for abilityIndex, cooldownEnd in pairs(data.Cooldowns) do
				if os.clock() >= cooldownEnd then
					data.Cooldowns[abilityIndex] = nil
				end
			end
		end
	end
end

-- Handle character selection
SelectCharacterEvent.OnServerEvent:Connect(function(player, characterName)
	local playerData = GetPlayerData(player)
	if not playerData then
		return
	end
	
	-- Get character data
	local characterData = CharacterData.GetCharacter(characterName, playerData.IsAdmin)
	
	if characterData then
		playerData.CurrentCharacter = characterName
		playerData.Cooldowns = {} -- Reset cooldowns on character change
		
		print(string.format("[JJK] %s selected character: %s", player.Name, characterData.DisplayName))
	end
end)

-- Handle ability usage
UseAbilityEvent.OnServerEvent:Connect(function(player, abilityIndex)
	local playerData = GetPlayerData(player)
	if not playerData or not playerData.CurrentCharacter then
		return
	end
	
	-- Get character and ability data
	local characterData = CharacterData.GetCharacter(playerData.CurrentCharacter, playerData.IsAdmin)
	local ability = AbilityData.GetAbility(characterData, abilityIndex)
	
	if not ability then
		return
	end
	
	-- Check if ability can be used
	local cooldownRemaining = 0
	if playerData.Cooldowns[abilityIndex] then
		cooldownRemaining = playerData.Cooldowns[abilityIndex] - os.clock()
		if cooldownRemaining < 0 then
			cooldownRemaining = 0
			playerData.Cooldowns[abilityIndex] = nil
		end
	end
	
	local canUse, reason = AbilityData.CanUseAbility(
		playerData.CurrentCE,
		ability,
		cooldownRemaining,
		playerData.IsAdmin
	)
	
	if not canUse then
		warn(string.format("[JJK] %s cannot use %s: %s", player.Name, ability.Name, reason))
		return
	end
	
	-- Use ability
	if not playerData.IsAdmin then
		playerData.CurrentCE = playerData.CurrentCE - ability.CECost
		playerData.Cooldowns[abilityIndex] = os.clock() + ability.Cooldown
		playerData.LastAbilityUse = os.clock()
	end
	
	print(string.format("[JJK] %s used %s (Damage: %d)", player.Name, ability.Name, ability.Damage))
	
	-- Execute ability through AbilityHandler if available
	if AbilityHandler and AbilityHandler.ExecuteAbility then
		AbilityHandler.ExecuteAbility(player, ability, playerData.CurrentCharacter, characterData)
	else
		warn("[JJK] AbilityHandler not loaded - ability used without VFX")
	end
end)

-- Get player data function
GetPlayerDataFunction.OnServerInvoke = function(player)
	local playerData = GetPlayerData(player)
	if not playerData then
		return nil
	end
	
	return {
		IsWhitelisted = playerData.IsWhitelisted,
		IsAdmin = playerData.IsAdmin,
		CurrentCharacter = playerData.CurrentCharacter,
		CurrentCE = playerData.CurrentCE,
		MaxCE = playerData.MaxCE,
		Cooldowns = playerData.Cooldowns
	}
end

-- Get ability info function
GetAbilityInfoFunction.OnServerInvoke = function(player, characterName, abilityIndex)
	local playerData = GetPlayerData(player)
	if not playerData then
		return nil
	end
	
	local characterData = CharacterData.GetCharacter(characterName, playerData.IsAdmin)
	local ability = AbilityData.GetAbility(characterData, abilityIndex)
	
	if not ability then
		return nil
	end
	
	return AbilityData.FormatAbilityInfo(ability, playerData.IsAdmin)
end

-- Player joined
Players.PlayerAdded:Connect(function(player)
	local playerData = InitializePlayerData(player)
	if playerData then
		print(string.format("[JJK] Player %s joined (Admin: %s)", player.Name, tostring(playerData.IsAdmin)))
	else
		print(string.format("[JJK] Player %s is not whitelisted", player.Name))
	end
end)

-- Player leaving
Players.PlayerRemoving:Connect(function(player)
	PlayerDataStore[player.UserId] = nil
end)

-- Initialize existing players
for _, player in ipairs(Players:GetPlayers()) do
	InitializePlayerData(player)
end

-- Start CE regeneration loop
task.spawn(UpdateCERegeneration)

print("[JJK] PlayerData server initialized")
