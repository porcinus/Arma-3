/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Define script parameter

	Parameter(s):
		0: ARRAY	- list of params
		1: NUMBER - selected index
		2: ANY (Optional) - default param (used when param is missing or of wrong type)
		                  - you can overload default value by setting 'BIS_fnc_<functionName>_<index>'
		3: ARRAY (Optional) - list of allowed type examples (e.g. ["",[],0,objnull])
		4: NUMBER (Optional) - If value is ARRAY, checks if it has required number of elements

	Returns:
		ANY - either value from list of params, or default value
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////


#define TYPE_ERROR "Error: type %1 expected %2 on index %3 in %4"
#define SIZE_ERROR "Error: size %1 expected %2 on index %3 in %4"

params [["_array", []], ["_index", 0, [0]], "_defaultValue", ["_wantedTypes", [], [[]]], ["_wantedSizes", [], [0, []]]];
private _param = _array param [_index];

if (isNil "_param") exitWith // param is nil, return default or nil
{
	if (isNil "_defaultValue") then {nil} else {_defaultValue};
}; 

if !(_param isEqualTypeAny _wantedTypes || _wantedTypes isEqualTo []) exitWith
{
	private _fnc_getTypeName = 
	{
		if (isNil {_this select 0}) then {"ANY"} else {typeName (_this select 0)};
	};
	
	private _fnc_expectedTypes = 
	{
		private _types = [];
		{_types pushBack ([_x] call _fnc_getTypeName)} forEach _this;
		_types joinString ", "
	}; 
	
	[TYPE_ERROR, [_param] call _fnc_getTypeName, _wantedTypes call _fnc_expectedTypes, _index, _array] call BIS_fnc_error;
	
	if (isNil "_defaultValue") then {nil} else {_defaultValue};
};

if !(_param isEqualType []) exitWith {_param};

if (_wantedSizes isEqualType 0) then {_wantedSizes = [_wantedSizes]};

if !(count _param in _wantedSizes || _wantedSizes isEqualTo []) exitWith 
{
	private _fnc_expectedSizes = 
	{
		private _sizes = [];
		{_sizes pushBack _x} forEach _this;
		_sizes joinString ", "
	};
	
	[SIZE_ERROR, count _param, _wantedSizes call _fnc_expectedSizes, _index, _array] call BIS_fnc_error;
	
	if (isNil "_defaultValue") then {nil} else {_defaultValue};
}; 

_param