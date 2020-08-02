/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns whether camera HUD is enabled

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	Bool - True if camera HUD is enabled, false if not
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera
if (isNull _camera) exitWith {false};

// Return
if (is3DEN) then
{
	(_camera get3DENAttribute "EnableHUD") select 0;
}
else
{
	_camera getVariable ["EnableHUD", false];
};