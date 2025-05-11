local replicatedStorage = game.ReplicatedStorage
--local serverStorage = game.ServerStorage
local replicatedFirst = game.ReplicatedFirst
local characterSample = replicatedStorage.CharacterSample
local animations = {
	--Basic Neutral Anims
	idle="",
	fall="",
	jump="",
	walk="",
	run="",
	swim="",
	swimIdle="",
	climb="",
	
	-----------------------------------------------
	--Generics
	----------------------------------------------
	knockdown = characterSample.Animations.States.Knockdown,
	dash = characterSample.Animations.States.Dash,
	falldown = characterSample.Animations.States.Falldown,
	guard = characterSample.Animations.States.Guard,
	-- Make a table out of this hitstun system for generic animations--
	hitstunAnimTable = {
		[1] = characterSample.Animations.States.Hitstun1,
		[2] = characterSample.Animations.States.Hitstun2,
	},
	
	knockback = characterSample.Animations.States.Knockback,
	--Attacks
	skill1 = characterSample.Animations.Attacks.Skills.Skill1,
	skill2 = characterSample.Animations.Attacks.Skills.Skill2,
	skill3 = characterSample.Animations.Attacks.Skills.Skill3,
	
	attack1 = characterSample.Animations.Attacks.NormalAttack.Attack1,
	attack2 = characterSample.Animations.Attacks.NormalAttack.Attack2,
	attack3 = characterSample.Animations.Attacks.NormalAttack.Attack3

}


return animations
