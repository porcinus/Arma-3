
/************************************************************
	Sort Numbers
	Author: Andrew Barron, optimised by Killzone_Kid

Sorts an array of numbers from lowest (left) to highest (right).
The passed array is modified by reference.

Example: [9,8,7] call BIS_fnc_sortNum; //[7,8,9]

This function uses the quick sort algorithm.
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

_this sort true;

_this