local QBCore = exports['qb-core']:GetCoreObject()

local DrunkenOxyPed = nil
local function createStartPed()
    RequestModel(Config.StartPed.ped)
    while not HasModelLoaded(Config.StartPed.ped) do
        Wait(0)
    end
    DrunkenOxyPed = CreatePed(0, Config.StartPed.ped, Config.StartPed.coords.x, Config.StartPed.coords.y, Config.StartPed.coords.z-1, Config.StartPed.coords.w, false, false)
    TaskStartScenarioInPlace(DrunkenOxyPed, Config.StartPed.scenario, true)
    FreezeEntityPosition(DrunkenOxyPed, true)
    SetEntityInvincible(DrunkenOxyPed, true)
    SetBlockingOfNonTemporaryEvents(DrunkenOxyPed, true)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createStartPed()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeletePed(DrunkenOxyPed)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createStartPed()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeletePed(DrunkenOxyPed)
    end
end)
