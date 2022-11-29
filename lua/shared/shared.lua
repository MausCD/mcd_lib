MCD = {}
AddEventHandler('mcd_lib:getSharedObject', function(cb)
	cb(MCD)
end)
exports('getSharedObject', function()
	return MCD
end)
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