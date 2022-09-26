local cooldownItem = false
local index = {
	licence_watch = 1,
	licence_show = 1,
	noclip = false,
	godmode = false,
	invisible = false,
	map = true,
	cinematic = false,
	effect = 1
}

_PersonalMenu.Bills = {}
_PersonalMenu.Bills.TotalSelectedPrice = 0
_PersonalMenu.Bills.TotalPrice = 0

function _PersonalMenu:getPlayerInventory()
	ESX.TriggerServerCallback("personalmenu:player:getInventory", function(inventory)
		_PersonalMenu.PlayerData.inventory = inventory
		for _,v in pairs(_PersonalMenu.PlayerData.inventory) do
			if (v.count >= 1) then
				v.index = 1
			end
		end
	end)
end
function _PersonalMenu:getPlayerBills()
	_PersonalMenu.PlayerBills = {}
	ESX.TriggerServerCallback("esx_billing:getBills", function(bills)
		for _, v in pairs(bills) do
			table.insert(_PersonalMenu.PlayerBills, {
				id = v.id,
				amount = v.amount,
				label = v.label,
				index = true
			})
		end
	end)
end
function _PersonalMenu.Bills:getSelectedPrice()
	_PersonalMenu.Bills.TotalSelectedPrice = 0
	for _, v in pairs(_PersonalMenu.PlayerBills) do
		if (v.index) then
			_PersonalMenu.Bills.TotalSelectedPrice = _PersonalMenu.Bills.TotalSelectedPrice + v.amount
		end
	end
end
function _PersonalMenu:marker_nearest_player()
	local player, distance = ESX.Game.GetClosestPlayer()
	if (player ~= -1 and distance <= 3.0) then
		--DrawMarker()
	end
end

function _PersonalMenu:main_menu()

	local main = RageUI.CreateMenu(_PersonalMenu.PlayerData.name, "Vos informations");
	local inventory = RageUI.CreateSubMenu(main, _PersonalMenu.PlayerData.name, "Votre inventaire");
	local billing = RageUI.CreateSubMenu(main, _PersonalMenu.PlayerData.name, "Vos factures");
	billing:SetStyleSize(100)
	local licence = RageUI.CreateSubMenu(main, _PersonalMenu.PlayerData.name, "Vos documents officiels");
	local manage_corp = RageUI.CreateSubMenu(main, _PersonalMenu.PlayerData.name, "Gestion entreprise");
	local admin = RageUI.CreateSubMenu(main, _PersonalMenu.PlayerData.name, "Administration");
	local visual = RageUI.CreateSubMenu(main, _PersonalMenu.PlayerData.name, "Gestion HUD & Visuel");

	RageUI.Visible(main, not RageUI.Visible(main))

	while main do

		Citizen.Wait(0)

		RageUI.IsVisible(main, function()
			if (Config.Enable.Inventory) then
				RageUI.Button("Inventaire", nil, {RightLabel = "→"}, true, {
					onSelected = function()
						_PersonalMenu:getPlayerInventory()
					end
				}, inventory)
			end
			if (Config.Enable.Billing) then
				RageUI.Button("Factures & Amendes", nil, {RightLabel = "→"}, true, {
					onSelected = function()
						_PersonalMenu:getPlayerBills()
					end
				}, billing)
			end
			if (Config.Enable.Licence) then
				RageUI.Button("Documents officiels", nil, {RightLabel = "→"}, true, {}, licence)
			end
			if (Config.Enable.Manage_Corp) then
				RageUI.Button("Gestion entreprise", nil, {RightLabel = "→"}, _PersonalMenu.PlayerData.job.grade_name == "boss", {}, manage_corp)
			end
			if (Config.Enable.Admin) then
				RageUI.Button("Administration", nil, {RightLabel = "→"}, Config.PermissionAdmin.OpenMenu[_PersonalMenu.PlayerData.group], {}, admin)
			end
			if (Config.Enable.Visual) then
				RageUI.Button("Gestion HUD & Visuel", nil, {RightLabel = "→"}, true, {}, visual)
			end
		end)
		RageUI.IsVisible(inventory, function()
			RageUI.List("Filtre : ", _PersonalMenu.filterArray, _PersonalMenu.index.filter, nil, {}, true, {
				onListChange = function(Index, Item)
					_PersonalMenu.index.filter = Index;
					_PersonalMenu.Filter = Item.Value
				end,
			})
			RageUI.Line()
			for _, v in pairs(_PersonalMenu.PlayerData.inventory) do
				if (v.count >= 1) then
					if (_PersonalMenu:start(v.label:lower(), _PersonalMenu.Filter:lower())) then
						if (not Config.BlacklistItem[v.name]) then
							RageUI.List(("[x%s] %s"):format(v.count, v.label), {
								{ Name = "Utiliser", Value = "use" },
								{ Name = "Donner", Value = "give" },
								{ Name = "Jeter", Value = "drop" },
							}, v.index, description, {}, not cooldownItem, {
								onListChange = function(Index, Item)
									v.index = Index;
								end,
								onSelected = function(Index, Item)
									if (Item.Value ~= "use") then
										qty = _PersonalMenu:keyboard("Quantité", nil, 2)
										if (Item.Value == "give") then
											local ply, dst = ESX.Game.GetClosestPlayer()
											if (ply == -1 or dst > 3.0) then
												return ESX.ShowNotification("~r~Aucun joueur à proximité")
											end
										end
									end
									TriggerServerEvent(("personalmenu:inventory:item:%s"):format(Item.Value), v, tonumber(qty), GetPlayerServerId(ply))
									cooldownItem = true
									SetTimeout(500, function()
										cooldownItem = false
										_PersonalMenu:getPlayerInventory()
									end)
								end
							})
						end
					end
				end
			end
		end)
		RageUI.IsVisible(billing, function()
			_PersonalMenu.Bills:getSelectedPrice()
			RageUI.Button("Tout sélectionner", nil, {}, true, {
				onSelected = function()
					for _, v in pairs(_PersonalMenu.PlayerBills) do
						v.index = true
					end
				end
			})
			RageUI.Line()
			if (#_PersonalMenu.PlayerBills >= 1) then
				for _, v in pairs(_PersonalMenu.PlayerBills) do
					RageUI.Checkbox(("%s : %s$"):format(v.label, v.amount), nil, v.index, {}, {
						onSelected = function(Index)
							v.index = Index
						end
					})
				end
			else
				RageUI.Separator("~r~Vous n'avez aucune amende/facture!")
			end
			RageUI.Line()
			RageUI.Button(("~g~Payer les amendes/factures sélectionnées (%s$)"):format(_PersonalMenu.Bills.TotalSelectedPrice), nil, {}, true, {
				onSelected = function()
					for _, v in pairs(_PersonalMenu.PlayerBills) do
						if (v.index) then
							ESX.TriggerServerCallback("esx_billing:payBill", function()
								_PersonalMenu:getPlayerBills()
							end, v.id)
						end
					end
				end
			})
		end)
		RageUI.IsVisible(licence, function()
			RageUI.Button("Métier : ".._PersonalMenu.PlayerData.job.label.." - ".._PersonalMenu.PlayerData.job.grade_label, nil, {}, true, {})
			RageUI.Line()
			RageUI.List("Regarder : ", {
				{ Name = "Carte d'identité", Type = "id_card"},
				{ Name = "Permis de conduire", Type = "driver"},
				{ Name = "Licence d'armes", Type = "weapon"},
			}, index.licence_watch, nil, {}, true, {
				onListChange = function(Index, Item)
					index.licence_watch = Index;
				end,
				onSelected = function(_, Item)
					if (Item.Type == "id_card") then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
					else
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), Item.Type)
					end
				end
			})
			RageUI.List("Montrer : ", {
				{ Name = "Carte d'identité", Type = "id_card"},
				{ Name = "Permis de conduire", Type = "driver"},
				{ Name = "Licence d'armes", Type = "weapon"},
			}, index.licence_show, nil, {}, true, {
				onListChange = function(Index, Item)
					index.licence_show = Index;
				end,
				onSelected = function(_, Item)
					local player, distance = ESX.Game.GetClosestPlayer()
					if player ~= -1 and distance <= 3.0 then
						if (Item.Type == "id_card") then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
						else
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), Item.Type)
						end
					else
						ESX.ShowNotification('Aucun joueur à proximité')
					end
				end
			})
		end)
		RageUI.IsVisible(manage_corp, function()
			_PersonalMenu:marker_nearest_player()
			RageUI.Button("Recruter", nil, {}, true, {
				onSelected = function()
					local player, dst = ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
					if (dst > 3.0) or (player == -1) then
						return ESX.ShowNotification("Aucun joueur à proximité")
					end
					TriggerServerEvent("personalmenu:manage_corp:recruit", GetPlayerServerId(player))
				end
			})
			RageUI.Button("Virer", nil, {}, true, {
				onSelected = function()
					local player = ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
					if (dst > 3.0) or (player == -1) then
						return ESX.ShowNotification("Aucun joueur à proximité")
					end
					TriggerServerEvent("personalmenu:manage_corp:transfer", GetPlayerServerId(player))
				end
			})
			RageUI.Button("Promouvoir", nil, {}, true, {
				onSelected = function()
					local player = ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
					if (dst > 3.0) or (player == -1) then
						return ESX.ShowNotification("Aucun joueur à proximité")
					end
					TriggerServerEvent("personalmenu:manage_corp:promote", GetPlayerServerId(player))
				end
			})
			RageUI.Button("Rétrograder", nil, {}, true, {
				onSelected = function()
					local player = ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
					if (dst > 3.0) or (player == -1) then
						return ESX.ShowNotification("Aucun joueur à proximité")
					end
					TriggerServerEvent("personalmenu:manage_corp:downgrade", GetPlayerServerId(player))
				end
			})
		end)
		RageUI.IsVisible(admin, function()
			RageUI.Checkbox("No-clip", nil, index.noclip, {Enabled = Config.PermissionAdmin.NoClip[_PersonalMenu.PlayerData.group]}, {
				onChecked = function()
					NoClip(true)
				end,
				onUnChecked = function()
					NoClip(false)
				end,
				onSelected = function(Index)
					index.noclip = Index
				end
			})
			RageUI.Checkbox("Godmode", nil, index.godmode, {Enabled = Config.PermissionAdmin.GodMode[_PersonalMenu.PlayerData.group]}, {
				onChecked = function()
					SetEntityInvincible(PlayerPedId(), true)
				end,
				onUnChecked = function()
					SetEntityInvincible(PlayerPedId(), false)
				end,
				onSelected = function(Index)
					index.godmode = Index
				end
			})
			RageUI.Checkbox("Invisible", nil, index.invisible, {Enabled = Config.PermissionAdmin.Invisible[_PersonalMenu.PlayerData.group]}, {
				onChecked = function()
					SetEntityVisible(PlayerPedId(), false)
				end,
				onUnChecked = function()
					SetEntityVisible(PlayerPedId(), true)
				end,
				onSelected = function(Index)
					index.invisible = Index
				end
			})
			RageUI.Line()
			RageUI.Button("Se téléporter à", nil, {}, Config.PermissionAdmin.TeleportTo[_PersonalMenu.PlayerData.group], {
				onSelected = function()
					local id = _PersonalMenu:keyboard("ID du joueur", nil, 4)
					TriggerServerEvent("personalmenu:admin:teleport", id)
				end
			})
			RageUI.Button("Téléporter à moi", nil, {}, Config.PermissionAdmin.TeleportToMe[_PersonalMenu.PlayerData.group], {
				onSelected = function()
					local id = _PersonalMenu:keyboard("ID du joueur", nil, 4)
					TriggerServerEvent("personalmenu:admin:teleportToMe", id)
				end
			})
		end)
		RageUI.IsVisible(visual, function()
			RageUI.Checkbox("Afficher/Cacher la carte", nil, index.map, {}, {
				onChecked = function()
					DisplayRadar(true)
				end,
				onUnChecked = function()
					DisplayRadar(false)
				end,
				onSelected = function(Index)
					index.map = Index
				end
			})
			RageUI.Checkbox("Mode cinématique", nil, index.cinematic, {}, {
				onChecked = function()
					ESX.UI.HUD.SetDisplay(0.0)
					TriggerEvent('es:setMoneyDisplay', 0.0)
					TriggerEvent('esx_status:setDisplay', 0.0)
					DisplayRadar(false)
				end,
				onUnChecked = function()
					ESX.UI.HUD.SetDisplay(1.0)
					TriggerEvent('es:setMoneyDisplay', 1.0)
					TriggerEvent('esx_status:setDisplay', 1.0)
					DisplayRadar(true)
				end,
				onSelected = function(Index)
					index.cinematic = Index
				end
			})
			RageUI.List("Effet", {
				{Name = "Aucun", Type = ""},
				{Name = "Bourré", Type = "DrugsMichaelAliensFight"},
				{Name = "Bourré n°2", Type = "HeistCelebPass"},
				{Name = "Bourré n°3", Type = "SuccessMichael"},
				{Name = "Noir & Blanc", Type = "DeathFailOut"},
				{Name = "Noir & Blanc n°2", Type = "DeathFailMPIn"},
				{Name = "Drogué", Type = "BikerFilter"},
				{Name = "Drogué n°2", Type = "BikerFormation"},
				{Name = "Drogué n°3", Type = "DMT_flight"},
				{Name = "Flou", Type = "BeastTransition"},
				{Name = "Cinématique", Type = "DeadlineNeon"},
			}, index.effect, nil, {}, true, {
				onListChange = function(Index, Item)
					index.effect = Index;
				end,
				onSelected = function(_, Item)
					AnimpostfxStopAll()
					AnimpostfxPlay(Item.Type, 10000001, true)
				end
			})
		end)

		if not RageUI.Visible(main) and not RageUI.Visible(inventory) and not RageUI.Visible(billing) and not RageUI.Visible(licence) and not RageUI.Visible(manage_corp) and not RageUI.Visible(admin) and not RageUI.Visible(visual) then
			main = RMenu:DeleteType('main', true)
			inventory = RMenu:DeleteType('inventory', true)
			billing = RMenu:DeleteType('billing', true)
			licence = RMenu:DeleteType('licence', true)
			manage_corp = RMenu:DeleteType('manage_corp', true)
			admin = RMenu:DeleteType('admin', true)
			visual = RMenu:DeleteType('visual', true)
		end
	end
end

Keys.Register(Config.OpenKey, Config.OpenKey, "Open PersonalMenu", function()
	ESX.TriggerServerCallback("personalmenu:player:getData", function(data)
		_PersonalMenu.PlayerData.name = data.name
		_PersonalMenu.PlayerData.group = data.group

		_PersonalMenu:main_menu()
	end)
end)

Citizen.CreateThread(function()
	while (true) do
		local interval = 1000
		if (index.cinematic) then
			interval = 0
			DrawRect(0.5, 0.0, 1.0, 0.25, 0, 0, 0, 255)
			DrawRect(0.5, 1.0, 1.0, 0.25, 0, 0, 0, 255)
		end

		Wait(interval)
	end
end)