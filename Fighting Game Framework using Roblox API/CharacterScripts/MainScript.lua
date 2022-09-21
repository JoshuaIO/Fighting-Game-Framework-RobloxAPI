local animationList = require(script.Parent.Animations)
local Main = {
	-----------------------------------------------------------
	-- Character State Value
	-----------------------------------------------------------
	activeState = script.Parent.Parent.CharacterState.ActiveState,
	hitboxLocation = script.Parent.Parent.CharacterState.HitboxLocation,
	hitboxTime = script.Parent.Parent.CharacterState.HitboxTime,
	hitstun = script.Parent.Parent.CharacterState.Hitstun,
	hurtboxLocation = script.Parent.Parent.CharacterState.HurtboxLocation,
	knockdown = script.Parent.Parent.CharacterState.Knockdown,
	isCrouching = script.Parent.Parent.CharacterState.isCrouching,
	isDashing = script.Parent.Parent.CharacterState.isDashing,
	isGuarding = script.Parent.Parent.CharacterState.isGuarding,
	hitstunDuration =script.Parent.Parent.CharacterState.HitstunDuration,
	--------------------------------------------------------------
	-- Generics
	--------------------------------------------------------------
	player = game.Players.LocalPlayer,
	char= game.Players.LocalPlayer.Character,
	humanoid = game.Players.LocalPlayer.Character.Humanoid,
	
}
local event = game.ReplicatedStorage.Events.MainAction
local eventClient = game.ReplicatedStorage.Events.MainActionClient

local debounce = false
function Main.BodyVelocity(parent, force, direction, waitTime)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.humanoid:SetStateEnabled(humanStateFalling, false)
	local bodyVelocity = Instance.new("BodyVelocity")
	print(parent)
	print(force)
	print(direction)
	print(waitTime)
	bodyVelocity.Parent = parent
	bodyVelocity.MaxForce = force--Force
	bodyVelocity.Velocity = direction --Direction
	wait(waitTime)--Wait
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

function Main.Hitstun(duration,knockback,force) --Values need to be passed
	Main.humanoid.WalkSpeed = 0
	Main.humanoid.JumpPower = 0
	Main.humanoid.AutoRotate = false
	local check = "serverCheck"
	event:FireServer(check)
	local randomAnimSelect = math.random(1,2)
	print(randomAnimSelect)
	print(duration)
	if randomAnimSelect == 1 then 
		local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.hitstun1)
		animPlay:Play()
		print(duration)
		animPlay:AdjustSpeed(duration/2)
		Main.BodyVelocity(Main.char.HumanoidRootPart,force,knockback,duration)
		wait(1)
		animPlay:AdjustSpeed(1)
		wait(Main.hitstunDuration.Value)
	else
		local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.hitstun2)
		animPlay:Play()
		animPlay:AdjustSpeed(duration/2)
		Main.BodyVelocity(Main.char.HumanoidRootPart,force,knockback,duration)
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
	local force = Vector3.new(math.huge,math.huge,math.huge)
	local direction = physicsLocation.CFrame.LookVector.Unit *60
	local waitTime = 0.5
	local check = "serverCheck"
	event:FireServer(Main.player,check)
	if debounce == false then
		debounce = true
		local animPlay = Main.humanoid.Animator:LoadAnimation(animationList.dash)
		animPlay:Play()
		Main.BodyVelocity(physicsLocation,force,direction,waitTime)
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
function Main.CreateHurtbox(player)--Pass Hurtbox Location
	Main.hurtboxLocation.Value = Main.char.HumanoidRootPart.Position
	local msg = "newHurtbox"
		event:FireServer(Main.char, msg)
end

function Main.CreateHitbox(areaLocation,damage,hitstunDuration, hitboxTime,size, knockback,force,humanoidAttacker)--Pass Hitbox Location
	local debounce = false
	local debounce2 = false
	local newTest = areaLocation
	--print(hitstunDuration)
	Main.hitboxLocation.Value = newTest.CFrame
--	hitboxTime = (1/60) 
	Main.hitboxTime.Value = hitboxTime
	if debounce == false then
		debounce = true
		local hitbox = Instance.new("Part")
		hitbox.Transparency = 0.6
		hitbox.Parent = areaLocation.Parent--Main.char
		print(hitbox.Parent)
		hitbox.Name = "Hitbox"
		hitbox.Color = Color3.fromRGB(255, 20, 20)
		hitbox.CanCollide = false
		hitbox.Massless = true
		hitbox.Size = size
		hitbox.CFrame = Main.hitboxLocation.Value
		hitbox.Orientation = newTest.Orientation
		debounce = true
		local weld = Instance.new("WeldConstraint")
		weld.Archivable = true
		weld.Name = "hitboxWeld"
		weld.Parent = hitbox
		weld.Part0 = areaLocation
		weld.Part1 = hitbox
		
		hitbox.Touched:Connect(function(victimPlayer)
			local victim = victimPlayer.Parent
			local humanoidVictim = victimPlayer.Parent:FindFirstChild("Humanoid")
			local humanoidVictimHead = victimPlayer.Parent:FindFirstChild("Head")
			--if humanoidVictim.Parent ~= hitbox.Parent and debounce2==false then
			if victim ~= hitbox.Parent and debounce2 == false and humanoidVictim ~= humanoidAttacker then
				debounce2= true
				humanoidVictimHead.CFrame = CFrame.lookAt(humanoidVictimHead.Position, hitbox.Position)
				local playerInPlayers = game.Players:GetPlayerFromCharacter(victimPlayer.Parent)
				event:FireServer(humanoidVictim, "hitbox",playerInPlayers,damage,hitstunDuration,knockback,force)
		end-- pass more
		end)
		wait(Main.hitboxTime.Value)
		hitbox:Destroy()
		debounce = false
		debounce2 = false
	end
end


function Main.ClientCalls(msg,duration,knockback,force)
	local waitTime = 0.5
	if msg == "hit" then
		--print(msg)
	--	print(duration)
		--print(knockback)
		--print(force)
		local newThread = coroutine.create(Main.Hitstun)
		coroutine.resume(newThread,duration,knockback,force)
		--Main.Hitstun(duration,knockback,force)
	end
	
end

function Main.newClientTouch(location,damage,hitDuration,hitboxTime,size,knockback,force, humanoidAttacker,msg,projectileTravelSpeed)
	--print("ClientCaptured")
	--print(location)
	--print(damage)
	--print(hitDuration)
	if msg == "Melee" then
	local newThread = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread, location,damage,hitDuration,hitboxTime,size,knockback,force)
		--	Main.CreateHitbox(location,damage,hitDuration,hitboxTime,size,knockback,force)
   end
   if msg == "ProjectileFire" then
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
		physicsMovement.Velocity = newProjectile.CFrame.LookVector.Unit*projectileTravelSpeed

	local newThread2 = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread2, newProjectile,damage,hitDuration,hitboxTime,size,knockback,force,humanoidAttacker)
	wait(hitboxTime)
	newProjectile:Destroy()

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
