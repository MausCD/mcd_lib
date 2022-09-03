Config = {}

Config.Locale = 'de'
Config.ServerName = 'MRP'

Config.defaultBinding = 'F6'
Config.defaultMapper = 'KEYBOARD'
Config.UsingOkokBilling = false

Config.PrintDiscord = false

Config.MarkerSpeed = 3
Config.ControllSpeed = 7.5
Config.HelpTextSpeed = 60

Config.MuteOnPlayerDeath = true

-- From Highest to lowest
Config.ServerGroups = {
    'inhaber',
    'projektleitung',
    'developer',
    'superadministrator',
    'teamleitung',
    'administrator',
    'fraktionsverwaltung',
    'headmoderator',
    'moderator',
    'testmoderator',
    'user',
}

Config.DefaultESXNotification = false

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
    '1256984db9dcc1a599a67a17bc7f461d9e754e45', -- Maus
}
Config.CrashImmun = { -- Without char1:
    '1256984db9dcc1a599a67a17bc7f461d9e754e45',
}

Config.DebugMode = false

Config.Key = 'MCD_Loves_U:4Ww0g18#rT5!2837~3,M4LG<172HM!µ54DM1/7X2X°°r,s0bj1L6054F9°2Q/,K20Jr2!2N49=72~1fO212n669z'