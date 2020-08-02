/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Play given timeline if currently not playing
	If we are playing and paused, we unpause

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Nothing
*/

#include "\a3\functions_f\debug.inc"

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _position	= _this param [1, 0.0, [0.0]];

// Validate object
if (isNull _timeline) exitWith
{
	["Invalid timeline object provided %1", _timeline] call BIS_fnc_error;
};

// If we're paused, unpause now
if ([_timeline] call BIS_fnc_timeline_isPaused) then
{
	[_timeline] call BIS_fnc_timeline_unpause;
};

// Add to timelines container
private _timelines = missionNamespace getVariable ["Timelines", []];
_timelines pushbackUnique _timeline;
missionNamespace setVariable ["Timelines", _timelines - [objNull]];

// Tick timelines
// We use global tick for all timelines
if (missionNamespace getVariable ["TimelinesTick", -1] == -1) then
{
	private _eh = addMissionEventHandler ["EachFrame",
	{
		PROFILING_START("BIS_fnc_timeline_init");

		// Compute delta time
		private _deltaTime = missionNamespace getVariable ["BIS_deltaTime", ["TimelinesDT"] call BIS_fnc_deltaTime];

		// Tick all the timelines
		{
			[_x, _deltaTime] call BIS_fnc_timeline_tick;
		}
		forEach (missionNamespace getVariable ["Timelines", []]);

		PROFILING_STOP("BIS_fnc_timeline_init");
	}];

	// Store handler to event handler to be removed when no more timelines exist
	missionNamespace setVariable ["TimelinesTick", _eh];
};

// Clamp position, since it needs to be within timeline range
_position = [_position, 0.0, [_timeline] call BIS_fnc_timeline_getLength] call BIS_fnc_clamp;

// Play the timeline
_timeline setVariable ["Playing", 		true];
_timeline setVariable ["Paused", 		false];
_timeline setVariable ["Finished", 		false];
_timeline setVariable ["Pos", 		_position];
_timeline setVariable ["Alpha", 		0.0];
_timeline setVariable ["PlayTime", 		time];
_timeline setVariable ["StopTime",	 	-1.0];
_timeline setVariable ["EndTime", 		-1.0];

// Trigger event
if (!is3DEN) then
{
	[_timeline, "played"] call BIS_fnc_callScriptedEventHandler;
	[_timeline] call compile (_timeline getVariable ["EventStarted", ""]);

	{
		[_x] call BIS_fnc_richCurve_resetKeysEventState;
	}
	forEach ([_timeline] call BIS_fnc_timeline_getSimulatedCurves);
};