/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns number of keys registered with given curve

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Integer - Number of keys assigned to this curve
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	0;
};

// Return number of keys
count ([_curve] call BIS_fnc_richCurve_getKeys);