_PersonalMenu.PlayerData = {}
_PersonalMenu.PlayerBills = {}

Citizen.CreateThread(function()
	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	_PersonalMenu.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	_PersonalMenu.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
	_PersonalMenu.PlayerData.job = job
end)

function _PersonalMenu:keyboard(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end