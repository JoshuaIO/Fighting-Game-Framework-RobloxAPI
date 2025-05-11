local playerSample = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local replicatedFirst = game.ReplicatedFirst
--local serverStorage = game.ServerStorage
local characterSample = replicatedStorage.CharacterSample
local characterScripts = replicatedStorage.CharacterScripts


local MainModule = require(characterScripts.MainScript)
local MoveList = require(script.Parent.CharacterMoveList)
local charWeld = require(script.Parent.CharacterWelds)

local characterStates = playerSample:WaitForChild("CharacterSample").CharacterState.CharacterStateModule --Replace WaitForChild
local characterStatesTable = require(characterStates)

local controllerStates = playerSample:WaitForChild("CharacterSample").Controls.ControlsModule --Replace WaitForChild
local controllerStatesTable = require(controllerStates)

print(characterStatesTable)
print(controllerStatesTable)

local UIS = game:GetService("UserInputService")
local controls = {
	--button1 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button1.Value)]
	button1 = Enum.KeyCode[string.upper(controllerStatesTable.buttonOne)], --playerSample.CharacterSample.Controls.Button1.Value
	button2 = Enum.KeyCode[string.upper(controllerStatesTable.buttonTwo)],
	button3 = Enum.KeyCode[string.upper(controllerStatesTable.buttonThree)],
	button4 = Enum.KeyCode[string.upper(controllerStatesTable.buttonFour)],
	button5 = Enum.KeyCode[string.upper(controllerStatesTable.buttonFive)],
	button6 = Enum.KeyCode[string.upper(controllerStatesTable.buttonSix)]
	
}

function controls.InputTest(input, isTyping)
	local playerData = {
		localplayer = playerSample,
	--	loadout = playerSample:FindFirstChild("Data").Loadout,
	--	magicEquipOne = playerSample:FindFirstChild("Data").Loadout.MagicEquipOne,
	--	magicEquipTwo = playerSample:FindFirstChild("Data").Loadout.MagicEquipTwo,
	} 
	if input.KeyCode == controls.button1 then
		print(controls.button1)
		
		--MoveList.Skill1(playerData)
	end
	if input.KeyCode == controls.button2 then
		print(controls.button2)
		MainModule.Dash()
		print(playerData)
	end
	if input.KeyCode == controls.button3 then
		--MoveList.Attack()
	    print(controls.button3)

	end
	if input.KeyCode == controls.button4 then
		print(controls.button4)
	--	charWeld.LoadWeld()
	end

	if input.KeyCode == controls.button5 then
		print(controls.button5)
	--	MainModule.Guarding()

	end
	if input.KeyCode == controls.button6 then
		print(controls.button6)
	end
end

function controls.HoldKeys(input, isTyping)
--[[	if input.KeyCode == controls.button1 then
		--print(controls.button1)
--		MainModule.Knockdown()
	end
	if input.KeyCode == controls.button2 then
		--MainModule.Dash()
	--	print(controls.button2)
	end]]--
	if input.KeyCode == controls.button3 then
		
	--	MainModule.Guarding()
		--print(controls.button3)
	end
	if input.KeyCode == controls.button4 then
		print(controls.button4)
	end
	if input.KeyCode == controls.button5 then
	characterStatesTable.isGuarding = false
		print(controls.button5)
	end
	if input.KeyCode == controls.button6 then
		print(controls.button6)
	end
end



return controls
