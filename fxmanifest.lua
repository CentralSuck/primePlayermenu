fx_version 'cerulean'
game 'gta5'

author 'primeScripts'
description 'NativeUI Reloaded Playermenu/Personalmenu with handcuffs, business, vehiclemenu and inventory. join discord: https://dsc.gg/primeScripts'
version '1.1.0'

lua54 'yes'

client_scripts {
    '@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
    'config.lua',
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua',
}
