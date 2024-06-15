--cool!
io.stdout:setvbuf("no")


function love.load()
	music = require('modules/load/mus')
	sfx = require('modules/load/sfx')
	settings = require('modules/load/settings')




end

function love.update(dTime)
	print('time is: '.. tostring(math.floor(love.timer.getTime()*100))/100)

end

function love.draw()

end

function love.keypressed(key, scancode, isrepeat)
	if key == 'z' then
		playSound(sfx.attack1, 'cut')
	end
	if key == 'x' then
		playSound(sfx.attack2, 'cut')
	end

	if key =='q' then
		setVolGlobal(music, 0.3)
	end

	if key == 'a' then
		playMusic(music.web1, 'cut')
	end
	if key == 's' then
		playMusic(music.battle1, 'cut')
	end
end