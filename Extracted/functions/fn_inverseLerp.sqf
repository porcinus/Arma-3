/*
	Author:
	Nelson Duarte

	Description:
	Inverse of BIS_fnc_lerp

	Parameters:
	_this: ARRAY
		0: SCALAR - A
		1: SCALAR - B
		2: SCALAR - Value

	Returns:
	SCALAR - Alpha
*/
params [["_a", 0.0, [0.0]], ["_b", 0.0, [0.0]], ["_value", 0.0, [0.0]]];

if (_a == _b) then
{
	if (_value < _a) then
	{
		0;
	}
	else
	{
		1;
	};
}
else
{
	(_value - _a) / (_b - _a);
};