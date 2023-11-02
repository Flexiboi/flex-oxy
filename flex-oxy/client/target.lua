local QBCore = exports['qb-core']:GetCoreObject()
exports['qb-target']:AddBoxZone("OxyStartPed", vector3(Config.StartPed.coords.x, Config.StartPed.coords.y, Config.StartPed.coords.z-0.5) , 0.6, 0.6, {
    name = "OxyStartPed",
    heading = 0,
    debugPoly = Config.Debug,
    minZ = Config.StartPed.coords.z-1,
    maxZ = Config.StartPed.coords.z+1.2,
}, {
    options = {
        {
            type = "client",
            event = "flex-oxy:client:startrun",
            icon = "fa-solid fa-beer-mug-empty",
            label = Lang:t('target.talktoped')
        },
    },
    distance = 1.5
})

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    exports['qb-target']:RemoveZone("OxyStartPed")
end)