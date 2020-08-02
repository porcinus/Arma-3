/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's the key in given index of given curve

	Parameter(s):
	_this select 0: Object - The curve
	_this select 1: Integer - The key index

	Returns:
	Object - The key at given index
*/

// Parameters
private _curve 		= _this param [0, objNull, [objNull]];
private _keyIndex 	= _this param [1, -1, [-1]];

// Validate curve
if (isNull _curve) exitWith
{
	objNull;
};

// The keys
private _keys = [_curve, true] call BIS_fnc_richCurve_getKeys;

// No keys?
if (count _keys < 1 || {_keyIndex >= count _keys - 1}) exitWith
{
	// Failed
	objNull;
};

// Return key at index
_keys select _keyIndex;