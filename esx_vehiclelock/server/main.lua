ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_vehiclelock:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)


ESX.RegisterServerCallback('esx_carlock:hasKeys', function(source, cb, plate )
	local xPlayer = ESX.GetPlayerFromId(source)
	print(plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {['@id'] = xPlayer.getIdentifier(), ['@plate'] = plate}, function(result)
		if #result > 0 then 
			if result[1].owner == xPlayer.identifier then 
				cb(true)
			else 
				if result[1].owner == 'FRAKTION' then 
					if result[1].job == xPlayer.getJob().name then 
						cb(true)
					else
						cb(false)
					end
				else
					cb(false)
				end
			end
		else 
			cb(false)
		end
	end) 
end)