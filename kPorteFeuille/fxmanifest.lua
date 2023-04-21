fx_version 'cerulean'

game 'gta5'

description 'KaiSoR PorteFeuille'
lua54 'yes'
version '1.0'
legacyversion '1.9.4'

shared_script '@es_extended/imports.lua'

client_scripts {
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

	'config.lua',
	'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/*.lua'
}

dependency 'es_extended'
