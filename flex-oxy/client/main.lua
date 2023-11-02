local QBCore = exports['qb-core']:GetCoreObject()
local deliverystarted, deliverblip, DeliveryPed = false, nil, nil
local dropOffCount = 0

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

RegisterNetEvent('flex-oxy:client:shop', function()
    local currep = 0
    QBCore.Functions.TriggerCallback('flex-oxy:server:checkRep', function(rep)
        if rep then
            if rep <= 0 then
                return QBCore.Functions.Notify(Lang:t("error.idkyou"), 'error')
            elseif rep >= Config.Shop[#Config.Shop].repneeded then
                QBCore.Functions.Notify(Lang:t("success.nothingnew"), 'success')
                currep = rep
            else
                currep = rep
            end

            local columns = {
                {
                    header = "ZatteWinkel",
                    isMenuHeader = true,
                },
            }
            for k, v in pairs(Config.Shop) do
                if tonumber(currep) >= tonumber(v.repneeded) then
                    local item = {}
                    item.header = "<img src=nui://"..Config.inventory..QBCore.Shared.Items[v.item].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.item].label
                    local text = v.amount .. " voor " .. v.cost .. ' ' .. QBCore.Shared.Items[Config.ShopBuyItem].label .. "</br>" .. Lang:t("menu.stock", {value = v.stock})
                    item.text = text
                    item.params = {
                        event = 'flex-oxy:client:buy',
                        args = {
                            item = k,
                            amount = v.amount,
                            cost = v.cost,
                            id = k,
                        }
                    }
                    table.insert(columns, item)
                end
            end
        
            exports['qb-menu']:openMenu(columns)
        end
    end)
end)

RegisterNetEvent('flex-oxy:client:startrun', function()
    QBCore.Functions.TriggerCallback('flex-oxy:server:checkPoliceCount', function(Cops)
        if Cops then
            QBCore.Functions.TriggerCallback('flex-oxy:server:hasitem', function(hasbeer)
                if hasbeer then
                    if not deliverystarted then
                        dropOffCount = math.random(Config.DropOffCount.Min, Config.DropOffCount.Max)
                        local oxymenu = {
                            {
                                header = Lang:t("menu.header"),
                                icon = "fa-solid fa-circle-info",
                                isMenuHeader = true,
                            },
                            {
                                header = Lang:t("menu.yes"),
                                icon = "fa-solid fa-list",
                                params = {
                                    event = "flex-oxy:client:getlocation",
                                }
                            },
                            {
                                header = Lang:t("menu.shop"),
                                icon = "fa-solid fa-list",
                                params = {
                                    event = "flex-oxy:client:shop",
                                }
                            },
                            {
                                header = Lang:t("menu.no"),
                                icon = "fa-solid fa-list",
                                params = {
                                    event = "flex-oxy:client:cancel",
                                }
                            },
                        }
                        exports['qb-menu']:openMenu(oxymenu)
                    else
                        QBCore.Functions.Notify(Lang:t("error.alreadystarted"), 'error')
                    end
                else
                    QBCore.Functions.Notify(Lang:t("error.nobeer"), 'error')
                end
            end, Config.BeerItem, 1)
        else
            QBCore.Functions.Notify(Lang:t("error.nopolice", {value = Config.copsneeded}), 'error')
        end
    end)
end)

RegisterNetEvent('flex-oxy:client:cancel', function()
    QBCore.Functions.Notify(Lang:t("error.mad"), 'error')
end)

RegisterNetEvent('flex-oxy:client:getlocation', function()
    if not deliverystarted then
        QBCore.Functions.Notify(Lang:t("success.checkgps"), 'success')
        local ped = PlayerPedId()
        LoadAnimDict("gestures@f@standing@casual")
        TaskPlayAnim(ped, "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(800)
        ClearPedTasks(ped)

        deliverystarted = true
        if dropOffCount >= dropOffCount then
            TriggerServerEvent('flex-oxy:server:removeitem', Config.BeerItem, 1)
        end
        TriggerServerEvent('flex-oxy:server:addOxy', Config.OxyItem, 1)
        local r = math.random(1,#Config.DeliveryLocs)
        local loc = Config.DeliveryLocs[r]
        deliverblip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(deliverblip, 615)
        SetBlipScale(deliverblip, 0.8)
        SetBlipAsShortRange(deliverblip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Lang:t("deliverinfo.blipname"))
        EndTextCommandSetBlipName(deliverblip)

        local model = Config.PedModels[math.random(1, #Config.PedModels)]
        local scernario = Config.Scenario[math.random(1, #Config.Scenario)]
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        DeliveryPed = CreatePed(0, model, loc.x, loc.y, loc.z-1, loc.w, false, false)
        TaskStartScenarioInPlace(DeliveryPed, scernario, true)
        FreezeEntityPosition(DeliveryPed, true)
        SetEntityInvincible(DeliveryPed, true)
        SetBlockingOfNonTemporaryEvents(DeliveryPed, true)

        exports['qb-target']:AddBoxZone("OxyDeliverPed", vector3(loc.x, loc.y, loc.z) , 0.6, 0.6, {
            name = "OxyDeliverPed",
            heading = 0,
            debugPoly = Config.Debug,
            minZ = loc.z-1,
            maxZ =loc.z+1.2,
        }, {
            options = {
                {
                    type = "client",
                    event = "flex-oxy:client:deliver",
                    icon = "fa fa-handshake-o",
                    label = Lang:t('target.delivertoped')
                },
            },
            distance = 1.5
        })
    else
        QBCore.Functions.Notify(Lang:t("error.alreadystarted"), 'error')
    end
end)

RegisterNetEvent('flex-oxy:client:deliver', function()
    exports['qb-target']:RemoveZone("OxyDeliverPed")
    QBCore.Functions.TriggerCallback('flex-oxy:server:hasitem', function(hasoxy)
        if hasoxy then
            --if math.random(0,100) <= Config.PoliceCallChance then
                exports['ps-dispatch']:SuspiciousActivity3()
            --end
            local ped = PlayerPedId()
            TaskLookAtEntity(DeliveryPed, ped, 5500.0, 2048, 3)
            TaskTurnPedToFaceEntity(DeliveryPed, ped, 5500)
            TaskStartScenarioInPlace(DeliveryPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
            Citizen.Wait(700)
            LoadAnimDict("gestures@f@standing@casual")
            TaskPlayAnim(ped, "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(DeliveryPed, "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(800)
            QBCore.Functions.Notify(Lang:t("success.thanks"), 'success')
            ClearPedTasks(ped)
            ClearPedTasks(DeliveryPed)
            FreezeEntityPosition(DeliveryPed, false)
            Citizen.Wait(500)
            TaskWanderStandard(DeliveryPed, 10.0, 10.0)
            TriggerServerEvent('flex-oxy:server:removeitem', Config.OxyItem, 1)
            RemoveBlip(deliverblip)
            deliverystarted = false
            Citizen.Wait(30000)
            DeletePed(DeliveryPed)
            deliverblip, DeliveryPed = nil, nil
            if dropOffCount > 0 then
                dropOffCount = dropOffCount -1
                deliverystarted = false
                TriggerEvent('flex-oxy:client:getlocation')
                TriggerServerEvent('flex-oxy:server:reward', true)
            end
            if dropOffCount <= 0 then
                TriggerServerEvent('flex-oxy:server:rep', true)
            end
        else
            QBCore.Functions.Notify(Lang:t("error.nooxy"), 'error')
            TriggerServerEvent('flex-oxy:server:rep', false)
            ClearPedTasks(DeliveryPed)
            FreezeEntityPosition(DeliveryPed, false)
            TaskWanderStandard(DeliveryPed, 10.0, 10.0)
            RemoveBlip(deliverblip)
            deliverystarted = false
            Citizen.Wait(30000)
            DeletePed(DeliveryPed)
            deliverblip, DeliveryPed = nil, nil
            dropOffCount = 0
        end
    end, Config.OxyItem, 1)
end)

RegisterNetEvent('flex-oxy:client:buy', function(data)
    if Config.ShopBuyItem == 'cash' then
        QBCore.Functions.TriggerCallback('flex-oxy:server:hasmoney', function(hasmoney)
            if hasmoney then
                TriggerServerEvent('flex-oxy:server:additem', data.item, data.amount)
                TriggerServerEvent('flex-oxy:server:setstock', data.id, data.amount)
                QBCore.Functions.Notify(Lang:t("success.buy"), 'success')
            else
                QBCore.Functions.Notify(Lang:t("error.topoor"), 'error')
            end
        end, 'cash', data.cost)
    elseif Config.ShopBuyItem == 'bank' then
        QBCore.Functions.TriggerCallback('flex-oxy:server:hasmoney', function(hasmoney)
            if hasmoney then
                TriggerServerEvent('flex-oxy:server:additem', data.item, data.amount)
                TriggerServerEvent('flex-oxy:server:setstock', data.id, data.amount)
                QBCore.Functions.Notify(Lang:t("success.buy"), 'success')
            else
                QBCore.Functions.Notify(Lang:t("error.topoor"), 'error')
            end
        end, 'bank', data.cost)
    else
        QBCore.Functions.TriggerCallback('flex-oxy:server:hasitem', function(hasitem)
            if hasitem then
                TriggerServerEvent('flex-oxy:server:removeitem', Config.ShopBuyItem, data.cost)
                TriggerServerEvent('flex-oxy:server:additem', data.item, data.amount)
                TriggerServerEvent('flex-oxy:server:setstock', data.id, data.amount)
                QBCore.Functions.Notify(Lang:t("success.buy"), 'success')
            else
                QBCore.Functions.Notify(Lang:t("error.topoor"), 'error')
            end
        end, Config.ShopBuyItem, data.cost)
    end
end)

RegisterNetEvent('flex-oxy:client:setstock', function(id, stock)
    Config.Shop[id].stock = stock
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    exports['qb-target']:RemoveZone("OxyDeliverPed")
    DeletePed(DeliveryPed)
    if DoesBlipExist(deliverblip) then
        RemoveBlip(deliverblip)
    end
end)
