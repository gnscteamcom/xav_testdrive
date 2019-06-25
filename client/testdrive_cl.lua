local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local IsInShopMenu            = false
local Categories              = {}
local Vehicles 		      = {}
ESX 			      = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)
		
	ESX.TriggerServerCallback('haven_testdrive:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('haven_testdrive:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('haven_testdrive:sendCategories')
AddEventHandler('haven_testdrive:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('haven_testdrive:sendVehicles')
AddEventHandler('haven_testdrive:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)



RegisterCommand('testdrive', function(source, args, rawCommand)
print("Test Driving a car")
local vehicle = args[1] -- get car to test drive
	-- if the big area blow does not work try
	-- SpawnVehicle(vehicle)
		
		
-- make changes to where car spawns and what not
  ESX.Game.SpawnVehicle(vehicle.model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function (vehicle)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    local newPlate     = GeneratePlate()
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    vehicleProps.plate = newPlate
    SetVehicleNumberPlateText(vehicle, newPlate)
    --TriggerServerEvent('esx_vehicleshop:setVehicleOwnedSociety', playerData.job.name, vehicleProps)
    ESX.ShowNotification(_U('vehicle_purchased'))
  end)


end

--command to remove car

-- get closest vehicle or vehicle player is in








function SpawnVehicle(veh)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 4.0, 0.5))
    if veh == nil then veh = "adder" end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 10000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()), 1, 0)
    end)
end
