/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the computed curve points

	Parameter(s):
	_this select 0: Object 	- The curve

	Returns:
	Array - The curve points (array of 3D vectors)
*/

// Parameters
private _curve	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	[];
};

// Return computed value
_curve getVariable ["ArcPoints", []];