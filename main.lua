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

end

function love.update(dTime)
	currentTime = love.timer.getTime()


	for i, player in pairs(playerList) do
		local vectorX = 0
		local vectorY = 0
		--print('player.id: '..player.id)
		if player.id == 1 then
			--adjust for controllers in future

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

	for i, player in pairs(playerList) do
		love.graphics.setColor(1, 1, 0.5, 1)
		love.graphics.circle('fill', player.xPos, player.yPos, player.radius)
		--love.graphics.draw(
		--drawable, player.xPos, player.yPos, player.rotate, sx, sy, ox, oy, kx, ky)
	end

end

function love.keypressed(key, scancode, isrepeat)
	if key == 'z' then
		playSound(sfx.attack1, 'cut')
	end
	if key == 'x' then
		playSound(sfx.attack2, 'cut')
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