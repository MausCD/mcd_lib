fx_version 'bodacious'
game 'gta5'
author 'MausCD'
description 'MCD Script Libary'
version '1.0.7'

lua54 'yes'

shared_script '@es_extended/imports.lua'

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',

	'config.lua',
	'*_config.lua',

	'lua/shared/*.lua',
	'lua/client/client.lua',
	'lua/client/events.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	"@mysql-async/lib/MySQL.lua",
	'locales/*.lua',

	'config.lua',
	'*_config.lua',

	'lua/shared/*.lua',
	'lua/server/server.lua',
	'lua/server/events.lua',
}

files {
	'lua/shared/import.lua',
    'html/ui.html',
	'html/imgs/*.png',
}

ui_page('html/ui.html')

escrow_ignore {
	'config.lua',
	'locales/*.lua',
}