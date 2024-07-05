-- aoeAttacks for stuff like crow bullets and wolf screen side
-- (has duration, shape is circle or side(i.e. wolf angle attack))
aoeAttacks = {}
-- bulletAttacks for streams of bullets like dragons
-- (has angle, no duration, erased outside of screen boundaries)
bulletAttacks = {}

-- Heavyblade's Primary
function playerAttack1(b)

	local a = {}

	a.owner = 'player'
	a.player = b.player
	a.player.globalCD = 1
	a.player.primaryCD = 1

	a.name = 'playerAttack1'
	a.shape = b.shape or 'circle'
	a.xPos = b.xPos or a.player.xPos
	a.yPos = b.yPos or a.player.yPos
	a.radius = b.radius or 80
	a.damage = b.damage or 50
	a.duration = b.duration or 0.1



 	turnPlayerAround(a.player)
	table.insert(aoeAttacks,a)
	playSound(sfx.attack1, 'cut')
end

-- Dancer's Secondary
function playerAttack2(b)
	local a = {}
	a.name = 'playerAttack2'
	a.radius = b.radius or 40
	a.damage = b.damage or 40
	a.duration = b.duration or 0.1

	a.owner = 'player'
	a.player = b.player

	a.player.globalCD = 1.3
	a.player.secondaryCD = 1.3
	a.shape = b.shape or 'circle'


	if a.player.target == nil then
		a.xPos = b.xPos or  a.player.xPos
		a.yPos = b.yPos or  a.player.yPos
	else
		a.xPos = b.xPos or a.player.target.xPos
		a.yPos = b.yPos or a.player.target.yPos
	end

  	turnPlayerAround(a.player)
	table.insert(aoeAttacks,a)
	playSound(sfx.attack2, 'cut')
end


function playerAttack4(b)
	local a = {}

	a.owner = 'player'
	a.player = b.player
--	a.player.globalCD = 1.2
	a.player.defensiveCD = 8
	a.player.hitTimer = 2 	--seconds of invincibility
	
	a.name = 'playerAttack4'
	a.xPos = b.xPos or a.player.xPos
	a.yPos = b.yPos or a.player.yPos
	a.radius = b.radius or 60

	a.damage = b.damage or 0
	a.duration = b.duration or 0.1
	a.shape = b.shape or 'circle'

	a.clearBullets = true

  	--turnPlayerAround(a.player)
	table.insert(aoeAttacks,a)
	playSound(sfx.attack2, 'cut')
end

function enemyAttack1(b)
	local a = {}
	a.name = 'enemyAttack1'
	a.shape = b.shape or 'circle'
	a.xPos = b.xPos or winCamX/2
	a.yPos = b.yPos or winCamY/2
	a.radius = b.radius or 80
	--a.damage = b.damage or 50
	a.duration = b.duration or 1

	a.owner = 'enemy'
	a.enemy = b.enemy
	table.insert(aoeAttacks,a)
	playSound(sfx.attack2, 'cut')
end

function enemyAttack2(b)
	local a = {}
	a.name = 'enemyAttack2'
	a.shape = b.shape or 'bullet'
	a.xPos = b.xPos
	a.yPos = b.yPos
	a.radius = b.radius or 10
	--a.duration = b.duration or 1
	a.velocity = b.velocity
	a.angle = b.angle or 0


	a.owner = 'enemy'
	a.enemy = b.enemy
	table.insert(bulletAttacks,a)
	playSound(sfx.attack1, 'cut')
end

--big laser, dragon
function enemyAttack3(b)
	local a = {}
	a.name = 'enemyAttack3'
	a.shape = b.shape or 'laser'
	a.xPos = b.xPos
	a.yPos = b.yPos
	a.width = b.width or 20
	a.duration = b.duration or 0.5
	a.angle = b.angle or 0
	a.version = b.version or 'single'
	a.owner = 'enemy'
	a.enemy = b.enemy
	a.rotateRate = b.rotateRate or 0
	table.insert(aoeAttacks,a)
	playSound(sfx.attack1, 'cut')
end

--horizontal laser on player
--single-sided lasers only
function initEnemyAttack4(wait,size,duration)
	local randEnemy = enemyList[math.random(1, objNumber(enemyList))]
	local randPlayer = playerList[math.random(1, objNumber(playerList))]
	genAttackEvent('enemyAtk3',wait,{
		xPos=boundL,
		yPos=randPlayer.yPos,
		width=size,
		shape='laser',
		version='double',
		enemy=randEnemy,
		angle=0,
		duration=duration
	})
end

function initEnemyAttack5(wait,size,duration)
	--local randEnemy = enemyList[math.random(1, objNumber(enemyList))]
	local randEnemy = enemyList[1]
	local randPlayer = playerList[math.random(1, objNumber(playerList))]
	genAttackEvent('enemyAtk3',wait,{
		xPos=randEnemy.xPos,
		yPos=randEnemy.yPos,
		width=size,
		shape='laser',
		version='single',
		enemy=randEnemy,
		angle= math.pi,--compassPoint(randEnemy, randPlayer).angle,
		duration=duration,
		rotateRate = 0.1
	})
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
			})
		else
			genAttackEvent('enemyAtk2',interval*i,b)			
		end
	end
end

function initEnemyAttack3(a, b)
	--bullet stream aimed directly at you, random attack from random enemy
	local enemy = a.enemy or enemyList[math.random(1, objNumber(enemyList))]
	local playerTarget = a.player or playerList[math.random(1,objNumber(playerList))]
	local angleTo = compassPoint(enemy, playerTarget).angle

	local c = {}
	c.xPos=b.xPos or enemy.xPos
	c.yPos=b.yPos or enemy.yPos
	c.shape=b.shape or 'bullet'
	c.owner=b.owner or 'enemy'
	c.angle=b.angle or angleTo 
	c.velocity = b.velocity or 200
	c.radius = b.radius or 8 
	c.enemy=enemy


	for i=1, a.bulletNum do
		genAttackEvent('enemyAtk2',a.interval*i,c)
	end
end

