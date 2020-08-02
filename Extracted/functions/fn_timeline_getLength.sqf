/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The time left of given timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The time left
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

if (is3DEN) then
{
	(_timeline get3DENAttribute "Length") select 0;
}
else
{
	_timeline getVariable ["Length", 0.0];
};