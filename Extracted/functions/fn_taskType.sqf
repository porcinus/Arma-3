/*
	Author: Jiri Wainar

	Description:
	Returns type of given task.

	Parameters:
		0: STRING - task id

	Returns:
		STRING - task type or type 'Default' if not defined

	Example:
		_taskType:string = [_taskId:string] call bis_fnc_taskType;
*/

#include "defines.inc"

private _taskID = param [0,"",[""]];
private _taskVar = _taskID call bis_fnc_taskVar;
private _taskReal = [_taskID] call bis_fnc_taskReal;

if (isNull _taskReal || {isNil{GET_DATA_NIL(_taskVar,ID)}}) exitwith {["Task '%1' does not exists.",_taskID] call bis_fnc_error; ""};

GET_DATA(_taskVar,TYPE)