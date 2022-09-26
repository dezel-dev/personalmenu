RegisterNetEvent("personalmenu:inventory:item:use", function(item)
	ESX.UseItem(source, item.name)
	TriggerClientEvent("esx:showNotification", source, "Vous avez utilisé x1 ~g~"..item.label)
end)

RegisterNetEvent("personalmenu:inventory:item:give", function(item, qty, id)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	if (not targetXPlayer.canCarryItem(item.name, qty)) then
		return TriggerClientEvent("esx:showNotification", xPlayer.source, ("%s n'a pas assez de place sur lui"):format(targetXPlayer:getName()))
	end
	xPlayer.removeInventoryItem(item.name, qty)
	targetXPlayer.addInventoryItem(item.name, qty)
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez donné x%s ~g~%s ~s~à %s"):format(qty, item.label, targetXPlayer:getName()))
	TriggerClientEvent("esx:showNotification", targetXPlayer.source, ("%s vous a donné x%s ~g~%s"):format(xPlayer:getName(), qty, item.label))
end)

RegisterNetEvent("personalmenu:inventory:item:drop", function(item, qty)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	ESX.CreatePickup("item_standard", item.name, qty, ("[x%i] %s"):format(qty, item.label), xPlayer.source)
	xPlayer.removeInventoryItem(item.name, qty)
end)