/*
	Author: Jiri Wainar

	Description:
	Return task variable

	Parameters:
		0: STRING - task ID

	Returns:
	STRING
*/

private ["_taskID"];

_taskID  = _this param [0,"",[""]]; if (_taskID == "") exitWith {""};

("@" + _taskID)