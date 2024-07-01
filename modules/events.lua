

graphicList = {}
remGraphic = {}


attackList = {}
function genAttackEvent(category, duration, param)
	--single use events
	local a = {}
	a.category = category
	a.duration = duration
	a.maxDuration = duration
	a.param = param


	table.insert(attackList, a)
end


transitionList = {}
function genTransitionEvent(category, duration, param)
	--no timing type besides linear, determine that in the interpreter
	local a = {}
	a.category = category
	a.duration = 0
	a.maxDuration = duration
	a.param = param
	table.insert(transitionList, a)
end


function checkTransitionEvent(timePass)
	for i, event in pairs(transitionList) do
		if event.duration <= event.maxDuration then
			if event.category == 'cameraScale' then
				--uses change bounds, but another function should be made later to change bounds independently of camera
				changeBounds(((event.param.final-event.param.init) *  event.duration/event.maxDuration) + event.param.init)

			elseif event.category == 'playerMovement' then
				--insert player movement cutscene here
				local tempValueX = (event.param.finalPosX-event.param.initPosX) *  (event.duration/event.maxDuration) + event.param.initPosX
				local tempValueY = (event.param.finalPosY-event.param.initPosY) *  (event.duration/event.maxDuration) + event.param.initPosY
				event.param.player.xPos = tempValueX
				event.param.player.yPos = tempValueY
			else -- any direct variable not given a specific scenario
				local tempValue = (event.param.final-event.param.init) *  (event.duration/event.maxDuration) + event.param.init
				print(tempValue)
				--event.category = tempValue
				playerList[1].xPos = tempValue
				--print('event.category is: ' .. event.category)
			end

			
		elseif event.duration > event.maxDuration then
			if event.category == 'cameraScale' then
				changeBounds(event.param.final)
			else -- any direct variable not given a specific scenario
				event.category = event.param.final
				print('time over')
			end
			
			transitionList[i] = nil --after everything else is finished
		end

		event.duration = event.duration + timePass
	end
end

function checkAttackEvents(timePass)
	--print('test occured')
	for i, event in pairs(attackList) do
		--print('test')
		if event.duration <= 0 then
			if event.category == 'playerAtk1' then
				playerAttack1(event.param)
			elseif event.category == 'playerAtk2' then
				playerAttack2(event.param)
			elseif event.category == 'enemyAtk1' then
				enemyAttack1(event.param)
			elseif event.category == 'enemyAtk2' then
				--print('ooookie')
				enemyAttack2(event.param)
			end
			attackList[i] = nil
		else
			event.duration = event.duration - timePass
		end
	end
end

function checkAttacks(category, timePass)
	for i, attacking in pairs(category) do
		local attack = attacking
		--everything is based on shape, done to make working with
		--category parameter easier, harder to compartmentalize
		if attack.shape == 'bullet' then
			local margin = 10
			--need to create margin for error, or maybe some camera function
			--in the future, make alternative check for if a hitbox has crossed paths with the bullet
			--and not just its immediate hitbox, but its path
			if attack.xPos < boundL-margin or attack.xPos > boundR + margin or attack.yPos < boundL-margin or attack.yPos > boundR + margin then
				--attack.duration = -1
				category[i] = nil
				--print('bad')
			else
				--print('attack.owner is '.. tostring(attacking.owner))
				-- potential future consequences, whether hitbox happens before or after the bullet is moved
				if attack.owner == 'enemy' then
					for i, player in pairs(playerList) do
						print(tostring(collideCircle(player,attack)))
						if collideCircle(player,attack) and player.hitable then
							playerHit(player)
						end
					end

				elseif attack.owner == 'player' then
					for i, enemy in pairs(enemyList) do
						if collideCircle(enemy,attack) then
							--enemy gets hit
							if attack.damage ~= nil then
								--damage calculation


								enemy.health = enemy.health - attack.damage
							else
								print('this attack has no damage haha')
							end
						end
					end
				end
				--bullet movement here
				attack.xPos = attack.xPos + math.cos(attack.angle)*attack.velocity*timePass
				attack.yPos = attack.yPos + math.sin(attack.angle)*attack.velocity*timePass
			end
		elseif attack.duration >= 0 then
			if attack.shape == 'circle' then
				if attack.clearBullets == true then
					checkBulletClear(attack)
				elseif attack.owner == 'enemy' then
					for i, player in pairs(playerList) do
						--check circular collision
						if collideCircle(player, attack) and player.hitable then
							playerHit(player)
						end
					end
				elseif attack.owner == 'player' then
					for i, enemy in pairs(enemyList) do
						--check circular collision
						if collideCircle(enemy, attack) then
							local calculatedAttack = randomizePlayerDamage(attack)
							local critMessage = ''
							if calculatedAttack.critical then
								critMessage = '!'
							end

							--adjust text position later, text for now
							--also adjust color later
							genFloatMsg{
								xPos=enemy.xPos + math.random(-10,10),
								yPos=enemy.yPos + math.random(-10,10),
								text=tostring(calculatedAttack.damage) .. critMessage,
								color=color[attack.player.color]
							}

							--enemy.health = enemy.health - attack.damage
							enemy.health = enemy.health - calculatedAttack.damage


							print('hit: Enemy '..tostring(enemy.id)..
								' | remaining : '..enemy.health..'/'..enemy.maxHealth)
							attack.duration = -1
							--category[i] = nil
							--for some reason, using category[i] = nil didn't work
							--one object took damage normal, the other took 5 hits in a row
							--now I'm concerned about bullets...
						end
					end
				end
			elseif attack.shape == 'side' then
				--todo later
			end
		else
			category[i] = nil
		end
		if attack.duration ~= nil then
			attack.duration = attack.duration - timePass
		end
	end
end


--all damage is calculated from here, changing data is practically global
function randomizePlayerDamage(attack)

	local critIncrease = 1
	local critHasHappened = false
	--local randomValue = math.random()
	--30% chance for a crit, that deal 75% extra damage
	if math.random() <= 0.3 then
		critIncrease = 1.75
		critHasHappened = true
	end


	local baseDmg
	local percentVariance = 0.2
	--example: 0.8 to 1.2, 0.2*2 = 0.4, math.random()*0.4 + 0.8
	local modifiedDamage = 2*percentVariance*math.random() + (1-percentVariance)
	--critical hits deal 75% more damage

	if attack.name == 'playerAttack1' then
		--	return baseDmg*modifiedDamage * (1 + attack.player.level/100) * attack.player.primaryModifers
		baseDmg = 50
	elseif attack.name == 'playerAttack2' then
		baseDmg = 40
	end


	--primary modifiers like the 20% increase from gear, rabbit and steel


	return {damage=math.floor(baseDmg*modifiedDamage*critIncrease),critical=critHasHappened} --the flooring is arbitrary...

end

