-- Server Script: AbilityHandler.server.lua
-- Handles ability execution, effects, and damage dealing with detailed VFX

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Wait for remotes to be created
local RemoteEventsFolder = ReplicatedStorage:WaitForChild("JJKRemotes")

-- Load shared modules
local SharedFolder = ReplicatedStorage:WaitForChild("JJKShared")
local CharacterData = require(SharedFolder:WaitForChild("CharacterData"))
local AbilityData = require(SharedFolder:WaitForChild("AbilityData"))

-- Create remote for ability effects
local AbilityEffectEvent = Instance.new("RemoteEvent")
AbilityEffectEvent.Name = "AbilityEffect"
AbilityEffectEvent.Parent = RemoteEventsFolder

local AbilityHandler = {}

-- VFX Creation Functions

-- Create a sphere VFX
local function CreateSphereVFX(position, radius, color, duration, transparency)
	local sphere = Instance.new("Part")
	sphere.Shape = Enum.PartType.Ball
	sphere.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
	sphere.Position = position
	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.Material = Enum.Material.Neon
	sphere.Color = color
	sphere.Transparency = transparency or 0.3
	sphere.Parent = workspace
	
	-- Add glow effect
	local pointLight = Instance.new("PointLight")
	pointLight.Color = color
	pointLight.Brightness = 2
	pointLight.Range = radius * 3
	pointLight.Parent = sphere
	
	-- Expand animation
	local expandTween = TweenService:Create(sphere, TweenInfo.new(duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(radius * 4, radius * 4, radius * 4),
		Transparency = 0.8
	})
	expandTween:Play()
	
	Debris:AddItem(sphere, duration)
	return sphere
end

-- Create a beam VFX
local function CreateBeamVFX(startPos, endPos, color, width, duration)
	local beam = Instance.new("Part")
	beam.Size = Vector3.new(width, width, (startPos - endPos).Magnitude)
	beam.CFrame = CFrame.new((startPos + endPos) / 2, endPos)
	beam.Anchored = true
	beam.CanCollide = false
	beam.Material = Enum.Material.Neon
	beam.Color = color
	beam.Transparency = 0.2
	beam.Parent = workspace
	
	-- Add glow
	local pointLight = Instance.new("PointLight")
	pointLight.Color = color
	pointLight.Brightness = 3
	pointLight.Range = width * 10
	pointLight.Parent = beam
	
	-- Fade out animation
	local fadeTween = TweenService:Create(beam, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Transparency = 1
	})
	fadeTween:Play()
	
	Debris:AddItem(beam, duration)
	return beam
end

-- Create particle effects
local function CreateParticleEmitter(parent, color, rate, lifetime, speed)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Color = ColorSequence.new(color)
	emitter.Rate = rate or 50
	emitter.Lifetime = NumberRange.new(lifetime or 1)
	emitter.Speed = NumberRange.new(speed or 10)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 2),
		NumberSequenceKeypoint.new(1, 0)
	})
	emitter.Parent = parent
	
	task.delay(0.5, function()
		emitter.Enabled = false
		Debris:AddItem(emitter, lifetime + 1)
	end)
	
	return emitter
end

-- Create shockwave effect
local function CreateShockwave(position, maxRadius, color, duration)
	local shockwave = Instance.new("Part")
	shockwave.Shape = Enum.PartType.Cylinder
	shockwave.Size = Vector3.new(0.5, maxRadius * 2, maxRadius * 2)
	shockwave.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = color
	shockwave.Transparency = 0.5
	shockwave.Parent = workspace
	
	local expandTween = TweenService:Create(shockwave, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0.1, maxRadius * 4, maxRadius * 4),
		Transparency = 1
	})
	expandTween:Play()
	
	Debris:AddItem(shockwave, duration)
	return shockwave
end

-- Create domain expansion effect
local function CreateDomainExpansion(position, radius, color, duration)
	-- Create dome structure
	local dome = Instance.new("Part")
	dome.Shape = Enum.PartType.Ball
	dome.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
	dome.Position = position
	dome.Anchored = true
	dome.CanCollide = false
	dome.Material = Enum.Material.ForceField
	dome.Color = color
	dome.Transparency = 0.7
	dome.Parent = workspace
	
	-- Add internal glow
	local pointLight = Instance.new("PointLight")
	pointLight.Color = color
	pointLight.Brightness = 5
	pointLight.Range = radius * 2
	pointLight.Parent = dome
	
	-- Create barrier rings
	for i = 1, 5 do
		task.delay(i * 0.1, function()
			CreateShockwave(position, radius * 0.8, color, 2)
		end)
	end
	
	-- Expand animation
	local startSize = Vector3.new(0.1, 0.1, 0.1)
	dome.Size = startSize
	local expandTween = TweenService:Create(dome, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Size = Vector3.new(radius * 2, radius * 2, radius * 2)
	})
	expandTween:Play()
	
	-- Pulse effect
	task.spawn(function()
		for i = 1, duration * 2 do
			task.wait(0.5)
			local pulseTween = TweenService:Create(dome, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.4
			})
			pulseTween:Play()
			task.wait(0.25)
			local pulseTween2 = TweenService:Create(dome, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Transparency = 0.7
			})
			pulseTween2:Play()
		end
	end)
	
	Debris:AddItem(dome, duration)
	return dome
end

-- Character-specific VFX

-- Gojo VFX
local function GojoBlueVFX(position, target)
	-- Pull effect with blue orb
	CreateSphereVFX(target, 3, Color3.fromRGB(0, 100, 255), 1, 0.3)
	CreateParticleEmitter(workspace.Terrain, Color3.fromRGB(0, 150, 255), 100, 1, 20)
	
	-- Create pull beam
	CreateBeamVFX(position, target, Color3.fromRGB(0, 150, 255), 1, 0.8)
end

local function GojoRedVFX(position, direction)
	-- Blast effect with red sphere
	local targetPos = position + direction * 30
	CreateSphereVFX(targetPos, 5, Color3.fromRGB(255, 50, 50), 1.5, 0.2)
	CreateBeamVFX(position, targetPos, Color3.fromRGB(255, 100, 100), 2, 1)
	CreateShockwave(targetPos, 10, Color3.fromRGB(255, 50, 50), 1)
end

local function GojoHollowPurpleVFX(position, direction)
	-- Massive purple sphere with beam
	local targetPos = position + direction * 50
	CreateSphereVFX(targetPos, 10, Color3.fromRGB(150, 0, 255), 2, 0.1)
	CreateBeamVFX(position, targetPos, Color3.fromRGB(150, 0, 255), 4, 1.5)
	
	-- Multiple shockwaves
	for i = 1, 3 do
		task.delay(i * 0.3, function()
			CreateShockwave(targetPos, 20, Color3.fromRGB(150, 0, 255), 1.5)
		end)
	end
end

local function GojoInfinityVFX(position)
	-- Barrier sphere
	CreateSphereVFX(position, 8, Color3.fromRGB(100, 200, 255), 3, 0.6)
	
	-- Rotating shields
	for i = 1, 4 do
		local shield = Instance.new("Part")
		shield.Size = Vector3.new(0.5, 10, 10)
		shield.Position = position
		shield.Anchored = true
		shield.CanCollide = false
		shield.Material = Enum.Material.Neon
		shield.Color = Color3.fromRGB(100, 200, 255)
		shield.Transparency = 0.5
		shield.Parent = workspace
		
		-- Rotate shield
		task.spawn(function()
			for j = 1, 30 do
				shield.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(i * 90 + j * 12), 0) * CFrame.new(5, 0, 0)
				task.wait(0.1)
			end
			shield:Destroy()
		end)
	end
end

local function GojoUnlimitedVoidVFX(position)
	-- Domain expansion
	CreateDomainExpansion(position, 50, Color3.fromRGB(100, 150, 255), 10)
	
	-- Stars effect
	for i = 1, 50 do
		task.delay(math.random() * 2, function()
			local star = Instance.new("Part")
			star.Shape = Enum.PartType.Ball
			star.Size = Vector3.new(1, 1, 1)
			star.Position = position + Vector3.new(
				math.random(-40, 40),
				math.random(-40, 40),
				math.random(-40, 40)
			)
			star.Anchored = true
			star.CanCollide = false
			star.Material = Enum.Material.Neon
			star.Color = Color3.fromRGB(255, 255, 255)
			star.Parent = workspace
			
			Debris:AddItem(star, 8)
		end)
	end
end

-- Sukuna VFX
local function SukunaCleaveVFX(position, target)
	-- Slash effect
	for i = 1, 5 do
		task.delay(i * 0.05, function()
			local slash = Instance.new("Part")
			slash.Size = Vector3.new(0.5, 8, 1)
			slash.CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(-30, 30)), math.rad(math.random(360)), 0)
			slash.Anchored = true
			slash.CanCollide = false
			slash.Material = Enum.Material.Neon
			slash.Color = Color3.fromRGB(255, 0, 0)
			slash.Transparency = 0.3
			slash.Parent = workspace
			
			Debris:AddItem(slash, 0.5)
		end)
	end
	CreateParticleEmitter(workspace.Terrain, Color3.fromRGB(255, 0, 0), 50, 0.5, 15)
end

local function SukunaDismantleVFX(position, target)
	-- Multiple slashes
	for i = 1, 10 do
		task.delay(i * 0.03, function()
			local slash = Instance.new("Part")
			slash.Size = Vector3.new(0.3, 6, 0.5)
			slash.CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(-45, 45)), math.rad(math.random(360)), math.rad(math.random(-45, 45)))
			slash.Anchored = true
			slash.CanCollide = false
			slash.Material = Enum.Material.Neon
			slash.Color = Color3.fromRGB(200, 0, 0)
			slash.Transparency = 0.2
			slash.Parent = workspace
			
			Debris:AddItem(slash, 0.4)
		end)
	end
end

local function SukunaFlameArrowVFX(position, direction)
	-- Fire arrow
	local targetPos = position + direction * 40
	CreateBeamVFX(position, targetPos, Color3.fromRGB(255, 100, 0), 3, 1.2)
	CreateSphereVFX(targetPos, 8, Color3.fromRGB(255, 50, 0), 1.5, 0.2)
	
	-- Fire particles
	local firePart = Instance.new("Part")
	firePart.Size = Vector3.new(1, 1, 1)
	firePart.Position = targetPos
	firePart.Anchored = true
	firePart.CanCollide = false
	firePart.Transparency = 1
	firePart.Parent = workspace
	
	local fire = Instance.new("Fire")
	fire.Size = 20
	fire.Heat = 20
	fire.Parent = firePart
	
	Debris:AddItem(firePart, 2)
end

local function SukunaMalevolentShrineVFX(position)
	-- Domain expansion
	CreateDomainExpansion(position, 60, Color3.fromRGB(200, 0, 50), 12)
	
	-- Create shrine pillars
	for i = 1, 8 do
		task.delay(i * 0.2, function()
			local angle = (i / 8) * math.pi * 2
			local pillarPos = position + Vector3.new(math.cos(angle) * 40, 0, math.sin(angle) * 40)
			
			local pillar = Instance.new("Part")
			pillar.Size = Vector3.new(4, 30, 4)
			pillar.Position = pillarPos
			pillar.Anchored = true
			pillar.CanCollide = false
			pillar.Material = Enum.Material.Granite
			pillar.Color = Color3.fromRGB(100, 0, 0)
			pillar.Parent = workspace
			
			Debris:AddItem(pillar, 10)
		end)
	end
	
	-- Constant slashes in domain
	task.spawn(function()
		for i = 1, 60 do
			task.wait(0.2)
			SukunaDismantleVFX(position, position + Vector3.new(
				math.random(-50, 50),
				math.random(-20, 20),
				math.random(-50, 50)
			))
		end
	end)
end

-- Megumi VFX
local function MegumiDivineDogVFX(position, target)
	-- Shadow wolf manifestation
	CreateSphereVFX(position, 3, Color3.fromRGB(50, 0, 100), 1, 0.5)
	
	-- Shadow trail
	for i = 1, 10 do
		task.delay(i * 0.1, function()
			local trailPos = position:Lerp(target, i / 10)
			local shadow = Instance.new("Part")
			shadow.Size = Vector3.new(3, 1, 5)
			shadow.Position = trailPos
			shadow.Anchored = true
			shadow.CanCollide = false
			shadow.Material = Enum.Material.Neon
			shadow.Color = Color3.fromRGB(50, 0, 100)
			shadow.Transparency = 0.5
			shadow.Parent = workspace
			
			Debris:AddItem(shadow, 0.5)
		end)
	end
end

local function MegumiNueStrikeVFX(position, target)
	-- Lightning bird
	CreateBeamVFX(position + Vector3.new(0, 20, 0), target, Color3.fromRGB(100, 100, 255), 2, 1)
	CreateSphereVFX(target, 5, Color3.fromRGB(150, 150, 255), 1, 0.3)
	
	-- Lightning particles
	CreateParticleEmitter(workspace.Terrain, Color3.fromRGB(150, 150, 255), 80, 0.8, 25)
end

local function MegumiMaxElephantVFX(position, direction)
	-- Water wave
	local targetPos = position + direction * 25
	
	for i = 1, 5 do
		task.delay(i * 0.1, function()
			local wave = Instance.new("Part")
			wave.Size = Vector3.new(15, 8, 2)
			wave.CFrame = CFrame.new(position:Lerp(targetPos, i / 5))
			wave.Anchored = true
			wave.CanCollide = false
			wave.Material = Enum.Material.Neon
			wave.Color = Color3.fromRGB(50, 150, 255)
			wave.Transparency = 0.4
			wave.Parent = workspace
			
			Debris:AddItem(wave, 0.8)
		end)
	end
end

local function MegumiChimeraShadowGardenVFX(position)
	-- Domain expansion
	CreateDomainExpansion(position, 45, Color3.fromRGB(50, 0, 100), 10)
	
	-- Shadow creatures
	for i = 1, 20 do
		task.delay(math.random() * 3, function()
			local creaturePos = position + Vector3.new(
				math.random(-35, 35),
				0,
				math.random(-35, 35)
			)
			CreateSphereVFX(creaturePos, 2, Color3.fromRGB(75, 0, 125), 2, 0.6)
		end)
	end
end

-- Yuji VFX
local function YujiDivergentFistVFX(position, target)
	-- Impact shockwave
	CreateShockwave(target, 5, Color3.fromRGB(255, 150, 0), 0.8)
	CreateSphereVFX(target, 3, Color3.fromRGB(255, 200, 0), 0.6, 0.4)
end

local function YujiBlackFlashVFX(position, target)
	-- Black flash explosion
	CreateSphereVFX(target, 8, Color3.fromRGB(0, 0, 0), 1.5, 0.1)
	
	-- Light burst
	task.delay(0.2, function()
		CreateSphereVFX(target, 12, Color3.fromRGB(255, 255, 0), 1, 0.2)
	end)
	
	-- Shockwaves
	for i = 1, 3 do
		task.delay(i * 0.2, function()
			CreateShockwave(target, 15, Color3.fromRGB(255, 200, 0), 1)
		end)
	end
	
	-- Lightning effect
	CreateBeamVFX(target + Vector3.new(0, 10, 0), target, Color3.fromRGB(255, 255, 0), 3, 0.5)
end

-- Todo VFX
local function TodoBoogieWoogieVFX(pos1, pos2)
	-- Swap effect with clap sound visualization
	CreateSphereVFX(pos1, 4, Color3.fromRGB(255, 100, 255), 0.8, 0.4)
	CreateSphereVFX(pos2, 4, Color3.fromRGB(255, 100, 255), 0.8, 0.4)
	
	-- Connecting beam
	CreateBeamVFX(pos1, pos2, Color3.fromRGB(255, 150, 255), 2, 0.6)
end

-- Main execution function
function AbilityHandler.ExecuteAbility(player, ability, characterName, characterData)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	
	local rootPart = character.HumanoidRootPart
	local position = rootPart.Position
	local direction = rootPart.CFrame.LookVector
	
	print(string.format(
		"[JJK AbilityHandler] %s used %s from %s (Type: %s, Damage: %d)",
		player.Name,
		ability.Name,
		characterName,
		ability.Type,
		ability.Damage
	))
	
	-- Fire client event for visual effects
	AbilityEffectEvent:FireAllClients(player, ability, characterName)
	
	-- Character-specific VFX
	if characterName == "Gojo" or characterName == "GojoAdmin" then
		if ability.Name:match("Blue") then
			GojoBlueVFX(position, position + direction * 20)
		elseif ability.Name:match("Red") then
			GojoRedVFX(position, direction)
		elseif ability.Name:match("Hollow Purple") then
			GojoHollowPurpleVFX(position, direction)
		elseif ability.Name:match("Infinity") then
			GojoInfinityVFX(position)
		elseif ability.Name:match("Unlimited Void") or ability.Name:match("Infinite Void") then
			GojoUnlimitedVoidVFX(position)
		end
	elseif characterName == "Sukuna" or characterName == "SukunaAdmin" then
		if ability.Name:match("Cleave") then
			SukunaCleaveVFX(position, position + direction * 15)
		elseif ability.Name:match("Dismantle") then
			SukunaDismantleVFX(position, position + direction * 15)
		elseif ability.Name:match("Flame Arrow") or ability.Name:match("Fire") then
			SukunaFlameArrowVFX(position, direction)
		elseif ability.Name:match("Malevolent Shrine") then
			SukunaMalevolentShrineVFX(position)
		end
	elseif characterName == "Megumi" or characterName == "MegumiAdmin" then
		if ability.Name:match("Divine Dog") then
			MegumiDivineDogVFX(position, position + direction * 20)
		elseif ability.Name:match("Nue") then
			MegumiNueStrikeVFX(position, position + direction * 25)
		elseif ability.Name:match("Elephant") then
			MegumiMaxElephantVFX(position, direction)
		elseif ability.Name:match("Chimera Shadow Garden") then
			MegumiChimeraShadowGardenVFX(position)
		end
	elseif characterName == "Yuji" or characterName == "YujiAdmin" then
		if ability.Name:match("Divergent Fist") or ability.Name:match("Kick") or ability.Name:match("Barrage") then
			YujiDivergentFistVFX(position, position + direction * 10)
		elseif ability.Name:match("Black Flash") then
			YujiBlackFlashVFX(position, position + direction * 12)
		end
	elseif characterName == "Todo" or characterName == "TodoAdmin" then
		if ability.Name:match("Boogie Woogie") then
			-- Find nearest player for swap effect
			local nearestPlayer = nil
			local nearestDistance = 30
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if otherPlayer ~= player and otherPlayer.Character then
					local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
					if otherRoot then
						local distance = (rootPart.Position - otherRoot.Position).Magnitude
						if distance < nearestDistance then
							nearestDistance = distance
							nearestPlayer = otherPlayer
						end
					end
				end
			end
			
			if nearestPlayer and nearestPlayer.Character then
				local otherRoot = nearestPlayer.Character.HumanoidRootPart
				TodoBoogieWoogieVFX(rootPart.Position, otherRoot.Position)
			end
		else
			-- Generic punch effects
			YujiDivergentFistVFX(position, position + direction * 10)
		end
	end
	
	-- Damage dealing logic
	if ability.Type == "Attack" or ability.Type == "Ultimate" or ability.Type == "Domain" then
		local hitRadius = 20
		
		-- Adjust radius based on ability type
		if ability.Type == "Ultimate" then
			hitRadius = 30
		elseif ability.Type == "Domain" then
			hitRadius = 50
		end
		
		-- Check for nearby players
		for _, otherPlayer in ipairs(Players:GetPlayers()) do
			if otherPlayer ~= player then
				local otherCharacter = otherPlayer.Character
				if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
					local distance = (rootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude
					
					if distance <= hitRadius then
						local humanoid = otherCharacter:FindFirstChild("Humanoid")
						if humanoid then
							humanoid:TakeDamage(ability.Damage)
							print(string.format(
								"[JJK] %s hit %s with %s for %d damage",
								player.Name,
								otherPlayer.Name,
								ability.Name,
								ability.Damage
							))
							
							-- Hit effect on target
							CreateSphereVFX(otherCharacter.HumanoidRootPart.Position, 3, Color3.fromRGB(255, 0, 0), 0.5, 0.3)
						end
					end
				end
			end
		end
	end
	
	-- Handle defense abilities
	if ability.Type == "Defense" then
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then
				-- Create shield effect
				CreateSphereVFX(position, 6, Color3.fromRGB(100, 200, 255), 5, 0.7)
				print(string.format("[JJK] %s activated defense: %s", player.Name, ability.Name))
			end
		end
	end
	
	-- Handle mobility abilities
	if ability.Type == "Mobility" then
		-- Speed boost effect
		CreateParticleEmitter(rootPart, Color3.fromRGB(255, 255, 255), 30, 1, 15)
		print(string.format("[JJK] %s used mobility: %s", player.Name, ability.Name))
	end
	
	-- Handle buff abilities
	if ability.Type == "Buff" then
		-- Buff aura
		CreateSphereVFX(position, 5, Color3.fromRGB(255, 200, 0), 8, 0.6)
		print(string.format("[JJK] %s activated buff: %s", player.Name, ability.Name))
	end
	
	-- Handle CC abilities
	if ability.Type == "CC" then
		-- Stun effect
		CreateSphereVFX(position, 15, Color3.fromRGB(150, 0, 200), 3, 0.5)
		print(string.format("[JJK] %s used CC: %s", player.Name, ability.Name))
	end
end

print("[JJK] AbilityHandler server initialized with VFX system")

return AbilityHandler
