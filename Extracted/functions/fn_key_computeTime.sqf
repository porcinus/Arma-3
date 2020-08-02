/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes the time of given key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key time
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Get the time value
private _t = [_key] call BIS_fnc_key_getConfigTime;

// The owner curve
private _ownerCurve = [_key] call BIS_fnc_key_computeOwnerCurve;

// If we have an owner curve that uses time as seconds we compute it now
if (!isNull _ownerCurve) then
{
	_t = [_ownerCurve, _key] call BIS_fnc_richCurve_getKeyTime;
};

_t;