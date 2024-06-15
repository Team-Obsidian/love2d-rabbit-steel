local temp = {}

temp.attack1 = love.audio.newSource('sfx/attack1.wav', 'static')
temp.attack2 = love.audio.newSource('sfx/attack2.wav', 'static')

function setVolGlobal(audioGroup, amount, override)
	--uses full audio group
	if audioGroup == music then
		settings.volume.music = amount
	elseif audioGroup == sfx then
		settings.volume.sfx = amount
	else
		print('[setVolGlobal]Unknown audio type')
	end

	if override == true then
		for i, audio in pairs(audioGroup) do
			--does not take into account modifiers,
			--direct value modification
			audio:setVolume(amount)
		end
	end
end

function setVolNormal(audio, amount)
	--uses individual audio sources
	if audio == nil then
		--exit if audio doesn't exist
		return
	end
	if audio:getType() == 'stream' then
		audio:setVolume(settings.volume.music*amount)
	elseif audio:getType() == 'static' then
		audio:setVolume(settings.volume.sfx*amount)
	else
		print('[setVolNormal]Unknown audio type')
	end
end

playingSounds = {}
function playSound(audio, behavior)
	-- Check for sounds to see if they're already playing

	--default behavior
	if behavior == 'cut' or behavior == nil then
		local alreadyExists = false
		for i, sound in pairs(playingSounds) do
			if sound == audio then
					--does not account for looping or intros?
					--assumes single instance
					alreadyExists = true
					sound:seek(0, 'seconds')
			end
		end
		if alreadyExists == false then
			table.insert(playingSounds, audio)
		end
		love.audio.play(audio)
	elseif behavior == 'overlay' then
		--todo, very confusing, create new sound objects...?
	end
	--to do: define behavior to rapidly fade out old
	--sound and queue the new sound...?				
end





return temp