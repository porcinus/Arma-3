/*
	Author: Jiri Wainar

	Description:
	Return a sub-task's parent task.

	Parameters:
		0: STRING - Task name

	Returns:
	STRING - sub-task's parent task.
*/

#include "defines.inc"

private ["_taskID","_taskVar","_params"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {["Task '%1' does not exists.",_taskID] call bis_fnc_error; ""};

GET_DATA(_taskVar,PARENT)