/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's the index of given key in given curve

	Parameter(s):
	_this select 0: Object - The curve
	_this select 1: Object - The key

	Returns:
	Integer - The index of the given key in given curve
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _key 	= _this param [1, objNull, [objNull]];

// Validate objects
if (isNull _curve || {isNull _key}) exitWith
{
	-1;
};

// Proceed with registration
private _curveKeys = [_curve, true] call BIS_fnc_richCurve_getKeys;

// The index
_curveKeys find _key;