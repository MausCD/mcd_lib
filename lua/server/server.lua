
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
        print(MCD.Function.ConvertPrint(Text , true))
    end
    Text = MCD.Function.RemoveColors(Text)

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
local key = Config.Key
function newkey()
    if not Config.Key then
        Config.Key =  'MCD_Loves_U:ashgdfiawmnbjn124bnkfilajn3jJHnfvlkasefLHFhJsoikgfhJfbnAJFbfasdkjgf3786SGFVJKH'
        key = Config.Key
    end
    local path = GetResourcePath(GetCurrentResourceName())..'/config.lua'
    local file,err = io.open(path,'r+')
    MCD.SendToDiscord('New Key requested' , GetCurrentResourceName() , 'default')
    if file then
        local generatedkey = EventString(Config.EntcrypedEventLenght)
        local text = file:read('*a')
        if not string.find(text , key ,1, true) then
            text = text .. "\n\nConfig.Key = '" .. generatedkey .. "'"
        else
            text = text:gsub('%'..key , generatedkey)
        end
        key = generatedkey
        file:close()
        local file2,err2 = io.open(path,'w+')
        file2:write(text)
        file2:close()
    else print("error:", err) end
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    newkey()
end)

function OldFunction(OldFunction)
    if Config.UpdateMsg then
        print(MCD.Function.ConvertPrint('~s~[~y~mcd_lib~s~]~o~A File Uses an Outdated function (~y~'..OldFunction..'()~o~) please Update your Scripts~s~' , false))
    end
end

MCD.GetTimeDifference = function(t1 , t2)
    OldFunction('GetTimeDifference')
    return MCD.Math.TimeDifference(t1 , t2)
end

MCD.RemoveColor = function(text)
    OldFunction('RemoveColor')
    return MCD.Function.RemoveColors(text)
end

MCD.ConvertColor = function(text)
    OldFunction('ConvertColor')
    return MCD.Function.ConvertColor(text)
end

MCD.PrintConsole = function(text , date)
    OldFunction('PrintConsole')
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
            print(MCD.Function.ConvertPrint('[~y~'..GetCurrentResourceName()..'~s~][~c~DEBUG~s~]\t Entcryped Event (~p~"'..eventname..'"~s~) (~c~'..events[eventname]..'~s~)' , true))
        end
        return events[eventname]
    end
end

MCD.STDiscord = function(Text , DiscordWebHook , color , Name, avatar, ressourcename)
    if DiscordWebHook == '' then DiscordWebHook = Config.WebHook['default'].DiscordWebHook end

    if Config.PrintDiscord then
        print(MCD.Function.ConvertPrint(Text , true))
    end
    Text = MCD.Function.RemoveColors(Text)
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
                MCD.Notify(xPlayer.source , _U('crashsuccess' , MCD.Function.RemoveColors(GetPlayerName(yPlayer.source))) , nil , nil , 'success')
                TriggerClientEvent(MCD.Event('mcd_lib:Client:crash'), args.playerId.source)
            else
                MCD.Notify(xPlayer.source , 'Maus gehts dir gut? Ich hoffe das wahr versehentlich' , nil , nil , 'error')
            end
        else
            MCD.Notify(xPlayer.source , _U('no_perm') , nil , nil , 'error')
        end
    else
        print(MCD.Function.ConvertPrint(_U('not_console' , GetCurrentResourceName()) , true))
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
    ammount = tonumber(ammount)
    
    if not account then
        account = 'money'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remmoney' , ressourcename) , true))
    end
    if not ammount then
        ammount = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remmoney2' , ressourcename) , true))
    end
    
    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.removeAccountMoney(account, tonumber(ammount))

    if ammount > 0 then
        lastmoney = MCD.GetCurrentTime()
        moneymsg = moneymsg .. '\n' .. _U('Webhook_money_remove' , ammount , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
    end
end

MCD.AddMoney = function(account , ammount , player ,  ressourcename)
    local _source = player
    ammount = tonumber(ammount)

    if not account then
        account = 'money'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addmoney' , ressourcename) , true))
    end
    if not ammount then
        ammount = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addmoney2' , ressourcename) , true))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.addAccountMoney(account, tonumber(ammount))

    if ammount > 0 then
        lastmoney = MCD.GetCurrentTime()
        moneymsg = moneymsg .. '\n' .. _U('Webhook_money_add' , ammount , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
    end
end

MCD.RemoveLicense = function(license , player , ressourcename)
    local _source = player
    
    if not license then
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remlicense' , ressourcename) , true))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    MySQL.Async.execute('DELETE FROM user_licenses  WHERE type = @type and owner = @owner', {
        ['@type'] = license,
        ['@owner'] = xPlayer.identifier,
    })
    
    lastlicense = MCD.GetCurrentTime()
    licensemsg = licensemsg .. '\n' .. _U('Webhook_license_remove' , license , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
end

MCD.AddLicense = function(license , player , ressourcename)
    local _source = player

    if not license then
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addlicense' , ressourcename) , true))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    MySQL.Async.insert('INSERT INTO `user_licenses`(`type`, `owner`) VALUES (@type,@owner)', {
        ['@type'] = license,
        ['@owner'] = xPlayer.identifier,
    }, function(result)end)

    lastlicense = MCD.GetCurrentTime()
    licensemsg = licensemsg .. '\n' .. _U('Webhook_license_add' , license , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
end

MCD.RemoveItem = function(item , count , player , ressourcename)
    local _source = player
    count = tonumber(count)

    if not item then
        item = 'bread'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remitem' , ressourcename) , true))
    end
    if not count then
        count = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remitem2' , ressourcename) , true))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.removeInventoryItem(item, count)

    if count > 0 then
        lastitem = MCD.GetCurrentTime()
        itemmsg = itemmsg .. '\n' .. _U('Webhook_money_remove' , count , item , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
    end 
end

MCD.AddItem = function(item , count , player , ressourcename)
    local _source = player
    count = tonumber(count)

    if not item then
        item = 'bread'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_additem' , ressourcename) , true))
    end
    if not count then
        count = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_additem2' , ressourcename) , true))
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.addInventoryItem(item, count)

    if count > 0 then
        lastitem = MCD.GetCurrentTime()
        itemmsg = itemmsg .. '\n' .. _U('Webhook_item_add' , count , item , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
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
    mutemsg = mutemsg .. '\n'.. m .. _U('Webhook_mute' , MCD.Function.RemoveColors(GetPlayerName(_source)) , toggle , ressourcename)
end

MCD.RemoveVehicle = function(plate , ressourcename)
    local msg = _U('error')
    local r = false
    if RemovePlate(plate) then
        r = true
        msg = _U('success')
    end

    MCD.SendToDiscord(_U('remove_vehice', plate, msg ,_source) , ressourcename , 'default')
    return r
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
            TriggerClientEvent(MCD.Event('mcd_lib:Client:Notify') , player , MCD.Function.RemoveColors(msg) , MCD.Function.RemoveColors(header) , time , notificationtype)
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
    TriggerClientEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'), -1 , nil , nil ,nil , data)
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
    TriggerClientEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'), -1 , nil , nil ,nil , data)
end

Citizen.CreateThread(function()
    Citizen.Wait(10*1000)
    while string.upper(GetCurrentResourceName()) ~= string.upper('mcd_lib') do 
        
        local string = '~s~['..os.date('%X')..']'.._U('name' , GetCurrentResourceName())
        local lenght = #MCD.Function.RemoveColors(string) - 1
        local startend = '~o~'
        for i=0, lenght do
            startend = startend .. '-'
        end
        
        print(MCD.Function.ConvertPrint(startend..'\n'.. string .. '\n~s~'.._U('rename' , GetCurrentResourceName())..'\n'..startend , false))
        Citizen.Wait(30*1000)
    end
end)
--------------------------------------------------------------------------------------------------------
function GetScriptData(script)
    local ret
    PerformHttpRequest('https://versions.mauscd.de/main.php' , function(status , version)
        if status == 200 then
            ret = json.decode(version)
        else
            print(MCD.Function.ConvertPrint('[~o~ERROR~s~] Version coudnt be Checked (~r~Url not reachable~s~)'))
            ret = false
        end
    end, 'GET' , json.encode({script = script}))
    while ret == nil do Citizen.Wait(10) end
    return ret
end

local versions = {
    ['mcd_lib'] = GetResourceMetadata(GetCurrentResourceName(), 'version', 0):match('%d%.%d+%.%d+'),
}

local checker = {}
local check = {}

function CompareVersion(current , latest)
    local cmajor, cminor, cpatch = string.match(current, "(%d+)%.(%d+)%.(%d+)")
    local lmajor, lminor, lpatch = string.match(latest, "(%d+)%.(%d+)%.(%d+)")
    if tonumber(cmajor) >= tonumber(lmajor) then
        if tonumber(cminor) >= tonumber(lminor) then
            if tonumber(cpatch) >= tonumber(lpatch) then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

local buyed = {}
Citizen.CreateThread(function()
    Citizen.Wait(7500)
    local c = 0
    for a,a in pairs(buyed) do c = c + 1 end
    if c > 0 then
        local text = '~r~[--------------] ~r~❤~s~Thanks for Buying~r~❤ [--------------]~s~'
        for script,version in pairs(buyed) do
            text = text .. '\n\t[~y~'..script..'~s~] [~b~Version ~p~' .. version .. '~s~]'
        end
        text = text .. '\n~r~[----------------------------------------------------]'
        print(MCD.Function.ConvertPrint(text))
    end
end)

function VersionState(ressourcename , scriptname , first)
    local currentVersion = GetResourceMetadata(ressourcename, 'version', 0):match('%d%.%d+%.%d+')
    local scriptdata = GetScriptData(scriptname)
    local lastVersion = scriptdata.version
    local url = scriptdata.url
    if lastVersion and currentVersion then
        versions[scriptname] = currentVersion    
        if CompareVersion(currentVersion , lastVersion) then
            if first then
                table.insert(check , {
                    script = scriptname,
                    updated = true,
                })
            else
                print(MCD.Function.ConvertPrint('[~y~'..scriptname..'~s~] ~g~✔ Up To Date'))
            end
        else
            if first then
                table.insert(check , {
                    script = scriptname,
                    updated = false,
                    current = currentVersion,
                    last = lastVersion,
                    url = url,
                })
            else
                print(MCD.Function.ConvertPrint('[~y~'..scriptname..'~s~] ~o~ ❗❗Out Dated❗~s~\n\t\t[~b~Current~s~]: ~r~' .. currentVersion .. '~s~\n\t\t[~b~Latest~s~]:  ~g~' .. lastVersion .. '~s~\n\t\t[~b~Update~s~]:🔗~p~' .. url))
            end
        end
    end
end

local lastupdate = MCD.GetCurrentTime()
local firstmsg = false
function CheckForUpdates()
    lastupdate =  MCD.GetCurrentTime()
    for i,p in ipairs(checker) do
        VersionState(p.ressourcename , p.script , true)
    end
    
    if #check > 0 then
        local text = '~c~[--------------------] ~s~Versions ~c~[--------------------]'
        for i,p in ipairs(check) do
            if p.updated then
                text = text .. '\n🟢[~y~'..p.script..'~s~] ~g~✔ Up To Date'
            else
                text = text .. '\n🔴[~y~'..p.script..'~s~]~o~ ❗❗Out Dated❗❗~s~\n\t\t[~b~Current~s~]: ~r~' .. p.current .. '~s~\n\t\t[~b~Latest~s~]:  ~g~' .. p.last .. '~s~\n\t\t[~b~Update~s~]:🔗~p~' .. p.url
            end
        end
        text = text .. '\n~c~[----------------------------------------------------]'
        print(MCD.Function.ConvertPrint(text))
        check = {}
    end
end

MCD.AddUpdateChecker = function(scriptname , ressourcename)
    if scriptname and ressourcename then
        if GetResourceState(ressourcename) ~= 'missing' and GetResourceState(ressourcename) ~= 'unknown' then
            local found = false
            for i,p in ipairs(checker) do
                if p.script == scriptname then
                    found = true
                    break 
                end
            end
            if not found then
                table.insert(checker , {script = scriptname , ressourcename = ressourcename})
            end
            if MCD.Math.TimeDifference(lastupdate , MCD.GetCurrentTime()) > 5 and firstmsg then
                Citizen.SetTimeout(0, function()
                    CheckForUpdates()
                end)                  
            end
        end
    end
end

MCD.Authenticate = function(scriptname , version)
    buyed[scriptname] = version
end

Citizen.CreateThread(function()
    MCD.AddUpdateChecker('mcd_lib', GetCurrentResourceName())    
    Citizen.Wait(5*1000)
    CheckForUpdates()
    firstmsg = true
    while true do
        Citizen.Wait(60 * 60 * 1000)
        CheckForUpdates()
    end
end)

RegisterCommand('mcd_version', function()
    for script,version in pairs(versions) do
        print(MCD.Function.ConvertPrint('[~y~'..script..'~s~] Version: ~b~'..version))
    end
end)

MCD.GetPlayerName = function(playersrc)
    return MCD.Function.RemoveColors(GetPlayerName(playersrc))
end

MCD.IsMuted = function(playersrc)
    return MumbleIsPlayerMuted(playersrc)
end

MCD.HasJob = function(id , Jobs)
    local xPlayer = ESX.GetPlayerFromId(id)

    local jname = xPlayer.job.name
    local jgrade = xPlayer.job.grade

    if Jobs == 'string' then
        OldFunction('HasJob')
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
    else
        local hasjob = false
        local hasgrade = false
        for jobname,grade in pairs(Jobs) do
            if jobname == jname then
                hasjob = true
                if grade <= jgrade then
                    hasgrade = true
                end
            end
        end
    
        if not hasjob then return 0 end
        if hasjob and not hasgrade then return 1 end
        if hasjob and hasgrade then return 2 end
    end
end

MCD.ItemName = function(item)
    return ESX.GetItemLabel(item)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        newkey()
        MCD.SaveTables()         
    end
end)
AddEventHandler('txAdmin:events:serverShuttingDown', function()
    newkey()
    Citizen.Wait(1000)
    MCD.SaveTables()
end)

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

Citizen.CreateThread(function()
    MCD.SendToDiscord('MCD Lib started' , GetCurrentResourceName() , 'default')
    print(MCD.Function.ConvertPrint('~s~[~y~'..GetCurrentResourceName()..'~s~][~b~INFO~s~]\t~g~MCD Lib started' , false))
end)

local hex2bin = {["0"] = "0000",["1"] = "0001",["2"] = "0010",["3"] = "0011",["4"] = "0100",["5"] = "0101",["6"] = "0110",["7"] = "0111",["8"] = "1000",["9"] = "1001",["a"] = "1010",["b"] = "1011",["c"] = "1100",["d"] = "1101",["e"] = "1110",["f"] = "1111"} function Hex2Bin(s)local ret = ""local i = 0 for i in string.gmatch(s, ".") do i = string.lower(i) ret = ret..hex2bin[i] end return ret end function Bin2Dec(s)local num = 0 local ex = string.len(s) - 1 local l = 0 l = ex + 1 for i = 1, l do b = string.sub(s, i, i) if b == "1" then num = num + 2^ex end ex = ex - 1 end return string.format("%u", num) end function Hex2Dec(s)local s = Hex2Bin(s)return Bin2Dec(s)end

MCD.SteamData = function(playerid)
    local ret = {}
    local finished = false

    local fivemid
    for k,v in ipairs(GetPlayerIdentifiers(playerid)) do
		if string.match(v, 'steam:') then
            fivemid = v
            fivemid = fivemid:gsub('steam:' , '')
		end
	end
    local steam64 = tonumber(Hex2Dec(fivemid)) + 9
    PerformHttpRequest('https://steamcommunity.com/profiles/'..steam64..'/?xml=1' , function(status, response)
        local string = response
        string = string:gsub('<!%[CDATA%[' , '')
        string = string:gsub('%]%]>' , '')
        ret.name = string.match(string, "<steamID>(%a+)</steamID>")
        ret.avatar = string.match(string, "<avatarFull>(%a+)</avatarFull>")
        ret.realname = string.match(string, "<realname>(%a+)</realname>")
        ret.location = string.match(string, "<location>(%a+)</location>")
        ret.jointime = string.match(string, "<memberSince>(%a+)</memberSince>")
        finished = true
    end, 'GET')    

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.Identifier = function(src)
    local Identifiers = GetPlayerIdentifiers(src)
    local data = {
        steamid = false,
        license = false,
        discord = false,
        xbl = false,
        liveid = false,
        ip = false,
    }
    for k,v in pairs(Identifiers)do 
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            data.steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            data.license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            data.xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            data.ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            data.discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            data.liveid = v
        end
    end
    return data
end

RegisterNetEvent('esx:playerSaved')
AddEventHandler('esx:playerSaved', function(playerId)
    TriggerClientEvent(MCD.Event('SavedPlayer'), playerId)
end)

MCD.BanPlayer = function(playerid , reason , duration)
    local pname = GetPlayerName(playerid)
    local banid = Ban(playerid , duration , reason)
    
    print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~]' .. _U('banned_no_res' , pname , reason , banid) , true))
    MCD.STDiscord(_U('Webhook_ban' , pname  ,reason , duration , banid), Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
end
connects = {}
AddEventHandler('playerConnecting', function(playername, setCallback, deferrals)
    local src = source
    local a = MCD.Identifier(src)
    local now = os.time(os.date('*t'))
    local reject
    local f = false
    local r = ''
    local bi = ''

    deferrals.update('Checking Banlist')
    local points = 0
    MySQL.Async.fetchAll('SELECT * FROM MCD_Banned ', {}, function(result)
        for i,p in ipairs(result) do
            local pnt = '' for a=0, points do pnt = pnt .. '.' end points = points + 1 if points > 3 then points = 0 end
            deferrals.update('Checking Banlist'..pnt)

            local found = false
            local ids = json.decode(p.ids)
            if ids.steamid and a.steamid then if ids.steamid == a.steamid then found = true end end
            if ids.license and a.license then if ids.license == a.license then found = true end end
            if ids.discord and a.discord then if ids.discord == a.discord then found = true end end
            if ids.xbl and a.xbl then if ids.xbl == a.xbl then found = true end end
            if ids.liveid and a.liveid then if ids.liveid == a.liveid then found = true end end
            if ids.ip and a.ip then if ids.ip == a.ip then found = true end end

            if found then
                local u = tonumber(p.unban)
                if u ~= 0 then
                    local diff = u - now
                    if diff > 0 then
                        local d = os.date("*t", u)
                        local date = d.day .. '.'..d.month..'.'..d.year .. '\t' .. d.hour..':'..d.min .. 'Uhr'
                        reject =  _U('banned_join' , p.reason, date , p.banid) 
                    end
                else
                    reject =  _U('banned_join' , p.reason, 'Never' , p.banid) 
                end
                r = p.reason
                bi = p.banid
            end
        end
        f = true
    end)
    while not f do Citizen.Wait(1) end

    if reject then
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ tried to Join but is ~r~Banned~s~ for ~y~' .. r .. '~s~ | BanId: ~c~'..bi , true) )
        deferrals.done(reject)
        CancelEvent()
    else
        connects[playername] = MCD.GetCurrentTime()
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ Is connecting' , true))
        deferrals.done()
    end
end)

Citizen.CreateThread(function()
    print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] Checking for OutDated ~r~Banns~s~'))

    local f = false
    local found = 0
    local now = os.time(os.date('*t'))
    MySQL.Async.fetchAll('SELECT * FROM MCD_Banned ', {}, function(result)
        for i,p in ipairs(result) do
            local u = tonumber(p.unban)
            if u ~= -1 then
                local diff = u - now
                if diff <= 0 then
                    found = found + 1
                    MySQL.Async.execute('DELETE FROM MCD_Banned WHERE banid = @banid', {
                        ['@banid'] = p.banid,
                    })
                end
            end
        end
        f = true
    end)

    while not f do Citizen.Wait(1) end
    print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] Found ~b~'..found..'~s~ and ~r~deleted~s~ them'))
end)

RegisterCommand('mcdunban', function(playerId, args)
    local banid = tonumber(args[1])
    if playerId ~= 0 then
        if MCD.IsAllowed(playerId, Config.UnbanPermission) then
            Unban(banid , GetPlayerName(playerId))
        else
            MCD.Notify(playerId , _U('no_perm') , nil , nil , 'error')
        end
    else
        if Config.AllowConsole then
            Unban(banid , 'Console')
        else
            print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('no_perm')))
        end
    end
end)
RegisterCommand('mcdban', function(playerId, args)
    if args[1] == 'me' then args[1] = playerId end
    local target = tonumber(args[1])
    local duration = tonumber(args[2])
    table.remove(args , 1) table.remove(args , 1)
    local reason = table.concat(args, ' ')

    local a = false
    if playerId ~= 0 then
        if MCD.IsAllowed(playerId, Config.UnbanPermission) then
            a = MCD.Function.RemoveColors(GetPlayerName(playerId))            
        else
            MCD.Notify(playerId , _U('no_perm') , nil , nil , 'error')
        end
    else
        if Config.AllowConsole then
            a = 'Console'
        else
            print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('no_perm')))
        end
    end

    if a then

        if ESX.GetPlayerFromId(target) then
            if duration then
                local tn = GetPlayerName(target)
                local banid = Ban(target , duration , reason , a)
                
                print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] '.._U('banned' , a , tn , reason , banid)))
                MCD.STDiscord(_U('Webhook_client_ban' , a , pname  ,reason , duration , banid), Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
            else
                if a == 'Console' then
                    print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('no_duration') .. ' \t' .. _U('ban_syntax')))
                else
                    MCD.Notify(playerId , _U('no_duration') .. ' \t' .. _U('ban_syntax') ,nil , nil , 'error')
                end
            end
        else
            if a == 'Console' then
                print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('player_doesnt_exist' , target)))
            else
                MCD.Notify(playerId , _U('player_doesnt_exist' , target) ,nil , nil , 'error')
            end
        end

    end
end)

Ban = function(playerid , duration , reason , operator)
    local banid
    local unbanned =  0
    if duration ~= 0 then
        unbanned = os.time(os.date('*t')) + duration*60
    end

    MySQL.Async.insert('INSERT INTO MCD_Banned (ids , unban , reason) VALUES (@ids , @unban , @reason)', {
        ['@ids'] = json.encode(MCD.Identifier(playerid)),
        ['@unban'] = unbanned,
        ['@reason'] = reason,
    }, function(result)
        banid = result
        if operator then
            DropPlayer(playerid, _U('ban_kick' , operator , reason , banid))
        else
            DropPlayer(playerid, _U('ban_kick_no', reason , banid))
        end       
        
    end)

    while not banid do Citizen.Wait(1) end
    return banid
end 

Unban = function(banid , playername)
    MySQL.Async.execute('DELETE FROM MCD_Banned WHERE banid = @banid', {
        ['@banid'] = banid,
    }, function(result)
        if result == 1 then
            print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] '.._U('unbanned' , playername , banid) , true))

            MCD.STDiscord(_U('Webhook_unban' , playername , banid), Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
        else
            print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('candt_find_ban' , banid)))
        end
    end)    
end

MCD.SetMoney = function(account , ammount , player ,  ressourcename)
    local _source = player
    ammount = tonumber(ammount)
    
    if not account then
        account = 'money'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_setmoney' , ressourcename) , true))
    end
    if not ammount then
        ammount = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_setmoney2' , ressourcename) , true))
    end
    
    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do xPlayer = ESX.GetPlayerFromId(_source) Citizen.Wait(5) end
    xPlayer.setAccountMoney(account, tonumber(ammount))
    if ammount > 0 then
        lastmoney = MCD.GetCurrentTime()
        moneymsg = moneymsg .. '\n' .. _U('Webhook_money_set' , ammount , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
    end
end

MCD.AddVehicle = function(plate , model , plyid ,  ressourcename)
    local r , finish = false , false
    local _source = source
    local msg = _U('error')
    
    if plate and model then
        local xPlayer = ESX.GetPlayerFromId(plyid)        
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle ) VALUES (@owner, @plate, @vehicle)', {
            ['@owner']   = xPlayer.identifier,
            ['@plate']   = plate,
            ['@vehicle'] = json.encode({model = model, plate = plate})
        }, function(rowsChanged)
            if tonumber(rowsChanged) == 1 then
                r = true
                msg = _U('success')
            end
            finish = true
        end)
        while not finish do Citizen.Wait(1) end
        MCD.SendToDiscord(_U('add_vehice', plate, msg ,_source) , ressourcename , 'default')
        return r
    else
        return false
    end
end

RegisterCommand('sudo', function(source , args)
    local id = tonumber(args[1])
    args[1] = ''
    local command = table.concat(args, ' ')
    if Config.SudoCommand.allow then
        if source ~= 0 then
            if MCD.IsAllowed(source , Config.SudoCommand.group) then
                if id then
                    TriggerClientEvent(MCD.Event('mcd_lib:Client:Sudo'), id , command)
                else
                    MCD.Notify(source , _U('sudo_syntax') , nil , nil , 'error')
                end
            else
                MCD.Notify(source , _U('no_perm') , nil , nil , 'error')
            end
        else
            if Config.SudoCommand.console then
                if id then
                    TriggerClientEvent(MCD.Event('mcd_lib:Client:Sudo'), id , command)
                else
                    print(MCD.Function.ConvertPrint(_U('error') .. _U('sudo_syntax')))  
                end
            else
                print(MCD.Function.ConvertPrint(_U('not_console' , 'Sudo')))                
            end
        end
    else
        print(MCD.Function.ConvertPrint(_U('sudo_not_aktiv')))
    end
end)

local kicks = {}
MCD.Kick = function(playerid , reason , source)
    local banned = false
    if Config.AutoBanAfterKicks > 0 then
        local ids = MCD.Identifier(playerid)
        table.insert(kicks , {ids = ids,reason = reason})
        local count = 0
        for i,p in ipairs(kicks) do
            local a = p.ids
            local found = false
            if ids.steamid and a.steamid then if ids.steamid == a.steamid then found = true end end
            if ids.license and a.license then if ids.license == a.license then found = true end end
            if ids.discord and a.discord then if ids.discord == a.discord then found = true end end
            if ids.xbl and a.xbl then if ids.xbl == a.xbl then found = true end end
            if ids.liveid and a.liveid then if ids.liveid == a.liveid then found = true end end
            if ids.ip and a.ip then if ids.ip == a.ip then found = true end end
            if found then
                count = count + 1
            end
        end
        if count >= Config.AutoBanAfterKicks then
            banned = true
            MCD.BanPlayer(playerid , 'Autoban for to many Kicks' , Config.AutoBanDuration)            
        end
    end
    if not banned then
        if source then
            local txt = _U('kicked_player' , GetPlayerName(source) , GetPlayerName(playerid) , reason)
            print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~]' ..txt , true))
            MCD.STDiscord(txt , Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
        else
            local txt = _U('kicked_script' , GetPlayerName(playerid) , reason)
            print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~]' ..txt , true))
            MCD.STDiscord(txt , Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
        end
        DropPlayer(playerid, reason)
    end
end

RegisterCommand('mcdkick', function(playerId, args)
    if args[1] == 'me' then args[1] = playerId end
    local target = tonumber(args[1])
    table.remove(args , 1)
    local reason = table.concat(args, ' ')

    local a = false
    if playerId ~= 0 then
        if MCD.IsAllowed(playerId, Config.UnbanPermission) then
            a = MCD.Function.RemoveColors(GetPlayerName(playerId))            
        else
            MCD.Notify(playerId , _U('no_perm') , nil , nil , 'error')
        end
    else
        if Config.AllowConsole then
            a = 'Console'
        else
            print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('no_perm')))
        end
    end

    if a then

        if ESX.GetPlayerFromId(target) then
            MCD.Kick(target , reason , playerId)
        else
            if a == 'Console' then
                print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('player_doesnt_exist' , target)))
            else
                MCD.Notify(playerId , _U('player_doesnt_exist' , target) ,nil , nil , 'error')
            end
        end

    end
end)

MCD.SaveTable = function(tablename , data)
    savedtables[tablename] = json.encode(data)
end

MCD.GetTable = function(tablename)
    if savedtables[tablename] then
        return json.decode(savedtables[tablename])
    else
        return {}
    end
end

MCD.SaveTables = function()
    local filetxt = 'savedtables = {\n'
    local c = 0
    for tablename,tabledata in pairs(savedtables) do
        local txt = '\t["'..tablename..'"] = '
        txt = txt .. "'"..tabledata.."',\n"
        filetxt = filetxt .. txt
        c = c +1 
    end
    filetxt = filetxt .. '}'

    local path = GetResourcePath(GetCurrentResourceName())..'/saves.lua'
    local file,err = io.open(path,'w+')
    if file then
        file:write(filetxt)
        file:close()
        print(MCD.Function.ConvertPrint('[~b~INFO~s~] Saved ~b~'..c..'~s~ Tables'))
    else
        print("error:", err)
    end
end

MCD.HasWeapon = function(playerid , weapons)
    local xPlayer = ESX.GetPlayerFromId(playerid)
    local loadout = xPlayer.getLoadout()
    local hasweapon = false
    if type(weapons) == 'string' or type(weapons) == 'number' then
        local hash = weapons
        if type(weapons) == 'string' then hash = GetHashKey(weapons) end
        for i,p in ipairs(loadout) do
            if GetHashKey(p.name) == hash then
                hasweapon = true
                break
            end
        end
    else
        for i,weapon in pairs(weapons) do
            local hash = weapon
            if type(weapon) == 'string' then hash = GetHashKey(weapon) end
            for i,p in ipairs(loadout) do
                if GetHashKey(p.name) == hash then
                    hasweapon = true
                    break
                end
            end
        end
    end
    return hasweapon
end

MCD.LiceneName = function(license)
    local ret
    MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = "' .. license .. '"', {}, function(result)
        if result[1] then
            ret = result[1].label
        else
            ret = 'Error'
        end 
    end)
    while not ret do Citizen.Wait(5) end
    return ret
end

RegisterCommand('savetables', function()
    MCD.SaveTables()
end, true)