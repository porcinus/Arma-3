/*
	Author: Jiri Wainar

	Description:
	Flags task to be or not to be always visible.

	Parameters:
		0: STRING - task id
		1: BOOL - always visible flag

	Returns:
		STRING - task id

	Example:
		[_taskId:string,_alwaysVisible:bool] call bis_fnc_taskSetAlwaysVisible;
*/

#include "defines.inc"

private _taskID = param [0,"",[""]];
private _alwaysVisible = param [1,nil,[true]];

if (isNil "_alwaysVisible") exitWith {["Task id '%1' parameter 'alwaysVisible' (#1) is mandatory!",_taskID] call bis_fnc_error};

[_taskID,nil,nil,nil,nil,nil,false,nil,nil,_alwaysVisible] call bis_fnc_setTask;