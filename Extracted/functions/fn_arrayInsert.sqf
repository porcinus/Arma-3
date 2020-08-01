
/************************************************************
	Array Insert
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [base array, insert array, index]
Returs: [array]

Inserts the elements of one array into another, at a specified
index.

Neither arrays are touched by reference, a new array is returned.

Example1: [[0,1,2,3,4], ["a","b","c"], 1] call BIS_fnc_arrayInsert
Returns: [0,"a","b","c",1,2,3,4]
Example2: [[1,2],[3,4],5] call BIS_fnc_arrayInsert
Returns: [1,2,<null>,<null>,<null>,3,4]
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[],0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr1", "_arr2", "_index"];

if (_index < 0) exitWith {_arr1};

private _size1 = count _arr1;
if (_index >= _size1) then {
	_arr1 = +_arr1;
	_arr1 resize _index;
};

(_arr1 select [0, _index]) + _arr2 + (_arr1 select [_index, _size1])