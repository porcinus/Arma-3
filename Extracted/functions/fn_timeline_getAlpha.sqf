/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's current alpha in given timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The current alpha
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

// Return timeline current alpha
_timeline getVariable ["Alpha", 0.0];