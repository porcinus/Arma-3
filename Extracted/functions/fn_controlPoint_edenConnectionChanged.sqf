/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN connections of a control point is changed

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
if (!isNull _ownerKey) then
{
	// The owner curve
	private _ownerCurve = [_ownerKey] call BIS_fnc_key_getOwnerCurve;

	// Validate curve
	if (!isNull _ownerCurve) then
	{
		// Recompute curve
		[_ownerCurve] call BIS_fnc_richCurve_compute;
	};
};