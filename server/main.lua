ESX 			    			= nil
local lastTime = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


for item_name in pairs(options) do
    ESX.RegisterUsableItem(item_name, function(source)
        local _source = source
        local currentTime = os.time(os.date("!*t"))
        if lastTime and currentTime - lastTime < 10 then
            TriggerClientEvent("pNotify:SendNotification", source, {
                text = _U('waitconfig'),
                type = "error",
                timeout = 2000,
                layout = "centerLeft"
            })
            do return end
        end
        lastTime = os.time(os.date("!*t"))

        --Check is there a good count of cops on duty
        local xPlayers = ESX.GetPlayers()
        local cops = 0
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                cops = cops + 1
                if cops >= options[item_name].cops then break end
            end
        end

        if cops >= options[item_name].cops then
            TriggerClientEvent('esx_receptury:RequestStart', _source, item_name, lastTime)
        else
            TriggerClientEvent("pNotify:SendNotification", _source, {
                 text = _U('police_req_1') .. options[item_name].cops .. _U('police_req_2'),
                type = "error",
                timeout = 5000,
                layout = "centerLeft"
            })
            TriggerClientEvent("pNotify:SendNotification", _source, {
                text = text = _U('police') .. cops ..'/'.. options[item_name].cops,
                type = "info",
                timeout = 6000,
                layout = "centerLeft"
            })
        end
    end)
end


RegisterServerEvent("esx_receptury:RemoveItem")
AddEventHandler("esx_receptury:RemoveItem", function(item_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(item_name, 1)
end)


RegisterServerEvent("esx_receptury:statusSuccess")
AddEventHandler("esx_receptury:statusSuccess", function(message, min, max, item)
	TriggerClientEvent('esx:showNotification', source, message)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	math.randomseed(os.time())
	local amount = math.random(min, max)
	local itemProps = xPlayer.getInventoryItem(item)
	if(itemProps.limit < itemProps.count + amount) then
		xPlayer.setInventoryItem(item, itemProps.limit)
		TriggerClientEvent("pNotify:SendNotification", source, {
		    text = _U('inv_full'),
		    type = "error",
		    timeout = 2000,
		    layout = "centerLeft"
		})
	else
		xPlayer.addInventoryItem(item, amount)
	end
end)
