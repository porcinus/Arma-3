/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Timeline is deleted

	Parameter(s):
	_this select 0: Object - The destroyed timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate timeline object
if (isNull _timeline) exitWith {};

// Remove from timelines container
private _timelines = missionNamespace getVariable ["Timelines", []];
_timelines = _timelines - [_timeline];
missionNamespace setVariable ["Timelines", _timelines];

// Stop timelines tick if this was the last one
if (count _timelines < 1 && {missionNamespace getVariable ["TimelinesTick", -1] != -1}) then
{
	removeMissionEventHandler ["EachFrame", missionNamespace getVariable ["TimelinesTick", -1]];
	missionNamespace setVariable ["TimelinesTick", nil];
};