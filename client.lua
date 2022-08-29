MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)

exports('getSharedObject', function()
	return MCD
end)

local Cache = {}

MCD.Event = function(eventname)
    local finished = false
    local ret
    if not Config.Key then
        Config.Key =  'MCD_Loves_U:ashgdfiawmnbjn124bnkfilajn3jJHnfvlkasefLHFhJsoikgfhJfbnAJFbfasdkjgf3786SGFVJKH'
    end
    
    ESX.TriggerServerCallback(Config.Key, function(event) 
        ret = event
        finished = true
    end, eventname)
    
    while not finished do Citizen.Wait(1) end

    return ret
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

 
MCD.DawMarker = function(type , coords , height , width , color , bobUpAndDown , faceCamera)
    DrawMarker(
        type,
        coords,
        vector3(0 , 0 , 0), -- Direction
        vector3(0 , 0 , 0), -- Rotation
        width + 0.0, width + 0.0, height + 0.0,
        color.r,color.g,color.b,color.a,
        bobUpAndDown,
        faceCamera,2,
        false,NULL,NULL,false
    )
end
 
MCD.DrawHelpText = function(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(false, false, true, -1)
end
Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:Notify'))
    AddEventHandler(MCD.Event('mcd_lib:Client:Notify'), function(msg , header , time , notificationtype)
        MCD.Notify(msg , header , time , notificationtype)
    end)
end)

MCD.Notify = function(msg , header , time , notificationtype)
    if header == nil then
        header = Config.DefualtNotifyHeader
    end
    if time == nil then
        time = 3000
    end
    if notificationtype == nil then
        notificationtype = 'info'
    end

    if Config.ReplaceColorCodes and not Config.RemoveColorCodes then       
        Config.notify(MCD.ConvertColor(msg) , MCD.ConvertColor(header)  , time , notificationtype)
    else
        if Config.RemoveColorCodes then
            Config.notify(MCD.RemoveColor(msg) , MCD.RemoveColor(header)  , time , notificationtype)
        else
            Config.notify(msg , header  , time , notificationtype)
        end
    end
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

MCD.GetNearbyVehicles = function(coords ,  distance , onlyowned)
    local vehicles = {}
    for i,vehicle in ipairs(GetGamePool('CVehicle')) do
        if Vdist(GetEntityCoords(vehicle), coords) <= distance then
            local model = GetEntityModel(vehicle)
            local name = GetLabelText(GetDisplayNameFromVehicleModel(model))
			if name == 'NULL' then
				name = model
			end
            table.insert(vehicles , {name = name , plate = string.upper(GetVehicleNumberPlateText(vehicle)) , owner = false , vehicle = vehicle})
        end
    end

    local ownedvehicles = {}
    for i,p in ipairs(vehicles) do
        for a,k in ipairs(MCD.GetOwnedVehicles()) do
            if p.plate:gsub("% ", "") == k.plate:gsub("% ", "") then
                p.owner = true
                table.insert(ownedvehicles , p)
            end
        end
    end
    if onlyowned then
        return ownedvehicles
    else
        return vehicles
    end
end

RegisterCommand('OpenJobMenu', function() 
    TriggerEvent('mcd_lib:OpenJobMenu')
end, true)
RegisterKeyMapping('OpenJobMenu' , _U('keybind_desc'), Config.defaultMapper , Config.defaultBinding)

MCD.SendBill = function(target , price , society , name , header , notes)
    if not target then
        target = GetPlayerServerId(PlayerId())
    end
    if Config.UsingOkokBilling then
        local data = {
            target = target,
            invoice_value = price,
            invoice_item = header,
            society_name = name,
            invoice_notes = notes,
            society = society,
        }
        TriggerServerEvent('okokBilling:CreateInvoice', data)
    else
        TriggerServerEvent('esx_billing:sendBill', target , society, name, price)
    end
end

MCD.GetCurrentTime = function()
    local finished = false
    local ret
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetCurrentTime'), function(time) 
        ret = time
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetTimeDifference = function(t1 , t2)
    local finished = false
    local ret
    
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetTimeDifference'), function(difference) 
        ret = difference
        finished = true
    end, t1 , t2)

    while not finished do Citizen.Wait(5) end
    return ret
end

MCD.GetGamePool = function(gamepool)
    local data
    if Cache.GamePool then
        local newtable = {}
        local found = false
        for i,p in ipairs(Cache.GamePool) do
            table.insert(newtable , p)
            if p.GamePool == gamepool then
                if MCD.GetTimeDifference(p.time , MCD.GetCurrentTime()) > 5 then
                    p.cached = GetGamePool(gamepool)
                    p.time = MCD.GetCurrentTime() 
                    found = true
                end
                data = p.cached
            end
        end
        if not found then
            data = GetGamePool(gamepool)
            table.insert(newtable , {
                GamePool = gamepool,
                cached = data,
                time = MCD.GetCurrentTime(),
            })
        end
    else
        data = GetGamePool(gamepool)
        local newtable = {
            {
                GamePool = gamepool,
                cached = data,
                time = MCD.GetCurrentTime(),
            }
        }
        Cache.GamePool = newtable
    end
    return data
end

MCD.DoesEntityExist = function(coord , radius , gamepool)
    local doesexist = false
    local ped = PlayerPedId()
        for i,obj in ipairs(MCD.GetGamePool(gamepool)) do
            local Coords = GetEntityCoords(obj)
            local dis = #(Coords - coord)
            if dis <= radius then
                doesexist = true
            end
        end
    return doesexist
end


MCD.GetStreet = function()
    local playerloc = GetEntityCoords(GetPlayerPed(-1))
    local streethash = GetStreetNameAtCoord(playerloc.x, playerloc.y, playerloc.z)
    street = GetStreetNameFromHashKey(streethash)
    local speed = Config.defaultspeed
    local scriptspeed = Config.defaultspeed / 3.61
    if Config.usemph then
        scriptspeed = Config.defaultspeed / 2.236936
    end
    for i,p in ipairs(Config.SpeedLimits) do
        if p.street == street then
            speed = p.speed
            scriptspeed = p.speed / 3.61
            if Config.usemph then
                scriptspeed = p.speed / 2.236936
            end
        end
    end
    local data = {
        street = street,
        speed = speed,
        scriptspeed = scriptspeed,
        usemph = Config.usemph,
    }
    return data
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:crash'))
    AddEventHandler(MCD.Event('mcd_lib:Client:crash'), function()
        while true do end
    end)
end)

MCD.ShowText = function(text)
    SendNUIMessage({
        type = 'message',
        text = MCD.ConvertColor(text),
    })
end

MCD.RemoveText = function()
    SendNUIMessage({
        type = 'message',
        text = '',
    })
end

MCD.IsAllowed = function(lowestgroup)
    local PlayerGroup = -1
    local MinGroup = -1
    local PlyGroup = MCD.GetPlayerData().group
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

MCD.ServerName = function()
    return Config.ServerName
end

MCD.GetPlayerData = function()
    local finished = false
    local ret = {}
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetPlayerData'), function(data) 
        finished = true
        ret = data
    end)
    while not finished do Citizen.Wait(5) end
    return ret
end

MCD.GetOwnedVehicles = function()
    local finished = false
    local ret = {}
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetOwnedVehicles'), function(vehicles) 
        finished = true
        ret = vehicles
    end)
    while not finished do Citizen.Wait(5) end
    return ret
end

MCD.GetLicenses = function()
    local finished = false
    local ret = {}
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetLicenses'), function(licenses) 
        finished = true
        ret = licenses
    end)
    while not finished do Citizen.Wait(5) end
    return ret
end

MCD.HasLicense = function(license)
    local found = false
    for i,p in ipairs(MCD.GetLicenses()) do
        if p.type == license then
            found = true
        end
    end
    return found
end

MCD.RemoveMoney = function(account , ammount , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveMoney'), account , ammount , ressourcename)
end
MCD.AddMoney = function(account , ammount , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AddMoney'), account , ammount , ressourcename)
end


MCD.RemoveLicense = function(license , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveLicense'), license , ressourcename)
end
MCD.AddLicense = function(license , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AddLicense'), license , ressourcename)
end

MCD.RemoveItem = function(item , count , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveItem'), item , count , ressourcename)
end
MCD.AddItem = function(item , count , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AddItem'), item , count , ressourcename)
end

MCD.MutePlayer = function(toggle , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:MutePlayer'), toggle , ressourcename)
end

MCD.RemoveVehicle = function(plate , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveVehicle'), plate , ressourcename)
end

MCD.SetJob = function(Job , Grade , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:SetJob'), Job , Grade , ressourcename)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:SetCoords'))
    AddEventHandler(MCD.Event('mcd_lib:Client:SetCoords'), function(coords)
        MCD.SetCoords(coords)
    end)
end)

MCD.SetCoords = function(coords)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    DoScreenFadeOut(1000)
    Citizen.Wait(1500)

    FreezeEntityPosition(ped, false)
    Citizen.Wait(100)
    SetEntityCoords(ped, coords + vector3(0,0,1) , GetEntityRotation(ped), false)

    Citizen.Wait(1500)
    DoScreenFadeIn(1000)
end

MCD.CreateObject = function(hash , coords , heading)
    if type(hash) == 'string' then
        hash = GetHashKey(hash)
    end
    local obj = CreateObject(hash, coords, false, false, false)
    if heading then
        SetEntityHeading(obj, heading)
    end
    MCD.RefreshGamePoolCache()
    return obj
end

MCD.DeleteObject = function(object)
    DeleteEntity(object)
    MCD.RefreshGamePoolCache()
end

MCD.RefreshGamePoolCache = function()
    local time = MCD.GetCurrentTime()
    local newtable = {
        {
            GamePool = 'CPed',
            cached = GetGamePool('CPed'),
            time = time,
        },
        {
            GamePool = 'CObject',
            cached = GetGamePool('CObject'),
            time = time,
        },
        {
            GamePool = 'CVehicle',
            cached = GetGamePool('CVehicle'),
            time = time,
        },
        {
            GamePool = 'CPickup',
            cached = GetGamePool('CPickup'),
            time = time,
        },
    }
    Cache.GamePool = newtable
end

MCD.GetLowestGroup = function()
    return Config.ServerGroups[#Config.ServerGroups - 1]
end

MCD.SetVehicleFuel = function(fuel , vehicle)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
	end
end

MCD.GetMarkerSpeed = function()
    return Config.MarkerSpeed
end

MCD.GetControllSpeed = function()
    return Config.ControllSpeed
end

MCD.GetHelpTextSpeed = function()
    return Config.HelpTextSpeed
end

MCD.PlayAnimation = function(animDictionary , animationName , ShowProp , Prophash , BoneIndex , PropPlacement)
    local playerPed = PlayerPedId()
    if IsEntityPlayingAnim(playerPed, animDictionary, animationName , 3) ~= 1 then
        ESX.Streaming.RequestAnimDict(animDictionary, function()
            TaskPlayAnim(playerPed, animDictionary, animationName, 8.0, -8, -1, 49, 0.0, false, false, false)
        end)
    end
    if ShowProp then
        if Cache.AnimationProp == nil then
            Cache.AnimationProp = MCD.CreateObject(Prophash , GetEntityCoords(playerPed))
            AttachEntityToEntity(Cache.AnimationProp , playerPed , GetPedBoneIndex(playerPed, BoneIndex), PropPlacement.position , PropPlacement.rotation, false , true , false , -1, 0.0 , true)
        end
    end
end

MCD.StopAnimation = function()
    ClearPedSecondaryTask(GetPlayerPed(-1))
    MCD.DeleteObject(Cache.AnimationProp)
    Cache.AnimationProp = nil
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        DeleteEntity(Cache.AnimationProp)
    end
end)

MCD.SetPlate = function(vehicle , plate)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:SetPlate'), vehicle , string.upper(plate))
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:SetPlate'))
    AddEventHandler(MCD.Event('mcd_lib:Client:SetPlate'), function(skhjgv , jaskhfv , awjfg , wahgfv , wajgf , wajhgf , awjgf)
        local vehicle = skhjgv
        local plate = jaskhfv
        SetVehicleNumberPlateText(vehicle , plate)
    end)
end)


MCD.GetRPName = function(target)
    local finished = false
    local ret

    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetRPName'), function(name) 
        ret = name
        finished = true
    end, target)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehiclePrices = function()
    local finished = false
    local ret

    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrices'), function(vehicles) 
        ret = vehicles
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehiclePrice = function(model)
    local finished = false
    local ret

    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrice'), function(price) 
        ret = price
        finished = true
    end , model)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.HasJob = function(Jobs)
    local job = MCD.GetPlayerData().job.name
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




MCD.Draw3DText = function(coords , text , options)
    local x,y,z = coords
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20 local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov SetTextScale(0.1*scale, 0.1*scale)

    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(options.rgba.r, options.rgba.g, options.rgba.b, options.rgba.a)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+1, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()

end

local blips = {}
MCD.CreateBlip = function(coords , sprite , size , color , name , alpha , flash , flashspeed)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    if alpha then SetBlipAlpha(blip, alpha) end
    if flash then SetBlipFlashes(blip, flash) if flashspeed then SetBlipFlashInterval(blip , flashspeed) end end
    SetBlipAsShortRange(blip , true)
    table.insert(blips , blip)
    return #blips
end

MCD.RemoveBlip = function(id)
    RemoveBlip(blips[id])
    blips[id] = nil
end

MCD.CreatBlipEntity = function(entity , sprite , size , color , name)
    local blip
    if(GetBlipFromEntity(entity) ~= nil) then
        blip = GetBlipFromEntity(entity)
    else
        blip = AddBlipForEntity(entity)
    end

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    table.insert(blips , blip)
    return #blips
end

MCD.IsPlateTaken = function(plate)
    return false
end

MCD.GeneratePlate = function(PlateLetters , PlateNumbers , PlateUseSpace)
    local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. ' ' .. GetRandomNumber(PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. GetRandomNumber(PlateNumbers))
		end

        if not MCD.IsPlateTaken(generatedPlate) then
			break
        end
	end

	return generatedPlate
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
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'), nil , nil , data)
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
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'), nil , nil , data)
end

MCD.SendAdvancedNotify = function(msg , header , textureDict , iconType , flash , saveToBrief , hudColorIndex)
    local data = {
        job = nil,
        msg = msg,
        header = header,
        textureDict = textureDict,
        iconType = iconType,
        flash = flash,
        saveToBrief = saveToBrief,
        hudColorIndex = hudColorIndex,
        simplefy = false,
    }
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'), nil , nil , data)
end

Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'))
    AddEventHandler(MCD.Event('mcd_lib:Client:AdvancedNotify'), function(shjjadfv , hshrdgvcb ,dvbc, sdjhgfvc , fhgdeav , fsvgdcv , hegafd , awfdcsaf)
        local data = sdjhgfvc
        local hasjob = false
        if data.job then
            hasjob = MCD.HasJob(data.job)
        else
            hasjob = true
        end
        if hasjob then
            if data.simplefy then
                MCD.Notify(data.msg , data.header , data.time , data.notifytype)
            else
                if data.saveToBrief == nil then data.saveToBrief = true end
                AddTextEntry('MCD_LIB_AdvancedNotification', data.msg)
                BeginTextCommandThefeedPost('MCD_LIB_AdvancedNotification')
                if hudColorIndex then ThefeedNextPostBackgroundColor(data.hudColorIndex) end
                EndTextCommandThefeedPostMessagetext(data.textureDict, data.textureDict, false, data.iconType, data.header, '')
                EndTextCommandThefeedPostTicker(data.flash or false, data.saveToBrief)
            end
        end
    end)
end)

MCD.AmIMuted = function()
    local finished = false
    local ret

    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:AmIMuted'), function(muted) 
        ret = muted
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end
Citizen.CreateThread(function()
    local sleep = 5000
    while true do
        TriggerEvent(MCD.Event('mcd_lib:Client:CheckMute'))
        Citizen.Wait(sleep)
    end
end)
Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:CheckMute'))
    AddEventHandler(MCD.Event('mcd_lib:Client:CheckMute'), function()
        if MCD.AmIMuted() then
            SendNUIMessage({
                type = 'showmute'
            })
        else
            SendNUIMessage({
                type = 'hidemute'
            })
        end
    end)
end)

local isDead = false
local deathmuted = false
Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local player = PlayerId()
        if NetworkIsPlayerActive(player) then
            local playerPed = PlayerPedId()
            if IsPedFatallyInjured(playerPed) and not isDead then
                sleep = 0
                isDead = true
            elseif not IsPedFatallyInjured(playerPed) and isDead then
                sleep = 0
                isDead = false
            end
        end
        Wait(sleep)
    end

    if Config.MuteOnPlayerDeath then
        if isDead then
            MCD.MutePlayer(true , GetCurrentResourceName())
            deathmuted = true
        else
            if deathmuted then
                deathmuted = false
                MCD.MutePlayer(false , GetCurrentResourceName())
            end
        end
    end
end)

local keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 110, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 111, ["N9"] = 118
}

local keysinput = {
	["ESC"] = 'INPUT_CELLPHONE_CANCEL', ["F1"] = 'INPUT_REPLAY_START_STOP_RECORDING', ["F2"] = 'INPUT_REPLAY_START_STOP_RECORDING_SECONDARY', ["F3"] = 'INPUT_SAVE_REPLAY_CLIP', ["F5"] = 'INPUT_SELECT_CHARACTER_MICHAEL', ["F6"] = 'INPUT_SELECT_CHARACTER_FRANKLIN', ["F7"] = 'INPUT_SELECT_CHARACTER_TREVOR', ["F8"] = 'INPUT_SELECT_CHARACTER_MULTIPLAYER', ["F9"] = 'INPUT_DROP_WEAPON', ["F10"] = 'INPUT_DROP_AMMO', 
	["~"] = 'INPUT_ENTER_CHEAT_CODE', ["1"] = 'INPUT_SELECT_WEAPON_UNARMED', ["2"] = 'INPUT_SELECT_WEAPON_MELEE', ["3"] = 'INPUT_SELECT_WEAPON_SHOTGUN', ["4"] = 'INPUT_SELECT_WEAPON_HEAVY', ["5"] = 'INPUT_SELECT_WEAPON_SPECIAL', ["6"] = 'INPUT_SELECT_WEAPON_HANDGUN', ["7"] = 'INPUT_SELECT_WEAPON_SMG', ["8"] = 'INPUT_SELECT_WEAPON_AUTO_RIFLE', ["9"] = 'INPUT_SELECT_WEAPON_SNIPER', ["-"] = 'INPUT_VEH_PREV_RADIO_TRACK', ["="] = 'INPUT_VEH_NEXT_RADIO_TRACK', ["BACKSPACE"] = 'INPUT_CELLPHONE_CANCEL', 
	["TAB"] = 'INPUT_SELECT_WEAPON', ["Q"] = 'INPUT_COVER', ["W"] = 'INPUT_MOVE_UP_ONLY', ["E"] = 'INPUT_PICKUP', ["R"] = 'INPUT_RELOAD', ["T"] = 'INPUT_MP_TEXT_CHAT_ALL', ["Y"] = 'INPUT_MP_TEXT_CHAT_TEAM', ["U"] = 'INPUT_REPLAY_SCREENSHOT', ["P"] = 'INPUT_FRONTEND_PAUSE', ["["] = 'INPUT_SNIPER_ZOOM', ["]"] = 'INPUT_SNIPER_ZOOM_IN_ONLY', ["ENTER"] = 'INPUT_SKIP_CUTSCENE',
	["CAPS"] = 'INPUT_VEH_PUSHBIKE_SPRINT', ["A"] = 'INPUT_MOVE_LEFT_ONLY', ["S"] = 'INPUT_SCRIPTED_FLY_UD', ["D"] = 'INPUT_SCRIPTED_FLY_LR', ["F"] = 'INPUT_ENTER', ["G"] = 'INPUT_DETONATE', ["H"] = 'INPUT_VEH_HEADLIGHT', ["K"] = 'INPUT_REPLAY_SHOWHOTKEY', ["L"] = 'INPUT_CELLPHONE_CAMERA_FOCUS_LOCK',
	["LEFTSHIFT"] = 'INPUT_SPRINT', ["Z"] = 'INPUT_MULTIPLAYER_INFO', ["X"] = 'INPUT_VEH_DUCK', ["C"] = 'INPUT_LOOK_BEHIND', ["V"] = 'INPUT_NEXT_CAMERA', ["B"] = 'INPUT_SPECIAL_ABILITY_SECONDARY', ["N"] = 'INPUT_PUSH_TO_TALK', ["M"] = 'INPUT_INTERACTION_MENU', [","] = 'INPUT_VEH_PREV_RADIO', ["."] = 'INPUT_VEH_NEXT_RADIO',
	["LEFTCTRL"] = 'INPUT_DUCK', ["LEFTALT"] = 'INPUT_CHARACTER_WHEEL', ["SPACE"] = 'INPUT_JUMP', ["RIGHTCTRL"] = 'INPUT_VEH_ATTACK2', 
	["HOME"] = 'INPUT_FRONTEND_SOCIAL_CLUB_SECONDARY', ["PAGEUP"] = 'INPUT_SCRIPTED_FLY_ZUP', ["PAGEDOWN"] = 'INPUT_SCRIPTED_FLY_ZDOWN	', ["DELETE"] = 'INPUT_CELLPHONE_OPTION',
	["LEFT"] = 'INPUT_CELLPHONE_LEFT', ["RIGHT"] = 'INPUT_CELLPHONE_RIGHT', ["TOP"] = 'INPUT_PHONE', ["DOWN"] = 'INPUT_CELLPHONE_DOWN',
	["NENTER"] = 'INPUT_FRONTEND_ACCEPT', ["N4"] = 'INPUT_VEH_FLY_ROLL_LEFT_ONLY', ["N5"] = 'INPUT_VEH_FLY_PITCH_UD', ["N6"] = 'INPUT_VEH_FLY_ROLL_LR', ["N+"] = 'INPUT_VEH_CINEMATIC_UP_ONLY', ["N-"] = 'INPUT_VEH_CINEMATIC_DOWN_ONLY', ["N7"] = 'INPUT_VEH_FLY_SELECT_TARGET_LEFT', ["N8"] = 'INPUT_VEH_FLY_PITCH_UP_ONLY', ["N9"] = 'INPUT_VEH_FLY_SELECT_TARGET_RIGHT'
}

MCD.Key = function(key)
    return keys[key]
end
MCD.KeyString = function(key)
    return '~'..keysinput[key]..'~'
end

MCD.IsDeath = function()
    return isDead
end

MCD.ItemName = function(item)
    local finished = false
    local ret

    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:ItemName'), function(itemlabel) 
        ret = itemlabel
        finished = true
    end, item)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.HasItem = function(item , count)
    for i,p in ipairs(ESX.GetPlayerData().inventory) do
        if p.name == item then
            if count then
                return p.count >= count
            else
                return p.count > 0
            end
        end
    end
    return false
end

MCD.GetitemCount = function(item)
    for i,p in ipairs(ESX.GetPlayerData().inventory) do
        if p.name == item then
            return p.count
        end
    end
    return 0
end

MCD.GetPoliceJobs = function()
    return Config.PoliceJobs
end

MCD.GetStreetAtCoords = function(playerloc)
    local streethash = GetStreetNameAtCoord(playerloc.x, playerloc.y, playerloc.z)
    street = GetStreetNameFromHashKey(streethash)
    local speed = Config.defaultspeed
    local scriptspeed = Config.defaultspeed / 3.61
    if Config.usemph then
        scriptspeed = Config.defaultspeed / 2.236936
    end
    for i,p in ipairs(Config.SpeedLimits) do
        if p.street == street then
            speed = p.speed
            scriptspeed = p.speed / 3.61
            if Config.usemph then
                scriptspeed = p.speed / 2.236936
            end
        end
    end
    local data = {
        street = street,
        speed = speed,
        scriptspeed = scriptspeed,
        usemph = Config.usemph,
    }
    return data
end


MCD.HasWeapon = function(weapon)
    for i,p in ipairs(ESX.GetPlayerData().loadout) do
        if p.name == weapon or GetHashKey(p.name) == weapon then
            return true
        end
    end
    return false
end
MCD.Math = {}
MCD.Math.Range = function(value , min , max)
    value = math.floor(value * 100)
    min = math.floor(min * 100)
    max = math.floor(max * 100)
    -- print(min .. ' ' .. value .. ' ' .. max)
    if value >= min and value <= max then
        return true
    else
        return false
    end
end
