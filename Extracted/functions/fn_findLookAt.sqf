/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Given target location, calculates orientation vectors facing direction

	Parameter(s):
	_this select 0: Object 	- The curve

	Returns:
	Array - In format [Dir Vector, Up Vector]
*/

#define UP [0.0, 0.0, 1.0]

// Parameters
params [["_start", [0.0, 0.0, 0.0], [[]]], ["_end", [0.0, 0.0, 0.0], [[]]], ["_default", [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [[]]]];

// Vectors are equal
if (_start isEqualTo _end) exitWith
{
	_default;
};

// The forward vector is direction to target
private _forward = vectorNormalized (_end vectorDiff _start);

// Use world up vector to calculate right vector
private _right = _forward vectorCrossProduct UP;

// Finally, calculate our up vector, using forward and right vectors
private _up = (_forward vectorCrossProduct _right) vectorMultiply -1;

// Return the vectors - arma sqf accepts only forward and up, right vector is calculated automatically when using setVectorXXX
[_forward, _up];