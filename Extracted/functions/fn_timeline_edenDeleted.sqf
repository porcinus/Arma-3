/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Timeline is deleted

	Parameter(s):
	_this select 0: Object - The destroyed timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate timeline object
if (isNull _timeline) exitWith {};

// Call the main deleted function
[_timeline] call BIS_fnc_timeline_deleted;