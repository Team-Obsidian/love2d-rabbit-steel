winX = 640
winY = 360
winScale = 3
love.window.setMode(winX*winScale,winY*winScale)

function displayTimer(fps)
	--print(tostring(tonumber(tostring(0))))
	local displayText1 = tostring(math.floor(currentTime / 60))
	local displayText2 = tostring(math.floor(currentTime % 60))
	local displayText3 = tostring(math.floor((currentTime - math.floor(currentTime))*100))
	local displayText4 = ''
	if tonumber(displayText1) < 10 then 
		displayText1 = '0' .. displayText1..'\''
	else
		displayText1 = displayText1 .. '\"'
	end
	--print(currentTime)
	if tonumber(displayText2) < 10 then 
		displayText2 = '0' .. displayText2.. '\"'
	else
		displayText2 = displayText2 .. '\"'
	end

	if tonumber(displayText3) < 10 then 
		displayText3 = '0' .. displayText3
	else
		--displayText3 = displayText2 .. '\"'
	end

	if fps == true then
		displayText4 = ' '.. tostring(math.floor(love.timer.getFPS()*100)/100)
	end

	love.graphics.print( 
		displayText1 ..
		displayText2 ..
		displayText3 ..
		displayText4
		,meiryoub,0,0)
end
