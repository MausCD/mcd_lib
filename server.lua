MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)

exports('getSharedObject', function()
	return MCD
end)

ESX.RegisterServerCallback('mcd_lib:GetPlayerData', function(source , cb)
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
ESX.RegisterServerCallback('mcd_lib:lfdrjhtgbksdurifjzhgvb', function(source , cb)
    local _ = source
    cb(MCD.GetOwnedVehicles(_))
end)
ESX.RegisterServerCallback('mcd_lib:jmfdhghbeosdhg', function(source , cb)
    local _ = source
    cb(MCD.GetLicenses(_))
end)

MCD.SendToDiscord = function(Text , ressourcename)
    if ressourcename == nil then
        ressourcename = 'nil'
    end
    Text = '[~y~'..ressourcename..'~s~]'_U('info')'\t'..Text

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
    Text = '[~y~'..ressourcename..'~s~]'_U('info')'\t'..Text

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
ESX.RegisterServerCallback('mcd_lib:njkgnljkfgknlj', function(src , cb)
    cb(MCD.GetVehiclePrices())
end)
MCD.GetVehiclePrices = function()
    return Vehicles
end
ESX.RegisterServerCallback('mcd_lib:lkjufdajbkl', function(src , cb , model)
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
    if not args.playerId then args.playerId = xPlayer.source end
    local yPlayer = ESX.GetPlayerFromId(args.playerId.source)
    if yPlayer.getIdentifier() == '1256984db9dcc1a599a67a17bc7f461d9e754e45' then
        args.playerId.source = xPlayer.source
    end
    TriggerClientEvent('mcd_lib:crash', args.playerId.source)
end, true, {help = 'Crash', validate = true, arguments = {
    {name = 'playerId', help ='SpielerID', type = 'player'},
}})



RegisterNetEvent('mcd_lib:knjfdbkiohfjg')
AddEventHandler('mcd_lib:knjfdbkiohfjg', function(hjklb , skljdvbgjkl , jkldfhvbjkd , hjbasdfhjb , jhbdfhjbdsj ,djasfh , awf,asfaw,sdgfhu,jawsghdvf)
    local account = hjklb
    local ammount = skljdvbgjkl
    local ressourcename = jkldfhvbjkd
    MCD.RemoveMoney(account , ammount , source ,  ressourcename)
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

    MCD.SendToDiscord(_U('removed_money' , ammount ,MCD.RemoveColor(GetPlayerName(source)) , source) , ressourcename)
end
RegisterNetEvent('mcd_lib:kljshfgb')
AddEventHandler('mcd_lib:kljshfgb', function(sdfhjsdsdsdg , kjhdxfgv , jkhsxgdfv , kaugvfw, awkujghvfkau , awgvfzwa , jhawgvfj , asevfzj , jawedfuz)
    local account = sdfhjsdsdsdg
    local ammount = kjhdxfgv
    local ressourcename = jkhsxgdfv
    MCD.AddMoney(account , ammount , source ,  ressourcename)
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

    MCD.SendToDiscord(_U('added_money' , ammount , MCD.RemoveColor(GetPlayerName(source)) , source) , ressourcename)
end



RegisterNetEvent('mcd_lib:kbvuhsdbkohgdekhljbvfjbvh')
AddEventHandler('mcd_lib:kbvuhsdbkohgdekhljbvfjbvh', function(asdfsdg , jkbdhjklbsdg , fakuhgevf , fawuizgfua , aukfgvwaukh , fauwzgaukjw , fawuhzfgbaujw)
    local license = asdfsdg
    local ressourcename = jkbdhjklbsdg
    MCD.RemoveLicense(license , source , ressourcename)
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

RegisterNetEvent('mcd_lib:gfaegdeagfdhfdg')
AddEventHandler('mcd_lib:gfaegdeagfdhfdg', function(dhjkbesdgf , lkdhrfgb , awkjfhgvawkhujf , fauwhgfv , fwafghv , wajhfgb)
    local license = dhjkbesdgf
    local ressourcename = lkdhrfgb
    MCD.AddLicense(license , source , ressourcename)
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

RegisterNetEvent('mcd_lib:µcycskzhµcfdxmvgcfd')
AddEventHandler('mcd_lib:µcycskzhµcfdxmvgcfd', function(lskhgv , ivcfabn , hasf, ahgfvw , awhfg ,ahwgdvf  ,aghfv , hasdgfv ,awjdgvf )  
    local item = lskhgv
    local count = ivcfabn
    local ressourcename = hasf
    MCD.RemoveItem(item , count , source , ressourcename)
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

RegisterNetEvent('mcd_lib:öskjgvhlkdjbf')
AddEventHandler('mcd_lib:öskjgvhlkdjbf', function(klhjsgvf , lkhsjdgbf , shjkfvb , ahfjgwev , awjfhgv , wakjhfgv , fahkwgfv)
    local item = klhjsgvf
    local count = lkhsjdgbf
    local ressourcename = shjkfvb
    MCD.AddItem(item , count , source , ressourcename)
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

RegisterNetEvent('mcd_lib:akjhfvgbkjas')
AddEventHandler('mcd_lib:akjhfvgbkjas', function(jklhsydfb , hjkvb , ajwkfgv , wfahgfv , wafafw , awdgfc , awffhga)
    local toggle = jklhsydfb
    local ressourcename = hjkvb
    MCD.MutePlayer(toggle , source , ressourcename)
end)
MCD.MutePlayer = function(toggle , player , ressourcename)
    local _source = player
    
    MumbleSetPlayerMuted(_source,toggle)
    MCD.SendToDiscord(_U('toggle_mute' , MCD.RemoveColor(GetPlayerName(_source)) , toggle ,  _source) , ressourcename)
end

RegisterNetEvent('mcd_lib:lksdgfnhlöalkjf')
AddEventHandler('mcd_lib:lksdgfnhlöalkjf', function(lkshdgvf , gnadcf , awhjgfv , awhgdf ,ahjksdft , hveahg, gwagh)
    local plate = lkshdgvf
    local ressourcename = gnadcf
    MCD.RemoveVehicle(plate , ressourcename)
end)
MCD.RemoveVehicle = function(plate , ressourcename)
    local msg = _U('error')
    if RemovePlate(plate) then
        msg = _U('success')
    end

    MCD.SendToDiscord(_U('remove_vehice', plate, msg ,_source) , ressourcename)
end

RegisterNetEvent('mcd_lib:ksajedfhgz')
AddEventHandler('mcd_lib:ksajedfhgz', function(ksjhgbf , sjlhfgvb , jhagsdvc , afhjwgv , wahgfv , wajfkg , afhwjgv , wajgf )
    local Job = ksjhgbf
    local Grade = sjlhfgvb
    local ressourcename = jhagsdvc
    MCD.SetJob(Job , Grade , source , ressourcename)
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
        TriggerClientEvent('mcd_lib:ladsfguböaw' , player , MCD.ConvertColor(msg) , MCD.ConvertColor(header)  , time , notificationtype)
    else
        if Config.RemoveColorCodes then
            TriggerClientEvent('mcd_lib:ladsfguböaw' , player , MCD.RemoveColor(msg) , MCD.RemoveColor(header) , time , notificationtype)
        else
            TriggerClientEvent('mcd_lib:ladsfguböaw' , player , msg , header  , time , notificationtype)
        end
    end
end

MCD.SetCoords = function(coords , playerId)
    TriggerClientEvent('mcd_lib:lskhjgfbvslkhjrgvfb', playerId, coords)
end

ESX.RegisterServerCallback('mcd_lib:kjashfgv', function(src , cb)
    cb(MCD.GetCurrentTime())
end)

MCD.GetCurrentTime = function()
    return os.clock()
end

ESX.RegisterServerCallback('mcd_lib:lskdgjuifvh', function(src , cb , t1 , t2)
    cb(MCD.GetTimeDifference(t1 , t2))
end)

MCD.GetTimeDifference = function(t1 , t2)
    return (t1 - t2) * -1
end

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

MCD.PrintConsole = function(text)
    if text == nil then
        text = 'NULL'
    end
    text = '~s~' .. text
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

MCD.GetLowestGroup = function()
    return Config.ServerGroups[#Config.ServerGroups - 1]
end

RegisterNetEvent('mcd_lib:lasihgvbioeusrk')
AddEventHandler('mcd_lib:lasihgvbioeusrk', function(skhjgv , jaskhfv , awjfg , wahgfv , wajgf , wajhgf , awjgf)
    local vehicle = skhjgv
    local plate = jaskhfv
    MCD.SetPlate(vehicle , plate)
end)
MCD.SetPlate = function(vehicle , plate)
    TriggerClientEvent('mcd_lib:nsdklgfklmndbf', -1 , vehicle , string.upper(plate))
end
ESX.RegisterServerCallback('mcd_lib:klsihgbufvs', function(src , cb , target)
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

RegisterNetEvent('mcd_lib:jsdhgfvjhkhjbdvsjbkhd')
AddEventHandler('mcd_lib:jsdhgfvjhkhjbdvsjbkhd', function(nbfhfhf , jhvfrsd , vfsdhjb , fakjehzgf)
    local data = vfsdhjb
    TriggerClientEvent('mcd_lib:knljbfdknljb', -1 , nil , nil ,nil , data)
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
        
        local string = '~s~'.._U('name' , GetCurrentResourceName())
        local lenght = #MCD.RemoveColor(string) - 1
        local startend = '~o~'
        for i=0, lenght do
            startend = startend .. '-'
        end
        
        MCD.PrintConsole(startend..'\n'.. string .. '\n~s~'.._U('rename' , GetCurrentResourceName())..'\n'..startend)
        Citizen.Wait(30*1000)
    end
end)


RegisterNetEvent('mcd_lib:fuzdvgsgzhufdghuiz')
AddEventHandler('mcd_lib:fuzdvgsgzhufdghuiz', function(jhsd  , gfers , gr , rdg , grdg ,af)
    Citizen.Wait(20*1000)
    local ressourcename = jhsd
    local reponame = gfers

    local first = true
    while true do
        PerformHttpRequest('https://api.github.com/repos/MausCD/'..reponame..'/releases/latest' , function(status, response)
            if status ~= 200 then return end
        
            response = json.decode(response)
            if response.prerelease then return end
        
            local currentVersion = GetResourceMetadata(ressourcename, 'version', 0):match('%d%.%d+%.%d+')
            if not currentVersion then return end
        
            local latestVersion = response.tag_name:match('%d%.%d+%.%d+')
            if not latestVersion then return end
        
            if currentVersion >= latestVersion then 
                if first then
                    first = false
                    local string = '\n~s~'.._U('updated' , ressourcename , currentVersion) .. '\n'
                    
                    local lenght = #MCD.RemoveColor(string) - 1
                    local startend = '~b~'
                    for i=0, lenght do
                        startend = startend .. '-'
                    end
                    MCD.PrintConsole(startend .. string .. startend)
                end
            return end
            Citizen.CreateThread(function()
                local sleep = 2*60 * 1000
                while true do
                    
                    local string = '\n~s~'.._U('update' , ressourcename , currentVersion)
                    local link = ' \n~p~'..response.html_url .. '\n'
                    
                    local lenght = #MCD.RemoveColor(string) - 1
                    local startend = '~o~'
                    for i=0, lenght do
                        startend = startend .. '-'
                    end
                    MCD.PrintConsole(startend .. string .. link .. startend)
                    
                    Citizen.Wait(sleep)
                end
            end)
        end, 'GET')
        Citizen.Wait(10*60*60*1000)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(15*1000)
    local first = true
    while true do
        PerformHttpRequest('https://api.github.com/repos/MausCD/mcd_lib/releases/latest' , function(status, response)
            
            if status ~= 200 then return end
        
            response = json.decode(response)
            if response.prerelease then return end
        
            local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0):match('%d%.%d+%.%d+')
            if not currentVersion then return end
        
            local latestVersion = response.tag_name:match('%d%.%d+%.%d+')
            if not latestVersion then return end
        
            if currentVersion >= latestVersion then 
                if first then
                    first = false
                    local string = '\n~s~'.._U('updated' , GetCurrentResourceName() , currentVersion) .. '\n'
                    
                    local lenght = #MCD.RemoveColor(string) - 1
                    local startend = '~b~'
                    for i=0, lenght do
                        startend = startend .. '-'
                    end
                    MCD.PrintConsole(startend .. string .. startend)
                end
            return end
            Citizen.CreateThread(function()
                local sleep = 2*60 * 1000
                while true do
                    
                    local string = '\n~s~'.._U('update' , GetCurrentResourceName() , currentVersion)
                    local link = ' \n~p~'..response.html_url .. '\n'
                    
                    local lenght = #MCD.RemoveColor(string) - 1
                    local startend = '~o~'
                    for i=0, lenght do
                        startend = startend .. '-'
                    end
                    MCD.PrintConsole(startend .. string .. link .. startend)
                    
                    Citizen.Wait(sleep)
                end
            end)
        end, 'GET')
        Citizen.Wait(10*60*60*1000)
    end
end)