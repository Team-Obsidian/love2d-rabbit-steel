

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

function checkAttackEvents(timePass)
	--print('test occured')
	for i, event in pairs(attackList) do
		--print('test')
		if event.duration <= 0 then
			if event.category == 'playerAtk1' then
				playerAttack1(event.param)
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
			local margin = 50
			--need to create margin for error, or maybe some camera function
			--in the future, make alternative check for if a hitbox has crossed paths with the bullet
			--and not just its immediate hitbox, but its path
			if attack.xPos < -margin or attack.xPos > winX + margin or attack.yPos < -margin or attack.yPos > winY + margin then
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
				if attack.owner == 'enemy' then
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

							--adjust text position later, text for now
							--also adjust color later
							genFloatMsg{
								xPos=enemy.xPos + math.random(-10,10),
								yPos=enemy.yPos + math.random(-10,10),
								text=tostring(attack.damage),
								color=color[attack.player.color]
							}

							enemy.health = enemy.health - attack.damage
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








