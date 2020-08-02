/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Attributes change in EDEN for a control point

	Parameter(s):
	_this select 0: Object	- The control point

	Returns:
	Nothing
*/

// Parameters
private _controlPoint = _this param [0, objNull, [objNull]];

// Validate control point
if (isNull _controlPoint) exitWith {};

// The owner key
private _ownerKey = [_controlPoint] call BIS_fnc_controlPoint_getOwnerKey;

// Validate key
if (isNull _ownerKey) exitWith {};

// The owner curve
private _ownerCurve = [_ownerKey] call BIS_fnc_key_getOwnerCurve;

// Validate curve
if (!isNull _ownerCurve) then
{
	// Recompute curve
	[_ownerCurve] call BIS_fnc_richCurve_compute;
};

// Reset drag operation time
if ([_controlPoint] call BIS_fnc_controlPoint_edenIsSelected) then
{
	missionNamespace setVariable ["_lastDragOperationTime", nil];
};