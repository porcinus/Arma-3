/*
	Author: Jiri Wainar (Warka), optimised by Killzone_Kid

	Description:
	Sorts an array according to given algorithm.

	Parameter(s):
	_this select 0: any unsorted array (Array)
		- array can contain any types (object/numbers/strings ..)

	_this select 1: input parameters (Array)
		- used in the eval algorithm (object/numbers/strings ..)
		- input params are referenced in the sorting algorithm by _input0, _input1 .. _input9
		- max. number of 10 input params is supported (0-9)

	_this select 2: sorted algorithm (Code) [optional: default {_x}]
		- code needs to return a scalar
		- variable _x refers to array item

	_this select 3: sort direction (String) [optional: default "ASCEND"]
		"ASCEND": sorts array in ascending direction (from lowest value to highest)
		"DESCEND": sorts array in descending direction

	_this select 4: filter (Code) [optional: default {true}]
		- code that needs to evaluate true for the array item to be sorted, otherwise item is removed

	Returns:
	Array

	Examples:

	//sort numbers from lowest to highest
	_sortedNumbers = [[1,-80,0,480,15,-40],[],{_x},"ASCEND"] call BIS_fnc_sortBy;

	//sort helicopters by distance from player
	_closestHelicopters = [[_heli1,_heli2,_heli3],[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;

	//sort enemy by distance from friendly unit (referenced by local variable), the furtherest first
	_furtherstEnemy = [[_enemy1,_enemy2,_enemy3],[_friendly],{_input0 distance _x},"DESCEND",{canMove _x}] call BIS_fnc_sortBy;
*/

params [["_inputArray", []], ["_inputParams", []], ["_algorithmFnc", {}], ["_sortDirection", "ASCEND"], ["_filterFnc", {}]];

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr1 [_inputArray,_inputParams,_algorithmFnc,_sortDirection,_filterFnc]
#define arr2 [[],[],{},"",{}]
paramsCheck(arr1,isEqualTypeParams,arr2)

_inputParams params ["_input0", "_input1", "_input2", "_input3", "_input4", "_input5", "_input6", "_input7", "_input8", "_input9"];

// filter is specified
if !(_filterFnc isEqualTo {}) then 
{
	_inputArray = _inputArray select _filterFnc;
};

// alternative sorting algorithm is specified
if !(_algorithmFnc isEqualTo {}) exitWith
{
	_cnt = 0;
	_inputArray = _inputArray apply 
	{
		_cnt = _cnt + 1; 
		[_x call _algorithmFnc, _cnt, _x]
	};

	_inputArray sort (_sortDirection == "ASCEND");
	_inputArray apply {_x select 2}
};

_inputArray =+ _inputArray;
_inputArray sort (_sortDirection == "ASCEND");
_inputArray