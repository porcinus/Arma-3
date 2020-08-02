/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's camera FOV

	Parameter(s):
	_this select 0: Object	- The camera
	_this select 1: Float	- The FOV value

	Returns:
	Nothing
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];
private _fov	= _this param [1, 0.75, [0.0]];

// Validate camera
if (isNull _camera) exitWith {};

// Set
_camera setVariable ["FOV", _fov];