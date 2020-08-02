/*
	Author: 
		Killzone_Kid
		
	Description:
		Returns array with all bit flags which are set in the given flagset
		
	Parameter:
		0: [NUMBER] - flagset

	Return:
		[ARRAY] - array of set bit flags
		
	Examples:
		15 call BIS_fnc_bitflagsToArray // [1,2,4,8]
		2342 call BIS_fnc_bitflagsToArray // [2,4,32,256,2048]
		[2 + 4 + 8] call BIS_fnc_bitflagsToArray // [2,4,8]
		[2 + 2 + 2 + 4 + 8 + 8 + 8] call BIS_fnc_bitflagsToArray // [2,32]
		
	Limitations:
		Due to various limitations of the Real Virtuality engine this function is 
		intended to work with unsigned 24 bit integers only. This means that the 
		supported range is 2^0...2^24 (1...16777216)
*/

params [["_flags", 0], "_flag"];

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_flags,isEqualType,0)

private _result = [];

for "_i" from 0 to 23 do 
{
	_flag = 2 ^ _i;
	
	if (_flag > _flags) exitWith {};
	
	_result pushBack ([_flags, _flag] call BIS_fnc_bitwiseAND);
};

_result - [0] 