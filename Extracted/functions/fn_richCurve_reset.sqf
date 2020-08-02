/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Clears all curves (and deletes them)

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Nothing
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _key 	= _this param [1, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith {};

// Validate key
if (isNull _key || {_key getVariable ["_ownerCurve", objNull] != _curve}) exitWith {};

// All the keys
private _keys = [_curve] call BIS_fnc_richCurve_getKeys;

// Destroy all keys
{
	[_x] call BIS_fnc_key_destroy;
}
forEach _keys;

// Reset container
[_curve, []] call BIS_fnc_richCurve_setKeys;