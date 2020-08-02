/*
	Author: Jiri Wainar

	Description:
	Return if a task has been completed.

	Parameters:
		0: STRING - Task name

	Returns:
	BOOL - True if the task has been completed, false if not.

	Example:
	["TestTask"] call bis_fnc_taskCompleted;
*/

#include "defines.inc"

private ["_taskID","_taskVar","_state"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {false};

_state = GET_DATA(_taskVar,STATE);

{_x == _state} count ["SUCCEEDED", "FAILED", "CANCELED"] > 0