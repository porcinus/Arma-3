/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes nearest point in a line

	Parameter(s):
	_this select 0: Array - The line start
	_this select 1: Array - The line end
	_this select 2: Array - The point to check against
	_this select 3: Bool  - Whether we are doing a 2D calculation instead of 3D

	Returns:
	Array - The nearest point in the given line
*/

private _lineStart 	= _this param [0, [0.0, 0.0, 0.0], [[]]];
private _lineEnd 	= _this param [1, [0.0, 0.0, 0.0], [[]]];
private _point 		= _this param [2, [0.0, 0.0, 0.0], [[]]];
private _2D			= _this param [3, [false], [false]];

if (_2D) then
{
	_lineStart set [2, _lineEnd select 2];
};

private _lineDirection = vectorNormalized (_lineEnd vectorDiff _lineStart);
private _closestPoint = (_point vectorDiff _lineStart) vectorDotProduct _lineDirection;

private _m = [];

for "_i" from 0 to 2 do
{
	private _cp = _closestPoint;
	private _ld = _lineDirection select _i;

	_m pushBack (_cp * _ld);
};

_lineStart vectorAdd _m;