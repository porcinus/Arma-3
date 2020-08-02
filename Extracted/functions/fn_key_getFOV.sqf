/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the FOV value of a key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The fov value
*/

// Parameters
private _key  = _this param [0, objNull, [objNull]];

// Return
if (is3DEN) then
{
	(_key get3DENAttribute "CameraFOV") select 0;
}
else
{
	_key getVariable ["CameraFOV", 0.75];
};