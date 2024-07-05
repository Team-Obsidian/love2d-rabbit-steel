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
	require('modules/misc')

	require('modules/playerMechanics')
	require('modules/eventShortcuts')


	currentTime = 0
	arrow = love.graphics.newImage('img/arrow.png')
	arrow2 = love.graphics.newImage('img/arrow2.png')
	meiryoub = love.graphics.newFont('meiryoub.ttf', 24)
	meiryoubSmall = love.graphics.newFont('meiryoub.ttf', 12)

    function collideCircle(object1, object2) 
        local something = findDistance(object1, object2)
        --print(math.sqrt(something))
        return object1.radius + object2.radius > something
    end

    function turnPlayerAround(player)
    	--bias toward facing right
    	if player.target ~= nil then
	    	if player.xPos > player.target.xPos then player.facing = 'left'
	       	elseif player.xPos <= player.target.xPos then player.facing = 'right' end
	    end
    end


end

function love.update(dTime)
	--currentTime = love.timer.getTime()
	currentTime = currentTime + dTime

	checkInstantEvents(dTime)
	checkTransitionEvent(dTime) -- order is arbitrary, maybe sort later

	checkAttackEvents(dTime)



	checkAttacks(aoeAttacks, dTime)
	checkAttacks(bulletAttacks, dTime)

	--for loop enemyList already included
	checkEnemyDeath()


	local joystickTable = 	love.joystick.getJoysticks()
	for i, joystick in ipairs(joystickTable) do
		local alreadyExists = false
		local joystickID = joystick:getID()

		for i, player in pairs(playerList) do
			if joystickID == player.controllerID then
				alreadyExists = true
			end
		end

		if alreadyExists == false then
			print('new player generated! ID: '..joystickID)
			genPlayer{inputDevice='controller',controllerID=joystickID, color='blue1'}
		end
	end



	for i, playerTemp in pairs(playerList) do
		local playerID = i
		local player = playerTemp
		playerPassCD(player, dTime)


		if player.hitTimer > 0 then
			player.hitTimer = player.hitTimer - player.hitTimerRate*dTime
			player.hitable = false
			--constantly setting hitable to false, may want to remove in future
		elseif player.hitTimer < 0 then
			player.hitTimer = 0
			player.hitable = true
		else
			--do nothing, hit timer is zero
		end

		--if player's enemy is defeated, redirect to lowest id
		-- (in the real game, retargets to nearest enemy in probably every second)
		if objNumber(enemyList) > 0 then
			playerTarget(player)
		end




		--print('player.cutscne: '..player.cutscene)
		if player.cutscene == false then

			--movement
			local vectorX = 0
			local vectorY = 0
			local sqrt2 = math.sqrt(2)
			--print('player.id: '..player.id)
			if player.inputDevice == 'keyboard' then
				--adjust for controllers in future
				if love.keyboard.isDown('z') and player.globalCD == 0 and player.primaryCD == 0 then
					playerAttack1{player=player}
				end
				if love.keyboard.isDown('x') and player.globalCD == 0 and player.secondaryCD == 0 then
					playerAttack2{player=player}
				end
				if love.keyboard.isDown('v') and player.globalCD == 0 and player.defensiveCD == 0 then
					playerAttack4{player=player}
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

				if math.abs(vectorX) == 1 and  math.abs(vectorY) == 1 then 
					vectorX = 1/sqrt2 * vectorX
					vectorY = 1/sqrt2 * vectorY
				end

			elseif player.inputDevice == 'controller' then
				for i, joystick in ipairs(joystickTable) do
					if joystick:getID() == player.controllerID then
						--deadZone could be larger or smaller, multiphase too
						local deadZoneLow = 0.3
						local deadZoneHigh = 0.7
						--6 axis, L2 and R2 are axis 5 and 6
						
						if joystick:isGamepadDown('a') and player.globalCD == 0 and player.primaryCD == 0 then
							playerAttack1{player=player}
						end
						if joystick:isGamepadDown('b') and player.globalCD == 0 and player.primaryCD == 0 then
							playerAttack2{player=player}
						end

						lstickX = joystick:getAxis(1)
						lstickY = joystick:getAxis(2)
						--if holding opposite sides, cancel out
						if math.abs(lstickX) > deadZoneLow then
							--arbitrary lower number
							vectorX = lstickX/math.abs(lstickX)*0.6
						end
						if math.abs(lstickX) > deadZoneHigh then
							vectorX = lstickX/math.abs(lstickX)
						end

						if math.abs(lstickY) > deadZoneLow then
							vectorY = lstickY/math.abs(lstickY)*0.6
						end
						if math.abs(lstickY) > deadZoneHigh then
							vectorY = lstickY/math.abs(lstickY)
						end

					end
				end
			end

			--movement code, diagonals move slower, radial movement
			--very possible to preserve sign more efficiently, todo


			if math.abs(vectorX) == 1 and  math.abs(vectorY) == 1 then 
				vectorX = 1/sqrt2 * vectorX
				vectorY = 1/sqrt2 * vectorY
			end

			--bounds are currently hardcoded to window, 
			--should make it dynamic, like rabbit and steel.
			if player.xPos + player.speed*vectorX*dTime > boundR - boundMargin then
				player.xPos = boundR - boundMargin
				vectorX = 0
			end
			if player.xPos + player.speed*vectorX*dTime < boundL + boundMargin then
				player.xPos = boundL + boundMargin
				vectorX = 0
			end
			if player.yPos + player.speed*vectorY*dTime > boundD - boundMargin then
				player.yPos = boundD - boundMargin
				vectorY = 0
			end
			if player.yPos + player.speed*vectorY*dTime < boundU + boundMargin then
				player.yPos = boundU + boundMargin
				vectorY = 0
			end

			player.xPos = player.xPos + player.speed*vectorX*dTime
			player.yPos = player.yPos + player.speed*vectorY*dTime


		--[[
		tetherPhysics(player, {
			xPos=winCamX/2,
			yPos=winY/2,
			radius=50
		})
		-]]

		end
	end

end

function love.draw()
	displayTimer(true)
	love.graphics.push()
	love.graphics.scale(winScale, winScale)

	for i, enemy in pairs(enemyList) do
		--healthbar
		local vertOffset = -15
		love.graphics.setColor(1, 0.5, 0.5, 1)
		love.graphics.rectangle('fill', 10, winY + vertOffset*i, (winX-20)*enemy.health/enemy.maxHealth, 6)
		love.graphics.rectangle('line', 10, winY + vertOffset*i, winX-20, 6)
	end


	love.graphics.scale(1/gameScale, 1/gameScale)
	


	love.graphics.translate(winCamX/2, winCamY/2 )


		--print('player 1 - xPos: '..playerList[1].xPos..' yPos: '..playerList[1].yPos)


	love.graphics.setColor(color.white1)
	love.graphics.rectangle('line', boundL+boundMargin, boundU+boundMargin, winCamX-2*boundMargin, winCamY-2*boundMargin)


	for i, player in pairs(playerList) do
		--tempOpacity


		local tempOpacity = 1
		if player.hitable == false then
			tempOpacity = 0.5
		end

		if player.color == 'yellow1' then
			love.graphics.setColor(1, 1, 0.5, tempOpacity)
			love.graphics.circle('fill', player.xPos, player.yPos, player.radius)
			love.graphics.setColor(1, 1, 0.5, tempOpacity*0.2)
			love.graphics.circle('fill', player.xPos, player.yPos, 5*player.radius)
			love.graphics.setColor(1, 1, 1, tempOpacity)
			love.graphics.circle('line', player.xPos, player.yPos, 5*player.radius)
		elseif player.color == 'blue1' then
			love.graphics.setColor(0.5, 0.5, 1, tempOpacity)
			love.graphics.circle('fill', player.xPos, player.yPos, player.radius)
			love.graphics.setColor(0.5, 0.5, 1, tempOpacity*0.2)
			love.graphics.circle('fill', player.xPos, player.yPos, 5*player.radius)
			love.graphics.setColor(1, 1, 1, tempOpacity)
			love.graphics.circle('line', player.xPos, player.yPos, 5*player.radius)
		end

		local arrowOffX = 8
		local facingSide = 1
		if player.facing == 'right' then
			facingSide = 1
		elseif player.facing == 'left' then
			facingSide = -1
		end
		love.graphics.draw(arrow, player.xPos + arrowOffX*facingSide, player.yPos, 0, facingSide, 1, 
			arrow:getWidth()/2, arrow:getHeight()/2)

		local targetArrow = compassPoint(player, player.target, 32)
		love.graphics.draw(arrow2, 
			targetArrow.xPos,
			targetArrow.yPos, 
			targetArrow.angle,1,1,
			arrow2:getWidth()/2,arrow2:getHeight()/2
			)





		--love.graphics.draw(
		--drawable, player.xPos, player.yPos, player.rotate, sx, sy, ox, oy, kx, ky)
	end

	for i, enemy in pairs(enemyList) do

		love.graphics.setColor(1, 1, 1, 0.2)
		love.graphics.circle('fill', enemy.xPos, enemy.yPos, enemy.radius)
		love.graphics.setColor(1, 0.5, 0.5, 1)
		love.graphics.circle('line', enemy.xPos, enemy.yPos, enemy.radius)
	end

	--temporary before graphics
	--todo: use attackList to foretell attacks and aoeAttacks or bulletAttacks only for hitbox
	for i, attack in pairs(attackList) do
		if attack.param.shape == 'circle' then
			--again, these commands are the same except for setColors, can be more efficient
			--really sketchy to hardcode this without a universal variable for all versions of this attack's radius
			local a = attack.param.xPos
			local b = attack.param.yPos
			local c = attack.param.radius or 80
			if attack.param.owner == 'player' then
				love.graphics.setColor(0.5, 1,1, 0.3)
				love.graphics.circle('fill', a,b,c)
				love.graphics.setColor(1, 1,1, 0.8)
				love.graphics.circle('line', a,b,c)
			elseif attack.param.owner == 'enemy' then
				--arbitrary lower opacity to fortell attack, graphics later
				love.graphics.setColor(1, 0.5,0.5, 0.3)
				love.graphics.circle('fill', a,b,c)
				love.graphics.setColor(1, 0.5,0.5, 0.5)
				love.graphics.circle('line', a,b,c)			
			end
			--todo, todo, todo
		elseif attack.param.shape == 'side' then
		elseif attack.param.shape == 'bullet' then
			local a = attack.param.xPos
			local b = attack.param.yPos
			local c = attack.param.radius or 10
			local d = attack.param.angle or 0
			local diagonal = (math.sqrt(winCamX^2+winCamY^2))
			love.graphics.line(a, b, math.cos(d)*diagonal + a, math.sin(d)*diagonal + b)
		elseif attack.param.shape == 'laser' then
			local a = attack.param.xPos
			local b = attack.param.yPos
			local c = attack.param.width or 10
			local d = attack.param.angle or 0
			love.graphics.setColor(1, 1, 0, 0.3)
			love.graphics.setLineWidth(c)

			if attack.param.version == 'single' then
				love.graphics.line(a, b, a + math.cos(d)*winCamX, b + math.sin(d)*winCamY)
			elseif attack.param.version == 'double' then
				love.graphics.line(attack.param.xPos - math.cos(attack.param.angle)*winCamX, attack.param.yPos - math.sin(attack.param.angle)*winCamY,
					attack.param.xPos + math.cos(attack.param.angle)*winCamX, attack.param.yPos + math.sin(attack.param.angle)*winCamY)
			end
			love.graphics.setLineWidth(1)
		end
	end

	for i, attack in pairs(aoeAttacks) do
		if attack.shape == 'circle' then
			if attack.owner == 'player' then
				love.graphics.setColor(0.5, 1,1, 0.3)
				love.graphics.circle('fill', attack.xPos, attack.yPos, attack.radius)
				love.graphics.setColor(1, 1,1, 0.8)
				love.graphics.circle('line', attack.xPos, attack.yPos, attack.radius)
			elseif attack.owner == 'enemy' then
				love.graphics.setColor(1, 0.5,0.5, 0.6)
				love.graphics.circle('fill', attack.xPos, attack.yPos, attack.radius)
				love.graphics.setColor(1, 0.5,0.5, 1.0)
				love.graphics.circle('line', attack.xPos, attack.yPos, attack.radius)				
			end
		elseif attack.shape == 'laser' then
			--print('okay')
			love.graphics.setColor(1, 1, 0, 0.5)
			love.graphics.setLineWidth(attack.width)
			if attack.version == 'single' then
				love.graphics.line(attack.xPos, attack.yPos, attack.xPos + math.cos(attack.angle)*winCamX, attack.yPos + math.sin(attack.angle)*winCamY)
			elseif attack.version == 'double' then
				love.graphics.line(attack.xPos - math.cos(attack.angle)*winCamX, attack.yPos - math.sin(attack.angle)*winCamY,
					attack.xPos + math.cos(attack.angle)*winCamX, attack.yPos + math.sin(attack.angle)*winCamY)
			else
				print('weird laser')
			end
			love.graphics.setLineWidth(1)
			--print('attack.xPos '..tostring(attack.xPos))
			--love.graphics.line(attack.xPos, attack.yPos, 0, 0)
		end
	end

	for i, attack in pairs(bulletAttacks) do
		--only 'bullet' shape exists, doesn't need another check
			--print('okay')
		--print(attack.owner)
		--love.graphics.setColor(1, 0.5,0.5, 0.3)
		--love.graphics.circle('fill', attack.xPos, attack.yPos, attack.radius)
		if attack.owner == 'player' then

			--no player attacks actually have bullets, may be unnecessary
			love.graphics.setColor(0.5, 1,1, 0.3)
			love.graphics.circle('fill', attack.xPos, attack.yPos, attack.radius)
			love.graphics.setColor(1, 1,1, 0.8)
			love.graphics.circle('line', attack.xPos, attack.yPos, attack.radius)
		elseif attack.owner == 'enemy' then
			--print('kthen')
			love.graphics.setColor(1, 0.5,0.5, 0.3)
			love.graphics.circle('fill', attack.xPos, attack.yPos, attack.radius)
			love.graphics.setColor(1, 0.5,0.5, 0.8)
			love.graphics.circle('line', attack.xPos, attack.yPos, attack.radius)				
		end
	end


	--better solution for getDelta later
	displayFloatMsg(love.timer.getDelta())

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
		--initEnemyAttack2(5,)
		initEnemyAttack3({
			bulletNum=20,
			interval=0.2,
		},
		{
			velocity = 100,
			radius=6,
			--enemy=enemyList[random]
		})
	end

	if key == 'l' then
		local randPlayer = playerList[math.random(1,objNumber(playerList))]
		--hardcoding, randomize target later
		genAttackEvent('enemyAtk1', 1.5, {
			id=randPlayer.id,
			xPos=randPlayer.xPos,
			yPos=randPlayer.yPos,
			shape='circle',
			owner='enemy',
			duration = 3
		})
	end

	if key =='p' then
		print('num of enemies: '..objNumber(enemyList))
		--print('num of objs in bulletAttacks: ' .. tostring(objNumber(bulletAttacks)))
	end

	if key =='1' then
		genTransitionEvent{
			category='cameraScale',
			variable='xPos',
			maxDuration=1,
			ease='sineEaseOut',
			init=gameScale,
			final=1.2
		}
	end

	if key == '2' then
		genTransitionEvent{
			category='cameraScale',
			variable='xPos',
			maxDuration=1.5,
			ease='sineEaseOut',
			init=gameScale,
			final=0.95
		}
	end

	if key == '3' then
		movePlayers(0,0,1.5)
	end

	if key =='4' then
		movePlayersScene(2)
	end

	if key == '5' then
		initEnemyAttack4(2.5,50,20)
	end

	if key == '6' then
		initEnemyAttack5(2.5,50,10)
	end

end