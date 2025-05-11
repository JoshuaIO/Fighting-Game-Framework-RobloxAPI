local mainServ = {}
local event = game.ReplicatedStorage.Events.MainAction
local eventClient =game.ReplicatedStorage.Events.MainActionClient
local eventSendToAll = game.ReplicatedStorage.Events.SendServerToClient
local eventSendToServerCast = game.ReplicatedStorage.Events.SendToServerFromCombatWriter

local physicsEvent = game.ReplicatedStorage.Events.ServerToPhysics
local helperTable = require(game.ReplicatedStorage.CharacterScripts.HelperTable)
local clientToClientSend = game.ReplicatedStorage.Events.ClientToClientSend
local hitboxTableR = helperTable.hitboxTable


-- get player from character, if nil, player to hitstun

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
--Needed for remote event interactions
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


function mainServ.SendDataToAllClients(player,object)
	--print("PROJECTO:", player, object)
	--fireserver and send to client
	print("PROJECTILE AREA: ", object)
	eventSendToAll:FireAllClients(object, object.projectileTravelSpeed)
	
	
end
function mainServ.ServerCalls(player,hitboxTable,serverChecker) --msg,playerInPlayers, itemParent, angle, knockback, force)

	if serverChecker == "serverCheck" then
		return "ServerCall"
	end
--hitbox msg is for server, make sure script works well for multiple instances
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
					print("USER HIT: ", victim.Parent)
					print("HITBOX SERVER TABLE", hitboxTable)
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
					physicsEvent:FireAllClients(hitboxTable)
				
				end
			end
		end
		
	end
	
	
end



return mainServ
