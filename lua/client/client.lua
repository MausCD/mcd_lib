local triggering = 0
local results = 0

local Cache = {}

MCD.TriggerServerEvent = function(event , ...)
    TriggerServerEvent(MCD.Event(event) , ...)
end
local events = {}
MCD.TriggerServerCallback = function(svevent , cb , ...)
    local data = ...
    SetTimeout(math.random(1,100), function()
        local event = 'mcd:event:'..MCD.Function.cKey(20)
        triggering = triggering + 1
        RegisterNetEvent(MCD.Event(event))
        events[event] = AddEventHandler(MCD.Event(event), function(...)
            results = results + 1
            RemoveEventHandler(events[event])
            events[event] = nil
            cb(...)
        end)
        MCD.TriggerServerEvent('mcd_lib:Server:Callback' , svevent , event , data)
    end)
end

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

MCD.DawMarker = function(type , coords , height , width , color , bobUpAndDown , faceCamera)
    OldFunction('DawMarker')
    MCD.DrawMarker(type , coords , height , width , color , bobUpAndDown , faceCamera)
end
 
MCD.DrawMarker = function(type , coords , height , width , color , bobUpAndDown , faceCamera)
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

MCD.Notify = function(msg , header , time , notificationtype)
    if header == nil then
        header = Config.DefaultNotifyHeader
    end
    if time == nil then
        time = 3000
    end
    if notificationtype == nil then
        notificationtype = 'info'
    end
    if Config.CustomNotify then
        notificationtype = Config.NotifyColors[notificationtype]
        if notificationtype == nil then notificationtype = 'info' end
    end
    if Config.ReplaceColorCodes and not Config.RemoveColorCodes then       
        Config.notify(MCD.Function.ConvertColor(msg) , MCD.Function.ConvertColor(header)  , time , notificationtype)
    else
        if Config.RemoveColorCodes then
            Config.notify(MCD.Function.RemoveColors(msg) , MCD.Function.RemoveColors(header)  , time , notificationtype)
        else
            Config.notify(msg , header  , time , notificationtype)
        end
    end
end

MCD.GetNearbyVehicles = function(coords ,  distance , onlyowned)
    local vehicles = {}
    for i,vehicle in ipairs(MCD.GetGamePool('CVehicle')) do
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

MCD.SendBill = function(target , price , society , name , notes)
    if not target then
        target = GetPlayerServerId(PlayerId())
    end
    if Config.UsingOkokBilling then
        local data = {
            target = target,
            invoice_value = price,
            invoice_item = name,
            society_name = society,
            invoice_notes = notes,
            society = society,
        }
        TriggerServerEvent('okokBilling:CreateInvoice', data)
    else
        TriggerServerEvent('esx_billing:sendBill', target , society, name, price)
    end
end

MCD.GetGamePool = function(gamepool)
    local data
    if Cache.GamePool then
        local newtable = {}
        local found = false
        for i,p in ipairs(Cache.GamePool) do
            table.insert(newtable , p)
            if p.GamePool == gamepool then
                if MCD.Math.TimeDifference(p.time , MCD.GetCurrentTime()) > 5 then
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
            local dis = #(Coords - coord.xyz)
            if dis <= radius then
                doesexist = true
            end
        end
    return doesexist
end

MCD.GetStreet = function()
    local playerloc = GetEntityCoords(PlayerPedId())
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

MCD.ShowText = function(text)
    SendNUIMessage({
        type = 'message',
        text = MCD.Function.ConvertColor(text),
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

local lastrequest = {
    playerdata      = false,
    ownedvehicles   = false,
    licenses        = false,
}
local lastdata = {
    playerdata      = {},
    ownedvehicles   = {},
    licenses        = {},
}
MCD.GetPlayerData = function()
    if not lastrequest.playerdata then
        local finished = false
        local ret = {}
        MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetPlayerData'), function(data) 
            finished = true
            ret = data
        end)
        while not finished do Citizen.Wait(5) end

        lastrequest.playerdata = true
        SetTimeout(1000, function()
            lastrequest.playerdata = false
        end)
        lastdata.playerdata = ret
        return ret
    else
        return lastdata.playerdata
    end
end

MCD.GetOwnedVehicles = function()
    if not lastrequest.ownedvehicles then
        local finished = false
        local ret = {}
        MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetOwnedVehicles'), function(vehicles) 
            finished = true
            ret = vehicles
        end)
        while not finished do Citizen.Wait(5) end
        lastrequest.ownedvehicles = true
        SetTimeout(1000, function()
            lastrequest.ownedvehicles = false
        end)
        lastdata.ownedvehicles = ret
        return ret
    else
        return lastdata.ownedvehicles
    end
end

MCD.GetLicenses = function()
    if not lastrequest.licenses then
        local finished = false
        local ret = {}
        MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetLicenses'), function(licenses) 
            finished = true
            ret = licenses
        end)
        while not finished do Citizen.Wait(5) end
        lastrequest.licenses = true
        SetTimeout(1000, function()
            lastrequest.licenses = false
        end)
        lastdata.licenses = ret
        return ret
    else
        return lastdata.licenses
    end
end

MCD.HasLicense = function(license)
    local found = false
    for i,p in ipairs(MCD.GetLicenses()) do
        if string.lower(p.type) == string.lower(license) then
            found = true
        end
    end
    return found
end

MCD.RemoveMoney = function(account , ammount , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end    
    MCD.TriggerServerEvent('mcd_lib:Server:RemoveMoney' , MCD.ToHash(account) , MCD.ToHash(ammount) , ressourcename, MCD.ToHash(target))
end
MCD.AddMoney = function(account , ammount , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end    
    MCD.TriggerServerEvent('mcd_lib:Server:AddMoney' , MCD.ToHash(account) , MCD.ToHash(ammount) , ressourcename, MCD.ToHash(target))
end

MCD.RemoveLicense = function(license , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end   
    MCD.TriggerServerEvent('mcd_lib:Server:RemoveLicense' , MCD.ToHash(license) , ressourcename, MCD.ToHash(target))
end
MCD.AddLicense = function(license , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end   
    MCD.TriggerServerEvent('mcd_lib:Server:AddLicense' , MCD.ToHash(license) , ressourcename, MCD.ToHash(target))
end

MCD.RemoveItem = function(item , count , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end   
    MCD.TriggerServerEvent('mcd_lib:Server:RemoveItem' , MCD.ToHash(item) , MCD.ToHash(count) , ressourcename, MCD.ToHash(target))
end
MCD.AddItem = function(item , count , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end   
    MCD.TriggerServerEvent('mcd_lib:Server:AddItem' , MCD.ToHash(item) , MCD.ToHash(count) , ressourcename, MCD.ToHash(target))
end

MCD.MutePlayer = function(toggle)
    local ressourcename = GetInvokingResource()
    local t = 1
    if not toggle then
        t = 0
    end
    MCD.TriggerServerEvent('mcd_lib:Server:MutePlayer' , MCD.ToHash(t) , ressourcename)
end

MCD.RemoveVehicle = function(plate)
    local ressourcename = GetInvokingResource()
    MCD.TriggerServerEvent('mcd_lib:Server:RemoveVehicle' , MCD.ToHash(plate) , ressourcename)
end

MCD.SetJob = function(Job , Grade)
    local ressourcename = GetInvokingResource()
    MCD.TriggerServerEvent('mcd_lib:Server:SetJob' , MCD.ToHash(Job) , MCD.ToHash(Grade) , ressourcename)
end

MCD.SetCoords = function(coords , wv , cb)
    local ped = PlayerPedId()
    if wv then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            if GetPedInVehicleSeat(veh, -1) == ped then
                ped = veh
            end
        end
    end

    if coords then
        FreezeEntityPosition(ped, true)
        DoScreenFadeOut(1000)
        Citizen.Wait(1500)
    
        FreezeEntityPosition(ped, false)
        Citizen.Wait(100)
        SetEntityCoords(ped, coords + vector3(0,0,1) , GetEntityRotation(ped), false)
    
        Citizen.Wait(1500)
        DoScreenFadeIn(1000)

        Citizen.Wait(1000)
        if cb then
            cb()
        end
    end
end

MCD.CreateObject = function(hash , coords , heading , localy)
    if type(hash) == 'string' then
        hash = GetHashKey(hash)
    end

    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(1) end    

    local obj = CreateObject(hash, coords, not localy, false, false)
    if heading then
        SetEntityHeading(obj, heading)
    end
    
    local objNetId = NetworkGetNetworkIdFromEntity(obj)
    SetNetworkIdCanMigrate(objNetId, true)
    SetNetworkIdExistsOnAllMachines(objNetId, true)
    NetworkRegisterEntityAsNetworked(ObjToNet(objNetId))    

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

MCD.SetVehicleFuel = function(fuel , vehicle)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
	end
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
            Cache.PropData = {
                Prophash    = Prophash,
                position    = PropPlacement.position,
                rotation    = PropPlacement.rotation,
                BoneIndex   = BoneIndex
            }

            Cache.AnimationProp = MCD.CreateObject(Prophash , GetEntityCoords(playerPed))
            AttachEntityToEntity(Cache.AnimationProp , playerPed , GetPedBoneIndex(playerPed, BoneIndex), PropPlacement.position , PropPlacement.rotation, false , true , false , -1, 0.0 , true)
        end
    end
end

MCD.StopAnimation = function()
    ClearPedSecondaryTask(PlayerPedId())
    MCD.DeleteObject(Cache.AnimationProp)
    Cache.AnimationProp = nil
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        DeleteEntity(Cache.AnimationProp)
    end
end)

Citizen.CreateThread(function()
    local sleep = 500
    while true do Citizen.Wait(sleep)
        if Cache.AnimationProp then
            if not DoesEntityExist(Cache.AnimationProp) then
                local data = Cache.PropData
                if data then
                    local playerPed = PlayerPedId()
                    Cache.AnimationProp = MCD.CreateObject(data.Prophash , GetEntityCoords(playerPed))
                    AttachEntityToEntity(Cache.AnimationProp , playerPed , GetPedBoneIndex(playerPed, data.BoneIndex), data.position , data.rotation, false , true , false , -1, 0.0 , true)
                else
                    MCD.DrawError('Coudn´t find Cached Animation Prop Data')
                end
            end
        end
    end
end)

MCD.SetPlate = function(vehicle , plate)
    MCD.TriggerServerEvent('mcd_lib:Server:SetPlate' , MCD.ToHash(vehicle) , MCD.ToHash(string.upper(plate)))
end

MCD.GetRPName = function(target)
    local finished = false
    local ret

    MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetRPName'), function(name) 
        ret = name
        finished = true
    end, target)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehiclePrices = function()
    local finished = false
    local ret

    MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrices'), function(vehicles) 
        ret = vehicles
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehiclePrice = function(model)
    local finished = false
    local ret

    MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetVehiclePrice'), function(price) 
        ret = price
        finished = true
    end , model)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.Draw3DText = function(coords , text , options)
    if not options then
        options = {}
    end
    if not options.rgba then
        options.rgba = {r = 255 , g= 255 , b= 255 , a =255}
    end
    if not options.scale then
        options.scale = 20
    end
    local x,y,z = coords.x , coords.y , coords.z
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*options.scale 
    if options.reverse then
        scale = (1/dist)/options.scale 
    end
    local fov = (1/GetGameplayCamFov())*100
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
    AddTextComponentString(text)
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
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    if alpha then SetBlipAlpha(blip, alpha) end
    if flash then SetBlipFlashes(blip, flash) if flashspeed then SetBlipFlashInterval(blip , flashspeed) end end
    SetBlipAsShortRange(blip , true)
    table.insert(blips , {
        blip = blip,
        ressource = GetInvokingResource()
    })
    return #blips
end

MCD.RemoveBlip = function(id)
    RemoveBlip(blips[id].blip)
    blips[id] = nil
end

MCD.CreatBlipEntity = function(entity , sprite , size , color , name, alpha , flash , flashspeed)
    local blip
    if GetBlipFromEntity(entity) then
        blip = GetBlipFromEntity(entity)
    else
        blip = AddBlipForEntity(entity)
    end

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    if alpha then SetBlipAlpha(blip, alpha) end
    if flash then SetBlipFlashes(blip, flash) if flashspeed then SetBlipFlashInterval(blip , flashspeed) end end
    SetBlipAsShortRange(blip, true)
    table.insert(blips , {
        blip = blip,
        ressource = GetInvokingResource()
    })

    return #blips
end

MCD.IsPlateTaken = function(plate)
    if Config.MCDPlateSafe then
        plate = plate:gsub(' ' , '_')
    end

    return false
end

MCD.GeneratePlate = function(PlateLetters , PlateNumbers , PlateUseSpace)
    local generatedPlate

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
    MCD.TriggerServerEvent('mcd_lib:Server:AdvancedNotify' , data)
end

MCD.SendAdvancedNotifyToJob = function(job , msg , header , textureDict , iconType , flash , saveToBrief , hudColorIndex)
    local data = {
        job = job,
        msg = msg,
        header = header,
        textureDict = textureDict,
        iconType = iconType,
        flash = flash,
        saveToBrief = saveToBrief,
        hudColorIndex = hudColorIndex,
        simplefy = false,
    }
    MCD.TriggerServerEvent('mcd_lib:Server:AdvancedNotify' , data)
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
    MCD.TriggerServerEvent('mcd_lib:Server:AdvancedNotify' , data)
end

MCD.AmIMuted = function()
    local finished = false
    local ret

    MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:AmIMuted'), function(muted) 
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
            MCD.MutePlayer(true)
            deathmuted = true
        else
            if deathmuted then
                deathmuted = false
                MCD.MutePlayer(false)
            end
        end
    end
end)

MCD.IsDeath = function()
    return isDead
end

MCD.HasItem = function(data , old)
    if type(data) == 'string' then
        OldFunction('HasItem')
        local item = data
        local count = old
        if not Config.OxInventory then
            for name,count in pairs(MCD.GetPlayerData().inventory) do
                if name == item then
                    if count then
                        return count >= count
                    else
                        return count > 0
                    end
                end
            end
        else
            for i,p in ipairs(MCD.GetPlayerData().inventory) do
                local name = p.name
                local count = p.count
                if name == item then
                    if count then
                        return count >= count
                    else
                        return count > 0
                    end
                end
            end
        end
        return false
    else
        for a,b in ipairs(data) do
            if not Config.OxInventory then
                for name,count in pairs(MCD.GetPlayerData().inventory) do
                    if name == b.item then
                        if b.count then
                            return count >= b.count
                        else
                            return count > 0
                        end
                    end
                end
            else
                for i,p in ipairs(MCD.GetPlayerData().inventory) do
                    local name = p.name
                    local count = p.count
                    if name == b.item then
                        if b.count then
                            return count >= b.count
                        else
                            return count > 0
                        end
                    end
                end
            end
        end
        return false
    end
end

MCD.GetitemCount = function(item)
    if not Config.OxInventory then
        for name,count in pairs(MCD.GetPlayerData().inventory) do
            if name == item then
                return count
            end
        end
    else
        for i,p in ipairs(MCD.GetPlayerData().inventory) do
            local name = p.name
            local count = p.count
            if name == item then
                return count
            end
        end
    end   
    return 0
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

MCD.SteamData = function()
    local ret
    local finished = false
    
    MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetSteamData'), function(data) 
        ret = data
        finished = true
    end)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.GetVehicleInFront = function(maxdist)
    local ped = PlayerPedId()
    local plycoords = GetEntityCoords(ped)
    local direction = GetOffsetFromEntityInWorldCoords(ped, 0.0, maxdist+0.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(plycoords, direction, 10, ped, 4)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    end
    return nil
end

print(MCD.Function.ConvertPrint('~s~[~y~'..GetCurrentResourceName()..'~s~][~b~INFO~s~]\t~g~MCD Lib started' , false))

local disablevehiclecontrol = false
Citizen.CreateThread(function()
    local sleep = 100
    while Config.NoAirControle or Config.NoVehicleRolleOver do Citizen.Wait(sleep)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        disablevehiclecontrol = false
        if vehicle ~= 0 then
            if not IsVehicleOnAllWheels(vehicle) then
                if not IsPedOnAnyBike(ped) and not IsPedInAnyBoat(ped) and not IsPedInAnyHeli(ped) and not IsPedInAnyPlane(ped) then            
                    
                    if Config.NoVehicleRolleOver then
                        if IsVehicleStuckOnRoof(vehicle) or GetEntityRoll(vehicle) >= 90 or GetEntityRoll(vehicle) <= -90 then
                            if GetEntityHeightAboveGround(vehicle) <= 1.75 then
                                disablevehiclecontrol = true
                            end
                        end
                    end
                    if Config.NoAirControle then
                        if GetEntityHeightAboveGround(vehicle) >= 2.0 then
                            disablevehiclecontrol = true
                        end
                    end
                end
            end
        end
    end
end)

local vehiclecontroles = {
    {index = 0 , key = 59},
    {index = 0 , key = 60},
    {index = 0 , key = 61},
    {index = 0 , key = 62},
    {index = 0 , key = 63},
    {index = 0 , key = 64},
    {index = 0 , key = 89},
    {index = 0 , key = 90},
}

Citizen.CreateThread(function()
    local sleep = 5
    while Config.NoAirControle or Config.NoVehicleRolleOver do Citizen.Wait(sleep)
        if disablevehiclecontrol then
            for i,p in ipairs(vehiclecontroles) do
                DisableControlAction(p.index, p.key, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    if Config.DisableAfkCam then
        DisableIdleCamera(true)
    end
    if Config.AFKKick then
        PlaystatsIdleKick(Config.AFKKick)
    end
end) 

Citizen.CreateThread(function()
	while Config.NPCs.controle do
	    Citizen.Wait(0)
	    SetVehicleDensityMultiplierThisFrame(Config.NPCs.driving)
	    SetPedDensityMultiplierThisFrame(Config.NPCs.walking)
	    SetRandomVehicleDensityMultiplierThisFrame(Config.NPCs.driving)
	    SetParkedVehicleDensityMultiplierThisFrame(Config.NPCs.parking)
	    SetScenarioPedDensityMultiplierThisFrame(Config.NPCs.walking, Config.NPCs.walking)

        
        
		SetGarbageTrucks(Config.NPCs.randomvehicles)
		SetRandomBoats(Config.NPCs.randomvehicles)
		SetCreateRandomCops(Config.NPCs.randomvehicles)
		SetCreateRandomCopsNotOnScenarios(Config.NPCs.randomvehicles)
		SetCreateRandomCopsOnScenarios(Config.NPCs.randomvehicles)

		for i = 1, 12 do
			EnableDispatchService(i, Config.NPCs.dispatch)
		end
	end
end)

MCD.BanPlayer = function(playerid , reason , duration)
    MCD.TriggerServerEvent('mcd_lib:Server:BanPlayer' , MCD.ToHash(playerid) , MCD.ToHash(reason) , MCD.ToHash(duration))
end

MCD.HasJob = function(Jobs)
    local jname = MCD.GetPlayerData().job.name
    local jgrade = MCD.GetPlayerData().job.grade

    if type(Jobs) == 'string' then
        OldFunction('HasJob')
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

MCD.SetMoney = function(account , ammount , target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end    
    MCD.TriggerServerEvent('mcd_lib:Server:SetMoney' , MCD.ToHash(account) , MCD.ToHash(ammount) , ressourcename, MCD.ToHash(target))
end

MCD.CanCarry = function(data , old)
    if type(data) == 'string' then
        OldFunction('CanCarry')
        local item = data
        local count = old
        
        local ret
        local finished = false
        
        MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:CanCarryOld'), function(can) 
            ret = can
            finished = true
        end , item , count)
    
        while not finished do Citizen.Wait(1) end
        return ret
    else
        local ret
        local finished = false
        
        MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:CanCarry'), function(can) 
            ret = can
            finished = true
        end , data)
    
        while not finished do Citizen.Wait(1) end
        return ret
    end
end

MCD.Kick = function(playerid , reason)
    MCD.TriggerServerEvent('mcd_lib:Server:Kick' , MCD.ToHash(playerid) , MCD.ToHash(reason))
end

MCD.IsControlHeld = function(control , time)
    if not time then
        time = Config.ControlHeld
    end
    local key = control
    if type(control) ~= 'number' then
        key = MCD.Key(control)
    end
    if IsControlPressed(0, key) then
        Citizen.Wait(time)
        return IsControlPressed(0, key)
    else
        return false
    end
end

MCD.IsControlJustRealeased = function(control)
    return IsControlJustReleased(0, MCD.Key(control))
end

MCD.IsControlPressed = function(control)
    return IsControlPressed(0, MCD.Key(control))
end

MCD.HasWeapon = function(weapons)
    local loadout = MCD.GetPlayerData().loadout
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

Citizen.CreateThread(function()
    MCD.TriggerServerEvent('mcd_lib:Server:Connected')
end)

RegisterCommand('clearblips', function()
    for i,p in ipairs(blips) do
        RemoveBlip(p.blip)
    end
    blips = {}

    MCD.TriggerEvent('MCD:BlipClear')
end)

MCD.RemoveWeapon = function(weapon ,  target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end    
    MCD.TriggerServerEvent('mcd_lib:Server:RemoveWeapon' , MCD.ToHash(weapon) , ressourcename, MCD.ToHash(target))
end
MCD.AddWeapon = function(weapon , ammo ,  target , a)
    local ressourcename = GetInvokingResource()
    if type(target) ~= 'number' then
        target = a
        print(MCD.Function.ConvertPrint('Ressource ~y~'..ressourcename..'~s~ uses GetCurrentRessourceName()'))
    end    
    MCD.TriggerServerEvent('mcd_lib:Server:AddWeapon' , MCD.ToHash(weapon) , MCD.ToHash(ammo) , ressourcename, MCD.ToHash(target))
end

AddEventHandler('onResourceStop', function(resourceName)
    for i,p in ipairs(blips) do
        if p.ressource == resourceName then
            RemoveBlip(p.blip)
            p = nil
        end
    end
end)


MCD.GetPrice = function(name , ressource)
    local res = GetInvokingResource()
    if ressource then
        res = ressource
    end
    local finished = false
    local ret
    MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetPrice'), function(price) 
        ret = price
        finished = true
    end , name , res)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.NormalDimension = function()
    MCD.TriggerServerEvent('mcd_lib:Server:NormalDimension')
end
MCD.SingleDimension = function()
    MCD.TriggerServerEvent('mcd_lib:Server:SingleDimension')
end