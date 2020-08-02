/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the position of given timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Float - The timeline position
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

_timeline getVariable ["Pos", 0.0];