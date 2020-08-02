/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes data for a key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Nothing
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Validate key
if (isNull _key) exitWith {};

// Compute data
_key setVariable ["OwnerCurve", [_key] call BIS_fnc_key_computeOwnerCurve];
_key setVariable ["KeyTime", [_key] call BIS_fnc_key_computeTime];

// Compute control points
private _arrive	= [_key] call BIS_fnc_key_getArriveControlPoint;
private _leave	= [_key] call BIS_fnc_key_getLeaveControlPoint;

{
	if (!isNull _x) then
	{
		[_x] call BIS_fnc_controlPoint_compute;
	};
}
forEach [_arrive, _leave];