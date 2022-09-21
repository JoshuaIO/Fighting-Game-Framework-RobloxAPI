wait(1)
local UIS = game:GetService("UserInputService")
local MainModule = require(script.Parent.MainScript)
local controlModule = require(script.Parent.Controls)
local animationModule = require(script.Parent.Animations)
local charWeld = require(script.Parent.CharacterWelds)
local event = game.ReplicatedStorage.Events.MainAction
local eventClient = game.ReplicatedStorage.Events.MainActionClient
local serverToClient = game.ReplicatedStorage.Events.ServerToClientAction
local serverToPhysics = game.ReplicatedStorage.Events.ServerToPhysics
UIS.InputBegan:Connect(controlModule.InputTest)
UIS.InputEnded:Connect(controlModule.HoldKeys)
charWeld.LoadWeld()
wait(3)
MainModule.CreateHurtbox()
--animationModule.HitboxAnimCall()
eventClient.OnClientEvent:Connect(MainModule.ClientCalls)
serverToClient.OnClientEvent:Connect(MainModule.newClientTouch)
serverToPhysics.OnClientEvent:Connect(MainModule.BodyVelocity)