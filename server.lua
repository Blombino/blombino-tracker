local tracked = {}

RegisterNetEvent("blombino-tracker:remove", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    tracked[xPlayer.source] = nil
    TriggerClientEvent("blombino-tracker:update", -1, tracked)
end)


RegisterNetEvent("blombino-tracker:add", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    tracked[xPlayer.source] = {}
    tracked[xPlayer.source].trackid = id
    tracked[xPlayer.source].name = xPlayer.getName()
    tracked[xPlayer.source].coords = xPlayer.getCoords(true)
    tracked[xPlayer.source].heading = GetEntityHeading(GetPlayerPed(xPlayer.source))
    tracked[xPlayer.source].vehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
    TriggerClientEvent("blombino-tracker:update", -1, tracked)
end)

ESX.RegisterUsableItem('tracker', function(playerId)
    TriggerClientEvent("blombino-tracker:open", playerId)
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(tracked) do 
            if v == nil then table.remove(tracked,k) end
                local xPlayer = ESX.GetPlayerFromId(k)
                if xPlayer then
                    tracked[k].coords = xPlayer.getCoords(true)
                    tracked[k].name = xPlayer.getName()
                    tracked[k].heading = GetEntityHeading(GetPlayerPed(k))
                    tracked[k].vehicle = GetVehiclePedIsIn(GetPlayerPed(k), false)  
                else
                    tracked[k] = nil
                end
        end
        TriggerClientEvent("blombino-tracker:update", -1, tracked)
        Wait(100)
    end
end)