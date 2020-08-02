/************************************************************
	Random Select
	Author: Andrew Barron, rewritten by Warka, optimized by Karel Moricky, optimised by Killzone_Kid

Parameters: array

This returns a randomly selected element from the passed array.

Example: [1,2,3] call BIS_fnc_selectRandom
Returns: 1, 2, or 3
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

selectRandom _this