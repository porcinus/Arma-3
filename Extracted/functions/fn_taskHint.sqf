/*
	Author: Jiri Wainar

	Description:
	Display a task hint.

	Parameters:
		_this select 0: STRING - Task name
		_this select 1: STRING - Task state (optional)

	Returns:
	True if successful, false if not.
*/

#include "defines.inc"

private ["_taskID","_taskVar","_taskReal","_state","_type","_cfgTaskType"];

_taskID = _this param [0,"",[""]];
_taskVar = _taskID call bis_fnc_taskVar;

if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {["Task '%1' does not exists.",_taskID] call bis_fnc_error; false};

_state = _this param [1,_taskID call bis_fnc_taskState,[""]];
_taskReal = [_taskID,player] call bis_fnc_taskReal;

if (_taskReal in simpletasks player) then
{
	private["_notificationSuffix"];

	_type = GET_DATA(_taskVar,TYPE);
	_taskTypeTexture = [_type] call bis_fnc_taskTypeIcon;

	_notificationSuffix = "";
	if !(isNil "BIS_taskNotificationSuffix") then {_notificationSuffix = BIS_taskNotificationSuffix};

	if (_taskTypeTexture != "") then
	{
		["task" + _state + _notificationSuffix + "Icon",[_taskTypeTexture,GET_DATA(_taskVar,TITLE) select 0]] call bis_fnc_shownotification;
	}
	else
	{
		["task" + _state + _notificationSuffix,[GET_DATA(_taskVar,DESCRIPTION),GET_DATA(_taskVar,TITLE),GET_DATA(_taskVar,MARKER)]] call bis_fnc_shownotification;
	};
};

true