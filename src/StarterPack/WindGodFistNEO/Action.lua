local UIS = game:GetService("UserInputService")

local replicatedStorage = game.ReplicatedStorage
--local serverStorage = game.ServerStorage
local event2 = game.ReplicatedStorage.Events.MainAction
local playerX = game.Players.LocalPlayer
--local EffectLib = require(playerX.Character:WaitForChild("ClientSideEffects"))
local MainModule = require(replicatedStorage.CharacterScripts.MainScript)
local HelperModule = require(replicatedStorage.CharacterScripts.HelperTable)
local HitboxTable = HelperModule.hitboxTable
local combatData = require(script.Parent.CombatData)

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
	check ="serverCheck",
	name = "Slash",
	hitboxMsg="msg"
	
}

function module.comboIncrement(animation)
	print("ANIMATION ALLOWED: ",animation)
	module.debounce = false
	module.combo += 1
	print(animation)
	--animation:Destroy()
end

function module.genericKeyPairSearch(combatDataFields ,combatDataKeyGoal)
	for key, value in pairs(combatDataFields) do
		-- Should choose animation by combo
		if key == combatDataKeyGoal then
		--	print("COMBATTT: ",key ,value)
			return value
		end
	end
	
end

function module.processKnockbackValue(combatDataVariable)
	print("HUMANOID HITTER: ", combatDataVariable.hitboxKnockbackMultiplier)
	-- Please use 1 as the lowest knockback value
	local knockbackValue = 1

	HelperModule.hitboxTable.knockbackMultiplier = combatDataVariable.hitboxKnockbackMultiplier
	HelperModule.hitboxTable.upForce = Vector3.new(
		combatDataVariable.hitboxKnockbackVictimDirection["kbX"], 
		combatDataVariable.hitboxKnockbackVictimDirection["kbY"],
		combatDataVariable.hitboxKnockbackVictimDirection["kbZ"]
	)
	HelperModule.hitboxTable.hitboxPhysicsChoice = combatDataVariable.physicsType
	print("UPFORCE: ", HelperModule.hitboxTable.upForce)
	print("KNOCKBACK Z: ", knockbackValue)
	return knockbackValue
end

--Hitboxes
--runAttack(keyframe, keyframePoint, combatData)

function module.physicsWriter(combatDataVariable)
	print(HitboxTable)
	print("PHYSICS TYPE: ", combatDataVariable.physicsType)
	
	if combatDataVariable.physicsType == "LinearVelocity" then

		HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode = combatDataVariable.velocityConstraintMode
		--Required Vector should update these elements only through ternary
		---Vector--
		print("RELATIVITY TO: ", combatDataVariable.relativeTo)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.relativeTo = combatDataVariable.relativeTo
		print("CLIENT Selection Choice: ", HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.relativeTo)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[HitboxTable.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode].vectorVelocity = combatDataVariable.velocityConstraintMode == "Vector" and module.processKnockbackValue(combatDataVariable)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[combatDataVariable.velocityConstraintMode].forceLimitsEnabled =  combatDataVariable.velocityConstraintMode == "Vector" and combatDataVariable.forceLimitsEnabled
	
		--Line--
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Line"].lineDirection =  combatDataVariable.velocityConstraintMode == "Line" and module.processKnockbackValue(combatDataVariable)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Line"].lineVelocity = combatDataVariable.velocityConstraintMode == "Line" and 75-- ternary force used to push the object, good for projectiles
		--Plane--
		
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Plane"].planeVelocity = combatDataVariable.velocityConstraintMode == "Plane" and Vector2.new(module.processKnockbackValue(combatDataVariable).X, module.processKnockbackValue(combatDataVariable).Y)
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Plane"].primaryTangentAxis = combatDataVariable.velocityConstraintMode == "Plane" and combatDataVariable.primaryTangentAxis -- check if nil
		HitboxTable.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode["Plane"].secondaryTangentAxis = combatDataVariable.velocityConstraintMode == "Plane" and combatDataVariable.secondaryTangentAxis -- if nil


	else if combatDataVariable.physicsType == "VectorForce" then
			print("VECTORALALALA")
			HitboxTable.hitboxKBPhysics["VectorForce"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass ~= nil and combatDataVariable.applyAtCenterOfMass  -- if variable exist add num, else do nothing
			HitboxTable.hitboxKBPhysics["VectorForce"].clientSelection.relativeTo = combatDataVariable.relativeTo ~= nil and combatDataVariable.relativeTo --nil relativity if
			HitboxTable.hitboxKBPhysics["VectorForce"].force = combatDataVariable.force ~= nil and module.processKnockbackValue(combatDataVariable)--combatDataVariable.force 

		else if combatDataVariable.physicsType == "AngularVelocity" then 
				HitboxTable.hitboxKBPhysics["AngularVelocity"].clientSelection.relativeTo = combatDataVariable.relativeTo ~= nil and combatDataVariable.relativeTo  
				HitboxTable.hitboxKBPhysics["AngularVelocity"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass ~= nil and combatDataVariable.applyAtCenterOfMass 
				HitboxTable.hitboxKBPhysics["AngularVelocity"].force = combatDataVariable.force ~= nil and combatDataVariable.force 
				HitboxTable.hitboxKBPhysics["AngularVelocity"].maxTorque = combatDataVariable.maxTorque ~= nil and combatDataVariable.maxTorque 

			else if combatDataVariable.physicsType == "AlignPosition" then
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.relativeTo = combatDataVariable.relativeTo ~= nil and combatDataVariable.relativeTo 
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.mode = combatDataVariable.mode ~= nil and combatDataVariable.mode 
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.forceLimitsMode = combatDataVariable.forceLimitsMode ~= nil and combatDataVariable.forceLimitsMode 
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["Magnitude"].maxVelocity = combatDataVariable.forceLimitsMode == "Magnitude" and combatDataVariable.maxVelocity
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["Magnitude"].responsiveness = combatDataVariable.forceLimitsMode == "Magnitude" and combatDataVariable.responsiveness
					HitboxTable.hitboxKBPhysics["AlignPosition"].clientSelection.perAxisRelative = combatDataVariable.perAxisRelative ~= nil and combatDataVariable.perAxisRelative 
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["PerAxis"].maxAxesForce = combatDataVariable.forceLimitsMode == "PerAxis" and combatDataVariable.maxAxesForce
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["PerAxis"].maxVelocity = combatDataVariable.forceLimitsMode == "PerAxis" and combatDataVariable.maxVelocity
					HitboxTable.hitboxKBPhysics["AlignPosition"].forceLimitsMode["PerAxis"].responsiveness = combatDataVariable.forceLimitsMode == "PerAxis" and combatDataVariable.responsiveness
					HitboxTable.hitboxKBPhysics["AlignPosition"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass ~= nil and combatDataVariable.applyAtCenterOfMass
					HitboxTable.hitboxKBPhysics["AlignPosition"].reactionForceEnabled = combatDataVariable.reactionForceEnabled ~= nil and combatDataVariable.reactionForceEnabled
					HitboxTable.hitboxKBPhysics["AlignPosition"].rigidityEnabled = combatDataVariable.rigidityEnabled ~= nil and combatDataVariable.rigidityEnabled

				else if combatDataVariable.physicsType == "AlignOrientation" then
						HitboxTable.hitboxKBPhysics["AlignOrientation"].clientSelection.mode = combatDataVariable.mode ~= nil and combatDataVariable.mode
						HitboxTable.hitboxKBPhysics["AlignOrientation"].clientSelection.alignType = combatDataVariable.alignType ~= nil and combatDataVariable.alignType
						HitboxTable.hitboxKBPhysics["AlignOrientation"].reactionTorqueEnabled = combatDataVariable.reactionTorqueEnabled ~= nil and combatDataVariable.reactionTorqueEnabled
						HitboxTable.hitboxKBPhysics["AlignOrientation"].rigidityEnabled = combatDataVariable.rigidityEnabled ~= nil and combatDataVariable.rigidityEnabled
						HitboxTable.hitboxKBPhysics["AlignOrientation"].maxAngularVelocity = combatDataVariable.maxAngularVelocity ~= nil and combatDataVariable.maxAngularVelocity
						HitboxTable.hitboxKBPhysics["AlignOrientation"].maxTorque = combatDataVariable.maxTorque ~= nil and combatDataVariable.maxTorque
						HitboxTable.hitboxKBPhysics["AlignOrientation"].responsiveness = combatDataVariable.responsiveness ~= nil and combatDataVariable.responsiveness

					else if combatDataVariable.physicsType == "Torque" then
							HitboxTable.hitboxKBPhysics["Torque"].clientSelection.relativeTo = combatDataVariable.relativeTo ~= nil and combatDataVariable.relativeTo
							HitboxTable.hitboxKBPhysics["Torque"].torque = combatDataVariable.torque ~= nil and combatDataVariable.torque

						else if combatDataVariable.physicsType == "LineForce" then
								HitboxTable.hitboxKBPhysics["LineForce"].applyAtCenterOfMass = combatDataVariable.applyAtCenterOfMass ~= nil and combatDataVariable.applyAtCenterOfMass
								HitboxTable.hitboxKBPhysics["LineForce"].inverseSquareLaw = combatDataVariable.inverseSquareLaw ~= nil and combatDataVariable.inverseSquareLaw
								HitboxTable.hitboxKBPhysics["LineForce"].magnitude = combatDataVariable.magnitude ~= nil and combatDataVariable.magnitude
								HitboxTable.hitboxKBPhysics["LineForce"].reactionForceEnabled = combatDataVariable.reactionForceEnabled ~= nil and combatDataVariable.reactionForceEnabled
								
							else if combatDataVariable.physicsType == "None" then
									--No data should be given
								end		
							end

						end					
					end

				end 	
			end
		end
	end
	return combatDataVariable.physicsType
end


function module.HitboxDetailLoader(keyframe, keyframePoint, combatDataVariable)

	
	if keyframe == keyframePoint[1] then --"Keyframe"
		HitboxTable.location = combatDataVariable.hitboxLocation
		HitboxTable.damage = combatDataVariable.hitboxDamage
		HitboxTable.duration = combatDataVariable.hitstunDuration
		HitboxTable.hitboxTime = combatDataVariable.hitboxTime
		HitboxTable.size = combatDataVariable.hitboxSize
		HitboxTable.force = Vector3.new(math.huge,math.huge,math.huge)
		HitboxTable.knockback = module.processKnockbackValue(combatDataVariable)
		-- we need an if statement or a ternary to edit details of the table, then select the type as a result		
		
		HitboxTable.attacker = MainModule.player
		HitboxTable.attackerPlayer = MainModule.player.Character
		HitboxTable.attackerHumanoidRootPart = MainModule.player.Character.HumanoidRootPart
		HitboxTable.msg = combatDataVariable.hitboxMessage

		HitboxTable.validLocation = combatDataVariable.validationLocation
		HitboxTable.cframe = combatDataVariable.validationCFrame
		HitboxTable.validSize = combatDataVariable.validationSize
		HitboxTable.validation = combatDataVariable.isValidation
		HitboxTable.magnitudeRange = combatDataVariable.hitboxMagnitudeRange
		HitboxTable.hitboxPhysicsChoice = module.physicsWriter(combatDataVariable)

		--print(HitboxTable.cframe)
		if combatDataVariable.hitboxType == HelperModule.hitboxTable.hitboxType.newHitbox then
			MainModule.BoundingRayBox(HitboxTable)
		elseif combatDataVariable.hitboxType == HelperModule.hitboxTable.hitboxType.magnitudeHitbox then
			MainModule.MagnitudeHitbox(HitboxTable)
		else if combatDataVariable.hitboxType == HelperModule.hitboxTable.hitboxType.legacyHitbox then
			MainModule.CreateHitbox(HitboxTable)	
			end
		end
		
	end
	
end

function module.MeleeCombo()
	if module.debounce == false then
		module.debounce = true
		print(module.combo)
		
		if module.combo > 3 then
			module.combo = 1
		end

		--Grab Generic Details from a table
		--if combo is, number, load action
		local combatAnimationParameters = {
			combatAnimationField = combatData["Animations"][3],
		}
		
		local check = "serverCheck"
		print(combatAnimationParameters)
		local animationKeyPairResult = module.genericKeyPairSearch(
			combatAnimationParameters.combatAnimationField,
			module.combo
		)
		local animation = Instance.new("Animation") --Correcting this so we dont keep creating 
		animation.Parent = MainModule.player.Character--playerX.Character
		animation.Name= combatData["Animations"][1].animName --"module.AninimationName "Slash""
		animation.AnimationId = animationKeyPairResult--combatData["Animations"][3].meleeOne --Needs to end here
		event2:FireServer(MainModule.player,check)
		local animPlay = MainModule.player.Character.Humanoid.Animator:LoadAnimation(animation)
	
		animPlay:Play()
		animPlay:AdjustSpeed(HelperModule.hitboxTable.animationSpeed)
	
		local keyFrameTable = combatData["Melee"][module.combo]["keyframe"]
		print(keyFrameTable)
		print(module.combo)
	
		animPlay.KeyframeReached:Connect(function(keyframe)
			--Multi hit logic needs to be added for loops
			
			module.HitboxDetailLoader(keyframe,keyFrameTable,combatData["Melee"][module.combo])
		end)
		
		--If animation is slow, it needs to yield the wait speed otherwise
		-- combo gets incremented
		-- We need a way to check if animation is done playing
		
	--	wait(1)
		--(nil,animation)
		animPlay.Stopped:Connect(function()
			module.comboIncrement(animation)
		end)
		
		--animPlay.Stopped:Connect(module.comboIncrement,animation)
		--animation:Destroy()
	end

end

return module
