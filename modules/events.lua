eventList = {}
remEvent = {}

graphicList = {}
remGraphic = {}

--causes event in X duration.
playerEvents = {}
remPlayerEvents = {}
function playerEvent(category, duration, id)
	local a = {}
	a.category = category
	a.duration = duration
	a.hasHappened = false
	a.id = id
	table.insert(playerEvents, a)
end

function checkPlayerEvents()
	for i, event in list(playerEvents) do
		if event.duration < 0 then
			if not a.hasHappened then
				if category == 'attack1' then
					playerAttack1{id=event.id}
				end
			end
			table.insert(remPlayerEvents)
		else
			--do nothing
		end
	end
end


--incomplete
function enemyEvent(category, duration, creator)
	local a = {}
	a.category = category
	a.duration = duration

	--[[optional stuff
		a.creator (who does damage belong to?) (what multipliers?)
	--]]

	table.insert(eventList, a)
end

function checkEvents()
	for i, event in pairs(eventList) do
		if event.duration <= 0 then
			table.insert(remEvent, i)
		else
			--check for category
			if event.category == 'attack1' then
				playerAttack1{}
			end
		end
	end
end



