QBCore = nil
MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)
exports('getSharedObject', function()
	return MCD
end)

local registeredevents = {}

MCD.RegisterEvent = function(event , cb)
    local ressource = GetInvokingResource()
    if not ressource then
        ressource = 'mcd_lib'
    end
	SetTimeout(0, function()
		RegisterNetEvent(MCD.Event(event))
		local event = AddEventHandler(MCD.Event(event), function(...)
			if os then
				cb(source, ...)
			else
				cb(...)
			end
		end)

        if not registeredevents[ressource] then
            registeredevents[ressource] = {}
        end
        table.insert(registeredevents[ressource] , event)
	end)
end

MCD.TriggerEvent = function(event , ...)
	TriggerEvent(MCD.Event(event) , ...)
end


MCD.Config = function()
	return Config
end

MCD.GetLowestGroup = function()
    return Config.ServerGroups[#Config.ServerGroups - 1]
end

MCD.ServerName = function()
    return Config.ServerName
end

MCD.ServerLogo = function()
    return Config.ServerLogo
end

MCD.GetPoliceJobs = function()
	local jobs = {}
	for i,job in pairs(Config.PoliceJobs) do
		jobs[job] = 0
	end
    return jobs
end

keys = {
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
    if type(key) == 'number' then
        return key
    end
    return keys[string.upper(key)]
end
MCD.KeyString = function(key)
    return '~'..keysinput[string.upper(key)]..'~'
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

itemnames = {}
licensenames = {}
Citizen.CreateThread(function()
    if not Config.OxInventory then
        if not os then
            MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetItemNames'), function(items) 
                itemnames = items
            end)
            MCD.TriggerServerCallback(MCD.Event('mcd_lib:Server:GetLicenseNames'), function(licenses) 
                licensenames = licenses
            end)
        else
            local finished = {
                items = false,
                license = false
            }
            
            MySQL.Async.fetchAll('SELECT * FROM items ', {}, function(result)
                for i,p in ipairs(result) do
                    itemnames[p.name] = p.label
                end
                finished.items = true
            end)
            MySQL.Async.fetchAll('SELECT * FROM licenses ', {}, function(result)
                for i,p in ipairs(result) do
                    licensenames[p.type] = p.label
                end
                finished.license = true
            end)
            
            if QBCore then
                QBCore.Functions.CreateCallback(MCD.Event('mcd_lib:Server:GetItemNames'), function(src , cb)
                    while not finished.items do Citizen.Wait(1) end
                    cb(itemnames)
                end)
                QBCore.Functions.CreateCallback(MCD.Event('mcd_lib:Server:GetLicenseNames'), function(src , cb)
                    while not finished.items do Citizen.Wait(1) end
                    cb(licensenames)
                end)
            else
                ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetItemNames'), function(src , cb)
                    while not finished.items do Citizen.Wait(1) end
                    cb(itemnames)
                end)
                ESX.RegisterServerCallback(MCD.Event('mcd_lib:Server:GetLicenseNames'), function(src , cb)
                    while not finished.items do Citizen.Wait(1) end
                    cb(licensenames)
                end)
            end
        end
    end
end)

MCD.ItemName = function(item)
    if Config.OxInventory then
        local name = exports.ox_inventory:Items()[item].label
        if not name then
            name = 'Item name for '..item..' does not exist'
        end
        return name
    else
        local name = itemnames[item]
        if not name then
            name = 'Item name for '..item..' does not exist'
        end
        return name
    end
end

MCD.LiceneName = function(item)
    local name = licensenames[item]
    if not name then
        name = 'License Name doesnt exist for ' .. item
    end
    return name
end

MCD.WeaponName = function(weapon)
    if QBCore then
        return 'Doesnt work with QBCore'
    end
    if string.find(weapon, "weapon_") then
        if Config.OxInventory then
            return MCD.ItemName(weapon)
        else
            return ESX.GetWeaponLabel(string.upper(weapon))
        end
    else
        if Config.OxInventory then
            return MCD.ItemName('WEAPON_'..weapon)
        else
            return ESX.GetWeaponLabel(string.upper('WEAPON_'..weapon))
        end
    end
end

MCD.Debug = function(msg)
    local res = GetInvokingResource()
	if not msg then msg = 'no message specified' end
    if not res then res = 'mcd_lib' end
    msg = msg:gsub('~s~' , '~p~')

	local num = math.random(1000,9999)
	local text = '[~b~'..num..'~s~][~y~'..GetInvokingResource()..'~s~] ~p~' .. msg
    print(MCD.Function.ConvertPrint(text))
end

MCD.DrawError = function(msg)
    local res = GetInvokingResource()
	if not msg then msg = 'no message specified' end
    if not res then res = 'mcd_lib' end
    msg = msg:gsub('~s~' , '~r~')

	local text = '[~y~'..res..'~s~][~o~ERROR~s~] ~r~' .. msg
    print(MCD.Function.ConvertPrint(text))
end

MCD.DrawInfo = function(msg)
    local res = GetInvokingResource()
	if not msg then msg = 'no message specified' end
    if not res then res = 'mcd_lib' end
    msg = msg:gsub('~s~' , '~g~')

	local text = '[~y~'..res..'~s~][~b~INFO~s~] ~g~' .. msg
    print(MCD.Function.ConvertPrint(text))
end

MCD.CheckFunktionSpeed = function(func , ...)
	local s = MCD.GetCurrentTime()
	func(...)
	local e = MCD.GetCurrentTime()
	return math.floor(MCD.Math.TimeDifference(s , e)*1000)..'ms'
end

MCD.BenchmarkFunction = function(func , fast , superfast)    
    local start = MCD.GetCurrentTime()
    MCD.DrawInfo('Test Started')
    local times = {}
    local max = 100
    local sleep = 400
    if superfast then
        max = 10
        sleep = 0
    end
    local msgs = {}

    if not fast then
        for i=0, max  do
            for a=1, 10  do
                local b = a*10
                if i/max*100 > b then
                    if not msgs[b] then
                        msgs[b] = true
                        MCD.DrawInfo(b..'%')
                    end
                end
            end
            local ms = tonumber(MCD.CheckFunktionSpeed(func):match("%d+"))
            table.insert(times , {
                duration = ms
            })
        end
    else
        SetTimeout(0, function()
            for i=0, max  do
                Citizen.Wait(sleep)
                SetTimeout(0, function()
                    local ms = tonumber(MCD.CheckFunktionSpeed(func):match("%d+"))
                    table.insert(times , {
                        duration = ms
                    })
                end)
            end
        end)

        while #times ~= max do
            local i = #times
            for a=1, 10  do
                local b = a*10
                if i/max*100 > b then
                    if not msgs[b] then
                        msgs[b] = true
                        MCD.DrawInfo(b..'%')
                    end
                end
            end
            Citizen.Wait(1)
        end
    end

    MCD.DrawInfo('Finished! Loading results')

    local chilltime = max*sleep
    local ms = times[1].duration
    for i,p in ipairs(times) do
        ms = (ms+p.duration)/2
    end
    ms = math.floor(ms)
    local run = MCD.Math.TimeDifference(start , MCD.GetCurrentTime())
    local runtime =  MCD.Math.Round(run , 1)..'s'
   
    MCD.DrawInfo('The Function Took in average ' .. ms .. 'ms and the proccess ' .. runtime)
    if fast then
        MCD.DrawInfo('With no Function Delay it would only took ' .. MCD.Math.Round(((run*1000)-chilltime)/1000 , 1)..'seconds')
    end
end

Citizen.CreateThread(function()
	while not Config do Citizen.Wait(1) end
	if GetResourceState('ox_inventory') ~= 'missing' then
		Config.OxInventory = true
	end
    
	if GetResourceState('okokBilling') ~= 'missing' then
		Config.UsingOkokBilling = true
	end

	if GetResourceState('qb-core') ~= 'missing' then
        QBCore = exports['qb-core']:GetCoreObject()
	end
end)

MCD.GetCurrentTime = function()
    if os then
        return os.clock()
    else
        return GetGameTimer()
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if registeredevents[resourceName] then
        for i,event in pairs(registeredevents[resourceName]) do
            RemoveEventHandler(event)
        end
        registeredevents[resourceName] = {}
    end
end)