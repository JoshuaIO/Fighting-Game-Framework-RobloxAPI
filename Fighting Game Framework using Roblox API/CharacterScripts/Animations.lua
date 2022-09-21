local animations = {
	--Basic Neutral Anims
	idle="",
	fall="",
	jump="",
	walk="rbxassetid://7683082435",
	run="rbxassetid://6564775773",
	swim="",
	swimIdle="",
	climb="",
	
	-----------------------------------------------
	--Generics
	----------------------------------------------
	knockdown = script.Parent.Parent.Animations.States.Knockdown,
	dash = script.Parent.Parent.Animations.States.Dash,
	falldown = script.Parent.Parent.Animations.States.Falldown,
	guard = script.Parent.Parent.Animations.States.Guard,
	hitstun1 = script.Parent.Parent.Animations.States.Hitstun1,
	hitstun2 = script.Parent.Parent.Animations.States.Hitstun2,
	knockback = script.Parent.Parent.Animations.States.Knockback,
	--Attacks
	skill1 = script.Parent.Parent.Animations.Attacks.Skills.Skill1,
	skill2 = script.Parent.Parent.Animations.Attacks.Skills.Skill2,
	skill3 = script.Parent.Parent.Animations.Attacks.Skills.Skill3,
	
	attack1 = script.Parent.Parent.Animations.Attacks.NormalAttack.Attack1,
	attack2 = script.Parent.Parent.Animations.Attacks.NormalAttack.Attack2,
	attack3 = script.Parent.Parent.Animations.Attacks.NormalAttack.Attack3

}


return animations
