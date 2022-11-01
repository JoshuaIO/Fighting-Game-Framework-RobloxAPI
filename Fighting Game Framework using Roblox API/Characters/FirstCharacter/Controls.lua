local playerSample = game.Players.LocalPlayer
local replicatedStorage = game.ReplicatedStorage
local replicatedFirst = game.ReplicatedFirst
local serverStorage = game.ServerStorage
local characterSample = replicatedStorage.CharacterSample
local characterScripts = replicatedStorage.CharacterScripts


local MainModule = require(characterScripts.MainScript)
local MoveList = require(script.Parent.CharacterMoveList)
local charWeld = require(script.Parent.CharacterWelds)
local UIS = game:GetService("UserInputService")
local controls = {
	button1 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button1.Value)],
	button2 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button2.Value)],
	button3 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button3.Value)],
	button4 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button4.Value)],
	button5 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button5.Value)],
	button6 = Enum.KeyCode[string.upper(playerSample.CharacterSample.Controls.Button6.Value)]
	
}

function controls.InputTest(input, isTyping)
	if input.KeyCode == controls.button1 then
		print(controls.button1)
		MoveList.Skill1()
	end
	if input.KeyCode == controls.button2 then
		print(controls.button2)
		MainModule.Dash()
	
	end
	if input.KeyCode == controls.button3 then
		MoveList.Attack()
	    print(controls.button3)

	end
	if input.KeyCode == controls.button4 then
		print(controls.button4)
		charWeld.LoadWeld()
	end

	if input.KeyCode == controls.button5 then
		print(controls.button5)
		MainModule.Guarding()

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
	MainModule.isGuarding.Value = false
		print(controls.button5)
	end
	if input.KeyCode == controls.button6 then
		print(controls.button6)
	end
end



return controls
