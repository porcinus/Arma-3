/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's keys assigned to given curve

	Parameter(s):
	_this select 0: Object - The curve
	_this select 1: Array - The keys

	Returns:
	Nothing
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _keys 	= _this param [1, [], [[]]];

// Set keys
_curve setVariable ["Keys", _keys];