/*
	Author: Jiri Wainar

	Description:
	Set a task's destination.

	Parameters:
		0: STRING - task name
		1: OBJECT or ARRAY or STRING - task destination
			OBJECT - task will be displayed on the object if player knows about it, otherwise it will be on estimated position or even hidden
			[OBJECT,true] - task will be on exact object position, even if player doesn't know about the object
			[X,Y,Z] - position - task will by on given positon
			STRING - marker name - task will be on that marker initial position

	Returns:
	STRING - Task ID
*/

private ["_taskID","_dest"];

_taskID = _this param [0,"",[""]];
_dest = _this param [1,objNull,[objNull,[],""]];

if (typename _dest == typename "") then {_dest = markerpos _dest;};

[_taskID,nil,nil,_dest] call bis_fnc_setTask;