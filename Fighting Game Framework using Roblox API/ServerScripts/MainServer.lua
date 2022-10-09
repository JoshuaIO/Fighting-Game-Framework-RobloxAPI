local mainServ = {}
local event = game.ReplicatedStorage.Events.MainAction
local eventClient =game.ReplicatedStorage.Events.MainActionClient
local physicsEvent = game.ReplicatedStorage.Events.ServerToPhysics

--Needed for remote event interactions
function mainServ.ServerCalls(player,playerPassed, object) --msg,playerInPlayers, itemParent, angle, knockback, force)
	
	if object.msg == "serverCheck" then
		print("ServerCall")
	end
	if object.msg == "loadWeldZ" then
		
		local weldItem = playerPassed:Clone()
		weldItem.Parent = object.location
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
	
	if object.msg == "hitbox" or object.msg == "Melee" then
		print(object)
		local victim = object.victimHumanoid
		if object.victimPlayer ~= nil then
			print(object.damage)
			victim:TakeDamage(object.damage)
			print(player)
			print(playerPassed)
			object.msg = "hit"
			print(object.victim)
			print(object.attacker)
			print(object.victimPlayer)
			eventClient:FireClient(object.victimPlayer, object)
		else if victim then
			victim:TakeDamage(object.damage)
				--print(playerInPlayers)
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
				physicsEvent:FireAllClients(victimHumanoidRootPart,object)
			if randomAnimSelect == 1 then 
					local animPlay =victim.Animator:LoadAnimation(victim.Parent.CharacterSample.Animations.States.Hitstun1)
					animPlay:Play()
					animPlay:AdjustSpeed(0)
					wait(object.duration)
					animPlay:AdjustSpeed(1)
					wait(object.duration)
			else
					local animPlay = victim.Animator:LoadAnimation(victim.Parent.CharacterSample.Animations.States.Hitstun2)
					animPlay:Play()
					animPlay:AdjustSpeed(0)
					wait(object.duration*2)
					animPlay:AdjustSpeed(1)
					wait(object.duration)
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
