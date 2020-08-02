/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes curve arc lenght

	Parameter(s):
	_this select 0: Object 	- The curve

	Returns:
	Float - The curve arc length
*/

#define INTERVAL 1.0

// Parameters
private _curve	= _this param [0, objNull, [objNull]];
private _forced	= _this param [1, false, [false]];

// Validate curve
if (isNull _curve) exitWith
{
	[0.0, [], []];
};

// Update rate
if (!_forced && {time < (_curve getVariable ["_l", -1]) + INTERVAL}) exitWith
{
	[_curve getVariable ["ArcTotalLength", 0.0], _curve getVariable ["ArcLengths", []], _curve getVariable ["ArcPoints", []]];
};

_curve setVariable ["_l", time];

// All the keys in the curve
private _keys = [_curve] call BIS_fnc_richCurve_getKeys;

// Validate number of available keys
if (count _keys < 2) exitWith
{
	[0.0, [], []];
};

// The length
private _length 	= 0.0;
private _lengths 	= [];
private _points		= [];

// The arc length computation
for "_i" from 0 to (count _keys - 2) do
{
	private _curKey 	= _keys select _i;
	private _nextKey 	= _keys select (_i + 1);

	if ([_curKey] call BIS_fnc_key_getInterpMode != 1) then
	{
		_length = _length + (_curKey distance _nextKey);
		_lengths pushBack _length;
	}
	else
	{
		private _p0 = [_curKey] call BIS_fnc_key_getValue;
		private _p1	= [_nextKey] call BIS_fnc_key_getValue;
		private _c0	= _p0 vectorAdd ([_curKey] call BIS_fnc_key_getLeaveTangent);
		private _c1	= _p1 vectorAdd ([_nextKey] call BIS_fnc_key_getArriveTangent);

		private _len = [_p0, _c0, _c1, _p1] call BIS_fnc_bezierLength;

		_length = _length + (_len select 0);
		_lengths = _lengths + (_len select 1);
		_points = _points + (_len select 2);
	};
};

// Return the length
[_length, _lengths, _points];