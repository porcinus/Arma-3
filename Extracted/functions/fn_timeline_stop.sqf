/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Initialized a timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	// Log error
	["Invalid timeline object provided %1", _timeline] call BIS_fnc_error;
};

// Setup dynamic properties
_timeline setVariable ["Playing", false];
_timeline setVariable ["Paused", false];