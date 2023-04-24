events = {}

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

local savetykey = Config.Key
function newkey()
    if not Config.Key then
        Config.Key =  'MCD_Loves_U:ashgdfiawmnbjn124bnkfilajn3jJHnfvlkasefLHFhJsoikgfhJfbnAJFbfasdkjgf3786SGFVJKH'
        savetykey = Config.Key
    end
    local path = GetResourcePath(GetCurrentResourceName())..'/config.lua'
    local file,err = io.open(path,'r+')
    if file then
        local generatedkey = EventString(Config.EntcrypedEventLenght)
        local text = file:read('*a')
        if not string.find(text , savetykey ,1, true) then
            text = text .. "\n\nConfig.Key = '" .. generatedkey .. "'"
        else
            text = text:gsub('%'..savetykey , generatedkey)
        end
        savetykey = generatedkey
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

keys = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'}
key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

Citizen.CreateThread(function()
    while not MCD.RegisterServerCallback do Citizen.Wait(1) end
    MCD.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetKey') , function(src , cb)
        cb(key)
    end)
end)

Citizen.CreateThread(function()
    NewHash()
    while true do
        Citizen.Wait(5000)
        NewHash()
    end
end)

function NewHash()
    local newkey = ''
    local already = {}
    for i=0, #keys-1  do
        local r = keys[math.random(1 , #keys)]
        local found = true
        while found do
            found = false
            for a,key in pairs(already) do
                if key == r then
                    found = true
                    r = keys[math.random(1 , #keys)]
                    break
                end
            end
        end
        table.insert(already , r)
    end
    for i , key in pairs(already) do
        newkey = newkey .. key
    end
    key = newkey
    MCD.TriggerClientEvent('mcd_lib:Client:NewKey' , -1 , key)
    MCD.TriggerEvent('mcd_lib:Server:NewKey' , key)
end

local createdtrab = {}
Citizen.CreateThread(function()
    Citizen.Wait(2500)
    local sleep = 1000
    while Config.CreateFakeEvents do Citizen.Wait(sleep)
        for tableevent,tablecrypt in pairs(events) do
            if not createdtrab[tableevent] then
                createdtrab[tableevent] = true
                RegisterNetEvent(tableevent)
                AddEventHandler(tableevent, function()
                    MCD.BanPlayer(source , _U('ban_trap') , 0)
                end)
                if Config.DebugMode then
                    print(MCD.Function.ConvertPrint('[~y~'..GetCurrentResourceName()..'~s~][~c~DEBUG~s~]\t Event Trap createt for "'..tableevent..'"' , true))
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    if Config.CreateBackups then
        while true do
            CreateBackup()
            Citizen.Wait(60*60*1000)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        CreateBackup()
    end
end)

function CreateBackup()
    local filename = 'backup ' .. os.date('%d-%B  Hour %H')..'.bak'

    local file,err = io.open(GetResourcePath(GetCurrentResourceName())..'/saves.lua','r+')
    if file then
        local content = file:read('*a')
        file:close()
        local file = io.open(GetResourcePath(GetCurrentResourceName())..'/backups/'..filename,'w+')
        file:write(content)
        file:close()

        print(MCD.Function.ConvertPrint(_U('backup') , true))
    else
        print(err)
    end
end

RegisterCommand('mcd_backup', function(source)
    if source == 0 then
        CreateBackup()
    else
        if MCD.IsAllowed(source , Config.CreateBackupCommand) then
            CreateBackup()
        else
            MCD.Notify(source , _U('no_perm') , nil , nil , 'error')
        end
    end
end)