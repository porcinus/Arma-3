/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Entity is dragged in 3DEN

	Parameter(s):
	_this select 0: Object	- The curve

	Returns:
	Nothing
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Validate
if (isNull _curve) exitWith {};

// Recompute curve
[_curve] call BIS_fnc_richCurve_compute;

// Store last dragged operation time
missionNamespace setVariable ["_lastDragOperationTime", time];