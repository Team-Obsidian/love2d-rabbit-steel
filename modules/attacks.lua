-- aoeAttacks for stuff like crow bullets and wolf screen side
-- (has duration, shape is circle or side(i.e. wolf angle attack))
aoeAttacks = {}
-- bulletAttacks for streams of bullets like ____
-- (has angle, no duration, erased outside of screen boundaries)
bulletAttacks = {}

function playerAttack1(b)
	turnPlayerAround(playerList[b.id], enemyList[playerList[b.id].target])
	local a = {}
	a.shape = b.shape or 'circle'
	a.xPos = b.xPos or winX/2
	a.yPos = b.yPos or winY/2
	a.radius = b.radius or 80
	a.damage = b.damage or 50
	a.duration = b.duration or 0.1

	a.owner = 'player'
	a.id = b.id
	a.player = b.player
	playerList[a.id].globalCD = 1
	playerList[a.id].primaryCD = 1
 
	table.insert(aoeAttacks,a)
	playSound(sfx.attack1, 'cut')
end

function playerAttack2(b)
	turnPlayerAround(playerList[b.id], enemyList[playerList[b.id].target])
	local a = {}
	a.id = b.id
	a.shape = b.shape or 'circle'
	if enemyList[playerList[a.id].target] == nil then
		a.xPos = b.xPos or  playerList[a.id].xPos
		a.yPos = b.yPos or  playerList[a.id].yPos
	else
		a.xPos = b.xPos or enemyList[playerList[a.id].target].xPos
		a.yPos = b.yPos or enemyList[playerList[a.id].target].yPos
	end
	a.radius = b.radius or 40
	a.damage = b.damage or 40
	a.duration = b.duration or 0.1

	a.owner = 'player'


	playerList[a.id].globalCD = 1.2
	playerList[a.id].primaryCD = 1.2
 
	table.insert(aoeAttacks,a)
	playSound(sfx.attack2, 'cut')
end

function enemyAttack1(b)
	local a = {}
	a.shape = b.shape or 'circle'
	a.xPos = b.xPos or winX/2
	a.yPos = b.yPos or winY/2
	a.radius = b.radius or 80
	--a.damage = b.damage or 50
	a.duration = b.duration or 1

	a.owner = 'enemy'
	a.id = b.id

	table.insert(aoeAttacks,a)
	playSound(sfx.attack2, 'cut')
end

function enemyAttack2(b)
	local a = {}
	a.shape = b.shape or 'bullet'
	a.xPos = b.xPos
	a.yPos = b.yPos
	a.radius = b.radius or 10
	--a.duration = b.duration or 1
	a.velocity = b.velocity
	a.angle = b.angle or 0


	--a.owner = 'enemy'
	a.id = b.id
	table.insert(bulletAttacks,a)
	playSound(sfx.attack1, 'cut')
end

function initEnemyAttack2(bulletNum, b)
	for i=1, bulletNum do
		local interval = 0.2
		if b == nil then
			genAttackEvent('enemyAtk2',interval*i,{
				xPos=0,
				yPos=0,
				shape='bullet',
				owner='enemy',
				angle=math.pi/6,
				id=1
			})
		else
			genAttackEvent('enemyAtk2',interval*i,b)			
		end
	end
end

function initEnemyAttack3(a, b)
	--bullet stream aimed directly at you
	local enemy = enemyList[math.random(1, objNumber(enemyList))]
	local playerTarget = playerList[math.random(1,objNumber(playerList))]
	local angleTo = compassPoint(enemy, playerTarget).angle

	local c = {}
	c.xPos=enemy.xPos or b.xPos
	c.yPos=enemy.yPos or b.yPos
	c.shape='bullet' or b.shape
	c.owner='enemy' or b.owner
	c.angle=angleTo or b.angle
	c.velocity = b.velocity or 200 
	c.id=enemy.id or b.id


	for i=1, a.bulletNum do
		genAttackEvent('enemyAtk2',a.interval*i,c)
	end
end

