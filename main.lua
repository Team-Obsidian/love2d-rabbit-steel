--cool!
io.stdout:setvbuf("no")


function love.load()
	music = require('modules/load/mus')
	sfx = require('modules/load/sfx')
	settings = require('modules/load/settings')

	meiryoub = love.graphics.newFont('meiryoub.ttf', 36)

end

function love.update(dTime)
	currentTime = love.timer.getTime()

	print('time is: '.. tostring(math.floor(love.timer.getTime()*100))/100)

end

function love.draw()

	--love.graphics.scale(3, 3)
	local displayText1 = tostring(math.floor(currentTime / 60))
	local displayText2 = tostring(math.floor(currentTime % 60))
	if tonumber(displayText1) < 10 then 
		displayText1 = '0' .. displayText1..'\''
	else
		displayText2 = displayText2 .. '\"'
	end
	if tonumber(displayText2) < 10 then 
		displayText2 = '0' .. displayText2.. '\"'
	else
		displayText2 = displayText2 .. '\"'
	end

	love.graphics.print( 
		displayText1 ..
		displayText2 ..
		tostring(math.floor((currentTime - math.floor(currentTime))*100))
		,meiryoub,0,0)



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
end