RegisterNetEvent('TOBI:autoevent:colis:start', function()
    local possibleVehicles = CFG.Colis.PossibleVehicleModel
    local randomIndex = math.random(1, #possibleVehicles)
    local modelVehicle = possibleVehicles[randomIndex]
    local Players = TOBI.GetPlayers()
    for i = 1, #Players do
        local player = TOBI.GetPlayerFromId(Players[i])
        local playerJob2 = player:getJob2()
        if playerJob2 ~= 'unemployed2' then
            TriggerClientEvent('TOBI:colis:start', player:src(), modelVehicle)
            TriggerClientEvent('TOBI:showNotification', player:src(),
                '~r~Lester~s~: Une cargaison est ~y~vulnérable~s~, attrape la et ramène la moi, je te met le GPS.')
            TriggerClientEvent('TOBI:freemod', player:src(), '~y~Event~s~', 'Colis', 5)
        end
    end
end)

RegisterNetEvent('TOBI:colis:stop', function()
    local Players = TOBI.GetPlayers()
    for i = 1, #Players do
        local player = TOBI.GetPlayerFromId(Players[i])
        local playerJob2 = player:getJob2()
        if playerJob2 ~= 'unemployed2' then
            TriggerClientEvent('TOBI::colis:stop:sync', player:src())
        end
    end
end)

RegisterNetEvent('TOBI:autoevent:colis:stop', function()
    local Players = TOBI.GetPlayers()
    for i = 1, #Players do
        local player = TOBI.GetPlayerFromId(Players[i])
        local playerJob2 = player:getJob2()
        if playerJob2 ~= 'unemployed2' then
            TriggerClientEvent('TOBI:freemod', player:src(), '~o~Event Terminé~s~', 'Colis', 5)
        end
    end
end)

RegisterNetEvent('TOBI:autoevent:eliminations:start', function()
    local Players = TOBI.GetPlayers()
    for i = 1, #Players do
        local player = TOBI.GetPlayerFromId(Players[i])
        local playerJob2 = player:getJob2()
        if playerJob2 ~= 'unemployed2' then
            TriggerClientEvent('TOBI:eliminations:start', player:src())
            TriggerClientEvent('TOBI:showNotification', player:src(),
                '~r~Lester~s~: J\'ai besoin que tu élimines un gars. Je te mets le GPS')
            TriggerClientEvent('TOBI:freemod', player:src(), '~y~Event~s~', 'Eliminations', 5)
        end
    end
end)
