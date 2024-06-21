--hello
attackList = {}
remAttack = {}

function queueAttack(b)
	local a = {}
	a.attack = b.attack
	--wizard primary, sends object from player to enemy / projectiles
	--start position required, used if non
	a.startPosX = b.startPosX
	a.startPosY = b.startPosY
	--can't decide between nil or equal to startPos, todo
	a.endPosX = b.endPosX or a.startPosX
	a.endPosY = b.endPosY or a.startPosY

	--set end time exact, according to ingame timer
	--happens in ___ seconds
	a.time = currentTime + b.time or currentTime + 1

	table.insert(eventList,a)
end

function queueGraphic(b)
	local a = {}
	a.graphic = b.graphic

	a.startPosX = b.startPosX
	a.startPosY = b.startPosY
	a.endPosX = b.endPosX or a.startPosX
	a.endPosY = b.endPosY or a.startPosY


	a.delay = b.delay or 1
	a.duration = b.duration or 1

	--table.insert(attackList,a)
end

function playerAttack1(b)
	local a = {}
	a.shape = b.shape or 'circle'
	a.xPos = b.xPos or winX/2
	a.yPos = b.yPos or winY/2
	a.radius = b.radius or 80
	a.damage = b.damage or 50
	a.duration = b.duration or 0.3

	a.owner = 'player'
	a.id = b.id

	playerList[a.id].globalCD = 0.5
	playerList[a.id].primaryCD = 0.5

	table.insert(attackList,a)
	playSound(sfx.attack2, 'cut')
	--return a
end

function playerPrimary(player)
	-- non-variable stuff, only does player default
	-- hard-coded essentially.

	--attacks are instant
	queueAttack{
		attack='attack1',
		startPosX=player.xPos,
		startPosY=player.yPos,
		time=1
	}

	--graphics have duration
	queueGraphic{
		graphic='circle',
		startPosX=player.xPos,
		startPosY=player.yPos,
		--uh,really?
		time=0.5,
		duration=1
	}

end