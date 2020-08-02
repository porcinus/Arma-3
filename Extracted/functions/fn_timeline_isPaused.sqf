/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given timeline is playing but paused

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Bool - True if paused, false if not
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

// Return timeline current time
if (is3DEN) then
{
	(_timeline get3DENAttribute "Paused") select 0;
}
else
{
	_timeline getVariable ["Paused", false];
};