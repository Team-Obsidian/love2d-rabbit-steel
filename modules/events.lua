eventList = {}
remEvent = {}


function genEvent(e)
	local temp = {}
	temp.type = e.type or 'generic'
	temp.startT = e.startT + currentTime or currentTime + 3
	temp.endT = e.endT + currentTime or currentTime + 5

	return temp
end

function checkEvents()
	for i, event in pairs(eventList) do
		if event.startT > currentTime then
			if event.endT < currentTime then
				--do action
			elseif event.endT >= currentTime then
				--remove from event list *[1]
			end
		end
	end
end