local animationList = require(script.Parent.Animations)
local playerSample = game.Players.LocalPlayer
local Main = {
	-----------------------------------------------------------
	-- Character State Value
	-----------------------------------------------------------
	activeState = playerSample.CharacterSample.CharacterState.ActiveState,
	hitboxLocation =  playerSample.CharacterSample.CharacterState.HitboxLocation,
	hitboxTime =  playerSample.CharacterSample.CharacterState.HitboxTime,
	hitstun =  playerSample.CharacterSample.CharacterState.Hitstun,
	hurtboxLocation =  playerSample.CharacterSample.CharacterState.HurtboxLocation,
	knockdown =  playerSample.CharacterSample.CharacterState.Knockdown,
	isCrouching =  playerSample.CharacterSample.CharacterState.isCrouching,
	isDashing =  playerSample.CharacterSample.CharacterState.isDashing,
	isGuarding =  playerSample.CharacterSample.CharacterState.isGuarding,
	hitstunDuration = playerSample.CharacterSample.CharacterState.HitstunDuration,
	--------------------------------------------------------------
	-- Generics
	--------------------------------------------------------------
	player = game.Players.LocalPlayer,
	char= game.Players.LocalPlayer.Character,
	humanoid = game.Players.LocalPlayer.Character.Humanoid,
	
}

local event = game.ReplicatedStorage.Events.MainAction
local eventClient = game.ReplicatedStorage.Events.MainActionClient
local HelperModule = require(game.ReplicatedStorage.CharacterScripts.HelperTable)
local runService = game:GetService("RunService")
local collisionGroupPlayer = "PlayerCollision"
local collisionGroupHitPlayer = "HitPlayerCollision"
local collisionRayGroup = "RayGroup"
local connector
--local HitboxTable = HelperModule.hitboxTable
local debounce = false
function Main.BodyVelocity(parent, object)--force, direction, waitTime)--(parent,table)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.humanoid:SetStateEnabled(humanStateFalling, false)
	local bodyVelocity = Instance.new("BodyVelocity")
	print(parent)
	print(object.force)
	print(object.direction)
	print(object.waitTime)
	bodyVelocity.Parent = parent
	bodyVelocity.MaxForce = object.force--Force
	bodyVelocity.Velocity = object.knockback --Direction
	wait(object.duration)--Wait
	bodyVelocity:Destroy()
	
end

function Main.Knockdown()--Values need to be passed
	if debounce == false and Main.char:FindFirstChild("Hurtbox") then
		debounce = true
	Main.humanoid.WalkSpeed = 0
	Main.humanoid.JumpPower = 0
	local check = "serverCheck"
	event:FireServer(check)
	
	local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.falldown)
	animPlay:Play()
	wait(0.05)
	animPlay = Main.humanoid.Animator:LoadAnimation(animationList.knockdown)
	animPlay:Play()
	Main.char.Hurtbox:Destroy()
	wait(2)
	animPlay:Stop()
	debounce=false
	Main.Recovery()
	end
end

function Main.Hitstun(object)--duration,knockback,force)--table --Values need to be passed
	Main.humanoid.WalkSpeed = 0
	Main.humanoid.JumpPower = 0
	Main.humanoid.AutoRotate = false
	local check = "serverCheck"
	event:FireServer(check)
	local randomAnimSelect = math.random(1,2)

	print(object.duration)
	if (object.victimHumanoidRootPart ~= nil) then
		object.victimHumanoidRootPart.CFrame = CFrame.lookAt(object.victimHumanoidRootPart.Position, object.attackerHumanoidRootPart.Position)
	end
	if randomAnimSelect == 1 then 
		local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.hitstun1)
		animPlay:Play()
		print(object.duration)
		animPlay:AdjustSpeed(object.duration/2)
		Main.BodyVelocity(Main.char.HumanoidRootPart,object)--force,knockback,duration)
		wait(1)
		animPlay:AdjustSpeed(1)
		wait(Main.hitstunDuration.Value)
	else
		local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.hitstun2)
		animPlay:Play()
		animPlay:AdjustSpeed(object.duration/2)
		Main.BodyVelocity(Main.char.HumanoidRootPart,object)--force,knockback,duration)
		wait(1)
		animPlay:AdjustSpeed(1)
		wait(Main.hitstunDuration.Value)
	end
	
	Main.humanoid.WalkSpeed = 25
    Main.humanoid.JumpPower = 70
	Main.humanoid.AutoRotate = true

end


function Main.Dash()--Values need to be passed
	local physicsLocation = Main.char.HumanoidRootPart
	local check = "serverCheck"
	local object = HelperModule.hitboxTable
	object.force = Vector3.new(math.huge,math.huge,math.huge)
	object.knockback = physicsLocation.CFrame.LookVector.Unit *60
	object.duration = 0.5
	event:FireServer(Main.player,check)
	if debounce == false then
		debounce = true
		local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.dash)
		animPlay:Play()
		Main.BodyVelocity(physicsLocation,object)
		debounce = false
	end
		
		
end

function Main.Recovery()
	Main.humanoid.WalkSpeed = 25
	Main.humanoid.JumpPower = 60
	Main.humanoid.AutoRotate = true
	Main.CreateHurtbox()
end

function Main.Guarding()
	local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.guard)
	if Main.isGuarding.Value == false then
		Main.isGuarding.Value = true
		local count = 0
		repeat 
			animPlay:Play()
			Main.humanoid.WalkSpeed = 0
			Main.humanoid.JumpPower = 0
			Main.humanoid.AutoRotate = false
			wait(0.03)
		until Main.isGuarding.Value == false
		Main.humanoid.WalkSpeed = 25
		Main.humanoid.JumpPower = 70
		Main.humanoid.AutoRotate = true
	animPlay:Stop()
	end
		
end

function Main.CollisionSetter(item,collisionGroup)
	--item is the model that will be searched through
	--collision Group will be set to this
	local humanList = item:GetChildren()
	for index=1,#humanList,1 do
		if humanList[index]:isA("BasePart") then
			humanList[index].CollisionGroup = collisionGroup
		end
	
	end
--	print(item)
--	print(#item)
end

function Main.CreateHurtbox(hitboxTable)--Pass Hurtbox Location
	Main.hurtboxLocation.Value = Main.char.HumanoidRootPart.Position
	--local msg = "newHurtbox"
	--	event:FireServer(hitboxTable)
end

function Main.CreateHitbox(hitboxTable)--areaLocation,damage,hitstunDuration, hitboxTime,size, knockback,force,humanoidAttacker)--Pass Hitbox Location
	local debounce = false
	local debounce2 = false
	print(hitboxTable)

	local newTest = hitboxTable.location
	print(newTest)
	--print(hitstunDuration)
	Main.hitboxLocation.Value = newTest.CFrame
--	hitboxTime = (1/60) 
	Main.hitboxTime.Value = hitboxTable.hitboxTime
	if debounce == false then
		debounce = true
		local hitbox = Instance.new("Part")
		hitbox.Transparency = 0.6
		hitbox.Parent = hitboxTable.location.Parent--Main.char
		print(hitbox.Parent)
		hitbox.Name = "Hitbox"
		hitbox.Color = Color3.fromRGB(255, 20, 20)
		hitbox.CanCollide = false
		hitbox.Massless = true
		hitbox.Size = hitboxTable.size
		hitbox.CFrame = Main.hitboxLocation.Value
		hitbox.Orientation = newTest.Orientation
		debounce = true
		local weld = Instance.new("WeldConstraint")
		weld.Archivable = true
		weld.Name = "hitboxWeld"
		weld.Parent = hitbox
		weld.Part0 = hitboxTable.location
		weld.Part1 = hitbox
		
		hitbox.Touched:Connect(function(victimPlayer)

			local victim = victimPlayer.Parent
			local playersX = game.Players
			local humanoidVictim = victimPlayer.Parent:FindFirstChild("Humanoid")
			local humanoidVictimHead = victimPlayer.Parent:FindFirstChild("Head")
			local humanoidVictimHRP = victimPlayer.Parent:FindFirstChild("HumanoidRootPart")
			
			if victim ~= hitbox.Parent and debounce2 == false and humanoidVictim ~= hitboxTable.attackerHumanoid then 
				print("Touched!!!!")
				debounce2= true
				hitboxTable.victim = victim
				hitboxTable.victimHumanoid = humanoidVictim
				print(hitboxTable.victim)
				local victimPlayerLoad = playersX:GetPlayerFromCharacter(victim)
		
				hitboxTable.victimPlayer = victimPlayerLoad
				hitboxTable.victimHumanoidRootPart = humanoidVictimHRP
				print(hitboxTable.victimHumanoidRootPart)
				print(humanoidVictim)
				--local playerInPlayers = game.Players:GetPlayerFromCharacter(victimPlayer.Parent)
				--event:FireServer(humanoidVictim, "hitbox",playerInPlayers,hitboxTable.damage, hitboxTable.duration, hitboxTable.knockback, hitboxTable.force)--damage,hitstunDuration,knockback,force)--table
				event:FireServer(humanoidVictim,hitboxTable)
		end-- pass more
		end)
		wait(Main.hitboxTime.Value)
		hitbox:Destroy()
		debounce = false
		debounce2 = false
	end	
end

function Main.MagnitudeHitbox(hitboxTable)
	local list = game.Workspace:GetChildren()
	for index=1,#list,1 do
		if list[index]:FindFirstChild("HumanoidRootPart") then
			if (hitboxTable.attackerHumanoidRootPart.Position - list[index]:FindFirstChild("HumanoidRootPart").Position).Magnitude < hitboxTable.magnitudeRange then
				if list[index]:FindFirstChild("Humanoid") then
					--hitboxTable.victim[index]
					local playerFound = game.Players:GetPlayerFromCharacter(list[index])
				
					if playerFound ~= Main.player then
						hitboxTable.victim=list[index]
						hitboxTable.victimHumanoid=list[index]:FindFirstChild("Humanoid")
						hitboxTable.victimHumanoidRootPart =list[index]:FindFirstChild("HumanoidRootPart")
						hitboxTable.victimPlayer=playerFound
						event:FireServer(hitboxTable)
					end
					
				end
			end
		end
		
	end
end

function Main.BoundingRayBox(hitboxTable)
	local validation  = hitboxTable.validation
	local hitbox = Instance.new("Part")
	local count =0
	hitbox.Transparency = 0.6
	hitbox.Parent = hitboxTable.location.Parent--Main.char
	--print(hitbox.Parent)
	hitbox.Name = "Hitbox"
	hitbox.Color = Color3.fromRGB(255, 20, 20)
	hitbox.CanCollide = false
	hitbox.Massless = true
	hitbox.Size = hitboxTable.size
	local newTest = hitboxTable.location
	Main.hitboxLocation.Value = newTest.CFrame
	hitbox.CFrame = Main.hitboxLocation.Value
	hitbox.Orientation = newTest.Orientation
	local validator = Instance.new("Part")
	validator.Transparency = 0.7
	validator.Parent = hitboxTable.validLocation
	validator.CFrame = hitboxTable.cframe
	validator.Size = hitboxTable.validSize
	validator.CanCollide = false
	validator.Massless = true
	local direction = validator.CFrame.LookVector * 60
	
	debounce = true
	local weld = Instance.new("WeldConstraint")
	local weld2 = Instance.new("WeldConstraint")
	weld.Archivable = true
	weld.Name = "hitboxWeld"
	weld.Parent = hitbox
	weld.Part0 = hitboxTable.location
	weld.Part1 = hitbox
	weld2.Name = "validWeld"
	weld2.Parent = validator
	weld2.Part0 = validator
	weld2.Part1 = hitbox
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {hitboxTable.location,hitbox,validator, hitboxTable.attacker,hitboxTable.location,hitboxTable.location.Parent,Main.char}

	connector = runService.Heartbeat:Connect(function()
		if count < hitboxTable.hitboxTime then
			local area = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size,params)
			if area then
				local enemyList = {}
				local enemySubjectList = {}
				for index=1,#area, 1 do
					local human = area[index].Parent
					local humanoid = human:FindFirstChild("Humanoid")
					if humanoid then
						
						if not enemyList[humanoid] then
							local rayOrign = validator
							local raycastParams = RaycastParams.new()
							raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
							raycastParams.CollisionGroup = "RayGroup"
							enemyList[humanoid] = true
							
							raycastParams.FilterDescendantsInstances = {hitbox,validator,hitboxTable.attacker,hitboxTable.location}
							--validation = false
							if validation == true then
								local rayCast = workspace:Blockcast(validator.CFrame,validator.Size,direction,raycastParams)
								wait(0.02)
								if rayCast then
									if rayCast.Instance.Parent == human  then 
										local head = human:FindFirstChild("HumanoidRootPart")
										hitboxTable.victim = human
										hitboxTable.victimHumanoid = humanoid
										hitboxTable.victimHumanoidRootPart = head
										local victimPlayer = game.Players
										
										print(human)
										hitboxTable.victimPlayer = victimPlayer:GetPlayerFromCharacter(human)
										print(hitboxTable.victimPlayer)
										local att1 = Instance.new("Attachment")
										att1.Name = "Att1"
										att1.Parent = validator
										att1.WorldPosition =validator.Position
										att1.Visible = true
										local att2 = Instance.new("Attachment")
										att2.Name = "Att2"
										att2.Parent = validator
										att2.WorldPosition = rayCast.Position
										att2.Visible = true
										local beam = Instance.new("Beam")
										beam.Parent =validator
										beam.Color = ColorSequence.new(Color3.new(1, 0.027451, 0.027451),Color3.new(1, 0.862745, 0.172549))
										beam.Attachment0 = att1
										beam.Attachment1 = att2
										beam.Width0 = 0.3
										beam.Width1 = 0.3 
										beam.Segments = 12
										local playerHit = rayCast.Instance.Parent:FindFirstChild("Humanoid")
										if playerHit and head.Color ~= Color3.fromRGB(255,0,0) then
												head.Color = Color3.fromRGB(255,0,0)
												event:FireServer(hitboxTable)
												Main.CollisionSetter(human, collisionGroupHitPlayer)
												wait(hitboxTable.hitboxTime+0.2)
												Main.CollisionSetter(human, collisionGroupPlayer)
												head.Color = Color3.fromRGB(255, 255, 255)
											--	hitbox:Destroy()
										--		validator:Destroy()
												
												
										end
									end
								end
							else
								local head = human:FindFirstChild("HumanoidRootPart")
								hitboxTable.victim = human
								hitboxTable.victimHumanoid = humanoid
								hitboxTable.victimHumanoidRootPart = head
								local victimPlayer = game.Players

								print(human)
								hitboxTable.victimPlayer = victimPlayer:GetPlayerFromCharacter(human)
								event:FireServer(hitboxTable)
							end
						end
					end
				end
				
				count+=1
			else
				count=0
				connector:Disconnect()
			end

		end
	end)
	
	wait(hitboxTable.hitboxTime)
	hitbox:Destroy()
	validator:Destroy()
end
		

function Main.ClientCalls(object)--msg,duration,knockback,force)--(msg, table)
	local waitTime = 0.5
	if object.msg == "hit" then
		print(object.msg)
	--	print(duration)
		--print(knockback)
		--print(force)
		local newThread = coroutine.create(Main.Hitstun)
		coroutine.resume(newThread,object)--duration,knockback,force)
		--Main.Hitstun(duration,knockback,force)
	end
	
end

function Main.newClientTouch(object)--location,damage,hitDuration,hitboxTime,size,knockback,force, humanoidAttacker,msg,projectileTravelSpeed)--table
	print(object)
	--print(location)
	--print(damage)
	--print(hitDuration)
	if object.msg == "Melee" then
	local newThread = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread, object)--location,damage,hitDuration,hitboxTime,size,knockback,force)--table
		--	Main.CreateHitbox(location,damage,hitDuration,hitboxTime,size,knockback,force)
   end
   if object.msg == "ProjectileFire" then
	local newProjectile = Instance.new("Part")
	newProjectile.Parent = object.location
	newProjectile.Name = "Projectile"
	newProjectile.Color = Color3.new(0, 0.317647, 1)
	newProjectile.Massless = true
	newProjectile.CanCollide = false--false
	newProjectile.Transparency = 0.5
	newProjectile.CFrame = object.location.CFrame
	newProjectile.Size = Vector3.new(5,5,5)
 
	local physicsMovement = Instance.new("BodyVelocity")
	physicsMovement.Parent = newProjectile
	physicsMovement.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		physicsMovement.Velocity = newProjectile.CFrame.LookVector.Unit*object.projectileTravelSpeed
    object.projectile = newProjectile
	local newThread2 = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread2, object)--damage,hitDuration,hitboxTime,size,knockback,force,humanoidAttacker)
	wait(object.duration)
	newProjectile:Destroy()
	object.projectile:Destroy()
   end
end
--[[
function Main.newClientProjectile(location,damage,hitDuration,hitboxTime,size,knockback,force, humanoidAttacker,msg)
	local newProjectile = Instance.new("Part")
	newProjectile.Parent = location
	newProjectile.Name = "Projectile"
	newProjectile.Color = Color3.new(0, 0.317647, 1)
	newProjectile.Massless = true
	newProjectile.CanCollide = false--false
	newProjectile.Transparency = 0.5
	newProjectile.CFrame = location.CFrame
	newProjectile.Size = Vector3.new(5,5,5)
	
	local physicsMovement = Instance.new("BodyVelocity")
	physicsMovement.Parent = newProjectile
	physicsMovement.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	physicsMovement.Velocity = newProjectile.CFrame.LookVector.Unit*30
	
	local newThread = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread, newProjectile,damage,hitDuration,hitboxTime,size,knockback,force,humanoidAttacker)
	wait(hitboxTime)
	newProjectile:Destroy()
	
end
]]--

return Main
