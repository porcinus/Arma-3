/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The selection state of given camera changes

	Parameter(s):
	_this select 0: Object	- The camera
	_this select 1: Bool	- True if selected, false if not

	Returns:
	Nothing
*/

disableSerialization;

// Make sure we are in 3DEN
if (!is3DEN) exitWith {};

// Parameters
private _camera 	= _this param [0, objNull, [objNull]];
private _selected 	= _this param [1, false, [false]];

// Validate camera
if (isNull _camera) exitWith {};

// The camera instance
private _cam = [_camera] call BIS_fnc_camera_getCam;

// Validate camera object
if (isNull _cam) exitWith {};

// Selected or deselected
if (_selected) then
{
	// Reset
	[] call BIS_fnc_camera_edenReset;

	// Create resource
	uiNamespace setVariable ["_camPIP", _camera];
	(["CameraPIP"] call bis_fnc_rscLayer) cutRsc ["RscCameraPIP", "plain", 0, false];

	// Gather list of cameras in world
	private _list = if (is3DEN) then {(all3DENEntities select 3) select {_x isKindOf "Camera_F"}} else {allMissionObjects "Camera_F"};

	// Go through all camera placed in world and reset them, just not the currently selected one
	{([_x] call BIS_fnc_camera_getCam) cameraEffect ["terminate", "back"];} forEach (_list - [_camera]);

	// Create ui / camera connections
	private _controlPIP 	= (uinamespace getvariable ["RscCameraPIP", displayNull]) displayctrl 2300;
	private _controlNoPIP 	= (uinamespace getvariable ["RscCameraPIP", displayNull]) displayctrl 2301;

	// Pip is enabled, render target
	if (isPipEnabled) then
	{
		_controlPIP ctrlsettext format ["#(argb,256,256,1)r2t(%1,1.0)", "3DENCameraPIP"];
		_controlPIP ctrlsettextcolor [1,1,1,1];
		_controlPIP ctrlcommit 0;

		_controlNoPIP ctrlsettextcolor [1,1,1,0];
		_controlNoPIP ctrlcommit 0;

		_cam cameraEffect ["Internal", "Back", "3DENCameraPIP"];
	}
	// Show the user that he is not seeing the render target
	else
	{
		_controlPIP ctrlsettext "";
		_controlPIP ctrlsettextcolor [1,1,1,0];
		_controlPIP ctrlcommit 0;

		_controlNoPIP ctrlsettextcolor [1,1,1,1];
		_controlNoPIP ctrlcommit 0;
	};

	// Apply vision mode
	switch ([_camera] call BIS_fnc_camera_getVisionMode) do
	{
		case "nvg": 	{"3DENCameraPIP" setPiPEffect [1];};
		case "ti": 		{"3DENCameraPIP" setPiPEffect [2];};
		default 		{"3DENCameraPIP" setPiPEffect [0];};
	};

	// Store the script handle so we can terminate it if selection changes again
	uiNamespace setVariable ["_scriptPIP", _script];
}
else
{
	// Clear resources if this camera was previously selected
	if (uiNamespace getVariable ["_camPIP", objNull] == _camera) then
	{
		// Terminate cam
		_cam cameraEffect ["terminate", "back"];

		// Reset
		[] call BIS_fnc_camera_edenReset;
	};
};