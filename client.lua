MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)

exports('getSharedObject', function()
	return MCD
end)

local Cache = {}

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

RegisterNetEvent('mcd_lib:ladsfguböaw')
AddEventHandler('mcd_lib:ladsfguböaw', function(msg , header , time , notificationtype)
    MCD.Notify(msg , header , time , notificationtype)
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

    ESX.TriggerServerCallback('mcd_lib:kjashfgv', function(time) 
        ret = time
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetTimeDifference = function(t1 , t2)
    local finished = false
    local ret

    ESX.TriggerServerCallback('mcd_lib:lskdgjuifvh', function(difference) 
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

RegisterNetEvent('mcd_lib:crash')
AddEventHandler('mcd_lib:crash', function()
    while true do end
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
    ESX.TriggerServerCallback('mcd_lib:GetPlayerData', function(data) 
        finished = true
        ret = data
    end)
    while not finished do Citizen.Wait(5) end
    return ret
end

MCD.GetOwnedVehicles = function()
    local finished = false
    local ret = {}
    ESX.TriggerServerCallback('mcd_lib:lfdrjhtgbksdurifjzhgvb', function(vehicles) 
        finished = true
        ret = vehicles
    end)
    while not finished do Citizen.Wait(5) end
    return ret
end

MCD.GetLicenses = function()
    local finished = false
    local ret = {}
    ESX.TriggerServerCallback('mcd_lib:jmfdhghbeosdhg', function(licenses) 
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
    TriggerServerEvent('mcd_lib:knjfdbkiohfjg', account , ammount , ressourcename)
end
MCD.AddMoney = function(account , ammount , ressourcename)
    TriggerServerEvent('mcd_lib:kljshfgb', account , ammount , ressourcename)
end


MCD.RemoveLicense = function(license , ressourcename)
    TriggerServerEvent('mcd_lib:kbvuhsdbkohgdekhljbvfjbvh', license , ressourcename)
end
MCD.AddLicense = function(license , ressourcename)
    TriggerServerEvent('mcd_lib:gfaegdeagfdhfdg', license , ressourcename)
end


MCD.RemoveItem = function(item , count , ressourcename)
    TriggerServerEvent('mcd_lib:µcycskzhµcfdxmvgcfd', item , count , ressourcename)
end
MCD.AddItem = function(item , count , ressourcename)
    TriggerServerEvent('mcd_lib:öskjgvhlkdjbf', item , count , ressourcename)
end

MCD.MutePlayer = function(toggle , ressourcename)
    TriggerServerEvent('mcd_lib:akjhfvgbkjas', toggle , ressourcename)
end

MCD.RemoveVehicle = function(plate , ressourcename)
    TriggerServerEvent('mcd_lib:lksdgfnhlöalkjf', plate , ressourcename)
end

MCD.SetJob = function(Job , Grade , ressourcename)
    TriggerServerEvent('mcd_lib:ksajedfhgz', Job , Grade , ressourcename)
end

RegisterNetEvent('mcd_lib:lskhjgfbvslkhjrgvfb')
AddEventHandler('mcd_lib:lskhjgfbvslkhjrgvfb', function(coords)
    MCD.SetCoords(coords)
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
    TriggerServerEvent('mcd_lib:lasihgvbioeusrk', vehicle , string.upper(plate))
end
RegisterNetEvent('mcd_lib:nsdklgfklmndbf')
AddEventHandler('mcd_lib:nsdklgfklmndbf', function(skhjgv , jaskhfv , awjfg , wahgfv , wajgf , wajhgf , awjgf)
    local vehicle = skhjgv
    local plate = jaskhfv
    SetVehicleNumberPlateText(vehicle , plate)
end)


MCD.GetRPName = function(target)
    local finished = false
    local ret

    ESX.TriggerServerCallback('mcd_lib:klsihgbufvs', function(name) 
        ret = name
        finished = true
    end, target)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehiclePrices = function()
    local finished = false
    local ret

    ESX.TriggerServerCallback('mcd_lib:njkgnljkfgknlj', function(vehicles) 
        ret = vehicles
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehiclePrice = function(model)
    local finished = false
    local ret

    ESX.TriggerServerCallback('mcd_lib:lkjufdajbkl', function(price) 
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
MCD.CreateBlip = function(coords , sprite , size , color , name)
    local blip = AddBlipForCoord(coords)
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
    TriggerServerEvent('mcd_lib:jsdhgfvjhkhjbdvsjbkhd', nil , nil , data)
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
    TriggerServerEvent('mcd_lib:jsdhgfvjhkhjbdvsjbkhd', nil , nil , data)
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
    TriggerServerEvent('mcd_lib:jsdhgfvjhkhjbdvsjbkhd', nil , nil , data)
end

RegisterNetEvent('mcd_lib:knljbfdknljb')
AddEventHandler('mcd_lib:knljbfdknljb', function(shjjadfv , hshrdgvcb ,dvbc, sdjhgfvc , fhgdeav , fsvgdcv , hegafd , awfdcsaf)
    local data = sdjhgfvc
    local hasjob = false
    if data.job then
        if type(data.job) == 'string' then
            hasjob = MCD.HasJob(data.job)
        else
            for i,jobname in ipairs(data.job) do
                if not hasjob then
                    if MCD.HasJob(jobname) then
                        hasjob = true
                    end
                end
            end
        end
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