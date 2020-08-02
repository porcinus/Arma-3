/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns camera vision mode

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	String - The vision mode
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera
if (isNull _camera) exitWith {0};

// Return
if (is3DEN) then
{
	(_camera get3DENAttribute "VisionMode") select 0;
}
else
{
	_camera getVariable ["VisionMode", 0];
};