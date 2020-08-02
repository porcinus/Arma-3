/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Bakes a curve to a set of points

	Parameter(s):
	_this select 0: Object  - The curve
	_this select 1: Integer - The amount of segments for curve baking (higher numbers mean more detail but also a lot more cpu time)

	Returns:
	ARRAY - All the baked curve points
*/

// Parameters
params [["_curve", objNull, [objNull]], ["_segmentCount", 200, [0]]];

// The points in the curve
private _points = [];

// Validate segments count
if (_segmentCount < 2) exitWith
{
	_points;
};

// The keys in the curve
private _keys = [_curve] call BIS_fnc_richCurve_getKeys;

// Validate keys
if (count _keys < 1 || {count _keys == 2 && {[_keys select 0] call BIS_fnc_key_getTime == [_keys select 1] call BIS_fnc_key_getTime}}) exitWith
{
	_points;
};

// Bake curve taking segment count into account
for "_i" from 0 to 1 step (1 / _segmentCount) do
{
	_points pushBack [[_curve, _i] call BIS_fnc_richCurve_getKeysAtTime, [_curve, _i] call BIS_fnc_richCurve_getCurveValueVector];
};

// Return the baked curve
_points;