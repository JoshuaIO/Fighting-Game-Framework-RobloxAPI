local event = game.ReplicatedStorage.Events.MainAction
local mainServer = require(script.Parent.MainServer)

event.OnServerEvent:Connect(mainServer.ServerCalls)