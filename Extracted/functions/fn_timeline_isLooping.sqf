/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given timeline is in loop mode

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Bool - True if in loop mode, false if not
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	false;
};

// Return timeline loop mode
if (is3DEN) then
{
	// In 3DEN we always return true so timeline is always looping
	//(_timeline get3DENAttribute "Loop") select 0;
	true;
}
else
{
	_timeline getVariable ["Loop", false];
};