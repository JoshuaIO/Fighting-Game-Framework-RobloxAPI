local tool = script.Parent


function Equip()
--	print("EQUIPPPPEED")
	local leftFist = script.Parent.LeftFist
	local rightFist = script.Parent.RightFist
	local body = script.Parent.Parent
	local leftArm = body:FindFirstChild("LeftLowerArm")
	local rightArm = body:FindFirstChild("RightLowerArm")
	local animation = body:FindFirstChild("Animate")
	animation.idle.Animation1.AnimationId = "rbxassetid://11029281322"
	leftFist.CFrame = leftArm.CFrame * CFrame.Angles(0,1.5,0)
	local leftWeld = Instance.new("WeldConstraint",leftFist)
	leftWeld.Part0 = leftArm
	leftWeld.Part1 = leftFist

	rightFist.CFrame = rightArm.CFrame * CFrame.Angles(0,-1.5,0)
	local rightWeld = Instance.new("WeldConstraint",rightFist)
	rightWeld.Part0 = rightArm
	rightWeld.Part1 = rightFist


	--print(body)
end

function Unequip()
	local leftFist = script.Parent.LeftFist
	local rightFist = script.Parent.RightFist
	local body = script.Parent
	local weld1 = leftFist:FindFirstChild("WeldConstraint")
	weld1:Destroy()
	local weld2 = leftFist:FindFirstChild("WeldConstraint")
	weld1:Destroy()
end

tool.Equipped:Connect(Equip)
tool.Unequipped:Connect(Unequip)