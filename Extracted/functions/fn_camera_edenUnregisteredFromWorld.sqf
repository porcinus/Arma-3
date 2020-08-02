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

// Validate camera object and make sure we are in 3DEN
if (isNull _camera || {!is3DEN}) exitWith {};

// Terminate PIP
terminate (uiNamespace getVariable ["_scriptPIP", scriptNull]);
(["CameraPIP"] call bis_fnc_rscLayer) cutText ["", "plain"];

// The camera instance
private _cam = [_camera] call BIS_fnc_camera_getCam;

if (!isNull _cam) then
{
	_cam cameraEffect ["terminate", "back", "3DENCameraPIP"];
	camDestroy _cam;
	[_camera, objNull] call BIS_fnc_camera_setCam;
	cameraon cameraEffect ["internal", "BACK"];
};