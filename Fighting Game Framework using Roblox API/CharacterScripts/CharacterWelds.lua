local mainWorld = require(script.Parent.MainScript)
local event = game.ReplicatedStorage.Events.MainAction
local welds = {
	--Items
	plasmaSword = game.ReplicatedStorage.WeldLibrary.Weapon:FindFirstChild("PlasmaSword"),
	classicSword = game.ReplicatedStorage.WeldLibrary.Weapon:FindFirstChild("ClassicSword"),
	mainParent = mainWorld.char,
	rightHandLocation = mainWorld.char.RightHand,
	leftHandLocation = mainWorld.char.LeftHand,
	RHAngle = CFrame.Angles(0,3.2,1.5),
	LHAngle = CFrame.Angles(0,3.2,1.5),
}
function welds.LoadWeld()
	local newSword = welds.plasmaSword
	local secondSword = welds.classicSword
	local msg = "loadWeld"
	event:FireServer(newSword,msg,welds.rightHandLocation,welds.mainParent,welds.RHAngle)
	event:FireServer(secondSword,msg,welds.leftHandLocation,welds.mainParent,welds.LHAngle)
end

return welds
