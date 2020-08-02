/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's actual camera instance from camera object

	Parameter(s):
	_this select 0: Object - The camera
	_this select 1: Object - The cam instance

	Returns:
	Nothing
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];
private _cam	= _this param [1, objNull, [objNull]];

// Validate
if (isNull _camera || {_cam == _camera getVariable ["_cam", objNull]} || {isNull _cam && {isNull (_camera getVariable ["_cam", objNull])}}) exitWith {};

// Set the cam instance
_camera setVariable ["_cam", _cam];