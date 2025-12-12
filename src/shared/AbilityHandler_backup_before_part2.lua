-- Enhanced ModuleScript: AbilityHandler.lua
-- Comprehensive VFX System for JJK Abilities (Part 1 of Enhanced System)
-- Handles ability execution with extensive visual effects, particles, and animations

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local AbilityHandler = {}

-- ==========================================
-- ADVANCED VFX CONFIGURATION
-- ==========================================

local VFXConfig = {
	ParticleQuality = "High", -- High, Medium, Low
	EnableCameraShake = true,
	EnableScreenEffects = true,
	MaxActiveEffects = 100,
	CleanupDelay = 2,
}

-- Effect tracking
local ActiveEffects = {}
local EffectCount = 0

-- ==========================================
-- UTILITY FUNCTIONS - CORE SYSTEMS
-- ==========================================

-- Advanced cleanup system
local function CleanupEffect(effect, delay)
	delay = delay or VFXConfig.CleanupDelay
	Debris:AddItem(effect, delay)
	
	-- Track effect count
	EffectCount = EffectCount + 1
	table.insert(ActiveEffects, effect)
	
	-- Auto-cleanup old effects if too many
	if EffectCount > VFXConfig.MaxActiveEffects then
		local oldEffect = table.remove(ActiveEffects, 1)
		if oldEffect and oldEffect.Parent then
			oldEffect:Destroy()
		end
		EffectCount = EffectCount - 1
	end
end

-- Create attachment with position
local function CreateAttachment(parent, position)
	local attachment = Instance.new("Attachment")
	attachment.Position = position or Vector3.new(0, 0, 0)
	attachment.Parent = parent
	return attachment
end

-- Advanced particle emitter with full control
local function CreateParticleEmitter(config)
	local emitter = Instance.new("ParticleEmitter")
	
	-- Color sequence
	if config.Colors then
		local colorKeypoints = {}
		for i, colorData in ipairs(config.Colors) do
			table.insert(colorKeypoints, ColorSequenceKeypoint.new(colorData.Time, colorData.Color))
		end
		emitter.Color = ColorSequence.new(colorKeypoints)
	else
		emitter.Color = config.Color or ColorSequence.new(Color3.new(1, 1, 1))
	end
	
	-- Size sequence
	if config.Sizes then
		local sizeKeypoints = {}
		for i, sizeData in ipairs(config.Sizes) do
			table.insert(sizeKeypoints, NumberSequenceKeypoint.new(sizeData.Time, sizeData.Size))
		end
		emitter.Size = NumberSequence.new(sizeKeypoints)
	else
		emitter.Size = config.Size or NumberSequence.new(1)
	end
	
	-- Transparency sequence
	if config.Transparencies then
		local transKeypoints = {}
		for i, transData in ipairs(config.Transparencies) do
			table.insert(transKeypoints, NumberSequenceKeypoint.new(transData.Time, transData.Transparency))
		end
		emitter.Transparency = NumberSequence.new(transKeypoints)
	else
		emitter.Transparency = config.Transparency or NumberSequence.new(0)
	end
	
	-- Basic properties
	emitter.Lifetime = config.Lifetime or NumberRange.new(1, 2)
	emitter.Rate = config.Rate or 50
	emitter.Speed = config.Speed or NumberRange.new(5, 10)
	emitter.SpreadAngle = config.SpreadAngle or Vector2.new(45, 45)
	emitter.Rotation = config.Rotation or NumberRange.new(0, 360)
	emitter.RotSpeed = config.RotSpeed or NumberRange.new(-50, 50)
	emitter.Acceleration = config.Acceleration or Vector3.new(0, 0, 0)
	emitter.Drag = config.Drag or 0
	emitter.VelocityInheritance = config.VelocityInheritance or 0
	emitter.EmissionDirection = config.EmissionDirection or Enum.NormalId.Top
	emitter.Enabled = config.Enabled ~= nil and config.Enabled or true
	emitter.LightEmission = config.LightEmission or 0.5
	emitter.LightInfluence = config.LightInfluence or 0
	emitter.ZOffset = config.ZOffset or 0
	
	-- Texture
	if config.Texture then
		emitter.Texture = config.Texture
	end
	
	return emitter
end

-- Multi-layered sphere with complex animations
local function CreateMultiLayerSphere(position, config)
	local layers = config.Layers or 4
	local baseRadius = config.Radius or 5
	local color = config.Color or Color3.new(1, 1, 1)
	local duration = config.Duration or 2
	local expansionFactor = config.ExpansionFactor or 2.5
	local parts = {}
	
	for i = 1, layers do
		local layerRadius = baseRadius * (0.5 + (i * 0.3))
		
		-- Create sphere
		local sphere = Instance.new("Part")
		sphere.Shape = Enum.PartType.Ball
		sphere.Size = Vector3.new(layerRadius, layerRadius, layerRadius)
		sphere.Position = position
		sphere.Anchored = true
		sphere.CanCollide = false
		sphere.Material = config.Material or Enum.Material.Neon
		sphere.Color = color
		sphere.Transparency = 0.2 + (i * 0.12)
		sphere.CastShadow = false
		sphere.Parent = workspace
		
		-- Advanced lighting
		local light = Instance.new("PointLight")
		light.Color = color
		light.Brightness = config.Brightness or (7 - i)
		light.Range = layerRadius * 4
		light.Shadows = false
		light.Parent = sphere
		
		-- Add surface glow
		if config.EnableSurfaceLight then
			local surfaceLight = Instance.new("SurfaceLight")
			surfaceLight.Color = color
			surfaceLight.Brightness = 3
			surfaceLight.Range = 20
			surfaceLight.Angle = 180
			surfaceLight.Face = Enum.NormalId.Top
			surfaceLight.Parent = sphere
		end
		
		-- Particle effect on sphere surface
		if config.EnableParticles then
			local particleEmitter = CreateParticleEmitter({
				Colors = {
					{Time = 0, Color = color},
					{Time = 0.5, Color = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)},
					{Time = 1, Color = color}
				},
				Sizes = {
					{Time = 0, Size = 0.5},
					{Time = 0.5, Size = 1},
					{Time = 1, Size = 0}
				},
				Transparencies = {
					{Time = 0, Transparency = 0.5},
					{Time = 1, Transparency = 1}
				},
				Rate = 50,
				Lifetime = NumberRange.new(0.5, 1),
				Speed = NumberRange.new(2, 5),
				SpreadAngle = Vector2.new(180, 180),
				LightEmission = 1
			})
			particleEmitter.Parent = sphere
			
			task.delay(duration * 0.8, function()
				particleEmitter.Enabled = false
			end)
		end
		
		-- Complex expansion animation
		local startSize = Vector3.new(layerRadius * 0.1, layerRadius * 0.1, layerRadius * 0.1)
		sphere.Size = startSize
		
		-- Phase 1: Rapid expansion
		local phase1Duration = duration * 0.3
		local phase1Size = Vector3.new(layerRadius, layerRadius, layerRadius)
		local phase1Tween = TweenService:Create(sphere,
			TweenInfo.new(phase1Duration, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
			{Size = phase1Size}
		)
		phase1Tween:Play()
		
		-- Phase 2: Pulsing
		task.delay(phase1Duration, function()
			if sphere and sphere.Parent then
				local pulseDuration = duration * 0.4
				local pulseCount = 3
				for j = 1, pulseCount do
					local pulseUp = TweenService:Create(sphere,
						TweenInfo.new(pulseDuration / (pulseCount * 2), Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
						{
							Size = phase1Size * 1.15,
							Transparency = 0.1 + (i * 0.12)
						}
					)
					pulseUp:Play()
					pulseUp.Completed:Wait()
					
					local pulseDown = TweenService:Create(sphere,
						TweenInfo.new(pulseDuration / (pulseCount * 2), Enum.EasingStyle.Sine, Enum.EasingDirection.In),
						{
							Size = phase1Size,
							Transparency = 0.2 + (i * 0.12)
						}
					)
					pulseDown:Play()
					pulseDown.Completed:Wait()
				end
			end
		end)
		
		-- Phase 3: Final expansion and fade
		task.delay(phase1Duration + (duration * 0.4), function()
			if sphere and sphere.Parent then
				local finalTween = TweenService:Create(sphere,
					TweenInfo.new(duration * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{
						Size = phase1Size * expansionFactor,
						Transparency = 1
					}
				)
				finalTween:Play()
			end
		end)
		
		-- Rotation for visual interest
		if config.EnableRotation then
			task.spawn(function()
				local rotationSpeed = 50 + (i * 10)
				local elapsed = 0
				while elapsed < duration and sphere and sphere.Parent do
					sphere.CFrame = sphere.CFrame * CFrame.Angles(0, math.rad(rotationSpeed * 0.05), 0)
					elapsed = elapsed + 0.05
					task.wait(0.05)
				end
			end)
		end
		
		table.insert(parts, sphere)
		CleanupEffect(sphere, duration + 1)
	end
	
	return parts
end

-- Advanced shockwave ring with multiple phases
local function CreateAdvancedShockwave(position, config)
	local maxRadius = config.MaxRadius or 20
	local color = config.Color or Color3.new(1, 1, 1)
	local duration = config.Duration or 1.5
	local thickness = config.Thickness or 1
	local height = config.Height or 2
	local rings = config.RingCount or 1
	local parts = {}
	
	for ringIndex = 1, rings do
		task.delay((ringIndex - 1) * (duration / (rings * 2)), function()
			-- Create ring
			local ring = Instance.new("Part")
			ring.Shape = Enum.PartType.Cylinder
			ring.Size = Vector3.new(thickness, maxRadius * 0.05, maxRadius * 0.05)
			ring.CFrame = CFrame.new(position + Vector3.new(0, height * (ringIndex - 1) * 0.3, 0)) * CFrame.Angles(0, 0, math.rad(90))
			ring.Anchored = true
			ring.CanCollide = false
			ring.Material = Enum.Material.Neon
			ring.Color = color
			ring.Transparency = 0.2
			ring.CastShadow = false
			ring.Parent = workspace
			
			-- Lighting
			local light = Instance.new("PointLight")
			light.Color = color
			light.Brightness = 5
			light.Range = maxRadius * 2
			light.Shadows = false
			light.Parent = ring
			
			-- Particle trail
			if config.EnableParticles then
				local attachment = CreateAttachment(ring, Vector3.new(0, 0, 0))
				local particleEmitter = CreateParticleEmitter({
					Color = ColorSequence.new(color),
					Sizes = {
						{Time = 0, Size = 2},
						{Time = 1, Size = 0}
					},
					Transparencies = {
						{Time = 0, Transparency = 0.3},
						{Time = 1, Transparency = 1}
					},
					Rate = 100,
					Lifetime = NumberRange.new(0.3, 0.6),
					Speed = NumberRange.new(1, 3),
					SpreadAngle = Vector2.new(30, 30),
					LightEmission = 1
				})
				particleEmitter.Parent = attachment
				
				task.delay(duration * 0.7, function()
					particleEmitter.Enabled = false
				end)
			end
			
			-- Ground distortion effect
			if config.EnableGroundEffect then
				local groundEffect = Instance.new("Part")
				groundEffect.Shape = Enum.PartType.Cylinder
				groundEffect.Size = Vector3.new(thickness * 0.3, maxRadius * 0.05, maxRadius * 0.05)
				groundEffect.CFrame = CFrame.new(position + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, math.rad(90))
				groundEffect.Anchored = true
				groundEffect.CanCollide = false
				groundEffect.Material = Enum.Material.Neon
				groundEffect.Color = color
				groundEffect.Transparency = 0.6
				groundEffect.CastShadow = false
				groundEffect.Parent = workspace
				
				-- Ground expand
				local groundTween = TweenService:Create(groundEffect,
					TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{
						Size = Vector3.new(thickness * 0.1, maxRadius * 2.2, maxRadius * 2.2),
						Transparency = 1
					}
				)
				groundTween:Play()
				
				CleanupEffect(groundEffect, duration + 0.5)
			end
			
			-- Main expansion
			local expandTween = TweenService:Create(ring,
				TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = Vector3.new(thickness * 0.2, maxRadius * 2, maxRadius * 2),
					Transparency = 1
				}
			)
			expandTween:Play()
			
			table.insert(parts, ring)
			CleanupEffect(ring, duration + 0.5)
		end)
	end
	
	return parts
end

-- ==========================================
-- GOJO VFX FUNCTIONS - DETAILED IMPLEMENTATION
-- ==========================================

-- Gojo Blue - Attraction effect with gravitational distortion
local function GojoBlueVFX(casterPosition, targetPosition)
	print("[VFX] Gojo Blue executed")
	
	-- Central blue sphere with multiple layers
	local blueConfig = {
		Radius = 6,
		Color = Color3.fromRGB(0, 100, 255),
		Duration = 2,
		Layers = 5,
		ExpansionFactor = 1.8,
		Material = Enum.Material.ForceField,
		Brightness = 8,
		EnableSurfaceLight = true,
		EnableParticles = true,
		EnableRotation = true
	}
	CreateMultiLayerSphere(targetPosition, blueConfig)
	
	-- Attraction beams from surroundings
	for i = 1, 16 do
		task.delay(i * 0.05, function()
			local angle = (i / 16) * math.pi * 2
			local distance = 25
			local startPos = targetPosition + Vector3.new(
				math.cos(angle) * distance,
				math.random(-10, 10),
				math.sin(angle) * distance
			)
			
			-- Create attraction beam
			local beam = Instance.new("Part")
			local beamLength = (startPos - targetPosition).Magnitude
			beam.Size = Vector3.new(0.8, 0.8, beamLength)
			beam.CFrame = CFrame.new((startPos + targetPosition) / 2, targetPosition)
			beam.Anchored = true
			beam.CanCollide = false
			beam.Material = Enum.Material.Neon
			beam.Color = Color3.fromRGB(50, 150, 255)
			beam.Transparency = 0.4
			beam.CastShadow = false
			beam.Parent = workspace
			
			-- Beam light
			local beamLight = Instance.new("PointLight")
			beamLight.Color = Color3.fromRGB(50, 150, 255)
			beamLight.Brightness = 4
			beamLight.Range = 15
			beamLight.Parent = beam
			
			-- Animate beam towards center
			task.spawn(function()
				for j = 1, 20 do
					if beam and beam.Parent then
						local progress = j / 20
						local currentPos = startPos:Lerp(targetPosition, progress)
						local newLength = (currentPos - targetPosition).Magnitude
						beam.Size = Vector3.new(0.8 * (1 - progress * 0.7), 0.8 * (1 - progress * 0.7), newLength)
						beam.CFrame = CFrame.new((currentPos + targetPosition) / 2, targetPosition)
						beam.Transparency = 0.4 + (progress * 0.5)
						task.wait(0.05)
					end
				end
			end)
			
			CleanupEffect(beam, 1.5)
		end)
	end
	
	-- Spiral attraction effect
	for spiralIndex = 1, 4 do
		task.delay(spiralIndex * 0.1, function()
			local spiralPart = Instance.new("Part")
			spiralPart.Size = Vector3.new(0.5, 0.5, 0.5)
			spiralPart.Position = targetPosition + Vector3.new(0, 15, 0)
			spiralPart.Anchored = true
			spiralPart.CanCollide = false
			spiralPart.Transparency = 1
			spiralPart.Parent = workspace
			
			-- Spiral particle trail
			local attachment = CreateAttachment(spiralPart)
			local spiralEmitter = CreateParticleEmitter({
				Colors = {
					{Time = 0, Color = Color3.fromRGB(100, 200, 255)},
					{Time = 0.5, Color = Color3.fromRGB(0, 150, 255)},
					{Time = 1, Color = Color3.fromRGB(0, 100, 200)}
				},
				Sizes = {
					{Time = 0, Size = 2},
					{Time = 0.5, Size = 1.5},
					{Time = 1, Size = 0}
				},
				Transparencies = {
					{Time = 0, Transparency = 0.2},
					{Time = 1, Transparency = 1}
				},
				Rate = 150,
				Lifetime = NumberRange.new(0.8, 1.2),
				Speed = NumberRange.new(0, 2),
				SpreadAngle = Vector2.new(10, 10),
				LightEmission = 1,
				Texture = "rbxasset://textures/particles/sparkles_main.dds"
			})
			spiralEmitter.Parent = attachment
			
			-- Spiral animation
			task.spawn(function()
				local height = 15
				local rotations = 5
				local steps = 60
				for step = 0, steps do
					if spiralPart and spiralPart.Parent then
						local progress = step / steps
						local angle = progress * math.pi * 2 * rotations
						local radius = 12 * (1 - progress)
						local x = math.cos(angle) * radius
						local z = math.sin(angle) * radius
						local y = height * (1 - progress)
						
						spiralPart.Position = targetPosition + Vector3.new(x, y, z)
						task.wait(0.03)
					end
				end
			end)
			
			task.delay(2, function()
				spiralEmitter.Enabled = false
			end)
			
			CleanupEffect(spiralPart, 3)
		end)
	end
	
	-- Implosion particles at center
	local implosionPart = Instance.new("Part")
	implosionPart.Size = Vector3.new(1, 1, 1)
	implosionPart.Position = targetPosition
	implosionPart.Anchored = true
	implosionPart.CanCollide = false
	implosionPart.Transparency = 1
	implosionPart.Parent = workspace
	
	local implosionEmitter = CreateParticleEmitter({
		Colors = {
			{Time = 0, Color = Color3.fromRGB(150, 220, 255)},
			{Time = 0.5, Color = Color3.fromRGB(50, 150, 255)},
			{Time = 1, Color = Color3.fromRGB(0, 100, 200)}
		},
		Sizes = {
			{Time = 0, Size = 3},
			{Time = 0.5, Size = 2},
			{Time = 1, Size = 0}
		},
		Transparencies = {
			{Time = 0, Transparency = 0.1},
			{Time = 1, Transparency = 1}
		},
		Rate = 300,
		Lifetime = NumberRange.new(0.5, 1),
		Speed = NumberRange.new(-25, -15),
		Acceleration = Vector3.new(0, -10, 0),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 1
	})
	implosionEmitter.Parent = implosionPart
	
	task.delay(1.8, function()
		implosionEmitter.Enabled = false
	end)
	
	CleanupEffect(implosionPart, 3)
	
	-- Shockwave rings
	local shockwaveConfig = {
		MaxRadius = 18,
		Color = Color3.fromRGB(0, 120, 255),
		Duration = 1.5,
		Thickness = 1.2,
		Height = 0.5,
		RingCount = 4,
		EnableParticles = true,
		EnableGroundEffect = true
	}
	CreateAdvancedShockwave(targetPosition, shockwaveConfig)
	
	-- Blue energy distortion field
	for i = 1, 8 do
		task.delay(i * 0.08, function()
			local distortionRing = Instance.new("Part")
			distortionRing.Shape = Enum.PartType.Ball
			distortionRing.Size = Vector3.new(8, 8, 8)
			distortionRing.Position = targetPosition
			distortionRing.Anchored = true
			distortionRing.CanCollide = false
			distortionRing.Material = Enum.Material.Glass
			distortionRing.Color = Color3.fromRGB(100, 200, 255)
			distortionRing.Transparency = 0.7
			distortionRing.CastShadow = false
			distortionRing.Parent = workspace
			
			-- Distortion effect
			local distortTween = TweenService:Create(distortionRing,
				TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = Vector3.new(2, 2, 2),
					Transparency = 1
				}
			)
			distortTween:Play()
			
			CleanupEffect(distortionRing, 1)
		end)
	end
end

-- Gojo Red - Repulsion blast with explosive force
local function GojoRedVFX(casterPosition, direction)
	print("[VFX] Gojo Red executed")
	local targetPosition = casterPosition + (direction * 45)
	
	-- Massive red sphere at impact
	local redConfig = {
		Radius = 10,
		Color = Color3.fromRGB(255, 50, 50),
		Duration = 2.5,
		Layers = 6,
		ExpansionFactor = 3,
		Material = Enum.Material.Neon,
		Brightness = 10,
		EnableSurfaceLight = true,
		EnableParticles = true,
		EnableRotation = false
	}
	CreateMultiLayerSphere(targetPosition, redConfig)
	
	-- Energy beam from caster to target
	for beamLayer = 1, 5 do
		task.delay(beamLayer * 0.05, function()
			local beam = Instance.new("Part")
			local beamLength = (targetPosition - casterPosition).Magnitude
			local beamWidth = 4 - (beamLayer * 0.5)
			beam.Size = Vector3.new(beamWidth, beamWidth, beamLength)
			beam.CFrame = CFrame.new((casterPosition + targetPosition) / 2, targetPosition)
			beam.Anchored = true
			beam.CanCollide = false
			beam.Material = Enum.Material.Neon
			beam.Color = Color3.fromRGB(255, 100 - (beamLayer * 10), 100 - (beamLayer * 10))
			beam.Transparency = 0.2 + (beamLayer * 0.1)
			beam.CastShadow = false
			beam.Parent = workspace
			
			-- Beam lighting
			local beamLight = Instance.new("PointLight")
			beamLight.Color = Color3.fromRGB(255, 100, 100)
			beamLight.Brightness = 8
			beamLight.Range = 25
			beamLight.Parent = beam
			
			-- Pulse animation
			task.spawn(function()
				for pulse = 1, 15 do
					if beam and beam.Parent then
						beam.Transparency = (0.2 + (beamLayer * 0.1)) + math.sin(pulse * 0.5) * 0.15
						task.wait(0.05)
					end
				end
			end)
			
			-- Fade out
			task.delay(1, function()
				if beam and beam.Parent then
					local fadeTween = TweenService:Create(beam,
						TweenInfo.new(0.5, Enum.EasingStyle.Linear),
						{Transparency = 1}
					)
					fadeTween:Play()
				end
			end)
			
			CleanupEffect(beam, 1.8)
		end)
	end
	
	-- Explosion shockwaves - multiple rings
	for ringSet = 1, 3 do
		task.delay(ringSet * 0.15, function()
			local shockConfig = {
				MaxRadius = 22 + (ringSet * 4),
				Color = Color3.fromRGB(255, 50 + (ringSet * 20), 50 + (ringSet * 20)),
				Duration = 1.8,
				Thickness = 1.5,
				Height = 1,
				RingCount = 3,
				EnableParticles = true,
				EnableGroundEffect = true
			}
			CreateAdvancedShockwave(targetPosition, shockConfig)
		end)
	end
	
	-- Fire/heat effect
	for fireIndex = 1, 12 do
		task.delay(fireIndex * 0.05, function()
			local firePart = Instance.new("Part")
			firePart.Size = Vector3.new(6, 6, 6)
			firePart.Position = targetPosition + Vector3.new(
				math.random(-8, 8),
				math.random(-5, 5),
				math.random(-8, 8)
			)
			firePart.Anchored = true
			firePart.CanCollide = false
			firePart.Transparency = 1
			firePart.Parent = workspace
			
			-- Fire instance
			local fire = Instance.new("Fire")
			fire.Size = 15
			fire.Heat = 20
			fire.Color = Color3.fromRGB(255, 100, 0)
			fire.SecondaryColor = Color3.fromRGB(200, 0, 0)
			fire.Parent = firePart
			
			task.delay(2, function()
				fire.Enabled = false
			end)
			
			CleanupEffect(firePart, 3)
		end)
	end
	
	-- Explosive particles burst
	local explosionPart = Instance.new("Part")
	explosionPart.Size = Vector3.new(1, 1, 1)
	explosionPart.Position = targetPosition
	explosionPart.Anchored = true
	explosionPart.CanCollide = false
	explosionPart.Transparency = 1
	explosionPart.Parent = workspace
	
	-- Multiple particle emitters for layered effect
	for emitterIndex = 1, 4 do
		local emitterAngle = (emitterIndex / 4) * math.pi * 2
		local attachment = CreateAttachment(explosionPart, Vector3.new(0, 0, 0))
		
		local burstEmitter = CreateParticleEmitter({
			Colors = {
				{Time = 0, Color = Color3.fromRGB(255, 200, 100)},
				{Time = 0.3, Color = Color3.fromRGB(255, 100, 50)},
				{Time = 0.7, Color = Color3.fromRGB(200, 50, 0)},
				{Time = 1, Color = Color3.fromRGB(100, 0, 0)}
			},
			Sizes = {
				{Time = 0, Size = 4},
				{Time = 0.5, Size = 3},
				{Time = 1, Size = 0}
			},
			Transparencies = {
				{Time = 0, Transparency = 0.1},
				{Time = 0.7, Transparency = 0.5},
				{Time = 1, Transparency = 1}
			},
			Rate = 200,
			Lifetime = NumberRange.new(1, 2),
			Speed = NumberRange.new(25, 40),
			Acceleration = Vector3.new(0, 5, 0),
			SpreadAngle = Vector2.new(45, 45),
			EmissionDirection = Enum.NormalId.Top,
			LightEmission = 0.8,
			Drag = 3
		})
		burstEmitter.Parent = attachment
		
		task.delay(1.5, function()
			burstEmitter.Enabled = false
		end)
	end
	
	CleanupEffect(explosionPart, 4)
	
	-- Debris/rubble effect
	for debrisIndex = 1, 20 do
		task.delay(debrisIndex * 0.02, function()
			local debris = Instance.new("Part")
			debris.Size = Vector3.new(
				math.random(1, 3),
				math.random(1, 3),
				math.random(1, 3)
			)
			debris.Position = targetPosition + Vector3.new(
				math.random(-3, 3),
				1,
				math.random(-3, 3)
			)
			debris.Anchored = false
			debris.CanCollide = true
			debris.Material = Enum.Material.Concrete
			debris.Color = Color3.fromRGB(100, 100, 100)
			debris.Parent = workspace
			
			-- Apply force
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = Vector3.new(
				math.random(-40, 40),
				math.random(20, 50),
				math.random(-40, 40)
			)
			bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
			bodyVelocity.Parent = debris
			
			task.delay(0.3, function()
				if bodyVelocity and bodyVelocity.Parent then
					bodyVelocity:Destroy()
				end
			end)
			
			CleanupEffect(debris, 4)
		end)
	end
end

-- TO BE CONTINUED IN NEXT SECTION...
-- This file will be extended with more character VFX

return AbilityHandler

-- Gojo Hollow Purple - Ultimate combination technique
local function GojoHollowPurpleVFX(casterPosition, direction)
print("[VFX] Gojo Hollow Purple executed")
local targetPosition = casterPosition + (direction * 70)

-- Charging effect at caster
local chargeConfig = {
Radius = 5,
Color = Color3.fromRGB(150, 0, 255),
Duration = 1,
Layers = 4,
ExpansionFactor = 1.5,
Material = Enum.Material.ForceField,
Brightness = 10,
EnableSurfaceLight = true,
EnableParticles = true,
EnableRotation = true
}
CreateMultiLayerSphere(casterPosition, chargeConfig)

-- Travel animation
task.spawn(function()
local travelSteps = 40
for step = 1, travelSteps do
local progress = step / travelSteps
local currentPos = casterPosition:Lerp(targetPosition, progress)

-- Purple sphere traveling
local travelSphere = Instance.new("Part")
travelSphere.Shape = Enum.PartType.Ball
travelSphere.Size = Vector3.new(12, 12, 12)
travelSphere.Position = currentPos
travelSphere.Anchored = true
travelSphere.CanCollide = false
travelSphere.Material = Enum.Material.Neon
travelSphere.Color = Color3.fromRGB(150, 0, 255)
travelSphere.Transparency = 0.3
travelSphere.CastShadow = false
travelSphere.Parent = workspace

-- Trail particles
local trailEmitter = CreateParticleEmitter({
Colors = {
{Time = 0, Color = Color3.fromRGB(200, 100, 255)},
{Time = 0.5, Color = Color3.fromRGB(150, 0, 255)},
{Time = 1, Color = Color3.fromRGB(100, 0, 200)}
},
Sizes = {
{Time = 0, Size = 3},
{Time = 1, Size = 0}
},
Transparencies = {
{Time = 0, Transparency = 0.2},
{Time = 1, Transparency = 1}
},
Rate = 100,
Lifetime = NumberRange.new(0.5, 1),
Speed = NumberRange.new(2, 5),
SpreadAngle = Vector2.new(180, 180),
LightEmission = 1
})
trailEmitter.Parent = travelSphere

CleanupEffect(travelSphere, 0.3)
task.wait(0.03)
end
end)

-- Impact explosion
task.delay(1.2, function()
-- Massive purple sphere
local impactConfig = {
Radius = 18,
Color = Color3.fromRGB(150, 0, 255),
Duration = 3,
Layers = 8,
ExpansionFactor = 3.5,
Material = Enum.Material.ForceField,
Brightness = 12,
EnableSurfaceLight = true,
EnableParticles = true,
EnableRotation = true
}
CreateMultiLayerSphere(targetPosition, impactConfig)

-- Energy distortion waves
for wave = 1, 15 do
task.delay(wave * 0.08, function()
local distortionSphere = Instance.new("Part")
distortionSphere.Shape = Enum.PartType.Ball
distortionSphere.Size = Vector3.new(15, 15, 15)
distortionSphere.Position = targetPosition
distortionSphere.Anchored = true
distortionSphere.CanCollide = false
distortionSphere.Material = Enum.Material.Glass
distortionSphere.Color = Color3.fromRGB(180, 50, 255)
distortionSphere.Transparency = 0.5
distortionSphere.CastShadow = false
distortionSphere.Parent = workspace

local distortTween = TweenService:Create(distortionSphere,
TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{
Size = Vector3.new(50, 50, 50),
Transparency = 1
}
)
distortTween:Play()

CleanupEffect(distortionSphere, 1.2)
end)
end

-- Lightning arcs
for lightning = 1, 25 do
task.delay(lightning * 0.04, function()
local startPos = targetPosition + Vector3.new(
math.random(-20, 20),
math.random(-20, 20),
math.random(-20, 20)
)
local endPos = targetPosition + Vector3.new(
math.random(-20, 20),
math.random(-20, 20),
math.random(-20, 20)
)

-- Lightning bolt
local bolt = Instance.new("Part")
local boltLength = (endPos - startPos).Magnitude
bolt.Size = Vector3.new(0.5, 0.5, boltLength)
bolt.CFrame = CFrame.new((startPos + endPos) / 2, endPos)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Material = Enum.Material.Neon
bolt.Color = Color3.fromRGB(200, 100, 255)
bolt.Transparency = 0.1
bolt.CastShadow = false
bolt.Parent = workspace

-- Flicker
task.spawn(function()
for flicker = 1, 8 do
if bolt and bolt.Parent then
bolt.Transparency = math.random(1, 4) * 0.1
task.wait(0.05)
end
end
end)

CleanupEffect(bolt, 0.6)
end)
end

-- Massive shockwaves
for shockSet = 1, 5 do
task.delay(shockSet * 0.2, function()
local megaShockConfig = {
MaxRadius = 35 + (shockSet * 5),
Color = Color3.fromRGB(150, 0, 255),
Duration = 2,
Thickness = 2,
Height = 2,
RingCount = 4,
EnableParticles = true,
EnableGroundEffect = true
}
CreateAdvancedShockwave(targetPosition, megaShockConfig)
end)
end

-- Void particles
local voidPart = Instance.new("Part")
voidPart.Size = Vector3.new(1, 1, 1)
voidPart.Position = targetPosition
voidPart.Anchored = true
voidPart.CanCollide = false
voidPart.Transparency = 1
voidPart.Parent = workspace

for emitterSet = 1, 6 do
local voidEmitter = CreateParticleEmitter({
Colors = {
{Time = 0, Color = Color3.fromRGB(200, 150, 255)},
{Time = 0.4, Color = Color3.fromRGB(150, 0, 255)},
{Time = 1, Color = Color3.fromRGB(80, 0, 180)}
},
Sizes = {
{Time = 0, Size = 5},
{Time = 0.5, Size = 3},
{Time = 1, Size = 0}
},
Transparencies = {
{Time = 0, Transparency = 0.1},
{Time = 1, Transparency = 1}
},
Rate = 250,
Lifetime = NumberRange.new(2, 3),
Speed = NumberRange.new(15, 30),
Acceleration = Vector3.new(0, 10, 0),
SpreadAngle = Vector2.new(180, 180),
LightEmission = 1,
Drag = 2
})
voidEmitter.Parent = voidPart
end

task.delay(2.5, function()
for _, child in ipairs(voidPart:GetChildren()) do
if child:IsA("ParticleEmitter") then
child.Enabled = false
end
end
end)

CleanupEffect(voidPart, 5)
end)
end

-- Gojo Infinity - Protective barrier
local function GojoInfinityVFX(casterPosition)
print("[VFX] Gojo Infinity executed")

-- Central shield sphere
local shieldConfig = {
Radius = 12,
Color = Color3.fromRGB(100, 200, 255),
Duration = 8,
Layers = 6,
ExpansionFactor = 1.2,
Material = Enum.Material.ForceField,
Brightness = 8,
EnableSurfaceLight = true,
EnableParticles = true,
EnableRotation = false
}
CreateMultiLayerSphere(casterPosition, shieldConfig)

-- Hexagonal barrier panels
for panel = 1, 12 do
local angle = (panel / 12) * math.pi * 2
local distance = 10

local barrierPanel = Instance.new("Part")
barrierPanel.Size = Vector3.new(0.5, 12, 12)
barrierPanel.CFrame = CFrame.new(casterPosition) * 
CFrame.Angles(0, angle, 0) * 
CFrame.new(distance, 0, 0) *
CFrame.Angles(0, math.rad(90), 0)
barrierPanel.Anchored = true
barrierPanel.CanCollide = false
barrierPanel.Material = Enum.Material.ForceField
barrierPanel.Color = Color3.fromRGB(120, 220, 255)
barrierPanel.Transparency = 0.4
barrierPanel.CastShadow = false
barrierPanel.Parent = workspace

-- Hexagon texture
local surfaceGui = Instance.new("SurfaceGui")
surfaceGui.Face = Enum.NormalId.Front
surfaceGui.Parent = barrierPanel

local hexFrame = Instance.new("Frame")
hexFrame.Size = UDim2.new(1, 0, 1, 0)
hexFrame.BackgroundColor3 = Color3.fromRGB(150, 230, 255)
hexFrame.BackgroundTransparency = 0.6
hexFrame.BorderSizePixel = 4
hexFrame.BorderColor3 = Color3.fromRGB(200, 240, 255)
hexFrame.Parent = surfaceGui

-- Rotation animation
task.spawn(function()
for frame = 1, 200 do
if barrierPanel and barrierPanel.Parent then
local currentAngle = angle + (frame * 0.02)
barrierPanel.CFrame = CFrame.new(casterPosition) * 
CFrame.Angles(0, currentAngle, 0) * 
CFrame.new(distance, math.sin(frame * 0.1) * 2, 0) *
CFrame.Angles(0, math.rad(90), math.sin(frame * 0.05) * 0.2)

-- Pulse transparency
hexFrame.BackgroundTransparency = 0.5 + math.sin(frame * 0.1) * 0.2
task.wait(0.04)
end
end
end)

CleanupEffect(barrierPanel, 8.5)
end

-- Orbiting particles
local orbitPart = Instance.new("Part")
orbitPart.Size = Vector3.new(1, 1, 1)
orbitPart.Position = casterPosition
orbitPart.Anchored = true
orbitPart.CanCollide = false
orbitPart.Transparency = 1
orbitPart.Parent = workspace

for orbit = 1, 5 do
local orbitEmitter = CreateParticleEmitter({
Colors = {
{Time = 0, Color = Color3.fromRGB(150, 230, 255)},
{Time = 0.5, Color = Color3.fromRGB(100, 200, 255)},
{Time = 1, Color = Color3.fromRGB(50, 150, 200)}
},
Sizes = {
{Time = 0, Size = 1.5},
{Time = 0.5, Size = 1},
{Time = 1, Size = 0}
},
Transparencies = {
{Time = 0, Transparency = 0.3},
{Time = 1, Transparency = 1}
},
Rate = 80,
Lifetime = NumberRange.new(2, 3),
Speed = NumberRange.new(18, 25),
SpreadAngle = Vector2.new(0, 360),
LightEmission = 1,
Drag = 1
})
orbitEmitter.Parent = orbitPart
end

task.delay(7.5, function()
for _, emitter in ipairs(orbitPart:GetChildren()) do
if emitter:IsA("ParticleEmitter") then
emitter.Enabled = false
end
end
end)

CleanupEffect(orbitPart, 10)

-- Ripple effects when hit
for ripple = 1, 15 do
task.delay(ripple * 0.4, function()
local ripplePos = casterPosition + Vector3.new(
math.random(-10, 10),
math.random(-10, 10),
math.random(-10, 10)
)

local rippleEffect = Instance.new("Part")
rippleEffect.Shape = Enum.PartType.Ball
rippleEffect.Size = Vector3.new(2, 2, 2)
rippleEffect.Position = ripplePos
rippleEffect.Anchored = true
rippleEffect.CanCollide = false
rippleEffect.Material = Enum.Material.Neon
rippleEffect.Color = Color3.fromRGB(150, 230, 255)
rippleEffect.Transparency = 0.3
rippleEffect.Parent = workspace

local rippleTween = TweenService:Create(rippleEffect,
TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{
Size = Vector3.new(6, 6, 6),
Transparency = 1
}
)
rippleTween:Play()

CleanupEffect(rippleEffect, 0.8)
end)
end
end

-- Gojo Unlimited Void - Domain Expansion
local function GojoUnlimitedVoidVFX(casterPosition)
print("[VFX] Gojo Unlimited Void executed")

-- Massive domain sphere
local domainRadius = 80
local domainSphere = Instance.new("Part")
domainSphere.Shape = Enum.PartType.Ball
domainSphere.Size = Vector3.new(domainRadius * 2, domainRadius * 2, domainRadius * 2)
domainSphere.Position = casterPosition
domainSphere.Anchored = true
domainSphere.CanCollide = false
domainSphere.Material = Enum.Material.ForceField
domainSphere.Color = Color3.fromRGB(100, 150, 255)
domainSphere.Transparency = 0.75
domainSphere.CastShadow = false
domainSphere.Parent = workspace

-- Domain lighting
local domainLight = Instance.new("PointLight")
domainLight.Color = Color3.fromRGB(100, 150, 255)
domainLight.Brightness = 15
domainLight.Range = domainRadius * 2
domainLight.Shadows = false
domainLight.Parent = domainSphere

-- Expansion animation
domainSphere.Size = Vector3.new(1, 1, 1)
local expandTween = TweenService:Create(domainSphere,
TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
{Size = Vector3.new(domainRadius * 2, domainRadius * 2, domainRadius * 2)}
)
expandTween:Play()

-- Barrier formation rings
for ring = 1, 12 do
task.delay(ring * 0.12, function()
local barrierConfig = {
MaxRadius = domainRadius * 0.95,
Color = Color3.fromRGB(120, 170, 255),
Duration = 2,
Thickness = 2,
Height = 1,
RingCount = 2,
EnableParticles = true,
EnableGroundEffect = false
}
CreateAdvancedShockwave(casterPosition, barrierConfig)
end)
end

-- Star field - hundreds of stars
for star = 1, 150 do
task.delay(math.random() * 2, function()
local starAngle1 = math.random() * math.pi * 2
local starAngle2 = math.random() * math.pi
local starDist = math.random(20, domainRadius - 10)

local starPos = casterPosition + Vector3.new(
math.cos(starAngle1) * math.sin(starAngle2) * starDist,
math.cos(starAngle2) * starDist,
math.sin(starAngle1) * math.sin(starAngle2) * starDist
)

local starPart = Instance.new("Part")
starPart.Shape = Enum.PartType.Ball
starPart.Size = Vector3.new(
math.random(3, 12) / 10,
math.random(3, 12) / 10,
math.random(3, 12) / 10
)
starPart.Position = starPos
starPart.Anchored = true
starPart.CanCollide = false
starPart.Material = Enum.Material.Neon
starPart.Color = Color3.new(1, 1, 1)
starPart.Transparency = 0
starPart.CastShadow = false
starPart.Parent = workspace

-- Star light
local starLight = Instance.new("PointLight")
starLight.Color = Color3.new(1, 1, 1)
starLight.Brightness = 6
starLight.Range = 25
starLight.Parent = starPart

-- Twinkle animation
task.spawn(function()
for twinkle = 1, 150 do
if starPart and starPart.Parent then
starPart.Transparency = 0.2 + math.sin(twinkle * 0.2 + star) * 0.3
local scale = 0.8 + math.sin(twinkle * 0.15 + star) * 0.3
starPart.Size = Vector3.new(scale, scale, scale)
task.wait(0.08)
end
end
end)

CleanupEffect(starPart, 15)
end)
end

-- Floating eyes
for eye = 1, 30 do
task.delay(eye * 0.2, function()
local eyeAngle1 = (eye / 30) * math.pi * 2
local eyeAngle2 = math.random() * math.pi
local eyeDist = math.random(30, 60)

local eyePos = casterPosition + Vector3.new(
math.cos(eyeAngle1) * math.sin(eyeAngle2) * eyeDist,
math.cos(eyeAngle2) * eyeDist,
math.sin(eyeAngle1) * math.sin(eyeAngle2) * eyeDist
)

-- Eye sphere
local eyePart = Instance.new("Part")
eyePart.Shape = Enum.PartType.Ball
eyePart.Size = Vector3.new(4, 4, 4)
eyePart.Position = eyePos
eyePart.Anchored = true
eyePart.CanCollide = false
eyePart.Material = Enum.Material.Neon
eyePart.Color = Color3.fromRGB(0, 150, 255)
eyePart.Transparency = 0.3
eyePart.Parent = workspace

-- Pupil
local pupil = Instance.new("Part")
pupil.Shape = Enum.PartType.Ball
pupil.Size = Vector3.new(1.5, 1.5, 1.5)
pupil.Position = eyePos
pupil.Anchored = true
pupil.CanCollide = false
pupil.Material = Enum.Material.Neon
pupil.Color = Color3.new(0, 0, 0)
pupil.Parent = workspace

-- Eye glow
local eyeGlow = Instance.new("PointLight")
eyeGlow.Color = Color3.fromRGB(0, 150, 255)
eyeGlow.Brightness = 4
eyeGlow.Range = 20
eyeGlow.Parent = eyePart

-- Float animation
task.spawn(function()
for float = 1, 140 do
if eyePart and eyePart.Parent and pupil and pupil.Parent then
local floatOffset = Vector3.new(
math.sin(float * 0.05 + eye) * 3,
math.cos(float * 0.08 + eye) * 3,
math.sin(float * 0.06 + eye) * 3
)
eyePart.Position = eyePos + floatOffset
pupil.Position = eyePart.Position

-- Blink effect
if float % 40 == 0 then
eyePart.Transparency = 0.8
task.wait(0.1)
eyePart.Transparency = 0.3
end

task.wait(0.08)
end
end
end)

CleanupEffect(eyePart, 14)
CleanupEffect(pupil, 14)
end)
end

-- Information overload particles
local infoPart = Instance.new("Part")
infoPart.Size = Vector3.new(1, 1, 1)
infoPart.Position = casterPosition
infoPart.Anchored = true
infoPart.CanCollide = false
infoPart.Transparency = 1
infoPart.Parent = workspace

for infoEmitter = 1, 10 do
local particleEmitter = CreateParticleEmitter({
Colors = {
{Time = 0, Color = Color3.fromRGB(150, 200, 255)},
{Time = 0.3, Color = Color3.fromRGB(100, 150, 255)},
{Time = 0.7, Color = Color3.fromRGB(200, 230, 255)},
{Time = 1, Color = Color3.new(1, 1, 1)}
},
Sizes = {
{Time = 0, Size = 0.8},
{Time = 0.5, Size = 2},
{Time = 1, Size = 0}
},
Transparencies = {
{Time = 0, Transparency = 0.4},
{Time = 1, Transparency = 1}
},
Rate = 60,
Lifetime = NumberRange.new(6, 9),
Speed = NumberRange.new(5, 12),
SpreadAngle = Vector2.new(180, 180),
LightEmission = 1,
Drag = 0.5
})
particleEmitter.Parent = infoPart
end

task.delay(14, function()
for _, emitter in ipairs(infoPart:GetChildren()) do
if emitter:IsA("ParticleEmitter") then
emitter.Enabled = false
end
end
end)

CleanupEffect(infoPart, 18)
CleanupEffect(domainSphere, 16)
end

-- ==========================================
-- SUKUNA VFX FUNCTIONS - DETAILED IMPLEMENTATION
-- ==========================================

-- Sukuna Cleave - Precision slashes
local function SukunaCleaveVFX(casterPosition, targetPosition)
print("[VFX] Sukuna Cleave executed")

-- Multiple slash marks
for slash = 1, 12 do
task.delay(slash * 0.06, function()
local slashPart = Instance.new("Part")
slashPart.Size = Vector3.new(1.5, 15, 2)
slashPart.CFrame = CFrame.new(targetPosition) * 
CFrame.Angles(
math.rad(math.random(-45, 45)),
math.rad(math.random(0, 360)),
math.rad(math.random(-30, 30))
)
slashPart.Anchored = true
slashPart.CanCollide = false
slashPart.Material = Enum.Material.Neon
slashPart.Color = Color3.fromRGB(255, 0, 0)
slashPart.Transparency = 0.15
slashPart.CastShadow = false
slashPart.Parent = workspace

-- Slash glow
local slashLight = Instance.new("PointLight")
slashLight.Color = Color3.fromRGB(255, 0, 0)
slashLight.Brightness = 6
slashLight.Range = 25
slashLight.Parent = slashPart

-- Trail effect
local attachment0 = CreateAttachment(slashPart, Vector3.new(0, slashPart.Size.Y/2, 0))
local attachment1 = CreateAttachment(slashPart, Vector3.new(0, -slashPart.Size.Y/2, 0))

local trail = Instance.new("Trail")
trail.Attachment0 = attachment0
trail.Attachment1 = attachment1
trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
trail.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.2),
NumberSequenceKeypoint.new(1, 1)
})
trail.Lifetime = 0.4
trail.LightEmission = 1
trail.Parent = slashPart

-- Fade animation
local fadeTween = TweenService:Create(slashPart,
TweenInfo.new(0.7, Enum.EasingStyle.Linear),
{Transparency = 1}
)
fadeTween:Play()

CleanupEffect(slashPart, 0.9)
end)
end

-- Blood spray particles
local bloodPart = Instance.new("Part")
bloodPart.Size = Vector3.new(1, 1, 1)
bloodPart.Position = targetPosition
bloodPart.Anchored = true
bloodPart.CanCollide = false
bloodPart.Transparency = 1
bloodPart.Parent = workspace

for bloodSpray = 1, 5 do
local bloodEmitter = CreateParticleEmitter({
Colors = {
{Time = 0, Color = Color3.fromRGB(255, 0, 0)},
{Time = 0.5, Color = Color3.fromRGB(180, 0, 0)},
{Time = 1, Color = Color3.fromRGB(100, 0, 0)}
},
Sizes = {
{Time = 0, Size = 1.5},
{Time = 0.5, Size = 1},
{Time = 1, Size = 0.3}
},
Transparencies = {
{Time = 0, Transparency = 0.1},
{Time = 1, Transparency = 1}
},
Rate = 200,
Lifetime = NumberRange.new(0.6, 1.2),
Speed = NumberRange.new(15, 25),
SpreadAngle = Vector2.new(180, 180),
LightEmission = 0.3,
Drag = 5,
Acceleration = Vector3.new(0, -20, 0)
})
bloodEmitter.Parent = bloodPart
end

task.delay(1, function()
for _, emitter in ipairs(bloodPart:GetChildren()) do
if emitter:IsA("ParticleEmitter") then
emitter.Enabled = false
end
end
end)

CleanupEffect(bloodPart, 3)

-- Impact shockwave
local impactConfig = {
MaxRadius = 12,
Color = Color3.fromRGB(200, 0, 0),
Duration = 0.8,
Thickness = 0.8,
Height = 0.5,
RingCount = 2,
EnableParticles = true,
EnableGroundEffect = true
}
CreateAdvancedShockwave(targetPosition, impactConfig)
end


-- ==========================================
-- SUKUNA: DISMANTLE VFX - PART 2
-- ==========================================
local function CreateDismantleVFX(attackerPos, targetPosition)
-- Rapid succession of slashes (10 slashes)
for i = 1, 10 do
task.spawn(function()
task.wait(i * 0.08) -- Very rapid succession

-- Create slash mark
local slash = Instance.new("Part")
slash.Size = Vector3.new(5, 0.3, 0.8)
slash.CFrame = CFrame.new(targetPosition) * CFrame.Angles(
math.rad(math.random(-45, 45)),
math.rad(math.random(-180, 180)),
math.rad(math.random(-30, 30))
) * CFrame.new(math.random(-4, 4), math.random(-3, 3), math.random(-2, 2))
slash.Anchored = true
slash.CanCollide = false
slash.Material = Enum.Material.Neon
slash.Color = Color3.fromRGB(255, 50, 50)
slash.Transparency = 0.3
slash.Parent = workspace

-- Slash glow
local light = Instance.new("PointLight")
light.Color = Color3.fromRGB(255, 50, 50)
light.Brightness = 5
light.Range = 12
light.Parent = slash

-- Slash trail effect
local trail = Instance.new("Part")
trail.Size = Vector3.new(0.3, 0.3, 6)
trail.CFrame = slash.CFrame * CFrame.new(0, 0, 3)
trail.Anchored = true
trail.CanCollide = false
trail.Material = Enum.Material.Neon
trail.Color = Color3.fromRGB(255, 100, 100)
trail.Transparency = 0.5
trail.Parent = workspace

-- Animate slash appearance
local slashTween = TweenService:Create(slash, TweenInfo.new(0.15), {
Transparency = 0,
Size = Vector3.new(6, 0.4, 1)
})
slashTween:Play()

-- Animate slash disappearance
task.wait(0.2)
local fadeTween = TweenService:Create(slash, TweenInfo.new(0.4), {
Transparency = 1,
Size = Vector3.new(7, 0.2, 0.5)
})
fadeTween:Play()

-- Fade trail
TweenService:Create(trail, TweenInfo.new(0.3), {Transparency = 1}):Play()

CleanupEffect(slash, 0.8)
CleanupEffect(trail, 0.5)
end)
end

-- Cut particles (multiple emitters)
for i = 1, 6 do
task.spawn(function()
task.wait(i * 0.15)

local cutPart = Instance.new("Part")
cutPart.Size = Vector3.new(1, 1, 1)
cutPart.Position = targetPosition + Vector3.new(
math.random(-3, 3),
math.random(-2, 2),
math.random(-3, 3)
)
cutPart.Anchored = true
cutPart.CanCollide = false
cutPart.Transparency = 1
cutPart.Parent = workspace

local cutConfig = {
Lifetime = NumberRange.new(0.3, 0.6),
Rate = 200,
Speed = NumberRange.new(10, 25),
SpreadAngle = Vector2.new(180, 180),
Colors = {
{Time = 0, Color = Color3.fromRGB(255, 255, 255)},
{Time = 0.5, Color = Color3.fromRGB(200, 50, 50)},
{Time = 1, Color = Color3.fromRGB(150, 0, 0)}
},
Sizes = {
{Time = 0, Size = 0.3},
{Time = 0.5, Size = 0.8},
{Time = 1, Size = 0.1}
},
Transparencies = {
{Time = 0, Transparency = 0.3},
{Time = 1, Transparency = 1}
}
}

local emitter = CreateParticleEmitter(cutConfig)
emitter.Parent = cutPart
emitter.Enabled = true

task.wait(0.4)
emitter.Enabled = false
CleanupEffect(cutPart, 1)
end)
end

-- Shockwave clusters
for i = 1, 4 do
task.spawn(function()
task.wait(i * 0.25)
local shockConfig = {
MaxRadius = 8 + i * 2,
Color = Color3.fromRGB(255, 80, 80),
Duration = 0.5,
Thickness = 0.5,
Height = 0.3,
RingCount = 1,
EnableParticles = true
}
CreateAdvancedShockwave(targetPosition, shockConfig)
end)
end
end

return AbilityHandler
