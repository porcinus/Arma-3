/*
	Author: Thomas Ryan
	
	Description:
	Set Task State module function
*/

private [
	"_logic",
	"_modules",
	"_module",
	"_task",
	"_state"
];

_logic = _this param [0, objNull, [objNull]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	// Find the synchronized module
	_modules = _logic call BIS_fnc_moduleModules;
	_module = objNull;

	{if (typeOf _x == "ModuleTaskCreate_F") exitWith {_module = _x}} forEach _modules;

	// Exit if no module is found
	if (isNull _module) exitWith {false};

	_task = _module getVariable ["ID", ""];

	// Exit if no task is found
	if (_task == "") exitWith {false};

	_state = _logic getVariable "State";
	private _showNotification = (_logic getVariable ["ShowNotification", 1]) == 1;

	if (_state == "ASSIGNED") then {
		[_task,nil,nil,nil,true,nil,_showNotification] call bis_fnc_setTask;
	} else {
		[_task,nil,nil,nil,_state,nil,_showNotification] call bis_fnc_setTask;
	};
};