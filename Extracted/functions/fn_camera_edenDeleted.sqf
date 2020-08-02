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

// Reset
if ([_camera] call BIS_fnc_camera_edenIsSelected) then
{
	[] call BIS_fnc_camera_edenReset;
};

// Call main delete function
[_camera] call BIS_fnc_camera_deleted;