local UIS = game:GetService("UserInputService")
local clientReceive = game.ReplicatedStorage.Events.ClientToClientSend
local replicatedStorage = game.ReplicatedStorage
--local serverStorage = game.ServerStorage
local event = game.ReplicatedStorage.Events.MainAction
local eventSendToAll = game.ReplicatedStorage.Events.SendServerToClient
local eventSendToServerCast = game.ReplicatedStorage.Events.SendToServerFromCombatWriter


local playerX = game.Players.LocalPlayer
--local EffectLib = require(playerX.Character:WaitForChild("ClientSideEffects"))
local MainModule = require(replicatedStorage.CharacterScripts.MainScript)
local HelperModule = require(replicatedStorage.CharacterScripts.HelperTable)

local HitboxTable = HelperModule.hitboxTable
local combatDataTemp = nil

-- Combat Data Receiver, yields until the MainServer Provides it with a Character from CharacterStateModule
local combatDataReceiver = clientReceive:InvokeServer("SampleCharacter")
--local combatDataReceiver = clientReceive:InvokeServer("SampleCharacter") --change this to be more generic
local combatData = require(combatDataReceiver.CombatData)--clientReceive.Event:Connect(clientOnCall) --require(script.Parent.CombatData)]]--
local characterStateModule = require(replicatedStorage.CharacterSample.CharacterState.CharacterStateModule) -- remove this


--print("RemoteFunction VAL: ", combatDataReceiver)
--wait(2)
--combatDataTemp = clientOnCall()
--print("COMBAT VALZZ: ", combatData)
--print("Maybe it works: ", combatDataTemp)

--Redo Pipeline and have combat data separate
local module = {
	idle = "rbxassetid://",
	combatIdle = "rbxassetid://9943150403",

	debounce = false,
	debounce2 = false,
	deobunce3 = false,
	debounce4 = false,
	--damage = script.Parent.Damage.Value,
	--STATUSES--
	combo =1, --Combos will be counted up, and eventually fall if cooldown strikes down, seperate routine
	keyframeHitboxLoaderNumber=1,
	sampleKeyframeScoreKeeper = 1,
	hitCountScoreKeeper = 1,
	check ="serverCheck",
	name = "Slash",
	hitboxMsg="msg"
	
}

function module.comboIncrement(currentThreadCombo)
	--print("ANIMATION ALLOWED: ",animation)
	print("THREAD COMBO INCREMENT: ", currentThreadCombo)
	module.debounce = false
	--currentThreadCombo += 1
	characterStateModule.comboIncrementCounterAssitant += 1
	characterStateModule.generalTableValueSetter("combo",characterStateModule.comboIncrementCounterAssitant)
	--module.combo += 1--currentThreadCombo
	--characterStateModule.combo += currentThreadCombo
	
	
	print("THREAD After COMBO INCREMENT: ", module.combo)
--	print(animation)
	--animation:Destroy()
end

--We need a function that will processPhysicsDirection, as for projectiles this does not change from CombatWriter

function module.fixPlayerCharacterPath(hitboxLocationPath)
	-- This method aims to solve the issue of CombatData having old information of player Location and status
	local dir="Workspace."
	local fullPathStringForOldHitbox = tostring(hitboxLocationPath:GetFullName())

	local newPathStringForHitbox = string.gsub(fullPathStringForOldHitbox, tostring(MainModule.player.Character:GetFullName()), tostring(MainModule.player.Character:GetFullName()))
	local fixedBuildString = dir..newPathStringForHitbox
		
	local segments=fixedBuildString:split(".")--newPathStringForHitbox:split(".")
	local current=game --location to search
	
	for i,v in pairs(segments) do
		current=current[v]
		
	end
	

	return current

end

function module.genericKeyPairSearch(combatDataFields ,combatDataKeyGoal)
	print("ANIMATION SELECTED :  ANIMS: ", combatDataFields, combatDataKeyGoal)
	for key, value in pairs(combatDataFields) do
		-- Should choose animation by combo
		if key == combatDataKeyGoal then
		--	print("COMBATTT: ",key ,value)
			return value
		end
	end
	
end

function module.processKnockbackValue(combatDataVariable)
	-- Please use 1 as the lowest knockback value
	local knockbackValue = 1

	HelperModule.hitboxTable.knockbackMultiplier = combatDataVariable.hitboxHitCount < 3 and combatDataVariable.hitboxKnockbackMultiplier[module.keyframeHitboxLoaderNumber] or combatDataVariable.hitboxKnockbackMultiplier[module.hitCountScoreKeeper]
	HelperModule.hitboxTable.upForce = Vector3.new(
		combatDataVariable.hitboxKnockbackVictimDirection["kbX"], 
		combatDataVariable.hitboxKnockbackVictimDirection["kbY"],
		combatDataVariable.hitboxKnockbackVictimDirection["kbZ"]
	)
	HelperModule.hitboxTable.hitboxPhysicsChoice = combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber]
	return knockbackValue
end

function module.processProjectileFireSource(combatDataVariable)
	local dir = "Workspace."
	local correctProjectileSource = tostring(combatDataVariable.projectileSource[module.keyframeHitboxLoaderNumber]:GetFullName())
	print("PROJECTILE SOURCE: ", correctProjectileSource)
	local correctProjectileForce = combatDataVariable.projectileForce[module.keyframeHitboxLoaderNumber]
	local correctProjectileDirectionAndUnit = combatDataVariable.projectileDirectionAndUnit[module.keyframeHitboxLoaderNumber]
	local correctFusionPath = correctProjectileSource..correctProjectileDirectionAndUnit
	print("CORRECT FUSION PATH: ", correctFusionPath)
--	print("NEW STRINGEERRR: ",correctProjectileSource..correctProjectileDirectionAndUnit)
	
	local healPath = string.gsub(correctFusionPath, tostring(MainModule.player.Character:GetFullName()), tostring(MainModule.player.Character:GetFullName()))
	local combinePath = healPath
	local splitPathResults = combinePath:split(".")
--	print("splitPath: ", splitPathResults)
	
	
	local current=game --location to search

	for i,v in pairs(splitPathResults) do
		current=current[v] --CURRENTLY A BUG THAT COUNTS THE ATTACKER'S DETAILS
--		print("CURRENTER: ", current)

	end
	local mergeForce = current*correctProjectileForce
	--return current
	--print("NEW STRINGER: ", tostring(correctProjectileSource))
--	print("CORRECTO: ", combatDataVariable.projectileSource:GetFullName())
	 print("FINAL PATH OF CREATION: ", mergeForce)
	return mergeForce
end
--Hitboxes
--runAttack(keyframe, keyframePoint, combatData)

function module.physicsWriter(combatDataVariable)
	--print(HitboxTable)
	
	print("PHYSICS WRITER LAUNCHER ", combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber])
	
	
	if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "LinearVelocity" then

		HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode = combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber]
		--Required Vector should update these elements only through ternary
		---Vector--
		
		HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.relativeTo = combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber]
	--	print("CLIENT Selection Choice: ", HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.relativeTo)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode].vectorVelocity = combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Vector" and module.processKnockbackValue(combatDataVariable)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber]].forceLimitsEnabled =  combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Vector" and combatDataVariable.forceLimitsEnabled[module.keyframeHitboxLoaderNumber]
	
		--Line--
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Line"].lineDirection =  combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Line" and module.processKnockbackValue(combatDataVariable)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Line"].lineVelocity = combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Line" and 75-- ternary force used to push the object, good for projectiles
		--Plane--
		
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Plane"].planeVelocity = combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Plane" and Vector2.new(module.processKnockbackValue(combatDataVariable).X, module.processKnockbackValue(combatDataVariable).Y)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Plane"].primaryTangentAxis = combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Plane" and combatDataVariable.primaryTangentAxis[module.keyframeHitboxLoaderNumber] -- check if nil
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Plane"].secondaryTangentAxis = combatDataVariable.velocityConstraintMode[module.keyframeHitboxLoaderNumber] == "Plane" and combatDataVariable.secondaryTangentAxis[module.keyframeHitboxLoaderNumber] -- if nil


	else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "VectorForce" then
			HitboxTable.hitboxKBPhysics["VectorForce"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber]  -- if variable exist add num, else do nothing
			HitboxTable.hitboxKBPhysics["VectorForce"].clientSelection.relativeTo = combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber] --nil relativity if
			HitboxTable.hitboxKBPhysics["VectorForce"].force = combatDataVariable.force[module.keyframeHitboxLoaderNumber] ~= nil and module.processKnockbackValue(combatDataVariable)--combatDataVariable.force 

		else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "AngularVelocity" then 
				HitboxTable.hitboxKBPhysics["AngularVelocity"].clientSelection.relativeTo = combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber]  
				HitboxTable.hitboxKBPhysics["AngularVelocity"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass ~= nil and combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber] 
				HitboxTable.hitboxKBPhysics["AngularVelocity"].force = combatDataVariable.force[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.force[module.keyframeHitboxLoaderNumber] 
				HitboxTable.hitboxKBPhysics["AngularVelocity"].maxTorque = combatDataVariable.maxTorque[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.maxTorque[module.keyframeHitboxLoaderNumber] 

			else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "AlignPosition" then
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.relativeTo = combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber] 
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.mode = combatDataVariable.mode[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.mode[module.keyframeHitboxLoaderNumber] 
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.forceLimitsMode = combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] 
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["Magnitude"].maxVelocity = combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] == "Magnitude" and combatDataVariable.maxVelocity[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["Magnitude"].responsiveness = combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] == "Magnitude" and combatDataVariable.responsiveness[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.perAxisRelative = combatDataVariable.perAxisRelative[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.perAxisRelative[module.keyframeHitboxLoaderNumber] 
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["PerAxis"].maxAxesForce = combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] == "PerAxis" and combatDataVariable.maxAxesForce[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["PerAxis"].maxVelocity = combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] == "PerAxis" and combatDataVariable.maxVelocity[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["PerAxis"].responsiveness = combatDataVariable.forceLimitsMode[module.keyframeHitboxLoaderNumber] == "PerAxis" and combatDataVariable.responsiveness[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].reactionForceEnabled = combatDataVariable.reactionForceEnabled[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.reactionForceEnabled[module.keyframeHitboxLoaderNumber]
					HitboxTable.hitboxKBPhysics["AlignPosition"].rigidityEnabled = combatDataVariable.rigidityEnabled[module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.rigidityEnabled[module.keyframeHitboxLoaderNumber]

				else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "AlignOrientation" then
						HitboxTable.hitboxKBPhysics["AlignOrientation"].clientSelection.mode = combatDataVariable.mode[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.mode[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
						HitboxTable.hitboxKBPhysics["AlignOrientation"].clientSelection.alignType = combatDataVariable.alignType[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.alignType[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
						HitboxTable.hitboxKBPhysics["AlignOrientation"].reactionTorqueEnabled = combatDataVariable.reactionTorqueEnabled[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.reactionTorqueEnabled[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
						HitboxTable.hitboxKBPhysics["AlignOrientation"].rigidityEnabled = combatDataVariable.rigidityEnabled[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.rigidityEnabled[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
						HitboxTable.hitboxKBPhysics["AlignOrientation"].maxAngularVelocity = combatDataVariable.maxAngularVelocity[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.maxAngularVelocity[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
						HitboxTable.hitboxKBPhysics["AlignOrientation"].maxTorque = combatDataVariable.maxTorque[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.maxTorque[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
						HitboxTable.hitboxKBPhysics["AlignOrientation"].responsiveness = combatDataVariable.responsiveness[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.responsiveness[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]

					else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "Torque" then
							HitboxTable.hitboxKBPhysics["Torque"].clientSelection.relativeTo = combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.relativeTo[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
							HitboxTable.hitboxKBPhysics["Torque"].torque = combatDataVariable.torque[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.torque[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]

						else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "LineForce" then
								HitboxTable.hitboxKBPhysics["LineForce"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.applyAtCenterOfMass[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
								HitboxTable.hitboxKBPhysics["LineForce"].inverseSquareLaw = combatDataVariable.inverseSquareLaw[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.inverseSquareLaw[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
								HitboxTable.hitboxKBPhysics["LineForce"].magnitude = combatDataVariable.magnitude[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.magnitude[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
								HitboxTable.hitboxKBPhysics["LineForce"].reactionForceEnabled = combatDataVariable.reactionForceEnabled[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber] ~= nil and combatDataVariable.reactionForceEnabled[module.keyframeHitboxLoaderNumber][module.keyframeHitboxLoaderNumber]
								
							else if combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber] == "None" then
									--No data should be given
								end		
							end

						end					
					end

				end 	
			end
		end
	end
	return combatDataVariable.physicsType[module.keyframeHitboxLoaderNumber]
end


function module.HitboxDetailLoader(keyframe, keyframePoint, combatDataVariable)
	
	
	if module.keyframeHitboxLoaderNumber <= #keyframePoint then
		

		if keyframe == keyframePoint[module.keyframeHitboxLoaderNumber] then
			
			--characterStateModule.generalTableValueSetter("characterAnimationSpeed",0.3)
			
			for index=1,combatDataVariable.hitboxHitCount ,1 do
			--check if entry is a table, if so we want to loop
				HitboxTable.hitboxStyle = combatDataVariable.hitboxStyle[module.keyframeHitboxLoaderNumber] -- make this a table with an increment
				HitboxTable.damage = combatDataVariable.hitboxHitCount < 3 and combatDataVariable.hitboxDamage[module.keyframeHitboxLoaderNumber] or combatDataVariable.hitboxDamage[module.hitCountScoreKeeper]
				HitboxTable.duration = combatDataVariable.hitboxHitCount < 3 and combatDataVariable.hitstunDuration[module.keyframeHitboxLoaderNumber] or combatDataVariable.hitstunDuration[module.hitCountScoreKeeper]
				HitboxTable.hitboxTime = combatDataVariable.hitboxTime[module.keyframeHitboxLoaderNumber]
				HitboxTable.size = combatDataVariable.hitboxHitCount < 3 and combatDataVariable.hitboxSize[module.keyframeHitboxLoaderNumber] or combatDataVariable.hitboxSize[module.hitCountScoreKeeper]
				HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
				HitboxTable.knockback = module.processKnockbackValue(combatDataVariable)
				-- we need an if statement or a ternary to edit details of the table, then select the type as a result		
				HitboxTable.attacker = MainModule.player
				HitboxTable.attackerPlayer = MainModule.player.Character
				HitboxTable.attackerHumanoidRootPart = MainModule.player.Character.HumanoidRootPart
				HitboxTable.msg = combatDataVariable.hitboxMessage[module.keyframeHitboxLoaderNumber]
				local hitboxLocationPath = combatDataVariable.hitboxLocation[module.keyframeHitboxLoaderNumber].Parent == MainModule.player.Character and combatDataVariable.hitboxLocation[module.keyframeHitboxLoaderNumber] or module.fixPlayerCharacterPath(combatDataVariable.hitboxLocation[module.keyframeHitboxLoaderNumber])
				HitboxTable.location = hitboxLocationPath
				HitboxTable.validLocation = combatDataVariable.validationLocation[module.keyframeHitboxLoaderNumber]
				HitboxTable.cframe = combatDataVariable.validationCFrame[module.keyframeHitboxLoaderNumber]
				HitboxTable.validSize = combatDataVariable.validationSize[module.keyframeHitboxLoaderNumber]
				HitboxTable.validation = combatDataVariable.isValidation[module.keyframeHitboxLoaderNumber]
				HitboxTable.magnitudeRange = combatDataVariable.hitboxMagnitudeRange[module.keyframeHitboxLoaderNumber]
				HitboxTable.hitboxPhysicsChoice = module.physicsWriter(combatDataVariable)
				HitboxTable.hitboxChoice = combatDataVariable.hitboxType[module.keyframeHitboxLoaderNumber]
				HitboxTable.hitboxDestoryOnSingleHit = combatDataVariable.hitboxDestoryOnSingleHit[module.keyframeHitboxLoaderNumber]
				HitboxTable.hitStop = combatDataVariable.hitStop[module.keyframeHitboxLoaderNumber]
				characterStateModule.generalTableValueSetter("hitStopCooldownCounter", HitboxTable.hitStop)
				print("HITBOXU: ", HitboxTable)
				print("HITBOX HitstoppU: ", HitboxTable.hitStop)



				if HitboxTable.hitboxStyle == "Hitbox" then

					if combatDataVariable.hitboxType[module.keyframeHitboxLoaderNumber] == HelperModule.hitboxTable.hitboxType.newHitbox then
						MainModule.BoundingRayBox(HitboxTable)
					elseif combatDataVariable.hitboxType[module.keyframeHitboxLoaderNumber] == HelperModule.hitboxTable.hitboxType.magnitudeHitbox then
						MainModule.MagnitudeHitbox(HitboxTable)
					else if combatDataVariable.hitboxType[module.keyframeHitboxLoaderNumber] == HelperModule.hitboxTable.hitboxType.legacyHitbox then
							MainModule.CreateHitbox(HitboxTable)	
						end
					end

				end

				if HitboxTable.hitboxStyle == "Projectile"  then
					HitboxTable.attackerMouse = combatDataVariable.playerMouse
					HitboxTable.projectileSource = combatDataVariable.projectileSource[module.keyframeHitboxLoaderNumber]
					HitboxTable.projectileForce = combatDataVariable.projectileForce[module.keyframeHitboxLoaderNumber]
					HitboxTable.projectileOrientation = combatDataVariable.projectileOrientation[module.keyframeHitboxLoaderNumber]
					HitboxTable.projectileDirectionAndUnit = combatDataVariable.projectileDirectionAndUnit[module.keyframeHitboxLoaderNumber]
					HitboxTable.projectileDuration = combatDataVariable.projectileDuration[module.keyframeHitboxLoaderNumber]
					HitboxTable.projectileActive = combatDataVariable.projectileActive[module.keyframeHitboxLoaderNumber]

					--module.processProjectileFireSource(combatDataVariable)
					HitboxTable.projectileTravelSpeed = module.processProjectileFireSource(combatDataVariable) --combatDataVariable.projectileVelocity
					-- FireServer
					-- Server sendss back information to mainScript to create Projectile
					-- Projectile Chooses hitbox System and send details over to make hitbox valid
					-- Same deal for rayhitbox and throws, etc
					-- projectile stuff
					--module.keyframeHitboxLoaderNumber += 1
					eventSendToServerCast:FireServer(HitboxTable)

				end
				--if goes here to increment
				if (combatDataVariable.hitboxHitCount > 2 and #keyframePoint==1) and (index == 1 or index == combatDataVariable.hitboxHitCount-1) then
					--val should only update when parameters are above figure out logic
					-- increase hit count to amount to be used for use
					module.hitCountScoreKeeper += 1
					--add to a new val to increment
				end
			end
		module.keyframeHitboxLoaderNumber += 1
		module.hitCountScoreKeeper = 1
		
		end
	end

end


function module.MeleeCombo()
	--local combatData = require(combatDataReceiver.CombatData)
	if module.debounce == false then
		module.debounce = true
		characterStateModule.cooldownYield = true
		
		print("Combat Data Library: ", #combatData["Melee"])
		characterStateModule.randomNumberTest = math.random(50,77)
		characterStateModule.mainPlayer = game.Players.LocalPlayer
		if characterStateModule.combo > #combatData["Melee"] then --3
			module.combo = 1
			characterStateModule.comboIncrementCounterAssitant = 1
			--characterStateModule.combo = 1
			characterStateModule.generalTableValueSetter("combo", characterStateModule.comboIncrementCounterAssitant)
		end
		-- ^ move this block of code to CharacterStateModule, to recreate combo
		--Grab Generic Details from a table
		--if combo is, number, load action
		--local currentThreadCombo = characterStateModule.comboIncrementCounterAssitant--module.combo--characterStateModule.combo--characterStateModule.combo
		--PLEASE USE CURRENT THREAD COMBO TO REPLACE ALL INSTANCES OF YOUR STUFF
		
		local combatAnimationParameters = {
			combatAnimationField = combatData["Animations"][3],
		}
		
		local check = "serverCheck"	
		
		--Animation Reading--
		local animationKeyPairResult = module.genericKeyPairSearch(
			combatAnimationParameters.combatAnimationField,
			characterStateModule.generalTableValueGetter("combo")--currentThreadCombo--currentThreadCombo
		)
		------------------------------------------------------------
		
		local animation = Instance.new("Animation") --Correcting this so we dont keep creating 
		animation.Parent = MainModule.player.Character--playerX.Character
		animation.Name= combatData["Animations"][1].animName --"module.AninimationName "Slash""
		animation.AnimationId = animationKeyPairResult--combatData["Animations"][3].meleeOne --Needs to end here
		event:FireServer(MainModule.player,check)
		local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animation)
	
		animPlay:Play()
		--animPlay:AdjustSpeed(HelperModule.hitboxTable.animationSpeed)
		--characterStateModule.generalTableValueSetter("characterAnimationSpeed",characterStateModule.characterAnimationSpeedNumberHolder)
		animPlay:AdjustSpeed(characterStateModule.animationModuleScript.generalTableValueGetter("generalAnimationSpeed"))
		
	
		local keyFrameTable = combatData["Melee"][characterStateModule.generalTableValueGetter("combo")]["keyframe"]--currentThreadCombo--characterStateModule.combo --currentThreadCombo
		print("COMBO COUNTER: ", characterStateModule.generalTableValueGetter("combo"))
	
		animPlay.KeyframeReached:Connect(function(keyframe)
			--animPlay:AdjustSpeed(characterStateModule.generalTableValueGetter("characterAnimationSpeed"))
			module.HitboxDetailLoader(keyframe,keyFrameTable,combatData["Melee"][characterStateModule.generalTableValueGetter("combo")])--characterStateModule.combo
			
			
			--module.TestGrid(keyframe)
			print("ANIMATION CURRENT SPEEDER: ",characterStateModule.generalTableValueGetter("characterAnimationSpeed"))
		end)
		
		--If animation is slow, it needs to yield the wait speed otherwise
		-- combo gets incremented
		-- We need a way to check if animation is done playing
		
		---Attack Ended ----
		animPlay.Stopped:Connect(function()
			module.keyframeHitboxLoaderNumber = 1
			print("RESULT EXAMPLE ENDER: ", characterStateModule.comboCooldown)
			characterStateModule.generalTableValueSetter("meleeComboStopped", true)
			--------ComboIncrement----------
			module.comboIncrement(characterStateModule.comboIncrementCounterAssitant) --currentThreadCombo
			
			
			--print("COMBO GET: ", characterStateModule.generalTableValueGetter("combo"))
			-----------------------------------------------------------------
			
			
			--print("FULL TABLE: ", combatData["Melee"][characterStateModule.generalTableValueGetter("combo")]) --currentThreadCombo
			if characterStateModule.generalTableValueGetter("combo") > #combatData["Melee"] then
				characterStateModule.comboCooldownCounterAssistant=((60*(combatData["Melee"][characterStateModule.generalTableValueGetter("combo")-1]["attackCooldown"])))
			else
				characterStateModule.comboCooldownCounterAssistant=((60*(combatData["Melee"][characterStateModule.generalTableValueGetter("combo")]["attackCooldown"])))
			end
			--FRAME: (60/60) = 1 frame, Formula: 60x10 -- this will create 10 second cool down
			characterStateModule.generalTableValueSetter("comboCooldown", characterStateModule.comboCooldownCounterAssistant)
			characterStateModule.cooldownYield = false
			animation:Destroy()
			--Cooldown is needed before returning back to increment of 1, maybe each hit can have a cooldown period
			--Jab could likely be loopable if someone were to delay
		end)
		
		--animPlay.Stopped:Connect(module.comboIncrement,animation)
		--animation:Destroy()
	end

end

return module
