local event = game.ReplicatedStorage.Events.MainAction
local eventSendToAll = game.ReplicatedStorage.Events.SendServerToClient
local eventSendToServerCast = game.ReplicatedStorage.Events.SendToServerFromCombatWriter

local mainServer = require(script.Parent.MainServer)
local helperTable = require(game.ReplicatedStorage.CharacterScripts.HelperTable) 
local clientToClientSend = game.ReplicatedStorage.Events.ClientToClientSend

function CombatDataServerSender(player)
	print("SERVER CHECKER: ")
	return "TESTER"
end

clientToClientSend.OnServerInvoke= mainServer.CombatDataServerSender
event.OnServerEvent:Connect(mainServer.ServerCalls) --mainServer.ServerCalls
eventSendToServerCast.OnServerEvent:Connect(mainServer.SendDataToAllClients)
--eventSendToAll.OnServerEvent:Connect(mainServer.SendDataToAllClients)
