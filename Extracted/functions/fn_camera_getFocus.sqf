/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns camera focus

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	Array - The focus value
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera
if (isNull _camera) exitWith {[-1, -1]};

// The value
private _val = if (is3DEN) then {(_camera get3DENAttribute "Focus") select 0} else {_camera getVariable ["Focus", [-1, -1]]};

// Return
if (_val isEqualType []) then
{
	_val;
}
else
{
	call compile _val;
};