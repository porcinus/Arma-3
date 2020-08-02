/*
	Author: Jiri Wainar

	Description:
	Returns true if task is forced to be always visible (default: false).

	Parameters:
		0: STRING - task id


	Returns:
		BOOL - true if task is forced to be always visible; false if it should fade out normaly

	Example:
		_alwaysVisible:bool = [_taskId:string] call bis_fnc_taskAlwaysVisible;
*/

#include "defines.inc"

private _taskID = param [0,"",[""]];
private _taskVar = _taskID call bis_fnc_taskVar;
private _taskReal = [_taskID] call bis_fnc_taskReal;

if (isNull _taskReal || {isNil{GET_DATA_NIL(_taskVar,ID)}}) exitwith {["[x] Task '%1' does not exists.",_taskID] call bis_fnc_error; false};

GET_DATA(_taskVar,CORE)