local mainServ = {}
local event = game.ReplicatedStorage.Events.MainAction
local eventClient =game.ReplicatedStorage.Events.MainActionClient
local physicsEvent = game.ReplicatedStorage.Events.ServerToPhysics
local helperTable = require(game.ReplicatedStorage.CharacterScripts.HelperTable)
local hitboxTable = helperTable.hitboxTable

print(hitboxTable)
--Needed for remote event interactions
function mainServ.CombatDataServerSender(player, combatData)
	local moduleExample = require(player.CharacterSample.CharacterState.CharacterStateModule)
	for index,item in pairs(game.ReplicatedStorage.Characters:GetChildren()) do
		if item.Name == moduleExample.characterSelected then	
			combatData = item	
		end
	end
	-- Loop to check the character selected and send the data

	return combatData
end



function mainServ.CollisionSetter(item,collisionGroup)
	--item is the model that will be searched through
	--collision Group will be set to this
	local humanList = item:GetChildren()
	for index=1,#humanList,1 do
		if humanList[index]:isA("BasePart") then
			humanList[index].CollisionGroup = collisionGroup
		end

	end
	print(item)
	print(#item)

end
function mainServ.ServerCalls(player,hitboxTable,serverChecker) --msg,playerInPlayers, itemParent, angle, knockback, force)

	
	if serverChecker == "serverCheck" then
		return "ServerCall"
	end

	if hitboxTable ~= player then

		if hitboxTable.msg == "hitbox" or hitboxTable.msg == "Melee" then
			--	print(hitboxTable)	
			local victim = hitboxTable.victimHumanoid
			if hitboxTable.victimPlayer ~= nil then

				victim:TakeDamage(hitboxTable.damage)

				hitboxTable.msg = "hit"
				print(hitboxTable.victimPlayer)
				eventClient:FireClient(hitboxTable.victimPlayer, hitboxTable)
			else if victim then

					if victim.Parent:FindFirstChild("CharacterSample") == nil then
						return victim:TakeDamage(hitboxTable.damage)
					end
					local characterStateTable = require(victim.Parent:FindFirstChild("CharacterSample")
						.CharacterState.CharacterStateModule)
					victim:TakeDamage(hitboxTable.damage)
					--print(playerInPlayers)
					--			print(player)
					--			print(victim)
					victim.WalkSpeed = 0
					victim.JumpPower = 0
					victim.AutoRotate = false
					local victimHumanoidRootPart = victim.Parent.HumanoidRootPart
					local randomAnimSelect = math.random(1,2)
					local hitstunValue = characterStateTable.hitstun
					--local hitstunValue = victim.Parent:FindFirstChild("CharacterSample").CharacterState.Hitstun
					--	print(hitstunValue)
					hitstunValue = true
					--	print(randomAnimSelect)
					---NEW ENTRY
					local distance = (hitboxTable.victimHumanoidRootPart.Position - hitboxTable.attackerPlayer.HumanoidRootPart.Position) --+ HelperModule.hitboxTable.knockbackMultiplier 
					hitboxTable.knockback = (distance * hitboxTable.knockbackMultiplier) + hitboxTable.upForce
					----
					physicsEvent:FireAllClients(victimHumanoidRootPart,hitboxTable)
					if randomAnimSelect == 1 then 
						local animPlay =victim.Animator:LoadAnimation(victim.Parent.CharacterSample.Animations.States.Hitstun1)
						animPlay:Play()
						animPlay:AdjustSpeed(0)
						wait(hitboxTable.duration)
						animPlay:AdjustSpeed(1)
						wait(hitboxTable.duration)
					else
						local animPlay = victim.Animator:LoadAnimation(victim.Parent.CharacterSample.Animations.States.Hitstun2)
						animPlay:Play()
						animPlay:AdjustSpeed(0)
						wait(hitboxTable.duration+0.02)
						animPlay:AdjustSpeed(1)
						wait(hitboxTable.duration)
					end
					victim.WalkSpeed = 25
					victim.JumpPower = 70
					victim.AutoRotate = true
					hitstunValue = false
				end

			end
		end
	end
	
end



return mainServ
