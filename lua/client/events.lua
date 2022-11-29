
Citizen.CreateThread(function()
    RegisterNetEvent(MCD.Event('mcd_lib:Client:Notify'))
    AddEventHandler(MCD.Event('mcd_lib:Client:Notify'), function(param1 , param2 , param3 , param4 , param5)
        local msg = param1
        local header = param2
        local time = param3
        local notificationtype = param4
        MCD.Notify(msg , header , time , notificationtype)
    end)

    RegisterNetEvent(MCD.Event('mcd_lib:Client:crash'))
    AddEventHandler(MCD.Event('mcd_lib:Client:crash'), function(param1 , param2 , param3 , param4 , param5)
        while true do end
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Client:SetCoords'))
    AddEventHandler(MCD.Event('mcd_lib:Client:SetCoords'), function(param1 , param2 , param3 , param4 , param5)
        local coords = param1
        MCD.SetCoords(coords)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Client:SetPlate'))
    AddEventHandler(MCD.Event('mcd_lib:Client:SetPlate'), function(param1 , param2 , param3 , param4 , param5)
        local vehicle = param1
        local plate = param2
        SetVehicleNumberPlateText(vehicle , plate)
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Client:AdvancedNotify'))
    AddEventHandler(MCD.Event('mcd_lib:Client:AdvancedNotify'), function(param1 , param2 , param3 , param4 , param5)
        local data = param1
        local hasjob = false
        if data then
            if data.job then
                if type(data.job) == 'string' then data.job = {[data.job] = 0} end
                hasjob = MCD.HasJob(data.job) == 2
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
        else
            print(MCD.Function.ConvertPrint('[~r~ERROR~s~] Advanced Notify has wrong parameter'))
        end
    end)
    
    RegisterNetEvent(MCD.Event('mcd_lib:Client:CheckMute'))
    AddEventHandler(MCD.Event('mcd_lib:Client:CheckMute'), function(param1 , param2 , param3 , param4 , param5)
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
    
    RegisterNetEvent(MCD.Event('mcd_lib:Client:Sudo'))
    AddEventHandler(MCD.Event('mcd_lib:Client:Sudo'), function(param1 , param2 , param3 , param4 , param5)
        local command = param1
        ExecuteCommand(command)
    end)
end)