local createdBlips = {}
local serverId = cache.serverId

lib.onCache('serverId', function(value)
	serverId = value
end)

local trackId = nil

function openTracker(data, slot)

	local options = {}



	local isEnabled = isEnabled or false
	trackId = trackId or false


	if trackId then

		options[#options + 1] = { title = ('Dabartinis GPS sekiklio dažnis: %s'):format(trackId) }

	end



	options[#options + 1] = { 

		title = 'Įvesti GPS sekiklio dažnį',

		onSelect = openTrackIdControl

	}

	

	options[#options + 1] = { 

		title = isEnabled and 'Išjungti GPS sekiklį' or 'Įjungti GPS sekiklį',

		onSelect = function()

			toggleTracker(not isEnabled)

		end,

	}



	lib.registerContext({

		id = 'blombino-tracker:openTracker',

		title = 'GPS sekiklio valdymas',

		options = options

	})

	

	lib.showContext('blombino-tracker:openTracker')

end



function openTrackIdControl()

	local input = lib.inputDialog('Dažnio valdymas', {'GPS sekiklio dažnis'})



	if input then 

		local newTrackId = tonumber(input[1])

		local isAllowed = true



		if Tracker.PrivateChannels[newTrackId] then

			isAllowed = false

			local playerJob = ESX.PlayerData.job.name



			for _, job in pairs(Tracker.PrivateChannels[newTrackId]) do

				if playerJob == job and exports.esx_service:isInService(job) then

					isAllowed = true

					break

				end

			end

		end



		if isAllowed then

			if isEnabled and trackId and newTrackId ~= trackId then

				TriggerServerEvent('blombino-tracker:remove', trackId)

			end



			trackId = newTrackId



			if isEnabled then

				TriggerServerEvent('blombino-tracker:add', trackId)

			end

		else

			ESX.ShowNotification('Šis dažnis yra privatus ir į jį prisijungti jūs negalite!', 'error') 

		end

	end



	openTracker()

end



function toggleTracker(newToggle, newTrackId)

	if newToggle then

		if newTrackId then

			if isEnabled and newTrackId ~= trackId then

				TriggerServerEvent('blombino-tracker:remove', trackId)

			end



			trackId = newTrackId

		end

		

		if not trackId then 

			ESX.ShowNotification('Prieš įjungiant GPS sekiklį jūs turite įvesti sekiklio dažnį!', 'error') 

			return openTracker()

		end

	end



	isEnabled = newToggle



	if isEnabled then

		ESX.ShowNotification(('Sėkmingai įjungėte savo GPS sekiklį, jūsų dažnis yra %s.'):format(trackId), 'success') 

		TriggerServerEvent('blombino-tracker:add', trackId)

	else

		ESX.ShowNotification('Sėkmingai išjungėte savo GPS sekiklį.', 'success') 

		TriggerServerEvent('blombino-tracker:remove', trackId)

	end



	openTracker()

end



function trackerRemoved()

	if isEnabled then

		ESX.ShowNotification('Jūs nebeturite GPS sekiklio, todėl visos GPS sekiklio suteikiamos galimybės buvo išjungtos!', 'error') 

		TriggerServerEvent('blombino-tracker:remove', trackId)

		isEnabled = false

	end

end

exports('openTracker', openTracker)

exports('openTrackIdControl', openTrackIdControl)

exports('toggleTracker', toggleTracker)

exports('trackerRemoved', trackerRemoved)

RegisterNetEvent("blombino-tracker:open", openTracker)

RegisterNetEvent('blombino-tracker:update', function(blips)
	for playerId, blip in pairs(createdBlips) do
		if not isEnabled and blip then
			RemoveBlip(blip)
			createdBlips[playerId] = nil
		end
		if blips[playerId] == nil then
			RemoveBlip(blip)
			createdBlips[playerId] = nil
		end
	end

	if not isEnabled or not blips then
		return
	end

	for playerId, v in pairs(blips) do
		if playerId == serverId then
			if createdBlips[playerId] then
				local createdBlip = createdBlips[playerId]
				SetBlipCoords(createdBlip, v.coords.x, v.coords.y, v.coords.z)
				SetBlipSprite(createdBlip, v.vehicle and 326 or 1)
				SetBlipRotation(createdBlip, math.ceil(v.heading))
				SetBlipColour(createdBlip, 0)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(v.name)
				EndTextCommandSetBlipName(createdBlip)
			else
				local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
				SetBlipSprite(blip, v.vehicle and 326 or 1)
				SetBlipColour(blip, 0)
				SetBlipRotation(blip, math.ceil(v.heading))
				SetBlipScale(blip, 0.6)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(v.name)
				EndTextCommandSetBlipName(blip)
				createdBlips[playerId] = blip
			end
		else
			local dbid = v.trackid
			if dbid == trackId then
					if createdBlips[playerId] then
						local createdBlip = createdBlips[playerId]
						SetBlipCoords(createdBlip, v.coords.x, v.coords.y, v.coords.z)
						SetBlipSprite(createdBlip, v.vehicle and 326 or 1)
						SetBlipRotation(createdBlip, math.ceil(v.heading))
						SetBlipColour(createdBlip, 0)
						BeginTextCommandSetBlipName('STRING')
						AddTextComponentSubstringPlayerName(v.name)
						EndTextCommandSetBlipName(createdBlip)
					else
						local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
						SetBlipSprite(blip, v.vehicle and 326 or 1)
						SetBlipColour(blip, 0)
						SetBlipRotation(blip, math.ceil(v.heading))
						SetBlipScale(blip, 0.6)
						BeginTextCommandSetBlipName('STRING')
						AddTextComponentSubstringPlayerName(v.name)
						EndTextCommandSetBlipName(blip)
						createdBlips[playerId] = blip
					end
				end
		end

	end

end)