RegisterNetEvent("personalmenu:manage_corp:recruit", function(target)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local xPlayerJob = xPlayer.getJob()
	local targetXPlayerJob = targetXPlayer.getJob()

	if (xPlayerJob.name ~= "boss") then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous devez être le boss pour exécuter cette action!"))
	end
	if (xPlayerJob.name == targetXPlayerJob.name) then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Le joueur est déjà dans l'entreprise!"))
	end
	targetXPlayer.setJob(xPlayerJob.name, 1)
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez recruté %s dans votre entreprise"):format(targetXPlayer.getName()))
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez été recruté dans l'entreprise de %s : %s"):format(xPlayer.getName(), xPlayerJob.label))
end)

RegisterNetEvent("personalmenu:manage_corp:transfer", function(target)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local xPlayerJob = xPlayer.getJob()
	local targetXPlayerJob = targetXPlayer.getJob()

	if (xPlayerJob.name ~= "boss") then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous devez être le boss pour exécuter cette action!"))
	end
	if (xPlayerJob.name ~= targetXPlayerJob.name) then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Le joueur n'est pas dans votre entreprise!"))
	end
	targetXPlayer.setJob("unemployed", 0)
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez viré %s de votre entreprise"):format(targetXPlayer.getName()))
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez été viré de l'entreprise de %s : %s"):format(xPlayer.getName(), xPlayerJob.label))
end)

RegisterNetEvent("personalmenu:manage_corp:promote", function(target)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local xPlayerJob = xPlayer.getJob()
	local targetXPlayerJob = targetXPlayer.getJob()

	if (xPlayerJob.name ~= "boss") then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous devez être le boss pour exécuter cette action!"))
	end
	if (xPlayerJob.name ~= targetXPlayerJob.name) then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Le joueur n'est pas dans votre entreprise!"))
	end
	targetXPlayer.setJob(xPlayerJob.name, targetXPlayerJob.grade + 1)
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez promu %s dans votre entreprise au grade de %s"):format(targetXPlayer.getName(), targetXPlayer.getJob().label))
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez été promu de l'entreprise de %s au grade de %s"):format(targetXPlayer.getName(), targetXPlayer.getJob().label))
end)

RegisterNetEvent("personalmenu:manage_corp:downgrade", function(target)
	local _src <const> = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local xPlayerJob = xPlayer.getJob()
	local targetXPlayerJob = targetXPlayer.getJob()

	if (xPlayerJob.name ~= "boss") then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous devez être le boss pour exécuter cette action!"))
	end
	if (xPlayerJob.name ~= targetXPlayerJob.name) then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Le joueur n'est pas dans votre entreprise!"))
	end
	if (targetXPlayerJob.grade == 0) then
		return (TriggerClientEvent("esx:showNotification", xPlayer.source, "Le joueur ne peut pas être rétrogradé!"))
	end
	targetXPlayer.setJob(xPlayerJob.name, targetXPlayerJob.grade - 1)
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez rétrogradé %s dans votre entreprise au grade de %s"):format(targetXPlayer.getName(), targetXPlayer.getJob().label))
	TriggerClientEvent("esx:showNotification", xPlayer.source, ("Vous avez été rétrogradé de l'entreprise de %s au grade de %s"):format(targetXPlayer.getName(), targetXPlayer.getJob().label))
end)