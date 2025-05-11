local helperTable = {
	hitboxTable = {
		location = 0,
		damage = 0,
		duration = 0,
		hitboxTime = 0,
		hitboxDestoryOnSingleHit=false,
		size = 0,
		cframe =0,
		knockback = 0,
		force = 0,
		msg = "serverCheck",
		hitStop=0, --Should be the number to determine how long an animation is stopped
		------PlayerMouse-----
		attackerMouse = 1,
		----------------------
		------Projectile------
		projectile =nil,
		projectileDuration =0,
		projectileActive=false,
		projectileSource =0,
		projectileForce =0,
		projectileOrientation =0,
		projectileDirectionAndUnit =0,
		projectileTravelSpeed = 0,
		--Add Projectile and details to be thrown
		----------------------
		animationSpeed = 1,--1
		attacker = 0,
		attackerHumanoid = 0,
		attackerHumanoidRootPart =0,
		attackerPlayer =0,
		knockbackMultiplier = 0,
		upForce = Vector3.new(0,0,0),
		animationSelection = 1,
	--	hitboxKnockbackVictim =0,
		victim=0,
		victimHumanoid=0,
		victimHumanoidRootPart =0,
		victimPlayer=0,
		validLocation =0,
		validDuration = 0,
		validSize = 0,
		validation = false,
		magnitudeRange =0,
		hitboxPhysicsChoice = "",
		hitboxType = {
			newHitbox ="NewHitbox", 
			magnitudeHitbox="magnitudeHitbox", 
			legacyHitbox="legacyHitbox"
		},
		hitboxChoice=0,
--[[
		PHYSICS AND KNOCKBACK INFORMATION	
]]--		
		hitboxAttachmentPosition = {
			attachment0 = 0,
			attatchment1 = 0 
		},
		hitboxKBPhysics = {
			["BodyVelocity"] = {physicsType = "BodyVelocity"},
			["LinearVelocity"] = {
					physicsType = "LinearVelocity",
					
					relativeTo = {
							["World"] = Enum.ActuatorRelativeTo.World,
							["Attachment0"] = Enum.ActuatorRelativeTo.Attachment0,
							["Attachment1"] = Enum.ActuatorRelativeTo.Attachment1,
						}, 
						
					velocityConstraintMode = {
						["Vector"] = {
							constraint = Enum.VelocityConstraintMode.Vector,
							vectorVelocity = Vector3.new(0,0,0),
							forceLimitsEnabled = true,
						}, 
						["Line"] = {
							constraint = Enum.VelocityConstraintMode.Line,
							lineDirection = Vector3.new(0,0,0),
							lineVelocity = 0,
							
						}, 
						["Plane"] = {
							constraint = Enum.VelocityConstraintMode.Plane,
							planeVelocity = Vector2.new(0,0),
							primaryTangentAxis = Vector3.new(1,0,0),
							secondaryTangentAxis = Vector3.new(0,1,0),
						},  
						
						
						
					},
					clientSelection = {relativeTo = nil, velocityConstraintMode = "Vector" }
				},
			["VectorForce"] = {
					physicsType = "VectorForce",
					relativeTo = {
						["World"] = Enum.ActuatorRelativeTo.World,
						["Attatchment0"] = Enum.ActuatorRelativeTo.Attachment0,
						["Attatchment1"] = Enum.ActuatorRelativeTo.Attachment1,
					}, 
					applyAtCenterOfMass = true,
					force = Vector3.new(0,0,100),
					
					clientSelection = {relativeTo = "World"}
					
				}, 
				
			["AngularVelocity"] = {
					physicsType = "AngularVelocity",
					relativeTo = {
						["World"] = Enum.ActuatorRelativeTo.World,
						["Attatchment0"] = Enum.ActuatorRelativeTo.Attachment0,
						["Attatchment1"] = Enum.ActuatorRelativeTo.Attachment1,
					}, 
					applyAtCenterOfMass = true,
					force = Vector3.new(0,0,100),
					maxTorque = 0,
					clientSelection = {relativeTo = "World"}
				}, 
			["AlignPosition"] = {
					physicsType = "AlignPosition",
					relativeTo = {
						["World"] = Enum.ActuatorRelativeTo.World,
						["Attatchment0"] = Enum.ActuatorRelativeTo.Attachment0,
						["Attatchment1"] = Enum.ActuatorRelativeTo.Attachment1,
					},
					mode = {
						oneAttachment = Enum.PositionAlignmentMode.OneAttachment,
						twoAttachment = Enum.PositionAlignmentMode.TwoAttachment
					},
					applyAtCenterOfMass = true,
					reactionForceEnabled = false,
					rigidityEnabled = false,
					forceLimitMode = {
						["Magnitude"] = {
							constraint = Enum.ForceLimitMode.Magnitude,
							maxVelocity = 0,
							responsiveness = 10,
						},
						["PerAxis"] = {
							constraint = Enum.ForceLimitMode.PerAxis,
							relativeTo = {
								["World"] = Enum.ActuatorRelativeTo.World,
								["Attatchment0"] = Enum.ActuatorRelativeTo.Attachment0,
								["Attatchment1"] = Enum.ActuatorRelativeTo.Attachment1,
							},
							maxAxesForce = Vector3.new(10000, 10000, 10000),
							maxVelocity = 0,
							responsiveness = 10,
						},
					},
				clientSelection = {relativeTo = "World", mode = "oneAttachment", forceLimitMode = "Magnitude", perAxisRelative = "World"}
				}, 
				
			["AlignOrientation"] = {
					physicsType = "AlignOrientation",
					mode = {
						oneAttachment = Enum.PositionAlignmentMode.OneAttachment,
						twoAttachment = Enum.PositionAlignmentMode.TwoAttachment
					},
					alignType = {
						["AllAxes"] = Enum.AlignType.AllAxes,
						["PrimaryAxisLookAt"] = Enum.AlignType.PrimaryAxisLookAt,
						["PrimaryAxisParallel"] = Enum.AlignType.PrimaryAxisParallel,
						["PrimaryAxisPerpendicular"] = Enum.AlignType.PrimaryAxisPerpendicular,
					},
					reactionTorqueEnabled = false,
					rigidityEnabled = false,
					maxAngularVelocity = 0,
					maxTorque = 0,
					responsiveness = 0,
				clientSelection = { mode = "oneAttachment", alignType = "AllAxes"}
				},  
				
			["Torque"] = {
				physicsType = "Torque",
				relativeTo = {
					["World"] = Enum.ActuatorRelativeTo.World,
					["Attatchment0"] = Enum.ActuatorRelativeTo.Attachment0,
					["Attatchment1"] = Enum.ActuatorRelativeTo.Attachment1,
				},
				torque = Vector3.new(0,0,0),
				clientSelection = { relativeTo = "World" }
			},
			["LineForce"] = {
				physicsType = "LineForce",
				applyAtCenterOfMass = true,
				inverseSquareLaw = false,
				magnitude = 300,
				reactionForceEnabled = true,
				}, 
			["None"] = {physicsType = "None"}
		}
		
	},
	
}

return helperTable
