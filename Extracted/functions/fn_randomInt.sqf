
/************************************************************
	Random Integer
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [bound 1, bound 2]

Returns a random integer between the two passed numbers (inclusive).

Example: [1,3] BIS_fnc_randomInt OR [3,1] call BIS_fnc_randomInt
Returns: 1, 2, or 3
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_beg", "_end"];

floor linearConversion [0, 1, random 1, _beg min _end, _end max _beg + 1]