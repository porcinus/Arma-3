/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether timeline is flagged as play from start on scenario begin

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Bool - True if should play from start
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	false;
};

// Return
if (is3DEN) then
{
	(_timeline get3DENAttribute "PlayFromStart") select 0;
}
else
{
	_timeline getVariable ["PlayFromStart", false];
};