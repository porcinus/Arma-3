
/************************************************************
	Random Number
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [bound 1, bound 2]

Returns a random number between the two passed numbers.

Example: [1,3] call BIS_fnc_randomNum OR [3,1] call BIS_fnc_randomNum
Returns: a number between 1 (inclusive) and 3 (exclusve)
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_beg", "_end"];

linearConversion [0, 1, random 1, _beg, _end]