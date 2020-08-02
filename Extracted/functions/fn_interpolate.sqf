/*
	Author:
	Nelson Duarte

	Description:
	Interpolates scalar to target, starts fast, eases out

	Parameters:
	_this: ARRAY
		0: SCALAR - The current value
		1: SCALAR - The target value
		2: SCALAR - The delta time
		3: SCALAR - The interpolation speed

	Returns:
	SCALAR
*/
params [["_current", 0.0, [0.0]], ["_target", 0.0, [0.0]], ["_deltaTime", 0.0, [0.0]], ["_interpSpeed", 0.0, [0.0]]];

if (_interpSpeed <= 0.0) exitWith { _target; };

private _dist = _target - _current;

if (sqrt _dist < 0.00000001) exitWith { _target; };

private _deltaMove = _dist * ([_deltaTime * _interpSpeed, 0.0, 1.0] call BIS_fnc_clamp);

_current + _deltaMove;