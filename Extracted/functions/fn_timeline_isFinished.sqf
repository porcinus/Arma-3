/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given timeline has finished

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Bool - True if finished, false if not
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

// Return timeline current time
_timeline getVariable ["Finished", false];