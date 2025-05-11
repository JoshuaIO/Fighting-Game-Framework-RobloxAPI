--local animationModuleScript = require(game.ReplicatedStorage.CharacterScripts.ModifiedAnimation.AnimationModuleScript)
local stateTable = {
	
	animationModuleScript = require(game.ReplicatedStorage.CharacterScripts.ModifiedAnimation.AnimationModuleScript),
	---------States for Characters ---------------
	activeState = false,
	hitboxLocation = CFrame.new(0,0,0),
	hitboxTime = 0,
	
	----HitStop Duration-----
	hitStopCooldownCounter=0,
	hitstopBoolean = false,
	--------------------------
	
	hitstun = false,
	hitstunDuration = 0,
	
	-----HurtboxDetails-----
	
	hurtBoxTable = {
		hurtboxLocation = CFrame.new(0,0,0),
		hurtboxSize = Vector3.new(0,0,0),
		isHurtboxExtended = false,
		hurtboxExtendedDuration = 0,
		hurtboxType = {["static"]="Static", ["dynamic"]="Dynamic"}, -- statoc has main hurtbox in one place, dynamic equips the hitbox everywhere
		hurtboxState = {
			["normal"] = "Normal", 
			["invincible"]="Invincible", 
			["armor"]="Armor",
			["knockedDown"]="KnockedDown", 
			["counterHit"] = "CounterHit",
		},
		
		--We need a hurtbox client selector that will be used to determine whats kept
		clientSelection = {hurtboxType = nil, hurtboxState =nil, isHurtboxExtended=nil}
	},
	--------------------
	playerToHitstun = nil,
	knockdown = false,
	isCrouching = false,
	isDashing = false,
	isGuarding = false,
	--characterAnimationSpeed=1,
	--characterAnimationSpeedNumberHolder=1,
	-----Combo Variables----
	combo = 1,
	comboIncrementCounterAssitant = 1,
	comboCount = 0,
	comboCooldown=0,
	comboCooldownCounterAssistant = 0,
	cooldownYield = false,
	meleeComboStopped=false,
	------Coroutine-------
	statusHandleThread = "ff",
	---CharacterSelected Should be edited by the server when a character is Selected, otherwise it cant be read
	characterSelected = "SampleFighter",
	-----------------------------------
	mainPlayer = game.Players.LocalPlayer,
	
}

--TALK TO THE HELPER TABLE FOR ASSISTANCE ON HITSTOP FOR PLAYER HIT, THIS COULD LIKELY BE DONE THROUGH REMOTE FUNCTION

-- FOR THE PLAYER CONTEXT 

local runService = game:GetService("RunService")

--- Rendered Step running on a coroutine to check the status, and update the status
-- functions that handle everything such as hitstun
-- Make a thread do later

-- make coroutine for controls, and for physics

---SETTERS AND GETTERS---
function stateTable.generalTableValueSetter(tableString, value)
	stateTable[tableString] = value
end

function stateTable.generalTableValueSetterOperator(tableString, value, operation)
	if operation == "add" then
		stateTable[tableString] += value
	elseif operation == "sub" then
		stateTable[tableString] -= value
	elseif operation == "mul" then
		stateTable[tableString] *= value
	elseif operation == "div" then
		stateTable[tableString] /= value
	end
	--stateTable[tableString] = value
end

function stateTable.generalTableValueGetter(tableString)
	return stateTable[tableString]
end
----------------------------------------

function stateTable.LockControls(isLocked)
	--local player = game.Players.LocalPlayer
	local char = stateTable.playerToHitstun--player.Character
	local playerChar = game.Players.LocalPlayer.Character
--	print("CONTROL LOCK STATUS: ", isLocked)
	if isLocked == false then
			-- potential bug, where if a player gets hit, then cpu gets hit, other player could recover quickly
		
		if char ~= nil then
			--print("PLAYER EXIST: " ,game.Players:GetPlayerFromCharacter(char))
			if game.Players:GetPlayerFromCharacter(char) ~= nil then
				playerChar:WaitForChild("Humanoid").WalkSpeed = 0
				playerChar:WaitForChild("Humanoid").JumpPower = 0
				playerChar:WaitForChild("Humanoid").AutoRotate = false
			end
			char:WaitForChild("Humanoid").WalkSpeed = 25
			char:WaitForChild("Humanoid").JumpPower = 70
			char:WaitForChild("Humanoid").AutoRotate = true
		
		end
		--Logic needs to be done to unlock controls of those are players, when char switches
		-- This can be done via running a coroutine so the thread doesnt change,
		-- or explicitcy
		-- after testing, might need coroutine, as the player hitstun needs to count down individually
	else
		
		if char ~= nil then
			if game.Players:GetPlayerFromCharacter(char) ~= nil then
				playerChar:WaitForChild("Humanoid").WalkSpeed = 0
				playerChar:WaitForChild("Humanoid").JumpPower = 0
				playerChar:WaitForChild("Humanoid").AutoRotate = false
			end
			--print("PLAYER EXIST: " ,game.Players:GetPlayerFromCharacter(char))
			char:WaitForChild("Humanoid").WalkSpeed = 0
			char:WaitForChild("Humanoid").JumpPower = 0
			char:WaitForChild("Humanoid").AutoRotate = false
			
		end
		
	end
	
	--coroutine.yield("YIELD")
end



function stateTable.comboIncrement(debounce)
	--print("ANIMATION ALLOWED: ",animation)
	------print("THREAD COMBO INCREMENT: ", stateTable.combo)
	--debounce = false
	--module.combo += 1
	stateTable.combo += 1
	-----print("THREAD After COMBO INCREMENT: ", stateTable.combo)
	--	print(animation)
	--animation:Destroy()
end


function stateTable.HitstunApply()
	if stateTable.hitstunDuration > 0 then
		if stateTable.hitstun == true then
			--and it is a hit
			--stateTable.comboCount += 1
		-----	print("COMBO COUNT: ", stateTable.comboCount)
		end
		stateTable.hitstun = true
		stateTable.LockControls(true)
		stateTable.hitstunDuration -= 1
-----		print("STATE HITSTUN:", stateTable.hitstunDuration)

	else
		stateTable.hitstun = false
		stateTable.comboCount = 0
		stateTable.LockControls(false)
	end
end

function stateTable.meleeComboCooldown()
	if stateTable.generalTableValueGetter("comboCooldown") > 0 and stateTable.meleeComboStopped == true then
		--task.wait(0.004)
		--stateTable.comboIncrementCounterAssitant -= 1
		stateTable.generalTableValueSetter("comboCooldown", stateTable.generalTableValueGetter("comboCooldown") - 1)
		--print("COOLDOWN COUNTDOWN: ", stateTable.generalTableValueGetter("comboCooldown"))
		--print("COOLDOWN RAW: ", stateTable.comboCooldown)
	else
		
		print("ENDED!")
		stateTable.meleeComboStopped = false
		stateTable.generalTableValueSetter("meleeComboStopped", false)
		stateTable.comboIncrementCounterAssitant = 1
		stateTable.generalTableValueSetter("combo", stateTable.comboIncrementCounterAssitant)
		
		print("FINAL VALUE meleeComboStopped: ",stateTable.generalTableValueGetter("meleeComboStopped"))
		print("FINAL VALUE Combo: ", stateTable.generalTableValueGetter("combo"))
		

	end
end



function stateTable.hitStopCooldown()
	if stateTable.generalTableValueGetter("hitStopCooldownCounter") > 0 and stateTable.generalTableValueGetter("hitstopBoolean") == true  then

		stateTable.animationModuleScript.generalTableValueSetter("generalAnimationSpeed",0)

		stateTable.animationModuleScript.adjustAnimationActionSpeed(stateTable.mainPlayer.Character.Humanoid, stateTable.animationModuleScript.generalTableValueGetter("generalAnimationSpeed"))

		stateTable.generalTableValueSetter("hitStopCooldownCounter", stateTable.generalTableValueGetter("hitStopCooldownCounter") - 1)
		print("HITKBZ: ", stateTable.generalTableValueGetter("hitStopCooldownCounter"))


	else

		print("HITSTOP IS ZERO")
		stateTable.generalTableValueSetter("hitStopCooldownCounter", 0)
		stateTable.generalTableValueSetter("hitstopBoolean", false)
		stateTable.hitstopBoolean = false
		stateTable.animationModuleScript.generalTableValueSetter("generalAnimationSpeed",1)--stateTable.generalTableValueSetter("characterAnimationSpeed",1)--stateTable.characterAnimationSpeedNumberHolder
		stateTable.animationModuleScript.adjustAnimationActionSpeed(stateTable.mainPlayer.Character.Humanoid, stateTable.animationModuleScript.generalTableValueGetter("generalAnimationSpeed"))
		



	end
end

function stateTable.HitstunLogic()
	--local player = game.Players.LocalPlayer
	local char = stateTable.playerToHitstun--player.Character
	local playerChar = game.Players.LocalPlayer.Character

	--print("PLAYER FOUND: ", game.Players.LocalPlayer)
	if game.Players:GetPlayerFromCharacter(char) == nil then
		--print("NO REAL PLAYER")
		--stateTable.HitstunApply()
		local newThread = coroutine.create(stateTable.HitstunApply)
		coroutine.resume(newThread)
		coroutine.close(newThread)
		--coroutine.close()
		
	else
	--	print("REAL PLAYER")
		local newThread = coroutine.create(stateTable.HitstunApply)
		coroutine.resume(newThread)
		coroutine.close(newThread)
		--stateTable.HitstunApply()
		--coroutine.wrap(stateTable.HitstunApply)
		
	end
	-- Yield process
end

function stateTable.meleeCoolDownManagerThread()


	if stateTable.meleeComboStopped == true and stateTable.cooldownYield == false then
		local newThread = coroutine.create(stateTable.meleeComboCooldown)
		coroutine.resume(newThread)
		coroutine.close(newThread)
	end
	if stateTable.generalTableValueGetter("hitstopBoolean") == true then
		--print("Old Boolean: ", stateTable.hitstopBoolean)
		--print("New Boolean: ", stateTable.generalTableValueGetter("hitstopBoolean"))
		--stateTable.generalTableValueGetter("hitstopBoolean")
		local newThread = coroutine.create(stateTable.hitStopCooldown)
		coroutine.resume(newThread)
		coroutine.close(newThread)
		--stateTable.hitStopCooldown()
	end
	--print("Old Boolean2: ", stateTable.hitstopBoolean)
	--print("New Boolean2: ", stateTable.generalTableValueGetter("hitstopBoolean"))
	-- check thread status, if dead we want to restore combo to 1
end


function stateTable.RenderStatParameters()
	--runService.RenderStepped:Connect()
	stateTable.meleeCoolDownManagerThread()
	stateTable.HitstunLogic()
	
	--stateTable.meleeComboCooldown()
--	print("CURRENT NUMBER IN ROTATION: ", stateTable.randomNumberTest)
	--stateTable.getMainPlayer()
	--while true do
	--	print("SALAD")
	--end
	
	--local hitstun = coroutine.wrap(stateTable.HitstunLogic) -- We want to make a coroutine
	--hitstun()
	--print("Rendererer")
	--Stay on a yield
	-- Figure out Knockdown
	-- Figure out Crouching
	-- Figure out Dashing
	-- Figure out Guarding
end



return stateTable
