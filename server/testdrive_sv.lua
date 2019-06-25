ESX              = nil
local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_bmvehicles:getCategories', function (source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_bmvehicles:getVehicles', function (source, cb)
	cb(Vehicles)
end)
