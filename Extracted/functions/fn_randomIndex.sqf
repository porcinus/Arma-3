
/************************************************************
	Random Index
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: array

This returns a random integer representing an index in the passed array.

Example: [1,2,3] call BIS_fnc_randomIndex
Returns: 0, 1, or 2
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

floor random count _this