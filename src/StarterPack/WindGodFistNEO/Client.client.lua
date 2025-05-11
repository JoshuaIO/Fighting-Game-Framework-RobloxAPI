local tool = script.Parent
local player = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local replicatedFirst = game.ReplicatedFirst
local character = replicatedStorage.Characters.SampleFighter
local runService = game:GetService("RunService")

--wait(2)

--local ModuleScript = require(replicatedStorage.CharacterScripts.MainScript) --require(player.Character:WaitForChild("CharacterSample").CharacterScripts.MainScript)
--local EffectLib = require(character.Effect)--require(player.Character:WaitForChild("CharacterSample").CharacterScripts.Effect)
--local Action = require(script.Parent:WaitForChild("Action"))\
--wait(15)
local CombatWriter = require(game.ReplicatedStorage.CharacterScripts.CombatWriter)
local characterStateModule = require(game.ReplicatedStorage.CharacterSample.CharacterState:WaitForChild("CharacterStateModule"))
local combatData = require(script.Parent:WaitForChild("CombatData"))
--local characters
characterStateModule.characterSelected = character.Name

local event = game.ReplicatedStorage.Events.MainAction
--local clientEventSend = game.ReplicatedStorage.Events.ClientToClientSend

tool.Activated:Connect(CombatWriter.MeleeCombo)
--tool.Activated:Connect(Action.MeleeCombo)


local statusThread =  coroutine.create(characterStateModule.RenderStatParameters)

--[[
	The Data flow goes as such:
	- Client is Given to playerScripts
	- Client sends data to ReplicatedStorage>CharacterScripts>CombatWriter
	- CombatData will also come from ReplicatedStorage>Characters>[Your character of choice]
	- For Instances where a tool is given to the player to do anything, please use Action Instead of Combat Writer
	- For Instances where a tool is given, use the CombatData Inside the tool, over the ReplicatedStorage>Characters>[<sample>] version
	

]]--



--wait(5)

runService.PostSimulation:Connect(characterStateModule.RenderStatParameters) --RenderStepped

	--[[function()
	
	local success, result =  coroutine.resume(statusThread)
	print("THREAD: ", coroutine.status(statusThread))
	print("SUCCESS: ", success)
	print("RESULT: ", result)
end)

]]--
