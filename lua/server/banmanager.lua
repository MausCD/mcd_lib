bans = MCD.GetTable('mcd_lib:BanTable')

MCD.BanPlayer = function(playerid , reason , duration)
    local pname = MCD.GetPlayerName(playerid)
    local cleanname = GetPlayerName(playerid)
    local banid = 0
    if not Config.DisableBans then
        banid = Ban(playerid , duration , reason)
    end
    local newduration = duration .. _U('minutes')
    if duration >= 120 then 
        newduration = math.floor(duration/60) .. _U('hours')

        local d = duration/60
        if d > 23 then
            newduration = math.floor(d/24) .. _U('day')
            if d > 47 then
                newduration = math.floor(d/24) .. _U('days')

                local da = d/24
                if da > 29 then
                    newduration = math.floor(da/30) .. _U('month')
                    if da > 59 then
                        newduration = math.floor(da/30) .. _U('months')
                        if da > 364 then
                            newduration = math.floor(da/30) .. _U('year')
                            if da > 729 then
                                newduration = math.floor(da/30) .. _U('years')
                            end
                        end
                    end
                end
            end
        end
    else
        if duration == 0 then
            newduration = _U('perm')
        end
    end
    
    print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~]' .. _U('banned_no_res' , cleanname , reason , banid) , true))
    MCD.STDiscord(_U('Webhook_ban' , pname  ,reason , newduration , banid), Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
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

    local date = ''

    deferrals.update('Checking Banlist')
    local points = 0
    for i,p in ipairs(bans) do
        if p.active then
            local pnt = '' for a=0, points do pnt = pnt .. '.' end points = points + 1 if points > 3 then points = 0 end
            deferrals.update('Checking Banlist'..pnt)
    
            local found = false
            local ids = p.ids
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
                        date = d.day .. '.'..d.month..'.'..d.year .. ' ' .. d.hour..':'..d.min .. 'Uhr'
                        reject =  true
                    end
                else
                    reject =  true
                    date = _U('perm')
                end
                r = p.reason
                bi = i
                break
            end
        end
    end

    if reject then
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~][~b~INFO~s~]'.._U('banned_join_print' , playername , r , bi) , true) )
        
        deferrals.defer()
        Wait(750)
        deferrals.presentCard([==[{
            "type": "AdaptiveCard",
            "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
            "version": "1.3",
            "body": [
            {
                "type": "Container",
                "items": [
                    {
                        "type":"Image",
                        "url":"https://i.ibb.co/Bt1CVQZ/MCD.png",
                        "size": "Large",
                        "horizontalAlignment": "Center"
                    },
                    {
                        "type": "TextBlock",
                        "text": "]==].._U('adaptiv_banned')..[==[",
                        "wrap": true,
                        "fontType": "Default",
                        "size": "ExtraLarge",
                        "weight": "Bolder",
                        "color": "Light",
                        "separator": true,
                        "horizontalAlignment": "Center"
                    },          
                    {
                        "type": "TextBlock",
                        "text": "]==].._U('adaptiv_description' , date)..[==[",
                        "wrap": true,
                        "color": "Light",
                        "size": "Medium",
                        "horizontalAlignment": "Center"
                    },
                    {
                        "type": "TextBlock",
                        "text": "]==].._U('adaptiv_reason' , r)..[==[",
                        "wrap": true,
                        "size": "Medium",
                        "color": "Light",
                        "horizontalAlignment": "Center"
                    },      
                    {
                        "type": "TextBlock",
                        "text": "]==].._U('adaptiv_banid' , bi)..[==[",
                        "wrap": true,
                        "color": "Light",
                        "size": "Medium",
                        "horizontalAlignment": "Center"
                    },
                    {
                        "type": "TextBlock",
                        "text": "]==].._U('adaptiv_finish' , Config.ServerName)..[==[",
                        "wrap": true,
                        "color": "Light",
                        "size": "Small",
                        "horizontalAlignment": "Center"
                    },
                    {
                        "type": "TextBlock",
                        "text": "ㅤ",
                        "wrap": true,
                        "color": "Light",
                        "size": "Small",
                        "separator": true
                    },
                    {
                        "type": "ColumnSet",
                        "height": "stretch",
                        "minHeight": "5px",
                        "bleed": true,
                        "selectAction": {
                            "type": "Action.OpenUrl"
                        },
                        "columns": [
                            {
                                "type": "Column",
                                "width": "stretch",
                                "items": [
                                    {
                                        "type": "ActionSet",
                                        "actions": [
                                            {
                                                "type": "Action.OpenUrl",
                                                "title": "Support Discord",
                                                "url": "]==]..Config.DiscordLink ..[==[",
                                                "style": "positive",
                                                "iconUrl": "https://static-00.iconduck.com/assets.00/shield-emoji-418x512-zinrlj3f.png"
                                            }
                                        ],
                                        "horizontalAlignment": "Left"
                                    }
                                ]
                            },
                            {
                                "type": "Column",
                                "width": "stretch",
                                "items": [
                                    {
                                        "type": "ActionSet",
                                        "actions": [
                                            {
                                                "type": "Action.OpenUrl",
                                                "title": "Script Discord",
                                                "url": "https://discord.mauscd.de/",
                                                "style": "positive",
                                                "iconUrl": "https://i.ibb.co/Bt1CVQZ/MCD.png"
                                            }
                                        ],
                                        "horizontalAlignment": "Right"
                                    }
                                ]
                            }
                        ]
                    }
                ],
                "style": "default",
                "bleed": true,
                "height": "stretch",
                "isVisible": true
            }
            ]
            }]==]
        )
    else
        connects[playername] = MCD.GetCurrentTime()
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] ' .. playername .. '~s~ Is connecting' , true))
        deferrals.done()
    end
end)

Citizen.CreateThread(function()
    print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] Checking for OutDated ~r~Banns'))

    local f = false
    local found = 0
    local now = os.time(os.date('*t'))

    for i,p in ipairs(bans) do
        if p.active then
            local u = tonumber(p.unban)
            if u ~= 0 then
                local diff = u - now
                if diff <= 0 then
                    found = found + 1
                    p.active = false
                end
            end
            Citizen.Wait(10)
        end
    end
    if found > 0 then
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] Found ~b~'..found..'~s~ and ~r~unbanned~s~ them'))
        MCD.SaveTable('mcd_lib:BanTable' , bans)  
    else
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] Found ~b~'..found..'~s~ OutDated ~r~Banns'))
    end
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
    if not duration then duration = 0 end
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

                local newduration = duration .. _U('minutes')
                if duration >= 120 then 
                    newduration = math.floor(duration/60) .. _U('hours')
            
                    local d = duration/60
                    if d > 23 then
                        newduration = math.floor(d/24) .. _U('day')
                        if d > 47 then
                            newduration = math.floor(d/24) .. _U('days')
            
                            local da = d/24
                            if da > 29 then
                                newduration = math.floor(da/30) .. _U('month')
                                if da > 59 then
                                    newduration = math.floor(da/30) .. _U('months')
                                    if da > 364 then
                                        newduration = math.floor(da/30) .. _U('year')
                                        if da > 729 then
                                            newduration = math.floor(da/30) .. _U('years')
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if duration == 0 then
                        newduration = _U('perm')
                    end
                end
                
                print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] '.._U('banned' , a , tn , reason , banid)))
                MCD.STDiscord(_U('Webhook_client_ban' , a , pname  ,reason , newduration , banid), Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
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
    local unbanned =  0
    if duration then
        if duration ~= 0 then
            unbanned = os.time(os.date('*t')) + duration*60
        end
    end
    
    table.insert(bans , {
        ids = MCD.Identifier(playerid),
        unban = unbanned,
        reason = reason,
        active = true
    })
    if operator then
        DropPlayer(playerid, _U('ban_kick' , operator , reason , #bans))
    else
        DropPlayer(playerid, _U('ban_kick_no', reason , #bans))
    end     
    MCD.SaveTable('mcd_lib:BanTable' , bans)  
    return #bans
end 

Unban = function(banid , playername)
    if bans[banid].active then
        bans[banid].active = false
        print(MCD.Function.ConvertPrint('[~o~BANMANAGER~s~] [~b~INFO~s~] '.._U('unbanned' , playername , banid) , true))

        MCD.STDiscord(_U('Webhook_unban' , playername , banid), Config.WebHook['banning'].DiscordWebHook , Config.WebHook['color'] , Config.WebHook['banning'].Name, Config.WebHook['avatar'])
        
        MCD.SaveTable('mcd_lib:BanTable' , bans)  
    else
        print(MCD.Function.ConvertPrint("[~o~BANMANAGER~s~] [~r~ERROR~s~] " .. _U('candt_find_ban' , banid)))
    end   
end

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
        DropPlayer(playerid, _U('kicked_for' , reason))
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

RegisterCommand('mcdhistory', function(playerId, args)
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
        local identifier = args[1]
        if tonumber(identifier) then
            identifier = MCD.Identifier(tonumber(identifier)).license
        end
        local hbans = {}
        local banned
        for i,p in ipairs(bans) do
            local found = false
            local ids = p.ids
            if ids.steamid then if ids.steamid == identifier then found = true end end
            if ids.license then if ids.license == identifier then found = true end end
            if ids.discord then if ids.discord == identifier then found = true end end
            if ids.xbl then if ids.xbl == identifier then found = true end end
            if ids.liveid then if ids.liveid == identifier then found = true end end
            if ids.ip then if ids.ip == identifier then found = true end end

            if found then
                if p.active then
                    banned = p
                else
                    table.insert(hbans , p)
                end
            end
        end

        local text = ''
        if banned then
            text = 'Player ist Currently Banned for ~y~'..banned.reason..'~s~\n\n'
        end

        if #hbans > 0 then
            text = text .. 'Was Banned for:'
            for i,p in ipairs(hbans) do
                text = text..'\n\t- ~y~'..p.reason..'~s~'
            end
        else
            if text ~= '' then
                text = text..'No other Bans in History'
            else
                text = 'Player Never was Banned'
            end
        end

        print(MCD.Function.ConvertPrint(text))
    end
end)


Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Server:BanPlayer'))
    AddEventHandler(MCD.Event('mcd_lib:Server:BanPlayer'), function(param1 , param2 , param3 , param4 , param5)
        local target = tonumber(MCD.ReadHash(param1))
        local Reason = MCD.ReadHash(param2)
        local Duration = tonumber(MCD.ReadHash(param3))
        if not target then target = source end
        MCD.BanPlayer(target , Reason , Duration)
        
        if IsStringCracked(Reason) or IsStringCracked(MCD.ReadHash(param3)) then
            MCD.BanPlayer(source , _U('triggerserverevent_ban') , 0)
        end
    end)
    RegisterNetEvent(MCD.Event('mcd_lib:Server:Kick'))
    AddEventHandler(MCD.Event('mcd_lib:Server:Kick'), function(param1 , param2 , param3 , param4 , param5)
        local target = tonumber(MCD.ReadHash(param1))
        local reason = MCD.ReadHash(param2)
        if not target then target = source end
        MCD.Kick(target , reason)
        
        if IsStringCracked(reason) then
            MCD.BanPlayer(source , _U('triggerserverevent_ban') , 0)
        end
    end)
end)