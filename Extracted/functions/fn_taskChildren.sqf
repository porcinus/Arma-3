/*
	Author: Jiri Wainar

	Description:
	Return a task's sub-tasks.

	Parameters:
		0: STRING - Task name

	Returns:
	ARRAY - task's sub-tasks.
*/

#include "defines.inc"

private ["_taskID","_taskVar","_params"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {["Task '%1' does not exists.",_taskID] call bis_fnc_error; objNull};

GET_DATA(_taskVar,CHILDREN)