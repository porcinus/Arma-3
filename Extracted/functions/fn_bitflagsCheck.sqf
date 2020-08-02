/*
	Author: 
		Killzone_Kid
		
	Description:
		Checks if one or more flags are set in the given flagset, represented with decimal or hexadecimal number
		(Hexadecimal number representation is simply auto-converted into decimal by the engine)
		To check which flags are present in given flagset use BIS_fnc_bitflagsToArray 
		
	Parameters:
		0: [NUMBER] - flagset
		1: [NUMBER] - one or more flags to check

	Return:
		[BOOLEAN] - 
			true: one or more flags are set in given flagset
			false: no given flag or flags are set in the given flagset  
			
	Examples:
		[2 + 4 + 8, 8] call BIS_fnc_bitflagsCheck // true
		[2 + 4 + 8, 2 + 32] call BIS_fnc_bitflagsCheck // true
		[2 + 4 + 8, 1] call BIS_fnc_bitflagsCheck // false
		[2 + 4 + 8, 1 + 32] call BIS_fnc_bitflagsCheck // false
		
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

[_flagset, _flags] call BIS_fnc_bitwiseAND > 0 