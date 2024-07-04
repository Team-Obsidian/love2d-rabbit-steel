
function movePlayers(toX,toY,time)
	for i, player in pairs(playerList) do
		player.cutscene = true

		genInstantEvent{
			table = player,
			variable='cutscene',
			maxDuration=time,
			value=false
		}

		genTransitionEvent{
			table=player,
			variable='xPos',
			--duration=2,
			ease='sineEaseOut',
			maxDuration=time,
			init=player.xPos,
			final=toX
		}

		genTransitionEvent{
			table=player,
			variable='yPos',
			--duration=2,
			ease='sineEaseOut',
			maxDuration=time,
			init=player.yPos,
			final=toY
		}
	end
end

function movePlayersScene(time)
	local playerNum = objNumber(playerList) + 1
	for i, player in pairs(playerList) do
		local tempVar = i + 1
		player.cutscene = true

		genInstantEvent{
			table = player,
			variable='cutscene',
			maxDuration=time,
			value=false
		}

		genTransitionEvent{
			table=player,
			variable='xPos',
			--duration=2,
			ease='sineEaseOut',
			maxDuration=time,
			init=player.xPos,
			final= winCamX *0.15 + boundL 
		}

		genTransitionEvent{
			table=player,
			variable='yPos',
			--duration=2,
			ease='sineEaseOut',
			maxDuration=time,
			init=player.yPos,
			final= winCamY * (i / playerNum) + boundU 
		}
	end
end