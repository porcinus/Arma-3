/*
	Author: Thomas Ryan
	
	Description:
	Set Task Destination module function
*/

private [
	"_logic",
	"_modules",
	"_module",
	"_task",
	"_destType",
	"_dest"
];

_logic = _this param [0, objNull, [objNull]];
_units = _this param [1, [], [[]]];

// Find the synchronized module
_modules = _logic call BIS_fnc_moduleModules;
_module = objNull;

{if (typeOf _x == "ModuleEventTaskCreate_F") exitWith {_module = _x}} forEach _modules;

// Exit if no module is found
if (isNull _module) exitWith {false};

_task = _module getVariable ["Task", ""];

// Exit if no task is found
if (_task == "") exitWith {false};

_destType = call compile (_logic getVariable "Destination");

// Exit if no synchronized units were provided
if (_destType == 1 && count _units == 0) exitWith {false};

if (_destType == 0) then {
	// Module position
	_dest = position _logic;
} else {
	// Synchronized unit
	_dest = [_units select 0, true];
};

[_task, _dest] call BIS_fnc_taskSetDestination;