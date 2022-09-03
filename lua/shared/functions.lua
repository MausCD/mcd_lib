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