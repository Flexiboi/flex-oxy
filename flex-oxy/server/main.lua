local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('flex-oxy:server:checkPoliceCount', function(source, cb)
    local src = source
    local players = QBCore.Functions.GetPlayers()
    local policeCount = 0

    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end

    if policeCount >= Config.copsneeded then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('flex-oxy:server:checkRep', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local curRep = Player.PlayerData.metadata[Config.RepType]
    if curRep then
        cb(curRep)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('flex-oxy:server:hasmoney', function(source, cb, moneytype, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.RemoveMoney(moneytype, amount) then
            cb(true)
        else
            cb(false)
        end
    end
end)

QBCore.Functions.CreateCallback('flex-oxy:server:hasitem', function(source, cb, item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName(item) and Player.Functions.GetItemByName(item).amount >= amount then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent("flex-oxy:server:removeitem")
AddEventHandler('flex-oxy:server:removeitem', function(item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "remove", amount)
end)

RegisterServerEvent("flex-oxy:server:addOxy")
AddEventHandler('flex-oxy:server:addOxy', function(item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(item, amount, false)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "add", amount)
end)

RegisterServerEvent("flex-oxy:server:additem")
AddEventHandler('flex-oxy:server:additem', function(item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    local info = {}
    
    if Config.Shop[item].labinfo.enable then
        info = {
            code = Config.Shop[item].labinfo.info.code,
            labname = Config.Shop[item].labinfo.info.labname,
        }
    end
    Player.Functions.AddItem(Config.Shop[item].item, amount, false, info)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.Shop[item].item], "add", amount)
end)

RegisterServerEvent("flex-oxy:server:setstock")
AddEventHandler('flex-oxy:server:setstock', function(id, amount)
    local currenstock = Config.Shop[id].stock
    local newstock = currenstock - amount
    Config.Shop[id].stock = newstock
    TriggerClientEvent('flex-oxy:clinet:setstock', -1, id, newstock)
end)

RegisterNetEvent('flex-oxy:server:rep', function(inTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local copsOnline = QBCore.Functions.GetDutyCount('police')
    local curRep = Player.PlayerData.metadata[Config.RepType]
    if inTime then
        -- local multi = Config.DefaultMulti
        -- if Config.CopsMultiPly[copsOnline] then
        --     multi = Config.CopsMultiPly[copsOnline]
        -- end
        -- local amount = Config.Rewardamount * multi
        -- Player.Functions.AddItem(Config.RewardItem, amount)
        -- TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RewardItem], "add", amount)
        Player.Functions.SetMetaData('dealerrep', (curRep + Config.DeliveryRepWin))
    else
        if curRep - 1 > 0 then
            Player.Functions.SetMetaData('dealerrep', (curRep - Config.DeliveryRepLoss))
        else
            Player.Functions.SetMetaData('dealerrep', 0)
        end
    end
end)

RegisterNetEvent('flex-oxy:server:reward', function(inTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local copsOnline = QBCore.Functions.GetDutyCount('police')
    -- local curRep = Player.PlayerData.metadata[Config.RepType]
    if inTime then
        local multi = Config.DefaultMulti
        if Config.CopsMultiPly[copsOnline] then
            multi = Config.CopsMultiPly[copsOnline]
        end
        local amount = Config.Rewardamount * multi
        Player.Functions.AddItem(Config.RewardItem, amount)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RewardItem], "add", amount)
        -- Player.Functions.SetMetaData('dealerrep', (curRep + Config.DeliveryRepWin))
    else
        -- if curRep - 1 > 0 then
        --     Player.Functions.SetMetaData('dealerrep', (curRep - Config.DeliveryRepLoss))
        -- else
        --     Player.Functions.SetMetaData('dealerrep', 0)
        -- end
    end
end)

QBCore.Commands.Add('oxp', Lang:t("command.levelcommand"), {}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local curRep = Player.PlayerData.metadata[Config.RepType]
        TriggerClientEvent('QBCore:Notify', src, Lang:t("command.showstorelevel", {value = curRep, value2 = Config.Shop[#Config.Shop].repneeded}), "success")
    end
end, 'admin')