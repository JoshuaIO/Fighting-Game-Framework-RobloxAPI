local UIS = game:GetService("UserInputService")

local replicatedStorage = game.ReplicatedStorage
local serverStorage = game.ServerStorage
local event2 = game.ReplicatedStorage.Events.MainAction
local playerX = game.Players.LocalPlayer
--local EffectLib = require(playerX.Character:WaitForChild("ClientSideEffects"))
local MainModule = require(replicatedStorage.CharacterScripts.MainScript)
local HelperModule = require(replicatedStorage.CharacterScripts.HelperTable)
local HitboxTable = HelperModule.hitboxTable

local module = {
	idle = "rbxassetid://",
	combatIdle = "rbxassetid://9943150403",
	slash1 = "rbxassetid://9943193017",
	slash2 = "rbxassetid://10233552978",
	slash3 = "rbxassetid://6598786883",
	slash4 = "rbxassetid://6598786883",
	
	slash5 = "rbxassetid://6603979975",
	skill1 = "rbxassetid://6603708595",
	skill2 = "rbxassetid://6603979975",
	debounce = false,
	debounce2 = false,
	deobunce3 = false,
	debounce4 = false,
	--damage = script.Parent.Damage.Value,
	combo =1
}


function module.MeleeCombo()
	if module.combo ==1 and module.debounce==false then
		module.debounce = true
		module.combo = 2
		local check = "serverCheck"
		local animation = Instance.new("Animation")
		animation.Parent = playerX.Character
		animation.Name= "Slash"
		animation.AnimationId = module.slash1
		event2:FireServer(MainModule.player,check)
		local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animation)
		animPlay:Play()
		
		animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
			if keyframe == "Keyframe3" then
				print("Spirit")

				HitboxTable.location = script.Parent.Blade
				HitboxTable.damage = 12
				HitboxTable.duration = 1--0.02
				HitboxTable.hitboxTime = (18/60)
				HitboxTable.size = Vector3.new(3,4,3)
				
				HitboxTable.knockback = MainModule.player.Character.HumanoidRootPart.CFrame.LookVector.Unit* 2
				HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
				HitboxTable.attackerHumanoid = playerX.Character.Humanoid
				HitboxTable.attacker = playerX
				HitboxTable.attackerHumanoidRootPart = playerX.Character.HumanoidRootPart
				HitboxTable.msg = "hitbox"
				
				HitboxTable.validLocation = HitboxTable.location
				HitboxTable.cframe = HitboxTable.location.CFrame * CFrame.new(-1,0,0)
				HitboxTable.validSize = Vector3.new(1,HitboxTable.size.Y,HitboxTable.size.Z)
				HitboxTable.validation = false
				HitboxTable.magnitudeRange = 60
				
				--print(HitboxTable.cframe)
				
				--print(HitboxTable.attackerHumanoid)
				
				--MainModule.MagnitudeHitbox(HitboxTable)
				MainModule.BoundingRayBox(HitboxTable)
				--MainModule.CreateHitbox(HitboxTable)

			end
		end)
		
		wait(0.4)
		module.debounce = false
		wait(2)
		module.combo =1

	else if module.combo==2 and module.debounce == false then
			module.debounce= true
			module.combo =1
			local animation = Instance.new("Animation")
			animation.Parent = playerX.Character
			animation.Name= "Slash"
			animation.AnimationId = module.slash2
			local check = "serverCheck"
			event2:FireServer(MainModule.player,check)
			local animPlay = MainModule.player.Character.Humanoid:LoadAnimation(animation)
			local animator = MainModule.player.Character.Humanoid.Animator
	
			animPlay:Play()

			animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
				if keyframe == "Keyframe4" then

					HitboxTable.location = script.Parent.Blade
					HitboxTable.damage = 12
					HitboxTable.duration = 1--0.02
					HitboxTable.hitboxTime = (18/60)
					HitboxTable.size = Vector3.new(3,4,3)
					HitboxTable.knockback = MainModule.player.Character.HumanoidRootPart.CFrame.LookVector.Unit* 2
					HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
					HitboxTable.attackerHumanoid = playerX.Character.Humanoid
					HitboxTable.attacker = playerX
					HitboxTable.attackerHumanoidRootPart = playerX.Character.HumanoidRootPart
					HitboxTable.msg = "hitbox"
					HitboxTable.validLocation = HitboxTable.location
					HitboxTable.cframe = HitboxTable.location.CFrame * CFrame.new(-1,0,0)
					HitboxTable.validSize = Vector3.new(1,HitboxTable.size.Y,HitboxTable.size.Z)
					HitboxTable.validation = false
					HitboxTable.magnitudeRange = 60
					print(HitboxTable.cframe)
					--print(HitboxTable.attackerHumanoid)

					--MainModule.MagnitudeHitbox(HitboxTable)
					MainModule.BoundingRayBox(HitboxTable)
					--MainModule.CreateHitbox(HitboxTable)
				end
			end)

			wait(0.3)
			module.debounce= false
			wait(3)
			module.combo =1
		else if module.combo == 3 and module.debounce == false  then
				module.debounce= true
				module.combo =4
				local animation = Instance.new("Animation")
				animation.Parent = playerX.Character
				animation.Name= "Slash"
				animation.AnimationId = module.slash3
				local check = "serverCheck"
				event2:FireServer(MainModule.player,check)
				local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animation)
				local animator = MainModule.player.Character.Humanoid.Animator

				animPlay:Play()

				animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
					if keyframe == "Keyframe6" then

						HitboxTable.location = script.Parent.Blade
						HitboxTable.damage = 5
						HitboxTable.duration = 1--0.3
						HitboxTable.hitboxTime = (18/60)
						HitboxTable.size = Vector3.new(5,5,5)
						HitboxTable.knockback = MainModule.player.Character.HumanoidRootPart.CFrame.LookVector.Unit* 2
						HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
						HitboxTable.attackerHumanoid = playerX.Character.Humanoid
						HitboxTable.attacker = playerX
						HitboxTable.attackerHumanoidRootPart = playerX.Character.HumanoidRootPart
						HitboxTable.msg = "hitbox"
						HitboxTable.validLocation = HitboxTable.location
						HitboxTable.cframe = HitboxTable.location.CFrame * CFrame.new(-1,0,0)
						HitboxTable.validSize = Vector3.new(1,HitboxTable.size.Y,HitboxTable.size.Z)
						HitboxTable.validation = true
						print(HitboxTable.cframe)
						--print(HitboxTable.attackerHumanoid)

						MainModule.BoundingRayBox(HitboxTable)
						--MainModule.CreateHitbox(HitboxTable)
					end
				end)	

				wait(1.5)
				module.debounce = false
				wait(3)
			end
		end
	end
end

return module
