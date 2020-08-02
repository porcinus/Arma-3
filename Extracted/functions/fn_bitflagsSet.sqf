/*
	Author: 
		Killzone_Kid
		
	Description:
		Sets one or more flags in the given flagset, represented with decimal or hexadecimal number
		(Hexadecimal number representation is simply auto-converted into decimal by the engine)
		To check which flags are set in given flagset use BIS_fnc_bitflagsToArray 
		
	Parameters:
		0: [NUMBER] - flagset
		1: [NUMBER] - one or more flags to set

	Return:
		[NUMBER] - new flagset with given flag or flags set
		
	Examples:
		[0, 16] call BIS_fnc_bitflagsSet // 16
		[16, 2] call BIS_fnc_bitflagsSet // 18 (which is 2 + 16)
		[18, 2 + 8 + 16] call BIS_fnc_bitflagsSet // 26 (which is 2 + 8 + 16)
		
	Limitations:
		Due to various limitations of the Real Virtuality engine this function is 
		limited to work with unsigned 24 bit integers only. This means that the 
		supported range is 2^0...2^24 (1...16777216)
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_flagset", "_flags"];

[_flagset, _flags] call BIS_fnc_bitwiseOR