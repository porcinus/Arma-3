
/************************************************************
	Find Nearest Number
	Author: Andrew Barron, optimised bu Killzone_Kid

Parameters: [[number set], target number]
Returns: number

Returns the number out of the set which is closest to the target number

Example: [[1,5,10], 4] call BIS_fnc_nearestNum
	returns 5
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr", "_num"];

/// --- validate specific input
paramsCheck(_arr,isEqualTypeAll,0)

_arr = _arr + [_num];
_arr sort true;

private _i = _arr find _num;
private _max = _arr deleteAt (_i + 1);
private _min = _arr deleteAt (_i - 1);

if (isNil "_min") exitWith {_max};
if (isNil "_max") exitWith {_min};

[_min, _max] select (_num - _min > _max - _num)