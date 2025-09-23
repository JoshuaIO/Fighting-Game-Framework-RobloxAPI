local serverToClientCharacterToSend = game.ReplicatedStorage.Events.ServerCharacterChosenToSendToClient
local combatWriter = require(game.ReplicatedStorage.CharacterScripts.CombatWriter)

--Choose Character from server

serverToClientCharacterToSend.OnClientEvent:Connect(combatWriter.setCharacterUtilities)