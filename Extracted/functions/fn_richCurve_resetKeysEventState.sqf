/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Reset's flag on all keys about handled events

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Nothing
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith {};

// Iterate keys
{
	_x setVariable ["_keyEventHandled", nil];
}
forEach ([_curve] call BIS_fnc_richCurve_getKeys);