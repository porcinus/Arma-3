
/************************************************************
	Array Push
	Author: KTottE, optimised by Killzone_Kid

This function adds an element to the end of an array and returns the array.
The array is passed by reference so changes inside the function will be reflected
outside of it.

Example:
array = [1,2,3]
[array, 4] call BIS_fnc_arrayPush
array2 = [[5,6,7], [8]] call BIS_fnc_arrayPush

array is now [1,2,3,4]
array2 is now [5,6,7,[8]]
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],nil]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr", "_el"];

_arr append [_el];

_arr