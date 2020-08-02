/*
	Author: Jiri Wainar

	Description:
	Set a task to current.

	Parameters:
		0: STRING - Task name
		1: BOOL - Show notification (default: true)

	Returns:
	STRING - Task ID
*/

private _taskID = param [0,"",[""]];
private _showNotification = param [1,true,[true]];

[_taskID,nil,nil,nil,true,nil,_showNotification] call bis_fnc_setTask;