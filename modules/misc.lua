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



function checkEnemyDeath()
	for i, enemy in pairs(enemyList) do
		if enemy.health <= 0 then
			print('Enemy '..tostring(enemy.id)..' has been defeated.')
			enemyList[i] = nil
		end
	end
end


function findDistance(object1, object2)
	return math.sqrt((object1.yPos-object2.yPos)^2 + (object1.xPos-object2.xPos)^2)
end

winCamX = 640
winCamY = 360
gameScale = 1
boundL = -winCamX/2
boundR = winCamX/2
boundU = -winCamY/2
boundD = winCamY/2
boundMargin = 10

function changeBounds(scale)
	gameScale = scale
	winCamX = 640 * gameScale
	winCamY = 360 * gameScale

	boundL = -winCamX/2
	boundR = winCamX/2
	boundU = -winCamY/2
	boundD = winCamY/2
	--boundMargin = 10
	--benefits greatly from using some timing function...

end
changeBounds(1.5)

function checkBulletClear(attack)
	-- insta-clears bullets, later should be put in a delete list so animations can still play
	for i, bullet in pairs(bulletAttacks) do
		if collideCircle(attack, bullet) then
			bulletAttacks[i] = nil
		end
	end
end