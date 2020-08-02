
/************************************************************
	Array Shift
	Author: KTottE, optimised by Killzone_Kid

This function removes the first (leftmost) element of an array and returns it.
The array is passed by reference so changes inside the function will be reflected
outside of it.

Example:
array = [1,2,3,4]
element = [array] call BIS_fnc_arrayShift

array is now [2,3,4]
element is now 1
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualTypeParams,[[]])

params ["_arr"];

_arr deleteAt 0