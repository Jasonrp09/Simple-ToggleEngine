print("^5Toggle Engine wurde gestartet^7")



ESX = nil
local engineOn = false
local inVehicle = false
local lastEngineToggle = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            if not inVehicle then
                inVehicle = true
                ToggleEngineControl()
            end
        else
            if inVehicle then
                inVehicle = false
                engineOn = false
            end
        end
    end
end)

function ToggleEngineControl()
    Citizen.CreateThread(function()
        while inVehicle do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if vehicle ~= 0 then
                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    if IsControlJustReleased(0, 244) then
                        local currentEngineStatus = GetIsVehicleEngineRunning(vehicle)
                        local currentTime = GetGameTimer()

                        if currentEngineStatus and (currentTime - lastEngineToggle) > 1000 then
                            exports.ox_lib:progressBar({
                                duration = 2000,
                                label = "Motor wird ausgeschaltet...",
                                useWhileDead = false,
                                canCancel = false,
                                disableMovement = true,
                                disableCarMovement = false
                            })

                            SetVehicleEngineOn(vehicle, false, false, true)
                            engineOn = false
                            lastEngineToggle = currentTime
                        end
                    end
                end
            end
        end
    end)
end
