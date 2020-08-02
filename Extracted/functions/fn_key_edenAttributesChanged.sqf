/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Attributes change in EDEN for a key

	Parameter(s):
	_this select 0: Object	- The key

	Returns:
	Nothing
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Validate
if (isNull _key) exitWith {};

// The owner curve
private _ownerCurve = [_key] call BIS_fnc_key_getOwnerCurve;

// Validate curve
if (!isNull _ownerCurve) then
{
	// Recompute
	[_ownerCurve] call BIS_fnc_richCurve_compute;
};

// Reset drag operation time
missionNamespace setVariable ["_lastDragOperationTime", nil];