RegisterNetEvent("personalmenu:admin:teleport", function(id)
	local _src <const> = source
	local playerPed = GetPlayerPed(_src)
	local xPlayer = ESX.GetPlayerFromId(id)
	if (xPlayer ~= nil) then
		SetEntityCoords(playerPed, GetEntityCoords(GetPlayerPed(xPlayer.source)))
	else
		TriggerClientEvent("esx:showNotification", _src, "~r~Le joueur n'existe pas!")
	end
end)

RegisterNetEvent("personalmenu:admin:teleportToMe", function(id)
	local _src <const> = source
	local playerPed = GetPlayerPed(_src)
	local xPlayer = ESX.GetPlayerFromId(id)
	if (xPlayer ~= nil) then
		SetEntityCoords(GetPlayerPed(xPlayer.source), GetEntityCoords(playerPed))
	else
		TriggerClientEvent("esx:showNotification", _src, "~r~Le joueur n'existe pas!")
	end
end)