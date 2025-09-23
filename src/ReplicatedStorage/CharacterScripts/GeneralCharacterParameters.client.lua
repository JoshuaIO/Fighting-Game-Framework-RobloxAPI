
local player = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
--local serverStorage = game.ServerStorage
local replicatedFirst = game.ReplicatedFirst
local characterSample = replicatedStorage.CharacterSample
local characterScripts = replicatedStorage.CharacterScripts
local characterState = replicatedStorage.CharacterState
local characterChosen = require(characterState.CharacterStateModule)
local clientUtils = game.ReplicatedStorage.Events.ClientUtils
--local characterUtils = require(player.Character.GeneralCharacterParameters.CharacterUtils)
local characterUtils = clientUtils:InvokeServer()

function fixPlayerCharacterPath(hitboxLocationPath)
	-- This method aims to solve the issue of CombatData having old information of player Location and status
	local dir="Workspace."
	local fullPathStringForOldHitbox = tostring(hitboxLocationPath:GetFullName())
	local fullPath = tostring(hitboxLocationPath:GetFullName())
	print("fullpathu :", fullPath)
	--local newPathStringForHitbox = string.gsub(fullPathStringForOldHitbox, tostring(MainModule.player.Character:GetFullName()), tostring(MainModule.player.Character:GetFullName()))
	local fixedBuildString =fullPathStringForOldHitbox--newPathStringForHitbox

	local segments=fixedBuildString:split(".")--newPathStringForHitbox:split(".")
	local current=game --location to search

	for i,v in pairs(segments) do
		current=current[v]

	end

	return current

end




print(fixPlayerCharacterPath(characterUtils.RobloxObject).Controls)

function CharacterChosenDirectory(character)
	print("GO!: ", character)
	local characterRoster = game.ReplicatedStorage.Characters:GetChildren()
	for i,v in pairs(characterRoster) do
		if v.Name == character then
			return v
		end
	end
end
--Figure out a way to get the player choice from the client again
-- when gettin info from the server, it grabs who was touched on the server side

local character = CharacterChosenDirectory(characterUtils.Name)--characterChosen.characterSelected--turn this from a string to directory --replicatedStorage.Characters.FirstCharacter

local UIS = game:GetService("UserInputService")
local MainModule = require(replicatedStorage.CharacterScripts.MainScript)
local controlModule = require(fixPlayerCharacterPath(characterUtils.RobloxObject).Controls)
--local controlModule = require(replicatedStorage.CharacterSample.Controls.ControlsModule)
local animationModule = require(replicatedStorage.CharacterScripts.Animations)
--local charWeld = require(character.CharacterWelds)
local event = game.ReplicatedStorage.Events.MainAction
local eventClient = game.ReplicatedStorage.Events.MainActionClient
local serverToClient = game.ReplicatedStorage.Events.ServerToClientAction
local serverToPhysics = game.ReplicatedStorage.Events.ServerToPhysics
--local eventSendToServerCast = game.ReplicatedStorage.Events.SendToServerFromCombatWriter
local eventSendToAll = game.ReplicatedStorage.Events.SendServerToClient
local serverToClientCharacterToSend = game.ReplicatedStorage.Events.ServerCharacterChosenToSendToClient
local combatWriter = require(game.ReplicatedStorage.CharacterScripts.CombatWriter)


--Choose Character
--serverToClientCharacterToSend.OnClientEvent:Connect(combatWriter.setCharacterUtilities)

UIS.InputBegan:Connect(controlModule.InputTest)
--UIS.InputBegan:Connect(controlModule.MouseButtonPress)
UIS.InputEnded:Connect(controlModule.HoldKeys)
--charWeld.LoadWeld()

MainModule.CreateHurtbox()
--animationModule.HitboxAnimCall()
eventClient.OnClientEvent:Connect(MainModule.ClientCalls)
serverToClient.OnClientEvent:Connect(MainModule.newClientTouch)
serverToPhysics.OnClientEvent:Connect(MainModule.Hitstun) --All clients receive the hitstun meant for NPC and all players
eventSendToAll.OnClientEvent:Connect(MainModule.CreateProjectile)
--serverToPhysics.OnClientEvent:Connect(MainModule.ServerPhysicsCheck)
--serverToPhysics.OnClientEvent:Connect(MainModule.BodyVelocity)
--serverToPhysics.OnClientEvent:Connect(MainModule.LinearVelocity)