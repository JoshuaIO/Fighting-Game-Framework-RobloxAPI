local tool = script.Parent


function Equip()
--	print("EQUIPPPPEED")

	local body = script.Parent.Parent
	
	local animation = body:FindFirstChild("Animate")
	animation.idle.Animation1.AnimationId = "rbxassetid://9943150403"




	--print(body)
end

function Unequip()

	local body = script.Parent

end

tool.Equipped:Connect(Equip)
tool.Unequipped:Connect(Unequip)