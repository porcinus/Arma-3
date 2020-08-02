/*
	Author: 
		Killzone_Kid
		
	Description:
		Flips one or more flags (set gets unset and vice versa) in the given flagset, represented with decimal or hexadecimal number
		(Hexadecimal number representation is simply auto-converted into decimal by the engine)
		To check which flags are flipped in given flagset use BIS_fnc_bitflagsToArray 
		
	Parameters:
		0: [NUMBER] - flagset
		1: [NUMBER] - one or more flags to flip

	Return:
		[NUMBER] - new flagset with given flag or flags flipped
		
	Examples:
		[1 + 16, 8] call BIS_fnc_bitflagsFlip // 25 (which is 1 + 8 + 16)
		[25, 8] call BIS_fnc_bitflagsFlip // 17 (which is 1 + 16)
		[2 + 4 + 8, 2 + 8] call BIS_fnc_bitflagsFlip // 4
		[4, 2 + 8] call BIS_fnc_bitflagsFlip // 14 (which is 2 + 4 + 8)
		
	Limitations:
		Due to various limitations of the Real Virtuality engine this function is 
		intended to work with unsigned 24 bit integers only. This means that the 
		supported range is 2^0...2^24 (1...16777216)
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_flagset", "_flags"];

[_flagset, _flags] call BIS_fnc_bitwiseXOR