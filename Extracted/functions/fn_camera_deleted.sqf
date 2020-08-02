/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Camera is deleted

	Parameter(s):
	_this select 0: Object - The destroyed camera

	Returns:
	Nothing
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera object
if (isNull _camera) exitWith {};

// Retrieve the cam object
private _cam = [_camera] call BIS_fnc_camera_getCam;

// Delete cam object
if (!isNull _cam) then
{
	_cam cameraEffect ["terminate", "back"];
	camDestroy _cam;
};

// Remove from cameras container
private _cameras = missionNamespace getVariable ["Cameras", []];
_cameras = _cameras - [_camera, objNull];
missionNamespace setVariable ["Cameras", _cameras];

// Stop tick function if this was the last camera
if (count _cameras <= 0 && {missionNamespace getVariable ["CamerasTick", -1] != -1}) then
{
	removeMissionEventHandler ["EachFrame", missionNamespace getVariable ["CamerasTick", -1]];
	missionNamespace setVariable ["CamerasTick", nil];
};