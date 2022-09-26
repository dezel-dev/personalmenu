ESX.RegisterServerCallback("personalmenu:player:getInventory", function(source, cb)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	cb(xPlayer.getInventory())
end)