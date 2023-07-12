-- Configuration
local planeModel = "globe" -- Change this to the desired plane model
local spawnCoords = vector3(1000.0, 50.0, 100.0) -- Change this to the desired spawn coordinates
local destinationCoords = vector3(2000.0, 1500.0, 100.0) -- Change this to the desired destination coordinates
local doorOpen = true -- Set this to true if you want the doors to be open initially

-- Flyby Command
RegisterCommand("flyby", function()
    -- Create the plane
    local plane = CreateVehicle(GetHashKey(planeModel), spawnCoords, 0.0, true, true)
    SetVehicleEngineOn(plane, true, true, false)
    SetVehicleLandingGear(plane, 3)
    if doorOpen then
        SetVehicleDoorOpen(plane, 2, false, false)
        SetVehicleDoorOpen(plane, 3, false, false)
    end

    -- Create the pilot ped
    local pilot = CreatePedInsideVehicle(plane, 1, GetHashKey("s_m_m_pilot_02"), -1, true, false)
    TaskVehicleDriveToCoord(pilot, plane, destinationCoords, 50.0, 0, GetEntityModel(plane), 16777216, 5.0, true)

    -- Cleanup when the plane reaches the destination
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)

            local currentCoords = GetEntityCoords(plane)
            local distance = #(currentCoords - destinationCoords)

            if distance < 20.0 then -- Adjust the distance threshold as needed
                DeleteEntity(plane)
                DeletePed(pilot)
                break
            end
        end
    end)
end)
