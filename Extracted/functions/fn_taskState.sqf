/*
	Author: Jiri Wainar

	Description:
	Return a task's state.

	Parameters:
		0: STRING - Task name

	Returns:
	STRING - task's state.
*/

#include "defines.inc"

private _taskID = _this param [0,"",[""]];
private _taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {""};

GET_DATA(_taskVar,STATE)