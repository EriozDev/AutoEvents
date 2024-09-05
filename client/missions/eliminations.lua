local EliminationActive = false

function Event.Eliminations()
    EliminationActive = true

    local possiblePedModel = CFG.Eliminations.PossiblePedModel
    local randomIndex = math.random(1, #possiblePedModel)
    local modelPed = possiblePedModel[randomIndex]
    local modelHash = joaat(modelPed)

    local possiblePositionPed = CFG.Eliminations.PossiblePedDefaultPosition
    local randomIndex = math.random(1, #possiblePositionPed)
    local positionPed = possiblePositionPed[randomIndex]

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end
    Npc = CreatePed(modelPed, modelHash, positionPed, 90.0, true, false)

    Citizen.CreateThread(function()
        while EliminationActive do
            Wait(0)

            if IsPedDeadOrDying(Npc, true) then
                local killer = GetPedSourceOfDeath(Npc)

                local isPed = IsEntityAPed(killer)
                local isPlayer = IsPedAPlayer(killer)

                if not isPed then
                    EliminationActive = false
                    --TODO ADD end event
                    break
                end

                if not isPlayer then
                    EliminationActive = false
                    --TODO ADD end event
                    break
                end

                local playerId = NetworkGetPlayerIndexFromPed(killer)

                --TODO ADD end event

                EliminationActive = false
            end
        end
    end)

    SetTimeout(CFG.Eliminations.TimeDuration, function()
        if not IsEntityDead(Npc) then
            --TODO ADD end event
        end
    end)
end

RegisterNetEvent('TOBI:eliminations:start', function()
    EliminationActive = true
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset")
    Event.Eliminations()
end)
