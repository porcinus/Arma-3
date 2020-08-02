/*
	Author:
	Nelson Duarte

	Description:
	Interpolates vector to target, linearly

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

if (_current isEqualTo _target) exitWith { _target };

private _dist = _target vectorDiff _current;
private _delta = vectorMagnitude _dist;
private _maxStep = _interpSpeed * _deltaTime;

if (_delta > _maxStep) then
{
	if (_maxStep > 0.0) then
	{
		private _deltaN = [_dist, _delta] call BIS_fnc_vectorDivide;
		_current vectorAdd (_deltaN vectorMultiply _maxStep);
	}
	else
	{
		_current;
	};
}
else
{
	_target;
};