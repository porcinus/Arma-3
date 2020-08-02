/*
	Author: Thomas Ryan

	Description:
	Set Task Destination module function
*/

private _logic = _this param [0, objNull, [objNull]];
private _units = _this param [1, [], [[]]];
private _activated = _this param [2,true,[true]];

if (_activated) then
{
	// Find the synchronized module
	private _modules = _logic call BIS_fnc_moduleModules;
	private _module = objNull;

	{if (typeOf _x == "ModuleTaskCreate_F") exitWith {_module = _x}} forEach _modules;

	// Exit if no module is found
	if (isNull _module) exitWith {false};

	private _task = _module getVariable ["ID", ""];

	// Exit if no task is found
	if (_task == "") exitWith {false};

	private _destType = call compile (_logic getVariable "Destination");

	// Exit if no synchronized units were provided
	if (_destType == 1 && count _units == 0) exitWith {false};

	private ["_dest"];

	if (_destType == 0) then
	{
		// Module position
		_dest = position _logic;
	}
	else
	{
		// Synchronized unit
		_dest = [_units select 0, true];
	};
	private _showNotification = (_logic getVariable ["ShowNotification", 1]) == 1;

	[_task,nil,nil,_dest,nil,nil,_showNotification] call bis_fnc_setTask;
};