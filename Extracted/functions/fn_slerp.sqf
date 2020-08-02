/*
	Author:
	Nelson Duarte

	Description:
	Spherical lerp, for correct lerping of normalized direction vectors

	Parameters:
	_this: ARRAY
		0: SCALAR - The current value
		1: SCALAR - The target value
		2: SCALAR - The alpha

	Returns:
	SCALAR
*/
params [["_a", [0.0, 0.0, 0.0], [[]]], ["_b", [0.0, 0.0, 0.0], [[]]], ["_alpha", 0.0, [0.0]]];

// Dot product - the cosine of the angle between 2 vectors
private _dot = _a vectorDotProduct _b;

// Clamp it to be in the range of Acos()
// This may be unnecessary, but floating point
// precision can be a fickle mistress
_dot = [_dot, -1.0, 1.0] call BIS_fnc_clamp;

// Returns the angle between start and end
// And multiplying that by alpha returns the angle between
// start and the final result
private _theta = acos(_dot) * _alpha;

// Orthonormal basis
private _rel = vectorNormalized (_b vectorDiff (_a vectorMultiply _dot));

// The final result
(_a vectorMultiply cos(_theta)) vectorAdd (_rel vectorMultiply sin(_theta));