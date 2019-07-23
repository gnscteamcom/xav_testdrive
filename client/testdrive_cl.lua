ESX 			      = nil
local PlayerData    = {}
local testplate = "TESTCAR"
canuse = false

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    if PlayerData.job.name == 'cardealer' then
        canuse = true
        print("canUse Test Drive set to true")
    else
        print("canUse Test Drive set to false")
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

--------------------------------------------- TEST DRIVE COMMANDS START ---------------------------------------------
-- command to spawn car.... restricted to anyone set at cardealer job
RegisterCommand("testdrive", function(source, args, rawCommand)
if canuse then
    print("Test Driving a car")
    local vehicle = args[1] -- get car to test drive
    print("Car is " .. vehicle) -- says what car your getting in F8 console
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    print("Setting plate") -- F8 console saying that its setting the plate
    ESX.Game.SpawnVehicle(vehicle, coords, 90.0, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
        SetVehicleNumberPlateText(vehicle, testplate) -- testplate is set above 
    end)
end           
end)

--command to remove car..... restricted to anyone set to cardealer job (This will delete "return" anycar even if it is not a testdrive car
RegisterCommand('testdriveend', function(source, args, rawCommand)
if canuse then
   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end
end)

--------------------------------------------- TEST DRIVE COMMANDS END ---------------------------------------------

