-- Client Script: CharacterSelectGUI.client.lua
-- Creates and manages the character selection GUI

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

local SelectCharacterEvent = RemoteEventsFolder:WaitForChild("SelectCharacter")
local GetPlayerDataFunction = RemoteEventsFolder:WaitForChild("GetPlayerData")

-- Check if player is whitelisted
if not Config.IsWhitelisted(player.Name) then
	warn("[JJK GUI] Player not whitelisted")
	return
end

local isAdmin = Config.IsAdmin(player.Name)

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JJKCharacterSelect"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame (Top-left scroll menu)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 150)
mainFrame.Parent = screenGui

-- Add corner rounding
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "JJK Characters"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -55)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
scrollFrame.BorderSizePixel = 1
scrollFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 4)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- Function to create a section header
local function CreateSectionHeader(text, layoutOrder)
	local header = Instance.new("TextLabel")
	header.Name = text .. "Header"
	header.Size = UDim2.new(1, -10, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	header.BorderSizePixel = 0
	header.Text = text
	header.TextColor3 = Color3.fromRGB(200, 200, 255)
	header.TextSize = 16
	header.Font = Enum.Font.SourceSansBold
	header.LayoutOrder = layoutOrder
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 4)
	headerCorner.Parent = header
	
	return header
end

-- Function to create a character button
local function CreateCharacterButton(characterName, displayName, layoutOrder)
	local button = Instance.new("TextButton")
	button.Name = characterName .. "Button"
	button.Size = UDim2.new(1, -10, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	button.BorderSizePixel = 0
	button.Text = displayName
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.Font = Enum.Font.SourceSans
	button.LayoutOrder = layoutOrder
	button.AutoButtonColor = true
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 4)
	buttonCorner.Parent = button
	
	-- Hover effect
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	end)
	
	-- Click handler
	button.MouseButton1Click:Connect(function()
		SelectCharacterEvent:FireServer(characterName)
		print("[JJK GUI] Selected character:", displayName)
		
		-- Visual feedback (non-blocking)
		task.spawn(function()
			button.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
			task.wait(0.2)
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
		end)
	end)
	
	return button
end

-- Add Regular Characters section
local regularHeader = CreateSectionHeader("Regular Characters", 1)
regularHeader.Parent = scrollFrame

local layoutOrder = 2
for name, data in pairs(CharacterData.RegularCharacters) do
	local button = CreateCharacterButton(name, data.DisplayName, layoutOrder)
	button.Parent = scrollFrame
	layoutOrder = layoutOrder + 1
end

-- Add Admin Characters section (only for admins)
if isAdmin then
	local adminHeader = CreateSectionHeader("Admin Characters", layoutOrder)
	adminHeader.Parent = scrollFrame
	layoutOrder = layoutOrder + 1
	
	for name, data in pairs(CharacterData.AdminCharacters) do
		local button = CreateCharacterButton(name, data.DisplayName, layoutOrder)
		button.Parent = scrollFrame
		layoutOrder = layoutOrder + 1
	end
end

-- Update canvas size
local function UpdateCanvasSize()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
UpdateCanvasSize()

print("[JJK GUI] Character selection GUI initialized for", player.Name, "(Admin:", tostring(isAdmin) .. ")")
