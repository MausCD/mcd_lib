Config = {}

Config.Locale = 'de'
Config.ServerName = 'MRP'

Config.ServerLogo = 'https://cdn.discordapp.com/attachments/982381663906562098/989575093489401876/newliferplogoanimationtransparent.gif'

Config.defaultBinding = 'F6'
Config.defaultMapper = 'KEYBOARD'
Config.UsingOkokBilling = false

Config.PrintDiscord = false

Config.MarkerSpeed = 3
Config.ControllSpeed = 7.5
Config.HelpTextSpeed = 60

Config.ControlHeld = 300

Config.MuteOnPlayerDeath = true
Config.NoAirControle = true
Config.NoVehicleRolleOver = true
Config.DisableAfkCam = true
Config.AFKKick = 60

Config.NPCs = {
    parking = 0.8,
    driving = 0.8,
    walking = 0.8,
    randomvehicles = false, -- Garbage Truck , Police , Amublance ...
    dispatch = false,
}

-- From Highest to lowest
Config.ServerGroups = {
    'inhaber',
    'projektleitung',
    'entwicklungsleiter',
    'superadministrator',
    'developer',
    'teamleitung',
    'administrator',
    'fraktionsverwaltung',
    'headmoderator',
    'moderator',
    'testmoderator',
    'user',
}

Config.UnbanPermission = 'testmoderator'
Config.AllowConsole = true

Config.AutoBanAfterKicks = 0 -- 0 to disable
Config.AutoBanDuration = 2*60 -- in min | 0 for permanent

Config.DefaultESXNotification = true

Config.DefaultNotifyHeader = 'MRP'
Config.notify = function(msg , header , time , notificationtype)
    if Config.DefaultESXNotification then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)
    else -- Put here your custom notify , it will trigger when Config.DefaultESXNotification is false
        exports["esx_notify"]:Notify(notificationtype, time, msg)
    end
end

Config.UseEuro = false

Config.PoliceJobs = {'police'}

Config.VehicleDatabases = {}
--Config.VehicleDatabases = {'vehicles'}

Config.EntcrypedEventLenght = 100 -- min 10

Config.CrashWhitelist = true
Config.CrashWhitelistIDs = { -- Without char1:
}
Config.CrashImmun = { -- Without char1:
}

Config.SudoCommand = {
    allow = true,
    console = true,
    group = 'developer'
}

Config.UpdateMsg = true
Config.DebugMode = false

Config.Key = 'MCD_Loves_U:413e=7ws17m2165nm_5~r545=02n27;H05IT55w56790553451A|38°73i588M4pS20R22<07,3Q3u51~#49p!pv'