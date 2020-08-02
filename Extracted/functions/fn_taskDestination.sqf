/*
	Author: Jiri Wainar

	Description:
	Return a task's destination.

	Parameters:
		0: STRING - Task name

	Returns:
		OBJECT
		ARRAY - either position in format [x,y,z], or [object,precision] as used by setSimpleTaskTarget command
*/

#include "defines.inc"

private ["_taskID","_taskVar"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {["Task '%1' does not exists.",_taskID] call bis_fnc_error; objNull};

GET_DATA(_taskVar,DESTINATION)