/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns camera FOV

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	Float - The FOV value
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera
if (isNull _camera) exitWith {0.75};

// Return
if (is3DEN) then
{
	(_camera get3DENAttribute "FOV") select 0;
}
else
{
	_camera getVariable ["FOV", 0.75];
};