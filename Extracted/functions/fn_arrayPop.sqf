
/************************************************************
	Array Pop
	Author: KTottE & Andrew Barron, optimised by Killzone_Kid

This function removes the last (rightmost) element of an array and returns it.
The array is passed by reference so changes inside the function will be reflected
outside of it.

Example:
array = [1,2,3,4]
element = array call BIS_fnc_arrayPop

array is now [1,2,3]
element is now 4
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

_this deleteAt (count _this - 1)