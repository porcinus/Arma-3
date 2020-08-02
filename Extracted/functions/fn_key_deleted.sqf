/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Key is deleted

	Parameter(s):
	_this select 0: Object - The destroyed key

	Returns:
	Nothing
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Validate key object
if (isNull _key) exitWith {};
/*
// The control points
private _arrive	= [_key] call BIS_fnc_key_getArriveControlPoint;
private _leave	= [_key] call BIS_fnc_key_getArriveControlPoint;

// Destroy control points
if (!isNull _arrive) then {deleteVehicle _arrive};
if (!isNull _leave) then {deleteVehicle _leave};