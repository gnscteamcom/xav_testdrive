ESX 			      = nil
local PlayerData    = {}
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
    if PlayerData.job.name == 'bmdealer' then
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

RegisterCommand("testdrive", function(source, args, rawCommand)
if canuse then
    print("Test Driving a car")
    local vehicle = args[1] -- get car to test drive
    print("arg is " .. vehicle)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
	-- if the big area blow does not work try
	 
    print("Setting plate")

    ESX.Game.SpawnVehicle(vehicle, coords, 90.0, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
        SetVehicleNumberPlateText(vehicle, "CAR " .. math.random(1234, 9999))
    end)
end           
end)

--command to remove car

-- get closest vehicle or vehicle player is in
RegisterCommand('testdriveend', function(source, args, rawCommand)
if canuse then
   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end
end)

