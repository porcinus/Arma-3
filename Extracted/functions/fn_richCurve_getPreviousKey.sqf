/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's the previous key from given key, null if none exists

	Parameter(s):
	_this select 0: Object - The curve
	_this select 1: Object - The key

	Returns:
	Object - The previous key
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _key 	= _this param [1, objNull, [objNull]];

// Validate objects
if (isNull _curve || {isNull _key}) exitWith
{
	objNull;
};

// The given key index and the amount of keys in the curve
private _keyIndex 	= [_curve, _key] call BIS_fnc_richCurve_getKeyIndex;
private _numKeys 	= [_curve] call BIS_fnc_richCurve_getNumKeys;

// No previous key
if (_keyIndex <= 0) exitWith
{
	// No next key
	objNull;
};

// Success
[_curve, _keyIndex - 1] call BIS_fnc_richCurve_getKeyFromIndex;