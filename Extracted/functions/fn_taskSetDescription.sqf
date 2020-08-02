/*
	Author: Jiri Wainar

	Description:
	Set a task's description.

	Parameters:
		0: STRING - Task name
		1: ARRAY - Task description in the format ["description", "title", "marker"]

	Returns:
	STRING - Task ID
*/

private ["_taskID","_info"];

_taskID = _this param [0,"",[""]];
_info = _this param [1,["","",""],[[]], 3];

[_taskID,nil,_info] call bis_fnc_setTask;