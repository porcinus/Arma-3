/*
	Author:
	Nelson Duarte

	Description:
	Given two different scalars A and B, think of a straight line drawn between them
	With _alpha saying how far along that line you are

	Parameters:
	_this: ARRAY
		0: SCALAR - The current value
		1: SCALAR - The target value
		2: SCALAR - The alpha

	Returns:
	SCALAR
*/
params [["_a", 0.0, [0.0]], ["_b", 0.0, [0.0]], ["_alpha", 0.0, [0.0]]];

_a + _alpha * (_b - _a);