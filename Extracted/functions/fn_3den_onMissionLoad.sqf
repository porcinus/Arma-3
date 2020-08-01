/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN mission loaded

	Parameter(s):
	Nothing

	Returns:
	Nothing
*/

// Camera reset
[] call BIS_fnc_camera_edenReset;

// Compute all curves
{
	[_x] call BIS_fnc_richCurve_compute;
}
forEach (allMissionObjects "Curve_F");