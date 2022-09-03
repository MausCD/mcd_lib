Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveMoney'), function(hjklb , skljdvbgjkl , jkldfhvbjkd , hjbasdfhjb , jhbdfhjbdsj ,djasfh , awf,asfaw,sdgfhu,jawsghdvf)
        local account = hjklb
        local ammount = skljdvbgjkl
        local ressourcename = jkldfhvbjkd
        MCD.RemoveMoney(account , ammount , source ,  ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddMoney'), function(sdfhjsdsdsdg , kjhdxfgv , jkhsxgdfv , kaugvfw, awkujghvfkau , awgvfzwa , jhawgvfj , asevfzj , jawedfuz)
        local account = sdfhjsdsdsdg
        local ammount = kjhdxfgv
        local ressourcename = jkhsxgdfv
        MCD.AddMoney(account , ammount , source ,  ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveLicense'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveLicense'), function(asdfsdg , jkbdhjklbsdg , fakuhgevf , fawuizgfua , aukfgvwaukh , fauwzgaukjw , fawuhzfgbaujw)
        local license = asdfsdg
        local ressourcename = jkbdhjklbsdg
        MCD.RemoveLicense(license , source , ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddLicense'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddLicense'), function(dhjkbesdgf , lkdhrfgb , awkjfhgvawkhujf , fauwhgfv , fwafghv , wajhfgb)
        local license = dhjkbesdgf
        local ressourcename = lkdhrfgb
        MCD.AddLicense(license , source , ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveItem'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveItem'), function(lskhgv , ivcfabn , hasf, ahgfvw , awhfg ,ahwgdvf  ,aghfv , hasdgfv ,awjdgvf)
        local item = lskhgv
        local count = ivcfabn
        local ressourcename = hasf
        MCD.RemoveItem(item , count , source , ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddItem'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddItem'), function(klhjsgvf , lkhsjdgbf , shjkfvb , ahfjgwev , awjfhgv , wakjhfgv , fahkwgfv)
        local item = klhjsgvf
        local count = lkhsjdgbf
        local ressourcename = shjkfvb
        MCD.AddItem(item , count , source , ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:MutePlayer'))
    AddEventHandler(MCD.Event('mcd_lib:Server:MutePlayer'), function(jklhsydfb , hjkvb , ajwkfgv , wfahgfv , wafafw , awdgfc , awffhga)
        local toggle = jklhsydfb
        local ressourcename = hjkvb
        MCD.MutePlayer(toggle , source , ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveVehicle'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveVehicle'), function(lkshdgvf , gnadcf , awhjgfv , awhgdf ,ahjksdft , hveahg, gwagh)
        local plate = lkshdgvf
        local ressourcename = gnadcf
        MCD.RemoveVehicle(plate , ressourcename)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetPlate'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetPlate'), function(skhjgv , jaskhfv , awjfg , wahgfv , wajgf , wajhgf , awjgf)
        local vehicle = skhjgv
        local plate = jaskhfv
        MCD.SetPlate(vehicle , plate)
    end)
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AdvancedNotify'), function(nbfhfhf , jhvfrsd , vfsdhjb , fakjehzgf)
        local data = vfsdhjb
        TriggerClientEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'), -1 , nil , nil ,nil , data)
    end)
end)

RegisterNetEvent('mcd_lib:fuzdvgsgzhufdghuiz')
AddEventHandler('mcd_lib:fuzdvgsgzhufdghuiz', function(jhsd  , gfers , gr , rdg , grdg ,af)
    local ressourcename = jhsd
    local reponame = gfers
    
    Citizen.Wait(20*1000)
    table.insert(checker , {repo = reponame , ressourcename = ressourcename})
    if not Config.DebugMode then
        VersionState(ressourcename , reponame , true)
    end
end)

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetJob'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetJob'), function(ksjhgbf , sjlhfgvb , jhagsdvc , afhjwgv , wahgfv , wajfkg , afhwjgv , wajgf)
        local Job = ksjhgbf
        local Grade = sjlhfgvb
        local ressourcename = jhagsdvc
        MCD.SetJob(Job , Grade , source , ressourcename)
    end)
end)




ESX.RegisterServerCallback(Config.Key, function(src, cb , eventname)
    cb(MCD.Event(eventname))
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetPlayerData'), function(source , cb)
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

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetOwnedVehicles'), function(source , cb)
    local _ = source
    cb(MCD.GetOwnedVehicles(_))
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetLicenses'), function(source , cb)
    local _ = source
    cb(MCD.GetLicenses(_))
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrices'), function(src , cb)
    cb(MCD.GetVehiclePrices())
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrice'), function(src , cb , model)
    cb(MCD.GetVehiclePrice(model))
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetCurrentTime'), function(src , cb)
    cb(MCD.GetCurrentTime())
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetRPName'), function(src , cb , target)
    if not target then
        target = src
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    cb(xPlayer.getName())
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:AmIMuted'), function(src , cb)
    cb(MCD.IsMuted(src))
end)

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:ItemName'), function(src , cb , item)
    cb(MCD.ItemName(item))
end)