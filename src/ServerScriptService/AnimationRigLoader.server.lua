local Players = game:GetService("Players")

function replaceLocalAnimateScript(player)
	player.CharacterAdded:Connect(function(character)
		local rigType = character.Humanoid.RigType
		print("Char: ", character)
		local oldAnimateScript = character:FindFirstChild("Animate")
		-- check the character rigType and replace with whats needed
		if (rigType.Value == 0) then
			--do logic to check if Animate local script exist, and replace it with better stuff
			if oldAnimateScript and oldAnimateScript:IsA("LocalScript") then
				local newAnimateScript = game.ReplicatedStorage.CharacterScripts.ModifiedAnimation.R6.Animate:Clone()
				oldAnimateScript:Destroy()
				newAnimateScript.Parent = character
			end			
		else
			if oldAnimateScript and oldAnimateScript:IsA("LocalScript") then
				local newAnimateScript = game.ReplicatedStorage.CharacterScripts.ModifiedAnimation.R15.Animate:Clone() --.ModifiedAnimation.R15.Animate:Clone()
				oldAnimateScript:Destroy()
				newAnimateScript.Parent = character
				
			end		
			-- do logic for r15
		end
		
	end)
end


Players.PlayerAdded:Connect(replaceLocalAnimateScript)