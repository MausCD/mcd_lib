fx_version 'bodacious'
game 'gta5'
author 'MausCD'
description 'MCD Libary'
version '1.0.1'

shared_script '@es_extended/imports.lua'

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	"@mysql-async/lib/MySQL.lua",
	'locales/*.lua',
	'config.lua',
	'server.lua'
}

files {
	'import.lua',
    'ui.html'
}

ui_page('ui.html')