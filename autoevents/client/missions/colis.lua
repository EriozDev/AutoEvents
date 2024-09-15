Event = {}
PropsCreated = {}
boxId = 0

function DamageVehicle(vehicle)
    SetVehicleBodyHealth(vehicle, 500.0)
    SetVehicleEngineHealth(vehicle, 500.0)

    for i = 0, 5 do
        SetVehicleTyreBurst(vehicle, i, true, 1000.0)
    end

    for i = 0, 5 do
        SmashVehicleWindow(vehicle, i)
    end

    SetVehicleBodyHealth(vehicle, 50.0)
    SetVehiclePetrolTankHealth(vehicle, 0.0)
    StartVehicleEngineSmoke(vehicle)
    SetVehicleUndriveable(vehicle, true)
    SetVehicleDoorOpen(vehicle, 5, false, false)
    PlayVehicleDoorCloseSound(vehicle)
end

function SpawnColis(vehicle)
    local vehiclePos = GetEntityCoords(vehicle)
    local heading = GetEntityHeading(vehicle)

    local offsetX = -2.0
    local offsetY = -2.0
    local offsetZ = 0.0

    colisPos = GetOffsetFromEntityInWorldCoords(vehicle, offsetX, offsetY, offsetZ)

    local propModel = "prop_rub_boxpile_05"
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(1)
    end

    local Z
    if colisPos.z < 29.0 then
        Z = 0.8
    else
        Z = 1.0
    end
    local colis = CreateObject(propModel, colisPos.x, colisPos.y, colisPos.z - Z, true, true, true)
    boxId = boxId + 1
    PropsCreated[boxId] = colis
    SetEntityHeading(colis, heading)
    FreezeEntityPosition(colis, true)
    SetModelAsNoLongerNeeded(propModel)
end

function StartVehicleEngineSmoke(vehicle)
    StartParticleFxLoopedOnEntity("exp_grd_bzgas_smoke", vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
end

function PlayAnim()
    local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(CPlayer.Ped, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
    Citizen.Wait(1500)
    ClearPedTasks(CPlayer.Ped)
end

local ColisActive = false
function Event.Colis(VehicleModel)
    ColisActive = true
    local possibleVehiclesPosition = CFG.Colis.PossibleVehiclePosition
    local randomIndex = math.random(1, #possibleVehiclesPosition)
    local positionVehicle = possibleVehiclesPosition[randomIndex]
    local modelHash = joaat(VehicleModel)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(10)
    end

    local Colis = CreateVehicle(modelHash, positionVehicle.x, positionVehicle.y, positionVehicle.z, 1.73, true, false)
    SetVehicleLivery(Colis, 1)
    FreezeEntityPosition(Colis, true)
    DamageVehicle(Colis)

    local blip = AddBlipForCoord(positionVehicle.x, positionVehicle.y, positionVehicle.z)
    local blip2 = AddBlipForCoord(positionVehicle.x, positionVehicle.y, positionVehicle.z)

    SetBlipSprite(blip, 227)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)

    SetBlipSprite(blip2, 161)
    SetBlipDisplay(blip2, 4)
    SetBlipScale(blip2, 0.8)
    SetBlipColour(blip2, 1)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Colis')
    EndTextCommandSetBlipName(blip)

    Citizen.CreateThread(function()
        while ColisActive do
            Citizen.Wait(0)

            local dst = #(CPlayer.Coords - positionVehicle)

            if dst >= 20.0 then
                goto skip
            end

            if CPlayer.Vehicle ~= 0 then
                goto skip
            end

            SpawnColis(Colis)
            TOBI.Draw(vector3(colisPos.x, colisPos.y, colisPos.z + 0.25), '~b~[E]~y~ Ramassez le colis', 1.2, 0)
            if dst < 5 then
                if IsControlJustPressed(0, 51) then
                    PlayAnim()
                    PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
                    RemoveBlip(blip)
                    RemoveBlip(blip2)
                    Citizen.Wait(1000)
                    for k, v in pairs(PropsCreated) do
                        DeleteEntity(v)
                    end
                    Citizen.Wait(1500)
                    DeleteEntity(Colis)
                    ColisActive = false

                    TOBI.EmitServer('TOBI:colis:stop')
                end
            end

            :: skip ::
        end
    end)

    SetTimeout(CFG.Colis.TimeDuration, function()
        if DoesEntityExist(Colis) then
            DeleteEntity(Colis)
            for k, v in pairs(PropsCreated) do
                DeleteEntity(v)
            end
            ColisActive = false
            RemoveBlip(blip)
            RemoveBlip(blip2)
            TOBI.EmitServer('TOBI:colis:stop')
        end
    end)
end

RegisterNetEvent('TOBI:colis:start', function(modelVehicle)
    ColisActive = true
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset")
    Event.Colis(modelVehicle)
end)
