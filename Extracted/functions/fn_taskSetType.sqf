/*
	Author: Jiri Wainar

	Description:
	Sets task type to given task.

	Parameters:
		0: STRING - task id
		1: STRING - task type

	Returns:
		STRING - task id

	Example:
		[_taskId:string,_taskType:string] call bis_fnc_taskSetType;
*/

#include "defines.inc"

private _taskID = param [0,"",[""]];
private _type = param [1,"",[""]];

if (_type == "") exitWith {["Task id '%1' parameter 'type' (#1) is mandatory!",_taskID] call bis_fnc_error};

[_taskID,nil,nil,nil,nil,nil,false,nil,_type] call bis_fnc_setTask;