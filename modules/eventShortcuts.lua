
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