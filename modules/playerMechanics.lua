-- rotates exactly on a circle if no internal conditional is specified
function tetherPhysics(player, a) --instantaneous teleport but that's okay I guess
	if findDistance(player, a) > a.radius then
		local temp = compassPoint(a, player, a.radius)
		player.xPos = temp.xPos
		player.yPos = temp.yPos
	end
end

function playerHit(player)
	--player is hit!
	player.hitTimer = player.hitTimerMax
	player.hitable = false
	--insert timer here
	print('hit: Player '..tostring(player.id))
end


function playerPassCD(player, timePass)
	--in the future when blocking cooldowns due to status
	--like maybe timestop
	--check and decrease all cooldown timers
	if player.globalCD > 0 then
		player.globalCD = player.globalCD - timePass
	elseif player.globalCD < 0 then
		player.globalCD = 0
	end
	if player.primaryCD > 0 then
		player.primaryCD = player.primaryCD - timePass
	elseif player.primaryCD < 0 then
		player.primaryCD = 0
	end
	if player.secondaryCD > 0 then
		player.secondaryCD = player.secondaryCD - timePass
	elseif player.secondaryCD < 0 then
		player.secondaryCD = 0
	end
	if player.specialCD > 0 then
		player.specialCD = player.specialCD - timePass
	elseif player.specialCD < 0 then
		player.specialCD = 0
	end
	if player.defensiveCD > 0 then
		player.defensiveCD = player.defensiveCD - timePass
	elseif player.defensiveCD < 0 then
		player.defensiveCD = 0
	end
end

function playerTarget(player)
	--auto target closest player, create auto system for tab targetting later
	if objNumber(enemyList) > 0 then
		local distanceTable = {}

		for i, enemy in pairs(enemyList) do
			local distance = findDistance(player, enemy)
			--print(tostring(distance))
			table.insert(distanceTable, i, distance)
		end

		local lowestID = 1
		local lowestValue = math.huge 	--is using math.huge okay...?
		for i, value in pairs(distanceTable) do
			if value < lowestValue then
				lowestID = i
				lowestValue = value
			end
		end

		player.target = enemyList[lowestID]
	end
end