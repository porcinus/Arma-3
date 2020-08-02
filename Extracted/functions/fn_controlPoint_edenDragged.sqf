/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Entity is dragged in 3DEN

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

// Handle dragging control point when owner key has LockedControlPoints enabled
if ([_ownerKey] call BIS_fnc_key_edenAreControlPointsLocked) then
{
	private _otherControlPoint = if ([_controlPoint] call BIS_fnc_controlPoint_isArrive) then {[_ownerKey] call BIS_fnc_key_getLeaveControlPoint} else {[_ownerKey] call BIS_fnc_key_getArriveControlPoint};

	if (!isNull _otherControlPoint && {!([_otherControlPoint] call BIS_fnc_controlPoint_edenIsSelected)}) then
	{
		private _pos		= ASLToAGL (getPosASLVisual _controlPoint);
		private _relPos 	= _ownerKey worldToModelVisual _pos;
		private _relPosInv	= _relPos vectorMultiply -1;

		_otherControlPoint set3DENAttribute ["Position", _ownerKey modelToWorldVisual _relPosInv];
	};
};

// The owner curve
private _ownerCurve = [_ownerKey] call BIS_fnc_key_getOwnerCurve;

// Validate curve
if (!isNull _ownerCurve) then
{
	// Recompute curve
	[_ownerCurve] call BIS_fnc_richCurve_compute;
};

// Store last dragged operation time
missionNamespace setVariable ["_lastDragOperationTime", time];