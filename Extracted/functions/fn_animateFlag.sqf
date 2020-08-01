/*
	Author: 
		Killzone_Kid
	
	Description:
		Smoothly animates given flag from current position on the flag pole to the given position
		The function is global, MP and JIP compatible, persistent and will syncronise flags across the network
		When flag animation is done, the scripted event handler "FlagAnimationDone" is called
		To add scripted event handler to the flag use: _eh = [<yourflag>, "FlagAnimationDone", <yourcode>] call BIS_fnc_addScriptedEventHandler;
	
	Parameters:
		0: OBJECT - flag object of the type "FlagCarrier"
		1: NUMBER - desired animation phase 0...1 (0 - bottom of the flag pole, 1 - top of the flag pole)
		2: (Optional) 
			BOOLEAN - when true, animation is instant ("FlagAnimationDone" EH is not called in this case). Default: false
			NUMBER - animation duration multiplier
				
	Returns:
		NOTHING
	
	Example:
		[flag1, 0] call BIS_fnc_animateFlag;
		
	NOTE: 
		Never put call to this function into object init field
*/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [objNull,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_flag", "_phaseEnd", ["_instant", false]];

//-- make sure we have the right flag
if (isNull _flag || !(_flag isKindOf "FlagCarrier")) exitWith 
{
	["Flag object doesn't exist or is not of type 'FlagCarrier'!"] call BIS_fnc_error;
	nil
};

//-- time it takes for the flag to go from 0 to 1
private _duration = 10; 

//-- apply any adjustment to the default speed if any
if (_instant isEqualType 0) then 
{
	_duration = _duration * (0 max _instant min 30);
};

//-- get current flag phase
private _phaseStart = flagAnimationPhase _flag;

//-- unify user supplied end phase
_phaseEnd = 0 max _phaseEnd min 1;

//-- select time clock according to game mode 
private _timeStart = [time, serverTime] select isMultiplayer;

//-- make persistent execution
[
	[
		_flag, 
		_timeStart, 
		_timeStart + _duration * abs (_phaseEnd - _phaseStart), //-- calculate animation duration
		_phaseStart, 
		_phaseEnd,
		_instant isEqualTo true
	], 
	"A3\Functions_F\Misc\fn_animateFlag.fsm"
]
remoteExecCall ["execFSM", 0, _flag];

//-- return nothing
nil 
