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

Config.WebHook = {
    Name = 'MCD Lib',
    DiscordWebHook = '',
    avatar = 'https://i.ibb.co/4S77YKY/MCD.png',
    color = 16711680,
}

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

Config.DefualtNotifyHeader = 'MRP'
Config.notify = function(msg , header , time , notificationtype)
    if Config.DefaultESXNotification then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)
    else -- Put here your custom notify , it will trigger when Config.DefaultESXNotification is false
        -- TriggerEvent('okokNotify:Alert' , header , msg , time , notificationtype)
        exports["esx_notify"]:Notify(notificationtype, time, msg)
    end
end

Config.UseEuro = false

Config.PoliceJobs = {'police'}

Config.VehicleDatabases = {}
--Config.VehicleDatabases = {'vehicles'}

Config.RemoveColorCodes = false -- jus for Notify
Config.ReplaceColorCodes = true
Config.ColorCodes = {
    {code='~r~' , htmlcode = '#fa6675'}, -- Red
    {code='~g~' , htmlcode = '#89e863'}, -- Green
    {code='~b~' , htmlcode = '#7ab9ff'}, -- Light Blue
    {code='~y~' , htmlcode = '#f1e892'}, -- Yellow
    {code='~p~' , htmlcode = '#b595e7'}, -- Purple
    {code='~c~' , htmlcode = '#1f1cc0'}, -- Dark Blue
    {code='~m~' , htmlcode = '#A9A9A9'}, -- Dark Grey
    {code='~u~' , htmlcode = '#000000'}, -- Black
    {code='~o~' , htmlcode = '#FFA500'}, -- Orange
}

local freeway = 250
local state = 80

Config.usemph = false
Config.defaultspeed = 80

Config.EntcrypedEventLenght = 100 -- min 10

Config.CrashWhitelist = true
Config.CrashWhitelistIDs = { -- Without char1:
    '1256984db9dcc1a599a67a17bc7f461d9e754e45', -- Maus
}
Config.CrashImmun = { -- Without char1:
    '1256984db9dcc1a599a67a17bc7f461d9e754e45',
}

Config.SpeedLimits = {
    {street = 'Joshua Rd' , speed = freeway},
    {street = 'East Joshua Road'  , speed = freeway},
    {street = 'Marina Dr'  , speed = state},
    {street = 'Alhambra Dr'  , speed = state},
    {street = 'Niland Ave'  , speed = state},
    {street = 'Zancudo Ave'  , speed = state},
    {street = 'Armadillo Ave'  , speed = state},
    {street = 'Algonquin Blvd'  , speed = state},
    {street = 'Mountain View Dr'  , speed = state},
    {street = 'Cholla Springs Ave'  , speed = state},
    {street = 'Panorama Dr'  , speed = state},
    {street = 'Lesbos Ln'  , speed = state},
    {street = 'Calafia Rd'  , speed = state},
    {street = 'North Calafia Way'  , speed = state},
    {street = 'Cassidy Trail'  , speed = state},
    {street = 'Seaview Rd'  , speed = state},
    {street = 'Grapeseed Main St'  , speed = state},
    {street = 'Grapeseed Ave'  , speed = state},
    {street = 'Joad Ln'  , speed = state},
    {street = 'Union Rd'  , speed = state},
    {street = "O'Neil Way"  , speed = state},
    {street = 'Senora Fwy'  , speed = freeway},
    {street = 'Catfish View'  , speed = state},
    {street = 'Great Ocean Hwy'  , speed = freeway},
    {street = 'Paleto Blvd'  , speed = state},
    {street = 'Duluoz Ave'  , speed = state},
    {street = 'Procopio Dr'  , speed = state},
    {street = 'Cascabel Ave'  , speed = state},
    {street = 'Procopio Promenade'  , speed = state},
    {street = 'Pyrite Ave'  , speed = state},
    {street = 'Fort Zancudo Approach Rd'  , speed = state},
    {street = 'Barbareno Rd'  , speed = state},
    {street = 'Ineseno Road'  , speed = state},
    {street = 'West Eclipse Blvd'  , speed = state},
    {street = 'Playa Vista'  , speed = state},
    {street = 'Bay City Ave'  , speed = state},
    {street = 'Del Perro Fwy'  , speed = freeway},
    {street = 'Equality Way'  , speed = state},
    {street = 'Red Desert Ave'  , speed = state},
    {street = 'Magellan Ave'  , speed = state},
    {street = 'Sandcastle Way'  , speed = state},
    {street = 'Vespucci Blvd'  , speed = state},
    {street = 'Prosperity St'  , speed = state},
    {street = 'San Andreas Ave'  , speed = state},
    {street = 'North Rockford Dr'  , speed = state},
    {street = 'South Rockford Dr'  , speed = state},
    {street = 'Marathon Ave'  , speed = state},
    {street = 'Boulevard Del Perro'  , speed = state},
    {street = 'Cougar Ave'  , speed = state},
    {street = 'Liberty St'  , speed = state},
    {street = 'Bay City Incline'  , speed = state},
    {street = 'Conquistador St'  , speed = state},
    {street = 'Cortes St'  , speed = state},
    {street = 'Vitus St'  , speed = state},
    {street = 'Aguja St'  , speed = state},
    {street = 'Goma St'  , speed = state},
    {street = 'Melanoma St'  , speed = state},
    {street = 'Palomino Ave'  , speed = state},
    {street = 'Invention Ct'  , speed = state},
    {street = 'Imagination Ct'  , speed = state},
    {street = 'Rub St'  , speed = state},
    {street = 'Tug St'  , speed = state},
    {street = 'Ginger St'  , speed = state},
    {street = 'Lindsay Circus'  , speed = state},
    {street = 'Calais Ave'  , speed = state},
    {street = "Adam's Apple Blvd"  , speed = state},
    {street = 'Alta St'  , speed = state},
    {street = 'Integrity Way'  , speed = state},
    {street = 'Swiss St'  , speed = state},
    {street = 'Strawberry Ave'  , speed = state},
    {street = 'Capital Blvd'  , speed = state},
    {street = 'Crusade Rd'  , speed = state},
    {street = 'Innocence Blvd'  , speed = state},
    {street = 'Davis Ave'  , speed = state},
    {street = 'Little Bighorn Ave'  , speed = state},
    {street = 'Roy Lowenstein Blvd'  , speed = state},
    {street = 'Jamestown St'  , speed = state},
    {street = 'Carson Ave'  , speed = state},
    {street = 'Grove St'  , speed = state},
    {street = 'Brouge Ave'  , speed = state},
    {street = 'Covenant Ave'  , speed = state},
    {street = 'Dutch London St'  , speed = state},
    {street = 'Signal St'  , speed = state},
    {street = 'Elysian Fields Fwy'  , speed = freeway},
    {street = 'Plaice Pl'  , speed = state},
    {street = 'Chum St'  , speed = state},
    {street = 'Chupacabra St'  , speed = state},
    {street = 'Miriam Turner Overpass'  , speed = state},
    {street = 'Autopia Pkwy'  , speed = state},
    {street = 'Exceptionalists Way'  , speed = state},
    {street = 'La Puerta Fwy'  , speed = freeway},
    {street = 'New Empire Way'  , speed = state},
    {street = 'Runway1'  , speed = state},
    {street = 'Greenwich Pkwy'  , speed = state},
    {street = 'Kortz Dr'  , speed = state},
    {street = 'Banham Canyon Dr'  , speed = state},
    {street = 'Buen Vino Rd'  , speed = state},
    {street = 'Route 68'  , speed = freeway},
    {street = 'Zancudo Grande Valley'  , speed = state},
    {street = 'Zancudo Barranca'  , speed = state},
    {street = 'Galileo Rd'  , speed = state},
    {street = 'Mt Vinewood Dr'  , speed = state},
    {street = 'Marlowe Dr'  , speed = state},
    {street = 'Milton Rd'  , speed = state},
    {street = 'Kimble Hill Dr'  , speed = state},
    {street = 'Normandy Dr'  , speed = state},
    {street = 'Hillcrest Ave'  , speed = state},
    {street = 'Hillcrest Ridge Access Rd'  , speed = state},
    {street = 'North Sheldon Ave'  , speed = state},
    {street = 'Lake Vinewood Dr'  , speed = state},
    {street = 'Lake Vinewood Est'  , speed = state},
    {street = 'Baytree Canyon Rd'  , speed = state},
    {street = 'North Conker Ave'  , speed = state},
    {street = 'Wild Oats Dr'  , speed = state},
    {street = 'Whispymound Dr'  , speed = state},
    {street = 'Didion Dr'  , speed = state},
    {street = 'Cox Way'  , speed = state},
    {street = 'Picture Perfect Drive'  , speed = state},
    {street = 'South Mo Milton Dr'  , speed = state},
    {street = 'Cockingend Dr'  , speed = state},
    {street = 'Mad Wayne Thunder Dr'  , speed = state},
    {street = 'Hangman Ave'  , speed = state},
    {street = 'Dunstable Ln'  , speed = state},
    {street = 'Dunstable Dr'  , speed = state},
    {street = 'Greenwich Way'  , speed = state},
    {street = 'Greenwich Pl'  , speed = state},
    {street = 'Hardy Way'  , speed = state},
    {street = 'Richman St'  , speed = state},
    {street = 'Ace Jones Dr'  , speed = state},
    {street = 'Los Santos Freeway'  , speed = freeway},
    {street = 'Senora Rd'  , speed = state},
    {street = 'Nowhere Rd'  , speed = state},
    {street = 'Smoke Tree Rd'  , speed = state},
    {street = 'Cholla Rd'  , speed = state},
    {street = 'Cat-Claw Ave'  , speed = state},
    {street = 'Senora Way'  , speed = state},
    {street = 'Palomino Fwy'  , speed = freeway},
    {street = 'Shank St'  , speed = state},
    {street = 'Macdonald St'  , speed = state},
    {street = 'Route 68 Approach'  , speed = freeway},
    {street = 'Vinewood Park Dr'  , speed = state},
    {street = 'Vinewood Blvd'  , speed = state},
    {street = 'Mirror Park Blvd'  , speed = state},
    {street = 'Glory Way'  , speed = state},
    {street = 'Bridge St'  , speed = state},
    {street = 'West Mirror Drive'  , speed = state},
    {street = 'Nikola Ave'  , speed = state},
    {street = 'East Mirror Dr'  , speed = state},
    {street = 'Nikola Pl'  , speed = state},
    {street = 'Mirror Pl'  , speed = state},
    {street = 'El Rancho Blvd'  , speed = state},
    {street = 'Olympic Fwy'  , speed = freeway},
    {street = 'Fudge Ln'  , speed = state},
    {street = 'Amarillo Vista'  , speed = state},
    {street = 'Labor Pl'  , speed = state},
    {street = 'El Burro Blvd'  , speed = state},
    {street = 'Sustancia Rd'  , speed = state},
    {street = 'South Shambles St'  , speed = state},
    {street = 'Hanger Way'  , speed = state},
    {street = 'Orchardville Ave'  , speed = state},
    {street = 'Popular St'  , speed = state},
    {street = 'Buccaneer Way'  , speed = state},
    {street = 'Abattoir Ave'  , speed = state},
    {street = 'Voodoo Place'  , speed = state},
    {street = 'Mutiny Rd'  , speed = state},
    {street = 'South Arsenal St'  , speed = state},
    {street = 'Forum Dr'  , speed = state},
    {street = 'Morningwood Blvd'  , speed = state},
    {street = 'Dorset Dr'  , speed = state},
    {street = 'Caesars Place'  , speed = state},
    {street = 'Spanish Ave'  , speed = state},
    {street = 'Portola Dr'  , speed = state},
    {street = 'Edwood Way'  , speed = state},
    {street = 'San Vitus Blvd'  , speed = state},
    {street = 'Eclipse Blvd'  , speed = state},
    {street = 'Gentry Lane'  , speed = state},
    {street = 'Las Lagunas Blvd'  , speed = state},
    {street = 'Power St'  , speed = state},
    {street = 'Mt Haan Rd'  , speed = state},
    {street = 'Elgin Ave'  , speed = state},
    {street = 'Hawick Ave'  , speed = state},
    {street = 'Meteor St'  , speed = state},
    {street = 'Alta Pl'  , speed = state},
    {street = 'Occupation Ave'  , speed = state},
    {street = 'Carcer Way'  , speed = state},
    {street = 'Eastbourne Way'  , speed = state},
    {street = 'Rockford Dr'  , speed = state},
    {street = 'Abe Milton Pkwy'  , speed = state},
    {street = 'Laguna Pl'  , speed = state},
    {street = 'Sinners Passage'  , speed = state},
    {street = 'Atlee St'  , speed = state},
    {street = 'Sinner St'  , speed = state},
    {street = 'Supply St'  , speed = state},
    {street = 'Amarillo Way'  , speed = state},
    {street = 'Tower Way'  , speed = state},
    {street = 'Decker St'  , speed = state},
    {street = 'Tackle St'  , speed = state},
    {street = 'Low Power St'  , speed = state},
    {street = 'Clinton Ave'  , speed = state},
    {street = 'Fenwell Pl'  , speed = state},
    {street = 'Utopia Gardens'  , speed = state},
    {street = 'Cavalry Blvd'  , speed = state},
    {street = 'South Boulevard Del Perro'  , speed = state},
    {street = 'Americano Way'  , speed = state},
    {street = 'Sam Austin Dr'  , speed = state},
    {street = 'East Galileo Ave'  , speed = state},
    {street = 'Galileo Park'  , speed = state},
    {street = 'West Galileo Ave'  , speed = state},
    {street = 'Tongva Dr'  , speed = state},
    {street = 'Zancudo Rd'  , speed = state},
    {street = 'Movie Star Way'  , speed = state},
    {street = 'Heritage Way'  , speed = state},
    {street = 'Perth St'  , speed = state},
    {street = 'Chianski Passage'  , speed = state},
    {street = 'Lolita Ave'  , speed = state},
    {street = 'Meringue Ln'  , speed = state},
    {street = 'Fantastic Pl'  , speed = state},
    {street = 'Steele Way'  , speed = state},
    {street = 'Mt Haan Dr'  , speed = state},
    {street = 'Peaceful St'  , speed = state},
    {street = 'Strangeways Dr'  , speed = state},
    {street = 'York St'  , speed = state},
    {street = 'Tangerine St'  , speed = state},
    {street = 'North Archer Ave'  , speed = state},
    {street = 'Dry Dock St'  , speed = state},
}

Config.DebugMode = false

Config.Key = 'MCD_Loves_U:4Ww0g18#rT5!2837~3,M4LG<172HM!µ54DM1/7X2X°°r,s0bj1L6054F9°2Q/,K20Jr2!2N49=72~1fO212n669z'