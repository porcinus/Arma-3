/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's whether camera cinema borders are enabled

	Parameter(s):
	_this select 0: Object	- The camera
	_this select 1: Bool	- The cinema borders state

	Returns:
	Nothing
*/

// Parameters
private _camera		= _this param [0, objNull, [objNull]];
private _enabled	= _this param [1, false, [false]];

// Validate camera
if (isNull _camera || {_enabled == [_camera] call BIS_fnc_camera_getCinemaBordersEnabled}) exitWith {};

// Set
_camera setVariable ["ShowCinemaBorders", _enabled];