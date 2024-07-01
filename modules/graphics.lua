local width, height = love.window.getDesktopDimensions()
winX = 640
winY = 360
--only if you want maximized window something something
--winScale = 3
--winScale = 0.5 * math.min(width/winX, height/winY)
winScale = 1

love.window.setMode(winX*winScale,winY*winScale)


floatMsg = {}

function genFloatMsg(b)
	local a = {}
	--add the initial offset X and Y into xPos, when generating
	a.xPos = b.xPos or winCamX/2
	a.yPos = b.yPos or winCamY/2
	a.duration = 0
	a.maxDuration = b.maxDuration or 1
	a.text = b.text or 'this message is empty'
	a.color = b.color or color.white1
	--a.effect = b.effect or nil
	table.insert(floatMsg, a)
end

function displayFloatMsg(timePass)
	local floatScale= 30 -- pixels, arbitrary float rate
	local fadePercent = 0.5
	for i, msg in pairs(floatMsg) do
		if msg.duration > msg.maxDuration then
			floatMsg[i] = nil
		else
			local floatY = -msg.duration*floatScale
			local opacity = 1
			if msg.duration/msg.maxDuration > fadePercent then
				opacity = 1 - ((msg.duration/msg.maxDuration-fadePercent)/(1-fadePercent))
			end
			--print('opacity is '..opacity)
		--future room for text effects...
		--love.graphics.print(text, msg.xPos, msg.yPos, 0, 1, 1, 0, 0, 0, 0)
			local displayColor = {}

		--pretty inefficient to iterate for every single color but oh well
			for i, value in pairs(msg.color) do
				table.insert(displayColor, value)
			end
			table.insert(displayColor, opacity)

			--print('object number of yellow1 is '..objNumber(displayColor))
			love.graphics.setColor(unpack(displayColor))
			--love.graphics.setColor(1, 1, 1, 0.1)
			--love.graphics.setColor(unpack(msg.color), opacity)
			love.graphics.print(msg.text, meiryoubSmall, msg.xPos, msg.yPos + floatY)
		end

		msg.duration = msg.duration + timePass
	end
end




color = {
	yellow1={1,1,0.5},
	yellow2={},
	yellow3={},
	blue1={0.5,0.5,1}, --done
	blue2={},
	blue3={},
	red1={0.5,0.5,1},
	red2={},
	red3={},
	green1={0.5,0.5,1},
	green2={},
	green3={},
	white1={1,1,1},
	white2={},
	white3={},
	black1={0.5,0.5,1},
	black2={},
	black3={},

}





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

	love.graphics.setColor(unpack(color.white1))

	love.graphics.print( 
		displayText1 ..
		displayText2 ..
		displayText3 ..
		displayText4
		,meiryoub,0,0)
end
