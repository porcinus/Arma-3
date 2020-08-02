/*
	Author: Jiri Wainar

	Description:
	Return if a task exists.

	Parameters:
		0: STRING - Task name

	Returns:
	True if the task exists, false if not.
*/

#include "defines.inc"

private ["_taskID","_taskVar"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

!isnil {GET_DATA_NIL(_taskVar,ID)}