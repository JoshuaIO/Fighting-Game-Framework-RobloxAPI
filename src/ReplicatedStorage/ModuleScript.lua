local module = {}
local Anims = require(game.ReplicatedStorage.AnimationScript)

function module.Control(input,isTyping)
	if input.KeyCode == Enum.KeyCode.F and isTyping == false then
		print("test")
		Anims.WaveAnim()
	end
end

function module.Slash()
	--if input.KeyCode == Enum.KeyCode.F and isTyping == false then
		print("test")
		Anims.WaveAnim()
--	end
end

return module
