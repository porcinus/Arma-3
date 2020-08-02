/*
	Author: Nelson Duarte

	Description:
	Set's cinematic mode, with cinematic mode enabled the sounds are muted and screen is black

	Parameters:
		_mode: Enable or not

	Returns:
		Nothing
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Make sure manager allows cinematics, otherwise exit here
if (missionNamespace getVariable [VAR_SS_NO_CINEMATICS, false]) exitWith {};

// Parameters
params [["_newMode", false, [true]], ["_fadeScreenTime", 5.0, [0.0]], ["_fadeSoundTime", 5.0, [0.0]]];

// The old mode
private _oldMode = [] call BIS_fnc_exp_camp_getCinematicMode;

// Whether or not to affect only camera
private _affectsCameraOnly = missionNamespace getVariable [VAR_CINEMATICS_AFFECT_CAMERA_ONLY, false];

// Make sure cinematic mode actually changed
if !(_newMode isEqualTo _oldMode) then
{
	if (_newMode) then
	{
		if (!_affectsCameraOnly) then
		{
			// Back screen
			0 cutText ["", "BLACK FADED", _fadeScreenTime];

			// Disable sound
			_fadeSoundTime fadeSound 0;
			_fadeSoundTime fadeMusic 0;
			_fadeSoundTime fadeRadio 0;
			enableSentences false;
			enableRadio false;
			showChat false;
			enableEnvironment false;
		};

		// Create camera (so player input is taken away)
		private _camera = "camera" camCreate (position player);

		// Switch to camera
		_camera cameraEffect ["internal", "BACK"];

		// Camera transform, make camera face up for better performance
		private _pos = eyePos player vectorAdd (eyeDirection player vectorMultiply -1.0);
		_camera setPosASL _pos;
		_camera setVectorDirAndUp [vectorUp player, vectorDir player];

		// Store a few things so we can check later
		missionNamespace setVariable [VAR_SS_CAMERA, _camera];
	}
	else
	{
		if (!_affectsCameraOnly) then
		{
			// Back screen
			0 cutText ["", "BLACK IN", _fadeScreenTime];

			// Enable sound
			_fadeSoundTime fadeSound 1.0;
			_fadeSoundTime fadeMusic 0.5;
			_fadeSoundTime fadeRadio 1.0;
			enableSentences true;
			enableRadio true;
			showChat true;
			enableEnvironment true;
		};

		// The camera
		private _camera = missionNamespace getVariable [VAR_SS_CAMERA, objNull];

		// Destroy camera and take control of character
		if (!isNull _camera) then
		{
			_camera cameraEffect ["terminate", "BACK"];
			deleteVehicle _camera;
			missionNamespace setVariable [VAR_SS_CAMERA, nil];
		};
	};

	// Store new mode
	missionNamespace setVariable [VAR_IS_CINEMATIC_MODE, _newMode];

	// Call event
	[missionNamespace, EVENT_CINEMATIC_MODE_CHANGED, [_newMode]] call BIS_fnc_callScriptedEventHandler;
};