/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the play rate of this timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The play rate of the timeline
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
	(_timeline get3DENAttribute "PlayRate") select 0;
}
else
{
	_timeline getVariable ["PlayRate", 0.0];
};