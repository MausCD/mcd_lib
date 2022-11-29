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
    {val = 1000 , txt = 'Tausend'},
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
    local currency = '$'
    if Config.UseEuro then currency = '€' end
    local ret = money..currency
    for i,p in ipairs(moneycfg) do
        if money >= p.val then ret = ESX.Math.Round(tonumber(money)/p.val, 2)..p.txt..currency end 
    end
    return ret
end