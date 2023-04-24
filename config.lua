Config = {}

Config.Locale = 'en'
Config.ServerName = 'Servername'

Config.ServerLogo = 'logo URL'
Config.DiscordLink = 'https://discord.gg/123abc'

Config.defaultBinding = 'F6'
Config.defaultMapper = 'KEYBOARD'

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

Config.CreateFakeEvents = true

Config.CreateBackups = true
Config.DeleteOldBackups = true 
Config.CreateBackupCommand = 'developer'

Config.NPCs = {
    controle = true,
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

Config.DefaultESXNotification = false

Config.DefaultNotifyHeader = 'Servername'
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
    '1256984db7bc7f49dcc1a599a67a161d9e754e45',
}
Config.CrashImmun = { -- Without char1:
    '1256984db9dcc1a599a67a17bc7f461d9e754e45',
}

Config.SudoCommand = {
    allow = true,
    console = true,
    group = 'developer'
}

Config.MCDPlateSafe = false

Config.UpdateMsg = false
Config.DebugMode = false

Config.DisableBans = false

Config.Key = 'MCD_Loves_U:<uz!1_7z0VJ!o33>4j9B36rW9&Rm7l24u=8PW5C3dAW§°925#831N5sg#6s69!1cE36a7p3xN~u#X62&µ!0n7!f6'