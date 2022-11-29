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

MCD.RemoveMoney = function(account , ammount , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveMoney'), account , ammount , ressourcename, target)
end
MCD.AddMoney = function(account , ammount , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AddMoney'), account , ammount , ressourcename, target)
end

MCD.RemoveLicense = function(license , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveLicense'), license , ressourcename, target)
end
MCD.AddLicense = function(license , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AddLicense'), license , ressourcename, target)
end

MCD.RemoveItem = function(item , count , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveItem'), item , count , ressourcename, target)
end
MCD.AddItem = function(item , count , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AddItem'), item , count , ressourcename, target)
end

MCD.MutePlayer = function(toggle , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:MutePlayer'), toggle , ressourcename, target)
end

MCD.RemoveVehicle = function(plate , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:RemoveVehicle'), plate , ressourcename)
end

MCD.SetJob = function(Job , Grade , ressourcename)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:SetJob'), Job , Grade , ressourcename, target)
end

MCD.SetCoords = function(coords , wv)
    local ped = PlayerPedId()
    wv = true
    if wv then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            if GetPedInVehicleSeat(veh, -1) == ped then
                ped = veh
            end
        end
    end
    FreezeEntityPosition(ped, true)
    DoScreenFadeOut(1000)
    Citizen.Wait(1500)

    FreezeEntityPosition(ped, false)
    Citizen.Wait(100)
    SetEntityCoords(ped, coords + vector3(0,0,1) , GetEntityRotation(ped), false)

    Citizen.Wait(1500)
    DoScreenFadeIn(1000)
end

MCD.CreateObject = function(hash , coords , heading , localy)
    if type(hash) == 'string' then
        hash = GetHashKey(hash)
    end
    local obj = CreateObject(hash, coords, not localy, false, false)
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

MCD.Draw3DText = function(coords , text , options)
    local x,y,z = coords.x , coords.y , coords.z
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
    table.insert(blips , blip)
    return #blips
end

MCD.RemoveBlip = function(id)
    RemoveBlip(blips[id])
    blips[id] = nil
end

MCD.CreatBlipEntity = function(entity , sprite , size , color , name, alpha , flash , flashspeed)
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
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    if alpha then SetBlipAlpha(blip, alpha) end
    if flash then SetBlipFlashes(blip, flash) if flashspeed then SetBlipFlashInterval(blip , flashspeed) end end
    SetBlipAsShortRange(blip, true)

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
    TriggerServerEvent(MCD.Event('mcd_lib:Server:AdvancedNotify'), data)
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

MCD.HasItem = function(data , old)
    if type(data) == 'string' then
        OldFunction('HasItem')
        local item = data
        local count = old
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
    else
        for a,b in ipairs(data) do
            for i,p in ipairs(ESX.GetPlayerData().inventory) do
                if p.name == b.item then
                    if b.count then
                        return p.count >= b.count
                    else
                        return p.count > 0
                    end
                end
            end
        end
        return false
    end
end

MCD.GetitemCount = function(item)
    for i,p in ipairs(ESX.GetPlayerData().inventory) do
        if p.name == item then
            return p.count
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
    
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetSteamData'), function(data) 
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
	while true do
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
    TriggerServerEvent(MCD.Event('mcd_lib:Server:BanPlayer') , playerid , reason , duration)
end

MCD.HasJob = function(Jobs)
    local jname = MCD.GetPlayerData().job.name
    local jgrade = MCD.GetPlayerData().job.grade

    if Jobs == 'string' then
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

MCD.SetMoney = function(account , ammount , ressourcename, target)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:SetMoney'), account , ammount , ressourcename, target)
end

MCD.CanCarry = function(data , old)
    if type(data) == 'string' then
        OldFunction('CanCarry')
        local item = data
        local count = old
        
        local ret
        local finished = false
        
        ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:CanCarryOld'), function(can) 
            ret = can
            finished = true
        end , item , count)
    
        while not finished do Citizen.Wait(1) end
        return ret
    else
        local ret
        local finished = false
        
        ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:CanCarry'), function(can) 
            ret = can
            finished = true
        end , data)
    
        while not finished do Citizen.Wait(1) end
        return ret
    end
end

MCD.Kick = function(playerid , reason)
    TriggerServerEvent(MCD.Event('mcd_lib:Server:Kick') , playerid , reason)
end

local held = {}
MCD.IsControlHeld = function(control)
    return held[string.upper(control)]
end

MCD.IsControlJustRealeased = function(control)
    return IsControlJustReleased(0, keys[control])
end

MCD.IsControlPressed = function(control)
    return IsControlPressed(0, keys[control])
end

Cache.held = {}
Citizen.CreateThread(function()
    local sleep = 10
    while true do Citizen.Wait(sleep)
        for keyname,control in pairs(keys) do
            if IsControlPressed(0, control) then
                if Cache.held[keyname] then
                    local timediff = MCD.GetTimeDifference(Cache.held[keyname] , MCD.GetCurrentTime())
                    if math.floor(timediff*1000) >= Config.ControlHeld then
                        held[keyname] = true
                    else
                        held[keyname] = false
                    end
                else
                    Cache.held[keyname] = MCD.GetCurrentTime()
                    held[keyname] = false
                end
            else
                Cache.held[keyname] = nil
                held[keyname] = false
            end
        end
    end
end)

MCD.HasWeapon = function(weapons)
    local ret
    local finished = false
    
    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:HasWeapon'), function(has) 
        ret = has
        finished = true
    end , weapons)

    while not finished do Citizen.Wait(1) end
    return ret
end

MCD.LiceneName = function(license)
    local finished = false
    local ret

    ESX.TriggerServerCallback(MCD.Event('mcd_lib:Server:ItemName'), function(licenseLable) 
        ret = licenseLable
        finished = true
    end, license)

    while not finished do Citizen.Wait(1) end
    return ret
end

Citizen.CreateThread(function()
    TriggerServerEvent(MCD.Event('mcd_lib:Server:Connected'))
end)