MCD.Function = {}

MCD.Function.String = function(string) 
    local newstring = string
    if Config.UseEuro then
        newstring = newstring:gsub('%$' , '€')
    else
        newstring = newstring:gsub('%€' , '$')
    end
    return newstring
end

MCD.Function.RemoveString = function(string) 
    OldFunction('RemoveString')
    return MCD.Function.RemoveColors(string)
end

MCD.Function.RemoveColors = function(string) 
    if string == nil then
        string = 'NULL'
    end
    for i,p in ipairs(Config.ColorCodes) do
        string = string:gsub("%"..p.code, "")
    end
    string = string:gsub("%~s~", "")
    
    return MCD.Function.String(string)
end

MCD.Function.ConvertColor = function(string) 
    if string == nil then
        string = 'NULL'
    end

    local output = "<span>" .. string
    for i,p in ipairs(Config.ColorCodes) do
        output = output:gsub("%"..p.code, "</span><span style='color:"..p.htmlcode.."'>")
    end
	output = output:gsub("%~s~", "</span><span>")
    output = output .. '</span>'

    return MCD.Function.String(output)
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
MCD.Function.ConvertPrint = function(string , date)
    if string == nil then
        string = 'NULL'
    end
    if date then
        string = '~s~['..os.date('%X')..']' .. string
    else
        string = '~s~' .. string
    end
    for i,p in ipairs(ColorCodes) do
        string = string:gsub("%"..p.code, p.replacecode)
    end
    return MCD.Function.String(string.. '^0')
end

local letter = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','#','~','µ','!','§','&','/','=','_',',',';','>','<','|','°'}
MCD.Function.cKey = function(lenght)
    local key = ''
    for i = 1 , lenght do
        local isletter = math.random(1,2)
        if isletter == 1 then
            local letter = letter[math.random(1,#letter)]
            local smallletter = math.random(1,2)
            if smallletter == 1 then
                key = key .. string.upper(letter)
            else
                key = key .. string.lower(letter)
            end
        else
            local number = math.random(0,9)
            key = key .. number
        end
    end
    return key
end

MCD.Function.CSpeed = function(speed , withstring)
    if Config.usemph then
        local s = math.floor(speed * 2.236936)
        if withstring then
            s = s .. 'mph'
        end
        return s
    else
        local s = math.floor(speed * 3.61)
        if withstring then
            s = s .. 'kmh'
        end
        return s
    end
end

local moneycfg = {
    {val = 1000 , txt = 'Tsd.'},
    {val = math.floor(1e6) , txt = 'Mio.'},
    {val = math.floor(1e9) , txt = 'Mrd.'},
    {val = math.floor(1e12) , txt = 'Bill.'},
    {val = math.floor(1e15) , txt = 'Brd.'},
    {val = math.floor(1e18) , txt = 'Trill.'},
    {val = math.floor(1e21) , txt = 'Trd.'},
    {val = 1e24 , txt = 'Quadrillion'},
    {val = 1e27 , txt = 'Quadrilliarde'},
    {val = 1e30 , txt = 'Quintillion'},
    {val = 1e33 , txt = 'Quintilliarde'},
    {val = 1e36 , txt = 'Sextillion'},
    {val = 1e39 , txt = 'Sextilliarde'},
    {val = 1e42 , txt = 'Septillion'},
    {val = 1e45 , txt = 'Septilliarde'},
    {val = 1e48 , txt = 'Oktillion'},
    {val = 1e51 , txt = 'Oktilliarde'},
    {val = 1e54 , txt = 'Nonillion'},
    {val = 1e57 , txt = 'Nonilliarde'},
    {val = 1e60 , txt = 'Dezillion'},
    {val = 1e63 , txt = 'Dezilliarde'},
    {val = 1e66 , txt = 'undecillion'},
    {val = 1e69 , txt = 'undecilliarde'},
    {val = 1e100 , txt = 'googol'},
    {val = 1e156 , txt = 'sexvigintillion'},
    {val = 1e600 , txt = 'zentillion'},
}

MCD.Function.ConvertMoney = function(money)
    if not money then
        money = 0
        print(MCD.Function.ConvertPrint(_U('error').._U('error_convertmoney') , true))
    end
    local currency = '$'
    if Config.UseEuro then currency = '€' end
    local ret = ESX.Math.Round(money, 3)..currency
    for i,p in ipairs(moneycfg) do
        if money >= p.val then ret = ESX.Math.Round(tonumber(money)/p.val, 2)..p.txt..currency end 
    end
    return ret
end

local key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
MCD.ToHash = function(string)
    if not string then string = '' end
    if type(string) ~= 'string' then string = tostring(string) end
    return ((string:gsub('.', function(x) 
      local r,b='',x:byte()
      for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
      return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
      if (#x < 6) then return '' end
      local c=0
      for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
      return key:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#string%3+1])
end

MCD.ReadHash = function(hash)
    if not hash then return nil end
    local data = string.gsub(hash, '[^'..key..'=]', '')
    return (data:gsub('.', function(x)
      if (x == '=') then return '' end
      local r,f='',(key:find(x)-1)
      for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
      return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
      if (#x ~= 8) then return '' end
      local c=0
      for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
      return string.char(c)
    end))
end

function IsStringCracked(msg)
    local a , b = utf8.len(msg)
    return not a
end

Citizen.CreateThread(function()
    if not os then
        Citizen.Wait(100)
        MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetKey'), function(newkey) 
            key = newkey
        end)
    
        MCD.RegisterEvent('mcd_lib:Client:NewKey' , function(newkey)
            key = newkey
        end)
    else
        MCD.RegisterEvent('mcd_lib:Server:NewKey' , function(src , newkey)
            key = newkey
        end)
    end
end)