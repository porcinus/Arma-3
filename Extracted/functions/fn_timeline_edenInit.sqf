/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Time line is initialized in 3den

	Parameter(s):
	_this select 0: Object	- The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate
if (isNull _timeline) exitWith
{
	["Invalid timeline object provided %1", _timeline] call BIS_fnc_error;
};

// Init
[_timeline] call BIS_fnc_timeline_init;

// Play timeline
if !([_timeline] call BIS_fnc_timeline_isPlaying) then
{
	[_timeline] call BIS_fnc_timeline_play;
};

// Make entity list dirty
missionNamespace setVariable ["_entityListDirty", true];