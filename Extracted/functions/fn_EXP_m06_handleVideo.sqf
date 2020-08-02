if (!hasInterface) exitWith {true};

#define PLAY_VIDEO "a3\missions_f_exp\video\exp_m06_vintel.ogv"

private _detector = createTrigger ["EmptyDetector", position BIS_monitor1, false];
_detector setTriggerArea [50, 50, 0, false];
_detector triggerAttachVehicle [player];
_detector setTriggerActivation ["VEHICLE", "PRESENT", true];
_detector setTriggerStatements 
[
	"this",
	
	format ["
		thisTrigger setVariable ['EH', [missionNamespace, 'BIS_fnc_playVideo_stopped', {['%1', [20, 20]] spawn BIS_fnc_playVideo}] call BIS_fnc_addScriptedEventHandler];
		BIS_monitor1 setObjectTexture [0, '%1'];
		['%1', [20, 20]] spawn BIS_fnc_playVideo;
	", PLAY_VIDEO],
	
	"
		[missionNamespace, 'BIS_fnc_playVideo_stopped', thisTrigger getVariable ['EH', -1]] call BIS_fnc_removeScriptedEventHandler;
		['', [20, 20]] spawn BIS_fnc_playVideo;
		BIS_monitor1 setObjectTexture [0, ''];
	"
];

true 