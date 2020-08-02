/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Destroys timeline and all related objects

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate timeline
if (isNull _timeline) exitWith {};

// Iterate timeline simulated curves
{
	// Iterate simulated objects
	{
		// Leave camera
		if (!isNull ([_x] call BIS_fnc_camera_getCam)) then
		{
			([_x] call BIS_fnc_camera_getCam) cameraEffect ["Terminate", "Back"];
		};

		// Delete simulated object
		deleteVehicle _x;
	}
	forEach ([_x] call BIS_fnc_richCurve_getSimulatedObjects);

	// Iterate keys
	{
		// Iterate control points
		{
			// Delete control point
			deleteVehicle _x;
		}
		forEach [[_x] call BIS_fnc_key_getArriveControlPoint, [_x] call BIS_fnc_key_getLeaveControlPoint];

		// Delete key
		deletevehicle _x;
	}
	forEach ([_x] call BIS_fnc_richCurve_getKeys);

	// Delete curve
	deleteVehicle _x;
}
forEach ([_timeline] call BIS_fnc_timeline_getSimulatedCurves);

// Delete timeline
deleteVehicle _timeline;