MCD.RegisterEvent('mcd_lib:Client:Notify' , function(msg , header , time , notificationtype)
    MCD.Notify(msg , header , time , notificationtype)
end)

MCD.RegisterEvent('mcd_lib:Client:crash' , function()
    while true do end
end)

MCD.RegisterEvent('mcd_lib:Client:SetCoords' , function(coords , withvehicle)
    MCD.SetCoords(coords , withvehicle)
end)

MCD.RegisterEvent('mcd_lib:Client:SetPlate' , function(vehicle , plate)
    SetVehicleNumberPlateText(vehicle , plate)
end)

MCD.RegisterEvent('mcd_lib:Client:AdvancedNotify' , function(data)
    local hasjob = false
    if data then
        if data.job then
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

MCD.RegisterEvent('mcd_lib:Client:CheckMute' , function()
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

MCD.RegisterEvent('mcd_lib:Client:Sudo' , function(command)
    ExecuteCommand(command)
end)