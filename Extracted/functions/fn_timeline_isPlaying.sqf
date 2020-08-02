/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given timeline is playing (can be paused at same time!)

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Bool - True if playing, false if not
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	false;
};

// Return timeline current time
_timeline getVariable ["Playing", false] && {!(_timeline getVariable ["Finished", false])};