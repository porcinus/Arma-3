/*
	Author: Jiri Wainar

	Description:
	Return a task's description.

	Parameters:
		_this: STRING - Task name

	Returns:
	ARRAY -  task's description in the format ["description", "title", "marker"]
*/

#include "defines.inc"

private ["_taskID","_taskVar"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {["Task '%1' does not exists.",_taskID] call bis_fnc_error; []};

[GET_DATA(_taskVar,DESCRIPTION),GET_DATA(_taskVar,TITLE),GET_DATA(_taskVar,MARKER)]