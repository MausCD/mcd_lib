fx_version 'bodacious'
game 'gta5'
author 'MausCD'
description 'MCD Script Libary'
version '1.0.9'

lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'lua/shared/shared.lua',
	'lua/shared/math.lua',
	'lua/shared/functions.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	
	'config.lua',
	'*_config.lua',
} 

client_scripts {
	'lua/client/client.lua',
	'lua/client/events.lua',
}

server_scripts {
	'config_webhook.lua',
	"@mysql-async/lib/MySQL.lua",

	'saves.lua',
	'lua/server/safety.lua',
	'lua/server/server.lua',
	'lua/server/update.lua',
	'lua/server/banmanager.lua',
	'lua/server/events.lua',
}

files {
	'import.lua',
    'html/ui.html',
	'html/imgs/*.png',
}

ui_page('html/ui.html')