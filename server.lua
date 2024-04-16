ESX = exports['es_extended']:getSharedObject()

local cuffed = {}

ESX.RegisterServerCallback('primePlayermenu:getWeight', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local playerWeight = xPlayer.getWeight()
    local playerMaxWeight = xPlayer.getMaxWeight()

    cb(playerWeight, playerMaxWeight)

end)

ESX.RegisterServerCallback('primePlayermenu:getIBAN', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.query('SELECT iban FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
    }, function(result)
    
        if result[1] ~= nil and result[1].iban ~= nil then
            cb(result[1].iban)
        else
            cb(false)
        end

    end)

end)

ESX.RegisterServerCallback('primePlayermenu:getInventory', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local playerInventory = xPlayer.getInventory(minimal)

    cb(playerInventory)

end)

ESX.RegisterServerCallback('primePlayermenu:getMyGrade', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    local mygradeName = xPlayer.getJob().grade_name
    local myJobLabel = xPlayer.getJob().label
    local myJobName = xPlayer.getJob().name

    cb(mygradeName, myJobLabel, myJobName)

end)

ESX.RegisterServerCallback('primePlayermenu:getPlayerInfo', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.WalletContent.iban then
        MySQL.query('SELECT iban FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
        
            local myCash = xPlayer.getMoney()
            local myBank = xPlayer.getAccount('bank').money
            local myBlackmoney = xPlayer.getAccount('black_money').money

            local myJobLabel = xPlayer.getJob().label
            local myGradeLabel = xPlayer.getJob().grade_label
            local myGrade = xPlayer.getJob().grade

            if result[1] ~= nil and result[1].iban ~= nil then
                cb(myCash, myJobLabel, myGradeLabel, myGrade, myBank, myBlackmoney, result[1].iban)
            else
                cb(myCash, myJobLabel, myGradeLabel, myGrade, myBank, myBlackmoney)
            end
        
        end)

    else
        local myCash = xPlayer.getMoney()
        local myBank = xPlayer.getAccount('bank').money
        local myBlackmoney = xPlayer.getAccount('black_money').money

        local myJobLabel = xPlayer.getJob().label
        local myGradeLabel = xPlayer.getJob().grade_label
        local myGrade = xPlayer.getJob().grade

        cb(myCash, myJobLabel, myGradeLabel, myGrade, myBank, myBlackmoney)
    end

end)

RegisterServerEvent('primePlayermenu:FireEmployee')
AddEventHandler('primePlayermenu:FireEmployee', function(player, jobName, joblabel)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(player)

    local targetJob = zPlayer.getJob().name
    local targetName = zPlayer.getName()

    if targetJob == jobName then
        zPlayer.setJob(Config.UnemployedJob, Config.DefaultJobGrade)
        TriggerClientEvent('esx:showNotification', player, Translation[Config.Locale]['fired_notify'])
        xPlayer.showNotification(Translation[Config.Locale]['youfired_notify1'] .. targetName .. Translation[Config.Locale]['youfired_notify2'])
    else
        xPlayer.showNotification(Translation[Config.Locale]['error_samejob'])
    end

end)

RegisterServerEvent('primePlayermenu:DegradeEmployee')
AddEventHandler('primePlayermenu:DegradeEmployee', function(player, jobName, joblabel)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(player)

    local targetJob = zPlayer.getJob().name
    local targetJobGrade = zPlayer.getJob().grade
    local targetName = zPlayer.getName()

    if targetJob == jobName then
        zPlayer.setJob(jobName, targetJobGrade - 1)
        TriggerClientEvent('esx:showNotification', player, Translation[Config.Locale]['degraded'])
        xPlayer.showNotification(Translation[Config.Locale]['youdegraded_notify1'] .. targetName .. Translation[Config.Locale]['youdegraded_notify2'])
    else
        xPlayer.showNotification(Translation[Config.Locale]['error_samejob'])
    end

end)

RegisterServerEvent('primePlayermenu:PromoteEmployee')
AddEventHandler('primePlayermenu:PromoteEmployee', function(player, jobName, joblabel)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(player)

    local targetJob = zPlayer.getJob().name
    local targetJobGrade = zPlayer.getJob().grade
    local targetName = zPlayer.getName()

    if targetJob == jobName then

        zPlayer.setJob(jobName, targetJobGrade + 1)
        TriggerClientEvent('esx:showNotification', player, Translation[Config.Locale]['promoted'])
        xPlayer.showNotification(Translation[Config.Locale]['youpromoted_notify1'] .. targetName .. Translation[Config.Locale]['youpromoted_notify2'])

    else
        xPlayer.showNotification(Translation[Config.Locale]['error_samejob'])
    end

end)

RegisterServerEvent('primePlayermenu:HireEmployee')
AddEventHandler('primePlayermenu:HireEmployee', function(player, jobName, joblabel)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(player)

    local getPlayerJob = zPlayer.getJob().name

    if getPlayerJob ~= jobName then

        zPlayer.setJob(jobName, Config.DefaultJobGrade)
        local playerName = zPlayer.getName()

        TriggerClientEvent('esx:showNotification', player, Translation[Config.Locale]['hired1'] .. joblabel .. Translation[Config.Locale]['hired2'])
        TriggerClientEvent('esx:showNotification', source, Translation[Config.Locale]['youhired_notify1'] .. playerName .. Translation[Config.Locale]['youhired_notify2'])
    else
        xPlayer.showNotification(Translation[Config.Locale]['already_an_employee'])
    end

end)

RegisterServerEvent('primePlayermenu:RobCash')
AddEventHandler('primePlayermenu:RobCash', function(target)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(target)

    local targetCash = zPlayer.getMoney()

    if targetCash > 0 then
        zPlayer.removeMoney(targetCash)
        xPlayer.addMoney(targetCash)

        zPlayer.showNotification('Dir wurde ' .. reformatInt(targetCash) .. Config.Currency .. ' gestohlen.')
        xPlayer.showNotification('Du hast ' .. reformatInt(targetCash) .. Config.Currency .. ' gestohlen.')
    else
        xPlayer.showNotification('~r~Die Person hat kein Bargeld.')
    end

end)

RegisterServerEvent('primePlayermenu:RobBlackmoney')
AddEventHandler('primePlayermenu:RobBlackmoney', function(target)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(target)

    local targetBlackmoney = zPlayer.getAccount('black_money').money

    if targetBlackmoney > 0 then
        zPlayer.showNotification('Dir wurde ' .. reformatInt(targetBlackmoney) .. Config.Currency .. ' gestohlen.')
        xPlayer.showNotification('Du hast ' .. reformatInt(targetBlackmoney) .. Config.Currency .. ' gestohlen.')

        zPlayer.removeAccountMoney('black_money', targetBlackmoney)
        xPlayer.addAccountMoney('black_money', targetBlackmoney)
    else
        xPlayer.showNotification('~r~Die Person hat kein Schwarzgeld.')
    end

end)

ESX.RegisterServerCallback('primePlayermenu:getTargetInventory', function(source, cb, target)

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = ESX.GetPlayerFromId(target)

    local targetInventory = zPlayer.getInventory()
    local targetCash = zPlayer.getMoney()
    local targetBlackmoney = zPlayer.getAccount('black_money').money

    TriggerClientEvent('esx:showNotification', target, 'Du wirst gerade durchsucht..')

    cb(targetInventory, targetCash, targetBlackmoney)

end)

ESX.RegisterUsableItem(Config.HandcuffItem, function(source)
    TriggerClientEvent("primePlayermenu:checkCuff", source)
end)

ESX.RegisterUsableItem(Config.HandcuffkeysItem, function(source)
    TriggerClientEvent("primePlayermenu:uncuff", source)
end)

RegisterServerEvent("primePlayermenu:uncuff")
AddEventHandler("primePlayermenu:uncuff",function(player)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    --xPlayer.addInventoryItem(Config.HandcuffItem, 1)
    cuffed[player]=false
    TriggerClientEvent('primePlayermenu:forceUncuff', player)
end)

RegisterServerEvent("primePlayermenu:handcuff")
AddEventHandler("primePlayermenu:handcuff",function(player,state)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cuffed[player]=state
    TriggerClientEvent('primePlayermenu:handcuff', player)
    if state then xPlayer.removeInventoryItem(Config.HandcuffItem, 1) else xPlayer.addInventoryItem(Config.HandcuffItem, 1) end
end)

function reformatInt(i)
	return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

ESX.RegisterServerCallback("primePlayermenu:isCuffed",function(source,cb,target)
    cb(cuffed[target] ~=nil and cuffed[target])
end)