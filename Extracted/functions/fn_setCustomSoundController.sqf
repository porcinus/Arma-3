/*
	BIS_fnc_setCustomSoundController

	a: reyhard
*/
if (isdedicated) exitwith {};

params [
	["_object",objnull,[objnull]],	// Name of object (object)
	["_controlller","",["string"]],	// Name of controller (string)
	["_value",0,[0]],				// Descired phase (number), default 0
	["_transition",1,[0]]			// Transition time in seconds (number), default 1 second
];


// Get starting phase
private _startPhase			= getCustomSoundController [_object,_controlller];
// Generate unique name for vehicle
private _perFrameHandler	= format["BIN_pfh_soundController_%1_%2",_object,_controlller];

[_perFrameHandler, "onEachFrame",
{
	params["_startTime","_endTime","_object","_controlller","_value","_transition","_startPhase","_perFrameHandler"];

	// Modify sond controller every frame
	private _valueMod = linearConversion [_startTime,_endTime,time,_startPhase,_value,true];
	setCustomSoundController [_object,_controlller,_valueMod];

	if(time > _endTime)exitWith
	{
		// Removed per frame handler
		[_perFrameHandler, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	};
},[
	time,
	time + _transition,
	_object,
	_controlller,
	_value,
	_transition,
	_startPhase,
	_perFrameHandler
	]
] call BIS_fnc_addStackedEventHandler;