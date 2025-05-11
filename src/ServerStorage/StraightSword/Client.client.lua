local tool = script.Parent
local player = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local replicatedFirst = game.ReplicatedFirst
local character = replicatedStorage.Characters.FirstCharacter
--wait(2)

local ModuleScript = require(replicatedStorage.CharacterScripts.MainScript) --require(player.Character:WaitForChild("CharacterSample").CharacterScripts.MainScript)
local EffectLib = require(character.Effect)--require(player.Character:WaitForChild("CharacterSample").CharacterScripts.Effect)
local Action = require(script.Parent:WaitForChild("Action"))

local event = game.ReplicatedStorage.Events.MainAction


tool.Activated:Connect(Action.MeleeCombo)



