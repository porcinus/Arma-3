/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's the first key on given curve

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Object - The first key of given curve
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	objNull;
};

// The keys in the curve
private _keys = [_curve, true] call BIS_fnc_richCurve_getKeys;

// Is there at least one key available?
// If not just return null
if (count _keys < 1) exitWith
{
	objNull;
};

// Get first key
_keys select 0;