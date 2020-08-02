/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Calculates distance between all keys, returning the total length

	Parameter(s):
	_this select 0: Object 	- The curve

	Returns:
	Float - The curve length
*/

// Parameters
private _curve	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	0.0;
};

// Return computed value
_curve getVariable ["ArcTotalLength", 0.0];