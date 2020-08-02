params
[
  ["_p0", [0,0,0], [[]]],
  ["_p1", [0,0,0], [[]]],
  ["_p2", [0,0,0], [[]]],
  ["_p3", [0,0,0], [[]]]
];

private _oldPoint  	= _p0;
private _length     = 0.0;
private _lengths	= [];
private _points		= [];

for "_alpha" from 0.0 to 1.0 step 0.001 do
{
  private _currentPoint 	= [_p0, _p1, _p2, _p3, _alpha] call BIS_fnc_bezierInterpolateVector;
  private _currentLength 	= _oldPoint distance _currentPoint;

  _length = _length + _currentLength;
  _lengths pushBack _length;
  _points pushBack _currentPoint;
  _oldPoint = _currentPoint;
};

[_length, _lengths, _points];