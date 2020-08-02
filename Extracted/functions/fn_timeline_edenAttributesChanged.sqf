/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Attributes change in EDEN for a timeline

	Parameter(s):
	_this select 0: Object	- The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate
if (isNull _timeline) exitWith {};

// Reset
[_timeline] call BIS_fnc_timeline_play;

// Reset drag operation time
missionNamespace setVariable ["_lastDragOperationTime", nil];