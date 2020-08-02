/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes data for control point

	Parameter(s):
	_this select 0: Object 	- The control point

	Returns:
	Nothing
*/

// Parameters
private _controlPoint = _this param [0, objNull, [objNull]];

// Validate control point
if (isNull _controlPoint) exitWith {};

// Data
private _ownerKey = [_controlPoint] call BIS_fnc_controlPoint_computeOwnerKey;

// Store data
_controlPoint setVariable ["OwnerKey", _ownerKey];