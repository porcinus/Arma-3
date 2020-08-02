// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// If we dont have a player just end mission immediatly (dedicated server, headless client)
if (!hasinterface) exitWith
{
	["END1", true, true] call BIS_fnc_endMission;
};

// Cinematic mode
[true] call BIS_fnc_exp_camp_setCinematicMode;

//subtitles
private _sub = [] execVM "a3\Missions_F_Exp\Campaign\Briefings\EXP_m07_debriefing.sqf";

// Play the campaign finale video
["A3\Missions_F_Exp\video\EXP_m07_vOUT.ogv"] call BIS_fnc_playVideo;

// Cinematic mode
[false] call BIS_fnc_exp_camp_setCinematicMode;

// End mission after video playback ends
["END1", true, true] call BIS_fnc_endMission;