playerList = {}
enemyList = {}

function genPlayer(b)
	local a = {}

	a.xPos = b.xPos or winX/2
	a.yPos = b.yPos or winY/2
	a.radius = b.radius or 4

	--effects
    a.rotate = b.rotate or 0
    a.skewX = b.skewX or 0
    a.skewY = b.skewY or 0
    a.opacity = b.opacity or 1

    --battle attributes
    a.hitable = b.hitable or true
    a.hitTimerMax = b.hitTimerMax or 1.5
    a.hitTimer = b.hitTimerMax or 0
    a.hitTimerRate = b.hitTimerRate or 1

    a.speed = 200
    a.facing = 'right'
    a.target = 0

    --cooldowns
    a.globalCD = 0
    a.primaryCD = 0
    a.secondaryCD = 0
    a.specialCD = 0
    a.defensiveCD = 0


    a.maxHealth = 5
    a.health = a.maxHealth

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

function genEnemy(b)
    local a = {}

    a.xPos = b.xPos or winX*2/3
    a.yPos = b.yPos or winY/2
    a.radius = b.radius or 100

    --effects
    a.rotate = b.rotate or 0
    a.skewX = b.skewX or 0
    a.skewY = b.skewY or 0
    a.opacity = b.opacity or 1

    --a.speed = 200
    a.facing = 'right'
    --a.target = 0


    a.health = 500
    a.maxHealth = a.health

    --arbitrary 8 enemy limit
    for i=1,8 do
        if enemyList[i] == nil then
            a.id = i
            break
        end
    end

    -- auto-insert into table
    if a.id == nil then print('trying to add more then 8 enemies') else 
        table.insert(enemyList, a.id, a)
    end

end
genEnemy{}
genEnemy{xPos=winX/3}


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



