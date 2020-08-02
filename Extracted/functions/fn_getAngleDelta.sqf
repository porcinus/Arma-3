/*
	Author: Nelson Duarte

	Description:
	Returns the smallest difference between 2 angles in degrees

	Parameters:
	_this: ARRAY
		0: Angle A
		1: Angle B
	Returns:
	NUMBER
*/
params [["_a", 0.0, [0.0]], ["_b", 0.0, [0.0]]];

(sin(_a - _b)) atan2 (cos (_a - _b));