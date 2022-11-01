wait(1)
local player = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local serverStorage = game.ServerStorage
local replicatedFirst = game.ReplicatedFirst
local characterSample = replicatedStorage.CharacterSample
local characterScripts = characterSample.CharacterScripts

local character = replicatedStorage.Characters.FirstCharacter

local UIS = game:GetService("UserInputService")
local MainModule = require(replicatedStorage.CharacterScripts.MainScript)
local controlModule = require(character.Controls)
local animationModule = require(replicatedStorage.CharacterScripts.Animations)
local charWeld = require(character.CharacterWelds)
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