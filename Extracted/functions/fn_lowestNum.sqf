
/************************************************************
	Find Lowest Number
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [number set]
Returns: number

Returns the lowest number out of the passed set.

Example: [1,5,10] call BIS_fnc_lowestNum
	returns 1
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

selectMin _this 