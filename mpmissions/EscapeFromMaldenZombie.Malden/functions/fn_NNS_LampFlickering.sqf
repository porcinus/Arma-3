/*
NNS
Make a lamp flicker and play a sound class.

Dependency: in description.ext:
class CfgSounds {
	sounds[] = {};
	class LightFlicker01 {name = "lightflicker01"; sound[] = {"audio\lightflicker01.ogg", 0.9, 1, 75}; titles[]	= {};};
	class LightFlicker02 {name = "lightflicker02"; sound[] = {"audio\lightflicker02.ogg", 0.9, 1, 75}; titles[]	= {};};
	class LightFlicker03 {name = "lightflicker03"; sound[] = {"audio\lightflicker03.ogg", 0.9, 1, 75}; titles[]	= {};};
};

Check 'audio' folder for noises.

Example: 
_null = [lampobj,"mysound",100] call BIS_fnc_NNS_LampFlickering;

*/

// Params
params [
	["_lamp",objNull], //lamp to flicker
	["_class",""], //sound class to use
	["_maxDist",40] //max distance allowed to play sound
];

// Check for validity
if (isNull _lamp) exitWith {[format["fn_NNS_LampFlickering : Non-existing object %1 used!",_lamp]] call BIS_fnc_NNS_debugOutput;};
if (_maxDist < 0) exitWith {["fn_NNS_LampFlickering : Max distance < 0"] call BIS_fnc_NNS_debugOutput;};
if !(alive _lamp) exitWith {[format["fn_NNS_LampFlickering : object %1 is destroyed",_lamp]] call BIS_fnc_NNS_debugOutput;};
if (_class == "") then {_class = format["LightFlicker0%1",1 + round (random 2)];};

[_lamp,_class,_maxDist] spawn { //spawn a flicker
	_lamp = _this select 0; //lamp object
	_class = _this select 1; //sound class
	_maxDist = _this select 2; //max distance to play sound
	_dist = _lamp distance2D player; //distance from player
	if (_dist < _maxDist) then {_lamp say3D _class;}; //under max distance, play sound
	_lamp switchLight "OFF"; sleep 0.15; _lamp switchLight "ON"; //flicker light
};
