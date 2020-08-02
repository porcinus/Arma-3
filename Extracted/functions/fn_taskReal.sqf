/*
	Author: Jiri Wainar

	Description:
	Find the actual task associated with a task name assigned to a unit.

	Parameters:
		0: STRING - Task name
		1: OBJECT - Task owner (optional, default: player)

	Returns:
	The actual task.
*/

private ["_taskID","_unit","_taskVar"];

_taskID = _this param [0,"",[""]];
_unit = _this param [1,player,[objnull]];
_taskVar = _taskID call bis_fnc_taskVar;

_unit getVariable [_taskVar,tasknull];