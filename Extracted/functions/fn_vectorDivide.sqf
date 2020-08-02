/*
	Author:
	Nelson Duarte

	Description:
	Divides vector by scalar, by dividing all vector elements

	Parameters:
	_this: ARRAY
		0: ARRAY - The vector to divide
		1: ARRAY - The scale used to divide each vector element

	Returns:
	ARRAY
*/
params [["_vector", [0.0, 0.0, 0.0], [[]]], ["_scale", 1.0, [0.0]]];

for "_i" from 0 to count _vector - 1 do
{
	_vector set [_i, (_vector select _i) / _scale];
};

_vector;