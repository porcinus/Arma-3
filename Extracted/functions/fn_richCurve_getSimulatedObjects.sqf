/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns a curve's simulated objects

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Array - List of objects simulated by given curve
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	[];
};

// Return
_curve getVariable ["SimulatedObjects", []];