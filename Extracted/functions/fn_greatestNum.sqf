
/************************************************************
	Find Greatest Number
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [number set]
Returns: number

Returns the highest number out of the passed set.

Example: [1,5,10] call BIS_fnc_greatestNum
	returns 10
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

selectMax _this 