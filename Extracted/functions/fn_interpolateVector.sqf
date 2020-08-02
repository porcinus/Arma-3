/*
	Author:
	Nelson Duarte

	Description:
	Interpolates vector to target, scaled by distance
	Starts very fast and smooths out

	Parameters:
	_this: ARRAY
		0: ARRAY - The current value
		1: ARRAY - The target value
		2: SCALAR - The delta time
		3: SCALAR - The interpolation speed

	Returns:
	ARRAY
*/
params [["_current", [0.0, 0.0, 0.0], [[]]], ["_target", [0.0, 0.0, 0.0], [[]]], ["_deltaTime", 0.0, [0.0]], ["_interpSpeed", 0.0, [0.0]]];

if (_interpSpeed <= 0.0) exitWith { _target; };

_dist = _target vectorDiff _current;

if (vectorMagnitudeSqr _dist < 0.00000001 ) exitWith { _target; };

private _deltaMove = _dist vectorMultiply ([_deltaTime * _interpSpeed, 0.0, 1.0] call BIS_fnc_clamp);

_current vectorAdd _deltaMove;