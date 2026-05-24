local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('destroy:getInventory', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb({})
        return
    end

    local items = {}

    local inventory = exports.ox_inventory:GetInventoryItems(source)

    for _, item in pairs(inventory) do

        if item.count > 0 and Config.ItemsValue[item.name] then

            items[#items + 1] = {
                name = item.name,
                label = item.label,
                count = item.count,
                isWeapon = false
            }
        end
    end

    for weaponName, value in pairs(Config.WeaponsValue) do

        local count = exports.ox_inventory:GetItemCount(source, weaponName)

        if count and count > 0 then

           local weaponData = exports.ox_inventory:Items(weaponName)

            items[#items + 1] = {
               name = weaponName,
               label = weaponData.label or weaponName,
               count = count,
               isWeapon = true
            }
        end
    end

    cb(items)
end)

local function JobAllowed(job)

    if Config.JobMode == 'whitelist' then
        return Config.JobList[job]
    end

    return not Config.JobList[job]
end

local function SendDiscordLog(player, item, amount, money, society)

    if Config.DiscordWebhook == '' then
        return
    end

    local embed = {
        {
            title = 'Itens Destruídos',
            color = 16711680,

            fields = {
                {
                    name = 'Player',
                    value = player.getName(),
                    inline = true
                },
                {
                    name = 'Item',
                    value = item,
                    inline = true
                },
                {
                    name = 'Quantidade',
                    value = amount,
                    inline = true
                },
                {
                    name = 'Valor',
                    value = '€'..money,
                    inline = true
                }
            }
        }
    }

    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
        json.encode({
            username = 'Destroy Logs',
            embeds = embed
        }),
        {
            ['Content-Type'] = 'application/json'
        }
    )
end

RegisterNetEvent('destroy:removeItem', function(itemName, amount, isWeapon)

    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return
    end

    if not JobAllowed(xPlayer.job.name) then
        return
    end

    local total = 0
    local society = 'society_'..xPlayer.job.name

    if isWeapon then

        local count = exports.ox_inventory:GetItemCount(src, itemName)

        if count < 1 then
            return
        end

        exports.ox_inventory:RemoveItem(src, itemName, 1)

        total = Config.WeaponsValue[itemName]

    else

        local count = exports.ox_inventory:GetItemCount(src, itemName)

        if count < amount then
            return
        end

        exports.ox_inventory:RemoveItem(src, itemName, amount)

        total = Config.ItemsValue[itemName] * amount
    end

    TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)

        if account then
            account.addMoney(total)
        end
    end)

    SendDiscordLog(xPlayer, itemName, amount, total, society)

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Destruição',
        description = ('Itens destruídos. Sociedade recebeu €%s'):format(total),
        type = 'success'
    })
end)