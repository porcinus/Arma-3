/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Attributes change in EDEN for a camera

	Parameter(s):
	_this select 0: Object	- The camera

	Returns:
	Nothing
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate camera
if (isNull _camera) exitWith {};

// PIP may be enabled
// Make sure to set the vision mode in case it was changed
switch ([_camera] call BIS_fnc_camera_getVisionMode) do
{
    case "nvg":     {"3DENCameraPIP" setPiPEffect [1];};
    case "ti_0";
    case "ti_1";
    case "ti_2";
    case "ti_3";
    case "ti_4";
    case "ti_5";
    case "ti_6";
    case "ti_7":    {"3DENCameraPIP" setPiPEffect [2];};
    default         {"3DENCameraPIP" setPiPEffect [0];};
};