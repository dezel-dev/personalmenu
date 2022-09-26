ESX.RegisterServerCallback("personalmenu:player:getData", function(source, cb)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local metadata = {
		name = xPlayer.getName(),
		group = xPlayer.getGroup(),
	}
	cb(metadata)
end)