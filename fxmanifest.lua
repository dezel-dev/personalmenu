fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Dezel#8203'
description 'PersonalMenu for your FiveM Server!'
version '1.0.0'

shared_script 'shared/*.lua'
client_scripts {
	"ui/RMenu.lua",
	"ui/menu/RageUI.lua",
	"ui/menu/Menu.lua",
	"ui/menu/MenuController.lua",
	"ui/components/*.lua",
	"ui/menu/elements/*.lua",
	"ui/menu/items/*.lua",
	"ui/menu/panels/*.lua",
	"ui/menu/panels/*.lua",
	"ui/menu/windows/*.lua",

	"client/*.lua",
	"client/components/*.lua",
	"client/addons/*.lua",
	"client/events/*.lua",
}
server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/*.lua",
	"server/events/*.lua",
}