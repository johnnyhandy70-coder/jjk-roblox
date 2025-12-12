-- Client Script: AbilityInfoPanel.client.lua
-- Creates and manages the ability info panel (K key)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for shared modules and remotes
local RemoteEventsFolder = ReplicatedStorage:WaitForChild("JJKRemotes")
local SharedFolder = ReplicatedStorage:WaitForChild("JJKShared")

local Config = require(SharedFolder:WaitForChild("Config"))
local CharacterData = require(SharedFolder:WaitForChild("CharacterData"))
local AbilityData = require(SharedFolder:WaitForChild("AbilityData"))

local GetPlayerDataFunction = RemoteEventsFolder:WaitForChild("GetPlayerData")

-- Check if player is whitelisted
if not Config.IsWhitelisted(player.Name) then
	return
end

local isAdmin = Config.IsAdmin(player.Name)

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JJKAbilityPanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Panel Frame (Left side)
local panelFrame = Instance.new("Frame")
panelFrame.Name = "PanelFrame"
panelFrame.Size = UDim2.new(0, 300, 0, 500)
panelFrame.Position = UDim2.new(0, -310, 0.5, -250) -- Start off-screen
panelFrame.AnchorPoint = Vector2.new(0, 0.5)
panelFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
panelFrame.BorderSizePixel = 2
panelFrame.BorderColor3 = Color3.fromRGB(100, 100, 150)
panelFrame.Visible = false
panelFrame.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = panelFrame

-- Panel Title
local panelTitle = Instance.new("TextLabel")
panelTitle.Name = "PanelTitle"
panelTitle.Size = UDim2.new(1, -20, 0, 40)
panelTitle.Position = UDim2.new(0, 10, 0, 10)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "Abilities"
panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
panelTitle.TextSize = 22
panelTitle.Font = Enum.Font.SourceSansBold
panelTitle.TextXAlignment = Enum.TextXAlignment.Left
panelTitle.Parent = panelFrame

-- Character Name Label
local characterLabel = Instance.new("TextLabel")
characterLabel.Name = "CharacterLabel"
characterLabel.Size = UDim2.new(1, -20, 0, 25)
characterLabel.Position = UDim2.new(0, 10, 0, 50)
characterLabel.BackgroundTransparency = 1
characterLabel.Text = "No character selected"
characterLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
characterLabel.TextSize = 14
characterLabel.Font = Enum.Font.SourceSansItalic
characterLabel.TextXAlignment = Enum.TextXAlignment.Left
characterLabel.Parent = panelFrame

-- CE Bar Background
local ceBarBg = Instance.new("Frame")
ceBarBg.Name = "CEBarBg"
ceBarBg.Size = UDim2.new(1, -20, 0, 20)
ceBarBg.Position = UDim2.new(0, 10, 0, 80)
ceBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ceBarBg.BorderSizePixel = 1
ceBarBg.BorderColor3 = Color3.fromRGB(80, 80, 120)
ceBarBg.Parent = panelFrame

local ceBarCorner = Instance.new("UICorner")
ceBarCorner.CornerRadius = UDim.new(0, 4)
ceBarCorner.Parent = ceBarBg

-- CE Bar Fill
local ceBarFill = Instance.new("Frame")
ceBarFill.Name = "CEBarFill"
ceBarFill.Size = UDim2.new(1, 0, 1, 0)
ceBarFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ceBarFill.BorderSizePixel = 0
ceBarFill.Parent = ceBarBg

local ceBarFillCorner = Instance.new("UICorner")
ceBarFillCorner.CornerRadius = UDim.new(0, 4)
ceBarFillCorner.Parent = ceBarFill

-- CE Text
local ceText = Instance.new("TextLabel")
ceText.Name = "CEText"
ceText.Size = UDim2.new(1, 0, 1, 0)
ceText.BackgroundTransparency = 1
ceText.Text = "CE: 500/500"
ceText.TextColor3 = Color3.fromRGB(255, 255, 255)
ceText.TextSize = 12
ceText.Font = Enum.Font.SourceSansBold
ceText.ZIndex = 2
ceText.Parent = ceBarBg

-- Scroll Frame for abilities
local abilityScrollFrame = Instance.new("ScrollingFrame")
abilityScrollFrame.Name = "AbilityScrollFrame"
abilityScrollFrame.Size = UDim2.new(1, -20, 1, -120)
abilityScrollFrame.Position = UDim2.new(0, 10, 0, 110)
abilityScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
abilityScrollFrame.BorderSizePixel = 1
abilityScrollFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
abilityScrollFrame.ScrollBarThickness = 6
abilityScrollFrame.Parent = panelFrame

local abilityScrollCorner = Instance.new("UICorner")
abilityScrollCorner.CornerRadius = UDim.new(0, 4)
abilityScrollCorner.Parent = abilityScrollFrame

local abilityListLayout = Instance.new("UIListLayout")
abilityListLayout.Padding = UDim.new(0, 8)
abilityListLayout.SortOrder = Enum.SortOrder.LayoutOrder
abilityListLayout.Parent = abilityScrollFrame

-- Function to create ability card
local function CreateAbilityCard(ability, index)
	local card = Instance.new("Frame")
	card.Name = "Ability" .. index
	card.Size = UDim2.new(1, -10, 0, 90)
	card.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	card.BorderSizePixel = 0
	card.LayoutOrder = index
	
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 6)
	cardCorner.Parent = card
	
	-- Ability name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(1, -10, 0, 20)
	nameLabel.Position = UDim2.new(0, 5, 0, 5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = ability.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = card
	
	-- Type badge
	local typeBadge = Instance.new("TextLabel")
	typeBadge.Name = "Type"
	typeBadge.Size = UDim2.new(0, 60, 0, 16)
	typeBadge.Position = UDim2.new(1, -65, 0, 5)
	typeBadge.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
	typeBadge.BorderSizePixel = 0
	typeBadge.Text = ability.Type
	typeBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
	typeBadge.TextSize = 10
	typeBadge.Font = Enum.Font.SourceSansBold
	typeBadge.Parent = card
	
	local typeBadgeCorner = Instance.new("UICorner")
	typeBadgeCorner.CornerRadius = UDim.new(0, 3)
	typeBadgeCorner.Parent = typeBadge
	
	-- Info text
	local infoText = Instance.new("TextLabel")
	infoText.Name = "Info"
	infoText.Size = UDim2.new(1, -10, 1, -30)
	infoText.Position = UDim2.new(0, 5, 0, 25)
	infoText.BackgroundTransparency = 1
	infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoText.TextSize = 12
	infoText.Font = Enum.Font.SourceSans
	infoText.TextXAlignment = Enum.TextXAlignment.Left
	infoText.TextYAlignment = Enum.TextYAlignment.Top
	infoText.TextWrapped = true
	infoText.Parent = card
	
	-- Format ability info
	local formattedInfo = AbilityData.FormatAbilityInfo(ability, isAdmin)
	
	local infoLines = {
		"Damage: " .. formattedInfo.Damage,
		"CE Cost: " .. formattedInfo.CECostDisplay,
		"Cooldown: " .. formattedInfo.CooldownDisplay
	}
	
	infoText.Text = table.concat(infoLines, "\n")
	
	return card
end

-- Function to update ability panel
local function UpdateAbilityPanel()
	local playerData = GetPlayerDataFunction:InvokeServer()
	
	if not playerData or not playerData.CurrentCharacter then
		characterLabel.Text = "No character selected"
		-- Clear abilities
		for _, child in ipairs(abilityScrollFrame:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		return
	end
	
	-- Get character data
	local characterData = CharacterData.GetCharacter(playerData.CurrentCharacter, playerData.IsAdmin)
	
	if characterData then
		characterLabel.Text = characterData.DisplayName
		
		-- Update CE bar
		local cePercent = playerData.CurrentCE / playerData.MaxCE
		ceBarFill.Size = UDim2.new(cePercent, 0, 1, 0)
		ceText.Text = string.format("CE: %d/%d", math.floor(playerData.CurrentCE), playerData.MaxCE)
		
		-- Clear old abilities
		for _, child in ipairs(abilityScrollFrame:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		-- Create ability cards
		for i, ability in ipairs(characterData.Abilities) do
			local card = CreateAbilityCard(ability, i)
			card.Parent = abilityScrollFrame
		end
		
		-- Update canvas size
		abilityScrollFrame.CanvasSize = UDim2.new(0, 0, 0, abilityListLayout.AbsoluteContentSize.Y + 10)
	end
end

-- Toggle panel visibility
local panelOpen = false

local function TogglePanel()
	panelOpen = not panelOpen
	panelFrame.Visible = true
	
	if panelOpen then
		-- Slide in
		panelFrame:TweenPosition(
			UDim2.new(0, 10, 0.5, -250),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.3,
			true
		)
		UpdateAbilityPanel()
	else
		-- Slide out
		panelFrame:TweenPosition(
			UDim2.new(0, -310, 0.5, -250),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.3,
			true,
			function()
				if not panelOpen then
					panelFrame.Visible = false
				end
			end
		)
	end
end

-- Handle K key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Config.Keys.OpenAbilityPanel then
		TogglePanel()
	end
end)

-- Update panel periodically when open
task.spawn(function()
	while true do
		task.wait(1)
		if panelOpen then
			UpdateAbilityPanel()
		end
	end
end)

print("[JJK GUI] Ability info panel initialized")
