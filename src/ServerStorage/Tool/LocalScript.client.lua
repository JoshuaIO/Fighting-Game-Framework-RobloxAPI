local tool = script.Parent
local repStorage = game.ReplicatedStorage
local modScript = require(repStorage.ModuleScript)
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local serverStorage = game.ServerStorage
local replicatedFirst = game.ReplicatedFirst
local characterSample = replicatedStorage.CharacterSample
local characterScripts = replicatedStorage.CharacterScripts

local character = replicatedStorage.Characters.FirstCharacter

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


tool.Activated:Connect(modScript.Slash)
eventClient.OnClientEvent:Connect(MainModule.ClientCalls)
serverToClient.OnClientEvent:Connect(MainModule.newClientTouch)
--serverToPhysics.OnClientEvent:Connect(MainModule.Hitstun)
--serverToPhysics.OnClientEvent:Connect(MainModule.BodyVelocity)