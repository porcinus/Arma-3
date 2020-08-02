
/************************************************************
	Array Push Stack
	Author: Andrew Barron, optimised by Killzone_Kid

This function is similar to the array push function; however,
it pushes the contents of an array onto the stack array.

Example:
array = [1,2,3]
[array, [4,5,6]] call BIS_fnc_arrayPushStack

array2 = [[5,6,7], [8,[9],10]] call BIS_fnc_arrayPushStack

array is now [1,2,3,4,5,6]
array2 is now [5,6,7,8,[9],10]
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr1", "_arr2"];

_arr1 append _arr2;

_arr1
