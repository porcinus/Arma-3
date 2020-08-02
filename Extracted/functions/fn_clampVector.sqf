/*
	Author:
	Nelson Duarte

	Description:
	Clamps vector between min / max

	Parameters:
	_this: ARRAY
		0: ARRAY - The vector to clamp
		1: SCALAR - Min value
		2: SCALAR - Max value

	Returns:
	ARRAY - Clamped vector
*/
params [["_vector", [0.0, 0.0, 0.0], [[]]], ["_min", 0.0, [0.0]], ["_max", 0.0, [0.0]]];

for "_i" from 0 to count _vector - 1 do
{
	_vector set [_i, [_vector select _i, _min, _max] call BIS_fnc_clamp];
};

_vector;