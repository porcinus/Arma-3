/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The current time of this timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The time at which timeline is currently in
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

private _length = [_timeline] call BIS_fnc_timeline_getLength;
private _alpha = [_timeline] call BIS_fnc_timeline_getAlpha;

[0.0, _length, _alpha] call BIS_fnc_lerp;