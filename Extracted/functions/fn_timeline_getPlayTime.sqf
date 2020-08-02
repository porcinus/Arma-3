/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The time at which timeline started playing

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The time at which timeline started playing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

// Return timeline current time
_timeline getVariable ["PlayTime", 0.0];