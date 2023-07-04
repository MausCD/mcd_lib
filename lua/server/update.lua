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

MCD.AddUpdateChecker = function(scriptname)
    local ressourcename = GetInvokingResource()
    if not ressourcename then
        ressourcename = GetCurrentResourceName()
    end
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

MCD.Authenticate = function(scriptname)
    local ressourcename = GetInvokingResource()
    local version = GetResourceMetadata(ressourcename, 'version', 0):match('%d%.%d+%.%d+')

    buyed[scriptname] = version
end

Citizen.CreateThread(function() 
    MCD.AddUpdateChecker('mcd_lib')   
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