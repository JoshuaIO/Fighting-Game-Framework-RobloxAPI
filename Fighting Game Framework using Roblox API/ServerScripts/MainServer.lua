local mainServ = {}
local event = game.ReplicatedStorage.Events.MainAction
local eventClient =game.ReplicatedStorage.Events.MainActionClient
local physicsEvent = game.ReplicatedStorage.Events.ServerToPhysics

--Needed for remote event interactions
function mainServ.ServerCalls(player,playerPassed,msg,playerInPlayers, itemParent, angle, knockback, force)
	
	if msg == "serverCheck" then
		print("ServerCall")
	end
	if msg == "loadWeldZ" then
		
		local weldItem = playerPassed:Clone()
		weldItem.Parent = itemParent
		weldItem.PrimaryPart = weldItem.Handle
		local weldAngle = angle
		weldItem:SetPrimaryPartCFrame(playerInPlayers.CFrame * weldAngle)
		local weld = Instance.new("WeldConstraint")
		weld.Parent = playerInPlayers
		weld.Part0 = playerInPlayers
		weld.Part1 = weldItem.PrimaryPart
		
		--print(playerInPlayers.CFrame)
		--weldItem.CFrame = playerInPlayers
	end
	if msg == "newHurtboxZ" then
		local charSamp = playerPassed.CharacterSample
		local hurtboxNew = Instance.new("Part")
		playerPassed.Humanoid.WalkSpeed = 0
		playerPassed.HumanoidRootPart.Anchored = true
		hurtboxNew.Parent = playerPassed
		hurtboxNew.Name = "Hurtbox"
		hurtboxNew.Position = charSamp.CharacterState.HurtboxLocation.Value
		hurtboxNew.Orientation = playerPassed.HumanoidRootPart.Orientation
		hurtboxNew.Transparency = 0.5
		hurtboxNew.Size = playerPassed.HumanoidRootPart.Size * Vector3.new(2,3,2)
		hurtboxNew.Color = Color3.new(1, 0.670588, 0.00392157)
		hurtboxNew.CanCollide = false
		hurtboxNew.Massless = true
		hurtboxNew.Position = playerPassed.HumanoidRootPart.Position
		local weld = Instance.new("WeldConstraint")
		weld.Parent = hurtboxNew
		weld.Part0 = playerPassed.HumanoidRootPart
		weld.Part1 = hurtboxNew
		playerPassed.Humanoid.WalkSpeed = charSamp.DataParams.WalkSpeed.Value
		playerPassed.HumanoidRootPart.Anchored = false
	end
	if msg == "hitbox"then
		
		local victim = playerPassed
		if playerInPlayers ~= nil then
			victim:TakeDamage(itemParent)
			print(player)
			print(playerPassed)
			print(msg)
			print(playerInPlayers)
			print(itemParent)
			print(angle)
			print(knockback)
			print(force)
			
			eventClient:FireClient(playerInPlayers, "hit",angle,knockback,force)
		else if victim then
			victim:TakeDamage(itemParent)
				print(playerInPlayers)
				print(player)
				print(victim)
				victim.WalkSpeed = 0
				victim.JumpPower = 0
				victim.AutoRotate = false
				local victimHumanoidRootPart = victim.Parent.HumanoidRootPart
				local randomAnimSelect = math.random(1,2)
				local hitstunValue = victim.Parent:FindFirstChild("CharacterSample").CharacterState.Hitstun
				print(hitstunValue)
				hitstunValue.Value = true
				print(randomAnimSelect)
				physicsEvent:FireAllClients(victimHumanoidRootPart,force,knockback,angle)
			if randomAnimSelect == 1 then 
					local animPlay =victim.Animator:LoadAnimation(victim.Parent.CharacterSample.Animations.States.Hitstun1)
					animPlay:Play()
					animPlay:AdjustSpeed(0)
					wait(angle)
					animPlay:AdjustSpeed(1)
					wait(angle)
			else
					local animPlay = victim.Animator:LoadAnimation(victim.Parent.CharacterSample.Animations.States.Hitstun2)
					animPlay:Play()
					animPlay:AdjustSpeed(0)
					wait(angle*2)
					animPlay:AdjustSpeed(1)
					wait(angle)
			end
				victim.WalkSpeed = 25
				victim.JumpPower = 70
				victim.AutoRotate = true
				hitstunValue.Value = false
		end
		
	end
	end
	
end



return mainServ
