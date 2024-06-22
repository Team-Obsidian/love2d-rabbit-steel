

graphicList = {}
remGraphic = {}


attackList = {}
function genAttack(category, duration, param)
	--single use events
	local a = {}
	a.category = category
	a.duration = duration
	a.param = param
	table.insert(attackList, a)
end

function checkAttacks(timePass)
	--print('test occured')
	for i, event in pairs(attackList) do
		--print('test')
		if event.duration < 0 then
			if event.category == 'playerAtk1' then
				playerAttack1(event.param)
			elseif event.category == 'enemyAtk1' then
				enemyAttack1(event.param)
			end
			attackList[i] = nil
		else
			event.duration = event.duration - timePass
		end
	end
end





