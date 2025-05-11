local players = game.Players
local replicatedStorage = game.ReplicatedStorage
local replicatedFirst = game.ReplicatedFirst
local serverStorage = game.ServerStorage
function NewMethods(plr)
	local newStates = replicatedStorage.CharacterSample:Clone()
	newStates.Parent = plr
end

players.PlayerAdded:Connect(NewMethods)