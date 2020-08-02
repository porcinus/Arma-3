/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The time at which timeline stopped playing

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The time at which timeline stopped playing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

// Return timeline current time
_timeline getVariable ["StopTime", 0.0];