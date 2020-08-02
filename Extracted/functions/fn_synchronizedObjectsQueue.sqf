/*
	Author: Jiri Wainar

	Description:
	Return sequence of all synchronized objects forming either line or circle.

	Parameter(s):
		0: OBJECT - starting object
		1: STRING or ARRAY of STRINGs (Optional) - object types that are considered
		2: BOOL (Optional) - class filter uses exact match
			true (default): objects need to match exectly one of the filter classes
			false: exact match is not required, objects can inherit from one of the listed classes
		3: NUMBER (Optional) - expected connection shape
			0 (default): none, can be either line or circle
			1: line expected
			2: circle expected

	Returns:
	ARRAY of OBJECTs or empty ARRAY if error is encountered

	Errors:
		* There are more then 2 objects matching class filter connected.
		* Circle is required but closing connection is not detected.

	Example:
	[_start,["ModuleToWAreaVertex_F","ModuleToWAreaOptions_F"],true,0] call bis_fnc_synchronizedObjectsQueue;
*/

#define GET_SYNCED_3DEN(module)			(((get3DENConnections module) select {_x select 0 == "Sync"}) apply {_x select 1})
#define GET_SYNCED_MISSION(module)		(synchronizedObjects module)
#define GET_SYNCED(module)				((if (is3DEN) then {GET_SYNCED_3DEN(module)} else {GET_SYNCED_MISSION(module)}) select _condition)

#define SHAPE_ANY						0
#define SHAPE_LINE						1
#define SHAPE_CIRCLE					2

params
[
	["_source",objnull,[objnull]],
	["_classes",[],[[],""]],
	["_preciseMatch",true,[true]],
	["_requiredShape",SHAPE_ANY,[123]]
];

if (isNull _source) exitWith {[]};
if (_classes isEqualType "") then {_classes = [_classes];};

private _condition = if (_preciseMatch) then
{
	{typeOf _x in _classes};
}
else
{
	{_obj = _x; {_obj isKindOf _x} count _classes > 0};
};

//if source doesn't match filter, replace it by connected object of the class
if (_condition count [_source] == 0) then
{
	_source = GET_SYNCED(_source) param [0, objNull];
};

private _output = [_source];
private _error = false;

private _fnc_synced =
{
	if (isNull _this) exitWith {};

	_output pushBack _this;

	private _detected = GET_SYNCED(_this) - _output;

	if (count _detected > 1) exitWith {_error = true};

	(_detected param [0, objNull, [objNull]]) call _fnc_synced;
};

//get the initial connections
private _initSync = GET_SYNCED(_source);

//there cannot be more then 2 valid connection from the source object
if (count _initSync > 2) exitWith {[]};

//start 1st recursion
(_initSync param [0,objNull,[objNull]]) call _fnc_synced;

//re-arrange the objects gathered by 1st recursion
reverse _output;

//start 2nd recursion
(_initSync param [1,objNull,[objNull]]) call _fnc_synced;

//terminate if error encountered (branching detected))
if (_error) exitWith {[]};

//remove duplicity & detect 'connection shape'
private _count = count _output;
_output = _output arrayIntersect _output;

if (_requiredShape != SHAPE_ANY) then
{
	private _shape = if (count _output < _count) then
	{
		SHAPE_CIRCLE
	}
	else
	{
		SHAPE_LINE
	};

	if (_shape != _requiredShape) then
	{
		_error = true;
	};
};

//terminate if error encountered (connection shape is different)
if (_error) exitWith {[]};

reverse _output;

_output