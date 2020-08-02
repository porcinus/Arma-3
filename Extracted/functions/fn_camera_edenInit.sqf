/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Camera is initialized in 3den

	Parameter(s):
	_this select 0: Object	- The camera

	Returns:
	Nothing
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate
if (isNull _camera) exitWith
{
	["Invalid camera object provided %1", _camera] call BIS_fnc_error;
};

// 3DEN Properties
_camera setVariable ["_selected", false];

// Init
[_camera] call BIS_fnc_camera_init;

// Force selection
if ([_camera] call BIS_fnc_camera_edenIsSelected) then
{
	[_camera, true] call BIS_fnc_camera_edenSelectionChanged;
};

// Make entity list dirty
missionNamespace setVariable ["_entityListDirty", true];