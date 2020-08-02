// If dedicated server or headless client, nothing to do here
if (!hasInterface) exitWith {};

// Params
private _videoPath = _this param [0, "", [""]];

// Validate video file path
if (_videoPath == "") exitWith
{
	"Provided video path is empty" call BIS_fnc_error;
};

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Cinematic mode
[true, 99, 0] call BIS_fnc_exp_camp_setCinematicMode;

// Play the campaign finale video
[_videoPath] call BIS_fnc_playVideo;

// Cinematic mode
[false, 10, 10] call BIS_fnc_exp_camp_setCinematicMode;