--cool!
io.stdout:setvbuf("no")


function love.load()
	music = require('modules/load/mus')
	sfx = require('modules/load/sfx')
	settings = require('modules/load/settings')

	require('modules/events')
	require('modules/graphics')
	require('modules/generate')

	require('modules/attacks')


	currentTime = 0	
	meiryoub = love.graphics.newFont('meiryoub.ttf', 36)

    function collideCircle(object1, object2) 
        local something = (object2.xPos - object1.xPos)^2 + (object2.yPos - object1.yPos)^2
        --print(math.sqrt(something))
        return (object1.radius + object2.radius > math.sqrt(something))
    end


end

function love.update(dTime)
	--currentTime = love.timer.getTime()
	currentTime = currentTime + dTime




	for i, attack in pairs(attackList) do
		if attack.duration < 0 then
			table.insert(remAttack, i)
		else
			--assumes enemy hitbox for now
			if attack.shape == 'circle' then
				if attack.owner == 'enemy' then
					for i, player in pairs(playerList) do
						--check circular collision
						if collideCircle(player, attack) and player.hitable then
							--player is hit!
							player.hitTimer = player.hitTimerMax
							player.hitable = false
							--insert timer here
							print('hit: Player '..tostring(player.id))
						end
					end
				elseif attack.owner == 'player' then
					for i, enemy in pairs(enemyList) do
						--check circular collision
						if collideCircle(enemy, attack) then
							--enemy is hit, duration autoset to -1 if hit (because hitbox)
							--no lingering player bullet hitbox
							enemy.health = enemy.health - attack.damage
							--insert timer here
							print('hit: Enemy '..tostring(enemy.id))
							attack.duration = -1

							if enemy.health <= 0 then
								print('Enemy '..tostring(enemy.id)..' has been defeated.')
								enemyList[i] = nil
								--table.remove(enemyList, i)
							end

						end
					end
				end
			end

			attack.duration = attack.duration - dTime
		end
	end

	for i, entry in pairs(remAttack) do
		attackList[entry] = nil
	end
	remAttack = {}



	--movement
	for i, player in pairs(playerList) do

		--check and decrease all cooldown timers
		if player.globalCD > 0 then
			player.globalCD = player.globalCD - dTime
		elseif player.globalCD < 0 then
			player.globalCD = 0
		end
		if player.primaryCD > 0 then
			player.primaryCD = player.primaryCD - dTime
		elseif player.primaryCD < 0 then
			player.primaryCD = 0
		end
		if player.secondaryCD > 0 then
			player.secondaryCD = player.secondaryCD - dTime
		elseif player.secondaryCD < 0 then
			player.secondaryCD = 0
		end
		if player.specialCD > 0 then
			player.specialCD = player.specialCD - dTime
		elseif player.specialCD < 0 then
			player.specialCD = 0
		end
		if player.defensiveCD > 0 then
			player.defensiveCD = player.defensiveCD - dTime
		elseif player.defensiveCD < 0 then
			player.defensiveCD = 0
		end

		--movement
		local vectorX = 0
		local vectorY = 0
		--print('player.id: '..player.id)
		if player.id == 1 then
			--adjust for controllers in future
			if love.keyboard.isDown('z') and player.globalCD == 0 and player.primaryCD == 0 then
				playerAttack1{xPos=player.xPos,yPos=player.yPos,id=1}
			end
			--if holding opposite sides, cancel out
			if love.keyboard.isDown('left') then
				vectorX = vectorX - 1
			end
			if love.keyboard.isDown('right') then
				vectorX = vectorX + 1
			end
			if love.keyboard.isDown('up') then
				vectorY = vectorY - 1
			end
			if love.keyboard.isDown('down') then
				vectorY = vectorY + 1
			end
		elseif player.id == 2 then
		elseif player.id == 3 then
		elseif player.id == 4 then
		end

		--movement code, diagonals move slower, radial movement
		--very possible to preserve sign more efficiently, todo

		if vectorX == vectorY and vectorX > 0 then 
			vectorX = 1/math.sqrt(2)
			vectorY = 1/math.sqrt(2)
		elseif vectorX == vectorY and vectorX < 0 then
			vectorX = -1/math.sqrt(2)
			vectorY = -1/math.sqrt(2)
		end

		player.xPos = player.xPos + player.speed*vectorX*dTime
		player.yPos = player.yPos + player.speed*vectorY*dTime

	end

end

function love.draw()
	displayTimer(true)
	love.graphics.push()
	love.graphics.scale(winScale, winScale)


	for i, player in pairs(playerList) do
		love.graphics.setColor(1, 1, 0.5, 1)
		love.graphics.circle('fill', player.xPos, player.yPos, player.radius)
		love.graphics.setColor(1, 1, 0.5, 0.2)
		love.graphics.circle('fill', player.xPos, player.yPos, 5*player.radius)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.circle('line', player.xPos, player.yPos, 5*player.radius)
		--love.graphics.draw(
		--drawable, player.xPos, player.yPos, player.rotate, sx, sy, ox, oy, kx, ky)
	end

	for i, enemy in pairs(enemyList) do
		love.graphics.setColor(1, 1, 1, 0.2)
		love.graphics.circle('fill', enemy.xPos, enemy.yPos, enemy.radius)
		love.graphics.setColor(1, 0.5, 0.5, 1)
		love.graphics.circle('line', enemy.xPos, enemy.yPos, enemy.radius)
		--healthbar
		love.graphics.setColor(1, 0.5, 0.5, 1)
		love.graphics.rectangle('fill', 10, winY-20, (winX-20)*enemy.health/enemy.maxHealth, 10)
		love.graphics.rectangle('line', 10, winY-20, winX-20, 10)


	end

	--temporary before graphics
	for i, attack in pairs(attackList) do
		love.graphics.setColor(0.5, 1,1, 0.3)
		love.graphics.circle('fill', attack.xPos, attack.yPos, attack.radius)
		love.graphics.setColor(1, 1,1, 0.8)
		love.graphics.circle('line', attack.xPos, attack.yPos, attack.radius)
	end

	love.graphics.pop()

end

function love.keypressed(key, scancode, isrepeat)
	if key == 'z' then

	end
	if key == 'x' then

	end

	if key =='q' then
		setVolNormal(playingMusic[1], 0.5)
	end

	if key =='w' then
		setVolNormal(playingMusic[1], 1.0)
	end

	if key == 'a' then
		playMusic(music.web1, 'cut')
	end
	if key == 's' then
		playMusic(music.battle1, 'cut')
	end
	if key == 'd' then
		playMusic(music.explore1, 'cut')
	end

	if key == 'j' then

	end

	if key == 'k' then

	end

	if key == 'l' then

	end

end