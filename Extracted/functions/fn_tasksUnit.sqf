/*
	Author: Jiri Wainar

	Description:
	Grab all tasks currently created for a given unit

	Parameters:
		0: OBJECT - Tasks owner

	Returns:
	ARRAY
*/

private ["_target"];

_target = _this param [0,objNull,[objNull]];

_target getvariable ["BIS_fnc_setTaskLocal_tasks",[]];