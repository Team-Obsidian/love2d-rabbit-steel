local temp = {}



temp.battle1 = love.audio.newSource('mus/fate-battle1.mp3', 'stream')
temp.web1 = love.audio.newSource('mus/loveweb3.mp3', 'stream')
temp.explore1 = love.audio.newSource('mus/etrian-labyrinth.mp3', 'stream')


playingMusic = {}
function playMusic(audio, behavior)
	-- Check for sounds to see if they're already playing
	audio:setVolume(settings.volume.music)
	--default behavior
	if behavior == 'cut' or behavior == nil then
		local alreadyExists = false
		for i, sound in pairs(playingMusic) do
			love.audio.stop(sound)
			if sound == audio then
					--does not account for looping or intros?
					--assumes single instance
					alreadyExists = true
					sound:seek(0, 'seconds')
			end
		end
		if alreadyExists == false then
			--only one song at a time, bad for crossfade
			playingMusic = {audio}
		end
		love.audio.play(audio)
	elseif behavior == 'crossfade' then
		--todo, add and control crossfade behavior somehow
	end				


end


function toggleLoop(audio, value)
	if type(value) == 'boolean' then
		audio:setLooping(value)
	elseif value == 'toggle' then
		audio:setLooping(not audio:isLooping())
	end
end

for i, value in pairs(temp) do
	toggleLoop(value, true)
end

return temp
