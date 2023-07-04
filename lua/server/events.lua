
MCD.RegisterEvent('mcd_lib:Server:RemoveMoney' , function(src , param1 , param2 , param3 , param4 , param5)
    local account = MCD.ReadHash(param1)
    local ammount = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    local target = tonumber(MCD.ReadHash(param4))
    if not target then target = src end
    MCD.RemoveMoney(account , ammount , target ,  ressourcename)

    if IsStringCracked(account) or IsStringCracked(MCD.ReadHash(param2))  then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:AddMoney' , function(src , param1 , param2 , param3 , param4 , param5)
    local account = MCD.ReadHash(param1)
    local ammount = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    local target = tonumber(MCD.ReadHash(param4))
    if not target then target = src end
    MCD.AddMoney(account , ammount , target ,  ressourcename)

    if IsStringCracked(account) or IsStringCracked(MCD.ReadHash(param2)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:RemoveLicense' , function(src , param1 , param2 , param3 , param4 , param5)
    local license = MCD.ReadHash(param1)
    local ressourcename = param2
    local target = tonumber(MCD.ReadHash(param3))
    if not target then target = src end
    MCD.RemoveLicense(license , target , ressourcename)
    
    if IsStringCracked(license) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end 
end)

MCD.RegisterEvent('mcd_lib:Server:AddLicense' , function(src , param1 , param2 , param3 , param4 , param5)
    local license = MCD.ReadHash(param1)
    local ressourcename = param2
    local target = tonumber(MCD.ReadHash(param3))
    if not target then target = src end
    MCD.AddLicense(license , target , ressourcename)
    
    if IsStringCracked(license) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)
    
MCD.RegisterEvent('mcd_lib:Server:RemoveItem' , function(src , param1 , param2 , param3 , param4 , param5)
    local item = MCD.ReadHash(param1)
    local count = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    local target = tonumber(MCD.ReadHash(param4))
    if not target then target = src end
    MCD.RemoveItem(item , count , target , ressourcename)
    
    if IsStringCracked(item) or IsStringCracked(MCD.ReadHash(param2)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:AddItem' , function(src , param1 , param2 , param3 , param4)
    local item = MCD.ReadHash(param1)
    local count = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    local target = tonumber(MCD.ReadHash(param4))
    if not target then target = src end
    MCD.AddItem(item , count , target , ressourcename)
    
    if IsStringCracked(item) or IsStringCracked(MCD.ReadHash(param2)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:MutePlayer' , function(src , param1 , param2 , param3 , param4 , param5)
    local toggle = tonumber(MCD.ReadHash(param1)) == 1
    local ressourcename = param2
    local target = tonumber(MCD.ReadHash(param3))
    if not target then target = src end
    MCD.MutePlayer(toggle , target , ressourcename)
    
    if IsStringCracked(MCD.ReadHash(param1)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:RemoveVehicle' , function(src , param1 , param2 , param3 , param4 , param5)
    local plate = MCD.ReadHash(param1)
    local ressourcename = param2
    MCD.RemoveVehicle(plate , ressourcename)
    
    if IsStringCracked(plate) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:SetPlate' , function(src , param1 , param2 , param3 , param4 , param5)
    local vehicle = tonumber(MCD.ReadHash(param1))
    local plate = MCD.ReadHash(param2)
    MCD.SetPlate(vehicle , plate)
    
    if IsStringCracked(plate) or IsStringCracked(MCD.ReadHash(param1)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:AdvancedNotify' , function(src , param1 , param2 , param3 , param4 , param5)
    local data = param1
    MCD.TriggerClientEvent('mcd_lib:Client:AdvancedNotify' , -1 , data)
end)

MCD.RegisterEvent('mcd_lib:Server:AddChecker' , function(src , param1 , param2 , param3 , param4 , param5)
    OldFunction('AddChecker')
    local ressourcename = param1
    local reponame = param2        
    MCD.AddUpdateChecker(reponame , ressourcename)
end)

MCD.RegisterEvent('mcd_lib:Server:SetJob' , function(src , param1 , param2 , param3 , param4 , param5)
    local Job = MCD.ReadHash(param1)
    local Grade = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    MCD.SetJob(Job , Grade , src , ressourcename)
    
    if IsStringCracked(Job) or IsStringCracked(MCD.ReadHash(param2)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

if QBCore then
    QBCore.Functions.CreateCallback(Config.Key , function(src , cb , eventname)
        cb(MCD.Event(eventname))
    end)
else
    ESX.RegisterServerCallback(Config.Key , function(src , cb , eventname)
        cb(MCD.Event(eventname))
    end)
end

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetPlayerData') , function(src , cb)
    local _ = src
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_)
    else
        xPlayer = ESX.GetPlayerFromId(_)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_)
        else
            xPlayer = ESX.GetPlayerFromId(_)
        end
        Citizen.Wait(5)
    end
    local group
    if QBCore then
        group = xPlayer.Functions.GetPermission()
    else
        group = xPlayer.getGroup()
    end
    local data = {
        group       = group,
        money       = MCD.GetMoney(_),
        job         = MCD.GetJob(_),
        inventory   = MCD.GetInventory(_),
        loadout     = MCD.GetLoadout(_),
    }
    cb(data)
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetOwnedVehicles') , function(src , cb)
    cb(MCD.GetOwnedVehicles(src))
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetLicenses') , function(src , cb)
    cb(MCD.GetLicenses(src))
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrices') , function(src , cb)
    cb(MCD.GetVehiclePrices())
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrice') , function(src , cb , model)
    cb(MCD.GetVehiclePrice(model))
end)
    
MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetCurrentTime') , function(src , cb)
    cb(MCD.GetCurrentTime())
end)
  
MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetRPName') , function(src , cb , param1)
    local target = param1
    if not target then
        target = src
    end
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(target)
    else
        xPlayer = ESX.GetPlayerFromId(target)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(target)
        else
            xPlayer = ESX.GetPlayerFromId(target)
        end
        Citizen.Wait(5)
    end
    local name
    if QBCore then
        name = xPlayer.PlayerData.firstname .. ' ' .. xPlayer.PlayerData.lastname  
    else
        name = xPlayer.getName()
    end
    cb(name)
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:AmIMuted') , function(src , cb)
    cb(MCD.IsMuted(src))
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetSteamData') , function(src , cb)
    cb(MCD.SteamData(src))
end)
    
MCD.RegisterEvent('mcd_lib:Server:SetMoney' , function(src , param1 , param2 , param3 , param4 , param5)
    local account = MCD.ReadHash(param1)
    local ammount = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    local target = tonumber(MCD.ReadHash(param4))
    if not target then target = src end
    MCD.SetMoney(account , ammount , target ,  ressourcename)
    
    if IsStringCracked(account) or IsStringCracked(MCD.ReadHash(param2)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:CanCarryOld') , function(src , cb , item , count)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(src)
    else
        xPlayer = ESX.GetPlayerFromId(src)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(src)
        else
            xPlayer = ESX.GetPlayerFromId(src)
        end
        Citizen.Wait(5)
    end
    if QBCore then
        cb(true) 
    else
        cb(xPlayer.canCarryItem(item, count))
    end
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:CanCarry') , function(src , cb , items)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(src)
    else
        xPlayer = ESX.GetPlayerFromId(src)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(src)
        else
            xPlayer = ESX.GetPlayerFromId(src)
        end
        Citizen.Wait(5)
    end
    local cancarry = true
    for i,p in ipairs(items) do
        if not QBCore then
            if not xPlayer.canCarryItem(p.item, p.count) then
                cancarry = false
            end
        end
    end
    cb(cancarry)
end)

MCD.RegisterEvent('mcd_lib:Server:Connected' , function(src)
    local playername = GetPlayerName(src)
    if connects[playername] ~= nil then
        local seconds = math.floor(MCD.Math.TimeDifference(connects[playername] , MCD.GetCurrentTime()))
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ Connected | Took ~y~'..seconds..'seconds' , true))
    else
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ Connected' , true))
    end 
end)

MCD.RegisterEvent('mcd_lib:Server:RemoveWeapon' , function(src , param1 , param2 , param3 , param4 , param5)
    local weapon = MCD.ReadHash(param1)
    local ressourcename = param2
    local target = tonumber(MCD.ReadHash(param3))
    if not target then target = src end
    MCD.RemoveWeapon(weapon ,target, ressourcename)
    
    if IsStringCracked(weapon) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterEvent('mcd_lib:Server:AddWeapon' , function(src , param1 , param2 , param3 , param4 , param5)
    local weapon = MCD.ReadHash(param1)
    local ammo = tonumber(MCD.ReadHash(param2))
    local ressourcename = param3
    local target = tonumber(MCD.ReadHash(param4))
    if not target then target = src end
    MCD.AddWeapon(weapon , ammo , target , ressourcename)
    
    if IsStringCracked(weapon) or IsStringCracked(MCD.ReadHash(param2)) then
        MCD.BanPlayer(src , _U('triggerserverevent_ban') , 0)
    end
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetPrice') , function(src , cb , name , res)
    cb(MCD.GetPrice(name , res))
end)

MCD.RegisterEvent('mcd_lib:Server:SingleDimension' , function(src , param1 , param2 , param3 , param4 , param5)
    MCD.SingleDimension(src)
end)

MCD.RegisterEvent('mcd_lib:Server:NormalDimension' , function(src , param1 , param2 , param3 , param4 , param5)
    MCD.NormalDimension(src)
end)

MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:IsPlateTaken') , function(src , cb , plate)
    cb(MCD.IsPlateTaken(plate))
end)