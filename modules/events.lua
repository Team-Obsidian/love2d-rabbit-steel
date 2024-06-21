eventList = {}
remEvent = {}

graphicList = {}
remGraphic = {}

--[[
function genEvent(e)
	local temp = {}
	temp.type = e.type or 'generic'
	temp.startT = e.startT + currentTime or currentTime + 3
	temp.endT = e.endT + currentTime or currentTime + 5

	return temp
end


--]]

function chooseAttack(event)
	if event.attack == 'attack1' then
		playerAttack1(event)
		playerGraphic1(event)
	end
end

function checkEvents()
	for i, event in pairs(eventList) do
		if currentTime >= event.time then
			table.insert(remEvent, i)
			chooseAttack(event)
		end
	end
end