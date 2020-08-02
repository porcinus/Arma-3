/*
	Author: Thomas Ryan
	
	Description:
	Create Task module function
*/

private [
	"_logic",
	"_units",
	"_ID",
	"_title",
	"_desc",
	"_marker"
];

_logic = _this param [0, objNull, [objNull]];
_units = _this param [1, [], [[]]];

_ID = _logic getVariable ["ID", "taskDefault"];
_logic setVariable ["Task", _ID];

_title = _logic getVariable ["Title", ""];
_desc = _logic getVariable ["Description", ""];
_marker = _logic getVariable ["Marker", ""];

[
	_units,
	_ID,
	[
		_desc,
		_title,
		_marker
	]
] call BIS_fnc_taskCreate;