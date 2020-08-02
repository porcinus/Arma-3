/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Calculates and returns delta time

	Parameter(s):
	_this select 0: String 	- The id, used to not create conflicts between different systems calling this function, each system can calculate delta time since it last ticked
	_this select 1: Bool	- Whether to clear, if true it will return SMALL_NUMBER

	Returns:
	The delta time
*/

#include "\a3\functions_f\debug.inc"

PROFILING_START("BIS_fnc_deltaTime");

#define SMALL_NUMBER 0.001

params [["_id", "generic", [""]], ["_clear", false, [false]]];

if (_clear) exitWith
{
	missionNamespace setVariable [_id, nil];
	SMALL_NUMBER;
};

private _oldTime = missionNamespace getVariable [_id, SMALL_NUMBER];
missionNamespace setVariable [_id, time];

PROFILING_STOP("BIS_fnc_deltaTime");

time - _oldTime;