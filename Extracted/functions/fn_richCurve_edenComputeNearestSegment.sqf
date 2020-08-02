/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes the nearest baked segment from given 3D position

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Array - The start and end vectors of segment
*/

// Parameters
private _curve	= _this param [0, objNull, [objNull]];
private _loc	= _this param [1, [0.0, 0.0, 0.0], [[]]];
private _points	= _this param [2, [], [[]]];

// Validate curve
if (isNull _curve) exitWith
{
	[[], 10e10];
};

// The amount of provided segments
private _count = count _points;

// No segments provided
if (_count < 2) exitWith
{
	[[], 10e10];
};

// Only two segments provided, return those
if (_count == 2) exitWith
{
	[[_points select 0, _points select 1], 0];
};

// The segment and it's distance
private _segment = [];
private _minDist = 10e10;
private _prev = objNull;
private _next = objNull;

// Iterate points and form segments
for "_i" from 0 to _count - 2 do
{
	private _a		= (_points select _i) select 1;
	private _dist	= _a distance2D _loc;

	if (_dist < _minDist) then
	{
		_segment = [_a, (_points select (_i + 1)) select 1];
		_minDist = _dist;
		_prev = ((_points select _i) select 0) select 0;
		_next = ((_points select _i) select 0) select 1;
	};
};

// Return the segment
[_segment, _minDist, _prev, _next];