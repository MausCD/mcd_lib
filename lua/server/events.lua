Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveMoney'), function(param1 , param2 , param3 , param4 , param5)
        local account = param1
        local ammount = param2
        local ressourcename = param3
        local target = param4
        if not target then target = source end
        MCD.RemoveMoney(account , ammount , target ,  ressourcename)
    end)

    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddMoney'), function(param1 , param2 , param3 , param4 , param5)
        local account = param1
        local ammount = param2
        local ressourcename = param3
        local target = param4
        if not target then target = source end
        MCD.AddMoney(account , ammount , target ,  ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveLicense'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveLicense'), function(param1 , param2 , param3 , param4 , param5)
        local license = param1
        local ressourcename = param2
        local target = param3
        if not target then target = source end
        MCD.RemoveLicense(license , target , ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddLicense'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddLicense'), function(param1 , param2 , param3 , param4 , param5)
        local license = param1
        local ressourcename = param2
        local target = param3
        if not target then target = source end
        MCD.AddLicense(license , target , ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveItem'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveItem'), function(param1 , param2 , param3 , param4 , param5)
        local item = param1
        local count = param2
        local ressourcename = param3
        local target = param4
        if not target then target = source end
        MCD.RemoveItem(item , count , target , ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddItem'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddItem'), function(param1 , param2 , param3 , param4 , param5)
        local item = param1
        local count = param2
        local ressourcename = param3
        local target = param4
        if not target then target = source end
        MCD.AddItem(item , count , target , ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:MutePlayer'))
    AddEventHandler(MCD.Event('mcd_lib:Server:MutePlayer'), function(param1 , param2 , param3 , param4 , param5)
        local toggle = param1
        local ressourcename = param2
        local target = param3
        if not target then target = source end
        MCD.MutePlayer(toggle , target , ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveVehicle'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveVehicle'), function(param1 , param2 , param3 , param4 , param5)
        local plate = param1
        local ressourcename = param2
        MCD.RemoveVehicle(plate , ressourcename)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetPlate'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetPlate'), function(param1 , param2 , param3 , param4 , param5)
        local vehicle = param1
        local plate = param2
        MCD.SetPlate(vehicle , plate)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AdvancedNotify'), function(param1 , param2 , param3 , param4 , param5)
        local data = param1
        TriggerClientEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'), -1 , data)
    end)

    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddChecker'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddChecker'), function(param1 , param2 , param3 , param4 , param5)
        OldFunction('AddChecker')
        local ressourcename = param1
        local reponame = param2        
        MCD.AddUpdateChecker(reponame , ressourcename)
    end)

    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetJob'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetJob'), function(param1 , param2 , param3 , param4 , param5)
        local Job = param1
        local Grade = param2
        local ressourcename = param3
        local target = param4
        if not target then target = source end
        MCD.SetJob(Job , Grade , target , ressourcename)
    end)

    ESX.RegisterServerCallback(Config.Key, function(src, cb , param1 , param2 , param3 , param4 , param5)
        local eventname = param1
        cb(MCD.Event(eventname))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetPlayerData'), function(source , cb, param1 , param2 , param3 , param4 , param5)
        local _ = source
        local xPlayer = ESX.GetPlayerFromId(_)
        while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_) Citizen.Wait(5) end
        local data = {
            group = xPlayer.getGroup(),
            money = MCD.GetMoney(_),
            job = MCD.GetJob(_),
        }
        cb(data)
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetOwnedVehicles'), function(source , cb, param1 , param2 , param3 , param4 , param5)
        local _ = source
        cb(MCD.GetOwnedVehicles(_))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetLicenses'), function(source , cb, param1 , param2 , param3 , param4 , param5)
        local _ = source
        cb(MCD.GetLicenses(_))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrices'), function(src , cb, param1 , param2 , param3 , param4 , param5)
        cb(MCD.GetVehiclePrices())
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrice'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local model = param1
        cb(MCD.GetVehiclePrice(model))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetCurrentTime'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        cb(MCD.GetCurrentTime())
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetRPName'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local target = param1
        if not target then
            target = src
        end
        local xPlayer = ESX.GetPlayerFromId(target)
        while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
        cb(xPlayer.getName())
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:AmIMuted'), function(src , cb, param1 , param2 , param3 , param4 , param5)
        cb(MCD.IsMuted(src))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:ItemName'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local item = param1
        cb(MCD.ItemName(item))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetSteamData'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        cb(MCD.SteamData(src))
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:BanPlayer'))
    AddEventHandler(MCD.Event('mcd_lib:Server:BanPlayer'), function(param1 , param2 , param3 , param4 , param5)
        local target = param1
        local Reason = param2
        local Duration = param3
        if not target then target = source end
        MCD.BanPlayer(target , Reason , Duration)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetMoney'), function(param1 , param2 , param3 , param4 , param5)
        local account = param1
        local ammount = param2
        local ressourcename = param3
        local target = param4
        if not target then target = source end
        MCD.SetMoney(account , ammount , target ,  ressourcename)
    end)

    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:CanCarryOld'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local item = param1
        local count = param2
        local xPlayer = ESX.GetPlayerFromId(src)
        cb(xPlayer.canCarryItem(item, count))
    end)

    RegisterNetEvent(MCD.Event('mcd_lib:Server:Kick'))
    AddEventHandler(MCD.Event('mcd_lib:Server:Kick'), function(param1 , param2 , param3 , param4 , param5)
        local target = param1
        local reason = param2
        if not target then target = source end
        MCD.Kick(target , reason)
    end)

    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:HasWeapon'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local weapons = param1
        cb(MCD.HasWeapon(src , weapons))
    end)
    
    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:LiceneName'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local license = param1
        cb(MCD.LiceneName(license))
    end)

    ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:CanCarry'), function(src , cb , param1 , param2 , param3 , param4 , param5)
        local items = param1
        local xPlayer = ESX.GetPlayerFromId(src)
        local cancarry = true
        for i,p in ipairs(items) do
            if not xPlayer.canCarryItem(p.item, p.count) then
                cancarry = false
            end
        end
        cb(cancarry)
    end)

    RegisterNetEvent(MCD.Event('mcd_lib:Server:Connected'))
    AddEventHandler(MCD.Event('mcd_lib:Server:Connected'), function()
        local playername = GetPlayerName(source)
        if connects[playername] ~= nil then
            local seconds = math.floor(MCD.Math.TimeDifference(connects[playername] , MCD.GetCurrentTime()))
            print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ Connected | Took ~y~'..seconds..'seconds' , true))
        else
            print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ Connected' , true))
        end        
    end)
end)