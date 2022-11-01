local replicatedStorage = game.ReplicatedStorage
local serverStorage = game.ServerStorage
local replicatedFirst = game.ReplicatedFirst
local characterSample = replicatedStorage.CharacterSample
local characterScripts = replicatedStorage.CharacterScripts
local animationList = require(characterScripts.Animations)
local MainModule = require(characterScripts.MainScript)
local charMoveList = {
	
}
local combo = 1
local debounce = false
local event = game.ReplicatedStorage.Events.MainAction
function charMoveList.Attack()
	if combo ==1 and debounce==false then
			debounce = true
			combo = 2
		local check = "serverCheck"
		event:FireServer(MainModule.player,check)
			local animPlay = MainModule.humanoid.Animator:LoadAnimation(animationList.attack1)
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
			local animPlay = MainModule.humanoid.Animator:LoadAnimation(animationList.attack2)
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
				local animPlay = MainModule.humanoid.Animator:LoadAnimation(animationList.attack3)
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

function charMoveList.Skill1()

		local check = "serverCheck"
		event:FireServer(MainModule.player,check)
		local animPlay = MainModule.humanoid.Animator:LoadAnimation(animationList.skill1)
		animPlay:Play()
		animPlay.KeyframeReached:Connect(function (keyframe, keyframePoint)
			if keyframe == "Keyframe4" then
				local location =MainModule.char.PlasmaSword.Blade
				local damage = 2
				local hitDuration = 0.3
				local hitboxTime = (8/60)
				local size = Vector3.new(6,3,3)
				MainModule.CreateHitbox(location,damage,hitDuration,hitboxTime,size)
				--animPlay:AdjustSpeed(0)
			end
		end)	
end
return charMoveList
