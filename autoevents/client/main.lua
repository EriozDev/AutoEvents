Citizen.CreateThread(function()
    while true do
        Wait(CFG.Colis.TimeInterval)
        local event = AutoEventsManager.New('colis')
        event:Start()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(CFG.Eliminations.TimeInterval)
        local event = AutoEventsManager.New('eliminations')
        event:Start()
    end
end)

RegisterCommand('event_start', function(src, args, rawCommand)
    TOBI.TriggerServerCallback('TOBI:CheckGroupStaff', function(group, cb)
        if group == 'superadmin' or group == 'owner' or group == 'dev' then
            local eventToStart = args[1]
            if (eventToStart) then
                local event = AutoEventsManager.New(eventToStart)
                event:Start()
            end
        end
    end)
end)

RegisterNetEvent('TOBI::colis:stop:sync', function()
    if (AutoEventsManager.IsOnByUniqueId('colis')) then
        AutoEventsManager.StopByUniqueId('colis')
    end
end)

RegisterNetEvent('TOBI:colis:onStart', function()
end)

RegisterNetEvent('TOBI:colis:onStop', function()
end)