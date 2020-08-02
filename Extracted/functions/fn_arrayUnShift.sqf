
/************************************************************
	Array UnShift
	Author: KTottE, optimized by Andrew Barron, optimised by Killzone_Kid

This function adds an element to the beginning of an array and returns the array.
The array is passed by reference so changes inside the function will be reflected
outside of it.

Example:
array = [2,3,4]
[array, 1] call BIS_fnc_ArrayUnshift
array2 = [[6,7,8], 5] call BIS_fnc_ArrayUnshift

array is now [1,2,3,4]
array2 is now [5,6,7,8]
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],nil]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr", "_el"];

_el = [_el];
_el append _arr;
_arr resize 0;
_arr append _el;

_arr
