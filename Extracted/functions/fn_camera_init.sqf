/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Initialize a camera

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	Nothing
*/

#include "\a3\functions_f\debug.inc"

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _camera) exitWith
{
	["Invalid camera object provided %1", _camera] call BIS_fnc_error;
};

// Camera entity is always hidden in game
_camera hideObject !is3DEN;

// Create the actual camera
private _cam = "camera" camCreate getPos _camera;

// Store the instance
[_camera, _cam] call BIS_fnc_camera_setCam;

// We may want to swith to camera
if (!is3DEN && {_camera getVariable ["SwitchToAtStart", false]}) then
{
	_cam cameraEffect ["internal", "BACK"];
};

// Add to cameras container
private _cameras = missionNamespace getVariable ["Cameras", []];
_cameras pushbackUnique _camera;
missionNamespace setVariable ["Cameras", _cameras - [objNull]];

// Tick cameras
// We use global tick for all camera
// Create tick function only if not created already
if (missionNamespace getVariable ["CamerasTick", -1] == -1) then
{
	private _eh = addMissionEventHandler ["EachFrame",
	{
		PROFILING_START("BIS_fnc_camera_init");

		// Compute delta time
		private _deltaTime = missionNamespace getVariable ["BIS_deltaTime", ["CamerasDT"] call BIS_fnc_deltaTime];

		// Tick all the cameras
		{
			[_x, _deltaTime] call BIS_fnc_camera_tick;
		}
		forEach (missionNamespace getVariable ["Cameras", []]);

		PROFILING_STOP("BIS_fnc_camera_init");
	}];

	// Store handler to event handler to be removed when no more cameras exist
	missionNamespace setVariable ["CamerasTick", _eh];
};