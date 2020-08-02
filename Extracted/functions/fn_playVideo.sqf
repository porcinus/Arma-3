/*
	Author:
		Karel Moricky, improved by Killzone_Kid

	Description:
		Plays in-game video with a range of options

	Parameters:
		0: STRING - Video path
		1: (Optional) ARRAY - Screen size in format [x, y, w, h]. Default: [safeZoneX, safeZoneY, safeZoneW, safeZoneH]
		2: (Optional) ARRAY - Foreground color in format [r, g, b, a]. Default: [1,1,1,1]
		3: (Optional) STRING - missionNamespace variable to skip the video when variable is TRUE. Default: "BIS_fnc_playVideo_skipVideo"
		4: (Optional) ARRAY - Background color in format [r, g, b, a]. Default: [0,0,0,1]
		5: (Optional) BOOLEAN - TRUE to keep video aspect ratio (Background color will fill the void), FALSE to stretch. Default: TRUE

	Returns:
		BOOLEAN - true
*/
#define VIDEO_DISPLAY_VAR "RscTitleDisplayEmpty"
#define VIDEO_CTRL_VAR "BIS_fnc_playVideo_videoCtrl"
#define SKIP_VIDEO_VAR "BIS_fnc_playVideo_skipVideo"

if (!hasInterface) exitWith {}; //--- ignore it when no UI
if (!canSuspend) exitWith {_this spawn (missionNamespace getVariable "BIS_fnc_playVideo"); true};

disableSerialization;

((uiNamespace getVariable [VIDEO_DISPLAY_VAR, displayNull]) getVariable [VIDEO_CTRL_VAR, controlNull]) ctrlSetText ""; // stop any video currently playing

// [_videoContent, _screenSize, _screenColor, _skipVariable, _backgroundColor, _keepAspect]
params
[
	["_videoContent", "", [""]],
	["_screenSize", [safeZoneX, safeZoneY, safeZoneW, safeZoneH], [[]]],
	["_screenColor", [1,1,1,1], [[]], 4],
	["_skipVideoVar", "", [""]],
	["_backgroundColor", [0,0,0,1], [[]], 4],
	["_keepAspect", true, [true]]
];

[] call BIS_fnc_rscLayer cutRsc [VIDEO_DISPLAY_VAR, "PLAIN"]; // video display

private _videoDisplay = uiNamespace getVariable [VIDEO_DISPLAY_VAR, displayNull];
private _videoCtrl = controlNull;

if (isNull _videoDisplay) exitWith
{
	["Failed to create video display"] call BIS_fnc_error; // should never happen
	true
};

private _videoBackgroundCtrl = _videoDisplay ctrlCreate ["RscText", -1];
_videoBackgroundCtrl ctrlSetBackgroundColor _backgroundColor;
_videoBackgroundCtrl ctrlSetPosition _screenSize;
_videoBackgroundCtrl ctrlCommit 0;

isNil
{
	_videoCtrl = _videoDisplay ctrlCreate [["RscVideo", "RscVideoKeepAspect"] select _keepAspect, -1];
	_videoDisplay setVariable [VIDEO_CTRL_VAR, _videoCtrl];
};

_videoCtrl ctrlAddEventHandler ["VideoStopped", {_this select 0 ctrlSetText ""}];
_videoCtrl ctrlSetTextColor _screenColor;
_videoCtrl ctrlSetPosition _screenSize;
_videoCtrl ctrlCommit 0;
_videoCtrl ctrlSetText _videoContent; // play video file

[missionNamespace, "BIS_fnc_playVideo_started", [_videoContent]] call (missionNamespace getVariable "BIS_fnc_callScriptedEventHandler");

if (_skipVideoVar isEqualTo "") then {_skipVideoVar = SKIP_VIDEO_VAR};

waitUntil
{
	ctrlText _videoCtrl isEqualTo "" // video stopped or new video started
	||
	missionNamespace getVariable [_skipVideoVar, false] isEqualTo true // video interrupted
};

_videoCtrl ctrlSetText "";
_videoDisplay closeDisplay 2;

[missionNamespace, "BIS_fnc_playVideo_stopped", [_videoContent]] call (missionNamespace getVariable "BIS_fnc_callScriptedEventHandler");
true