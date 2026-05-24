fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'esx_item_destroy'
description 'Destruir itens e pagar à society'
author 'pika80'
dirscord 'https://discord.gg/JZhmwRCkpW'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}