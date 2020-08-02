/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's keys assigned to given curve

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Array - List of assigned keys
*/

// Parameters
private _curve	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	[];
};

// If in game, curve will have variable Keys baked
_curve getVariable ["Keys", []];