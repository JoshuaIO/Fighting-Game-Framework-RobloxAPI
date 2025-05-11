local replicatedStorage = game.ReplicatedStorage
local MainModule = require(replicatedStorage.CharacterScripts.MainScript)
local HelperTable = require(replicatedStorage.CharacterScripts.HelperTable)

local combatData = {
	Animations = {
		--Merge these into one Table instead of multiple
		-- Animation Name --
		{
			animName = "Attack"
		},
		-- IdleAnimationsIds --
		{
			combatIdle="rbxassetid://9943150403"
		},
		-- MeleeAnimationsIds --
		{
			[1] = "rbxassetid://11029541454", -- Maybe we can add cooldowns here when animation stops
			[2] = "rbxassetid://11029974907",
			[3] = "rbxassetid://11284628545",
			[4] = "rbxassetid://6485192137", -- Keyframe 5
			[5] = "rbxassetid://105335582155367", -- Keyframe5,Keyframe9,Keyframe14,Keyframe18
			[6] = "rbxassetid://6485668419",
		},
		-- SkillAnimationIds --
		{
			skillOne ="rbxassetid://11029541454",
			skillTwo ="rbxassetid://6603979975",
			skillThree ="",
			
		}
		
	},
	Melee = {
		-- This Should Contain Data needed, for hbox position,frames,etc
		--FirstAttack Data
		{
			
			keyframe = {"Keyframe2","Keyframe5"},
			isHoldKeyFrame = {false,false},--false,--Pass player to a function to always get the newest character
			attackCooldown = 1.7, -- cool down for after attack
			hitboxLocation = {MainModule.player.Character.LeftHand,MainModule.player.Character.LeftHand},--characterStateModule.mainPlayer.Character.LeftHand,--(MainModule.player == game.Players.LocalPlayer) and MainModule.player.Character.LeftHand or nil,--MainModule.player.Character.LeftHand,--MainModule.player.Character:FindFirstChild("LeftHand"),--script.Parent.LeftFist,
			hitboxDamage = {2,2},
			hitstunDuration = {50,50},
			hitboxTime = {(18/60), (18/60)},
			hitboxSize = {Vector3.new(3,4,3),Vector3.new(3,4,3)},
			hitboxKnockbackMultiplier = {1.7, 1.7},
			hitboxDestoryOnSingleHit = {false,false},
			hitStop = {3,3},
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 1,
				kbZ = 1,
			},
			hitboxKnockback = MainModule.player.Character.HumanoidRootPart,
			hitboxMagnitudeRange = {60,60},
			hitboxHitCount = 1, -- Used for another feature, multi hit attack
			hitboxMessage = {"hitbox","hitbox"},
			hitboxStyle = {"Hitbox","Hitbox"},
			hitboxType = {HelperTable.hitboxTable.hitboxType.newHitbox, HelperTable.hitboxTable.hitboxType.newHitbox},
			validationLocation = {MainModule.player.Character.LeftHand, MainModule.player.Character.LeftHand},--script.Parent.LeftFist,
			validationSize = {
				Vector3.new(1,MainModule.player.Character.LeftHand.Size.Y,MainModule.player.Character.LeftHand.Size.Z),
				Vector3.new(1,MainModule.player.Character.LeftHand.Size.Y,MainModule.player.Character.LeftHand.Size.Z)
			},
			validationCFrame = {
				MainModule.player.Character.LeftHand.CFrame * CFrame.new(-1,0,0),
				MainModule.player.Character.LeftHand.CFrame * CFrame.new(-1,0,0)
			},--script.Parent.LeftFist.CFrame * CFrame.new(-1,0,0),
			isValidation = {false,false},
			physicsType = {"LinearVelocity","LinearVelocity"},
			relativeTo = {"World","World"},
			velocityConstraintMode = {"Vector","Vector"},
			constraint = {Enum.VelocityConstraintMode.Vector,Enum.VelocityConstraintMode.Vector},
			velocity = {Vector3.new(0,0,0),Vector3.new(0,0,0)}, -- knockback result goes here
			forceLimitsEnabled = {true, true}
			
			
			
			
		},
		{
			keyframe = {"Keyframe5"},
			isHoldKeyFrame = {false,false},
			attackCooldown = 1.7, -- cool down for after attack
			hitboxLocation = {MainModule.player.Character.RightHand,MainModule.player.Character.RightHand},--We need to compare if value is nil to current player, if nil then 
			hitboxDamage = {20,20}, --^ We need to create a recovery function for fixing paths when dead, 
			hitstunDuration = {50,50},
			hitboxTime = {(18/60),(18/60)},
			hitboxSize = {Vector3.new(3,4,3), Vector3.new(3,4,3)},
			hitboxKnockbackMultiplier = {1.7,1.7},--00
			hitboxDestoryOnSingleHit = {true, false}, -- Destroy on single hit can cause a bug where the hitbox yields infintely
			hitStop = {10,10},
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 1,
				kbZ = 1,
			},
			hitboxKnockback = {MainModule.player.Character.HumanoidRootPart, MainModule.player.Character.HumanoidRootPart},
			hitboxMagnitudeRange = {2,2},
			hitboxHitCount = 1,
			hitboxMessage = {"hitbox", "hitbox"}, -- "hitbox"-- projectile
			hitboxStyle = {"Hitbox", "Hitbox"},
			hitboxType = {HelperTable.hitboxTable.hitboxType.newHitbox, HelperTable.hitboxTable.hitboxType.newHitbox},
			validationLocation = {MainModule.player.Character.RightHand, MainModule.player.Character.RightHand},--script.Parent.RightFist,
			validationSize = {
				Vector3.new(1,MainModule.player.Character.RightHand.Size.Y,MainModule.player.Character.RightHand.Size.Z),
				Vector3.new(1,MainModule.player.Character.RightHand.Size.Y,MainModule.player.Character.RightHand.Size.Z)
			},
			validationCFrame = {
				MainModule.player.Character.RightHand.CFrame  * CFrame.new(-1,0,0),
				MainModule.player.Character.RightHand.CFrame  * CFrame.new(-1,0,0)
			},--script.Parent.RightFist.CFrame * CFrame.new(-1,0,0),
			isValidation = {false,false},
			physicsType = {"LinearVelocity", "LinearVelocity"},
			
			relativeTo = {"World","World"},
			applyAtCenterOfMass = {true,true},
			force = {Vector3.new(0,0,100), Vector3.new(0,0,100)},
			velocityConstraintMode = {"Vector","Vector"},
			constraint = {Enum.VelocityConstraintMode.Vector,Enum.VelocityConstraintMode.Vector},
			velocity = {Vector3.new(0,0,0),Vector3.new(0,0,0)}, -- knockback result goes here
			forceLimitsEnabled = {true,true}
		},
		{
			keyframe = {"Keyframe7"},
			isHoldKeyFrame = {false,false},
			attackCooldown = 2, -- cool down for after attack
			hitboxLocation = {MainModule.player.Character.LeftLowerLeg},
			hitboxDamage = {2},
			hitstunDuration = {50},
			hitboxTime = {(18/60)},
			hitboxSize = {Vector3.new(3,4,3)},
			hitboxKnockbackMultiplier = {1.7},
			hitboxDestoryOnSingleHit = {false},
			hitStop = {10,10},
			hitboxKnockbackVictimDirection = {
					kbX = 1,
					kbY = 1,
					kbZ = 1,
				},
			hitboxKnockback = {MainModule.player.Character.HumanoidRootPart},
			hitboxMagnitudeRange = {60},
			hitboxHitCount = 1,
			hitboxMessage = {"hitbox"},
			hitboxStyle = {"Hitbox"},
			hitboxType = {HelperTable.hitboxTable.hitboxType.newHitbox},
			validationLocation = {MainModule.player.Character.LeftLowerLeg},
			validationSize = {Vector3.new(1,MainModule.player.Character.LeftLowerLeg.Size.Y,MainModule.player.Character.LeftLowerLeg.Size.Z)},
			validationCFrame = {MainModule.player.Character.LeftLowerLeg.CFrame * CFrame.new(-1,0,0)},
			isValidation = {false},
			physicsType = {"LinearVelocity"},
			relativeTo = {"World"},
			velocityConstraintMode = {"Vector"},--"Vector",
			constraint = {Enum.VelocityConstraintMode.Line},
			
			velocity = {Vector3.new(0,0,0)}, -- knockback result goes here
			forceLimitsEnabled = {false}
		},
		{
			keyframe = {"Keyframe5"}, --FOR MULTI,MAKE A TABLE
			isHoldKeyFrame = {false},
			attackCooldown = 2, -- cool down for after attack
			hitboxLocation = {MainModule.player.Character.HumanoidRootPart}, --FOR MULTI,MAKE A TABLE--RightLowerLeg,--HumanoidRootPart,--RightLowerLeg,--HumanoidRootPart,
			hitboxDamage = {5},
			hitstunDuration = {50},--50,
			hitboxTime = {150}, --(18/60),--FOR MULTI,MAKE A TABLE
			
			hitboxSize = {Vector3.new(3,4,3)}, --FOR MULTI,MAKE A TABLE
			hitboxKnockbackMultiplier = {1.7}, --FOR MULTI,MAKE A TABLE
			hitboxDestoryOnSingleHit = {false}, --FOR MULTI,MAKE A TABLE
			hitStop = {10,10},
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 1,
				kbZ = 1,
			},
			hitboxKnockback = {MainModule.player.Character.HumanoidRootPart}, --FOR MULTI,MAKE A TABLE
			hitboxMagnitudeRange = {60}, --FOR MULTI,MAKE A TABLE
			hitboxHitCount = 1, --Show how many hits, prob 3
			hitboxMessage = {"hitbox"}, --FOR MULTI,MAKE A TABLE
			hitboxStyle = {"Projectile"}, --FOR MULTI,MAKE A TABLE
			hitboxType = {HelperTable.hitboxTable.hitboxType.newHitbox}, --FOR MULTI,MAKE A TABLE
			--------Projectile Data-------------------
			playerMouse = MainModule.player:GetMouse(),
			projectileDuration = {150}, --FOR MULTI,MAKE A TABLE
			projectileActive={true}, --FOR MULTI,MAKE A TABLE
			projectileSource = {MainModule.player.Character.HumanoidRootPart}, --FOR MULTI,MAKE A TABLE
			projectileForce = {4}, --FOR MULTI,MAKE A TABLE
			projectileDirectionAndUnit = {".CFrame.LookVector.Unit"},
			projectileOrientation = {MainModule.player.Character.HumanoidRootPart.Orientation}, --FOR MULTI,MAKE A TABLE
			projectileVelocity= {MainModule.player.Character.HumanoidRootPart.CFrame.LookVector.Unit *100}, --FOR MULTI,MAKE A TABLE
			------------------------------------------
			validationLocation = {MainModule.player.Character.RightLowerLeg}, --FOR MULTI,MAKE A TABLE
			validationSize = {Vector3.new(1,MainModule.player.Character.RightLowerLeg.Size.Y,MainModule.player.Character.RightLowerLeg.Size.Z)}, --FOR MULTI,MAKE A TABLE
			validationCFrame = {MainModule.player.Character.RightLowerLeg.CFrame * CFrame.new(-1,0,0)}, --FOR MULTI,MAKE A TABLE
			isValidation = {false}, --FOR MULTI,MAKE A TABLE
			physicsType = {"LinearVelocity"}, --FOR MULTI,MAKE A TABLE
			relativeTo = {"World"}, --FOR MULTI,MAKE A TABLE
			velocityConstraintMode = {"Vector"},--"Vector", --FOR MULTI,MAKE A TABLE
			constraint = {Enum.VelocityConstraintMode.Line}, --FOR MULTI,MAKE A TABLE

			velocity = {Vector3.new(0,0,0)}, -- knockback result goes here --FOR MULTI,MAKE A TABLE
			forceLimitsEnabled = {true} --FOR MULTI,MAKE A TABLE
		},
		{
			keyframe = {"Keyframe5","Keyframe9","Keyframe14","Keyframe18"}, --FOR MULTI,MAKE A TABLE
			isHoldKeyFrame = {false,false,false,false},
			attackCooldown = 2, -- cool down for after attack
			hitboxLocation = {
				MainModule.player.Character.RightLowerArm,
				MainModule.player.Character.LeftLowerArm,
				MainModule.player.Character.RightLowerArm,
				MainModule.player.Character.LeftLowerArm,
			}, --FOR MULTI,MAKE A TABLE--RightLowerLeg,--HumanoidRootPart,--RightLowerLeg,--HumanoidRootPart,
			hitboxDamage = {5,5,5,5},
			hitstunDuration = {50,50,50,50},--50,
			hitboxTime = {
				(18/60),
				(18/60),
				(18/60),
				(18/60),
			}, --(18/60),--FOR MULTI,MAKE A TABLE

			hitboxSize = {
				Vector3.new(3,4,3),
				Vector3.new(3,4,3),
				Vector3.new(3,4,3),
				Vector3.new(3,4,3)
			}, --FOR MULTI,MAKE A TABLE
			hitboxKnockbackMultiplier = {0.2,0.2,0.2,5.7}, --FOR MULTI,MAKE A TABLE
			hitboxDestoryOnSingleHit = {false,false,false,false}, --FOR MULTI,MAKE A TABLE
			hitStop = {10,10,10,10},
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 1,
				kbZ = 1,
			},
			hitboxKnockback = {
				MainModule.player.Character.HumanoidRootPart,
				MainModule.player.Character.HumanoidRootPart,
				MainModule.player.Character.HumanoidRootPart,
				MainModule.player.Character.HumanoidRootPart
			}, --FOR MULTI,MAKE A TABLE
			hitboxMagnitudeRange = {60,60,60,60}, --FOR MULTI,MAKE A TABLE
			hitboxHitCount = 1, --Show how many hits, prob 3
			hitboxMessage = {"hitbox","hitbox","hitbox","hitbox"}, --FOR MULTI,MAKE A TABLE
			hitboxStyle = {"Hitbox","Hitbox","Hitbox","Hitbox"}, --FOR MULTI,MAKE A TABLE
			hitboxType = {
				HelperTable.hitboxTable.hitboxType.newHitbox,
				HelperTable.hitboxTable.hitboxType.newHitbox,
				HelperTable.hitboxTable.hitboxType.newHitbox,
				HelperTable.hitboxTable.hitboxType.newHitbox
			}, --FOR MULTI,MAKE A TABLE
			--------Projectile Data-------------------
		
			------------------------------------------
			validationLocation = {
				MainModule.player.Character.RightLowerArm,
				MainModule.player.Character.LeftLowerArm,
				MainModule.player.Character.RightLowerArm,
				MainModule.player.Character.LeftLowerArm,
			}, --FOR MULTI,MAKE A TABLE
			validationSize = {
				Vector3.new(1,MainModule.player.Character.RightLowerArm.Size.Y,MainModule.player.Character.RightLowerArm.Size.Z),
				Vector3.new(1,MainModule.player.Character.LeftLowerLeg.Size.Y,MainModule.player.Character.LeftLowerArm.Size.Z),
				Vector3.new(1,MainModule.player.Character.RightLowerArm.Size.Y,MainModule.player.Character.RightLowerArm.Size.Z),
				Vector3.new(1,MainModule.player.Character.LeftLowerLeg.Size.Y,MainModule.player.Character.LeftLowerArm.Size.Z),
			}, --FOR MULTI,MAKE A TABLE
			validationCFrame = {
				MainModule.player.Character.RightLowerArm.CFrame * CFrame.new(-1,0,0),
				MainModule.player.Character.LeftLowerArm.CFrame * CFrame.new(-1,0,0),
				MainModule.player.Character.RightLowerArm.CFrame * CFrame.new(-1,0,0),
				MainModule.player.Character.LeftLowerArm.CFrame * CFrame.new(-1,0,0),
			}, --FOR MULTI,MAKE A TABLE
			isValidation = {false,false,false,false}, --FOR MULTI,MAKE A TABLE
			physicsType = {"LinearVelocity","LinearVelocity","LinearVelocity","LinearVelocity"}, --FOR MULTI,MAKE A TABLE
			relativeTo = {"World","World","World","World"}, --FOR MULTI,MAKE A TABLE
			velocityConstraintMode = {"Vector","Vector","Vector","Vector"},--"Vector", --FOR MULTI,MAKE A TABLE
			constraint = {
				Enum.VelocityConstraintMode.Line,
				Enum.VelocityConstraintMode.Line,
				Enum.VelocityConstraintMode.Line,
				Enum.VelocityConstraintMode.Line
			}, --FOR MULTI,MAKE A TABLE

			velocity = {
				Vector3.new(0,0,0),
				Vector3.new(0,0,0),
				Vector3.new(0,0,0),
				Vector3.new(0,0,0)
			}, -- knockback result goes here --FOR MULTI,MAKE A TABLE
			forceLimitsEnabled = {true,true,true,true} --FOR MULTI,MAKE A TABLE
		},
		{
			keyframe = {"Keyframe8"},
			isHoldKeyFrame = {false,false},
			attackCooldown = 1.7, -- cool down for after attack
			hitboxLocation = {MainModule.player.Character.HumanoidRootPart},--We need to compare if value is nil to current player, if nil then 
			hitboxDamage = {2,1.5,12}, --^ We need to create a recovery function for fixing paths when dead, 
			hitstunDuration = {50,3,70},
			hitboxTime = {(18/60),(18/60)},
			hitboxSize = {Vector3.new(3,4,3), Vector3.new(3,4,3), Vector3.new(5,4,5)},
			hitboxKnockbackMultiplier = {-0.2,-0.02,15},--00
			hitboxDestoryOnSingleHit = {false, false},
			hitStop = {10,10},
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 1,
				kbZ = 1,
			},
			hitboxKnockback = {MainModule.player.Character.HumanoidRootPart, MainModule.player.Character.HumanoidRootPart},
			hitboxMagnitudeRange = {2,2},
			hitboxHitCount = 15,
			hitboxMessage = {"hitbox", "hitbox"}, -- "hitbox"-- projectile
			hitboxStyle = {"Hitbox", "Hitbox"},
			hitboxType = {HelperTable.hitboxTable.hitboxType.newHitbox, HelperTable.hitboxTable.hitboxType.newHitbox},
			validationLocation = {MainModule.player.Character.HumanoidRootPart, MainModule.player.Character.HumanoidRootPart},--script.Parent.RightFist,
			validationSize = {
				Vector3.new(1,MainModule.player.Character.HumanoidRootPart.Size.Y,MainModule.player.Character.HumanoidRootPart.Size.Z),
				Vector3.new(1,MainModule.player.Character.HumanoidRootPart.Size.Y,MainModule.player.Character.HumanoidRootPart.Size.Z)
			},
			validationCFrame = {
				MainModule.player.Character.HumanoidRootPart.CFrame  * CFrame.new(-1,0,0),
				MainModule.player.Character.HumanoidRootPart.CFrame  * CFrame.new(-1,0,0)
			},--script.Parent.RightFist.CFrame * CFrame.new(-1,0,0),
			isValidation = {false,false},
			physicsType = {"LinearVelocity", "LinearVelocity"},

			relativeTo = {"World","World"},
			applyAtCenterOfMass = {true,true},
			force = {Vector3.new(0,0,100), Vector3.new(0,0,100)},
			velocityConstraintMode = {"Vector","Vector"},
			constraint = {Enum.VelocityConstraintMode.Vector,Enum.VelocityConstraintMode.Vector},
			velocity = {Vector3.new(0,0,0),Vector3.new(0,0,0)}, -- knockback result goes here
			forceLimitsEnabled = {true,true}
		}
	}, -- Should contain hitbox information for all combo hits
	Special ={}, --Should contain hitbox information for all combo hits
	Effects ={}, -- Should contain the effects it should call from an effects tree
}



return combatData
