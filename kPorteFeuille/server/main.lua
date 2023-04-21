ESX.RegisterServerCallback("VerifItems", function(source, cb, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local verifitem = xPlayer.getInventoryItem(item).count

    if verifitem >= 1 then 
        cb(true)
    else 
        cb(false)
    end 
end)

ESX.RegisterServerCallback('kPorteMonnaie:ObtenirFactures', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			}
		end
		cb(bills)
	end)
end)
