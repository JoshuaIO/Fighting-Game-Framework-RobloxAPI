-- variables
local TransparencyDAY = 0.75
local TransparencyNIGHT = 0.85
local Follow_World_Light = true
local SingularIntensity = true
local FirstPersonZoomLimit = 1.5 -- used to detect first person and disable shadows

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local cellShadingGui = player:WaitForChild("PlayerGui"):WaitForChild("Cell Shading")
local lightFrame = cellShadingGui:WaitForChild("Light")

script.Parent.CurrentCamera = game.Workspace.CurrentCamera

-- save the original lighting settings
local originalBrightness = game.Lighting.Brightness or 1
local originalGlobalShadows = game.Lighting.GlobalShadows
local originalAmbient = game.Lighting.Ambient or Color3.fromRGB(127, 127, 127)

-- toggle the viewport in first person
local function toggleViewportVisibility()
	local camera = game.Workspace.CurrentCamera
	local character = player.Character
	if not camera or not character then return end

	local head = character:FindFirstChild("Head")
	if not head then return end

	local zoomDistance = (camera.CFrame.Position - head.Position).Magnitude

	if zoomDistance <= FirstPersonZoomLimit then
		lightFrame.Visible = false -- hide the viewport
	else
		lightFrame.Visible = true -- show the viewport
	end
end

-- clean up old clones
local function cleanUpClones()
	for _, child in pairs(script.Parent:GetChildren()) do
		if child.Name:match("_Clone$") then
			if not child:IsA("Highlight") then 
				child:Destroy()
			end
		end
	end
end

-- add a highlight to a part
local function applyHighlight(part)
	local existingHighlight = part:FindFirstChildOfClass("Highlight")
	if not existingHighlight then
		local high = Instance.new("Highlight")
		high.Parent = part
		high.FillTransparency = 1 -- fully transparent fill
		high.OutlineTransparency = 0.85 -- make the outline subtle
		high.OutlineColor = Color3.new(0, 0, 0) -- black outline
		high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	end
end

-- clone accessories and add highlights
local function cloneAccessories(character)
	for _, accessory in pairs(character:GetChildren()) do
		if accessory:IsA("Accessory") then
			if not script.Parent:FindFirstChild(accessory.Name .. "_Clone") then
				local clonedAccessory = accessory:Clone()
				clonedAccessory.Parent = script.Parent
				clonedAccessory.Name = accessory.Name .. "_Clone"

				local handle = clonedAccessory:FindFirstChild("Handle")
				if handle then
					handle.Material = Enum.Material.SmoothPlastic
					applyHighlight(handle)
				else
					-- retry if the handle isn't immediately available
					task.defer(function()
						handle = clonedAccessory:FindFirstChild("Handle")
						if handle then
							handle.Material = Enum.Material.SmoothPlastic
							applyHighlight(handle)
						end
					end)
				end
			end
		end
	end
end

-- clone character parts and accessories
local function cloneCharacterParts(character)
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("Shirt") or part:IsA("Pants") then
			if not script.Parent:FindFirstChild(part.Name .. "_Clone") then
				local cl = part:Clone()
				cl.Parent = script.Parent
				cl.Name = part.Name .. "_Clone"

				if cl:IsA("Part") or cl:IsA("MeshPart") then
					cl.Material = Enum.Material.SmoothPlastic
				end

				applyHighlight(cl)
			end
		end
	end

	cloneAccessories(character)
end

-- sync cloned parts with the real ones
local function syncClones(character)
	for _, part in pairs(character:GetChildren()) do
		local clonedPart = script.Parent:FindFirstChild(part.Name .. "_Clone")
		if clonedPart then
			if part:IsA("Part") or part:IsA("MeshPart") then
				clonedPart.CFrame = part.CFrame
			elseif part:IsA("Accessory") then
				local originalHandle = part:FindFirstChild("Handle")
				local clonedHandle = clonedPart:FindFirstChild("Handle")
				if originalHandle and clonedHandle then
					clonedHandle.CFrame = originalHandle.CFrame
				end
			elseif part:IsA("Shirt") or part:IsA("Pants") then
				if not clonedPart:IsDescendantOf(script.Parent) then
					clonedPart:Destroy()
					local newClone = part:Clone()
					newClone.Parent = script.Parent
					newClone.Name = part.Name .. "_Clone"
				end
			end
		end
	end
end

-- handle character loading
local function onCharacterAdded(character)
	-- wait to ensure all parts are loaded
	task.wait(0.1)
	cleanUpClones()
	cloneCharacterParts(character)

	game:GetService("RunService").RenderStepped:Connect(function()
		syncClones(character)
		toggleViewportVisibility()
	end)
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
	onCharacterAdded(player.Character)
end

-- adjust lighting based on the time of day
if Follow_World_Light then
	spawn(function()
		while task.wait() do
			local sunDirection = game.Lighting:GetSunDirection()
			local moonDirection = game.Lighting:GetMoonDirection()
			local isDay = game.Lighting.ClockTime >= 6 and game.Lighting.ClockTime < 18

			if isDay then
				script.Parent.ImageTransparency = TransparencyDAY
				script.Parent.LightDirection = sunDirection * -1
			else
				script.Parent.ImageTransparency = TransparencyNIGHT
				script.Parent.LightDirection = moonDirection * -1
			end
		end
	end)
else
	script.Parent.ImageTransparency = TransparencyDAY
end

-- restore original lighting settings when the player leaves
game:GetService("Players").PlayerRemoving:Connect(function()
	game.Lighting.Brightness = originalBrightness
	game.Lighting.GlobalShadows = originalGlobalShadows
	game.Lighting.Ambient = originalAmbient
end)
