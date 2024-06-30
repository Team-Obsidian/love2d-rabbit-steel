function compassPoint(b, c, radius)
	local a = {}
	local objFrom = b
--	if objFrom == nil then 
	local objTo = c or b
	--used to point to player's target.
	--todo: make default if objTo is nil or radius is nil
	radius = radius or 0



	a.angle = math.atan2(objTo.yPos - objFrom.yPos, objTo.xPos - objFrom.xPos)
	a.xPos = objFrom.xPos + math.cos(a.angle) * radius
	a.yPos = objFrom.yPos + math.sin(a.angle) * radius

	return a
end

-- rotates exactly on a circle if no internal conditional is specified
function tetherPhysics(player, a) --instantaneous teleport but that's okay I guess
	if findDistance(player, a) > a.radius then
		local temp = compassPoint(a, player, a.radius)
		player.xPos = temp.xPos
		player.yPos = temp.yPos
	end
end

-- square hitboxes only exist for enemy attacks, player and enemy hitboxes are always circular
-- todo: fix please, only does exact position, doesn't use radius of object
function ellipseHitbox(a, object)
--width and height describe a and b, not major and minor axis
	local b = compassPoint(object, a, object.radius)
	if object.radius ~= nil then
		local value = (object.xPos-a.xPos)^2/a.width^2 + (object.yPos-a.yPos)^2/a.height^2
		if value <= 1 then
			print('object hit by ellipse')
		end
	elseif object.width ~= nil then

	end
end


function objNumber(inputValue)
	local num = 0
	for i, numberThing in pairs(inputValue) do
		num = num + 1
	end
	return num
end

function playerHit(player)
	--player is hit!
	player.hitTimer = player.hitTimerMax
	player.hitable = false
	--insert timer here
	print('hit: Player '..tostring(player.id))
end

function checkEnemyDeath()
	for i, enemy in pairs(enemyList) do
		if enemy.health <= 0 then
			print('Enemy '..tostring(enemy.id)..' has been defeated.')
			enemyList[i] = nil
		end
	end
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






		--local minValue = math.min(unpack(tempTable))
		

	else
		--print('no enemy to target')
	end
end

function findDistance(object1, object2)
	return math.sqrt((object1.yPos-object2.yPos)^2 + (object1.xPos-object2.xPos)^2)
end




