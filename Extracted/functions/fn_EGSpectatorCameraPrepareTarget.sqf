#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"

private _focus = vehicle (_this param [0, objNull, [objNull]]);

if (!isNull _focus) then
{
	private _deltaTime = missionNamespace getVariable [VAR_CAMERA_DELTA_TIME, 0.0];
	private _camera = missionNamespace getVariable [VAR_CAMERA, objNull];
	private _cameraMode = missionNamespace getVariable [VAR_CAMERA_MODE, MODE_FREE];
	private _dummy = missionNamespace getVariable [VAR_CAMERA_DUMMY_TARGET, objNull];
	private _zoom = if (_cameraMode == MODE_FOLLOW) then { missionNamespace getVariable [VAR_FOLLOW_CAMERA_ZOOM, 0.0] } else { 0.0 };
	private _zoomTemp = missionNamespace getVariable [VAR_FOLLOW_CAMERA_ZOOM_TEMP, 0.0];
	private _isMan = _focus isKindOf "Man";
	private _bbd = [_focus] call BIS_fnc_getObjectBBD;
	private _height = if (!_isMan) then { (_bbd select 2) / 3.0 } else { switch (stance _focus) do { case "STAND": {1.4}; case "CROUCH": {0.8}; default {0.4}; }; };

	// Interpolate zoom
	if (_zoomTemp != _zoom) then
	{
		_zoomTemp = [_zoomTemp, _zoom, _deltaTime, 10.0] call BIS_fnc_interpolate;
		missionNamespace setVariable [VAR_FOLLOW_CAMERA_ZOOM_TEMP, _zoomTemp];
	};

	// The distance at which to place camera from the focus pivot
	private _distance = (_bbd select 1) + _zoomTemp;

	// The pivot on the target vehicle
	private _center = if (_isMan) then { AGLToASL (_focus modelToWorldVisual (_focus selectionPosition "Spine3")) } else { AGLToASL (_focus modelToWorldVisual [0,0,_height]) };

	// The camera pitch and yaw
	private _cameraYaw = missionNamespace getVariable [VAR_FOLLOW_CAMERA_YAW, 0.0];
	private _cameraPitch = missionNamespace getVariable [VAR_FOLLOW_CAMERA_PITCH, 0.0];
	private _dirTemp = missionNamespace getVariable [VAR_FOLLOW_CAMERA_DIR_TEMP, 0.0];

	// Set dummy location and rotation
	_dummy setPosASL _center;
	[_dummy, [_dirTemp + _cameraYaw, _cameraPitch, 0.0]] call BIS_fnc_setObjectRotation;

	// Apply location and rotation to camera
	_camera setPosASL (AGLToASL (_dummy modelToWorldVisual [0, -_distance, 0]));
	_camera setVectorDirAndUp [vectorDirVisual _dummy, vectorUpVisual _dummy];
};