local  animationDetailModule = {
	--AnimationSpeeds--
	movementAnimationSpeed=1.4,
	generalAnimationSpeed=1--1.5--0.2--0.2
}

---SETTERS AND GETTERS---
function animationDetailModule.generalTableValueSetter(tableString, value)
	animationDetailModule[tableString] = value
end

function animationDetailModule.generalTableValueSetterOperator(tableString, value, operation)
	if operation == "add" then
		animationDetailModule[tableString] += value
	elseif operation == "sub" then
		animationDetailModule[tableString] -= value
	elseif operation == "mul" then
		animationDetailModule[tableString] *= value
	elseif operation == "div" then
		animationDetailModule[tableString] /= value
	end
	--stateTable[tableString] = value
end

function animationDetailModule.generalTableValueGetter(tableString)
	return animationDetailModule[tableString]
end


---CallHitStop--

function animationDetailModule.adjustAnimationActionSpeed(playerHumanoid, value)
	if playerHumanoid then
		local playerAnimSpeed = playerHumanoid:FindFirstChild("Animator")
		print(playerAnimSpeed:GetPlayingAnimationTracks())
		for i,v in pairs(playerAnimSpeed:GetPlayingAnimationTracks()) do

			--print("Index: ", i ,"Key: ", typeof(v))
			--print("Index: ", i ,"Key: ", v.AnimationId)
			--player.Parent.Humanoid.Animator:LoadAnimation(v)
			--v:Stop() 
			v:AdjustSpeed(value)
			--player.Parent.Humanoid.WalkSpeed = 0
		--	wait(0.001)
			--player.Parent.Humanoid.WalkSpeed = 1
			--wait(2)
			--v:AdjustSpeed(1)
			--player.Parent.Humanoid.Animator:AdjustSpeed(0)
		end
	end
end

-----CONTROLLER FUNCTIONS----

--EXAMPLE FUNCTION TO GRAB LOGIC TO GET PLAYING ANIM TRACKS
-- AND ADJUST THE ENTIRE SPEED, THIS LIKELY CAN JUST BE CALLED BACK AND CALLED TO CHARACTERSTATEMODULE
function animationSpeedChange(player)
	print("Player: ", player)
	if player.Parent.Humanoid then
		local playerAnimSpeed = player.Parent.Humanoid:FindFirstChild("Animator")
		print(playerAnimSpeed:GetPlayingAnimationTracks())
		--[[
		for i,v in pairs(playerAnimSpeed:GetPlayingAnimationTracks()) do
			
			print("Index: ", i ,"Key: ", typeof(v))
			--print("Index: ", i ,"Key: ", v.AnimationId)
			--player.Parent.Humanoid.Animator:LoadAnimation(v)
			--v:Stop() 
			v:AdjustSpeed(0.3)
			player.Parent.Humanoid.WalkSpeed = 0
			wait(0.001)
			player.Parent.Humanoid.WalkSpeed = 1
			--wait(2)
			--v:AdjustSpeed(1)
			--player.Parent.Humanoid.Animator:AdjustSpeed(0)
		end
		]]--
		local modScript = require(player.Parent:FindFirstChild("AnimationModuleScript"))

		modScript.generalTableValueSetter("generalAnimationSpeed", 0.5)
		player.Parent.Humanoid.WalkSpeed = 0
		wait(0.001)
		player.Parent.Humanoid.WalkSpeed = 16 --Animations can be stopped for movement by setting
		--Walkspeed, or Jump to 0, you can do this instead of anchoring everything
		-- this works out well
		-- Currently running animations can be grabbed with GetPlayingAnimationTracks()
		-- This returns an array where you can find currently playing AnimationTracks
		-- And be able to make edits

	end

end

--MAKE A FUNCTION 

return animationDetailModule
