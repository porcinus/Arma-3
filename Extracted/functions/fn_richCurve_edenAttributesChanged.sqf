/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN attributes of a curve change

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Nothing
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Recompute curve
[_curve, true] call BIS_fnc_richCurve_compute;

// Reset drag operation time
missionNamespace setVariable ["_lastDragOperationTime", nil];