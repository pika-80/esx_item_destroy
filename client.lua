local ESX = exports['es_extended']:getSharedObject()

local PlayerData = {}

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(100)
    end

    PlayerData = ESX.GetPlayerData()

    exports.ox_target:addSphereZone({
        coords = Config.Marker,
        radius = 1.5,
        debug = false,
        options = {
            {
                name = 'destroy_items',
                icon = 'fa-solid fa-trash',
                label = 'Destruir Itens',
                distance = 2.0,

                canInteract = function()
                    if not PlayerData.job then return false end

                    local job = PlayerData.job.name

                    if Config.JobMode == 'whitelist' then
                        return Config.JobList[job]
                    end

                    return not Config.JobList[job]
                end,

                onSelect = function()
                    OpenDestroyMenu()
                end
            }
        }
    })
end)

function OpenDestroyMenu()

    ESX.TriggerServerCallback('destroy:getInventory', function(items)

        if not items or #items == 0 then
            lib.notify({
                title = 'Destruição',
                description = 'Não tens itens destruíveis',
                type = 'error'
            })
            return
        end

        local options = {}

        for _, item in pairs(items) do
            options[#options + 1] = {
                title = item.label,
                description = 'Quantidade: '..item.count,
                image = ('nui://ox_inventory/web/images/%s.png'):format(item.name),
                onSelect = function()

                    if item.isWeapon then
                        StartDestroyProcess(item.name, 1, true)
                    else

                        local input = lib.inputDialog('Quantidade', {
                            {
                                type = 'number',
                                label = 'Quantidade',
                                required = true,
                                min = 1,
                                default = 1
                            }
                        })

                        if input then
                            StartDestroyProcess(item.name, input[1], false)
                        end
                    end
                end
            }
        end

        lib.registerContext({
            id = 'destroy_menu',
            title = 'Destruir Itens',
            options = options
        })

        lib.showContext('destroy_menu')

    end)
end

function StartDestroyProcess(item, amount, isWeapon)

    local success = lib.progressBar({
        duration = Config.DestroyTime,
        label = 'A destruir...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            combat = true,
            car = true
        },
        anim = {
            dict = Config.AnimDict,
            clip = Config.Anim
        }
    })

    if not success then
        return
    end

    TriggerServerEvent('destroy:removeItem', item, amount, isWeapon)
end