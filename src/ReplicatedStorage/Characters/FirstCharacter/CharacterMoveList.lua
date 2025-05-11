local replicatedStorage = game.ReplicatedStorage
--local serverStorage = game.ServerStorage
local replicatedFirst = game.ReplicatedFirst
local characterSample = replicatedStorage.CharacterSample
local characterScripts = replicatedStorage.CharacterScripts
local animationList = require(characterScripts.Animations)
local MainModule = require(characterScripts.MainScript)
local HelperModule = require(replicatedStorage.CharacterScripts.HelperTable)
local HitboxTable = HelperModule.hitboxTable
local combo = 1
local debounce = false
local debounce2 = false
local event = game.ReplicatedStorage.Events.MainAction
local charMoveList = {}


function charMoveList.Attack()
	if combo ==1 and debounce==false then
			debounce = true
			combo = 2
		local check = "serverCheck"
		event:FireServer(MainModule.player,check)
		local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animationList.attack1)
			animPlay:Play()
	animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
			if keyframe == "Keyframe4" then
				local location =MainModule.char.PlasmaSword.Blade
				local damage = 2
				local hitDuration = 0.3
				local hitboxTime = (8/60)
				local size = Vector3.new(5,5,5)
				local knockback = MainModule.char.HumanoidRootPart.CFrame.LookVector.Unit* 2
				local force = Vector3.new(math.huge,math.huge,math.huge)
				MainModule.CreateHitbox(location,damage,hitDuration,hitboxTime,size,knockback,force) --Translate this to table
				--animPlay:AdjustSpeed(0)
			end
		end)		
			wait(0.4)
			debounce = false
			wait(2)
			combo =1
		
	else if combo==2 and debounce == false then
			debounce= true
			combo =3

			local check = "serverCheck"
			event:FireServer(MainModule.player,check)
			local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animationList.attack2)
			animPlay:Play()
			animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
				if keyframe == "Keyframe7" then
					local location =MainModule.char.RightHand
					local damage = 2
					local hitDuration = 0.3
					local hitboxTime = (6/60)
					local size = Vector3.new(5,5,5)
					local knockback = MainModule.char.HumanoidRootPart.CFrame.LookVector.Unit* 2
					local force = Vector3.new(math.huge,math.huge,math.huge)
					MainModule.CreateHitbox(location,damage,hitDuration,hitboxTime,size,knockback,force)
					--animPlay:AdjustSpeed(0)
				end
			end)		
			wait(0.3)
			debounce= false
			wait(3)
			combo =1
		else if combo == 3 and debounce == false  then
				debounce= true
				combo =4

				local check = "serverCheck"
				event:FireServer(MainModule.player,check)
				local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animationList.attack3)
				animPlay:Play()
				animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
					if keyframe == "Keyframe6" then
						local location =MainModule.char.RightHand
						local damage = 2
						local hitDuration = 0.3
						local hitboxTime = (6/60)
						local size = Vector3.new(5,5,5)
						local knockback = MainModule.char.HumanoidRootPart.CFrame.LookVector.Unit* 30
						local force = Vector3.new(math.huge,math.huge,math.huge)
						MainModule.CreateHitbox(location,damage,hitDuration,hitboxTime,size,knockback,force)
						--animPlay:AdjustSpeed(0)
					end
				end)	
				wait(1.5)
				debounce = false
				wait(3)
			end
		end
	end
end

function charMoveList.Skill1(playerData)
	print(playerData)
		local playerX = playerData.localplayer
		local check = "serverCheck"
--	event:FireServer(MainModule.player,check)
	if playerData.magicEquipOne.Value == "Aqua Typhoon" or playerData.magicEquipTwo.Value == "Aqua Typhoon" and debounce==false then
		local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animationList.skill1)
		animPlay:Play()
		debounce=true
		animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
			if keyframe == "Keyframe6" then
				HitboxTable.location = playerX.Character.HumanoidRootPart
				HitboxTable.damage = 7
				HitboxTable.duration = 0.5
				HitboxTable.hitboxTime = (18/60)
				HitboxTable.size = Vector3.new(3,3,3)
				HitboxTable.knockback = MainModule.char.HumanoidRootPart.CFrame.LookVector.Unit* 2
				HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
				HitboxTable.attackerHumanoid = playerX.Character.Humanoid
				HitboxTable.attacker = playerX
				HitboxTable.attackerHumanoidRootPart = playerX.Character.HumanoidRootPart
				HitboxTable.msg = "hitbox"
				HitboxTable.validLocation = HitboxTable.location
				HitboxTable.cframe = HitboxTable.location.CFram
				
				HitboxTable.validSize = Vector3.new(1,HitboxTable.size.Y,HitboxTable.size.Z)
				HitboxTable.validation = false
				HitboxTable.magnitudeRange = 14
				print(HitboxTable.cframe)
				print(HitboxTable.attackerHumanoid)
				print(HitboxTable)
				MainModule.MagnitudeHitbox(HitboxTable)
			--	MainModule.BoundingRayBox(HitboxTable)
				--MainModule.CreateHitbox(HitboxTable)
				wait(9)
				debounce = false
			end
		end)	
	end
		
end

function charMoveList.Skill2(playerData)

	print(playerData)
	local playerX = playerData.localplayer
	local check = "serverCheck"
	--	event:FireServer(MainModule.player,check)
	if playerData.magicEquipOne.Value == "FireBall" or playerData.magicEquipTwo.Value == "Fireball" and debounce2 == false then
		local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animationList.skill1)
		debounce2 = true
		animPlay:Play()
		animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
			if keyframe == "Keyframe6" then
				
				HitboxTable.location = playerX.Character.HumanoidRootPart
				HitboxTable.damage = 7
				HitboxTable.duration = 0.5
				HitboxTable.hitboxTime = (18/60)
				HitboxTable.size = Vector3.new(3,3,3)
				HitboxTable.knockback = MainModule.char.HumanoidRootPart.CFrame.LookVector.Unit* 2
				HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
				HitboxTable.attackerHumanoid = playerX.Character.Humanoid
				HitboxTable.attacker = playerX
				HitboxTable.attackerHumanoidRootPart = playerX.Character.HumanoidRootPart
				HitboxTable.msg = "hitbox"
				HitboxTable.validLocation = HitboxTable.location
				HitboxTable.cframe = HitboxTable.location.CFrame * CFrame.new(-1,0,0)
				HitboxTable.validSize = Vector3.new(1,HitboxTable.size.Y,HitboxTable.size.Z)
				HitboxTable.validation = false
				HitboxTable.magnitudeRange = 14
				print(HitboxTable.cframe)
				print(HitboxTable.attackerHumanoid)
				print(HitboxTable)
				MainModule.MagnitudeHitbox(HitboxTable)
				--	MainModule.BoundingRayBox(HitboxTable)
				--MainModule.CreateHitbox(HitboxTable)
				wait(9)
				debounce2= false
			end
		end)	
	end

end
return charMoveList
