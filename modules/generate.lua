playerList = {}

function genPlayer(b)
	local a = {}

	a.xPos = b.xPos or winX/2
	a.yPos = b.yPos or winY/2
	a.radius = b.radius or 16

	--effects
    a.rotate = b.rotate or 0
    a.skewX = b.skewX or 0
    a.skewY = b.skewY or 0
    a.opacity = b.opacity or 1

    --battle attributes
    a.hitable = b.hitable or true
    a.speed = 300
    a.facing = 'right'
    a.target = 0

    --cooldowns
    a.globalCD = 0
    a.primaryCD = 0
    a.secondaryCD = 0
    a.specialCD = 0
    a.defensiveCD = 0


    --arbitrary 4 player limit
    for i=1,4 do
    	if playerList[i] == nil then
    		a.id = i
    		break
    	end
    end

    -- auto-insert into table
    if a.id == nil then print('trying to add more then 4 players') else 
    	table.insert(playerList, a.id, a)
    end

end
genPlayer{}



--[[
if enemy.moving:
            enemy.moveTime+= 1
            if enemy.movingType == 'logistic':
                enemy.centerX = (-1/(1+math.e**(-5+enemy.moveTime/enemy.moveTimeMax*10))+1) * (enemy.toX-enemy.initialX) + enemy.initialX
                enemy.centerY = (-1/(1+math.e**(-5+enemy.moveTime/enemy.moveTimeMax*10))+1) * (enemy.toY-enemy.initialY) + enemy.initialY
            if enemy.moveTime == enemy.moveTimeMax:
                enemy.moving = False
            pass 
--]]



