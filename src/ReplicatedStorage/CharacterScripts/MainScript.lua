local animationList = require(script.Parent.Animations)
local playerSample = game.Players.LocalPlayer

local Main = {
	-----------------------------------------------------------
	-- Character State Value
	-----------------------------------------------------------
	
	characterStates = playerSample:FindFirstChild("CharacterSample").CharacterState.CharacterStateModule,
	enemySubjectList = {},
--	activeState = playerSample:FindFirstChild("CharacterSample").CharacterState.ActiveState,
--	hitboxLocation =  playerSample:FindFirstChild("CharacterSample").CharacterState.HitboxLocation,
--	hitboxTime =  playerSample:FindFirstChild("CharacterSample").CharacterState.HitboxTime,
--	hitstun =  playerSample:FindFirstChild("CharacterSample").CharacterState.Hitstun,
--	hurtboxLocation =  playerSample:FindFirstChild("CharacterSample").CharacterState.HurtboxLocation,
--	knockdown =  playerSample:FindFirstChild("CharacterSample").CharacterState.Knockdown,
--	isCrouching =  playerSample:FindFirstChild("CharacterSample").CharacterState.isCrouching,
--	isDashing =  playerSample:FindFirstChild("CharacterSample").CharacterState.isDashing,
--	isGuarding =  playerSample:FindFirstChild("CharacterSample").CharacterState.isGuarding,
--	hitstunDuration = playerSample:FindFirstChild("CharacterSample").CharacterState.HitstunDuration,

	--------------------------------------------------------------
	-- Generics
	--------------------------------------------------------------
	player = game.Players.LocalPlayer,
	char= game.Players.LocalPlayer:FindFirstChild("Character"), --.Character
	--humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"),
	
}

local event = game.ReplicatedStorage.Events.MainAction
local eventClient = game.ReplicatedStorage.Events.MainActionClient
local HelperModule = require(game.ReplicatedStorage.CharacterScripts.HelperTable)
local runService = game:GetService("RunService")
local collisionGroupPlayer = "PlayerCollision"
local collisionGroupHitPlayer = "HitPlayerCollision"
local collisionRayGroup = "RayGroup"
local connector
--local HitboxTable = HelperModule.hitboxTable
local characterStatesTable = require(Main.characterStates)
local debounce = false
local debounce2 = false
local debounceHitCheck = false



---Physics Body Movers --
----[[
function Main.BodyVelocity(parent, object)--force, direction, waitTime)--(parent,table)
	--Deprecated
	local humanStateFalling = Enum.HumanoidStateType.FallingDown

	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local bodyVelocity = Instance.new("BodyVelocity")

	bodyVelocity.Parent = parent
	bodyVelocity.MaxForce = object.force--Force
	bodyVelocity.Velocity = object.knockback --Direction
	wait(object.duration)--Wait
	bodyVelocity:Destroy()
	-- ALL CLEAR
end
--]]--
--FOR NEW PHYSICS, WE WANT TO EDIT THE HELPERTABLE'S ClientSelection
--ClientSelection is what is processed through each pipeline

function Main.LinearVelocity(parent, object)
	-- Used for constant force pushes, similar to BodyVelocity
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	
--	print("PARENTER: ", parent)
--	print("OBJECTR: ", object)
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local linearVelocity = Instance.new("LinearVelocity")
	local attachment0 = Instance.new("Attachment")
	
	linearVelocity.Parent = parent
	attachment0.Parent = parent
	
	-- add attachment support later
	linearVelocity.Attachment0 = attachment0
	--Vector--
	--print("LINEVELO PARENT: ", parent)
	--print("LINEVELO object: ", object)
	
	local clientSelect = object.hitboxKBPhysics["LinearVelocity"].clientSelection
	print("PHYSICS X: ", object.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode)
	if object.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode == "Vector" then
		linearVelocity.VelocityConstraintMode = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].constraint
		print("DASHU: ", object.hitboxKBPhysics["LinearVelocity"].clientSelection)
		linearVelocity.RelativeTo = object.hitboxKBPhysics["LinearVelocity"].relativeTo[clientSelect.relativeTo]
		linearVelocity.Color = BrickColor.new("Gold")
		linearVelocity.Visible = true
		linearVelocity.MaxForce = 999*99*99
		object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].vectorVelocity = object.knockback
		print("VECTOR VELOCITY EXAMPU: ", object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode])
		print("THE OBJECTVEL: ", object.knockback)
		print("clientUser: ", object.hitboxKBPhysics["LinearVelocity"])
		linearVelocity.VectorVelocity = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].vectorVelocity
	end
	
	-- Plane --
	
	if object.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode == "Plane" then
		object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].planeVelocity = Vector2.new(object.knockback.X,object.knockback.Y)
		linearVelocity.VelocityConstraintMode = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].constraint
		linearVelocity.MaxForce = 999*99*99
		linearVelocity.PlaneVelocity = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].planeVelocity
		linearVelocity.PrimaryTangentAxis = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].primaryTangentAxis
		linearVelocity.SecondaryTangentAxis = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].secondaryTangentAxis
		
	end
	-- Line --
	if object.hitboxKBPhysics["LinearVelocity"].clientSelection.velocityConstraintMode == "Line" then
		linearVelocity.VelocityConstraintMode = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].constraint
		linearVelocity.MaxForce = 999*99*99
		object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].lineDirection = object.knockback
		linearVelocity.LineDirection = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].lineDirection
		object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].lineVelocity = object.knockbackMultiplier
		linearVelocity.LineVelocity = object.hitboxKBPhysics["LinearVelocity"].velocityConstraintMode[clientSelect.velocityConstraintMode].lineVelocity
	end
	
	print("WAIT TIME: ",object.duration )

	if object.hitboxStyle == "Projectile" and object.projectileActive == true then
		--might need a statement, for when hitbox loads
		--[[
		local function projectileLifeTime ()
			wait(object.projectileDuration/10)
			linearVelocity:Destroy()
			attachment0:Destroy()
			return nil
		end
		]]--
		--local thread = coroutine.create(projectileLifeTime)

		wait(object.projectileDuration/10)
		linearVelocity:Destroy()
		attachment0:Destroy()
		return nil
	end
	wait(object.duration/10)
	print("AIR SLASHER")
	
	linearVelocity:Destroy()
	attachment0:Destroy()

end

function Main.VectorForce(parent, object)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local vectorForce = Instance.new("VectorForce")
	local attachment0 = Instance.new("Attachment")
	
	vectorForce.Parent = parent
	attachment0.Parent = parent
	--vectorForce.MaxForce = 999*99*99
	local clientSelect = object.hitboxKBPhysics["VectorForce"].clientSelection
	print("VECTOR ZZ: ", object.hitboxKBPhysics["VectorForce"].relativeTo[clientSelect.relativeTo])
	--
	-- add attachment support later
	print("VECTOR FORCE!")
	vectorForce.Attachment0 = attachment0
	vectorForce.RelativeTo = object.hitboxKBPhysics["VectorForce"].relativeTo[clientSelect.relativeTo]
	vectorForce.ApplyAtCenterOfMass = object.hitboxKBPhysics["VectorForce"].applyAtCenterOfMass
	vectorForce.Force = object.knockback
	
	print("WAIT TIME: ",object.duration )
	wait(object.duration/10)
	print("WAIT TIME AFTER: ",object.duration )
	vectorForce:Destroy()
	attachment0:Destroy()


end

function Main.AngularVelocity(parent, object)
	--ANGULAR VELOCITY
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local angularVelocity = Instance.new("AngularVelocity")
	local attachment0 = Instance.new("Attachment")
	
	local clientSelect = object.hitboxKBPhysics["AngularVelocity"].clientSelection
	angularVelocity.Parent = parent
	attachment0.Parent = parent
	
	angularVelocity.Attachment0 = attachment0
	angularVelocity.AngularVelocity = object.knockback
	angularVelocity.Torque = 100000
	
	wait(object.duration/10)
	angularVelocity:Destroy()
	attachment0:Destroy()

end

function Main.AlignPosition(parent, object)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local alignPosition = Instance.new("AlignPosition")
	local attachment0 = Instance.new("Attachment")

	local clientSelect = object.hitboxKBPhysics["AlignPosition"].clientSelection
	alignPosition.Parent = parent
	attachment0.Parent = parent
	
	alignPosition.Attachment0 = attachment0
	
	alignPosition.Mode = object.hitboxKBPhysics["AlignPosition"].mode[clientSelect.mode]
	alignPosition.ApplyAtCenterOfMass = object.hitboxKBPhysics["AlignPosition"].applyAtCenterOfMass
	alignPosition.ReactionForceEnabled = object.hitboxKBPhysics["AlignPosition"].reactionForceEnabled
	alignPosition.RigidityEnabled = object.hitboxKBPhysics["AlignPosition"].rigidityEnabled 
	

	if object.hitboxKBPhysics["AlignPosition"].clientSelection.forceLimitMode == "Magnitude" then
		alignPosition.ForceLimitMode = object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode]
		-- add align magnitude details
		alignPosition.MaxVelocity = object.knockback --object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode].maxVelocity
		alignPosition.Responsiveness = object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode].responsiveness
	end
	
	if object.hitboxKBPhysics["AlignPosition"].clientSelection.forceLimitMode == "PerAxis" then
		alignPosition.ForceLimitMode = object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode]
		-- add align perAxis details
		alignPosition.ForceRelativeTo = object.hitboxKBPhysics["AlignPosition"].relativeTo[clientSelect.relativeTo]
		alignPosition.MaxAxesForce = object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode].maxAxesForce
		alignPosition.Responsiveness = object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode].responsiveness
		alignPosition.MaxVelocity = object.knockback --object.hitboxKBPhysics["AlignPosition"].forceLimitMode[clientSelect.forceLimitMode].maxVelocity
	end
	
	wait(object.duration/10)
	alignPosition:Destroy()
	attachment0:Destroy()
	
	print("ALIGN POS: ", alignPosition)
		
	--alignPosition.AngularVelocity = object.knockback
	
end

function Main.AlignOrientation(parent, object)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local alignOrientation = Instance.new("AlignOrientation")
	local attachment0 = Instance.new("Attachment")

	local clientSelect = object.hitboxKBPhysics["AlignOrientation"].clientSelection
	alignOrientation.Parent = parent
	attachment0.Parent = parent

	alignOrientation.Attachment0 = attachment0
	
	alignOrientation.Mode = object.hitboxKBPhysics["AlignOrientation"].mode[clientSelect.mode]
	alignOrientation.AlignType = object.hitboxKBPhysics["AlignOrientation"].alignType[clientSelect.alignType]
	
	alignOrientation.ReactionTorqueEnabled = object.hitboxKBPhysics["AlignOrientation"].reactionTorquedEnabled
	alignOrientation.RigidityEnabled = object.hitboxKBPhysics["AlignOrientation"].rigidityEnabled
	alignOrientation.MaxAngularVelocity = object.hitboxKBPhysics["AlignOrientation"].maxAngularVelocity
	alignOrientation.MaxTorque = object.hitboxKBPhysics["AlignOrientation"].maxTorque
	alignOrientation.Responsiveness = object.hitboxKBPhysics["AlignOrientation"].responsiveness

	wait(object.duration/10)
	alignOrientation:Destroy()
	attachment0:Destroy()

end

function Main.Torque(parent, object)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local torque = Instance.new("Torque")
	local attachment0 = Instance.new("Attachment")

	local clientSelect = object.hitboxKBPhysics["AlignOrientation"].clientSelection
	torque.Parent = parent
	attachment0.Parent = parent

	torque.Attachment0 = attachment0
	
	torque.Torque = object.hitboxKBPhysics["Torque"].torque
	torque.RelativeTo = object.hitboxKBPhysics["Torque"].relativeTo[clientSelect.relativeTo]
	
	wait(object.duration/10)
	torque:Destroy()
	attachment0:Destroy()
end

function Main.LineForce(parent, object)
	local humanStateFalling = Enum.HumanoidStateType.FallingDown
	Main.player.Character.Humanoid:SetStateEnabled(humanStateFalling, false)
	local lineForce = Instance.new("LineForce")
	local attachment0 = Instance.new("Attachment")

	local clientSelect = object.hitboxKBPhysics["LineForce"].clientSelection
	lineForce.Parent = parent
	attachment0.Parent = parent

	lineForce.Attachment0 = attachment0
	
	lineForce.ApplyAtCenterOfMass = object.hitboxKBPhysics["LineForce"].applyAtCenterOfMass
	lineForce.InverseSquareLaw = object.hitboxKBPhysics["LineForce"].inverseSquareLaw
	lineForce.Magnitude = object.hitboxKBPhysics["LineForce"].Magnitude
	lineForce.ReactionForceEnabled = object.hitboxKBPhysics["LineForce"].reactionForceEnabled
	
	wait(object.duration/10)
	lineForce:Destroy()
	attachment0:Destroy()
end

function Main.Knockdown()--Values need to be passed
	local playerCharacter = Main.player.Character
	if debounce == false and playerCharacter:FindFirstChild("Hurtbox") then
		debounce = true
		playerCharacter.Humanoid.WalkSpeed = 0
		playerCharacter.Humanoid.JumpPower = 0
	local check = "serverCheck"
	event:FireServer(check)
	--local animator = playerCharacter.Humanoid.Animator
	--animator.EvaluationThrottled = true	
	local animPlay = playerCharacter.Humanoid.Animator:LoadAnimation(animationList.falldown)
	animPlay:Play()
	wait(0.05) -- Create a better delay
	animPlay = playerCharacter.Humanoid.Animator:LoadAnimation(animationList.knockdown)
	animPlay:Play()
	Main.char.Hurtbox:Destroy()
	wait(2) -- Make a better delay
	animPlay:Stop()
	debounce=false
	Main.Recovery()
	end
	-- Needs fixing on delay and it's purpose in the overall script
end

function Main.ServerPhysicsCheck( parent,object)
	print("SERVER PHSYX PARENT: ", parent)
	print("SERVER PHSYX PARENT: ", object)
	----[[
	local function processPhysicsThreadForHitstun()
		object.duration /= 10
		print("PHYSIC THREAD: ", object.duration)
		if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "LinearVelocity" then
			Main.LinearVelocity(object.victimHumanoidRootPart,object)
		else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "VectorForce" then
				Main.VectorForce(object.victimHumanoidRootPart,object)
			else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "AngularVelocity" then
					Main.AngularVelocity(object.victimHumanoidRootPart,object)
				else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "AlignPosition" then
						Main.AlignPosition(object.victimHumanoidRootPart,object)
					else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "AlignOrientation" then
							Main.AlignOrientation(object.victimHumanoidRootPart,object)
						else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "Torque" then
								Main.Torque(object.victimHumanoidRootPart,object)
							else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "LineForce" then
									Main.LineForce(object.victimHumanoidRootPart,object)
								else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "BodyVelocity" then
										print("BODY VELOCITY CALLED SET")
										Main.BodyVelocity(object.victimHumanoidRootPart,object)
									else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "None" then

										end
									end
								end
							end
						end
					end	
				end
			end

		end
		
	end
--]]--
	local physicsThread = coroutine.create(processPhysicsThreadForHitstun)
	coroutine.resume(physicsThread)
	
end

--ChoosePhysicsToProcess
function Main.processPhysicsThread(object, target)
	--object.duration /= 10
	print("PHYSIC THREAD: ", object.duration)
	if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "LinearVelocity" then
		Main.LinearVelocity(target,object)
	else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "VectorForce" then
			Main.VectorForce(target,object)
		else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "AngularVelocity" then
				Main.AngularVelocity(target,object)
			else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "AlignPosition" then
					Main.AlignPosition(target,object)
				else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "AlignOrientation" then
						Main.AlignOrientation(target,object)
					else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "Torque" then
							Main.Torque(target,object)
						else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "LineForce" then
								Main.LineForce(target,object)
							else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "BodyVelocity" then
									Main.BodyVelocity(target,object)
								else if object.hitboxKBPhysics[object.hitboxPhysicsChoice].physicsType == "None" then

									end
								end
							end
						end
					end
				end	
			end
		end

	end	
end

function Main.Hitstun(object)--duration,knockback,force)--table --Values need to be passed
	print("AREA OF CODE TOUCHEDEXAMPLE: ")
	print("HITSTUN OBJ: ",object)
	local characterStateStatus = require(game.ReplicatedStorage.CharacterSample.CharacterState.CharacterStateModule)

	
	-- Implement The Physics Reader--
	--Physics type will determine what function gets used for the reading --
	local playerCharacter = Main.player.Character
	local animPlay = Main.player.Character.Humanoid.Animator:LoadAnimation(animationList.hitstunAnimTable[1])
	
	local check = "serverCheck"
	local checkMessanger = HelperModule.hitboxTable
	checkMessanger.msg = check
	event:FireServer(checkMessanger)
	local randomAnimSelect = math.random(1,2) 
	local highlight = nil
	characterStateStatus.hitstunDuration = object.duration
	local distance = (object.victimHumanoidRootPart.Position - object.attackerPlayer.HumanoidRootPart.Position) --+ HelperModule.hitboxTable.knockbackMultiplier 
	object.knockback = (distance * object.knockbackMultiplier) + object.upForce
	characterStateStatus.playerToHitstun = object.victim -- get player from character, if nil, player to hitstun
	print("PLAYER FROM CHAR: ", characterStateStatus.playerToHitstun)
	print("PLAYA TO CHAR: ", game.Players:GetPlayerFromCharacter(characterStateStatus.playerToHitstun))
	if object.projectileActive ~= nil and object.projectileActive == true then
		object.projectileActive=false
	end
	print("VICTIMER: ", object.victim)
	if (object.victimHumanoidRootPart ~= nil) then
		object.victimHumanoidRootPart.CFrame = CFrame.lookAt(Vector3.new(object.victimHumanoidRootPart.Position.X,3.3,object.victimHumanoidRootPart.Position.Z), Vector3.new(object.attackerHumanoidRootPart.Position.X,3.3,object.attackerHumanoidRootPart.Position.Z))
		if characterStateStatus.hitstun == false then
			highlight = Instance.new("Highlight")
			highlight.FillColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
			highlight.Parent = object.victimHumanoidRootPart.Parent
		end
		characterStateStatus.hitstun = true
		if characterStateStatus.hitstun == true then
			characterStateStatus.comboCount +=1
		end
	end
	
	print("OBJECTOR: ", object.hitboxKBPhysics["AlignPosition"].mode["oneAttachment"])
	
	-------EDIT HERE-------
	object.duration /= 10
	

	print("Animation List", animationList)
	if HelperModule.hitboxTable.animationSelection < 2 and HelperModule.hitboxTable.animationSelection > 0 then
		animPlay = object.victimHumanoid.Animator:LoadAnimation(animationList.hitstunAnimTable[HelperModule.hitboxTable.animationSelection])
	else
		animPlay = object.victimHumanoid.Animator:LoadAnimation(animationList.hitstunAnimTable[randomAnimSelect])
	end

	
	local physicsThread = coroutine.create(Main.processPhysicsThread)
	
	
	
	---Add hitstop Delay here which Should delay play, this should also delay attackerAnim on Hit
	--HIT STOP LOGIC SHOULD BE ADDED HERE
	
	-- WE NEED CLIENT HITSTOP
	local characterModuleScript = require(game.ReplicatedStorage.CharacterSample.CharacterState.CharacterStateModule)
	
	--hitstop needs to yield
	animPlay:Play()
	
	--Check if player, if player from char run the hitstopCoolDownCounter logic
	-- if NPC run the adjustment logic
	-------HITSTOP/HIT FREEZE on hitstun
	if (game.Players:GetPlayerFromCharacter(characterStateStatus.playerToHitstun) ~= nil) then
		characterModuleScript.generalTableValueSetter("hitstopBoolean",true)
		characterModuleScript.generalTableValueSetter("hitStopCooldownCounter", object.hitStop)
		task.wait((object.hitStop/60))
	else
		animPlay:AdjustSpeed(0)
		--print("HitStop: ", object.hitStop)
		task.wait((object.hitStop/60))
		--task.wait(3)
		animPlay:AdjustSpeed(1)
	end
	
	
	
	print("FOOTSTOP DOES THIS RUN")
	
	--animPlay:AdjustSpeed(0)
	--print("ATTACKER IS: ", HelperModule.hitboxTable.attackerHumanoidRootPart.Parent.Humanoid.Animator:GetPlayingAnimationTracks())
	--characterModuleScript.generalTableValueSetter("hitStopCooldownCounter", HelperModule.hitboxTable.hitStop)
	
	--print("Hit stopper: ", characterModuleScript.generalTableValueGetter("hitStopCooldownCounter"))
	--print("HitStop: ", object.hitStop)

	--animPlay:AdjustSpeed(1)
	
	--task.delay()
	--Animation speed that needs to yield when paused for attacker and the client
	
	
	coroutine.resume(physicsThread,object, object.victimHumanoidRootPart)
	-- FIX ANIMATION LIST!!! --
	
	
	


	print("ANIMATION SPEED: ", animPlay.Speed)
	--animPlay:AdjustSpeed(0) 
	
	------------------------------------------
	--Hitstun adjust speed should be 2, so speed=2 speed-duration(0.4, would be 1.6)
	print("HITSTUN DURATION:", object.duration/10)

	animPlay.KeyframeReached:Connect(function(keyframe)
		animPlay:AdjustSpeed(0.5) 

		if keyframe == "KeyframeFinal" then -- hitstun countdown timer needs to be here too
			local taskTimeWait = object.duration/10 ~= nil and object.duration/10 or 0 -- Lua ternary, if fals it is nil

			task.wait(taskTimeWait)
			local highlightStatus = highlight ~= nil and highlight:Destroy() or nil
			--highlight:Destroy()
		end
	end)
	
	animPlay.Stopped:Connect(function()
		print("ANIMATION STOPPED")
	end)

end


function Main.Dash()--Values need to be passed
	local physicsLocation = Main.player.Character.HumanoidRootPart
--	local check = "serverCheck"
	local object = HelperModule.hitboxTable
	object.force = Vector3.new(math.huge,math.huge,math.huge)
	object.knockback = physicsLocation.CFrame.LookVector.Unit *130
	object.duration = 0.5
	print(characterStatesTable.hitstun)
	print("Dasher") -- Remove
--	event:FireServer(Main.player,check)
	if debounce2 == false then
		debounce2 = true
	--	print("INVERT") -- Remove
	--	print(physicsLocation) -- Remove
		local animPlay = Main.player.Character.Humanoid.Animator:LoadAnimation(animationList.dash)
		animPlay:Play()
		print(animPlay)
		print("object :", object)
		object.hitboxKBPhysics["LinearVelocity"].clientSelection.relativeTo = "World"
		print("objectZJZ :", object)
		--object.hitboxKBPhysics["LinearVelocity"]["clientSelection"] = object.hitboxKBPhysics["LinearVelocity"]["clientSelection"]["velocityConstraintMode"]
		Main.LinearVelocity(physicsLocation,object)
		--Main.BodyVelocity(physicsLocation,object) --Deprecated, replace later maybe
		-- bodyVelocity slightly floats better
		wait(0.02)
		debounce2 = false
	end
		
		
end

function Main.CreateProjectile(object, projectileDirection)
	
	print("PROJECTILE DIRECTION", projectileDirection)
	local newProjectile = Instance.new("Part")
	newProjectile.Parent = object.attacker.Character
	newProjectile.CFrame *= CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))
	newProjectile.Orientation = Vector3.new(0,0,0)
	newProjectile.Name = "Projectile"
	newProjectile.Color = Color3.new(0, 0.317647, 1)
	newProjectile.Massless = true
	newProjectile.CanCollide = false--false --true--false--false
	newProjectile.Transparency = 0.5
	newProjectile.Anchored = false--true
	newProjectile.CFrame *= object.location.CFrame --* CFrame.Angles(Main.player.Character.HumanoidRootPart.CFrame.X,Main.player.Character.HumanoidRootPart.CFrame.Y,Main.player.Character.HumanoidRootPart.CFrame.Z)
	newProjectile.Size = object.size
	print("PROJECTILE HAS LOADED ")
	object.projectile = newProjectile
	object.knockback = projectileDirection--HelperModule.hitboxTable.projectileTravelSpeed--Vector3.new(5,5,5)---object.projectileVelocity
	object.location = newProjectile

	

	-------EDIT HERE-------

--	Main.processPhysicsThread()
	
	local function projectileHitboxThread()
		if object.hitboxChoice == HelperModule.hitboxTable.hitboxType.newHitbox then
		
			Main.BoundingRayBox(object) --hitboxTable is helperMod
		elseif object.hitboxChoice == HelperModule.hitboxTable.hitboxType.magnitudeHitbox then
			Main.MagnitudeHitbox(object)
		else if object.hitboxChoice == HelperModule.hitboxTable.hitboxType.legacyHitbox then
			Main.CreateHitbox(object)	
			end
		end
	end

	local projectileHitboxThread = coroutine.create(projectileHitboxThread)
	local physicsThread = coroutine.create(Main.processPhysicsThread)
	
	coroutine.resume(projectileHitboxThread)
	coroutine.resume(physicsThread, object,newProjectile)
	
	print("PROJECTILE HITBOX TABLE: ", object.projectile)
	print("PROJECTILE HITBOX TABLE Objects: ", object)

	while coroutine.status(physicsThread) ~= "dead" do
		
		task.wait()  -- Wait for the next step
	end
	
	newProjectile:Destroy()
--	Main.player.Character:FindFirstChild("Hitbox"):Destroy()
end

function Main.Recovery()
	local playerCharacter = Main.player.Character
	playerCharacter.Humanoid.WalkSpeed = 25
	playerCharacter.Humanoid.JumpPower = 70
	playerCharacter.Humanoid.AutoRotate = true
	-- Rethink the logic behind this entire function
	Main.CreateHurtbox()
end

function Main.Guarding()
	-- Please refractor this with the steps above,and do not hardcode values, they can be grabbed by helper scripts
	local animPlay = Main.player.Character.Humanoid.Animator:LoadAnimation(animationList.guard)
	--Main.isGuarding.Value = true
	
	if characterStatesTable.isGuarding == false then
		characterStatesTable.isGuarding = true
		local count = 0
		repeat 
			animPlay:Play()
			Main.player.Character.Humanoid.WalkSpeed = 0
			Main.player.Character.Humanoid.JumpPower = 0
			Main.player.Character.Humanoid.AutoRotate = false
			wait(0.03)
		until characterStatesTable.isGuarding == false
		Main.player.Character.Humanoid.WalkSpeed = 25
		Main.player.Character.Humanoid.JumpPower = 70
		Main.player.Character.Humanoid.AutoRotate = true
	animPlay:Stop()
	end
		
end

function Main.CollisionSetter(item,collisionGroup)
	--item is the model that will be searched through
	--collision Group will be set to this
	local humanList = item:GetChildren()
	for index=1,#humanList,1 do --Turn this into a key pair loop, or use in pairs for faster processing
		if humanList[index]:isA("BasePart") then
			humanList[index].CollisionGroup = collisionGroup
		end
	
	end

end



function Main.CreateHurtbox(hitboxTable)--Pass Hurtbox Location, 2024 is this even used?
	characterStatesTable.hurtboxLocation = Main.player.Character.HumanoidRootPart.Position
	--Main.hurtboxLocation.Value = Main.player.Character.HumanoidRootPart.Position
	--local msg = "newHurtbox" 
	-- characterStateTable contains hurtbox details for loading hurtboxes in areas that is needed along with it's size
	
	
end

function Main.createStaticHurtbox(hitboxTable)
	characterStatesTable.hurtboxLocation = Main.player.Character.HumanoidRootPart.Position
	-- Make a folder that contains hurtbox info, and clear it when it needs to be deleted
end

function Main.createDynamicHurtbox(hitboxTable)
	characterStatesTable.hurtboxLocation = Main.player.Character.HumanoidRootPart.Position
end
--Hurtboxes




function Main.CreateHitbox(hitboxTable)--areaLocation,damage,hitstunDuration, hitboxTime,size, knockback,force,humanoidAttacker)--Pass Hitbox Location
	local debounce = false
	local debounce2 = false
	print(hitboxTable)
	-- This function is deprecated as it was the old hitbox system, it will still remain as is, but this is completely deprecated
	-- I Should remove this to be honest
	-- We will see if I get rid of it
	local newTest = hitboxTable.location
	print(newTest)
	--print(hitstunDuration)
	characterStatesTable.hitboxLocation = newTest.CFrame
	--Main.hitboxLocation.Value = newTest.CFrame
--	hitboxTime = (1/60) 
	characterStatesTable.hitboxTime = hitboxTable.hitboxTime
	--Main.hitboxTime.Value = hitboxTable.hitboxTime
	if debounce == false then
		debounce = true
		local hitbox = Instance.new("Part")
		hitbox.Transparency = 0.6
		hitbox.Parent = hitboxTable.location.Parent--Main.char
		print(hitbox.Parent)
		hitbox.Name = "Hitbox"
		hitbox.Color = Color3.fromRGB(255, 20, 20)
		hitbox.CanCollide = false
		hitbox.Massless = true
		hitbox.Size = hitboxTable.size
		hitbox.CFrame = characterStatesTable.hitboxLocation--Main.hitboxLocation.Value
		hitbox.Orientation = newTest.Orientation
		debounce = true
		local weld = Instance.new("WeldConstraint")
		weld.Archivable = true
		weld.Name = "hitboxWeld"
		weld.Parent = hitbox
		weld.Part0 = hitboxTable.location
		weld.Part1 = hitbox
		
		hitbox.Touched:Connect(function(victimPlayer)

			local victim = victimPlayer.Parent
			local playersX = game.Players
			local humanoidVictim = victimPlayer.Parent:FindFirstChild("Humanoid")
			local humanoidVictimHead = victimPlayer.Parent:FindFirstChild("Head")
			local humanoidVictimHRP = victimPlayer.Parent:FindFirstChild("HumanoidRootPart")
			
			if victim ~= hitbox.Parent and debounce2 == false and humanoidVictim ~= hitboxTable.attackerHumanoid then 
				print("Touched!!!!")
				debounce2= true
				hitboxTable.victim = victim
				hitboxTable.victimHumanoid = humanoidVictim
				print(hitboxTable.victim)
				local victimPlayerLoad = playersX:GetPlayerFromCharacter(victim)
		
				hitboxTable.victimPlayer = victimPlayerLoad
				hitboxTable.victimHumanoidRootPart = humanoidVictimHRP
				print(hitboxTable.victimHumanoidRootPart)
				print(humanoidVictim)
				--local playerInPlayers = game.Players:GetPlayerFromCharacter(victimPlayer.Parent)
				--event:FireServer(humanoidVictim, "hitbox",playerInPlayers,hitboxTable.damage, hitboxTable.duration, hitboxTable.knockback, hitboxTable.force)--damage,hitstunDuration,knockback,force)--table
				event:FireServer(humanoidVictim,hitboxTable)
		end-- pass more
		end)
		wait(characterStatesTable.hitboxLocation)
		hitbox:Destroy()
		debounce = false
		debounce2 = false
	end	
end

function Main.MagnitudeHitbox(hitboxTable)
	local list = game.Workspace:GetChildren()
	for index=1,#list,1 do -- Use in pairs
		if list[index]:FindFirstChild("HumanoidRootPart") then
			local distance = (hitboxTable.attackerHumanoidRootPart.Position - list[index]:FindFirstChild("HumanoidRootPart").Position) 
			if distance.Magnitude < hitboxTable.magnitudeRange then
				if list[index]:FindFirstChild("Humanoid") then
					--hitboxTable.victim[index]
					local playerFound = game.Players:GetPlayerFromCharacter(list[index])
				
					if playerFound ~= Main.player then
						hitboxTable.victim=list[index]
						hitboxTable.victimHumanoid=list[index]:FindFirstChild("Humanoid")
						hitboxTable.victimHumanoidRootPart =list[index]:FindFirstChild("HumanoidRootPart")
						hitboxTable.victimPlayer=playerFound
						event:FireServer(hitboxTable)
					end
					
				end
			end
		end
		
	end
end

function Main.BoundingRayBox(hitboxTable)
	local validation  = hitboxTable.validation
	local hitbox = Instance.new("Part")
	local count =0.00
	
	hitbox.Transparency = 0.97
	hitbox.Parent = hitboxTable.hitboxStyle == "Projectile" and hitboxTable.projectile or  hitboxTable.location.Parent
	--hitbox.Parent = hitboxTable.location.Parent--Main.char
	--print(hitbox.Parent)
	hitbox.Name = "Hitbox"
	hitbox.Color = Color3.fromRGB(255, 20, 20)
	hitbox.CanCollide = false
	hitbox.Massless = true
	hitbox.Material = Enum.Material.ForceField
	hitbox.Size = hitboxTable.size
	--Bug needs to be fixed on respawning players to reapply hitboxTable.location.Parent
	local highlight = Instance.new("Highlight")
	highlight.Parent = hitbox
	local newTest = hitboxTable.location
	characterStatesTable.hitboxLocation = newTest.CFrame
	--Main.hitboxLocation.Value = newTest.CFrame
	hitbox.CFrame = characterStatesTable.hitboxLocation--Main.hitboxLocation.Value
	hitbox.Orientation = newTest.Orientation --Vector3.new(0,0,0)
--	print(hitbox.TopSurface)
	local validator = Instance.new("Part")
	validator.Transparency = 1
	validator.Parent = hitboxTable.validLocation
	validator.CFrame = hitboxTable.cframe --We want to resize the validator to face a certain area

	-- HitboxTime and hitbox Duration needs to be separate, but similar


	--validator.Size = hitboxTable.validSize * Vector3.new(0,0,0)
	--validator.Size = validator.Size + Vector3.FromAxis(Enum.Axis.X)*-4
	--validator.Position = validator.Position+Vector3.FromNormalId(Enum.NormalId.Top)*4/2
	--Size = spike.Size + Vector3.FromAxis(Enum.Axis.Y)*4,
	--Position = spike.Position+Vector3.FromNormalId(Enum.NormalId.Top)*4/2
	validator.Size = hitboxTable.validSize --We want to resize the validator to face a certain area
	validator.Color = Color3.fromRGB(255, 255, 99)
	validator.CanCollide = false
	validator.Massless = true
	local direction = validator.CFrame.LookVector * 60
	
	debounce = true
	local weld = Instance.new("WeldConstraint")
	local weld2 = Instance.new("WeldConstraint")
	weld.Archivable = true
	weld.Name = "hitboxWeld"
	weld.Parent = hitbox
	weld.Part0 = hitboxTable.location
	weld.Part1 = hitbox
	weld2.Name = "validWeld"
	weld2.Parent = validator
	weld2.Part0 = validator
	weld2.Part1 = hitbox
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {hitboxTable.location,hitbox,validator, hitboxTable.attackerPlayer,hitboxTable.location,hitboxTable.location.Parent,Main.char}
	--print(hitboxTable)
	print("HITBOXU TIMEU: ", hitboxTable.hitboxTime)
	local function runRenderForHitbox()
		
	
	connector = runService.PostSimulation:Connect(function() --OLD Heartbeat--Redo this, you could possibly run this through a thread, maybe not using heartbeat
		if count < hitboxTable.hitboxTime then
			local area = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size,params)
		
			
			if area then
				local enemyList = {}
				local enemySubjectList = {}
				local detection
				--Grabs everyone hit and damages everyone
				for index,vindex in pairs(area) do
				--for index=1,#area, 1 do -- in pairs
				--	print("INDEX: ",vindex)
				--	print("REAL NUM: ", index)
					local human = area[index].Parent
					
					local humanoid = human:FindFirstChild("Humanoid")
					if humanoid and humanoid ~= hitboxTable.attackerHumanoid then
						
						if not enemyList[humanoid] then
							
							local rayOrign = validator
							local raycastParams = RaycastParams.new()
							raycastParams.FilterType = Enum.RaycastFilterType.Exclude
							raycastParams.CollisionGroup = "RayGroup"
							
							enemyList[humanoid] = human--true
							
							--table.insert(Main.enemySubjectList,enemyList[humanoid])
							raycastParams.FilterDescendantsInstances = {hitbox,validator,hitboxTable.attackerPlayer,hitboxTable.location}
							--validation = false
							if validation == true then
								local rayCast = workspace:Blockcast(validator.CFrame,validator.Size,direction,raycastParams)
								wait(0.02) --Asses this
								if rayCast then
									if rayCast.Instance.Parent == human  then 
										local head = human:FindFirstChild("HumanoidRootPart")
										hitboxTable.victim = human
										hitboxTable.victimHumanoid = humanoid
										hitboxTable.victimHumanoidRootPart = head
										local victimPlayer = game.Players 
										-- CURRENT ISSUE, ATTACKER GETS HIT BY OWN HITBOX
										-- After this is done refractor
										print(human)
										hitboxTable.victimPlayer = victimPlayer:GetPlayerFromCharacter(human)
										print(hitboxTable.victimPlayer)
										local att1 = Instance.new("Attachment")
										att1.Name = "Att1"
										att1.Parent = validator
										att1.WorldPosition =validator.Position
										att1.Visible = true
										local att2 = Instance.new("Attachment")
										att2.Name = "Att2"
										att2.Parent = validator
										att2.WorldPosition = rayCast.Position
										att2.Visible = true
										local beam = Instance.new("Beam")
										beam.Parent =validator -- Test Sequence
										beam.Color = ColorSequence.new(Color3.new(1, 0.027451, 0.027451),Color3.new(1, 0.862745, 0.172549))
										beam.Attachment0 = att1
										beam.Attachment1 = att2
										beam.Width0 = 0.3
										beam.Width1 = 0.3 
										beam.Segments = 12
										local playerHit = rayCast.Instance.Parent:FindFirstChild("Humanoid")
										if playerHit and head.Color ~= Color3.fromRGB(255,0,0) then
												head.Color = Color3.fromRGB(255,0,0)
												event:FireServer(hitboxTable)
												Main.CollisionSetter(human, collisionGroupHitPlayer)
												wait(hitboxTable.hitboxTime+0.2)
												Main.CollisionSetter(human, collisionGroupPlayer)
												head.Color = Color3.fromRGB(255, 255, 255)
											--	hitbox:Destroy()
										--		validator:Destroy()
												
												
										end
									end
								end
							else
								-- Edit Here to change what happens when players are hit
								local head = human:FindFirstChild("HumanoidRootPart")
								hitboxTable.victim = human -- hitstop logic should be processed for attacker somewhere here
								--Add hitstop declaration
								
								
								if (Main.player) then
										local characterModuleScript = require(game.ReplicatedStorage.CharacterSample.CharacterState.CharacterStateModule)
										--characterModuleScript.generalTableValueSetter("characterAnimationSpeed",0)
										print("PLAYER VALIDATED ON X: ", characterModuleScript.hurtBoxTable.hurtboxState["normal"])
										print("PLAYER VALIDATED ON Y: ", characterModuleScript.hurtBoxTable.hurtboxState)
										characterModuleScript.generalTableValueSetter("hitstopBoolean",true)
								end
								
								--"/ReplicatedStorage/"
								if human ~= hitboxTable.attacker then
									hitboxTable.victimHumanoid = humanoid
									hitboxTable.victimHumanoidRootPart = head
									local victimPlayer = game.Players
									hitboxTable.victimPlayer = victimPlayer:GetPlayerFromCharacter(human)

										if enemyList[humanoid] and not Main.enemySubjectList[humanoid] then
											Main.enemySubjectList[humanoid] = human
											
											
											event:FireServer(hitboxTable)
											
											--hitboxTable.hitboxDestoryOnSingleHit = true
											if hitboxTable.hitboxDestoryOnSingleHit == true then
												if hitboxTable.hitboxStyle == "Projectile" and hitboxTable.projectile ~= nil then
													hitboxTable.projectile:Destroy()
												end
												
											end
											
										end
									
								end
								
							end
						end
					end
				
				end

				if hitboxTable.hitboxDestoryOnSingleHit == true then
					count = hitboxTable.hitboxTime-2
				end
				count+=1 --0.01
			else
				
				count=0.00
				connector:Disconnect()
			end
			--print("SUBJECT LIST KIVAXDZ: ")
		end
	end)
	
	end -- part of function thread
	
	local newRenderThread = coroutine.create(runRenderForHitbox)
	coroutine.resume(newRenderThread)

	debounceHitCheck = false
	Main.enemySubjectList = {}
	wait((hitboxTable.hitboxTime)/100)  --OLD LOGIC: hitboxTable.hitboxTime -- NewLogic: (hitboxTable.hitboxTime)/10
	--wait(count)
	-- Create a flag that checks if hitbox needs to be destroyed
	local freeProjectile = hitboxTable.projectile ~= nil and hitboxTable.projectile:Destroy() or nil
	if characterStatesTable.generalTableValueGetter("hitStopCooldownCounter") <= 0 then
		characterStatesTable.generalTableValueSetter("hitstopBoolean", false)
	end
	hitbox:Destroy()
	validator:Destroy()
end




---------------------------------------- DEPRECATED PROJECTILE SYSTEM ----------------------------------------

function Main.ClientCalls(object)--msg,duration,knockback,force)--(msg, table)
	local waitTime = 0.5
	if object.msg == "hit" then
		print(object.msg)
	--	print(duration)
		--print(knockback)
		--print(force)
		local newThread = coroutine.create(Main.Hitstun)
		coroutine.resume(newThread,object)--duration,knockback,force)
		--Main.Hitstun(duration,knockback,force)
	end
	
end

function Main.newClientTouch(object)--location,damage,hitDuration,hitboxTime,size,knockback,force, humanoidAttacker,msg,projectileTravelSpeed)--table
	print(object)
	--print(location)
	--print(damage)
	--print(hitDuration)
	if object.msg == "Melee" then
	local newThread = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread, object)--location,damage,hitDuration,hitboxTime,size,knockback,force)--table
		--	Main.CreateHitbox(location,damage,hitDuration,hitboxTime,size,knockback,force)
   end
   if object.msg == "ProjectileFire" then
	local newProjectile = Instance.new("Part")
	newProjectile.Parent = object.location
	newProjectile.Name = "Projectile"
	newProjectile.Color = Color3.new(0, 0.317647, 1)
	newProjectile.Massless = true
	newProjectile.CanCollide = false--false
	newProjectile.Transparency = 0.5
	newProjectile.CFrame = object.location.CFrame
	newProjectile.Size = Vector3.new(5,5,5)
 
	local physicsMovement = Instance.new("BodyVelocity")
	physicsMovement.Parent = newProjectile
	physicsMovement.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		physicsMovement.Velocity = newProjectile.CFrame.LookVector.Unit*object.projectileTravelSpeed
    object.projectile = newProjectile
	local newThread2 = coroutine.create(Main.CreateHitbox)
	coroutine.resume(newThread2, object)--damage,hitDuration,hitboxTime,size,knockback,force,humanoidAttacker)
	wait(object.duration)
	newProjectile:Destroy()
	object.projectile:Destroy()
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

--------------------------------------------------------------------------------------------------------------

return Main
