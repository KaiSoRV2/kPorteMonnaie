
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(Faction)
    ESX.PlayerData.faction = Faction
end)

local MainMenuOuvert = false 
local MainPorteMonnaie = RageUI.CreateMenu('', 'Porte Monnaie')
local MenuArgentLiquide = RageUI.CreateSubMenu(MainPorteMonnaie, '', "Argent Liquide")
local MenuPapiers = RageUI.CreateSubMenu(MainPorteMonnaie, '', "Vos Papiers")
local MenuFactures = RageUI.CreateSubMenu(MainPorteMonnaie, '', "Vos Factures")
MainPorteMonnaie.Display.Header = true 
MainPorteMonnaie.Closed = function()
    MainMenuOuvert = false 
end 

function PorteMonnaie()

    local IndexListID = 1
    local IndexListPC = 1
    local IndexListPA = 1

    if MainMenuOuvert then 
        MainMenuOuvert = false 
        RageUI.Visible(MainPorteMonnaie, false)
        return 
    else 
        MainMenuOuvert = true 
        RageUI.Visible(MainPorteMonnaie, true)
        CreateThread(function()

            local billing = {}
            ESX.TriggerServerCallback('kPorteMonnaie:ObtenirFactures', function(bills)
                billing = bills
                ESX.PlayerData = ESX.GetPlayerData()
            end)

            while MainMenuOuvert do 
                RageUI.IsVisible(MainPorteMonnaie, function()
                    
                    RageUI.Separator("↓ Votre Porte Monnaie ↓")
                    RageUI.Separator("~g~Emploie : ~s~".. ESX.PlayerData.job.label)
                    RageUI.Separator("~r~Organisation : ~s~".. ESX.PlayerData.faction.label)
                    RageUI.Button('Argent Liquide', nil, {RightLabel = "→→"}, true, {}, MenuArgentLiquide);
                    RageUI.Button('Papiers', nil, {RightLabel = "→→"}, true, {}, MenuPapiers);
                    RageUI.Button('Factures', nil, {RightLabel = "→→"}, true, {}, MenuFactures);
                end)

                RageUI.IsVisible(MenuArgentLiquide, function()
                    RageUI.Separator("↓ Argent Liquide ↓")
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        -- Argent 
                        if ESX.PlayerData.accounts[i].name == 'money' then
                            RageUI.Button("~g~Argent : ", nil, {RightLabel = "~s~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).."$"}, true, {})
                        end
                        -- Argent Sale
                        if ESX.PlayerData.accounts[i].name == 'black_money' then
                            RageUI.Button("~r~Argent Sale : ", nil, {RightLabel = "~s~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).."$"}, true, {})
                        end
                    end
                end)

                RageUI.IsVisible(MenuPapiers, function()
                    RageUI.Separator("↓ Vos Papiers ↓")
                    RageUI.List("Carte d'Identité : ", {"Voir", "Montrer"}, IndexListID, nil, {}, true, {
                        onListChange = function(Index, Item) -- Index - Indice sur lequel on est et Item = ce qu'on à mit à l'interieur
                            IndexListID = Index
                        end,
                        onSelected = function(Index, Item)
                            if IndexListID == 1 then 
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                            elseif IndexListID == 2 then 
                                local player, distance = ESX.Game.GetClosestPlayer()
                                if distance ~= -1 and distance <= 3.0 then
                                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
                                else
                                    ESX.ShowNotification("Il n'y a personne autour de vous")
                                end
                            end
                        end
                    })

                    RageUI.List("Permis de Conduire : ", {"Voir", "Montrer"}, IndexListPC, nil, {}, true, {
                        onListChange = function(Index, Item) -- Index - Indice sur lequel on est et Item = ce qu'on à mit à l'interieur
                            IndexListPC = Index
                        end,
                        onSelected = function(Index, Item)
                            if IndexListPC == 1 then 
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                            elseif IndexListPC == 2 then 
                                local player, distance = ESX.Game.GetClosestPlayer()
                                if distance ~= -1 and distance <= 3.0 then
                                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
                                else
                                    ESX.ShowNotification("Il n'y a personne autour de vous")
                                end
                            end
                        end
                    })

                    RageUI.List("Permis Port d'Armes : ", {"Voir", "Montrer"}, IndexListPA, nil, {}, true, {
                        onListChange = function(Index, Item) -- Index - Indice sur lequel on est et Item = ce qu'on à mit à l'interieur
                            IndexListPA = Index
                        end,
                        onSelected = function(Index, Item)
                            if IndexListPA == 1 then 
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                            elseif IndexListPA == 2 then 
                                local player, distance = ESX.Game.GetClosestPlayer()
                                if distance ~= -1 and distance <= 3.0 then
                                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
                                else
                                    ESX.ShowNotification("Il n'y a personne autour de vous")
                                end
                            end
                        end
                    })
                end)

                RageUI.IsVisible(MenuFactures, function()
                    RageUI.Separator("↓ Vos Factures ↓")
                    if #billing == 0 then
                        RageUI.Button("Vous n'avez aucune facture", nil, { RightLabel = "" }, true,{} )
                    end
                        
                    for i = 1, #billing, 1 do
                        RageUI.Button(billing[i].label, nil, {RightLabel = '[~b~$' .. ESX.Math.GroupDigits(billing[i].amount.."~s~] →")}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('esx_billing:payBill', function()
                                    ESX.TriggerServerCallback('kPorteMonnaie:ObtenirFactures', function(bills) billing = bills end)
                                end, billing[i].id)
                            end
                        })
                    end
                end)
            Wait(0)
            end
        end)
    end 
end 




-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Config.InputKey) then
            if Config.UseItem then  
                ESX.TriggerServerCallback("VerifItems", function(HasRequiredItem) 
                    if HasRequiredItem then 
                        PorteMonnaie()
                    else 
                        ESX.ShowNotification("~r~Vous n'avez pas de porte monnaie sur vous !")
                    end
                end, Config.RequiredItem)
            else 
                PorteMonnaie() 
            end
		end
	end
end)
