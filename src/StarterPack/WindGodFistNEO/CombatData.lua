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
			[1] = "rbxassetid://11029541454",
			[2] = "rbxassetid://11029974907",
			[3] = "rbxassetid://11284628545"
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
			keyframe = {"Keyframe5"},
			isHoldKeyFrame = false,
			hitboxLocation = script.Parent.LeftFist,
			hitboxDamage = 2,
			hitstunDuration = 50,
			hitboxTime = (18/60),
			hitboxSize = Vector3.new(3,4,3),
			hitboxKnockbackMultiplier = 2,
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 1,
				kbZ = 1,
			},
			hitboxKnockback = MainModule.player.Character.HumanoidRootPart,
			hitboxMagnitudeRange = 60,
			hitboxHitCount = 1,
			hitboxMessage = "hitbox",
			hitboxType = HelperTable.hitboxTable.hitboxType.newHitbox,
			validationLocation = script.Parent.LeftFist,
			validationSize = Vector3.new(1,script.Parent.LeftFist.Size.Y,script.Parent.LeftFist.Size.Z),
			validationCFrame = script.Parent.LeftFist.CFrame * CFrame.new(-1,0,0),
			isValidation = false,
			physicsType = "None",
			relativeTo = "World",
			velocityConstraintMode = "Vector",
			constraint = Enum.VelocityConstraintMode.Vector,
			velocity = Vector3.new(0,5,0), -- knockback result goes here
			forceLimitsEnabled = true
			
			
			
			
		},
		{
			keyframe = {"Keyframe5"},
			isHoldKeyFrame = false,
			hitboxLocation = script.Parent.RightFist,
			hitboxDamage = 2,
			hitstunDuration = 50,
			hitboxTime = (18/60),
			hitboxSize = Vector3.new(3,4,3),
			hitboxKnockbackMultiplier = 2,--00
			hitboxKnockbackVictimDirection = {
				kbX = 1,
				kbY = 3,
				kbZ = 1,
			},
			hitboxKnockback = MainModule.player.Character.HumanoidRootPart,
			hitboxMagnitudeRange = 2,
			hitboxHitCount = 1,
			hitboxMessage = "hitbox",
			hitboxType = HelperTable.hitboxTable.hitboxType.newHitbox,
			validationLocation = script.Parent.RightFist,
			validationSize = Vector3.new(1,script.Parent.RightFist.Size.Y,script.Parent.RightFist.Size.Z),
			validationCFrame = script.Parent.RightFist.CFrame * CFrame.new(-1,0,0),
			isValidation = false,
			physicsType = "LinearVelocity",
			
			relativeTo = "World",
			applyAtCenterOfMass = true,
			force = Vector3.new(0,0,100),
			velocityConstraintMode = "Vector",
			constraint = Enum.VelocityConstraintMode.Vector,
			velocity = Vector3.new(0,0,0), -- knockback result goes here
			forceLimitsEnabled = true
		},
		{
			keyframe = {"Keyframe7"},
			isHoldKeyFrame = false,
			hitboxLocation = MainModule.player.Character.LeftLowerLeg,
			hitboxDamage = 2,
			hitstunDuration = 50,
			hitboxTime = (18/60),
			hitboxSize = Vector3.new(3,4,3),
			hitboxKnockbackMultiplier = 5,
			hitboxKnockbackVictimDirection = {
					kbX = 1,
					kbY = 1,
					kbZ = 1,
				},
			hitboxKnockback = MainModule.player.Character.HumanoidRootPart,
			hitboxMagnitudeRange = 60,
			hitboxHitCount = 1,
			hitboxMessage = "hitbox",
			hitboxType = HelperTable.hitboxTable.hitboxType.newHitbox,
			validationLocation = MainModule.player.Character.LeftLowerLeg,
			validationSize = Vector3.new(1,MainModule.player.Character.LeftLowerLeg.Size.Y,MainModule.player.Character.LeftLowerLeg.Size.Z),
			validationCFrame = MainModule.player.Character.LeftLowerLeg.CFrame * CFrame.new(-1,0,0),
			isValidation = false,
			physicsType = "LinearVelocity",
			relativeTo = "World",
			velocityConstraintMode = "Vector",--"Vector",
			constraint = Enum.VelocityConstraintMode.Line,
			
			velocity = Vector3.new(0,0,0), -- knockback result goes here
			forceLimitsEnabled = true
		}
	}, -- Should contain hitbox information for all combo hits
	Special ={}, --Should contain hitbox information for all combo hits
	Effects ={}, -- Should contain the effects it should call from an effects tree
}

return combatData
