/*
	Author: 
		Killzone_Kid
		
	Description:
		Unsets one or more flags in the given flagset, represented with decimal or hexadecimal number
		(Hexadecimal number representation is simply auto-converted into decimal by the engine)
		To check which flags are unset in given flagset use BIS_fnc_bitflagsToArray 
		
	Parameters:
		0: [NUMBER] - flagset
		1: [NUMBER] - one or more flags to unset

	Return:
		[NUMBER] - new flagset with given flag or flags unset
		
	Examples:
		[2 + 4 + 8, 8] call BIS_fnc_bitflagsUnset // 6 (which is 2 + 4)
		[2 + 4 + 8, 2 + 8] call BIS_fnc_bitflagsUnset // 4
		[2 + 4 + 8, 1 + 8] call BIS_fnc_bitflagsUnset // 6 (which is 2 + 4)
		[2 + 4 + 8, 1 + 8 + 8 + 2 + 2] call BIS_fnc_bitflagsUnset // 10 (which is 2 + 8, since 1 + 8 + 8 + 2 + 2 is in fact 1 + 4 + 16)
		
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

[_flagset, _flags call BIS_fnc_bitwiseNOT] call BIS_fnc_bitwiseAND