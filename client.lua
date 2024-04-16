ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
    while ESX.GetPlayerData().inventory == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

_menuPool = NativeUI.CreatePool()
local mainMenu
local inventoryMenu
local robMenu

local society_money = nil
local hasAccess = false


local IsHandcuffed = false

Citizen.CreateThread(function()
    while true do

        if _menuPool:IsAnyMenuOpen() then 
            _menuPool:ProcessMenus()
        end

        local playerPed = PlayerPedId()

        if IsControlJustReleased(0, Config.OpenMenu) then
            openPlayermenu()
        end


        Citizen.Wait(1)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    print('registered Job: ' .. xPlayer.job.name)


    Citizen.CreateThread(function()
        while true do

            RefreshMoney()
            refreshCompanyAccess()

            Citizen.Wait(200)
        end
    end)

end)

-- Citizen.CreateThread(function()
--     while true do

--         RefreshMoney()
--         refreshCompanyAccess()

--         Citizen.Wait(200)
--     end
-- end)

function refreshCompanyAccess()

    ESX.TriggerServerCallback('primePlayermenu:getMyGrade', function(gradeName, myJobLabel, myJobName)
        hasAccess = false
        if Config.GradeAccess ~= nil and #Config.GradeAccess > 0 then
            for j, allowedGrade in pairs(Config.GradeAccess) do
                if allowedGrade == gradeName then
                    hasAccess = true
                end
            end
        end

    end)

end

function openInventory()

    _menuPool:CloseAllMenus()
    collectgarbage()
    _menuPool:RefreshIndex()

    local inventoryMenu = NativeUI.CreateMenu(Translation[Config.Locale]['inventorytitle'], Translation[Config.Locale]['inventorySubtitle'])
    _menuPool:Add(inventoryMenu)


    ESX.TriggerServerCallback('primePlayermenu:getWeight', function(playerWeight, playerMaxWeight)

        local yourWeight = NativeUI.CreateItem(Translation[Config.Locale]['weight'] .. playerWeight .. Config.WeightUnit .. ' / ' .. playerMaxWeight .. Config.WeightUnit, '')
        inventoryMenu:AddItem(yourWeight)
    
    end)


    ESX.TriggerServerCallback('primePlayermenu:getInventory', function(playerInventory)
    
        for k, v in pairs(playerInventory) do

            if v.count >= 1 then
                local itemSub = _menuPool:AddSubMenu(inventoryMenu, v.count .. 'x ' .. v.label, '')
                itemSub.Item:RightLabel(v.count * v.weight .. Config.WeightUnit)
                _menuPool:RefreshIndex()
                local useItem = NativeUI.CreateItem(Translation[Config.Locale]['useInventoryItem'], '')
                local giveItem = NativeUI.CreateItem(Translation[Config.Locale]['giveInventoryItem'], '')
                local dropItem = NativeUI.CreateItem(Translation[Config.Locale]['dropInventoryItem'], '')

                itemSub.SubMenu:AddItem(useItem)
                itemSub.SubMenu:AddItem(giveItem)
                itemSub.SubMenu:AddItem(dropItem)


                useItem.Activated = function(sender, index)
                    if v.count >= 1 then
                        TriggerServerEvent('esx:useItem', v.name)
                    else
                        ESX.ShowNotification(Translation[Config.Locale]['notEnoughNotify'] .. v.label .. Translation[Config.Locale]['notEnoughNotify2'])
                    end
                end

                giveItem.Activated = function(sender, index)

                    local giveItemDialog = CreateDialog(Translation[Config.Locale]['giveItemDialog'] .. v.label .. Translation[Config.Locale]['giveItemDialog2'])
                    if (giveItemDialog ~= nil) then
                        if tonumber(giveItemDialog) then
                            local giveAmount = tonumber(giveItemDialog)
                            local closestPlayer2, closestDistance2 = ESX.Game.GetClosestPlayer()

					        if closestDistance2 ~= -1 and closestDistance2 <= 3 then
						        local closestPed = GetPlayerPed(closestPlayer2)

                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer2), 'item_standard', v.name, giveAmount)
                            else
                                ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                            end
                        else
                            ESX.ShowNotification(Translation[Config.Locale]['inputFigureText'])
                        end
                    end


                end

                dropItem.Activated = function(sender, index)

                    local dropItemDialog = CreateDialog(Translation[Config.Locale]['dropItemtext1'] .. v.label .. Translation[Config.Locale]['dropItemtext2'])
                    if (dropItemDialog ~= nil) then
                        if tonumber(dropItemDialog) then
                            dropAmount = tonumber(dropItemDialog)
                            TriggerServerEvent('esx:removeInventoryItem', 'item_standard', v.name, dropAmount)
                            _menuPool:RefreshIndex()
                            _menuPool:CloseAllMenus()
                        else
                            ESX.ShowNotification(Translation[Config.Locale]['inputFigureText'])
                        end
                    end

                end

            end

        end

        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled (false)
        _menuPool:ControlDisablingEnabled(false)
    
    end)



    _menuPool:RefreshIndex()
    inventoryMenu:Visible(true)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)

end

function RefreshMoney()
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		society_money = reformatInt(money)
	end, ESX.PlayerData.job.name)
end

-- function openRobMenu(target)

--     _menuPool:CloseAllMenus()
--     collectgarbage()
--     _menuPool:RefreshIndex()

--     local robMenu = NativeUI.CreateMenu('Ausrauben', 'Durchsuchen')
--     _menuPool:Add(robMenu)

--     ESX.TriggerServerCallback('primePlayermenu:getTargetInventory', function(targetInventory, targetCash, targetBlackmoney)

--         local money = NativeUI.CreateItem('Bargeld', '')
--         money:RightLabel('~g~' .. reformatInt(targetCash) .. Config.Currency)
--         robMenu:AddItem(money)

--         local blackmoney = NativeUI.CreateItem('Schwarzgeld', '')
--         blackmoney:RightLabel('~r~' .. reformatInt(targetBlackmoney) .. Config.Currency)
--         robMenu:AddItem(blackmoney)

--         blackmoney.Activated = function(sender, index)
--             TriggerServerEvent('primePlayermenu:RobBlackmoney', GetPlayerServerId(target))
--             _menuPool:CloseAllMenus()
--             openRobMenu(target)
--         end

--         money.Activated = function(sender, index)
--             TriggerServerEvent('primePlayermenu:RobCash', GetPlayerServerId(target))
--             _menuPool:CloseAllMenus()
--             openRobMenu(target)
--         end

--     end)

--     _menuPool:RefreshIndex()
--     robMenu:Visible(true)
--     _menuPool:MouseControlsEnabled(false)
--     _menuPool:MouseEdgeEnabled(false)
--     _menuPool:ControlDisablingEnabled(false)

-- end

function openPlayermenu()

    _menuPool:CloseAllMenus()
    collectgarbage()
    _menuPool:RefreshIndex()
    refreshCompanyAccess()

    local mainMenu = NativeUI.CreateMenu(Translation[Config.Locale]['PlayermenuTitle'], Translation[Config.Locale]['PlayermenuSubtitle'])
    _menuPool:Add(mainMenu)

    -- playeractions

    if Config.showPlayeractions then
        local subPlayerActions = _menuPool:AddSubMenu(mainMenu, Translation[Config.Locale]['PlayeractionsTitle'], '')
        subPlayerActions.Item:RightLabel('→→→')


        if Config.PlayeractionsContent.cuff then
            local cuffPlayer = NativeUI.CreateItem(Translation[Config.Locale]['handcuffTitle'], '')
            subPlayerActions.SubMenu:AddItem(cuffPlayer)

            local uncuffPlayer = NativeUI.CreateItem(Translation[Config.Locale]['cutHandcuffs'], '')
            subPlayerActions.SubMenu:AddItem(uncuffPlayer)

            cuffPlayer.Activated = function(sender, index)
                TriggerServerEvent('esx:useItem', Config.HandcuffItem)
            end

            uncuffPlayer.Activated = function(sender, index)
                TriggerServerEvent('esx:useItem', Config.HandcuffkeysItem)
            end

        end

        -- if Config.PlayeractionsContent.search then
        --     local searchPlayer = NativeUI.CreateItem('Person durchsuchen', '')
        --     subPlayerActions.SubMenu:AddItem(searchPlayer)


        --     searchPlayer.Activated = function(sender, index)

        --         local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		-- 		if closestPlayer ~= -1 and closestDistance <= 3.0 then
        --             openRobMenu(closestPlayer)
        --         else
        --             ESX.ShowNotification('~r~Keine Person in der Nähe.')
        --         end


        --     end


        -- end

        if Config.PlayeractionsContent.searchIDCard then
            local seeID = NativeUI.CreateItem(Translation[Config.Locale]['showIDCardTitle'], '')
            subPlayerActions.SubMenu:AddItem(seeID)

            seeID.Activated = function(sender, index)

                local player, distance = ESX.Game.GetClosestPlayer()

                if distance ~= -1 and distance <= 3.0 then

                    TriggerEvent('primePlayermenu:checkCuff2', player)
                else
                    ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                end

            end

        end
    
    end

    -- playeractions

    -- wallet


    if Config.showWallet then
        local subWallet = _menuPool:AddSubMenu(mainMenu, Translation[Config.Locale]['walletTitle'], '')
        subWallet.Item:RightLabel('→→→')

        if Config.WalletContent.playerid then

            local id = NativeUI.CreateItem(Translation[Config.Locale]['yourid'] .. GetPlayerServerId(PlayerId()), '')
            subWallet.SubMenu:AddItem(id)

        end

        ESX.TriggerServerCallback('primePlayermenu:getPlayerInfo', function(myCash, myJobLabel, myGradeLabel, myGrade, myBank, myBlackmoney, iban)

            if Config.WalletContent.iban then
                if iban ~= nil then
                    local iban = NativeUI.CreateItem(Translation[Config.Locale]['iban'] .. iban, '')
                    subWallet.SubMenu:AddItem(iban)
                else
                    local noIban = NativeUI.CreateItem(Translation[Config.Locale]['noiban'], '')
                    subWallet.SubMenu:AddItem(noIban)
                end
            end

            if Config.WalletContent.job then

                local jobItem = NativeUI.CreateItem(Translation[Config.Locale]['jobTitle'] .. myJobLabel .. ' - ' .. myGradeLabel .. ' (' .. myGrade .. ')', '')
                subWallet.SubMenu:AddItem(jobItem)
            end

        
        
            if Config.WalletContent.cash then
            
                local cashItem = NativeUI.CreateItem(Translation[Config.Locale]['CashTitle'] .. reformatInt(myCash) .. Config.Currency, '')
                subWallet.SubMenu:AddItem(cashItem)
            
            end
        

            if Config.WalletContent.bank then
            
                local bankItem = NativeUI.CreateItem(Translation[Config.Locale]['bankTitle'] .. reformatInt(myBank) .. Config.Currency, '')
                subWallet.SubMenu:AddItem(bankItem)
            end

            if Config.WalletContent.blackmoney then

                local blackmoneyItem = NativeUI.CreateItem(Translation[Config.Locale]['blackmoney'] .. reformatInt(myBlackmoney) .. Config.Currency, '')
                subWallet.SubMenu:AddItem(blackmoneyItem)

            end


            if Config.WalletContent.job or Config.WalletContent.cash or Config.WalletContent.bank then
                if Config.WalletContent.IDCard or Config.WalletContent.DriverLicense or Config.WalletContent.GunLicense then
                    local emptyItem = NativeUI.CreateItem('', '')
                    subWallet.SubMenu:AddItem(emptyItem)
                end
            end


            

            local IDCardOptions = {Translation[Config.Locale]['IDOptionsSee'], Translation[Config.Locale]['IDOptionsShow']}
            local IDCardList = NativeUI.CreateListItem(Translation[Config.Locale]['IDCardTitle'], IDCardOptions, 1)

            if Config.WalletContent.IDCard then
                subWallet.SubMenu:AddItem(IDCardList)
            end


            local DriversLicenseOptions = {Translation[Config.Locale]['IDOptionsSee'], Translation[Config.Locale]['IDOptionsShow']}
            local DriversLicenseList = NativeUI.CreateListItem(Translation[Config.Locale]['DriversLicenseTitle'], DriversLicenseOptions, 1)

            if Config.WalletContent.DriverLicense then
                subWallet.SubMenu:AddItem(DriversLicenseList)
            end

    

            local GunLicenseOptions = {Translation[Config.Locale]['IDOptionsSee'], Translation[Config.Locale]['IDOptionsShow']}
            local WeaponLicenseList = NativeUI.CreateListItem(Translation[Config.Locale]['WeaponLicenseTitle'], GunLicenseOptions, 1)

            if Config.WalletContent.GunLicense then
                subWallet.SubMenu:AddItem(WeaponLicenseList)
            end
            
            _menuPool:RefreshIndex()



            subWallet.SubMenu.OnListSelect = function(sender, item, index)
                if item == IDCardList then
                    if index == 1 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                        ESX.ShowNotification(Translation[Config.Locale]['SeeIDCardNotify'])
                    elseif index == 2 then
                        local player, distance = ESX.Game.GetClosestPlayer()

                        if distance ~= -1 and distance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
                        else
                            ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end
                    end
                elseif item == DriversLicenseList then
                    if index == 1 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                    elseif index == 2 then
                        local player, distance = ESX.Game.GetClosestPlayer()

                        if distance ~= -1 and distance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
                        else
                            ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end
                    end
                elseif item == WeaponLicenseList then
                    if index == 1 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                    elseif index == 2 then
                        local player, distance = ESX.Game.GetClosestPlayer()

                        if distance ~= -1 and distance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
                        else
                            ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end
                    end
                end
            end
        end)
    end

    if Config.showCompany then

        ESX.TriggerServerCallback('primePlayermenu:getMyGrade', function(gradeName, myJobLabel, myJobName)
        
            if hasAccess then
                        
                local companySub = _menuPool:AddSubMenu(mainMenu, Translation[Config.Locale]['company'], '')
                companySub.Item:RightLabel('→→→')
                _menuPool:RefreshIndex()
                local companyLabel = NativeUI.CreateItem(Translation[Config.Locale]['companylabel'] .. myJobLabel, '')
                -- companyLabel:RightLabel(myJobLabel)
                companySub.SubMenu:AddItem(companyLabel)


                if Config.CompanyContent.societymoney then

                    local societyaccount = NativeUI.CreateItem(Translation[Config.Locale]['business_account'], '')
                    companySub.SubMenu:AddItem(societyaccount)

                    ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
                        local society_money = reformatInt(money)
                        societyaccount:RightLabel('~g~' .. society_money .. Config.Currency)
                    end, myJobName)


                end

                if Config.CompanyContent.hire then

                    local hireEmployee = NativeUI.CreateItem(Translation[Config.Locale]['hire_employee'], Translation[Config.Locale]['hire_subtitle'])
                    companySub.SubMenu:AddItem(hireEmployee)

                    hireEmployee.Activated = function(sender, index)

                        local player, distance = ESX.Game.GetClosestPlayer()
                        if distance ~= -1 and distance <= 3.0 then

                            TriggerServerEvent('primePlayermenu:HireEmployee', GetPlayerServerId(player), myJobName, myJobLabel)

                        else
                            ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end


                    end

                end

                if Config.CompanyContent.promote then

                    local promoteEmployee = NativeUI.CreateItem(Translation[Config.Locale]['promote_employee'], Translation[Config.Locale]['promote_subtitle'])
                    companySub.SubMenu:AddItem(promoteEmployee)

                    promoteEmployee.Activated = function(sender, index)

                        local player, distance = ESX.Game.GetClosestPlayer()
                        if distance ~= -1 and distance <= 3.0 then

                            TriggerServerEvent('primePlayermenu:PromoteEmployee', GetPlayerServerId(player), myJobName, myJobLabel)

                        else
                            ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end

                    end

                end

                if Config.CompanyContent.degrade then

                    local degradeEmployee = NativeUI.CreateItem(Translation[Config.Locale]['degrade_employee'], Translation[Config.Locale]['degrade_subtitle'])
                    companySub.SubMenu:AddItem(degradeEmployee)

                    degradeEmployee.Activated = function(sender, index)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if distance ~= -1 and distance <= 3.0 then

                            TriggerServerEvent('primePlayermenu:DegradeEmployee', GetPlayerServerId(player), myJobName, myJobLabel)

                        else
                            ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end

                    end

                end

                if Config.CompanyContent.fire then

                    local fireEmployee = NativeUI.CreateItem(Translation[Config.Locale]['fire_employee'], Translation[Config.Locale]['fire_subtitle'])
                    fireEmployee:SetRightBadge(4)
                    companySub.SubMenu:AddItem(fireEmployee)

                    fireEmployee.Activated = function(sender, index)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if distance ~= -1 and distance <= 3.0 then
                            TriggerServerEvent('primePlayermenu:FireEmployee', GetPlayerServerId(player), myJobName, myJobLabel)
                        else
                            ShowNotification(Translation[Config.Locale]['noPlayerFound'])
                        end

                    end

                end

                _menuPool:RefreshIndex()

            else
                local companySubLock = NativeUI.CreateItem(Translation[Config.Locale]['company_locked'], '')
                companySubLock:SetRightBadge(21)
                mainMenu:AddItem(companySubLock)
                _menuPool:RefreshIndex()
            end
        
            _menuPool:MouseControlsEnabled(false)
            _menuPool:MouseEdgeEnabled(false)
            _menuPool:ControlDisablingEnabled(false)
        end)

    end


    local inventoryItem = NativeUI.CreateItem(Translation[Config.Locale]['inventorytitle'], '')
    inventoryItem:RightLabel('→→→')

    if Config.useInventory then
        mainMenu:AddItem(inventoryItem)
    end

    inventoryItem.Activated = function(sender, index)
        openInventory()
    end

    if Config.showVehiclemenu then

        if IsPedSittingInAnyVehicle(PlayerPedId(), false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then

                local vehiclemenuSub = _menuPool:AddSubMenu(mainMenu, Translation[Config.Locale]['vehiclemenu'], '')
                vehiclemenuSub.Item:SetRightBadge(12)

                if Config.VehiclemenuContent.engine then

                    local toggleEngine = NativeUI.CreateItem(Translation[Config.Locale]['toggle_engine'], '')

                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    local status = GetIsVehicleEngineRunning(vehicle)
                    
                    if status then
                        toggleEngine:RightLabel(Translation[Config.Locale]['engine_on'])
                    else
                        toggleEngine:RightLabel(Translation[Config.Locale]['engine_off'])
                    end

                    vehiclemenuSub.SubMenu:AddItem(toggleEngine)


                    toggleEngine.Activated = function(sender, index)

                        if IsPedSittingInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                            local status = GetIsVehicleEngineRunning(vehicle)

                            if status then
                                SetVehicleEngineOn(vehicle, false, false, true)
                                toggleEngine:RightLabel(Translation[Config.Locale]['engine_off'])
                            else
                                SetVehicleEngineOn(vehicle, true, false, true)
                                toggleEngine:RightLabel(Translation[Config.Locale]['engine_on'])
                            end
                        end


                    end


                end

                if Config.VehiclemenuContent.doorsAndWindows then

                    local doorOptions = {
                        Translation[Config.Locale]['frontleft'], 
                        Translation[Config.Locale]['frontright'], 
                        Translation[Config.Locale]['backleft'], 
                        Translation[Config.Locale]['backright'],
                        Translation[Config.Locale]['trunk'],
                        Translation[Config.Locale]['hood'],
                    }

                    local DoorState = {
                        FrontLeft = false,
                        FrontRight = false,
                        BackLeft = false,
                        BackRight = false,
                        trunk = false,
                        hood = false,
                    }

                    local windowOptions = {
                        Translation[Config.Locale]['frontleft'], 
                        Translation[Config.Locale]['frontright'], 
                        Translation[Config.Locale]['backleft'], 
                        Translation[Config.Locale]['backright'],
                    }

                    local WindowState = {
                        FrontLeft = false,
                        FrontRight = false,
                        BackLeft = false,
                        BackRight = false,
                    }

                    local vehicleDoors = NativeUI.CreateListItem(Translation[Config.Locale]['doors'], doorOptions, 1)
                    vehiclemenuSub.SubMenu:AddItem(vehicleDoors)

                    local toggleWindow = NativeUI.CreateListItem(Translation[Config.Locale]['windows'], windowOptions, 1)
                    vehiclemenuSub.SubMenu:AddItem(toggleWindow)

                    vehiclemenuSub.SubMenu.OnListSelect = function(sender, item, index)
                        if IsPedSittingInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                            if item == vehicleDoors then
                                -- local selectedDoor = item:IndexToItem(index)

                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                                if index == 1 then
                                    
                                    if DoorState.FrontLeft == false then
                                        DoorState.FrontLeft = true
                                        SetVehicleDoorOpen(vehicle, 0, false, false)
                                    else
                                        DoorState.FrontLeft = false
                                        SetVehicleDoorShut(vehicle, 0, false)
                                    end
                                elseif index == 2 then

                                    if DoorState.FrontRight == false then
                                        DoorState.FrontRight = true
                                        SetVehicleDoorOpen(vehicle, 1, false, false)
                                    else
                                        DoorState.FrontRight = false
                                        SetVehicleDoorShut(vehicle, 1, false)
                                    end
                                
                                elseif index == 3 then

                                    if DoorState.BackLeft == false then
                                        DoorState.BackLeft = true
                                        SetVehicleDoorOpen(vehicle, 2, false, false)
                                    else
                                        DoorState.BackLeft = false
                                        SetVehicleDoorShut(vehicle, 2, false)
                                    end
                                
                                elseif index == 4 then

                                    if DoorState.BackRight == false then
                                        DoorState.BackRight = true
                                        SetVehicleDoorOpen(vehicle, 3, false, false)
                                    else
                                        DoorState.BackRight = false
                                        SetVehicleDoorShut(vehicle, 3, false)
                                    end

                                elseif index == 5 then

                                    if DoorState.trunk == false then
                                        DoorState.trunk = true
                                        SetVehicleDoorOpen(vehicle, 5, false, false)
                                    else
                                        DoorState.trunk = false
                                        SetVehicleDoorShut(vehicle, 5, false)
                                    end

                                elseif index == 6 then

                                    if DoorState.hood == false then
                                        DoorState.hood = true
                                        SetVehicleDoorOpen(vehicle, 4, false, false)
                                    else
                                        DoorState.hood = false
                                        SetVehicleDoorShut(vehicle, 4, false)
                                    end

                                end



                            elseif item == toggleWindow then
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        
                                if index == 1 then
                                    if WindowState.FrontLeft == false then
                                        WindowState.FrontLeft = true
                                        RollDownWindow(vehicle, 0)
                                    else
                                        WindowState.FrontLeft = false
                                        RollUpWindow(vehicle, 0)
                                    end
                                    
                                elseif index == 2 then
                                    if WindowState.FrontRight == false then
                                        WindowState.FrontRight = true
                                        RollDownWindow(vehicle, 1)
                                    else
                                        WindowState.FrontRight = false
                                        RollUpWindow(vehicle, 1)
                                    end
        
                                elseif index == 3 then
                                    if WindowState.BackLeft == false then
                                        WindowState.BackLeft = true
                                        RollDownWindow(vehicle, 2)
                                    else
                                        WindowState.BackLeft = false
                                        RollUpWindow(vehicle, 2)
                                    end
        
                                elseif index == 4 then
                                    if WindowState.BackRight == false then
                                        WindowState.BackRight = true
                                        RollDownWindow(vehicle, 3)
                                    else
                                        WindowState.BackRight = false
                                        RollUpWindow(vehicle, 3)
                                    end
                                end
                            end

                        end

                    end

                end

            else
                local vehiclemenuLock = NativeUI.CreateItem(Translation[Config.Locale]['vehiclemenu_locked'], '')
                mainMenu:AddItem(vehiclemenuLock)
                vehiclemenuLock:SetRightBadge(21)
            end
        else
            local vehiclemenuLock = NativeUI.CreateItem(Translation[Config.Locale]['vehiclemenu_locked'], '')
            mainMenu:AddItem(vehiclemenuLock)
            vehiclemenuLock:SetRightBadge(21)
        end

    end


    _menuPool:RefreshIndex()
    mainMenu:Visible(true)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)

end

RegisterNetEvent("primePlayermenu:checkCuff2")
AddEventHandler("primePlayermenu:checkCuff2", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        ESX.TriggerServerCallback("primePlayermenu:isCuffed",function(cuffed)
            if not cuffed then
                ESX.ShowNotification(Translation[Config.Locale]['cuffPlayerNotify'])
            else
                -- TriggerEvent('esx:showNotification', player, 'Dein Ausweis wird sich angeguckt..')
                ESX.ShowNotification(Translation[Config.Locale]['searchIDCardNotify'])
                Citizen.Wait(1000)
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
            end
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'busted', 1.0)
        end,GetPlayerServerId(player))
    else
        ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
    end
end)

RegisterNetEvent("primePlayermenu:checkCuff")
AddEventHandler("primePlayermenu:checkCuff", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        ESX.TriggerServerCallback("primePlayermenu:isCuffed",function(cuffed)
            if not cuffed then
                TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, 4000, 48, 0, 0, 0, 0) 
                TriggerServerEvent("primePlayermenu:handcuff",GetPlayerServerId(player),true)
            else
                TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8, 5000, 49, 0, 0, 0, 0)
                TriggerServerEvent("primePlayermenu:handcuff",GetPlayerServerId(player),false)
            end
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'busted', 1.0)
        end,GetPlayerServerId(player))
    else
        ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
    end
end)

RegisterNetEvent("primePlayermenu:uncuff")
AddEventHandler("primePlayermenu:uncuff",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        TriggerServerEvent("primePlayermenu:uncuff",GetPlayerServerId(player))
    else
        ESX.ShowNotification(Translation[Config.Locale]['noPlayerFound'])
    end
end)

RegisterNetEvent('primePlayermenu:forceUncuff')
AddEventHandler('primePlayermenu:forceUncuff',function()
    IsHandcuffed = false
    local playerPed = GetPlayerPed(-1)
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DisplayRadar(true)
end)

RegisterNetEvent("primePlayermenu:handcuff")
AddEventHandler("primePlayermenu:handcuff",function()
    local playerPed = GetPlayerPed(-1)
    IsHandcuffed = not IsHandcuffed
    Citizen.CreateThread(function()
        if IsHandcuffed then
            ClearPedTasks(playerPed)
            SetPedCanPlayAmbientBaseAnims(playerPed, true)

            Citizen.Wait(10)
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(100)
            end
            RequestAnimDict('mp_arrest_paired')
            while not HasAnimDictLoaded('mp_arrest_paired') do
                Citizen.Wait(100)
            end
			TaskPlayAnim(playerPed, "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
			Citizen.Wait(5000)
            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
        else
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            DisplayRadar(true)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsHandcuffed then
            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
            DisableControlAction(0, 140, true)
        end
        if not IsHandcuffed and not IsControlEnabled(0, 140) then EnableControlAction(0, 140, true) end
    end
end)

Citizen.CreateThread(function()
    local wasgettingup = false
    while true do
        Citizen.Wait(250)
        if IsHandcuffed then
            local ped = GetPlayerPed(-1)
            if not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3) or (wasgettingup and not IsPedGettingUp(ped)) then ESX.Streaming.RequestAnimDict("mp_arresting", function() TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0) end) end
            wasgettingup = IsPedGettingUp(ped)
        end
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end

function reformatInt(i)
	return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function CreateDialog(OnScreenDisplayTitle)
	AddTextEntry(OnScreenDisplayTitle, OnScreenDisplayTitle)
	DisplayOnscreenKeyboard(1, OnScreenDisplayTitle, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end