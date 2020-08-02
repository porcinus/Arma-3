/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the curve that owns key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Curve - The owner curve object
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Validate key
if (isNull _key) exitWith
{
	objNull;
};

// Return
_key getVariable ["OwnerCurve", objNull];