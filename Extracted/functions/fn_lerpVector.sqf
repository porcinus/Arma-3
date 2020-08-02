/*
	Author:
	Nelson Duarte

	Description:
	Given two different vectors A and B, think of a straight line drawn between them
	With _alpha saying how far along that line you are

	Parameters:
	_this: ARRAY
		0: ARRAY - The current value
		1: ARRAY - The target value
		2: SCALAR - The alpha

	Returns:
	ARRAY
*/
params [["_a", [0.0, 0.0, 0.0], [[]]], ["_b", [0.0, 0.0, 0.0], [[]]], ["_alpha", 0.0, [0.0]]];

_a vectorAdd ((_b vectorDiff _a) vectorMultiply _alpha);