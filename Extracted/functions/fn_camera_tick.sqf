/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Ticks a camera

	Parameter(s):
	_this select 0: Object - The camera

	Returns:
	Nothing
*/

// Parameters
private _camera 	= _this param [0, objNull, [objNull]];
private _deltaTime 	= _this param [1, 0.0, [0.0]];

// Validate timeline
if (isNull _camera) exitWith {};

// The actual camera instance
private _cam 		= [_camera] call BIS_fnc_camera_getCam;

// Update camera instance
if (!isNull _cam) then
{
	if (!is3DEN) then
	{
		cameraEffectEnableHUD ([_camera] call BIS_fnc_camera_getHUDEnabled);
		showCinemaBorder ([_camera] call BIS_fnc_camera_getCinemaBordersEnabled);
	};

	_cam setPosASL getPosASLVisual _camera;
	_cam setVectorDirAndUp [vectorDirVisual _camera, vectorUpVisual _camera];
	_cam camSetFov ([_camera] call BIS_fnc_camera_getFOV);
	_cam camSetFocus ([_camera] call BIS_fnc_camera_getFocus);
	_cam camCommit 0;
};