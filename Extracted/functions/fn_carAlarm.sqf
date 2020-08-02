/*
	Author: Karel Moricky and Nelson Duarte

	Description:
	Play car alarm effect.

	Parameter(s):
		0: STRING - mode, can be:
			"init" - add "hit" and "GetIn" event handler on the car
			"play" - play the alarm effect
		1: OBJECT - car

	Examples:
		this call bis_fnc_carAlarm;
		["play",vehicle player] spawn bis_fnc_carAlarm;

	Returns:
	NOTHING
*/

params [
	["_mode","init",[""]],
	["_car",if !(isnil "this") then {this} else {objnull},[objNull]]
];

switch tolower _mode do {
	case "init": {
		if (ismultiplayer) then {
			_car addmpeventhandler [
				"mphit",
				{
					["play",_this select 0] remoteexec ["bis_fnc_carAlarm"];
					[_this select 0,_thiseventhandler] spawn {(_this select 0) removempeventhandler ["mphit",_this select 1];};
					//(_this select 0) removempeventhandler ["mphit",_thiseventhandler];
				}
			];
		} else {
			_car addeventhandler [
				"hit",
				{
					["play",_this select 0] remoteexec ["bis_fnc_carAlarm"];
					[_this select 0,_thiseventhandler] spawn {(_this select 0) removeeventhandler ["hit",_this select 1];};
					//(_this select 0) removeeventhandler ["hit",_thiseventhandler];
				}
			];
		};
		_car addeventhandler [
			"getin",
			{
				["play",_this select 0] remoteexec ["bis_fnc_carAlarm"];
				[_this select 0,_thiseventhandler] spawn {(_this select 0) removeeventhandler ["getin",_this select 1];};
				//(_this select 0) removeeventhandler ["getin",_thiseventhandler];
			}
		];
	};
	case "play": {
		if !(canSuspend) exitwith {_this spawn bis_fnc_carAlarm;};
		if (_car getvariable ["bis_fnc_carAlarm_busy",false]) exitwith {};
		_car setvariable ["bis_fnc_carAlarm_busy",true];

		private _time = time + 6;
		if !(hasinterface) then {
			//--- Simply wait without any effect on server
			waituntil {time > _time || {!alive _car || {!simulationenabled _car}}};
		} else {
			//--- Sound
			if (player in _car) then {playsound "Orange_Car_Alarm_Loop_01";} else {_car say3D "Orange_Car_Alarm_Loop_01";};

			//--- Lights
			_timeLight = 0;
			_statusLight = "LightOff";
			waituntil {
				if (time > _timeLight) then {
					_statusLight = (["LightOn","LightOff"] - [_statusLight]) select 0;
					bis_functions_mainscope action [_statusLight,_car];
					_timeLight = time + 0.25;
				};
				time > _time || {!alive _car || {!simulationenabled _car}}
			};
		};
		bis_functions_mainscope action ["LightOff",_car];
		_car setvariable ["bis_fnc_carAlarm_busy",false];
	};
};