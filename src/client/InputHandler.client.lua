-- Client Script: InputHandler.client.lua
-- Handles input for using abilities

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Wait for shared modules and remotes
local RemoteEventsFolder = ReplicatedStorage:WaitForChild("JJKRemotes")
local SharedFolder = ReplicatedStorage:WaitForChild("JJKShared")

local Config = require(SharedFolder:WaitForChild("Config"))
local UseAbilityEvent = RemoteEventsFolder:WaitForChild("UseAbility")

-- Check if player is whitelisted
if not Config.IsWhitelisted(player.Name) then
	return
end

-- Key bindings for abilities (1-5 for regular, 1-0 for admin)
local abilityKeys = {
	Enum.KeyCode.One,
	Enum.KeyCode.Two,
	Enum.KeyCode.Three,
	Enum.KeyCode.Four,
	Enum.KeyCode.Five,
	Enum.KeyCode.Six,
	Enum.KeyCode.Seven,
	Enum.KeyCode.Eight,
	Enum.KeyCode.Nine,
	Enum.KeyCode.Zero
}

-- Handle ability usage
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Check if input is an ability key
	for i, keyCode in ipairs(abilityKeys) do
		if input.KeyCode == keyCode then
			-- Fire ability use event to server
			UseAbilityEvent:FireServer(i)
			print("[JJK Input] Pressed ability key:", i)
			break
		end
	end
end)

print("[JJK Input] Input handler initialized")
