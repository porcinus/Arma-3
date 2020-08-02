/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns whether camera uses cinema borders or not

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	Bool - True if camera uses cinema borders, false if not
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera
if (isNull _camera) exitWith {false};

// Return
if (is3DEN) then
{
	(_camera get3DENAttribute "ShowCinemaBorders") select 0;
}
else
{
	_camera getVariable ["ShowCinemaBorders", false];
};